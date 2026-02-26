// lib/core/services/ai_service.dart
//
// AI Service - OpenAI API Integration for Example Generation
//

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import '../../data/models/example_sentence.dart';
import 'service_error_messages.dart';

class AIService {
  final String? _apiKey;
  final ServiceErrorMessages? _errorMessages;
  static const String _baseUrl = 'https://api.openai.com/v1/chat/completions';

  AIService({String? apiKey, ServiceErrorMessages? errorMessages})
      : _apiKey = apiKey,
        _errorMessages = errorMessages;

  /// Generate example sentences using AI
  ///
  /// [text] - The word/phrase to generate examples for
  /// [language1Name] - Name of the first language (e.g., 'English')
  /// [language2Name] - Name of the second language (e.g., 'Spanish')
  /// [language1Code] - Code of the first language (e.g., 'en-US')
  /// [language2Code] - Code of the second language (e.g., 'es-ES')
  ///
  /// Returns list of example sentences or throws exception
  Future<List<ExampleSentence>> generateExamples({
    required String text,
    required String language1Name,
    required String language2Name,
    required String language1Code,
    required String language2Code,
  }) async {
    if (text.trim().isEmpty) {
      throw Exception(_errorMessages?.textCannotBeEmpty ?? 'Text cannot be empty');
    }

    final prompt = '''Help search for 1-3 practical example sentences using the word or phrase "$text" in $language1Name.

Requirements:
1. Examples should be natural, everyday sentences
2. Show different contexts and usage patterns
3. Keep sentences short and clear (max 15 words)
4. Provide accurate translations to $language2Name

Return ONLY a JSON array with this exact format:
[
  {
    "textLanguage1": "example sentence in $language1Name",
    "textLanguage2": "translation in $language2Name"
  }
]

Do not include any explanation, only the JSON array.''';

    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'model': 'gpt-3.5-turbo',
          'messages': [
            {
              'role': 'system',
              'content': 'You are a helpful language learning assistant that looks for practical example sentences based on the input provided. Always respond with valid JSON only.',
            },
            {
              'role': 'user',
              'content': prompt,
            }
          ],
          'temperature': 0.7,
          'max_tokens': 500,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final content = data['choices'][0]['message']['content'];

        // Extract JSON from response (sometimes it's wrapped in markdown)
        String jsonContent = content;
        if (content.contains('```json')) {
          final start = content.indexOf('[');
          final end = content.lastIndexOf(']') + 1;
          if (start >= 0 && end > start) {
            jsonContent = content.substring(start, end);
          }
        } else if (content.contains('```')) {
          final start = content.indexOf('[');
          final end = content.lastIndexOf(']') + 1;
          if (start >= 0 && end > start) {
            jsonContent = content.substring(start, end);
          }
        }

        final examples = json.decode(jsonContent) as List;
        const uuid = Uuid();
        return examples.map((e) => ExampleSentence(
          id: uuid.v4(),
          textLanguage1: e['textLanguage1'] ?? '',
          textLanguage2: e['textLanguage2'] ?? '',
        )).toList();
      } else if (response.statusCode == 401) {
        throw Exception(_errorMessages?.invalidApiKeyConfigureOpenAI ?? 'Invalid API key. Please configure your OpenAI API key.');
      } else if (response.statusCode == 429) {
        throw Exception(_errorMessages?.apiRateLimitExceeded ?? 'API rate limit exceeded. Please try again later.');
      } else {
        throw Exception(_errorMessages?.aiRequestFailed(response.statusCode, response.body) ?? 'AI request failed: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      if (e.toString().contains('Invalid API key') || e.toString().contains('rate limit')) {
        rethrow;
      }
      if (e is FormatException) {
        throw Exception(_errorMessages?.failedToParseAiResponse ?? 'Failed to parse AI response. Please try again.');
      }
      throw Exception(_errorMessages?.aiGenerationError(e.toString()) ?? 'AI generation error: $e');
    }
  }

  /// Check if API key is configured
  bool isConfigured() {
    return _apiKey != null && _apiKey.isNotEmpty;
  }
}

