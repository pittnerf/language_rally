// windows/rtaudio_plugin_c_api.h
//
// C API wrapper for RTAudio plugin registration

#ifndef RTAUDIO_PLUGIN_C_API_H
#define RTAUDIO_PLUGIN_C_API_H

#include <flutter/plugin_registrar_windows.h>

#ifdef __cplusplus
extern "C" {
#endif

// Register the RTAudio plugin
void RtAudioPluginRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar);

#ifdef __cplusplus
}
#endif

#endif  // RTAUDIO_PLUGIN_C_API_H

