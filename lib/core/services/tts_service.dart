// lib/core/services/tts_service.dart
//
// Text-to-Speech Service
//
// Provides text-to-speech functionality using:
// 1. Device native TTS (flutter_tts) - Primary method
// 2. Web-based TTS API (Google Translate TTS) - Fallback/alternative
//
// FEATURES:
// - Automatic language detection and configuration
// - Volume, pitch, and rate control
// - Error handling and fallback mechanisms
// - Support for multiple languages
//
// USAGE:
// final ttsService = TtsService();
// await ttsService.speak('Hello world', 'en-US');
//

import 'package:flutter_tts/flutter_tts.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class TtsService {
  static final TtsService _instance = TtsService._internal();
  factory TtsService() => _instance;
  TtsService._internal();

  final FlutterTts _flutterTts = FlutterTts();
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isInitialized = false;
  bool _isSpeaking = false;
  List<dynamic>? _availableVoices;

  /// Initialize the TTS service
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Configure flutter_tts
      await _flutterTts.setVolume(1.0);
      await _flutterTts.setSpeechRate(0.5);
      await _flutterTts.setPitch(1.0);

      // Set up handlers
      _flutterTts.setStartHandler(() {
        _isSpeaking = true;
      });

      _flutterTts.setCompletionHandler(() {
        _isSpeaking = false;
      });

      _flutterTts.setErrorHandler((msg) {
        _isSpeaking = false;
        // print('TTS Error: $msg');
      });

      _isInitialized = true;

      // Log available languages for debugging
      try {
        // final languages = await getAvailableLanguages();
        // print('TTS: ${languages.length} languages available on device');
        // print('TTS: Sample languages: ${languages.take(10).join(", ")}');

        // Try to get available voices
        try {
          final voices = await _flutterTts.getVoices;
          _availableVoices = voices;
          // print('TTS: ${voices.length} voices available');
          if (voices.isNotEmpty) {
            // Show sample voices
            // final sampleVoices = voices.take(5).map((v) => v['name']).join(', ');
            // print('TTS: Sample voices: $sampleVoices');
          }
        } catch (e) {
          // print('TTS: Could not get voices: $e');
        }
      } catch (e) {
        // print('TTS: Could not get available languages: $e');
      }
    } catch (e) {
      // print('TTS initialization error: $e');
    }
  }

  /// Speak text using device TTS
  Future<bool> speak(String text, String languageCode) async {
    if (text.isEmpty) return false;

    try {
      await initialize();
      await stop(); // Stop any ongoing speech

      // print('Speaking text in language: $languageCode');

      // On Windows, device TTS (SAPI) often doesn't switch languages correctly
      // even when setLanguage returns success. Web TTS is more reliable.
      // Try web TTS first for better multi-language support
      try {
        final webSuccess = await speakWebTts(text, languageCode);
        if (webSuccess) {
          // print('Web TTS succeeded for language: $languageCode');
          return true;
        }
      } catch (e) {
        // print('Web TTS failed: $e, trying device TTS');
      }

      // Fallback to device TTS
      // print('Attempting device TTS for language: $languageCode');

      // Try to find and set a voice for this language
      bool voiceSet = await _setVoiceForLanguage(languageCode);

      // Try to set language
      final result = await _flutterTts.setLanguage(languageCode);
      // print('setLanguage result: $result (1 = success), voice set: $voiceSet');

      if (result == 1 || voiceSet) {
        await _flutterTts.speak(text);
        return true;
      } else {
        // print('Device TTS failed for language: $languageCode');
        return false;
      }
    } catch (e) {
      // print('TTS speak error: $e');
      return false;
    }
  }

  /// Try to set a voice that supports the specified language
  Future<bool> _setVoiceForLanguage(String languageCode) async {
    try {
      if (_availableVoices == null) {
        final voices = await _flutterTts.getVoices;
        _availableVoices = voices;
      }

      if (_availableVoices != null && _availableVoices!.isNotEmpty) {
        // Extract base language code (e.g., 'en' from 'en-US')
        final baseLang = languageCode.split('-').first.toLowerCase();

        // Find a voice that matches this language
        for (var voice in _availableVoices!) {
          final voiceLang = (voice['locale'] as String?)?.toLowerCase() ?? '';
          final voiceName = voice['name'] as String? ?? '';

          if (voiceLang.startsWith(baseLang) || voiceName.toLowerCase().contains(baseLang)) {
            // print('Setting voice: ${voice['name']} for language: $languageCode');
            await _flutterTts.setVoice(voice);
            return true;
          }
        }

        // print('No voice found for language: $languageCode');
      }
    } catch (e) {
      // print('Error setting voice: $e');
    }
    return false;
  }

  /// Speak text using web-based TTS (Google Translate TTS API)
  /// This is a free public API that doesn't require authentication
  Future<bool> speakWebTts(String text, String languageCode) async {
    try {
      // Extract base language code for Google TTS
      // Examples: 'en-US' -> 'en', 'hu-HU' -> 'hu', 'de-DE' -> 'de'
      final lang = languageCode.split('-').first;

      // print('Web TTS: Using language code: $lang for text: ${text.substring(0, text.length > 30 ? 30 : text.length)}...');

      // Google Translate TTS API (unofficial but widely used)
      // Note: This is for educational purposes. For production, consider:
      // - Google Cloud Text-to-Speech API (requires API key)
      // - Amazon Polly (requires API key)
      // - Microsoft Azure TTS (requires API key)
      final url = Uri.parse(
        'https://translate.google.com/translate_tts?ie=UTF-8&client=tw-ob&tl=$lang&q=${Uri.encodeComponent(text)}'
      );

      // print('Fetching TTS audio from: $url');

      final response = await http.get(
        url,
        headers: {
          'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
        },
      );

      if (response.statusCode == 200) {
        // Save audio to temporary file
        final tempDir = await getTemporaryDirectory();
        final tempFile = File('${tempDir.path}/tts_${DateTime.now().millisecondsSinceEpoch}.mp3');
        await tempFile.writeAsBytes(response.bodyBytes);

        // Play audio
        await _audioPlayer.stop();
        await _audioPlayer.play(DeviceFileSource(tempFile.path));

        // Clean up temp file after a delay
        Future.delayed(const Duration(seconds: 10), () {
          if (tempFile.existsSync()) {
            tempFile.deleteSync();
          }
        });

        return true;
      } else {
        // print('Web TTS failed with status: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      // print('Web TTS error: $e');
      return false;
    }
  }

  /// Stop current speech
  Future<void> stop() async {
    try {
      await _flutterTts.stop();
      await _audioPlayer.stop();
      _isSpeaking = false;
    } catch (e) {
      // print('TTS stop error: $e');
    }
  }

  /// Check if currently speaking
  bool get isSpeaking => _isSpeaking;

  /// Set speech rate (0.0 to 1.0, default 0.5)
  Future<void> setSpeechRate(double rate) async {
    await _flutterTts.setSpeechRate(rate);
  }

  /// Set volume (0.0 to 1.0, default 1.0)
  Future<void> setVolume(double volume) async {
    await _flutterTts.setVolume(volume);
  }

  /// Set pitch (0.5 to 2.0, default 1.0)
  Future<void> setPitch(double pitch) async {
    await _flutterTts.setPitch(pitch);
  }

  /// Get available languages
  Future<List<String>> getAvailableLanguages() async {
    try {
      final languages = await _flutterTts.getLanguages;
      return languages.cast<String>();
    } catch (e) {
      // print('Error getting languages: $e');
      return [];
    }
  }

  /// Dispose resources
  void dispose() {
    _flutterTts.stop();
    _audioPlayer.dispose();
  }
}

