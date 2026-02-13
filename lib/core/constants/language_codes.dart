// lib/core/constants/language_codes.dart

/// Comprehensive list of language locale codes (e.g., 'en-US', 'hu-HU')
/// Using full locale codes for proper TTS pronunciation support
class LanguageCodes {
  static const Map<String, String> codes = {
    'en-US': 'English (United States)',
    'en-GB': 'English (United Kingdom)',
    'en-AU': 'English (Australia)',
    'en-CA': 'English (Canada)',
    'en-IN': 'English (India)',
    'es-ES': 'Spanish (Spain)',
    'es-MX': 'Spanish (Mexico)',
    'es-AR': 'Spanish (Argentina)',
    'de-DE': 'German (Germany)',
    'de-AT': 'German (Austria)',
    'de-CH': 'German (Switzerland)',
    'fr-FR': 'French (France)',
    'fr-CA': 'French (Canada)',
    'fr-BE': 'French (Belgium)',
    'it-IT': 'Italian (Italy)',
    'pt-PT': 'Portuguese (Portugal)',
    'pt-BR': 'Portuguese (Brazil)',
    'pl-PL': 'Polish (Poland)',
    'ru-RU': 'Russian (Russia)',
    'ja-JP': 'Japanese (Japan)',
    'ko-KR': 'Korean (Korea)',
    'zh-CN': 'Chinese (China)',
    'zh-TW': 'Chinese (Taiwan)',
    'ar-SA': 'Arabic (Saudi Arabia)',
    'ar-EG': 'Arabic (Egypt)',
    'nl-NL': 'Dutch (Netherlands)',
    'nl-BE': 'Dutch (Belgium)',
    'sv-SE': 'Swedish (Sweden)',
    'da-DK': 'Danish (Denmark)',
    'fi-FI': 'Finnish (Finland)',
    'no-NO': 'Norwegian (Norway)',
    'tr-TR': 'Turkish (Turkey)',
    'el-GR': 'Greek (Greece)',
    'cs-CZ': 'Czech (Czechia)',
    'ro-RO': 'Romanian (Romania)',
    'sk-SK': 'Slovak (Slovakia)',
    'uk-UA': 'Ukrainian (Ukraine)',
    'bg-BG': 'Bulgarian (Bulgaria)',
    'hr-HR': 'Croatian (Croatia)',
    'sr-RS': 'Serbian (Serbia)',
    'sl-SI': 'Slovenian (Slovenia)',
    'lt-LT': 'Lithuanian (Lithuania)',
    'lv-LV': 'Latvian (Latvia)',
    'et-EE': 'Estonian (Estonia)',
    'vi-VN': 'Vietnamese (Vietnam)',
    'th-TH': 'Thai (Thailand)',
    'id-ID': 'Indonesian (Indonesia)',
    'ms-MY': 'Malay (Malaysia)',
    'hi-IN': 'Hindi (India)',
    'bn-BD': 'Bengali (Bangladesh)',
    'ur-PK': 'Urdu (Pakistan)',
    'fa-IR': 'Persian (Iran)',
    'he-IL': 'Hebrew (Israel)',
    'hu-HU': 'Hungarian (Hungary)',
    'af-ZA': 'Afrikaans (South Africa)',
    'sq-AL': 'Albanian (Albania)',
    'am-ET': 'Amharic (Ethiopia)',
    'hy-AM': 'Armenian (Armenia)',
    'az-AZ': 'Azerbaijani (Azerbaijan)',
    'eu-ES': 'Basque (Spain)',
    'be-BY': 'Belarusian (Belarus)',
    'bs-BA': 'Bosnian (Bosnia and Herzegovina)',
    'ca-ES': 'Catalan (Spain)',
    'ka-GE': 'Georgian (Georgia)',
    'gu-IN': 'Gujarati (India)',
    'is-IS': 'Icelandic (Iceland)',
    'ga-IE': 'Irish (Ireland)',
    'kn-IN': 'Kannada (India)',
    'kk-KZ': 'Kazakh (Kazakhstan)',
    'km-KH': 'Khmer (Cambodia)',
    'ku-TR': 'Kurdish (Turkey)',
    'lo-LA': 'Lao (Laos)',
    'mk-MK': 'Macedonian (North Macedonia)',
    'ml-IN': 'Malayalam (India)',
    'mr-IN': 'Marathi (India)',
    'mn-MN': 'Mongolian (Mongolia)',
    'ne-NP': 'Nepali (Nepal)',
    'pa-IN': 'Punjabi (India)',
    'si-LK': 'Sinhala (Sri Lanka)',
    'sw-KE': 'Swahili (Kenya)',
    'ta-IN': 'Tamil (India)',
    'te-IN': 'Telugu (India)',
    'tl-PH': 'Tagalog (Philippines)',
    'uz-UZ': 'Uzbek (Uzbekistan)',
    'zu-ZA': 'Zulu (South Africa)',
  };

  /// Get language name from code
  static String? getLanguageName(String code) {
    return codes[code];
  }

  /// Get all language codes sorted alphabetically by name
  static List<MapEntry<String, String>> getSortedLanguages() {
    final entries = codes.entries.toList();
    entries.sort((a, b) => a.value.compareTo(b.value));
    return entries;
  }

  /// Search languages by name or code
  static List<MapEntry<String, String>> search(String query) {
    if (query.isEmpty) return getSortedLanguages();

    final lowerQuery = query.toLowerCase();
    return codes.entries
        .where((entry) =>
            entry.key.toLowerCase().contains(lowerQuery) ||
            entry.value.toLowerCase().contains(lowerQuery))
        .toList()
      ..sort((a, b) => a.value.compareTo(b.value));
  }
}

