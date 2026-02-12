@echo off
echo Downloading NuGet.exe...
curl -L -o nuget.exe https://dist.nuget.org/win-x86-commandline/latest/nuget.exe
if exist nuget.exe (
    echo SUCCESS: nuget.exe downloaded to %CD%
    echo.
    echo Adding to PATH for this session...
    set PATH=%CD%;%PATH%
    echo.
    echo Running: nuget help
    nuget.exe help
    echo.
    echo Now you can run: flutter clean and flutter build windows
) else (
    echo FAILED to download nuget.exe
    exit /b 1
)

