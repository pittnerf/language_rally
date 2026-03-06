# Windows Debug Build AOT Error Fix

## Problem
When launching the app from IDE in debug mode on Windows, you may encounter:
```
[ERROR:flutter/shell/platform/windows/flutter_project_bundle.cc(73)] Can't load AOT data from "...\app.so"; no such file.
[ERROR:flutter/shell/platform/windows/flutter_windows_engine.cc(282)] Unable to start engine without AOT data.
```

## Root Cause
The Flutter engine is trying to load AOT (Ahead-Of-Time) compiled data, which is only present in **release** or **profile** builds. Debug builds use JIT (Just-In-Time) compilation and don't have `app.so` files.

This typically happens when:
1. IDE caches are corrupted or stale
2. Mixed build artifacts from previous release builds
3. IDE run configuration is incorrectly set to profile/release mode

## Solution

### Option 1: Clean Build (Recommended)
```powershell
cd C:\FEJLESZTES\Java\language_rally

# Remove all build artifacts and caches
Remove-Item -Recurse -Force .dart_tool -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force build -ErrorAction SilentlyContinue
Remove-Item -Force .flutter-plugins -ErrorAction SilentlyContinue
Remove-Item -Force .flutter-plugins-dependencies -ErrorAction SilentlyContinue

# Regenerate dependencies
flutter pub get

# Build debug version
flutter build windows --debug
```

### Option 2: Flutter Clean
```powershell
cd C:\FEJLESZTES\Java\language_rally
flutter clean
flutter pub get
flutter build windows --debug
```

### Option 3: IDE Configuration Check (JetBrains)

1. **Check Run Configuration:**
   - Open Run → Edit Configurations
   - Ensure "Debug" mode is selected (not "Profile" or "Release")
   - Build flavor should be empty or "debug"

2. **Invalidate IDE Caches:**
   - File → Invalidate Caches / Restart
   - Choose "Invalidate and Restart"

3. **Re-sync Project:**
   - Tools → Flutter → Flutter Pub Get
   - Tools → Flutter → Flutter Clean

### Option 4: Run from Command Line
If IDE issues persist, run directly from command line:

```powershell
cd C:\FEJLESZTES\Java\language_rally

# Method 1: Flutter run
flutter run -d windows --debug

# Method 2: Direct execution
flutter build windows --debug
.\build\windows\x64\runner\Debug\language_rally.exe
```

## Verification

After applying the fix:

1. **Check build output location:**
   ```powershell
   Get-ChildItem ".\build\windows\x64\runner\Debug"
   ```
   You should see `language_rally.exe`

2. **Check data folder:**
   ```powershell
   Get-ChildItem ".\build\windows\x64\runner\Debug\data"
   ```
   Should contain:
   - `flutter_assets/` (folder)
   - `icudtl.dat` (file)
   - **NO `app.so`** (this is correct for debug builds!)

3. **Run the app:**
   - From IDE: Debug button should work
   - From terminal: `flutter run -d windows` should work
   - Direct: `.\build\windows\x64\runner\Debug\language_rally.exe` should work

## Understanding Build Modes

| Mode | Compilation | app.so | Use Case |
|------|------------|---------|----------|
| **Debug** | JIT | ❌ No | Development, hot reload |
| **Profile** | AOT | ✅ Yes | Performance testing |
| **Release** | AOT | ✅ Yes | Production deployment |

### Debug Mode (JIT)
- Code is compiled just-in-time
- Supports hot reload
- Includes debug symbols
- Slower performance
- **No app.so file**

### Release/Profile Mode (AOT)
- Code is pre-compiled
- Faster performance
- No hot reload
- **Requires app.so file**

## Common Mistakes

1. ❌ **Building release, then trying to debug:**
   ```powershell
   flutter build windows --release
   flutter run -d windows --debug  # This will fail!
   ```
   **Fix:** Always `flutter clean` when switching between modes

2. ❌ **Mixed build artifacts:**
   - Building release in terminal
   - Running debug from IDE
   - **Fix:** Clean build directory

3. ❌ **IDE caching old configuration:**
   - IDE remembers old build settings
   - **Fix:** Invalidate caches and restart

## Prevention

To avoid this issue in the future:

1. **Always clean when switching modes:**
   ```powershell
   flutter clean && flutter pub get
   ```

2. **Use separate build commands:**
   - Debug: `flutter build windows --debug`
   - Release: `flutter build windows --release`
   - Never mix them without cleaning

3. **IDE Best Practices:**
   - Create separate run configurations for debug/release
   - Use "Flutter Clean" before switching configurations
   - Verify mode in run configuration before launching

## Still Not Working?

If you still see the error after trying all solutions:

1. **Check Flutter installation:**
   ```powershell
   flutter doctor -v
   ```
   Ensure no issues with Flutter or Visual Studio

2. **Check Flutter version:**
   ```powershell
   flutter --version
   ```
   Current project tested with Flutter 3.41.2

3. **Rebuild Flutter tools:**
   ```powershell
   flutter channel stable
   flutter upgrade
   flutter doctor
   ```

4. **Check Visual Studio:**
   - Ensure Visual Studio 2022 with C++ Desktop Development workload
   - Windows 10 SDK should be installed

5. **Try profile mode as test:**
   ```powershell
   flutter build windows --profile
   ```
   If profile works but debug doesn't, there may be an environment issue

## Related Issues

This error is tracked in Flutter GitHub issues:
- Similar to build mode mismatch issues
- Related to IDE caching problems
- Windows-specific AOT/JIT confusion

## Quick Fix Summary

**Most Common Fix (Works 90% of the time):**
```powershell
cd C:\FEJLESZTES\Java\language_rally
flutter clean
flutter pub get
flutter run -d windows
```

If that doesn't work, restart your IDE and try again.

