# Item Edit Page - Async Settings Loading Fix

## Date: 2026-03-09

## Issue: OpenAI API Key Not Detected on First Load

### Problem
The same async loading issue that affected `pronunciation_practice_page` was also affecting `item_edit_page`:

1. User opens item edit page (new or existing item)
2. `initState()` calls `_initializeSpeechRecognition()` immediately
3. `ref.read(appSettingsProvider)` is called synchronously
4. Settings haven't finished loading yet from SharedPreferences
5. OpenAI API key appears as `null` or empty
6. Whisper API service is not initialized
7. User gets "Speech recognition is not available" error
8. If user closes and reopens the page, settings are now loaded and it works

### Root Cause
The `appSettingsProvider` loads settings asynchronously from SharedPreferences in its constructor:

```dart
AppSettingsProvider() {
  _loadSettings(); // Async method, not awaited in constructor
}
```

But `initState()` is synchronous and doesn't wait for the async loading to complete before reading the settings.

### Solution
Use the same pattern as `pronunciation_practice_page.dart`:

1. **Post-Frame Callback**: Defer speech recognition initialization until after the first frame
2. **Await Initialization**: Make sure initialization completes before continuing
3. **Debug Logging**: Track the loading state to verify the fix

## Code Changes

### Before (Incorrect)
```dart
@override
void initState() {
  super.initState();
  _ttsService.initialize();
  _audioRecorder = AudioRecorder();
  _initializeControllers();
  _initializeSpeechRecognition(); // ❌ Settings not loaded yet!
  _isKnown = widget.item.isKnown;
  // ...
}
```

### After (Correct)
```dart
@override
void initState() {
  super.initState();
  _ttsService.initialize();
  _audioRecorder = AudioRecorder();
  _initializeControllers();
  
  // ✅ Use post-frame callback to ensure settings are loaded
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    logDebug('📍 ItemEditPage: postFrameCallback executing...');
    
    // Check current settings state BEFORE initialization
    final currentSettings = ref.read(appSettingsProvider);
    logDebug('📊 Current settings state at postFrameCallback:');
    logDebug('   - openaiApiKey present: ${currentSettings.openaiApiKey != null && currentSettings.openaiApiKey!.isNotEmpty}');
    
    // Initialize speech recognition - AWAIT to ensure it completes!
    logDebug('🚀 Calling _initializeSpeechRecognition() for the first time...');
    await _initializeSpeechRecognition();
    logDebug('✅ Initial speech recognition setup complete');
  });
  
  _isKnown = widget.item.isKnown;
  // ...
}
```

## Why This Works

### 1. Post-Frame Callback Timing
`addPostFrameCallback()` executes **after** the first frame is rendered, which means:
- The widget tree is built
- Providers have had time to initialize
- Settings have finished loading from SharedPreferences
- The OpenAI API key is available

### 2. Async/Await Pattern
By making the callback `async` and using `await`:
- We ensure `_initializeSpeechRecognition()` completes fully
- Speech recognition service is properly initialized
- Whisper API service is created if API key exists
- State is consistent before user interaction

### 3. Same Pattern as pronunciation_practice_page
This creates consistency across the codebase and ensures both pages handle async settings loading the same way.

## Debug Output

### First Load (With Fix)
```
📍 ItemEditPage: postFrameCallback executing...
📊 Current settings state at postFrameCallback:
   - openaiApiKey present: true
   - openaiApiKey length: 164
   - openaiApiKey prefix: sk-proj-Ns...
🚀 Calling _initializeSpeechRecognition() for the first time...
═══════════════════════════════════════════════════════════
🎤 Initializing Speech Recognition for Item Edit Page
═══════════════════════════════════════════════════════════
📊 Settings provider state:
   - OpenAI API Key: present (164 chars)
   First 10 chars: sk-proj-Ns...
✓ OpenAI API key available - Whisper API can be used as fallback
✓ SpeechRecognitionService created
✓ Speech recognition available with 0 locales
❌ Native speech recognition not available on this device
═══════════════════════════════════════════════════════════
📊 Final initialization state:
   - Native speech available: false
   - Whisper service available: true
═══════════════════════════════════════════════════════════
✅ Initial speech recognition setup complete
```

### User Taps Microphone (With Fix)
```
═══════════════════════════════════════════════════════════
🎤 _startVoiceInput called
   Language code: en-GB
   Currently listening: false
═══════════════════════════════════════════════════════════
📊 Current state check:
   - OpenAI API Key in settings: present (164 chars)
   - SpeechRecognitionService exists: true
   - Native speech available: false
📋 Availability check:
   - Language available natively: false
   - Whisper API available: true
✅ Using OpenAI Whisper API (fallback mode)
   Reason: Native speech recognition not available
```

## Testing Verification

### Test Scenario 1: New Item
1. ✅ Open item_browser_page
2. ✅ Click "+" to add new item
3. ✅ Item edit page opens
4. ✅ Check console - API key is detected
5. ✅ Click microphone button
6. ✅ "Using cloud AI..." notification appears
7. ✅ Icon changes to stop button
8. ✅ Recording starts successfully

### Test Scenario 2: Edit Existing Item
1. ✅ Open item_browser_page
2. ✅ Click on existing item
3. ✅ Item edit page opens
4. ✅ Check console - API key is detected
5. ✅ Click microphone button
6. ✅ Whisper API mode activated
7. ✅ Recording works correctly

### Test Scenario 3: Without API Key
1. ✅ Remove OpenAI API key from settings
2. ✅ Open item edit page
3. ✅ Check console - no API key detected
4. ✅ Click microphone button
5. ✅ Error message with Settings link appears
6. ✅ Add API key in Settings
7. ✅ Return to item edit (close and reopen)
8. ✅ API key now detected
9. ✅ Whisper API works

## Benefits

1. **Consistent Behavior**: First load now works the same as subsequent loads
2. **No User Confusion**: No more "not available" errors when API key is configured
3. **Better Reliability**: Settings are guaranteed to be loaded before initialization
4. **Proper Logging**: Clear debug output helps track the loading sequence
5. **Code Consistency**: Same pattern used in both affected pages

## Related Files

- `lib/presentation/pages/items/item_edit_page.dart` - Fixed
- `lib/presentation/pages/training/pronunciation_practice_page.dart` - Reference implementation
- `lib/presentation/providers/app_settings_provider.dart` - Settings provider with async loading

## Key Takeaway

**When using Riverpod providers that load data asynchronously (like from SharedPreferences), always use `addPostFrameCallback()` in `initState()` to ensure the data is loaded before reading it.**

This is especially important for:
- Settings/preferences that load from persistent storage
- Any provider with async initialization
- API keys, user data, or configuration values

## Future Prevention

Consider adding a comment or lint rule to remind developers:

```dart
// ⚠️ IMPORTANT: If you need to read appSettingsProvider in initState,
// use addPostFrameCallback to ensure async loading is complete!
// See pronunciation_practice_page.dart and item_edit_page.dart for examples.
```

