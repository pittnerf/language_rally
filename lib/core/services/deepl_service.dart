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
    print('🌐 DeepL Translation Request:');
    print('  Source Language: $sourceLang');
    print('  Target Language: $targetLang');
    print('  Text: "$text"');
    print('  API Key configured: ${_apiKey != null && _apiKey.isNotEmpty}');

    if (_apiKey == null || _apiKey.isEmpty) {
      print('  ⚠️ No API key, skipping DeepL');
      return null;
    }

    if (text.trim().isEmpty) {
      print('  ⚠️ Text is empty, skipping DeepL');
      return null;
    }

    try {
      // Convert language codes to DeepL format (e.g., 'en-US' -> 'EN')
      // IMPORTANT: DeepL has different rules for source vs target languages:
      // - Target languages can have variants: EN-US, EN-GB, PT-BR, PT-PT
      // - Source languages CANNOT have variants: EN (not EN-GB), PT (not PT-BR)
      final targetLangCode = _normalizeLanguageCode(targetLang);
      final sourceLangCode = sourceLang != null ? _normalizeSourceLanguageCode(sourceLang) : null;

      print('  Normalized Target: $targetLangCode');
      print('  Normalized Source: $sourceLangCode');

      final body = {
        'text': text,
        'target_lang': targetLangCode,
      };

      if (sourceLangCode != null) {
        body['source_lang'] = sourceLangCode;
      }

      print('  📤 Sending request to DeepL...');
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Authorization': 'DeepL-Auth-Key $_apiKey',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: body,
      );

      print('  Status Code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final translations = data['translations'] as List;
        if (translations.isNotEmpty) {
          final translated = translations[0]['text'];
          print('  📥 DeepL Response: "$translated"');
          print('  ✅ Translation successful');
          return translated;
        }
      } else {
        print('  ❌ DeepL failed with status ${response.statusCode}');
        print('  Response: ${response.body}');
      }

      return null;
    } catch (e) {
      // If DeepL fails, return null so caller can try OpenAI
      print('  ❌ DeepL error: $e');
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

  /// Normalize language code to DeepL format for TARGET languages
  /// Examples: 'en-US' -> 'EN-US', 'en-GB' -> 'EN-GB', 'de-DE' -> 'DE', 'pt-BR' -> 'PT-BR'
  /// Target languages CAN have regional variants (EN-US, EN-GB, PT-BR, PT-PT)
  String _normalizeLanguageCode(String code) {
    // Handle special cases for target languages that support variants
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

  /// Normalize language code to DeepL format for SOURCE languages
  /// Examples: 'en-US' -> 'EN', 'en-GB' -> 'EN', 'de-DE' -> 'DE', 'pt-BR' -> 'PT'
  /// Source languages CANNOT have regional variants - DeepL only accepts base language codes
  String _normalizeSourceLanguageCode(String code) {
    // Always strip regional variants for source languages
    // DeepL does not support EN-GB, EN-US, PT-BR, PT-PT as source languages
    return code.split('-')[0].toUpperCase();
  }

  /// Check if API key is configured
  bool isConfigured() {
    return _apiKey != null && _apiKey.isNotEmpty;
  }
}

