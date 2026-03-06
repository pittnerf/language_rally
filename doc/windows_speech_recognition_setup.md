# Pronunciation Practice - Platform Support

## Overview
The Pronunciation Practice feature uses speech recognition to evaluate your pronunciation. **Speech recognition is NOT reliably supported on Windows desktop** due to technical limitations with the underlying APIs.

## Important Notice for Windows Users

⚠️ **Windows Desktop Limitation**: The pronunciation practice feature does **NOT work reliably on Windows 10/11 desktop** because:

1. The `speech_to_text` Flutter package uses **SAPI (Speech API)** on Windows
2. SAPI is an **older, deprecated technology** from Windows Vista/7 era
3. Modern Windows 10/11 systems may not have SAPI speech engines installed
4. The error `HRESULT: 80045077` means **speech engine not found/not available**
5. This is NOT the same as "Windows Speech Recognition" in Settings (which uses different APIs)

**Recommended Solution**: Use the Android or iOS mobile app for pronunciation practice.

## Platform Support

| Platform | Speech Recognition | Audio Recording | Status |
|----------|-------------------|-----------------|--------|
| **Android** | ✅ Native | ✅ Native | ✅ **Fully supported** |
| **iOS** | ✅ Native | ✅ Native | ✅ **Fully supported** |
| **Web** | ✅ Browser API | ✅ Browser API | ✅ **Supported** (Chrome/Edge) |
| **Windows** | ❌ SAPI (deprecated) | ✅ Yes | ❌ **NOT SUPPORTED** |
| **macOS** | ⚠️ Limited | ✅ Yes | ⚠️ Limited support |
| **Linux** | ❌ No | ✅ Yes | ❌ Not supported |

## Why Windows Desktop Doesn't Work

### The Technical Problem

**SAPI (Speech API) is Deprecated:**
- The `speech_to_text` Flutter package on Windows uses **SAPI 5.4** (Speech API)
- SAPI was the speech recognition technology used in **Windows Vista and Windows 7**
- Microsoft has deprecated SAPI in favor of newer technologies (Windows.Media.SpeechRecognition, Azure Cognitive Services)
- Modern Windows 10/11 installations **may not include SAPI speech engines**

**Error Code Explained:**
- `HRESULT: 80045077` = **SPERR_NOT_FOUND**
- This means: "Speech recognition engine not found or not installed"
- This is NOT a configuration issue - the required components simply aren't available on modern Windows

**Not the Same as "Windows Speech Recognition":**
- The "Speech" settings in Windows Settings (Settings > Time & Language > Speech) configure **different APIs**
- These settings control:
  - Online speech recognition (cloud-based)
  - Voice activation
  - Dictation features
- They do **NOT** enable SAPI, which is what the Flutter package needs

### What About Windows Speech Recognition in Control Panel?

Windows Speech Recognition (accessible from Control Panel) is also a **different system**:
- Uses different APIs than SAPI
- Not accessible through Flutter's `speech_to_text` package
- Designed for dictation and voice commands, not app integration
- Even if enabled, won't fix the SAPI error

## Recommended Solutions

### ✅ Option 1: Use Mobile App (RECOMMENDED)

**Android or iOS:**
- Speech recognition works natively without any setup
- Better microphone quality
- More reliable recognition
- Full feature support

**How to transfer your data:**
1. Export your packages on Windows
2. Transfer the exported file to your mobile device
3. Import on mobile device
4. Practice pronunciation with full support

### ✅ Option 2: Use Web Version

**Modern browsers (Chrome, Edge):**
- Uses browser's built-in Web Speech API
- No Windows configuration needed
- Works immediately
- Quality depends on browser and internet connection

**How to access:**
1. Open Language Rally in Chrome or Edge browser
2. Allow microphone access when prompted
3. Practice pronunciation normally

### ❌ Option 3: Windows Desktop (NOT RECOMMENDED)

Windows desktop speech recognition through this app is **not reliably available** due to SAPI deprecation.

**Attempted workarounds that DON'T work:**
- ❌ Enabling "Speech recognition" in Windows Settings
- ❌ Configuring speech language packs
- ❌ Installing speech recognition languages
- ❌ Running as Administrator
- ❌ Enabling microphone permissions
- ❌ Training Windows Speech Recognition

These don't work because they configure different APIs that the app cannot access.

## Troubleshooting

### Issue: "Speech recognition is not supported on this platform"

**Cause:** You're using Windows desktop, which doesn't have SAPI speech engines available.

**Solution:**
- Use the Android or iOS mobile app
- Use the web version in Chrome or Edge browser
- Windows desktop pronunciation practice is not supported

### Issue: HRESULT: 80045077 error in console

**Cause:** SAPI (Speech API) is not available on your Windows installation. This is normal for modern Windows 10/11 systems.

**This is NOT a configuration problem** - it's a platform limitation.

**Solution:**
- This cannot be fixed on Windows desktop
- Use mobile app or web version instead

### Issue: "Why does the Windows Speech settings not help?"

**Answer:** The Windows Speech settings in "Settings > Time & Language > Speech" configure different APIs (cloud-based recognition) that the Flutter `speech_to_text` package cannot access. The package specifically needs SAPI, which is deprecated and not available on modern Windows.

### Issue: "Can I install SAPI manually?"

**Answer:** Technically possible but not recommended:
- SAPI installers are outdated and may not work on Windows 10/11
- May cause system instability
- Limited language support
- Still inferior to mobile/web alternatives
- Not worth the effort when mobile apps work perfectly

## Mobile Platform Language Support

When using the **mobile app (Android/iOS)** or **web version**, speech recognition supports:

- English (US, UK, Australia, Canada, India)
- French (France, Canada)
- German (Germany)
- Spanish (Spain, Mexico)
- Italian (Italy)
- Japanese (Japan)
- Chinese (Simplified, Traditional)
- Portuguese (Brazil, Portugal)
- Korean (Korea)
- Russian (Russia)
- Polish (Poland)
- And many more...

**Note:** Language availability depends on the platform (Android, iOS, or browser) and your device settings.

## Feature Status by Platform

### Windows Desktop

#### What Works ✅
- Audio recording for waveform analysis (partial scoring)
- Text-to-speech for correct pronunciation playback
- Visual feedback (tachometer)
- Item filtering and progress tracking
- Swipe gestures for navigation

#### What Doesn't Work ❌
- **Speech-to-text recognition** - SAPI not available
- **Word accuracy scoring** - Requires speech recognition
- **Full pronunciation scoring** - Only audio analysis (50%) available

### Mobile (Android/iOS) - RECOMMENDED

#### Fully Functional ✅
- ✅ Speech-to-text recognition
- ✅ Audio waveform analysis
- ✅ Complete pronunciation scoring (100%)
- ✅ All features work natively
- ✅ Better microphone quality
- ✅ Offline capable (depending on device)

### Web (Chrome/Edge)

#### Fully Functional ✅
- ✅ Speech-to-text via Web Speech API
- ✅ Audio recording
- ✅ Complete pronunciation scoring (100%)
- ⚠️ Requires internet connection
- ⚠️ Microphone permission required

## Technical Details

### How It Works (When Supported)

The pronunciation practice uses a dual-scoring system:

1. **Speech Recognition (50%)**
   - Platform-native speech API
   - Converts your speech to text
   - Compares recognized words with expected text
   - Word match scoring

2. **Audio Analysis (50%)**
   - Records audio using the `record` package
   - Analyzes waveform, volume patterns, rhythm
   - Compares duration, stress patterns, pauses
   - Gender-neutral normalization

### Why Windows Desktop Doesn't Work

- **Windows uses SAPI** (Speech API 5.4) - deprecated since Windows 7
- **Android/iOS use native APIs** - always available and maintained
- **Web uses Web Speech API** - modern, cloud-based
- **SAPI engines** are not included in modern Windows 10/11

### API Usage Example

```dart
// Speech recognition initialization
_speechAvailable = await _speech.initialize(
  onError: (error) => handleError(error),
  onStatus: (status) => updateStatus(status),
);

// Check if available before use
if (!_speechAvailable) {
  // On desktop: Not supported
  // On mobile: Works immediately
}
```

## FAQ

**Q: Why doesn't pronunciation practice work on my Windows PC?**
A: Windows desktop uses deprecated SAPI technology that's not available on modern systems. Use the mobile app or web version instead.

**Q: Will enabling Windows Speech Recognition in Settings help?**
A: No. That configures different APIs (cloud-based) that the app cannot access. The app needs SAPI, which is not included in modern Windows.

**Q: Can I fix the HRESULT: 80045077 error?**
A: This error means SAPI speech engines are not found. It's not fixable on Windows 10/11. Use mobile or web instead.

**Q: Why does it work on my phone but not Windows?**
A: Mobile platforms (Android/iOS) have speech recognition built-in and always available. Windows desktop doesn't support the required APIs.

**Q: Do I need internet for pronunciation practice?**
A: 
- **Mobile:** Depends on device settings (online or offline recognition)
- **Web:** Yes, requires internet
- **Windows Desktop:** Not applicable (not supported)

**Q: Can I use a different speech recognition service?**
A: The app currently uses platform-native speech recognition. Cloud services (Azure, Google Cloud) could be integrated in future versions.

**Q: Does audio recording work without speech recognition?**
A: Yes! Audio recording and analysis (50% of scoring) works on all platforms including Windows. Only speech-to-text is unavailable on desktop.

**Q: How accurate is the pronunciation scoring?**
A: On supported platforms (mobile/web):
- Speech recognition quality: 50% of score
- Audio waveform analysis: 50% of score
- Depends on microphone quality and environment

On Windows desktop: Only 50% (audio analysis) is available.

**Q: Can I practice without speech recognition?**
A: Partially. You can record audio and get partial scoring (audio analysis only), but full word-match scoring requires speech recognition available on mobile/web.

## Error Messages Explained

| Message | Meaning | Solution |
|---------|---------|----------|
| "Speech recognition is not supported on this platform" | Running on Windows desktop | Use mobile app or web version |
| "Speech recognition is not available" | SAPI not found (normal on Windows 10/11) | Use mobile app or web version |
| "No speech detected" | Recording completed but nothing heard | Check microphone, speak louder |
| "HRESULT: 80045077" | SAPI engine not found (console only) | Expected on Windows - use mobile/web |

## Summary

- ✅ **Android/iOS:** Fully supported - recommended platform
- ✅ **Web (Chrome/Edge):** Fully supported - good alternative
- ❌ **Windows Desktop:** Not supported - use mobile or web
- ⚠️ **macOS:** Limited support
- ❌ **Linux:** Not supported

**For the best pronunciation practice experience, use the mobile app on Android or iOS.**








