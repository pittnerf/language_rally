// lib/core/audio/rtaudio_recorder.dart
//
// RTAudio Recorder - Platform channel wrapper for RTAudio C++ library
//
// This class provides a Dart interface to the native RTAudio recording functionality

import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import '../utils/debug_print.dart';

class RtAudioDevice {
  final int id;
  final String name;
  final int maxInputChannels;
  final int maxOutputChannels;
  final bool isDefaultInput;
  final int preferredSampleRate;
  final List<int> sampleRates;

  RtAudioDevice({
    required this.id,
    required this.name,
    required this.maxInputChannels,
    required this.maxOutputChannels,
    required this.isDefaultInput,
    required this.preferredSampleRate,
    required this.sampleRates,
  });

  factory RtAudioDevice.fromMap(Map<dynamic, dynamic> map) {
    return RtAudioDevice(
      id: map['id'] as int,
      name: map['name'] as String,
      maxInputChannels: map['maxInputChannels'] as int,
      maxOutputChannels: map['maxOutputChannels'] as int,
      isDefaultInput: map['isDefaultInput'] as bool,
      preferredSampleRate: (map['preferredSampleRate'] as int?) ?? 44100,
      sampleRates: (map['sampleRates'] as List?)
              ?.map((e) => e as int)
              .toList() ??
          [44100],
    );
  }

  @override
  String toString() =>
      'RtAudioDevice{id: $id, name: $name, channels: $maxInputChannels, '
      'preferredRate: $preferredSampleRate}';
}

class RtAudioRecorder {
  static const MethodChannel _channel =
      MethodChannel('com.language_rally/rtaudio');

  bool _isRecording = false;
  bool _isInitialized = false;
  int _actualSampleRate = 44100;
  int _actualChannels = 1;

  int get actualSampleRate => _actualSampleRate;
  int get actualChannels => _actualChannels;

  /// Initialize RTAudio
  Future<bool> initialize() async {
    if (_isInitialized) return true;
    try {
      logDebug('Initializing RTAudio...');
      final result = await _channel.invokeMethod<bool>('initialize');
      _isInitialized = result ?? false;
      if (_isInitialized) {
        logDebug('✅ RTAudio initialized successfully');
      } else {
        logDebug('❌ RTAudio initialization failed');
      }
      return _isInitialized;
    } catch (e) {
      logDebug('❌ Error initializing RTAudio: $e');
      return false;
    }
  }

  /// Get list of available input devices
  Future<List<RtAudioDevice>> listInputDevices() async {
    try {
      logDebug('Listing RTAudio input devices...');
      final result = await _channel.invokeMethod<List>('listInputDevices');
      if (result == null) return [];

      final devices = result
          .map((device) => RtAudioDevice.fromMap(device as Map))
          .toList();

      logDebug('Found ${devices.length} RTAudio input device(s)');
      for (var device in devices) {
        logDebug('  - $device');
        logDebug('    Supported rates: ${device.sampleRates}');
      }
      return devices;
    } catch (e) {
      logDebug('❌ Error listing devices: $e');
      return [];
    }
  }

  /// Start recording audio
  Future<bool> startRecording({
    required int deviceId,
    required int sampleRate,
    required int numChannels,
    double gainMultiplier = 3.0,
  }) async {
    if (!_isInitialized) {
      logDebug('❌ RTAudio not initialized');
      return false;
    }
    if (_isRecording) {
      logDebug('⚠️ Already recording');
      return false;
    }

    try {
      logDebug('Starting RTAudio recording...');
      logDebug('  Device ID: $deviceId');
      logDebug('  Requested Sample Rate: $sampleRate Hz');
      logDebug('  Requested Channels: $numChannels');
      logDebug('  Gain multiplier: ${gainMultiplier.toStringAsFixed(1)}x');

      final result = await _channel.invokeMethod('startRecording', {
        'deviceId': deviceId,
        'sampleRate': sampleRate,
        'numChannels': numChannels,
        'gainMultiplier': gainMultiplier,
      });

      // startRecording now returns a map with actual params
      if (result is Map) {
        final success = result['success'] as bool? ?? false;
        if (success) {
          _actualSampleRate = result['actualSampleRate'] as int? ?? sampleRate;
          _actualChannels = result['actualChannels'] as int? ?? numChannels;
          final bufferFrames = result['bufferFrames'] as int? ?? 512;
          _isRecording = true;
          logDebug('✅ RTAudio recording started');
          logDebug('  Actual sample rate: $_actualSampleRate Hz');
          logDebug('  Actual channels: $_actualChannels');
          logDebug('  Buffer frames: $bufferFrames');
          return true;
        }
      } else if (result == true) {
        _isRecording = true;
        logDebug('✅ RTAudio recording started');
        return true;
      }

      logDebug('❌ Failed to start recording');
      return false;
    } catch (e) {
      logDebug('❌ Error starting recording: $e');
      return false;
    }
  }

  /// Stop recording and get audio data
  Future<Uint8List?> stopRecording() async {
    if (!_isRecording) {
      logDebug('⚠️ Not currently recording');
      return null;
    }
    try {
      logDebug('Stopping RTAudio recording...');
      final result = await _channel.invokeMethod<Uint8List>('stopRecording');
      _isRecording = false;
      logDebug('✅ Recording stopped');
      if (result == null || result.isEmpty) {
        logDebug('⚠️ No audio data captured');
        return null;
      }
      logDebug('  Total data: ${(result.length / 1024).toStringAsFixed(1)} KB');
      return result;
    } catch (e) {
      logDebug('❌ Error stopping recording: $e');
      _isRecording = false;
      return null;
    }
  }

  /// Returns buffer info map: {byteSize, callbackCount, sampleRate, channels}
  Future<Map<String, int>> getBufferInfo() async {
    try {
      final result = await _channel.invokeMethod('getBufferSize');
      if (result is Map) {
        return {
          'byteSize':      result['byteSize']      as int? ?? 0,
          'callbackCount': result['callbackCount'] as int? ?? 0,
          'nonzeroCount':  result['nonzeroCount']  as int? ?? 0,
          'sampleRate':    result['sampleRate']    as int? ?? 0,
          'channels':      result['channels']      as int? ?? 0,
        };
      }
      return {'byteSize': 0, 'callbackCount': 0, 'nonzeroCount': 0, 'sampleRate': 0, 'channels': 0};
    } catch (e) {
      return {'byteSize': 0, 'callbackCount': 0, 'nonzeroCount': 0, 'sampleRate': 0, 'channels': 0};
    }
  }

  // Keep old bufferSize getter for backwards compatibility
  Future<int> get bufferSize async {
    final info = await getBufferInfo();
    return info['byteSize'] ?? 0;
  }

  /// Play a WAV file using the native Windows MCI player (no threading errors)
  Future<bool> playAudio(String path) async {
    try {
      logDebug('▶️ Playing via MCI: $path');
      final result = await _channel.invokeMethod<bool>('playAudio', {'path': path});
      return result ?? false;
    } catch (e) {
      logDebug('❌ MCI playAudio error: $e');
      return false;
    }
  }

  /// Stop MCI playback and wait for OS to release the file handle
  Future<void> stopAudio() async {
    try {
      await _channel.invokeMethod('stopAudio');
      // Small delay to allow the OS to fully release the file handle
      await Future.delayed(const Duration(milliseconds: 100));
    } catch (e) {
      logDebug('❌ MCI stopAudio error: $e');
    }
  }

  /// Check if currently recording
  bool get isRecording => _isRecording;

  /// Dispose resources
  Future<void> dispose() async {
    // Stop playback first — MCI must release the file handle before
    // the caller tries to delete the temp WAV file.
    await stopAudio();
    if (_isRecording) await stopRecording();
    if (_isInitialized) {
      try {
        await _channel.invokeMethod('dispose');
        _isInitialized = false;
        logDebug('RTAudio disposed');
      } catch (e) {
        logDebug('Error disposing RTAudio: $e');
      }
    }
  }
}

