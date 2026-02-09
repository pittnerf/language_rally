# Download Inter Font Files
# Run this script from the project root directory

Write-Host "Downloading Inter font files..." -ForegroundColor Green

# Create fonts directory if it doesn't exist
$fontsDir = "assets/fonts"
if (-not (Test-Path $fontsDir)) {
    New-Item -ItemType Directory -Path $fontsDir | Out-Null
    Write-Host "Created $fontsDir directory" -ForegroundColor Yellow
}

# Google Fonts API URL for Inter
$fontFamily = "Inter"
$fontWeights = @(400, 500, 600, 700)
$fontNames = @{
    400 = "Inter-Regular.ttf"
    500 = "Inter-Medium.ttf"
    600 = "Inter-SemiBold.ttf"
    700 = "Inter-Bold.ttf"
}

Write-Host ""
Write-Host "Please download Inter font manually:" -ForegroundColor Cyan
Write-Host "1. Visit: https://fonts.google.com/specimen/Inter" -ForegroundColor White
Write-Host "2. Click 'Download family'" -ForegroundColor White
Write-Host "3. Extract the zip file" -ForegroundColor White
Write-Host "4. Copy these files to assets/fonts/:" -ForegroundColor White
Write-Host "   - Inter-Regular.ttf (static/Inter-Regular.ttf)" -ForegroundColor White
Write-Host "   - Inter-Medium.ttf (static/Inter-Medium.ttf)" -ForegroundColor White
Write-Host "   - Inter-SemiBold.ttf (static/Inter-SemiBold.ttf)" -ForegroundColor White
Write-Host "   - Inter-Bold.ttf (static/Inter-Bold.ttf)" -ForegroundColor White
Write-Host ""

# Alternative: Direct download links (may change)
Write-Host "Alternative: Download from GitHub:" -ForegroundColor Cyan
Write-Host "https://github.com/rsms/inter/releases" -ForegroundColor White
Write-Host ""

Write-Host "After downloading, run: flutter clean && flutter pub get" -ForegroundColor Green

