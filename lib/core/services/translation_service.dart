// lib/core/services/translation_service.dart
//
// Translation Service - Cascading fallback: DeepL Pro → DeepL Free → OpenAI → Google Translate
//

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'service_error_messages.dart';

class TranslationService {
  static const String _googleTranslateUrl = 'https://translate.googleapis.com/translate_a/single';
  static const String _deeplProUrl = 'https://api.deepl.com/v2/translate';
  static const String _deeplFreeUrl = 'https://api-free.deepl.com/v2/translate';
  static const String _openaiUrl = 'https://api.openai.com/v1/chat/completions';

  final String? _deeplApiKey;
  final String? _openaiApiKey;
  final ServiceErrorMessages? _errorMessages;

  TranslationService({
    String? deeplApiKey,
    String? openaiApiKey,
    ServiceErrorMessages? errorMessages,
  })  : _deeplApiKey = deeplApiKey,
        _openaiApiKey = openaiApiKey,
        _errorMessages = errorMessages;

  /// Translate text from source language to target language
  /// Cascading fallback order:
  /// 1. DeepL Pro (if API key provided)
  /// 2. DeepL Free (if API key provided and Pro fails)
  /// 3. OpenAI (if API key provided)
  /// 4. Google Translate (free, always available)
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

    final errors = <String>[];

    // 1. Try DeepL Pro (if API key available)
    if (_deeplApiKey != null && _deeplApiKey.isNotEmpty) {
      try {
        return await _translateWithDeepL(text, sourceLang, targetLang, _deeplProUrl);
      } catch (e) {
        errors.add('DeepL Pro: $e');

        // 2. Try DeepL Free endpoint
        try {
          return await _translateWithDeepL(text, sourceLang, targetLang, _deeplFreeUrl);
        } catch (e2) {
          errors.add('DeepL Free: $e2');
        }
      }
    }

    // 3. Try OpenAI (if API key available)
    if (_openaiApiKey != null && _openaiApiKey.isNotEmpty) {
      try {
        return await _translateWithOpenAI(text, sourceLang, targetLang);
      } catch (e) {
        errors.add('OpenAI: $e');
      }
    }

    // 4. Final fallback: Google Translate (always available)
    try {
      return await _translateWithGoogle(text, sourceLang, targetLang);
    } catch (e) {
      errors.add('Google Translate: $e');
      throw Exception('All translation services failed:\n${errors.join('\n')}');
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
  /// [baseUrl] - Either Pro or Free endpoint URL
  Future<String> _translateWithDeepL(String text, String sourceLang, String targetLang, String baseUrl) async {
    try {
      final sourceCode = _convertToDeepLCode(sourceLang);
      final targetCode = _convertToDeepLCode(targetLang);

      final response = await http.post(
        Uri.parse(baseUrl),
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

  /// Translate using OpenAI API (requires API key)
  Future<String> _translateWithOpenAI(String text, String sourceLang, String targetLang) async {
    try {
      final sourceLangName = _getLanguageName(sourceLang);
      final targetLangName = _getLanguageName(targetLang);

      final response = await http.post(
        Uri.parse(_openaiUrl),
        headers: {
          'Authorization': 'Bearer $_openaiApiKey',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'model': 'gpt-3.5-turbo',
          'messages': [
            {
              'role': 'system',
              'content': 'You are a professional translator. Translate the text accurately and naturally. Respond with ONLY the translation, no explanations.',
            },
            {
              'role': 'user',
              'content': 'Translate from $sourceLangName to $targetLangName:\n\n$text',
            }
          ],
          'temperature': 0.3,
          'max_tokens': 500,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final translation = data['choices'][0]['message']['content'].toString().trim();
        return translation;
      } else if (response.statusCode == 401) {
        throw Exception('Invalid OpenAI API key');
      } else if (response.statusCode == 429) {
        throw Exception('OpenAI rate limit exceeded');
      } else {
        throw Exception('OpenAI translation failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('OpenAI translation error: $e');
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

  /// Get human-readable language name from code for OpenAI
  String _getLanguageName(String languageCode) {
    final code = languageCode.toLowerCase();

    // Common language mappings
    final Map<String, String> languageMap = {
      'en': 'English',
      'es': 'Spanish',
      'fr': 'French',
      'de': 'German',
      'it': 'Italian',
      'pt': 'Portuguese',
      'ru': 'Russian',
      'ja': 'Japanese',
      'ko': 'Korean',
      'zh': 'Chinese',
      'ar': 'Arabic',
      'hi': 'Hindi',
      'nl': 'Dutch',
      'pl': 'Polish',
      'tr': 'Turkish',
      'sv': 'Swedish',
      'da': 'Danish',
      'no': 'Norwegian',
      'fi': 'Finnish',
      'hu': 'Hungarian',
      'cs': 'Czech',
      'ro': 'Romanian',
      'el': 'Greek',
      'he': 'Hebrew',
      'th': 'Thai',
      'vi': 'Vietnamese',
      'id': 'Indonesian',
      'uk': 'Ukrainian',
      'bg': 'Bulgarian',
      'hr': 'Croatian',
      'sk': 'Slovak',
    };

    final langCode = code.split('-')[0];
    return languageMap[langCode] ?? langCode.toUpperCase();
  }

  /// Check if using DeepL (with API key)
  bool isUsingDeepL() {
    return _deeplApiKey != null && _deeplApiKey.isNotEmpty;
  }

  /// Check if using OpenAI (with API key)
  bool isUsingOpenAI() {
    return _openaiApiKey != null && _openaiApiKey.isNotEmpty;
  }

  /// Check if service is ready (always true since Google is free fallback)
  bool isConfigured() {
    return true; // Always configured (Google is free)
  }

  /// Get the name of the primary service being used
  String getServiceName() {
    if (isUsingDeepL()) {
      return 'DeepL (Pro/Free)';
    } else if (isUsingOpenAI()) {
      return 'OpenAI + Google Translate';
    } else {
      return 'Google Translate';
    }
  }
}

