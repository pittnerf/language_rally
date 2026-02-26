// lib/data/repositories/app_settings_repository.dart
//
// Repository for Application Settings
//

import 'package:shared_preferences/shared_preferences.dart';
import '../models/app_settings.dart';

class AppSettingsRepository {
  static const String _keyUserLanguageCode = 'user_language_code';
  static const String _keyUserLanguageName = 'user_language_name';
  static const String _keyDeeplApiKey = 'deepl_api_key';
  static const String _keyOpenaiApiKey = 'openai_api_key';
  static const String _keyOpenaiModel = 'openai_model';
  static const String _keyMinItemsForBadges = 'min_items_for_badges';
  static const String _keyLastTrainedPackageId = 'last_trained_package_id';

  /// Load app settings from SharedPreferences
  Future<AppSettings> loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      return AppSettings(
        userLanguageCode: prefs.getString(_keyUserLanguageCode) ?? 'en',
        userLanguageName: prefs.getString(_keyUserLanguageName) ?? 'English',
        deeplApiKey: prefs.getString(_keyDeeplApiKey),
        openaiApiKey: prefs.getString(_keyOpenaiApiKey),
        openaiModel: prefs.getString(_keyOpenaiModel) ?? 'gpt-4-turbo',
        minItemsForBadges: prefs.getInt(_keyMinItemsForBadges) ?? 10,
        lastTrainedPackageId: prefs.getString(_keyLastTrainedPackageId),
      );
    } catch (e) {
      // Return defaults if loading fails
      return const AppSettings();
    }
  }

  /// Save user language settings
  Future<void> saveUserLanguage({
    required String languageCode,
    required String languageName,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserLanguageCode, languageCode);
    await prefs.setString(_keyUserLanguageName, languageName);
  }

  /// Save DeepL API key
  Future<void> saveDeeplApiKey(String? apiKey) async {
    final prefs = await SharedPreferences.getInstance();
    if (apiKey == null || apiKey.isEmpty) {
      await prefs.remove(_keyDeeplApiKey);
    } else {
      await prefs.setString(_keyDeeplApiKey, apiKey);
    }
  }

  /// Save OpenAI API key
  Future<void> saveOpenaiApiKey(String? apiKey) async {
    final prefs = await SharedPreferences.getInstance();
    if (apiKey == null || apiKey.isEmpty) {
      await prefs.remove(_keyOpenaiApiKey);
    } else {
      await prefs.setString(_keyOpenaiApiKey, apiKey);
    }
  }

  /// Save OpenAI model selection
  Future<void> saveOpenaiModel(String model) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyOpenaiModel, model);
  }

  /// Save minimum items for badges
  Future<void> saveMinItemsForBadges(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyMinItemsForBadges, value);
  }

  /// Save last trained package ID
  Future<void> saveLastTrainedPackageId(String? packageId) async {
    final prefs = await SharedPreferences.getInstance();
    if (packageId == null || packageId.isEmpty) {
      await prefs.remove(_keyLastTrainedPackageId);
    } else {
      await prefs.setString(_keyLastTrainedPackageId, packageId);
    }
  }

  /// Save all settings at once
  Future<void> saveSettings(AppSettings settings) async {
    await saveUserLanguage(
      languageCode: settings.userLanguageCode,
      languageName: settings.userLanguageName,
    );
    await saveDeeplApiKey(settings.deeplApiKey);
    await saveOpenaiApiKey(settings.openaiApiKey);
    await saveOpenaiModel(settings.openaiModel);
    await saveMinItemsForBadges(settings.minItemsForBadges);
    await saveLastTrainedPackageId(settings.lastTrainedPackageId);
  }

  /// Clear all API keys (for security/logout)
  Future<void> clearApiKeys() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyDeeplApiKey);
    await prefs.remove(_keyOpenaiApiKey);
  }
}

