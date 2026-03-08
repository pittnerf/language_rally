# Pronunciation Practice Page - OpenAI API Key Detection Fix

## Problem

When the `PronunciationPracticePage` was opened for the first time after app launch, the OpenAI API key was not being detected, even though it was stored in the settings. This caused the app to fall back to native speech recognition instead of using the superior Whisper API.

## Root Cause

The issue was an **async loading race condition**:

1. **Provider Initialization**: The `appSettingsProvider` uses a Riverpod `Notifier` with this build pattern:
   ```dart
   @override
   AppSettings build() {
     _loadSettings();  // Async call
     return const AppSettings();  // Returns immediately with empty settings
   }
   ```

2. **Race Condition**: When `PronunciationPracticePage` initialized:
   - `initState` → `addPostFrameCallback` → `_initializeSpeechRecognition()`
   - `_initializeSpeechRecognition()` called `ref.read(appSettingsProvider)`
   - This read the provider BEFORE `_loadSettings()` completed
   - Result: Empty `AppSettings()` with no API key

3. **Timing Issue**: The `_loadSettings()` method loads from `SharedPreferences` asynchronously, which takes 50-200ms. The pronunciation page tried to read the settings before this completed.

## Solution

Implemented a **reactive initialization pattern** that waits for settings to be loaded:

### Previous Approach (Broken)
```dart
@override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    _initializeSpeechRecognition();  // ❌ Too early, reads empty settings
  });
}
```

### New Approach (Fixed)
```dart
@override
void initState() {
  super.initState();
  
  WidgetsBinding.instance.addPostFrameCallback((_) {
    // Set up listener that triggers when settings are loaded
    ref.listenManual(
      appSettingsProvider,
      (previous, next) {
        // Check if API key is now available
        final previousHadKey = previous?.openaiApiKey != null && previous!.openaiApiKey!.isNotEmpty;
        final nowHasKey = next.openaiApiKey != null && next.openaiApiKey!.isNotEmpty;
        
        // Initialize when we haven't yet, or when API key becomes available
        if (!_hasInitializedSpeech || (!previousHadKey && nowHasKey)) {
          _hasInitializedSpeech = false;
          _initializeSpeechRecognition();
        }
      },
      fireImmediately: true, // ✅ Triggers with current state AND future updates
    );
  });
}
```

## Key Changes

### 1. Listener-Based Initialization
- Uses `ref.listenManual()` with `fireImmediately: true`
- This fires immediately with the current settings state
- Also fires again when settings finish loading
- Catches both quick and slow loading scenarios

### 2. Smart Re-initialization Logic
```dart
// Initialize speech recognition if:
// 1. We haven't initialized yet, OR
// 2. API key changed from empty to filled
if (!_hasInitializedSpeech || (!previousHadKey && nowHasKey)) {
  _hasInitializedSpeech = false;
  _initializeSpeechRecognition();
}
```

### 3. Debugging Output
Added console logging to track what's happening:
```dart
print('🔄 Settings updated: openaiApiKey=${next.openaiApiKey != null && next.openaiApiKey!.isNotEmpty ? "present" : "missing"}');
```

## How It Works

### Scenario 1: Settings Load Quickly (< 16ms)
1. `initState` runs
2. `addPostFrameCallback` schedules listener setup
3. Settings finish loading from SharedPreferences
4. Listener fires with loaded settings containing API key
5. ✅ Initializes with Whisper API

### Scenario 2: Settings Load Slowly (> 16ms)
1. `initState` runs  
2. `addPostFrameCallback` schedules listener setup
3. Listener fires immediately with empty settings
4. Initializes with native speech (fallback)
5. Settings finish loading
6. Listener fires again with loaded settings containing API key
7. ✅ Re-initializes with Whisper API

### Scenario 3: User Adds API Key Later
1. Page already open with native speech
2. User goes to settings and adds API key
3. Listener detects API key change
4. ✅ Re-initializes with Whisper API

## Benefits

### ✅ Reliability
- No race conditions
- Works regardless of loading speed
- Catches settings loaded at any time

### ✅ Flexibility  
- Handles fast and slow loading
- Supports adding API key while page is open
- Graceful fallback to native speech if no key

### ✅ Debuggability
- Console logs show when settings update
- Easy to trace initialization flow
- Clear status messages

## Testing

### Test Scenario 1: Fresh App Launch
1. ✅ Close app completely
2. ✅ Launch app
3. ✅ Navigate to Pronunciation Practice
4. ✅ **Expected**: Detects OpenAI API key immediately
5. ✅ **Expected**: Console shows "Using OpenAI Whisper API"

### Test Scenario 2: No API Key
1. ✅ Remove OpenAI API key from settings
2. ✅ Go to Pronunciation Practice
3. ✅ **Expected**: Falls back to native speech recognition
4. ✅ **Expected**: Console shows "OpenAI API key not found"

### Test Scenario 3: Add API Key While Page Open
1. ✅ Start with no API key
2. ✅ Open Pronunciation Practice (uses native)
3. ✅ Keep page open, add API key in settings
4. ✅ Return to Pronunciation Practice
5. ✅ **Expected**: Automatically switches to Whisper API
6. ✅ **Expected**: Console shows "API key was added, switching to Whisper API mode"

## Files Modified

- `lib/presentation/pages/training/pronunciation_practice_page.dart`
  - Modified `initState()` method
  - Changed initialization strategy from immediate read to reactive listener

## Related Issues

This fix also resolves the same issue that was previously fixed in:
- `app_settings_page.dart` - Similar async loading problem
- `main.dart` - Android lifecycle provider refresh

## Technical Notes

### Why `fireImmediately: true`?
- Ensures the listener fires with the current state right away
- Without it, we'd only catch future changes, missing initial load
- Acts like both an initial read AND a change listener

### Why `listenManual` instead of `listen`?
- `listenManual` doesn't automatically dispose when widget rebuilds
- We want the listener to persist for the widget's lifetime
- Manual control over when listener is active

### Why `addPostFrameCallback`?
- Ensures widget tree is fully built before setting up listener
- Riverpod refs are fully available after first frame
- Prevents "ref used during build" errors

## Future Improvements

Consider updating `AppSettingsProvider` to use a proper async pattern:
```dart
final appSettingsProvider = FutureProvider<AppSettings>((ref) async {
  final repository = AppSettingsRepository();
  return await repository.loadSettings();
});
```

This would make the async nature explicit and allow consumers to wait properly. However, this would require updating all usages throughout the app.

