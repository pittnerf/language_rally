<#
.SYNOPSIS
    Translates a Flutter ARB localisation file into a target language using OpenAI,
    with both English (app_en.arb) AND Hungarian (app_hu.arb) as parallel sources.

.DESCRIPTION
    Reads  lib/l10n/app_en.arb  (English - authoritative keys/placeholders)
    and    lib/l10n/app_hu.arb  (Hungarian - human-reviewed reference)
    and sends both values for every string in batches to the OpenAI Chat API.
    Metadata (@key) entries are preserved verbatim from app_en.arb.
    Outputs lib/l10n/app_<TargetLocale>.arb.

    Compatible with Windows PowerShell 5.1 and PowerShell 7+.
    On PS 5.1, ConvertTo-Json escapes non-ASCII as \uXXXX - the script
    post-processes the output to restore readable Unicode characters.

.PARAMETER TargetLocale
    BCP-47 locale code: de, es, fr, pt, zh, ja, ko, it, ru, ar, ro ...

.PARAMETER TargetLangName
    Human-readable language name for the AI prompt, e.g. "German", "Spanish".

.PARAMETER OpenAiApiKey
    Your OpenAI API key (sk-...).

.PARAMETER Model
    OpenAI model. Default: gpt-4o.
    Alternatives: gpt-4.1, gpt-4o-mini (faster/cheaper, slightly lower quality).

.PARAMETER BatchSize
    Strings per API call. Default 20. Reduce to 10-15 for Asian/RTL languages.

.PARAMETER MaxRetries
    Retries per batch on failure. Default 3.

.PARAMETER L10nDir
    Path to the l10n directory. Defaults to <project-root>/lib/l10n.

.EXAMPLE
    .\scripts\translate_arb.ps1 -TargetLocale de -TargetLangName German -OpenAiApiKey "sk-..."

.EXAMPLE
    .\scripts\translate_arb.ps1 -TargetLocale zh -TargetLangName "Chinese (Simplified)" `
        -OpenAiApiKey "sk-..." -BatchSize 15
#>

param(
    [Parameter(Mandatory = $true)]
    [string]$TargetLocale,

    [Parameter(Mandatory = $true)]
    [string]$TargetLangName,

    [Parameter(Mandatory = $true)]
    [string]$OpenAiApiKey,

    [string]$Model      = "gpt-4o",
    [int]   $BatchSize  = 20,
    [int]   $MaxRetries = 3,

    # Leave empty to auto-detect from script location
    [string]$L10nDir = ""
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# Resolve L10nDir: default is <script-folder>/../lib/l10n
if (-not $L10nDir) {
    $L10nDir = Join-Path $PSScriptRoot "..\lib\l10n"
}
$L10nDir = [System.IO.Path]::GetFullPath($L10nDir)

# ---------------------------------------------------------------------------
# Banner
# ---------------------------------------------------------------------------
Write-Host ""
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "   Language Rally -- ARB Auto-Translator" -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "  Target  : $TargetLangName ($TargetLocale)"
Write-Host "  Model   : $Model"
Write-Host "  Batch   : $BatchSize strings/call"
Write-Host ""

# ---------------------------------------------------------------------------
# Helper: Recursively convert PSCustomObject -> ordered hashtable
# (PS 5.1 does not support ConvertFrom-Json -AsHashtable)
# ---------------------------------------------------------------------------
function ConvertPSObjectToOrderedHashtable {
    param([object]$Obj)
    if ($null -eq $Obj) { return [ordered]@{} }
    if ($Obj -is [array]) {
        return @($Obj | ForEach-Object { ConvertPSObjectToOrderedHashtable $_ })
    }
    if ($Obj -isnot [System.Management.Automation.PSCustomObject]) {
        return $Obj   # scalar: string, number, bool
    }
    $ht = [ordered]@{}
    foreach ($prop in $Obj.PSObject.Properties) {
        $ht[$prop.Name] = ConvertPSObjectToOrderedHashtable $prop.Value
    }
    return $ht
}

# ---------------------------------------------------------------------------
# Helper: Unescape \uXXXX sequences so output ARB is human-readable.
# PS 5.1 ConvertTo-Json escapes all non-ASCII chars this way.
# ---------------------------------------------------------------------------
function Unescape-UnicodeJson {
    param([string]$Json)
    return [System.Text.RegularExpressions.Regex]::Replace(
        $Json,
        '\\u([0-9a-fA-F]{4})',
        {
            param($m)
            [char][System.Convert]::ToUInt16($m.Groups[1].Value, 16)
        }
    )
}

# ---------------------------------------------------------------------------
# Helper: Call OpenAI Chat Completions with json_object response format
# ---------------------------------------------------------------------------
function Invoke-OpenAIChat {
    param(
        [string]$SystemMsg,
        [string]$UserMsg
    )
    $headers = @{
        "Authorization" = "Bearer $OpenAiApiKey"
        "Content-Type"  = "application/json"
    }
    $bodyObj = [ordered]@{
        model           = $Model
        messages        = @(
            [ordered]@{ role = "system"; content = $SystemMsg },
            [ordered]@{ role = "user";   content = $UserMsg   }
        )
        temperature     = 0.15
        response_format = [ordered]@{ type = "json_object" }
    }
    $body = $bodyObj | ConvertTo-Json -Depth 10

    for ($attempt = 1; $attempt -le $MaxRetries; $attempt++) {
        try {
            $resp = Invoke-RestMethod `
                -Uri         "https://api.openai.com/v1/chat/completions" `
                -Method      Post `
                -Headers     $headers `
                -Body        $body `
                -ContentType "application/json"
            return $resp.choices[0].message.content
        }
        catch {
            Write-Warning "  Attempt $attempt/$MaxRetries failed: $($_.Exception.Message)"
            if ($attempt -lt $MaxRetries) {
                $wait = 5 * $attempt
                Write-Host "  Retrying in ${wait}s..."
                Start-Sleep -Seconds $wait
            }
        }
    }
    throw "OpenAI API failed after $MaxRetries attempts."
}

# ---------------------------------------------------------------------------
# Keys whose English value must be kept unchanged in ALL locales
# ---------------------------------------------------------------------------
$KeepAsIs = [System.Collections.Generic.HashSet[string]]::new()
@(
    "appTitle",               # brand name - never translate
    "helloWorld",             # developer placeholder
    "aboutWebsiteUrl",        # URL
    "aboutSupportEmailAddress"
) | ForEach-Object { [void]$KeepAsIs.Add($_) }

# ---------------------------------------------------------------------------
# System prompt sent with every batch
# ---------------------------------------------------------------------------
$SystemPrompt = @"
You are a senior localisation engineer for a mobile language-learning app called "Language Rally".

Your task: translate an ARB (Flutter l10n) UI string batch into $TargetLangName.

INPUT FORMAT
Each entry in the JSON object has:
  "key": { "en": "<English source>", "hu": "<Human-reviewed Hungarian translation>" }

OUTPUT FORMAT
Return a flat JSON object:
  "key": "<$TargetLangName translation>"
  (each key maps to a plain string - not a nested object)

TRANSLATION RULES
1. PLACEHOLDER PRESERVATION - every {variable} must appear in the output EXACTLY as in
   the source, including braces (e.g., {count}, {name}, {language}, {from}, {to}).
2. ICU PLURAL SYNTAX - strings like "{count, plural, =1{one item} other{{count} items}}"
   must keep the exact ICU skeleton; translate ONLY the human-readable text inside {}.
3. APP NAME - never translate "Language Rally".
4. TECHNICAL TERMS - keep as-is: OpenAI, DeepL, Whisper, GPT-4o, Firebase, RTAudio,
   RevenueCat, A1/A2/B1/B2/C1/C2, WAV, JSON, ZIP, URL, API.
5. URLS AND EMAILS - reproduce verbatim, even when embedded inside longer strings.
6. TONE - natural, friendly, professional $TargetLangName suitable for a modern mobile app.
   Use the Hungarian reference to calibrate meaning and register.
7. OUTPUT - return ONLY the JSON object. No markdown code fences, no explanations.
"@

# ---------------------------------------------------------------------------
# Load source ARB files
# ---------------------------------------------------------------------------
$enPath  = Join-Path $L10nDir "app_en.arb"
$huPath  = Join-Path $L10nDir "app_hu.arb"
$outPath = Join-Path $L10nDir "app_${TargetLocale}.arb"

if (-not (Test-Path $enPath)) { throw "File not found: $enPath" }
if (-not (Test-Path $huPath)) { throw "File not found: $huPath" }

Write-Host "Loading app_en.arb..."
$enRaw  = Get-Content $enPath -Raw -Encoding UTF8
$enData = ConvertPSObjectToOrderedHashtable ($enRaw | ConvertFrom-Json)

Write-Host "Loading app_hu.arb..."
$huRaw  = Get-Content $huPath -Raw -Encoding UTF8
$huData = ConvertPSObjectToOrderedHashtable ($huRaw | ConvertFrom-Json)

# ---------------------------------------------------------------------------
# Separate translatable keys from @metadata keys (preserve original order)
# ---------------------------------------------------------------------------
$allKeys          = [System.Collections.Generic.List[string]]::new()
$translatableList = [System.Collections.Generic.List[string]]::new()

foreach ($key in $enData.Keys) {
    $allKeys.Add($key)
    if (-not $key.StartsWith("@")) {
        $translatableList.Add($key)
    }
}

$metaCount = $allKeys.Count - $translatableList.Count
Write-Host "Translatable strings : $($translatableList.Count)"
Write-Host "Metadata (@) entries : $metaCount"
Write-Host ""

# ---------------------------------------------------------------------------
# Translation pass
# ---------------------------------------------------------------------------
$translated = [ordered]@{}

# Pre-fill keep-as-is keys directly from English
foreach ($key in $translatableList) {
    if ($KeepAsIs.Contains($key)) {
        $translated[$key] = $enData[$key]
        Write-Host "  [keep-as-is] $key" -ForegroundColor DarkGray
    }
}

# Build list of keys that actually need AI translation
$needsTranslation = @($translatableList | Where-Object { -not $KeepAsIs.Contains($_) })
$total            = $needsTranslation.Count
$totalBatches     = [Math]::Ceiling($total / $BatchSize)
$batchNum         = 0
$errorCount       = 0

Write-Host ""
Write-Host "Translating $total strings in $totalBatches batch(es)..." -ForegroundColor Yellow
Write-Host ""

for ($i = 0; $i -lt $total; $i += $BatchSize) {
    $batchNum++
    $end   = [Math]::Min($i + $BatchSize - 1, $total - 1)
    $batch = $needsTranslation[$i..$end]
    $from  = $i + 1
    $to    = $i + $batch.Count
    $pct   = [Math]::Round($i * 100.0 / $total)

    Write-Host "  Batch $batchNum/$totalBatches  [$pct%]  keys $from-$to ..." -NoNewline

    # Build batch input: each key -> { en: "...", hu: "..." }
    $batchInput = [ordered]@{}
    foreach ($key in $batch) {
        $enVal = if ($enData.Contains($key)) { [string]$enData[$key] } else { "" }
        $huVal = if ($huData.Contains($key)) { [string]$huData[$key] } else { "" }
        $batchInput[$key] = [ordered]@{ en = $enVal; hu = $huVal }
    }

    $userPrompt = "Translate to ${TargetLangName}:`n" + ($batchInput | ConvertTo-Json -Depth 5)

    try {
        $rawResp     = Invoke-OpenAIChat -SystemMsg $SystemPrompt -UserMsg $userPrompt
        $batchResult = ConvertPSObjectToOrderedHashtable ($rawResp | ConvertFrom-Json)

        foreach ($key in $batchResult.Keys) {
            # Safety guard: only accept keys from this batch
            if ($needsTranslation -contains $key) {
                $translated[$key] = [string]$batchResult[$key]
            }
        }
        Write-Host " OK" -ForegroundColor Green
    }
    catch {
        $errorCount++
        Write-Host " FAILED - using English fallback" -ForegroundColor Red
        Write-Warning "  Error: $($_.Exception.Message)"
        foreach ($key in $batch) {
            if (-not $translated.Contains($key)) {
                $translated[$key] = if ($enData.Contains($key)) { [string]$enData[$key] } else { "" }
            }
        }
    }

    # Polite rate-limit buffer between batches (skip after last batch)
    if ($i + $BatchSize -lt $total) { Start-Sleep -Milliseconds 600 }
}

# ---------------------------------------------------------------------------
# Rebuild final ARB in original EN key order
# ---------------------------------------------------------------------------
Write-Host ""
Write-Host "Building output ARB..."

$finalData = [ordered]@{}
foreach ($key in $allKeys) {
    if ($key.StartsWith("@")) {
        # Metadata: copy verbatim from English (defines placeholders/descriptions)
        $finalData[$key] = $enData[$key]
    }
    elseif ($translated.Contains($key)) {
        $finalData[$key] = $translated[$key]
    }
    else {
        Write-Warning "  Key '$key' missing from translation - using English fallback"
        $finalData[$key] = if ($enData.Contains($key)) { $enData[$key] } else { "" }
    }
}

# ---------------------------------------------------------------------------
# Serialise and write UTF-8 without BOM
# ---------------------------------------------------------------------------
$jsonOut = $finalData | ConvertTo-Json -Depth 10

# PS 5.1 serialises non-ASCII as \uXXXX - unescape for human readability
$jsonOut = Unescape-UnicodeJson $jsonOut

$utf8NoBom = [System.Text.UTF8Encoding]::new($false)
[System.IO.File]::WriteAllText($outPath, $jsonOut, $utf8NoBom)

# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------
Write-Host ""
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "  Output  : $outPath"
Write-Host "  Total   : $($finalData.Count) entries ($($translated.Count) translated)"
if ($errorCount -gt 0) {
    Write-Host "  Batches with errors (fell back to English): $errorCount" -ForegroundColor Yellow
}
else {
    Write-Host "  All batches succeeded!" -ForegroundColor Green
}
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next steps:"
Write-Host "  1. Review app_${TargetLocale}.arb and correct any critical UI strings"
Write-Host "  2. Run: flutter gen-l10n    (regenerates Dart localisation files)"
Write-Host "  3. Test the app in $TargetLangName on a simulator or device"
Write-Host ""







