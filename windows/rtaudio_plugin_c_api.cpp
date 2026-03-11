// windows/rtaudio_plugin_c_api.cpp
//
// C API wrapper implementation

#include "rtaudio_plugin_c_api.h"
#include "rtaudio_plugin.h"
#include <flutter/plugin_registrar_windows.h>

void RtAudioPluginRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  language_rally::RtAudioPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}

