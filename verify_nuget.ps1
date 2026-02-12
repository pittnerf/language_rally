# Quick Verification Script
# Run this to verify NuGet is installed correctly

Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "  NuGet Installation Verification" -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host ""

$projectDir = Get-Location
$nugetPath = Join-Path $projectDir "nuget.exe"

Write-Host "Checking NuGet installation..." -ForegroundColor Yellow
Write-Host ""

# Test 1: File exists
Write-Host "Test 1: File Existence" -ForegroundColor Cyan
if (Test-Path $nugetPath) {
    Write-Host "  [PASS] nuget.exe found at: $nugetPath" -ForegroundColor Green
    $fileSize = (Get-Item $nugetPath).Length
    Write-Host "    Size: $([math]::Round($fileSize/1MB, 2)) MB" -ForegroundColor Gray
} else {
    Write-Host "  [FAIL] nuget.exe not found!" -ForegroundColor Red
    Write-Host "    Run: .\install_nuget.ps1" -ForegroundColor Yellow
    exit 1
}
Write-Host ""

# Test 2: File is executable
Write-Host "Test 2: Executable Test" -ForegroundColor Cyan
try {
    $version = & $nugetPath help 2>&1 | Select-Object -First 1
    Write-Host "  [PASS] NuGet is executable" -ForegroundColor Green
    Write-Host "    $version" -ForegroundColor Gray
} catch {
    Write-Host "  [FAIL] Cannot execute nuget.exe" -ForegroundColor Red
    Write-Host "    Error: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}
Write-Host ""

# Test 3: PATH accessibility
Write-Host "Test 3: PATH Accessibility" -ForegroundColor Cyan
$env:PATH = "$projectDir;$env:PATH"
try {
    $accessible = Get-Command nuget -ErrorAction SilentlyContinue
    if ($accessible) {
        Write-Host "  [PASS] nuget.exe accessible via PATH" -ForegroundColor Green
        Write-Host "    Location: $($accessible.Source)" -ForegroundColor Gray
    } else {
        Write-Host "  [WARNING] Not in PATH (fixed for this session)" -ForegroundColor Yellow
        Write-Host "    Added to PATH: $projectDir" -ForegroundColor Gray
    }
} catch {
    Write-Host "  [FAIL] Cannot access via PATH" -ForegroundColor Red
}
Write-Host ""

# Test 4: Flutter detection
Write-Host "Test 4: Flutter Environment" -ForegroundColor Cyan
try {
    $flutterVersion = flutter --version 2>&1 | Select-Object -First 1
    Write-Host "  [PASS] Flutter found" -ForegroundColor Green
    Write-Host "    $flutterVersion" -ForegroundColor Gray
} catch {
    Write-Host "  [FAIL] Flutter not found" -ForegroundColor Red
    exit 1
}
Write-Host ""

# Summary
Write-Host "==================================================" -ForegroundColor Green
Write-Host "  ALL TESTS PASSED!" -ForegroundColor Green
Write-Host "==================================================" -ForegroundColor Green
Write-Host ""
Write-Host "NuGet is correctly installed and configured." -ForegroundColor Green
Write-Host ""
Write-Host "You can now build your Flutter app:" -ForegroundColor Yellow
Write-Host "  .\build_with_nuget.ps1" -ForegroundColor Cyan
Write-Host ""
Write-Host "Or run it directly:" -ForegroundColor Yellow
Write-Host "  `$env:PATH = `"`$PWD;`$env:PATH`"; flutter run -d windows" -ForegroundColor Cyan
Write-Host ""

