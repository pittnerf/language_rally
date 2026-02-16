// lib/core/services/translation_service.dart
//
// Translation Service - Google Translate (free) and DeepL (with API key)
//

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'service_error_messages.dart';

class TranslationService {
  static const String _googleTranslateUrl = 'https://translate.googleapis.com/translate_a/single';
  static const String _deeplBaseUrl = 'https://api-free.deepl.com/v2/translate';

  final String? _deeplApiKey;
  final ServiceErrorMessages? _errorMessages;

  TranslationService({String? deeplApiKey, ServiceErrorMessages? errorMessages})
      : _deeplApiKey = deeplApiKey,
        _errorMessages = errorMessages;

  /// Translate text from source language to target language
  /// Uses Google Translate (free) by default, DeepL if API key is provided
  ///
  /// [text] - The text to translate
  /// [sourceLang] - Source language code (e.g., 'en-US')
  /// [targetLang] - Target language code (e.g., 'es-ES')
  ///
  /// Returns translated text or throws exception
  Future<String> translateText({
    required String text,
    required String sourceLang,
    required String targetLang,
  }) async {
    if (text.trim().isEmpty) {
      throw Exception(_errorMessages?.textCannotBeEmpty ?? 'Text cannot be empty');
    }

    // Use DeepL if API key is available, otherwise use Google Translate
    if (_deeplApiKey != null && _deeplApiKey.isNotEmpty) {
      return await _translateWithDeepL(text, sourceLang, targetLang);
    } else {
      return await _translateWithGoogle(text, sourceLang, targetLang);
    }
  }

  /// Translate using free Google Translate API
  Future<String> _translateWithGoogle(String text, String sourceLang, String targetLang) async {
    try {
      final sourceCode = _convertToGoogleCode(sourceLang);
      final targetCode = _convertToGoogleCode(targetLang);

      final url = Uri.parse(_googleTranslateUrl).replace(queryParameters: {
        'client': 'gtx',
        'sl': sourceCode,
        'tl': targetCode,
        'dt': 't',
        'q': text,
      });

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty && data[0] is List) {
          final translations = data[0] as List;
          final translatedText = translations.map((e) => e[0]).join('');
          return translatedText;
        } else {
          throw Exception(_errorMessages?.noTranslationReceivedFromGoogle ?? 'No translation received from Google');
        }
      } else {
        throw Exception(_errorMessages?.googleTranslationFailed(response.statusCode) ?? 'Google translation failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception(_errorMessages?.googleTranslationError(e.toString()) ?? 'Google translation error: $e');
    }
  }

  /// Translate using DeepL API (requires API key)
  Future<String> _translateWithDeepL(String text, String sourceLang, String targetLang) async {
    try {
      final sourceCode = _convertToDeepLCode(sourceLang);
      final targetCode = _convertToDeepLCode(targetLang);

      final response = await http.post(
        Uri.parse(_deeplBaseUrl),
        headers: {
          'Authorization': 'DeepL-Auth-Key $_deeplApiKey',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'text': text,
          'source_lang': sourceCode,
          'target_lang': targetCode,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['translations'] != null && data['translations'].isNotEmpty) {
          return data['translations'][0]['text'];
        } else {
          throw Exception(_errorMessages?.noTranslationReceivedFromDeepL ?? 'No translation received from DeepL');
        }
      } else if (response.statusCode == 403) {
        throw Exception(_errorMessages?.invalidDeepLApiKey ?? 'Invalid DeepL API key');
      } else if (response.statusCode == 456) {
        throw Exception(_errorMessages?.deeplTranslationQuotaExceeded ?? 'DeepL translation quota exceeded');
      } else {
        throw Exception(_errorMessages?.deeplTranslationFailed(response.statusCode) ?? 'DeepL translation failed: ${response.statusCode}');
      }
    } catch (e) {
      if (e.toString().contains('Invalid') || e.toString().contains('quota')) {
        rethrow;
      }
      throw Exception(_errorMessages?.deeplTranslationError(e.toString()) ?? 'DeepL translation error: $e');
    }
  }

  /// Convert language code to Google Translate format
  /// e.g., 'en-US' -> 'en', 'zh-CN' -> 'zh-CN'
  String _convertToGoogleCode(String languageCode) {
    final code = languageCode.toLowerCase();

    // Google special cases
    if (code.startsWith('zh-cn') || code == 'zh-hans') return 'zh-CN';
    if (code.startsWith('zh-tw') || code == 'zh-hant') return 'zh-TW';

    // For most languages, just use the language part (before hyphen)
    final parts = code.split('-');
    return parts[0];
  }

  /// Convert language code to DeepL format
  /// e.g., 'en-US' -> 'EN', 'es-ES' -> 'ES', 'pt-BR' -> 'PT-BR'
  String _convertToDeepLCode(String languageCode) {
    final code = languageCode.toUpperCase();

    // DeepL special cases
    if (code.startsWith('EN')) return 'EN';
    if (code.startsWith('PT-BR')) return 'PT-BR';
    if (code.startsWith('PT')) return 'PT-PT';

    // Extract the language part (before hyphen)
    final parts = code.split('-');
    return parts[0];
  }

  /// Check if using DeepL (with API key)
  bool isUsingDeepL() {
    return _deeplApiKey != null && _deeplApiKey.isNotEmpty;
  }

  /// Check if service is ready (always true since Google is free fallback)
  bool isConfigured() {
    return true; // Always configured (Google is free)
  }

  /// Get the name of the service being used
  String getServiceName() {
    return isUsingDeepL() ? 'DeepL' : 'Google Translate';
  }
}

