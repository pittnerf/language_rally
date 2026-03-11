// windows/rtaudio_plugin_registrar.cc
//
// RTAudio Plugin Registration

#include "rtaudio_plugin.h"
#include <flutter/plugin_registrar_windows.h>

void RegisterRtAudioPlugin(flutter::PluginRegistrarWindows* registrar) {
  language_rally::RtAudioPlugin::RegisterWithRegistrar(registrar);
}

