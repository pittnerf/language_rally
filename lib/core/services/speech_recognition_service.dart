// lib/core/services/speech_recognition_service.dart
//
// Speech Recognition Service - OpenAI Whisper API Integration
//
// Provides high-quality speech-to-text transcription using OpenAI's Whisper model
// Falls back to native platform speech recognition if API key is not available

import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/debug_print.dart';

class SpeechRecognitionService {
  final String? _apiKey;
  static const String _baseUrl = 'https://api.openai.com/v1/audio/transcriptions';

  SpeechRecognitionService({String? apiKey}) : _apiKey = apiKey;

  /// Check if OpenAI Whisper API is available
  bool get isWhisperAvailable {
    final key = _apiKey;
    return key != null && key.isNotEmpty;
  }

  /// Transcribe audio file using OpenAI Whisper API
  ///
  /// [audioFilePath] - Path to the audio file (supports m4a, mp3, mp4, mpeg, mpga, wav, webm)
  /// [language] - Optional: Language code (e.g., 'en', 'es', 'de') - helps accuracy
  /// [prompt] - Optional: Text prompt to guide the transcription (e.g., expected words)
  ///
  /// Returns the transcribed text or throws an exception
  Future<WhisperTranscriptionResult> transcribeAudio({
    required String audioFilePath,
    String? language,
    String? prompt,
  }) async {
    if (!isWhisperAvailable) {
      throw Exception('OpenAI API key not configured. Please add your API key in Settings.');
    }

    final audioFile = File(audioFilePath);
    if (!await audioFile.exists()) {
      throw Exception('Audio file not found: $audioFilePath');
    }

    try {
      // Create multipart request
      final request = http.MultipartRequest('POST', Uri.parse(_baseUrl));

      // Add headers
      request.headers['Authorization'] = 'Bearer $_apiKey';

      // Add audio file
      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          audioFilePath,
        ),
      );

      // Add model (whisper-1 is the only model currently available)
      request.fields['model'] = 'whisper-1';

      // Add optional language parameter
      if (language != null && language.isNotEmpty) {
        request.fields['language'] = language;
      }

      // Add optional prompt (helps with context and accuracy)
      if (prompt != null && prompt.isNotEmpty) {
        request.fields['prompt'] = prompt;
      }

      // Add response format (we want verbose for more details)
      request.fields['response_format'] = 'verbose_json';

      logDebug('🎙️ Sending audio to OpenAI Whisper API...');
      logDebug('   File size: ${await audioFile.length()} bytes');
      logDebug('   Language: ${language ?? "auto-detect"}');
      logDebug('   Prompt: ${prompt ?? "none"}');

      // Send request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      logDebug('📡 Whisper API response: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        logDebug('✓ Transcription successful');
        logDebug('   Text: ${data['text']}');
        logDebug('   Language: ${data['language'] ?? "unknown"}');
        logDebug('   Duration: ${data['duration'] ?? "unknown"}s');

        return WhisperTranscriptionResult(
          text: data['text'] ?? '',
          language: data['language'],
          duration: data['duration']?.toDouble(),
          segments: _parseSegments(data['segments']),
        );
      } else {
        // Handle errors
        final errorData = json.decode(response.body);
        final errorMessage = errorData['error']['message'] ?? 'Unknown error';
        final errorType = errorData['error']['type'] ?? 'unknown';

        logDebug('!!! Whisper API error: $errorMessage (type: $errorType)');

        if (response.statusCode == 401) {
          throw Exception('Invalid OpenAI API key. Please check your API key in Settings.');
        } else if (response.statusCode == 429) {
          throw Exception('OpenAI API rate limit exceeded. Please try again later.');
        } else if (response.statusCode == 413) {
          throw Exception('Audio file too large. Maximum size is 25MB.');
        } else {
          throw Exception('OpenAI Whisper API error: $errorMessage');
        }
      }
    } catch (e) {
      logDebug('!!! Exception during transcription: $e');
      rethrow;
    }
  }

  /// Parse segments from Whisper API response
  List<WhisperSegment>? _parseSegments(dynamic segmentsData) {
    if (segmentsData == null) return null;

    try {
      final segments = (segmentsData as List).map((segment) {
        return WhisperSegment(
          id: segment['id'],
          start: segment['start']?.toDouble() ?? 0.0,
          end: segment['end']?.toDouble() ?? 0.0,
          text: segment['text'] ?? '',
        );
      }).toList();

      return segments;
    } catch (e) {
      logDebug('Warning: Could not parse segments: $e');
      return null;
    }
  }

  /// Calculate confidence score by comparing transcribed text with expected text
  ///
  /// This is a simple implementation. For better accuracy, you might want to use
  /// phonetic comparison or edit distance algorithms.
  double calculateConfidence(String transcribedText, String expectedText) {
    final transcribed = transcribedText.toLowerCase().trim();
    final expected = expectedText.toLowerCase().trim();

    if (transcribed == expected) {
      return 1.0;
    }

    // Split into words
    final transcribedWords = transcribed.split(RegExp(r'\s+'));
    final expectedWords = expected.split(RegExp(r'\s+'));

    // Calculate word-level similarity
    int matchingWords = 0;
    for (final word in transcribedWords) {
      if (expectedWords.contains(word)) {
        matchingWords++;
      }
    }

    final maxWords = expectedWords.length > transcribedWords.length
        ? expectedWords.length
        : transcribedWords.length;

    if (maxWords == 0) return 0.0;

    return matchingWords / maxWords;
  }
}

/// Result from Whisper API transcription
class WhisperTranscriptionResult {
  final String text;
  final String? language;
  final double? duration;
  final List<WhisperSegment>? segments;

  WhisperTranscriptionResult({
    required this.text,
    this.language,
    this.duration,
    this.segments,
  });

  @override
  String toString() {
    return 'WhisperTranscriptionResult(text: "$text", language: $language, duration: ${duration}s)';
  }
}

/// Individual segment from Whisper API
class WhisperSegment {
  final int id;
  final double start;
  final double end;
  final String text;

  WhisperSegment({
    required this.id,
    required this.start,
    required this.end,
    required this.text,
  });

  @override
  String toString() {
    return 'Segment #$id: [$start-$end] "$text"';
  }
}

