// lib/data/models/app_settings.dart
//
// Application Settings Model
//

import 'package:equatable/equatable.dart';

/// Application-level settings stored in SharedPreferences
class AppSettings extends Equatable {
  /// User's preferred UI language code (e.g., 'en', 'hu')
  final String userLanguageCode;

  /// User's preferred UI language name (e.g., 'English', 'Hungarian')
  final String userLanguageName;

  /// DeepL API key (optional)
  final String? deeplApiKey;

  /// OpenAI API key (optional)
  final String? openaiApiKey;

  const AppSettings({
    this.userLanguageCode = 'en-US',
    this.userLanguageName = 'English (United States)',
    this.deeplApiKey,
    this.openaiApiKey,
  });

  AppSettings copyWith({
    String? userLanguageCode,
    String? userLanguageName,
    String? deeplApiKey,
    String? openaiApiKey,
  }) {
    return AppSettings(
      userLanguageCode: userLanguageCode ?? this.userLanguageCode,
      userLanguageName: userLanguageName ?? this.userLanguageName,
      deeplApiKey: deeplApiKey ?? this.deeplApiKey,
      openaiApiKey: openaiApiKey ?? this.openaiApiKey,
    );
  }

  @override
  List<Object?> get props => [
        userLanguageCode,
        userLanguageName,
        deeplApiKey,
        openaiApiKey,
      ];
}

