# Fix: OpenAI API Key Not Detected on First Load

## The Problem

When you first open the pronunciation practice page after starting the app, the OpenAI API key isn't detected even though it's saved in settings. However, when you go back to the main menu and return to pronunciation practice, it works correctly.

**Symptoms:**
```
First visit:
=== Initializing Speech Recognition ===
OpenAI API Key present: false  ← WRONG!
Using Whisper API: false

Second visit (after going back and returning):
=== Initializing Speech Recognition ===
OpenAI API Key present: true   ← CORRECT!
Using Whisper API: true
```

## Root Cause

This is a **Riverpod provider initialization timing issue**.

### The Problem Flow:

1. App starts
2. User navigates to Pronunciation Practice
3. `initState()` is called
4. Code tries to read `appSettingsProvider` using `ref.read()`
5. **But**: The provider's `build()` method calls `_loadSettings()` asynchronously
6. **Result**: `ref.read()` gets the default empty `AppSettings()` before loading completes
7. Empty settings = no API key = fallback to native mode

### Why Second Visit Works:

When you go back and return:
1. Settings are already loaded in memory
2. `ref.read()` gets the cached, loaded settings
3. API key is present
4. Whisper API mode enabled ✓

## The Solution

Applied the same fix used in `app_settings_page.dart`:

### 1. Use `WidgetsBinding.instance.addPostFrameCallback`

Initialize speech recognition **after** the first frame is rendered, giving the provider time to load:

```dart
@override
void initState() {
  super.initState();
  _ttsService.initialize();
  _loadAndFilterItems();
  _loadPlaybackPreference();
  
  // Initialize AFTER first frame
  WidgetsBinding.instance.addPostFrameCallback((_) {
    _initializeSpeechRecognition();
  });
}
```

### 2. Use `ref.listenManual` to Handle Dynamic Changes

Listen for settings changes to handle cases where the API key is added later:

```dart
WidgetsBinding.instance.addPostFrameCallback((_) {
  // Initialize immediately
  _initializeSpeechRecognition();
  
  // Listen for future changes
  ref.listenManual(
    appSettingsProvider,
    (previous, next) {
      final hadApiKey = previous?.openaiApiKey != null && previous!.openaiApiKey!.isNotEmpty;
      final hasApiKey = next.openaiApiKey != null && next.openaiApiKey!.isNotEmpty;
      
      // Reinitialize if API key is added
      if (!hadApiKey && hasApiKey && !_useWhisperAPI) {
        print('✓ API key was added, switching to Whisper API mode');
        _hasInitializedSpeech = false;
        _initializeSpeechRecognition();
      }
    },
  );
});
```

### 3. Use `ref.watch` in Build Method

Ensure the UI rebuilds when settings change:

```dart
@override
Widget build(BuildContext context) {
  // Watch settings to rebuild when they change
  final settings = ref.watch(appSettingsProvider);
  
  // ...rest of build method
}
```

## How It Works Now

### First Visit (Fixed):

```
1. App starts
2. Navigate to Pronunciation Practice
3. initState() schedules postFrameCallback
4. First frame renders
5. postFrameCallback executes:
   a. Provider has time to load settings from storage
   b. _initializeSpeechRecognition() reads loaded settings
   c. API key is present!
   d. Whisper API mode enabled ✓
```

### Adding API Key Later:

```
1. User in Pronunciation Practice (no API key)
2. Uses basic mode (native speech recognition)
3. Goes to Settings
4. Adds OpenAI API key
5. Returns to Pronunciation Practice
6. ref.listenManual detects the change
7. Automatically reinitializes in Whisper API mode ✓
```

## Testing

### Test Scenario 1: Fresh Start with API Key

1. **Setup**: Have API key saved in settings
2. **Action**: Start app → Go directly to Pronunciation Practice
3. **Expected Result**:
   ```
   === Initializing Speech Recognition ===
   OpenAI API Key present: true
   OpenAI API Key (first 10 chars): sk-proj-ab...
   🎙️ Using OpenAI Whisper API for speech recognition
   ```
4. **UI**: Green "Premium Mode" banner shows

### Test Scenario 2: Fresh Start Without API Key

1. **Setup**: No API key in settings
2. **Action**: Start app → Go to Pronunciation Practice
3. **Expected Result**:
   ```
   === Initializing Speech Recognition ===
   OpenAI API Key present: false
   🎙️ OpenAI API key not found, using native speech recognition...
   ```
4. **UI**: Orange "Basic Mode" banner shows

### Test Scenario 3: Adding API Key Mid-Session

1. **Setup**: Start with no API key
2. **Action**: 
   - Open Pronunciation Practice (basic mode)
   - Go back to main menu
   - Go to Settings
   - Add OpenAI API key
   - Return to Pronunciation Practice
3. **Expected Result**:
   ```
   🔄 Settings changed, checking if we need to reinitialize speech recognition...
   ✓ API key was added, switching to Whisper API mode
   🎙️ Using OpenAI Whisper API for speech recognition
   ```
4. **UI**: Banner changes from orange to green

## Debug Output

You'll now see proper logging:

### On First Load (With API Key):
```
=== Initializing Speech Recognition ===
OpenAI API Key present: true
OpenAI API Key (first 10 chars): sk-proj-ab...
🎙️ Using OpenAI Whisper API for speech recognition
   ✓ High-quality transcription enabled
   ✓ Manual recording control (no automatic timeout)
   ✓ No speech timeout issues
```

### When Settings Change:
```
🔄 Settings changed, checking if we need to reinitialize speech recognition...
✓ API key was added, switching to Whisper API mode
=== Initializing Speech Recognition ===
OpenAI API Key present: true
...
```

## Files Modified

### Single File Changed:
`lib/presentation/pages/training/pronunciation_practice_page.dart`

**Changes:**
1. Updated `initState()` to use `addPostFrameCallback`
2. Added `ref.listenManual` to watch for settings changes
3. Added `ref.watch` in `build()` method
4. Removed `didChangeDependencies()` logic (no longer needed)

## Technical Details

### Why `addPostFrameCallback`?

```dart
WidgetsBinding.instance.addPostFrameCallback((_) {
  // Code here runs AFTER first frame is rendered
  // At this point, providers have had time to initialize
});
```

This ensures:
- UI builds first (no delay)
- Provider has time to load from storage
- Settings are available when we read them

### Why `ref.listenManual`?

```dart
ref.listenManual(appSettingsProvider, (previous, next) {
  // Called whenever appSettingsProvider changes
  // Can compare old vs new to detect specific changes
});
```

Benefits:
- Detects when API key is added later
- Automatically switches modes
- No need to restart or navigate away

### Why `ref.watch`?

```dart
final settings = ref.watch(appSettingsProvider);
```

Ensures:
- Widget rebuilds when settings change
- UI always shows correct state
- Banner updates automatically

## Comparison: Before vs After

| Aspect | Before (Broken) | After (Fixed) |
|--------|----------------|---------------|
| **First Load** | ❌ Empty settings | ✅ Loaded settings |
| **API Key Detection** | ❌ Missing | ✅ Detected |
| **Mode Selection** | ❌ Wrong (native) | ✅ Correct (Whisper) |
| **Second Load** | ✅ Works | ✅ Works |
| **Adding API Key** | ❌ Requires restart | ✅ Auto-switches |
| **UI Updates** | ❌ Manual refresh | ✅ Automatic |

## Related Issues

This fix also resolves:
- Banner showing wrong mode on first load
- Playback checkbox not appearing (since it depends on Whisper mode)
- Having to navigate away and back to activate Whisper mode

## References

### Similar Fixes Applied:
- `app_settings_page.dart` - Uses same pattern for loading API keys
- This is a common pattern when working with async Riverpod providers

### Riverpod Best Practices:
1. **Don't use `ref.read()` in `initState()`** - Settings may not be loaded yet
2. **Use `addPostFrameCallback`** - Gives providers time to initialize
3. **Use `ref.watch()`** - Ensures rebuilds when state changes
4. **Use `ref.listenManual()`** - React to specific changes

## Verification

After this fix, you should see:

✅ **First load works correctly**  
✅ **API key detected immediately**  
✅ **Correct mode banner (green for Whisper, orange for native)**  
✅ **Playback checkbox appears (if in Whisper mode)**  
✅ **No need to navigate away and back**  
✅ **Dynamic switching when API key added**  

---

**Status**: Fixed ✓  
**Issue**: Initialization timing with async Riverpod provider  
**Solution**: Use `addPostFrameCallback` + `ref.listenManual` + `ref.watch`  
**Pattern**: Same as `app_settings_page.dart`  

Last updated: 2026-03-06

