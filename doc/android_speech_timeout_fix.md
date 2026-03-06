# Android Speech Recognition "No Speech Detected" Issue - Resolution

## Issue Summary

**Problem**: When testing pronunciation practice on Android, the app shows "No speech detected" even though the user is speaking.

**Root Cause**: Speech recognition timeout after only 3 seconds due to the speech not being detected by the recognition engine.

## Analysis from Logcat

From the Android logcat output, we can see the exact sequence of events:

```
19:07:35.410  >>> Speech recognition status: listening
19:07:38.437  >>> Speech recognition status: notListening
19:07:38.440  >>> Speech recognition status: done
19:07:38.585  !!! Speech recognition error: error_speech_timeout
```

**Timeline**: 
- Recording started at 19:07:35.410
- Speech recognition stopped at 19:07:38.437 (only 3 seconds later)
- Error: `error_speech_timeout`

**What worked:**
- ✅ Microphone permission granted
- ✅ Audio recording worked (53,932 bytes recorded)
- ✅ Speech recognition initialized successfully
- ✅ Locale (en-GB) was available
- ✅ Audio recording hardware functional

**What didn't work:**
- ❌ Speech recognition engine didn't detect any speech input
- ❌ Timed out after 3 seconds of silence

## Why This Happens

The speech recognition engine has a built-in speech detection algorithm that:

1. **Listens for voice patterns** - distinguishes speech from background noise
2. **Times out on silence** - if no speech is detected within the `pauseFor` duration (was 3 seconds)
3. **Requires minimum volume** - voice must be loud enough to be distinguished from noise

Common reasons for timeout:
- **Speaking too quietly** - voice doesn't reach detection threshold
- **Too far from microphone** - signal too weak (should be 6-12 inches away)
- **Background noise** - masks the voice signal
- **Not speaking immediately** - user takes too long to start speaking after pressing record
- **Microphone sensitivity** - device-specific calibration issues

## Solutions Implemented

### 1. Increased Timeout Durations

**Changed:**
```dart
// Before:
pauseFor: const Duration(seconds: 3),  // Too short
listenFor: const Duration(seconds: 30), // Reasonable but could be longer

// After:
pauseFor: const Duration(seconds: 5),  // More time between words
listenFor: const Duration(seconds: 60), // Full minute to speak
```

**Impact**: Gives users more time to speak and reduces premature timeouts.

### 2. Added Sound Level Tracking

**Added:**
```dart
double maxSoundLevel = 0.0;

onSoundLevelChange: (level) {
  if (level > maxSoundLevel) {
    maxSoundLevel = level;
  }
  print('Sound level: $level (max: $maxSoundLevel)');
}
```

**Impact**: Helps diagnose if microphone is picking up audio at all.

### 3. Immediate User Feedback

**Added:**
```dart
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Text(l10n.speakNow),
    duration: const Duration(seconds: 3),
    backgroundColor: Theme.of(context).colorScheme.primary,
  ),
);
```

**Impact**: Users know exactly when to start speaking.

### 4. Enhanced Error Messages

**Before:**
```
"No speech detected. Please try again."
```

**After:**
```
Speech timeout - Please speak louder and closer to the microphone.

Tips:
• Hold device 6-12 inches from your mouth
• Speak clearly at normal volume
• Reduce background noise
• Start speaking within 2 seconds of pressing record
```

**Impact**: Users understand what went wrong and how to fix it.

### 5. Better Timeout Detection

**Added:**
```dart
if (_speech.lastError != null && _speech.lastError!.errorMsg.contains('timeout')) {
  errorMessage = '... helpful timeout-specific guidance ...';
}
```

**Impact**: Different errors get different helpful messages.

## Testing Instructions

### To test the fix on Android:

1. **Build and install** the updated app:
   ```bash
   flutter build apk --debug
   # or
   flutter run
   ```

2. **Open Pronunciation Practice**:
   - Go to a language package
   - Select items for practice
   - Start Pronunciation Practice

3. **Test recording**:
   - Press the microphone button
   - **Wait for the blue "Speak now" message to appear**
   - **Immediately start speaking** (within 2 seconds)
   - **Speak clearly and at normal volume**
   - Hold phone 6-12 inches from your mouth
   - Speak for at least 2-3 seconds

4. **Check logs** while testing:
   ```bash
   flutter logs | findstr "Sound level"
   ```
   
   You should see sound levels > 0.1 when speaking, like:
   ```
   Sound level: 0.45 (max: 0.52)
   ✓ Sound detected! Level: 0.45
   ```

5. **If still not working**, check:
   - Is sound level always 0.0? → Microphone blocked or permission issue
   - Is sound level very low (< 0.1)? → Speak louder or move closer
   - Does it work with headset microphone? → Phone mic may be faulty

## Additional Recommendations

### For Users:

1. **Optimal microphone distance**: 6-12 inches (15-30 cm)
2. **Speak at 70-80% of normal speaking volume** (not too quiet, not shouting)
3. **Reduce background noise**:
   - Turn off TV/radio
   - Close windows in noisy areas
   - Move to quieter room
4. **Start speaking immediately** after the "Speak now" message appears
5. **Speak the full phrase** without long pauses (< 3 seconds between words)

### For Developers:

1. **Test on multiple devices** - speech recognition sensitivity varies
2. **Test in different environments** - quiet room vs. noisy environment
3. **Consider adding visual feedback** - show sound level bars during recording
4. **Add calibration option** - let users test their microphone first
5. **Provide practice mode** - let users practice without scoring first

## Technical Notes

### Speech Recognition Flow:

1. **User presses microphone button**
2. **App calls `_speech.listen()`**
3. **Speech recognition service starts** (Google's on Android)
4. **Service listens for voice patterns**
5. **If speech detected**: Starts transcription
6. **If no speech for `pauseFor` duration**: Times out with `error_speech_timeout`
7. **If speech detected and completed**: Returns transcribed text

### Platform Differences:

**Android:**
- Uses Google Speech Recognition service
- Requires Google app to be updated
- Detection threshold is device-dependent
- Generally very reliable if properly configured

**iOS:**
- Uses Apple's Speech Recognition framework
- Requires Siri to be enabled
- Generally more sensitive to speech
- Different timeout behavior

## Troubleshooting Guide

### Issue: Still getting timeout even after fix

**Check these in order:**

1. **Verify app has microphone permission:**
   ```
   Settings > Apps > Language Rally > Permissions > Microphone > Allow
   ```

2. **Test microphone with another app:**
   - Open Voice Recorder
   - Record a test message
   - Play it back - can you hear yourself clearly?

3. **Check Google app:**
   - Play Store > Search "Google" > Update
   - Settings > Apps > Google > Storage > Clear Cache

4. **Check sound levels in logs:**
   ```bash
   adb logcat | findstr "Sound level"
   ```
   - All zeros? → Microphone permission or hardware issue
   - Very low (< 0.1)? → Speak louder or closer
   - Good levels (> 0.2) but still no recognition? → Language/locale issue

5. **Test with English first:**
   - Create a simple English test item
   - If English works but other language doesn't → Language pack not installed

6. **Restart device:**
   - Sometimes speech recognition service needs a restart

### Issue: Works on one device but not another

This is normal - speech recognition sensitivity varies by:
- Device manufacturer and model
- Android version
- Google app version
- Microphone hardware quality
- Regional settings

**Solution**: Add device-specific calibration or adjustable sensitivity settings.

## Files Modified

1. **lib/presentation/pages/training/pronunciation_practice_page.dart**
   - Increased `pauseFor` from 3 to 5 seconds
   - Increased `listenFor` from 30 to 60 seconds
   - Added sound level tracking with max value
   - Added "Speak now" feedback message
   - Enhanced error messages for timeout scenarios
   - Improved error logging and diagnostics

2. **lib/l10n/app_en.arb**
   - Added `speakNow` localization string

3. **lib/l10n/app_hu.arb**
   - Added `speakNow` localization string (Hungarian)

## Next Steps

1. **Test the changes** on your Android device
2. **Monitor logs** to verify sound levels are being detected
3. **Adjust sensitivity** if needed (may require adding user settings)
4. **Consider adding**:
   - Visual sound level meter during recording
   - Microphone test/calibration feature
   - Adjustable timeout settings
   - Practice mode without scoring

---

**Summary**: The issue was caused by speech recognition timing out too quickly (3 seconds) before detecting speech. The fix increases timeouts, adds better user guidance, and provides more helpful error messages when speech isn't detected.

**Key takeaway**: Users need to speak **immediately**, **clearly**, and **at sufficient volume** (close to microphone) for speech recognition to work reliably.

---

Last updated: 2026-03-06

