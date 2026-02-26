// lib/core/services/deepl_service.dart
//
// DeepL Translation Service
//

import 'dart:convert';
import 'package:http/http.dart' as http;

class DeepLService {
  final String? _apiKey;
  static const String _baseUrl = 'https://api.deepl.com/v2/translate';

  DeepLService({String? apiKey}) : _apiKey = apiKey;

  /// Translate text using DeepL API
  ///
  /// [text] - Text to translate
  /// [targetLang] - Target language code (e.g., 'EN', 'DE', 'HU')
  /// [sourceLang] - Source language code (optional, auto-detected if null)
  ///
  /// Returns translated text or null if translation fails
  Future<String?> translate({
    required String text,
    required String targetLang,
    String? sourceLang,
  }) async {
    if (_apiKey == null || _apiKey.isEmpty) {
      return null;
    }

    if (text.trim().isEmpty) {
      return null;
    }

    try {
      // Convert language codes to DeepL format (e.g., 'en-US' -> 'EN')
      final targetLangCode = _normalizeLanguageCode(targetLang);
      final sourceLangCode = sourceLang != null ? _normalizeLanguageCode(sourceLang) : null;

      final body = {
        'text': text,
        'target_lang': targetLangCode,
      };

      if (sourceLangCode != null) {
        body['source_lang'] = sourceLangCode;
      }

      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Authorization': 'DeepL-Auth-Key $_apiKey',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final translations = data['translations'] as List;
        if (translations.isNotEmpty) {
          return translations[0]['text'];
        }
      }

      return null;
    } catch (e) {
      // If DeepL fails, return null so caller can try OpenAI
      return null;
    }
  }

  /// Batch translate multiple texts
  Future<List<String?>> batchTranslate({
    required List<String> texts,
    required String targetLang,
    String? sourceLang,
  }) async {
    final results = <String?>[];

    for (final text in texts) {
      final translated = await translate(
        text: text,
        targetLang: targetLang,
        sourceLang: sourceLang,
      );
      results.add(translated);
    }

    return results;
  }

  /// Normalize language code to DeepL format
  /// Examples: 'en-US' -> 'EN', 'de-DE' -> 'DE', 'pt-BR' -> 'PT-BR'
  String _normalizeLanguageCode(String code) {
    // Handle special cases
    if (code.toLowerCase().startsWith('pt-br')) {
      return 'PT-BR';
    }
    if (code.toLowerCase().startsWith('pt-pt')) {
      return 'PT-PT';
    }
    if (code.toLowerCase().startsWith('en-gb')) {
      return 'EN-GB';
    }
    if (code.toLowerCase().startsWith('en-us')) {
      return 'EN-US';
    }

    // For most languages, just take the first part and uppercase
    return code.split('-')[0].toUpperCase();
  }

  /// Check if API key is configured
  bool isConfigured() {
    return _apiKey != null && _apiKey.isNotEmpty;
  }
}

