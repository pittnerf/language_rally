# pull_envelope_debug.ps1
# Streams envelope_debug.png directly from the app private cache to your Desktop.
# No sdcard copy needed -- works on Android 11+ (scoped storage).
#
# Usage:  .\pull_envelope_debug.ps1
#    or   .\pull_envelope_debug.ps1 -Device RFCTA0NHAVW
#    or   .\pull_envelope_debug.ps1 -Device emulator-5554
param(
    [string]$Device  = '',
    [string]$Package = 'com.example.language_rally',
    [string]$Dest    = "$env:USERPROFILE\Desktop\envelope_debug.png"
)
$adb = "$env:LOCALAPPDATA\Android\Sdk\platform-tools\adb.exe"
if (-not (Test-Path $adb)) {
    Write-Error "adb.exe not found at: $adb"; exit 1
}
if (-not $Device) {
    $deviceLines = & $adb devices | Select-Object -Skip 1 | Where-Object { $_ -match '\tdevice$' }
    if (-not $deviceLines) { Write-Error "No ADB device found."; exit 1 }
    $Device = ($deviceLines -split '\t')[0].Trim()
    Write-Host "Auto-detected device: $Device"
}
$remoteSrc = "/data/user/0/$Package/cache/envelope_debug.png"
Write-Host "Device  : $Device"
Write-Host "Package : $Package"
Write-Host "Source  : $remoteSrc"
Write-Host "Dest    : $Dest"
Write-Host ""
$check = & $adb -s $Device shell run-as $Package ls "$remoteSrc" 2>&1
if ($check -notmatch 'envelope_debug') {
    Write-Error "File not found on device. Has the app run a pronunciation comparison?`n$check"
    exit 1
}
Write-Host "Streaming binary from device..."
$proc = New-Object System.Diagnostics.Process
$proc.StartInfo.FileName               = $adb
$proc.StartInfo.Arguments              = "-s $Device exec-out run-as $Package cat `"$remoteSrc`""
$proc.StartInfo.UseShellExecute        = $false
$proc.StartInfo.RedirectStandardOutput = $true
$proc.Start() | Out-Null
$inStream  = $proc.StandardOutput.BaseStream
$outStream = [System.IO.File]::OpenWrite($Dest)
$inStream.CopyTo($outStream)
$outStream.Close()
$proc.WaitForExit()
$size = (Get-Item $Dest).Length
if ($size -lt 100) { Write-Error "File too small ($size bytes) -- transfer may have failed."; exit 1 }
Write-Host ""
Write-Host "Done! $size bytes saved to $Dest" -ForegroundColor Green
Start-Process $Dest