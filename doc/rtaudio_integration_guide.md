# RTAudio Integration for Windows Audio Recording

## Date: 2026-03-11
## Status: ⚠️ **IMPLEMENTATION INCOMPLETE - Requires Native Build Setup**

## Overview

Replaced the `record` package with RTAudio C++ library for Windows audio recording due to persistent issues with the `record` package only capturing 0.9%-36% of expected audio data.

## Files Created

### Dart/Flutter Layer:
1. **lib/core/audio/rtaudio_recorder.dart**
   - Platform channel wrapper for RTAudio
   - Provides Dart interface: `RtAudioRecorder` class
   - Handles device listing, recording start/stop
   - Streams audio data via EventChannel

### Native C++ Layer:
2. **windows/rtaudio_plugin.h**
   - Plugin header with class definition
   - Method handlers for initialize, list devices, start/stop recording
   - RTAudio callback implementation

3. **windows/rtaudio_plugin.cpp**
   - Plugin implementation
   - Platform channel setup (MethodChannel + EventChannel)
   - RTAudio integration
   - Audio streaming to Flutter

4. **windows/rtaudio_plugin_registrar.cc**
   - Plugin registration helper

### Page Updated:
5. **lib/presentation/pages/test/windows_audio_recording_test_page.dart**
   - Replaced `record` package with `RtAudioRecorder`
   - Updated to use `RtAudioDevice` instead of `InputDevice`
   - Added WAV file creation from PCM data
   - Updated UI to show RTAudio implementation

## What Still Needs to be Done

### ⚠️ CRITICAL: Native Build Setup Required

The following steps MUST be completed to make this work:

### 1. Copy RTAudio Source Files
```bash
# Copy the RtAudio files from temp to windows directory
copy C:\FEJLESZTES\Java\language_rally\temp\RtAudio.h C:\FEJLESZTES\Java\language_rally\windows\
copy C:\FEJLESZTES\Java\language_rally\temp\RtAudio.cpp C:\FEJLESZTES\Java\language_rally\windows\
```

### 2. Update Windows CMakeLists.txt

Add the following BEFORE the line `add_subdirectory("runner")`:

```cmake
# RTAudio Plugin
add_library(rtaudio_plugin STATIC
  "rtaudio_plugin.cpp"
  "rtaudio_plugin.h"
  "rtaudio_plugin_registrar.cc"
  "RtAudio.cpp"
  "RtAudio.h"
)

apply_standard_settings(rtaudio_plugin)

# Define RTAudio API (use WASAPI for Windows)
target_compile_definitions(rtaudio_plugin PRIVATE __WINDOWS_WASAPI__)

# Link Windows audio libraries
target_link_libraries(rtaudio_plugin PRIVATE
  flutter
  flutter_wrapper
  ksuser
  mfplat
  mfuuid
  wmcodecdspuuid
)

set_target_properties(rtaudio_plugin PROPERTIES
  CXX_VISIBILITY_PRESET hidden
)

target_include_directories(rtaudio_plugin INTERFACE
  "${CMAKE_CURRENT_SOURCE_DIR}"
)
```

### 3. Register Plugin in runner/main.cpp

Find the `RegisterPlugins()` call and add BEFORE it:

```cpp
#include "rtaudio_plugin_registrar.cc"

// In the main() function, before RegisterPlugins():
RegisterRtAudioPlugin(flutter_controller.GetRegistrar("rtaudio_plugin"));
```

### 4. Update generated_plugin_registrant.cc (if auto-generated)

If this file gets regenerated, you may need to manually add:

```cpp
#include "rtaudio_plugin.h"

// In RegisterPlugins():
language_rally::RtAudioPlugin::RegisterWithRegistrar(
    registry->GetRegistrarForPlugin("RtAudioPlugin"));
```

### 5. Clean and Rebuild

```bash
cd C:\FEJLESZTES\Java\language_rally
flutter clean
flutter pub get
flutter build windows
flutter run -d windows
```

## How It Works

### Architecture:

```
┌─────────────────────────────────────┐
│ Flutter/Dart Layer                   │
│                                      │
│ windows_audio_recording_test_page.dart│
│           ↓                          │
│   RtAudioRecorder (Dart wrapper)    │
└──────────────┬──────────────────────┘
               │ Platform Channel
               │ (MethodChannel + EventChannel)
┌──────────────┴──────────────────────┐
│ Native C++ Layer                     │
│                                      │
│   rtaudio_plugin.cpp                │
│           ↓                          │
│   RtAudio Library                   │
│           ↓                          │
│   Windows WASAPI                    │
└─────────────────────────────────────┘
```

### Data Flow:

1. **Device List**: Dart → MethodChannel → C++ RTAudio → Returns device list
2. **Start Recording**: Dart → MethodChannel → C++ starts RTAudio stream → Audio callback fires
3. **Audio Stream**: C++ callback → EventChannel → Dart receives audio chunks
4. **Stop Recording**: Dart → MethodChannel → C++ stops stream → Returns total audio data

### Recording Process:

```cpp
// C++ Side (rtaudio_plugin.cpp)
int RecordCallback(...) {
  // Called by RTAudio for each audio buffer
  // 1. Get PCM audio samples from input_buffer
  // 2. Convert to byte array
  // 3. Send via EventChannel to Dart
  // 4. Store in internal buffer
  return 0;
}
```

```dart
// Dart Side (rtaudio_recorder.dart)
_audioStreamSubscription = _streamChannel
    .receiveBroadcastStream()
    .listen((audioData) {
      _audioBuffer.addAll(audioData);  // Accumulate audio
    });
```

## Testing (Once Build Setup Complete)

### 1. Run the App:
```bash
flutter run -d windows
```

### 2. Open Test Page:
- Home > Windows Audio Test

### 3. Expected Behavior:
- Should list all audio devices via RTAudio
- Select device and tap microphone
- Should capture full audio data (not 0.9% like before)
- Should create valid WAV file
- Should play back correctly

### 4. Debug Output:
```
🎵 Initializing RTAudio
✅ RTAudio initialized successfully
🎧 Loading Available Input Devices (RTAudio)
📊 Found 2 RTAudio input device(s)
🎙️ Starting Windows Audio Recording (RTAudio)
✅ Recording started successfully
📊 Buffer size after 500ms: 48.0 KB  ← Should be > 0!
🛑 Stopping Windows Audio Recording (RTAudio)
✅ Audio data captured
   Data size: 480.0 KB
   Expected: 470.4 KB
   Size ratio: 102.0%  ← Should be close to 100%!
```

## Why RTAudio Should Work Better

1. **Native C++ Library**: Direct access to Windows APIs
2. **WASAPI Backend**: Windows Audio Session API - modern and efficient
3. **Proven Track Record**: RTAudio used by many professional audio applications
4. **Low Latency**: Direct buffer access without intermediate layers
5. **Full Control**: Complete control over audio stream parameters

## Comparison

| Feature | record package | RTAudio |
|---------|---------------|---------|
| Implementation | Dart + Platform Channels | Native C++ |
| Windows Backend | Unknown/Broken | WASAPI |
| Data Capture | 0.9%-36% | Expected: 100% |
| Latency | Higher | Lower |
| Control | Limited | Full |
| Setup Complexity | Simple (pub.dev) | Complex (native build) |

## Known Issues with record Package

From testing logs:
- Mono recording: Only 2.4 KB in 5.9s (3.1% of expected)
- Stereo recording: Only 28.2 KB in 5.8s (36.1% of expected)
- Initial file size after 500ms: Often 0 bytes
- Inconsistent across devices

## Alternative Solutions (If RTAudio Doesn't Work)

If the native build is too complex or RTAudio still has issues:

### Option 1: Use pronunciation_practice_page's approach
- Check what's working there
- Copy that implementation

### Option 2: Native Windows Plugin
- Create custom FFI plugin using `win32` package
- Direct Windows Media Foundation API calls

### Option 3: Different Audio Package
- Try `flutter_sound` package
- Try `just_audio` with recording

### Option 4: External Tool
- Use Windows Sound Recorder via Process
- Capture output file

## Current Status

✅ **Complete**:
- Dart wrapper created
- C++ plugin files created
- Test page updated
- Documentation written

⚠️ **Incomplete**:
- CMakeLists.txt not updated
- Plugin not registered in main.cpp
- RTAudio source files not copied
- Native build not tested

❌ **Not Working Yet**:
- Cannot compile without build setup
- Cannot test until native integration complete

## Next Steps

1. **Complete build setup** (see steps above)
2. **Copy RTAudio source files**
3. **Update CMakeLists.txt**
4. **Register plugin**
5. **Clean and rebuild**
6. **Test recording**
7. **Debug if needed**

---

**Created:** 2026-03-11  
**Status:** Code written, build setup required  
**Priority:** HIGH - This is the most promising solution  
**Estimated Time:** 30-60 minutes for native build setup

