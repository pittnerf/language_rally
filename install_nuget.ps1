# Download and Install NuGet for Flutter TTS Windows Build
# Run this script from the project directory

Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "  NuGet Installation for Flutter TTS (Windows)" -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host ""

$projectDir = Get-Location
$nugetUrl = "https://dist.nuget.org/win-x86-commandline/latest/nuget.exe"
$nugetPath = Join-Path $projectDir "nuget.exe"

Write-Host "Downloading NuGet.exe..." -ForegroundColor Yellow
Write-Host "  From: $nugetUrl" -ForegroundColor Gray
Write-Host "  To: $nugetPath" -ForegroundColor Gray
Write-Host ""

try {
    # Download NuGet
    $ProgressPreference = 'SilentlyContinue'
    Invoke-WebRequest -Uri $nugetUrl -OutFile $nugetPath -UseBasicParsing

    if (Test-Path $nugetPath) {
        Write-Host "SUCCESS: NuGet.exe downloaded!" -ForegroundColor Green
        Write-Host "  Location: $nugetPath" -ForegroundColor Gray
        Write-Host ""

        # Verify it works
        Write-Host "Verifying NuGet installation..." -ForegroundColor Yellow
        $version = & $nugetPath help | Select-Object -First 1
        Write-Host "  $version" -ForegroundColor Gray
        Write-Host ""

        # Add to PATH for current session
        $env:PATH = "$projectDir;$env:PATH"
        Write-Host "Added to PATH for this PowerShell session" -ForegroundColor Green
        Write-Host ""

        Write-Host "==================================================" -ForegroundColor Cyan
        Write-Host "  Next Steps:" -ForegroundColor Cyan
        Write-Host "==================================================" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "1. Run: flutter clean" -ForegroundColor Yellow
        Write-Host "2. Run: flutter pub get" -ForegroundColor Yellow
        Write-Host "3. Run: flutter build windows" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "Note: NuGet is in your project directory." -ForegroundColor Gray
        Write-Host "      For permanent installation, add to your system PATH." -ForegroundColor Gray
        Write-Host ""

    } else {
        Write-Host "ERROR: Failed to download NuGet.exe" -ForegroundColor Red
        exit 1
    }
} catch {
    Write-Host "ERROR: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

