# Download Inter Fonts - Alternative Method
# Run with: powershell -ExecutionPolicy Bypass -File .\scripts\download_fonts_auto.ps1

Write-Host "Downloading Inter fonts automatically..." -ForegroundColor Green
Write-Host ""

$fontsDir = "assets/fonts"
if (-not (Test-Path $fontsDir)) {
    New-Item -ItemType Directory -Path $fontsDir | Out-Null
    Write-Host "Created $fontsDir directory" -ForegroundColor Yellow
}

# GitHub release URL for Inter font
$releaseUrl = "https://api.github.com/repos/rsms/inter/releases/latest"
Write-Host "Fetching latest Inter release information..." -ForegroundColor Cyan

try {
    # Get latest release info
    $release = Invoke-RestMethod -Uri $releaseUrl
    $zipAsset = $release.assets | Where-Object { $_.name -like "Inter-*.zip" } | Select-Object -First 1

    if ($zipAsset) {
        $downloadUrl = $zipAsset.browser_download_url
        $zipFile = "Inter.zip"

        Write-Host "Downloading Inter fonts from: $downloadUrl" -ForegroundColor Cyan
        Invoke-WebRequest -Uri $downloadUrl -OutFile $zipFile

        Write-Host "Extracting fonts..." -ForegroundColor Cyan
        Expand-Archive -Path $zipFile -DestinationPath "temp_fonts" -Force

        # Find and copy the required font files
        $fontFiles = @(
            @{Name = "Inter-Regular.ttf"; Weight = 400},
            @{Name = "Inter-Medium.ttf"; Weight = 500},
            @{Name = "Inter-SemiBold.ttf"; Weight = 600},
            @{Name = "Inter-Bold.ttf"; Weight = 700}
        )

        $copied = 0
        Get-ChildItem -Path "temp_fonts" -Recurse -Filter "*.ttf" | ForEach-Object {
            $fileName = $_.Name
            $targetFont = $fontFiles | Where-Object { $_.Name -eq $fileName }
            if ($targetFont) {
                Copy-Item $_.FullName -Destination "$fontsDir\$fileName" -Force
                Write-Host "  ✓ Copied $fileName" -ForegroundColor Green
                $copied++
            }
        }

        # Cleanup
        Remove-Item $zipFile -Force
        Remove-Item "temp_fonts" -Recurse -Force

        Write-Host ""
        if ($copied -eq 4) {
            Write-Host "✓ All Inter fonts downloaded successfully!" -ForegroundColor Green
            Write-Host ""
            Write-Host "Next steps:" -ForegroundColor Cyan
            Write-Host "1. Run: flutter clean" -ForegroundColor White
            Write-Host "2. Run: flutter pub get" -ForegroundColor White
            Write-Host "3. Start building your app!" -ForegroundColor White
        } else {
            Write-Host "⚠ Only $copied of 4 fonts were found. Manual download may be needed." -ForegroundColor Yellow
        }
    } else {
        throw "Could not find Inter font zip in release assets"
    }
} catch {
    Write-Host ""
    Write-Host "⚠ Automatic download failed: $($_.Exception.Message)" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Please download manually:" -ForegroundColor Cyan
    Write-Host "1. Visit: https://fonts.google.com/specimen/Inter" -ForegroundColor White
    Write-Host "2. Click 'Download family'" -ForegroundColor White
    Write-Host "3. Extract and copy these files to assets/fonts/:" -ForegroundColor White
    Write-Host "   - Inter-Regular.ttf" -ForegroundColor White
    Write-Host "   - Inter-Medium.ttf" -ForegroundColor White
    Write-Host "   - Inter-SemiBold.ttf" -ForegroundColor White
    Write-Host "   - Inter-Bold.ttf" -ForegroundColor White
}

