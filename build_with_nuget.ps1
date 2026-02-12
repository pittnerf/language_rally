# Flutter Build Script with NuGet Support
# This script ensures nuget.exe is in PATH before building

Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "  Flutter Windows Build with NuGet" -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host ""

$projectDir = Get-Location
$nugetPath = Join-Path $projectDir "nuget.exe"

# Check if nuget.exe exists
if (-not (Test-Path $nugetPath)) {
    Write-Host "ERROR: nuget.exe not found in project directory!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Please run: .\install_nuget.ps1 first" -ForegroundColor Yellow
    Write-Host ""
    exit 1
}

Write-Host "✓ Found nuget.exe" -ForegroundColor Green
Write-Host ""

# Add nuget.exe to PATH for this session
$env:PATH = "$projectDir;$env:PATH"
Write-Host "✓ Added nuget.exe to PATH" -ForegroundColor Green
Write-Host ""

# Determine build type
$buildType = $args[0]
if (-not $buildType) {
    $buildType = "windows"
}

Write-Host "Building Flutter app..." -ForegroundColor Yellow
Write-Host "  Command: flutter build $buildType" -ForegroundColor Gray
Write-Host ""

# Build the app
& flutter build $buildType

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "==================================================" -ForegroundColor Green
    Write-Host "  BUILD SUCCESSFUL!" -ForegroundColor Green
    Write-Host "==================================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "Run the app with:" -ForegroundColor Yellow
    Write-Host "  flutter run -d windows" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Or find the executable in:" -ForegroundColor Yellow
    Write-Host "  build\windows\x64\runner\Debug\" -ForegroundColor Cyan
    Write-Host ""
} else {
    Write-Host ""
    Write-Host "==================================================" -ForegroundColor Red
    Write-Host "  BUILD FAILED" -ForegroundColor Red
    Write-Host "==================================================" -ForegroundColor Red
    Write-Host ""
    Write-Host "Try running:" -ForegroundColor Yellow
    Write-Host "  flutter clean" -ForegroundColor Cyan
    Write-Host "  flutter pub get" -ForegroundColor Cyan
    Write-Host "  .\build_with_nuget.ps1" -ForegroundColor Cyan
    Write-Host ""
    exit $LASTEXITCODE
}

