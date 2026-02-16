// lib/core/services/service_error_messages.dart
//
// Service Error Messages - Localized error messages for services
//

import '../../l10n/app_localizations.dart';

/// Wrapper class to provide localized error messages for services
class ServiceErrorMessages {
  final AppLocalizations l10n;

  ServiceErrorMessages(this.l10n);

  String get textCannotBeEmpty => l10n.textCannotBeEmpty;
  String get noTranslationReceivedFromGoogle => l10n.noTranslationReceivedFromGoogle;
  String googleTranslationFailed(int statusCode) => '${l10n.googleTranslationFailed}: $statusCode';
  String googleTranslationError(String error) => '${l10n.googleTranslationError}: $error';
  String get noTranslationReceivedFromDeepL => l10n.noTranslationReceivedFromDeepL;
  String get invalidDeepLApiKey => l10n.invalidDeepLApiKey;
  String get deeplTranslationQuotaExceeded => l10n.deeplTranslationQuotaExceeded;
  String deeplTranslationFailed(int statusCode) => '${l10n.deeplTranslationFailed}: $statusCode';
  String deeplTranslationError(String error) => '${l10n.deeplTranslationError}: $error';
  String get invalidApiKeyConfigureOpenAI => l10n.invalidApiKeyConfigureOpenAI;
  String get apiRateLimitExceeded => l10n.apiRateLimitExceeded;
  String aiRequestFailed(int statusCode, String body) => '${l10n.aiRequestFailed}: $statusCode - $body';
  String get failedToParseAiResponse => l10n.failedToParseAiResponse;
  String aiGenerationError(String error) => '${l10n.aiGenerationError}: $error';
  String get voiceInputPlaceholder => l10n.voiceInputPlaceholder;
}

