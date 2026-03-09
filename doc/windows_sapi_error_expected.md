# Windows SAPI Error - Expected Behavior

## Date: 2026-03-09

## Error Message
```
Method called: initialize
Initializing SAPI speech recognition...
Failed to create recognition context. HRESULT: 80045077
```

## Understanding the Error

### What is HRESULT 80045077?

**HRESULT: 80045077** is a Windows Speech API (SAPI) error code that means:
- **SPERR_NOT_FOUND** or **Speech Recognition Not Available**
- This occurs when Windows Speech Recognition is not enabled or configured on the system

### Why Does This Happen?

On Windows desktop, the `speech_to_text` Flutter package uses Windows SAPI (Speech API), which requires:

1. **Windows Speech Recognition to be enabled** in Windows Settings
2. **Language packs installed** for the languages you want to use
3. **Microphone configured** in Windows audio settings

### Is This a Problem?

**No! This is EXPECTED behavior on Windows desktop** and is why we implemented the Whisper API fallback.

## How It's Handled

### 1. Error is Caught and Logged
```dart
try {
  _speechAvailable = await _speech.initialize(...);
} catch (e) {
  logDebug('❌ Native speech recognition initialization failed: $e');
  _speechAvailable = false; // ✅ Handled gracefully
}
```

### 2. Enhanced Error Message
The code now detects Windows SAPI errors and provides clear guidance:

```
❌ Native speech recognition initialization failed: ...HRESULT: 80045077...
   Error type: ...

ℹ️  This is a Windows SAPI error - EXPECTED on Windows desktop
   Windows desktop speech recognition requires:
   1. Windows Speech Recognition to be enabled in Windows settings
   2. Or use Whisper API fallback (recommended)

   👉 Solution: Whisper API will be used automatically if OpenAI key is configured
```

### 3. Automatic Fallback to Whisper API

After initialization completes, you'll see:

**If OpenAI Key is Configured:**
```
📊 Final initialization state:
   - Native speech available: false
   - Whisper service available: true

✅ READY FOR RECORDING:
   - Native speech: Not available (expected on Windows)
   - Whisper API: Available and ready to use
   - Click microphone button to start recording
```

**If OpenAI Key is NOT Configured:**
```
📊 Final initialization state:
   - Native speech available: false
   - Whisper service available: false

⚠️  WARNING: No speech input method available
   - Native speech: Not available
   - Whisper API: Not configured
   - Action needed: Add OpenAI API key in Settings
```

## Expected Console Output

When you open the item edit page on Windows with OpenAI key configured:

```
═══════════════════════════════════════════════════════════
🎤 Initializing Speech Recognition for Item Edit Page
═══════════════════════════════════════════════════════════
📊 Settings provider state:
   - OpenAI API Key: present (164 chars)
✓ OpenAI API key available - Whisper API can be used as fallback
   First 10 chars: sk-proj-Ns...
✓ SpeechRecognitionService created

Method called: initialize
Initializing SAPI speech recognition...
Failed to create recognition context. HRESULT: 80045077

❌ Native speech recognition initialization failed: ...
   Error type: ...

ℹ️  This is a Windows SAPI error - EXPECTED on Windows desktop
   Windows desktop speech recognition requires:
   1. Windows Speech Recognition to be enabled in Windows settings
   2. Or use Whisper API fallback (recommended)

   👉 Solution: Whisper API will be used automatically if OpenAI key is configured

═══════════════════════════════════════════════════════════
📊 Final initialization state:
   - Native speech available: false
   - Whisper service available: true

✅ READY FOR RECORDING:
   - Native speech: Not available (expected on Windows)
   - Whisper API: Available and ready to use
   - Click microphone button to start recording

═══════════════════════════════════════════════════════════
```

## What Happens When You Click Microphone?

The app will:

1. Check native speech availability ❌ (false)
2. Check Whisper API availability ✅ (true)
3. **Use Whisper API automatically**
4. Show notification: "Using cloud AI for speech recognition (may be slower)"
5. Start recording with icon changing to stop button

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

## How to Enable Windows Speech Recognition (Optional)

If you want to use native Windows speech recognition instead:

### Windows 10
1. Open **Settings** → **Time & Language** → **Speech**
2. Turn on **Speech recognition**
3. Set up microphone
4. Download language packs if needed

### Windows 11
1. Open **Settings** → **Accessibility** → **Speech**
2. Turn on **Windows Speech Recognition**
3. Configure microphone
4. Install language packs

**Note**: Even with Windows Speech Recognition enabled, Whisper API provides:
- Better accuracy
- More language support
- Works across all platforms consistently

## Summary

✅ **The HRESULT: 80045077 error is EXPECTED on Windows**
✅ **It's handled gracefully with automatic fallback**
✅ **Whisper API will be used if OpenAI key is configured**
✅ **No user action needed unless Whisper API isn't available**

## Troubleshooting

### If Recording Still Doesn't Work

Check the diagnostic logs when you click microphone and try to record:

1. **Does Whisper API initialize?**
   ```
   ✓ SpeechRecognitionService created
   ```

2. **When you click microphone, is Whisper selected?**
   ```
   ✅ Using OpenAI Whisper API (fallback mode)
   ```

3. **Does recording start?**
   ```
   ✅ Audio recording started successfully
   Is recording: true
   ```

4. **What's the recording duration?**
   ```
   ⏱️ Recording duration: 2767ms (2.767s)
   ```

5. **What's the file size?**
   ```
   File size: 45321 bytes (44.26 KB)
   ```

If you see issues with any of these steps, share the complete console output for further diagnosis.

## Files Modified

- `lib/presentation/pages/items/item_edit_page.dart`
  - Enhanced error detection for Windows SAPI errors
  - Added clear messaging about expected behavior
  - Added ready state confirmation messages
  - Improved guidance for users

## Related Documentation

- `doc/item_edit_enhanced_speech_recognition.md` - Overall implementation
- `doc/item_edit_speech_recognition_fixes.md` - Bug fixes
- `doc/item_edit_async_settings_fix.md` - Async loading fix
- `doc/item_edit_recording_diagnostics.md` - Recording diagnostics

