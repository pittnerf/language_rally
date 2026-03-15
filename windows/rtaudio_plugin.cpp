// windows/rtaudio_plugin.cpp
#include "rtaudio_plugin.h"
#include <flutter/standard_message_codec.h>
#include <memory>
#include <sstream>
#include <cstring>
#include <algorithm>
#include <thread>
#include <future>
#include <chrono>

// Windows microphone permission headers
#include <windows.h>
#include <mmdeviceapi.h>
#include <audioclient.h>
#include <functiondiscoverykeys_devpkey.h>

#pragma comment(lib, "ole32.lib")
#pragma comment(lib, "oleaut32.lib")

namespace language_rally {

// Static registration
void RtAudioPlugin::RegisterWithRegistrar(flutter::PluginRegistrarWindows* registrar) {
  auto plugin = std::make_shared<RtAudioPlugin>();

  // Method channel
  auto method_channel =
      std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
          registrar->messenger(), "com.language_rally/rtaudio",
          &flutter::StandardMethodCodec::GetInstance());

  method_channel->SetMethodCallHandler(
      [plugin_pointer = plugin.get()](const auto& call, auto result) {
        plugin_pointer->HandleMethodCall(call, std::move(result));
      });


  // Don't use AddPlugin for non-Plugin derived classes
  // Just keep the plugin alive by storing it
  static auto plugin_instance = plugin;
}

RtAudioPlugin::RtAudioPlugin() {
  // Constructor
}

RtAudioPlugin::~RtAudioPlugin() {
  StopStreamSafe();
}

// Stop the stream safely with a timeout to prevent freezing
void RtAudioPlugin::StopStreamSafe() {
  if (!rtaudio_) return;
  is_recording_.store(false);

  // Run abort/close on a background thread with a 3-second timeout
  auto future = std::async(std::launch::async, [this]() {
    try {
      if (rtaudio_->isStreamRunning()) rtaudio_->abortStream();
      if (rtaudio_->isStreamOpen())    rtaudio_->closeStream();
    } catch (...) {}
  });

  if (future.wait_for(std::chrono::seconds(3)) == std::future_status::timeout) {
    // Timeout - stream is stuck, just reset the rtaudio instance
    // The destructor of RtAudio itself may also hang but we can't do much about it
  }
}

void RtAudioPlugin::HandleMethodCall(
    const flutter::MethodCall<flutter::EncodableValue>& method_call,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

  const std::string& method = method_call.method_name();

  if (method == "initialize") {
    Initialize(std::move(result));
  } else if (method == "listInputDevices") {
    ListInputDevices(std::move(result));
  } else if (method == "startRecording") {
    const auto* arguments = std::get_if<flutter::EncodableMap>(method_call.arguments());
    if (arguments) {
      StartRecording(*arguments, std::move(result));
    } else {
      result->Error("INVALID_ARGUMENTS", "Arguments must be a map");
    }
  } else if (method == "stopRecording") {
    StopRecording(std::move(result));
  } else if (method == "getBufferSize") {
    GetBufferSize(std::move(result));
  } else if (method == "playAudio") {
    const auto* arguments = std::get_if<flutter::EncodableMap>(method_call.arguments());
    if (arguments) {
      PlayAudio(*arguments, std::move(result));
    } else {
      result->Error("INVALID_ARGUMENTS", "Arguments must be a map");
    }
  } else if (method == "stopAudio") {
    StopAudio(std::move(result));
  } else if (method == "dispose") {
    Dispose(std::move(result));
  } else if (method == "testDirectWasapi") {
    const auto* arguments = std::get_if<flutter::EncodableMap>(method_call.arguments());
    flutter::EncodableMap emptyMap;
    TestDirectWasapi(arguments ? *arguments : emptyMap, std::move(result));
  } else {
    result->NotImplemented();
  }
}

void RtAudioPlugin::Initialize(
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  try {
    // --- Request microphone permission via Windows WASAPI ---
    // This opens the mic briefly via COM to trigger the Windows privacy check.
    // Without this, Windows 10/11 privacy settings may block microphone access
    // for Win32 apps even if globally allowed.
    HRESULT hr = CoInitializeEx(nullptr, COINIT_APARTMENTTHREADED);
    bool co_initialized = SUCCEEDED(hr) || hr == RPC_E_CHANGED_MODE;

    IMMDeviceEnumerator* enumerator = nullptr;
    hr = CoCreateInstance(__uuidof(MMDeviceEnumerator), nullptr,
                          CLSCTX_ALL, __uuidof(IMMDeviceEnumerator),
                          reinterpret_cast<void**>(&enumerator));

    if (SUCCEEDED(hr) && enumerator) {
      IMMDevice* device = nullptr;
      hr = enumerator->GetDefaultAudioEndpoint(eCapture, eConsole, &device);
      if (SUCCEEDED(hr) && device) {
        // Activate IAudioClient - this is the call that triggers the
        // Windows microphone permission prompt if not yet granted
        IAudioClient* audio_client = nullptr;
        hr = device->Activate(__uuidof(IAudioClient), CLSCTX_ALL,
                              nullptr, reinterpret_cast<void**>(&audio_client));
        if (SUCCEEDED(hr) && audio_client) {
          audio_client->Release();
          // mic_permission_ok = true
        }
        device->Release();
      }
      enumerator->Release();
    }

    if (co_initialized && hr != RPC_E_CHANGED_MODE) {
      CoUninitialize();
    }
    // --- End permission request ---

    // Now create RTAudio with WASAPI
    rtaudio_ = std::make_unique<RtAudio>(RtAudio::WINDOWS_WASAPI);
    result->Success(flutter::EncodableValue(true));
  } catch (const std::exception& e) {
    result->Error("RTAUDIO_ERROR", e.what());
  }
}

void RtAudioPlugin::ListInputDevices(
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!rtaudio_) { result->Error("NOT_INITIALIZED", "RTAudio not initialized"); return; }
  try {
    flutter::EncodableList devices_list;
    std::vector<unsigned int> device_ids = rtaudio_->getDeviceIds();
    unsigned int default_input = rtaudio_->getDefaultInputDevice();

    for (unsigned int device_id : device_ids) {
      RtAudio::DeviceInfo info = rtaudio_->getDeviceInfo(device_id);
      if (info.inputChannels > 0) {
        unsigned int preferred_rate = info.preferredSampleRate;
        if (preferred_rate == 0 && !info.sampleRates.empty())
          preferred_rate = info.sampleRates.back();

        flutter::EncodableMap device_map;
        device_map[flutter::EncodableValue("id")]               = flutter::EncodableValue(static_cast<int>(device_id));
        device_map[flutter::EncodableValue("name")]             = flutter::EncodableValue(info.name);
        device_map[flutter::EncodableValue("maxInputChannels")] = flutter::EncodableValue(static_cast<int>(info.inputChannels));
        device_map[flutter::EncodableValue("maxOutputChannels")]= flutter::EncodableValue(static_cast<int>(info.outputChannels));
        device_map[flutter::EncodableValue("isDefaultInput")]   = flutter::EncodableValue(device_id == default_input);
        device_map[flutter::EncodableValue("preferredSampleRate")] = flutter::EncodableValue(static_cast<int>(preferred_rate));
        flutter::EncodableList rates;
        for (unsigned int r : info.sampleRates)
          rates.push_back(flutter::EncodableValue(static_cast<int>(r)));
        device_map[flutter::EncodableValue("sampleRates")] = flutter::EncodableValue(rates);
        devices_list.push_back(flutter::EncodableValue(device_map));
      }
    }
    result->Success(flutter::EncodableValue(devices_list));
  } catch (const std::exception& e) {
    result->Error("RTAUDIO_ERROR", e.what());
  }
}

// Callback receives FLOAT32 data from WASAPI and converts to SINT16
int RtAudioPlugin::RecordCallback(void* /*output_buffer*/, void* input_buffer,
                                   unsigned int frames, double /*stream_time*/,
                                   RtAudioStreamStatus /*status*/, void* user_data) {
  RtAudioPlugin* plugin = static_cast<RtAudioPlugin*>(user_data);
  if (!plugin->is_recording_.load()) return 0;
  if (!input_buffer || frames == 0) return 0;

  plugin->callback_count_.fetch_add(1);

  const unsigned int samples = frames * plugin->num_channels_;
  float* f_buf = static_cast<float*>(input_buffer);

  // Check if this callback has any non-zero (real) audio
  bool has_signal = false;
  for (unsigned int i = 0; i < samples && !has_signal; i++) {
    if (f_buf[i] > 0.0001f || f_buf[i] < -0.0001f) has_signal = true;
  }
  if (has_signal) plugin->nonzero_count_.fetch_add(1);

  // Reserve to avoid reallocations inside callback
  if (plugin->audio_buffer_.size() + samples > plugin->audio_buffer_.capacity()) {
    plugin->audio_buffer_.reserve(plugin->audio_buffer_.capacity() + plugin->sample_rate_ * plugin->num_channels_ * 10);
  }

  // Convert float [-1.0, 1.0] -> int16 with configurable gain boost
  const float gain = plugin->gain_;
  for (unsigned int i = 0; i < samples; i++) {
    float s = f_buf[i] * gain;
    if (s >  1.0f) s =  1.0f;
    if (s < -1.0f) s = -1.0f;
    plugin->audio_buffer_.push_back(static_cast<int16_t>(s * 32767.0f));
  }

  return 0;
}

void RtAudioPlugin::StartRecording(
    const flutter::EncodableMap& args,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

  if (!rtaudio_) { result->Error("NOT_INITIALIZED", "RTAudio not initialized"); return; }
  if (is_recording_.load()) { result->Error("ALREADY_RECORDING", "Already recording"); return; }

  // Close any previously open stream first
  if (rtaudio_->isStreamOpen()) {
    try { rtaudio_->closeStream(); } catch (...) {}
  }

  // IMPORTANT: Recreate the RTAudio instance before each recording.
  // The WASAPI session obtained during listInputDevices can become stale,
  // causing the callback thread to never start. A fresh instance guarantees
  // a clean WASAPI handle.
  try { rtaudio_.reset(); } catch (...) {}
  try {
    rtaudio_ = std::make_unique<RtAudio>(RtAudio::WINDOWS_WASAPI);
  } catch (const std::exception& e) {
    result->Error("RTAUDIO_REINIT_ERROR", e.what());
    return;
  }

  try {
    int device_id      = std::get<int>(args.at(flutter::EncodableValue("deviceId")));
    int requested_rate = std::get<int>(args.at(flutter::EncodableValue("sampleRate")));
    num_channels_      = static_cast<unsigned int>(std::get<int>(args.at(flutter::EncodableValue("numChannels"))));

    // Optional gain multiplier (default 3.0)
    auto gain_it = args.find(flutter::EncodableValue("gainMultiplier"));
    if (gain_it != args.end()) {
      if (auto* d = std::get_if<double>(&gain_it->second)) gain_ = static_cast<float>(*d);
    }

    RtAudio::DeviceInfo info = rtaudio_->getDeviceInfo(static_cast<unsigned int>(device_id));

    // Find device preferred (native WASAPI shared-mode) rate
    unsigned int native_rate = info.preferredSampleRate;
    if (native_rate == 0 && !info.sampleRates.empty()) {
      native_rate = info.sampleRates.back(); // highest supported
    }
    if (native_rate == 0) native_rate = static_cast<unsigned int>(requested_rate);

    // Clamp channels to device max
    if (num_channels_ > info.inputChannels && info.inputChannels > 0)
      num_channels_ = info.inputChannels;

    buffer_frames_ = 512;
    audio_buffer_.clear();
    callback_count_.store(0);
    nonzero_count_.store(0);

    RtAudio::StreamParameters params;
    params.deviceId     = static_cast<unsigned int>(device_id);
    params.nChannels    = num_channels_;
    params.firstChannel = 0;

    RtAudioErrorType error = RTAUDIO_NO_ERROR;
    bool opened = false;

    // Strategy 1: If requested rate differs from native, try exclusive mode
    // (RTAUDIO_HOG_DEVICE) which allows arbitrary sample rates.
    if (static_cast<unsigned int>(requested_rate) != native_rate) {
      RtAudio::StreamOptions excl_opts;
      excl_opts.flags         = RTAUDIO_HOG_DEVICE;
      excl_opts.numberOfBuffers = 2;
      unsigned int excl_frames = buffer_frames_;
      sample_rate_ = static_cast<unsigned int>(requested_rate);
      audio_buffer_.reserve(sample_rate_ * num_channels_ * 30);

      error = rtaudio_->openStream(
          nullptr, &params, RTAUDIO_FLOAT32,
          sample_rate_, &excl_frames,
          &RecordCallback, this, &excl_opts);

      if (error == RTAUDIO_NO_ERROR) {
        buffer_frames_ = excl_frames;
        opened = true;
        // exclusive mode opened successfully at requested rate
      } else {
        // Exclusive mode failed - recreate RTAudio and fall through to shared mode
        try { rtaudio_.reset(); } catch (...) {}
        try { rtaudio_ = std::make_unique<RtAudio>(RtAudio::WINDOWS_WASAPI); }
        catch (...) {}
        audio_buffer_.clear();
      }
    }

    // Strategy 2: Shared mode at native rate (always works)
    if (!opened) {
      sample_rate_ = native_rate;
      audio_buffer_.reserve(sample_rate_ * num_channels_ * 30);
      unsigned int shared_frames = buffer_frames_;

      error = rtaudio_->openStream(
          nullptr, &params, RTAUDIO_FLOAT32,
          sample_rate_, &shared_frames,
          &RecordCallback, this, nullptr);

      if (error == RTAUDIO_NO_ERROR) {
        buffer_frames_ = shared_frames;
        opened = true;
      }
    }

    if (!opened || error != RTAUDIO_NO_ERROR) {
      result->Error("RTAUDIO_OPEN_ERROR", rtaudio_->getErrorText());
      return;
    }

    error = rtaudio_->startStream();
    if (error != RTAUDIO_NO_ERROR) {
      try { rtaudio_->closeStream(); } catch (...) {}
      result->Error("RTAUDIO_START_ERROR", rtaudio_->getErrorText());
      return;
    }

    is_recording_.store(true);

    flutter::EncodableMap response;
    response[flutter::EncodableValue("success")]          = flutter::EncodableValue(true);
    response[flutter::EncodableValue("actualSampleRate")] = flutter::EncodableValue(static_cast<int>(sample_rate_));
    response[flutter::EncodableValue("actualChannels")]   = flutter::EncodableValue(static_cast<int>(num_channels_));
    response[flutter::EncodableValue("bufferFrames")]     = flutter::EncodableValue(static_cast<int>(buffer_frames_));
    result->Success(flutter::EncodableValue(response));

  } catch (const std::exception& e) {
    result->Error("RTAUDIO_ERROR", e.what());
  } catch (...) {
    result->Error("RTAUDIO_ERROR", "Unknown error starting recording");
  }
}

void RtAudioPlugin::StopRecording(
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

  if (!is_recording_.load()) {
    result->Success(flutter::EncodableValue(std::vector<uint8_t>()));
    return;
  }

  // Signal callback to stop immediately
  is_recording_.store(false);

  // Stop stream on background thread with timeout to prevent UI freeze
  auto stop_future = std::async(std::launch::async, [this]() -> bool {
    try {
      if (rtaudio_ && rtaudio_->isStreamRunning()) rtaudio_->abortStream();
      if (rtaudio_ && rtaudio_->isStreamOpen())    rtaudio_->closeStream();
      return true;
    } catch (...) {
      return false;
    }
  });

  // Wait up to 2 seconds, then continue regardless
  stop_future.wait_for(std::chrono::seconds(2));

  // Convert int16 buffer to bytes
  std::vector<uint8_t> byte_data(audio_buffer_.size() * sizeof(int16_t));
  if (!audio_buffer_.empty()) {
    std::memcpy(byte_data.data(), audio_buffer_.data(), byte_data.size());
  }

  result->Success(flutter::EncodableValue(byte_data));
}

void RtAudioPlugin::GetBufferSize(
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  flutter::EncodableMap info;
  info[flutter::EncodableValue("byteSize")]      = flutter::EncodableValue(static_cast<int>(audio_buffer_.size() * sizeof(int16_t)));
  info[flutter::EncodableValue("callbackCount")] = flutter::EncodableValue(static_cast<int>(callback_count_.load()));
  info[flutter::EncodableValue("nonzeroCount")]  = flutter::EncodableValue(static_cast<int>(nonzero_count_.load()));
  info[flutter::EncodableValue("sampleRate")]    = flutter::EncodableValue(static_cast<int>(sample_rate_));
  info[flutter::EncodableValue("channels")]      = flutter::EncodableValue(static_cast<int>(num_channels_));
  result->Success(flutter::EncodableValue(info));
}

void RtAudioPlugin::PlayAudio(
    const flutter::EncodableMap& args,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

  auto path_it = args.find(flutter::EncodableValue("path"));
  if (path_it == args.end()) {
    result->Error("INVALID_ARGUMENTS", "Missing 'path'");
    return;
  }
  const std::string& path = std::get<std::string>(path_it->second);

  // Close any previously open MCI device
  if (mci_device_id_ != 0) {
    mciSendCommand(mci_device_id_, MCI_STOP, 0, 0);
    mciSendCommand(mci_device_id_, MCI_CLOSE, 0, 0);
    mci_device_id_ = 0;
  }

  // Open the WAV file with MCI
  MCI_OPEN_PARMSA open_params = {};
  open_params.lpstrDeviceType  = "waveaudio";
  open_params.lpstrElementName = path.c_str();

  MCIERROR err = mciSendCommandA(0, MCI_OPEN,
      MCI_OPEN_TYPE | MCI_OPEN_ELEMENT,
      reinterpret_cast<DWORD_PTR>(&open_params));

  if (err != 0) {
    char errBuf[256] = {};
    mciGetErrorStringA(err, errBuf, sizeof(errBuf));
    result->Error("MCI_OPEN_ERROR", errBuf);
    return;
  }

  mci_device_id_    = open_params.wDeviceID;
  current_play_path_ = path;

  // Play the file (non-blocking - MCI_NOTIFY would call a window proc,
  // we just fire-and-forget here; Dart polls isPlaying via getPlaybackState)
  MCI_PLAY_PARMS play_params = {};
  play_params.dwCallback = 0;

  err = mciSendCommand(mci_device_id_, MCI_PLAY, 0,
                       reinterpret_cast<DWORD_PTR>(&play_params));
  if (err != 0) {
    char errBuf[256] = {};
    mciGetErrorStringA(err, errBuf, sizeof(errBuf));
    mciSendCommand(mci_device_id_, MCI_CLOSE, 0, 0);
    mci_device_id_ = 0;
    result->Error("MCI_PLAY_ERROR", errBuf);
    return;
  }

  result->Success(flutter::EncodableValue(true));
}

void RtAudioPlugin::StopAudio(
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (mci_device_id_ != 0) {
    mciSendCommand(mci_device_id_, MCI_STOP, 0, 0);
    mciSendCommand(mci_device_id_, MCI_CLOSE, 0, 0);
    mci_device_id_ = 0;
  }
  result->Success(flutter::EncodableValue(true));
}

void RtAudioPlugin::Dispose(
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  StopStreamSafe();
  if (mci_device_id_ != 0) {
    mciSendCommand(mci_device_id_, MCI_STOP, 0, 0);
    mciSendCommand(mci_device_id_, MCI_CLOSE, 0, 0);
    mci_device_id_ = 0;
  }
  rtaudio_.reset();
  audio_buffer_.clear();
  result->Success(flutter::EncodableValue(nullptr));
}

// ── Direct WASAPI diagnostic (no RTAudio) ─────────────────────────────────
//
// Opens the specified (or default) capture device directly via IAudioCaptureClient,
// records ~200 ms, and reports:
//   - deviceName, formatTag, sampleRate, channels, bitsPerSample
//   - totalFrames, nonZeroFrames, silentFlagSeen
// This lets us distinguish between "WASAPI itself is silent" vs "RTAudio bug".
void RtAudioPlugin::TestDirectWasapi(
    const flutter::EncodableMap& args,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

  HRESULT hr;
  bool co_init = false;
  hr = CoInitializeEx(nullptr, COINIT_APARTMENTTHREADED);
  if (SUCCEEDED(hr)) co_init = true;
  else if (hr == RPC_E_CHANGED_MODE) co_init = false; // already init'd, don't uninit

  IMMDeviceEnumerator* enumerator = nullptr;
  IMMDevice*           device     = nullptr;
  IAudioClient*        client     = nullptr;
  IAudioCaptureClient* capture    = nullptr;
  WAVEFORMATEX*        pwfx       = nullptr;

  flutter::EncodableMap res;
  res[flutter::EncodableValue("ok")] = flutter::EncodableValue(false);

  auto cleanup = [&]() {
    if (capture)    { capture->Release();    capture    = nullptr; }
    if (client)     { client->Release();     client     = nullptr; }
    if (device)     { device->Release();     device     = nullptr; }
    if (enumerator) { enumerator->Release(); enumerator = nullptr; }
    if (pwfx)       { CoTaskMemFree(pwfx);   pwfx       = nullptr; }
    if (co_init)    CoUninitialize();
  };

  hr = CoCreateInstance(__uuidof(MMDeviceEnumerator), nullptr,
                        CLSCTX_ALL, __uuidof(IMMDeviceEnumerator),
                        reinterpret_cast<void**>(&enumerator));
  if (FAILED(hr)) {
    res[flutter::EncodableValue("error")] = flutter::EncodableValue(std::string("CoCreateInstance(MMDeviceEnumerator) failed: ") + std::to_string(hr));
    cleanup(); result->Success(flutter::EncodableValue(res)); return;
  }

  // Prefer the device ID passed in; fall back to default capture device
  auto id_it = args.find(flutter::EncodableValue("deviceWasapiId"));
  if (id_it != args.end()) {
    if (const auto* sid = std::get_if<std::string>(&id_it->second)) {
      std::wstring wid(sid->begin(), sid->end());
      hr = enumerator->GetDevice(wid.c_str(), &device);
    }
  }
  if (!device) {
    hr = enumerator->GetDefaultAudioEndpoint(eCapture, eConsole, &device);
  }
  if (FAILED(hr) || !device) {
    res[flutter::EncodableValue("error")] = flutter::EncodableValue(std::string("GetDefaultAudioEndpoint failed: ") + std::to_string(hr));
    cleanup(); result->Success(flutter::EncodableValue(res)); return;
  }

  // Get device friendly name
  IPropertyStore* props = nullptr;
  std::string device_name = "(unknown)";
  if (SUCCEEDED(device->OpenPropertyStore(STGM_READ, &props))) {
    PROPVARIANT pv; PropVariantInit(&pv);
    if (SUCCEEDED(props->GetValue(PKEY_Device_FriendlyName, &pv)) && pv.pwszVal) {
      int n = WideCharToMultiByte(CP_UTF8, 0, pv.pwszVal, -1, nullptr, 0, nullptr, nullptr);
      if (n > 0) { std::string s(n - 1, '\0'); WideCharToMultiByte(CP_UTF8, 0, pv.pwszVal, -1, &s[0], n, nullptr, nullptr); device_name = s; }
    }
    PropVariantClear(&pv);
    props->Release();
  }
  res[flutter::EncodableValue("deviceName")] = flutter::EncodableValue(device_name);

  hr = device->Activate(__uuidof(IAudioClient), CLSCTX_ALL, nullptr, reinterpret_cast<void**>(&client));
  if (FAILED(hr)) {
    res[flutter::EncodableValue("error")] = flutter::EncodableValue(std::string("Activate(IAudioClient) failed: ") + std::to_string(hr));
    cleanup(); result->Success(flutter::EncodableValue(res)); return;
  }

  hr = client->GetMixFormat(&pwfx);
  if (FAILED(hr)) {
    res[flutter::EncodableValue("error")] = flutter::EncodableValue(std::string("GetMixFormat failed: ") + std::to_string(hr));
    cleanup(); result->Success(flutter::EncodableValue(res)); return;
  }

  // Log format details
  res[flutter::EncodableValue("formatTag")]     = flutter::EncodableValue(static_cast<int>(pwfx->wFormatTag));
  res[flutter::EncodableValue("sampleRate")]    = flutter::EncodableValue(static_cast<int>(pwfx->nSamplesPerSec));
  res[flutter::EncodableValue("channels")]      = flutter::EncodableValue(static_cast<int>(pwfx->nChannels));
  res[flutter::EncodableValue("bitsPerSample")] = flutter::EncodableValue(static_cast<int>(pwfx->wBitsPerSample));
  if (pwfx->wFormatTag == WAVE_FORMAT_EXTENSIBLE) {
    WAVEFORMATEXTENSIBLE* wfex = reinterpret_cast<WAVEFORMATEXTENSIBLE*>(pwfx);
    bool is_float = (wfex->SubFormat == KSDATAFORMAT_SUBTYPE_IEEE_FLOAT);
    bool is_pcm   = (wfex->SubFormat == KSDATAFORMAT_SUBTYPE_PCM);
    res[flutter::EncodableValue("subformat")] = flutter::EncodableValue(
        std::string(is_float ? "IEEE_FLOAT" : (is_pcm ? "PCM" : "OTHER")));
  }

  // Initialise in shared mode – use IAudioClient3 for low latency if available
  IAudioClient3* client3 = nullptr;
  client->QueryInterface(__uuidof(IAudioClient3), reinterpret_cast<void**>(&client3));

  if (client3) {
    UINT32 ignore, minPeriod;
    hr = client3->GetSharedModeEnginePeriod(pwfx, &ignore, &ignore, &minPeriod, &ignore);
    if (SUCCEEDED(hr)) {
      hr = client3->InitializeSharedAudioStream(AUDCLNT_STREAMFLAGS_EVENTCALLBACK, minPeriod, pwfx, nullptr);
    }
    client3->Release(); client3 = nullptr;
    if (FAILED(hr)) {
      // Fall back to regular Initialize
      hr = client->Initialize(AUDCLNT_SHAREMODE_SHARED, AUDCLNT_STREAMFLAGS_EVENTCALLBACK,
                              0, 0, pwfx, nullptr);
    }
  } else {
    hr = client->Initialize(AUDCLNT_SHAREMODE_SHARED, AUDCLNT_STREAMFLAGS_EVENTCALLBACK,
                            0, 0, pwfx, nullptr);
  }

  if (FAILED(hr)) {
    res[flutter::EncodableValue("error")] = flutter::EncodableValue(std::string("client->Initialize failed: ") + std::to_string(hr));
    cleanup(); result->Success(flutter::EncodableValue(res)); return;
  }

  hr = client->GetService(__uuidof(IAudioCaptureClient), reinterpret_cast<void**>(&capture));
  if (FAILED(hr)) {
    res[flutter::EncodableValue("error")] = flutter::EncodableValue(std::string("GetService(IAudioCaptureClient) failed: ") + std::to_string(hr));
    cleanup(); result->Success(flutter::EncodableValue(res)); return;
  }

  HANDLE hEvent = CreateEvent(nullptr, FALSE, FALSE, nullptr);
  if (!hEvent) {
    res[flutter::EncodableValue("error")] = flutter::EncodableValue(std::string("CreateEvent failed"));
    cleanup(); result->Success(flutter::EncodableValue(res)); return;
  }
  client->SetEventHandle(hEvent);
  hr = client->Start();
  if (FAILED(hr)) {
    CloseHandle(hEvent);
    res[flutter::EncodableValue("error")] = flutter::EncodableValue(std::string("client->Start failed: ") + std::to_string(hr));
    cleanup(); result->Success(flutter::EncodableValue(res)); return;
  }

  // Capture for ~300 ms
  DWORD deadline = GetTickCount() + 300;
  int64_t total_frames   = 0;
  int64_t nonzero_frames = 0;
  bool    silent_flag_seen = false;
  int     packet_count = 0;

  while (GetTickCount() < deadline) {
    WaitForSingleObject(hEvent, 20);

    UINT32 pkt_size = 0;
    capture->GetNextPacketSize(&pkt_size);
    while (pkt_size > 0) {
      BYTE*  data   = nullptr;
      UINT32 frames = 0;
      DWORD  flags  = 0;
      hr = capture->GetBuffer(&data, &frames, &flags, nullptr, nullptr);
      if (FAILED(hr)) break;

      if (flags & AUDCLNT_BUFFERFLAGS_SILENT) silent_flag_seen = true;

      total_frames += frames;
      const int bytes_per_frame = pwfx->nBlockAlign;
      // Check raw bytes for any non-zero content
      bool any_nonzero = false;
      for (UINT32 f = 0; f < frames && !any_nonzero; f++) {
        BYTE* frame_ptr = data + f * bytes_per_frame;
        for (int b = 0; b < bytes_per_frame; b++) {
          if (frame_ptr[b] != 0) { any_nonzero = true; break; }
        }
      }
      if (any_nonzero) nonzero_frames += frames;

      capture->ReleaseBuffer(frames);
      packet_count++;
      capture->GetNextPacketSize(&pkt_size);
    }
  }

  client->Stop();
  CloseHandle(hEvent);

  res[flutter::EncodableValue("ok")]             = flutter::EncodableValue(true);
  res[flutter::EncodableValue("totalFrames")]    = flutter::EncodableValue(static_cast<int>(total_frames));
  res[flutter::EncodableValue("nonZeroFrames")]  = flutter::EncodableValue(static_cast<int>(nonzero_frames));
  res[flutter::EncodableValue("silentFlagSeen")] = flutter::EncodableValue(silent_flag_seen);
  res[flutter::EncodableValue("packetCount")]    = flutter::EncodableValue(packet_count);

  cleanup();
  result->Success(flutter::EncodableValue(res));
}

}  // namespace language_rally

