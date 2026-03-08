# Android Lifecycle Issue Fix

## Problem
When the app was restored from Android's background memory (instead of a fresh start), it would show only the Flutter icon and not display the home page properly. This happened because Android was restoring the app to a previous state without properly reinitializing providers and settings.

## Root Cause
1. **Launch Mode Issue**: The `singleTop` launch mode was allowing Android to restore the app to whatever navigation state it was in when backgrounded
2. **Stale Providers**: Critical providers (especially `appSettingsProvider` for API keys) were not being refreshed when the app resumed from background
3. **Navigation State**: The app wasn't guaranteed to return to the home page when launched from the app icon

## Changes Made

### 1. AndroidManifest.xml
**File**: `android/app/src/main/AndroidManifest.xml`

Changed `launchMode` from `singleTop` to `singleTask`:
```xml
android:launchMode="singleTask"
```

**Effect**: When the app icon is clicked, Android will:
- Clear the navigation stack above the main activity
- Always return to the root/home screen
- Prevent restoration to arbitrary previous screens

### 2. main.dart - Enhanced Lifecycle Management
**File**: `lib/main.dart`

#### Added Import
```dart
import 'presentation/providers/app_settings_provider.dart';
```

#### Enhanced App Resume Handler
```dart
case AppLifecycleState.resumed:
  debugPrint('App resumed - checking database connection and refreshing providers');
  _checkAndReinitialize();
  // Force refresh providers to ensure fresh data
  if (mounted) {
    // Invalidate providers to force reload - especially important for settings/API keys
    ref.invalidate(appSettingsProvider);
    ref.invalidate(localeProvider);
    ref.invalidate(themeProvider);
  }
  break;
```

**Effect**: When the app resumes from background, it:
- Checks and reinitializes the database connection
- Forces all critical providers to reload their data
- Ensures API keys and settings are properly loaded
- Refreshes theme and locale settings

#### Added Explicit Route Configuration
```dart
initialRoute: '/',
routes: {
  '/': (context) => const HomePage(),
},
```

**Note**: The `home` property was removed to avoid conflict with the routes table. In Flutter, you cannot specify both `home` and a route for `'/'` as they are redundant.

**Effect**: Ensures the app always starts at home page as the initial route when restored.

## Testing Recommendations

1. **Background/Foreground Test**:
   - Open app, navigate to settings
   - Press home button (don't close app)
   - Wait several hours or open many other apps
   - Tap app icon again
   - **Expected**: Should show home page with all data loaded

2. **API Key Test**:
   - Set API keys in settings
   - Background the app
   - Return to app via icon
   - Go to pronunciation practice
   - **Expected**: API keys should be immediately available

3. **Day-Old App Test**:
   - Open app
   - Background it
   - Wait until next day
   - Tap app icon
   - **Expected**: Home page shown, not Flutter icon

## Additional Notes

- The `singleTask` launch mode is commonly used for apps with a main hub (like home pages) that should always be accessible
- Provider invalidation forces a complete reload, ensuring no stale data
- The lifecycle observer pattern ensures the app responds to Android's memory management
- Database connection validation prevents issues with stale database handles

## Related Issues
This fix also resolves the issue where:
- API keys appeared empty on first open of settings page
- Providers had stale data after app restoration
- Navigation stack was inconsistent after backgrounding

