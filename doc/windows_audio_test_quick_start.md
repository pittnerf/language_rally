# Quick Start Guide - Windows Audio Recording Test

## 🚀 Quick Start (3 Steps)

### 1. Run the App
```bash
flutter run -d windows
```

### 2. Open Test Page
- Scroll down on home page
- Tap **"Windows Audio Test"** button

### 3. Test Recording
1. **Select your microphone** from dropdown
2. **Tap the microphone button** (blue circle)
3. **Speak for 3-5 seconds**
4. **Tap again to stop** (red circle turns blue)
5. **Check console** - should show file size ~80 KB
6. **Tap "Play Recording"** - should hear your voice

---

## ✅ Success Indicators

**Recording is working if you see:**
```
✓ Initial file size after 500ms: 8192 bytes
✓ Final size: 81.2 KB (5s recording)
✓ Size ratio: 101.5%
✓ Recording saved: 5s, 81.2 KB (green message)
```

**Recording is NOT working if you see:**
```
⚠️ Initial file size after 500ms: 0 bytes
⚠️ Final size: 0.7 KB (5s recording)
⚠️ Size ratio: 0.9%
⚠️ Recording file is very small (orange message)
```

---

## 🔧 Troubleshooting (If Recording Fails)

### Try Different Device:
1. Open dropdown menu
2. Select different microphone (try USB headset if available)
3. Record again
4. Check console output

### Check Permissions:
1. Windows Settings > Privacy > Microphone
2. Enable "Allow desktop apps to access microphone"
3. Restart app

### Verify Device Works:
1. Open Windows "Sound Recorder" app
2. Record and play back
3. If it works there, try that device in our app

---

## 📊 What to Look For in Console

### Good Output:
```
═══════════════════════════════════════════════════════════
🎙️ Starting Windows Audio Recording
═══════════════════════════════════════════════════════════
🔊 Checking microphone permission...
✓ Microphone permission granted
📁 Output path: C:\Users\...\Temp\windows_audio_test_1773230123456.m4a
🎤 Starting recording...
   Selected device: Headset Microphone (USB Audio Device)
   Device ID: {0.0.1.00000000}.{device-id-2}
   Sample rate: 44100 Hz
   Channels: 1 (mono)
   Encoder: AAC-LC
   Bit rate: 128000 bps
   AAC-LC encoder supported: true
   Is recording: true
   Initial file size after 500ms: 8192 bytes         ← GOOD! (> 0)
   ✓ File is growing - recording appears to be working
✅ Recording started successfully
═══════════════════════════════════════════════════════════

[after stopping]

═══════════════════════════════════════════════════════════
🛑 Stopping Windows Audio Recording
═══════════════════════════════════════════════════════════
📊 Recording stopped
   Duration: 5.234s
✅ Recording file saved
   Path: C:\Users\...\Temp\windows_audio_test_1773230123456.m4a
   Size: 81.2 KB (83148 bytes)                      ← GOOD! (~16KB/s)
   Expected size: 80.0 KB
   Size ratio: 101.5%                                ← GOOD! (~100%)
✓ Recording appears to be valid
═══════════════════════════════════════════════════════════
```

### Bad Output:
```
   Initial file size after 500ms: 0 bytes           ← BAD! (should be > 0)
   ⚠️ WARNING: File size is 0 - recording may not be working!

[after stopping]

   Size: 0.7 KB (718 bytes)                         ← BAD! (too small)
   Expected size: 80.0 KB
   Size ratio: 0.9%                                  ← BAD! (< 80%)
⚠️ File size is very small (< 5KB) - recording may have failed
```

---

## 🎯 Features Available

### Device Selection
- Lists all audio input devices
- Auto-selects first device
- Refresh button to reload
- Shows device count

### Recording Settings
- **Mono/Stereo toggle**
  - Mono (1 channel) - recommended for voice
  - Stereo (2 channels) - for music/ambient
- **Sample rate**: 44,100 Hz (standard)

### Recording Controls
- Large microphone button
- Blue = ready to record
- Red = recording in progress
- Status card shows state

### Validation
- Checks file size after 500ms
- Warns if recording too short
- Warns if file too small
- Shows size ratio vs expected

### Playback
- Play button after recording
- Stop button during playback
- Shows file name

---

## 📝 Common Issues

### "No audio input devices found"
**Solution:** 
- Check microphone is plugged in
- Click "Refresh Devices"
- Check Windows Sound settings

### "Microphone permission denied"
**Solution:**
- Windows Settings > Privacy > Microphone
- Enable for desktop apps
- Restart app

### Recording file too small
**Solution:**
- Try different device from dropdown
- Check device is not muted in Windows
- Test in Windows Sound Recorder first
- Verify microphone is plugged in properly

### Playback is silent
**Solution:**
- Check Windows volume
- Verify file size is reasonable (> 5KB)
- Try different output device
- Check console for playback errors

---

## 💡 Tips

1. **USB headsets** usually work better than built-in mics
2. **Try each device** in the dropdown if first one doesn't work
3. **Record for at least 3 seconds** for valid testing
4. **Watch the console** for detailed diagnostic info
5. **File size should be ~16KB per second** of recording

---

## 📍 Where to Find Test Page

1. Open app
2. Home page
3. Scroll down to dev tools section
4. Look for button with microphone icon: **"Windows Audio Test"**

---

## ⚡ Expected File Sizes

| Duration | Expected Size (Mono) | Expected Size (Stereo) |
|----------|---------------------|------------------------|
| 1 second | ~16 KB | ~32 KB |
| 3 seconds | ~48 KB | ~96 KB |
| 5 seconds | ~80 KB | ~160 KB |
| 10 seconds | ~160 KB | ~320 KB |

*(At 128 kbps bitrate, AAC-LC format)*

---

## 🆘 If Nothing Works

1. **Document what you see:**
   - Copy console output
   - Note which devices were tried
   - Check file sizes
   - Test playback results

2. **Verify Windows recording works:**
   - Open Windows "Sound Recorder"
   - Record and play back
   - If that fails, it's a Windows/hardware issue

3. **Try different approach:**
   - Check if pronunciation practice page works
   - Compare with other recording apps
   - Consider different audio library

---

**Created:** 2026-03-11  
**Version:** Fresh Start  
**Expected:** Working audio recording with proper file sizes

