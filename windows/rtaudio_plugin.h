// windows/rtaudio_plugin.h
//
// RTAudio Plugin for Flutter on Windows
//
// This plugin provides access to RTAudio functionality from Dart code

#ifndef RTAUDIO_PLUGIN_H
#define RTAUDIO_PLUGIN_H

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <flutter/standard_method_codec.h>

#include <windows.h>
#include <mmdeviceapi.h>
#include <audioclient.h>
#include <mmsystem.h>   // for MCI

#include <memory>
#include <vector>
#include <atomic>
#include <string>
#include "RtAudio.h"

namespace language_rally {

class RtAudioPlugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows* registrar);

  RtAudioPlugin();
  virtual ~RtAudioPlugin();

  // Prevent copying
  RtAudioPlugin(const RtAudioPlugin&) = delete;
  RtAudioPlugin& operator=(const RtAudioPlugin&) = delete;

 private:
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue>& method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

  // RTAudio instance
  std::unique_ptr<RtAudio> rtaudio_;

  // Recording state
  std::atomic<bool>    is_recording_{false};
  std::vector<int16_t> audio_buffer_;
  std::atomic<size_t>  callback_count_{0};
  std::atomic<size_t>  nonzero_count_{0};  // callbacks with actual audio

  // Recording parameters
  unsigned int sample_rate_   = 44100;
  unsigned int num_channels_  = 1;
  unsigned int buffer_frames_ = 512;
  float        gain_          = 3.0f;  // volume gain multiplier

  // Playback state (MCI)
  MCIDEVICEID  mci_device_id_ = 0;
  std::string  current_play_path_;

  // RTAudio callback
  static int RecordCallback(void* output_buffer, void* input_buffer,
                           unsigned int frames, double stream_time,
                           RtAudioStreamStatus status, void* user_data);

  // Safe stream stop with timeout (prevents UI freeze)
  void StopStreamSafe();

  // Method handlers
  void Initialize(std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void ListInputDevices(std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void StartRecording(const flutter::EncodableMap& args,
                     std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void StopRecording(std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void GetBufferSize(std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void PlayAudio(const flutter::EncodableMap& args,
                 std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void StopAudio(std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void Dispose(std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  // Direct WASAPI diagnostic – bypasses RTAudio entirely
  void TestDirectWasapi(const flutter::EncodableMap& args,
                        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace language_rally

#endif  // RTAUDIO_PLUGIN_H

