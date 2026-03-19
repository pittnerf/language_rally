// lib/data/repositories/app_settings_repository.dart
//
// Repository for Application Settings
//

import 'package:shared_preferences/shared_preferences.dart';
import '../models/app_settings.dart';
import '../../core/utils/debug_print.dart';

class AppSettingsRepository {
  static const String _keyUserLanguageCode = 'user_language_code';
  static const String _keyUserLanguageName = 'user_language_name';
  static const String _keyDeeplApiKey = 'deepl_api_key';
  static const String _keyOpenaiApiKey = 'openai_api_key';
  static const String _keyOpenaiModel = 'openai_model';
  static const String _keyAiKnowledgeLevel = 'ai_knowledge_level';
  static const String _keyMinItemsForBadges = 'min_items_for_badges';
  static const String _keyLastTrainedPackageId = 'last_trained_package_id';
  static const String _keySelectedGroupId = 'selected_group_id';
  static const String _keyTrainingSelectedGroupId = 'training_selected_group_id';
  static const String _keyShowTrainingExamples = 'show_training_examples';
  static const String _keyShowTrainingStatistics = 'show_training_statistics';

  // ── Windows Audio Recording Test ─────────────────────────────────────────
  static const String _keyAudioTestDeviceId   = 'audio_test_device_id';
  static const String _keyAudioTestDeviceName = 'audio_test_device_name';
  static const String _keyAudioTestStereo     = 'audio_test_stereo';
  static const String _keyAudioTestSampleRate = 'audio_test_sample_rate';
  static const String _keyAudioTestGain       = 'audio_test_gain';

  /// Load app settings from SharedPreferences
  Future<AppSettings> loadSettings() async {
    try {
      logDebug('📖 Loading settings from SharedPreferences...');
      final prefs = await SharedPreferences.getInstance();

      // Read individual values
      final deeplKey = prefs.getString(_keyDeeplApiKey);
      final openaiKey = prefs.getString(_keyOpenaiApiKey);

      logDebug('   Values read from SharedPreferences:');
      logDebug('   - deeplApiKey: ${deeplKey == null ? "NULL" : "present (length: ${deeplKey.length})"}');
      logDebug('   - openaiApiKey: ${openaiKey == null ? "NULL" : "present (length: ${openaiKey.length})"}');

      // Check if keys exist in SharedPreferences
      final hasDeeplKey = prefs.containsKey(_keyDeeplApiKey);
      final hasOpenaiKey = prefs.containsKey(_keyOpenaiApiKey);
      logDebug('   Keys exist in SharedPreferences:');
      logDebug('   - $_keyDeeplApiKey: $hasDeeplKey');
      logDebug('   - $_keyOpenaiApiKey: $hasOpenaiKey');

      final settings = AppSettings(
        userLanguageCode: prefs.getString(_keyUserLanguageCode) ?? 'en',
        userLanguageName: prefs.getString(_keyUserLanguageName) ?? 'English',
        deeplApiKey: deeplKey,
        openaiApiKey: openaiKey,
        openaiModel: prefs.getString(_keyOpenaiModel) ?? 'gpt-4-turbo',
        aiKnowledgeLevel: prefs.getString(_keyAiKnowledgeLevel) ?? 'B1',
        minItemsForBadges: prefs.getInt(_keyMinItemsForBadges) ?? 10,
        lastTrainedPackageId: prefs.getString(_keyLastTrainedPackageId),
        showTrainingExamples: prefs.getBool(_keyShowTrainingExamples) ?? true,
        showTrainingStatistics: prefs.getBool(_keyShowTrainingStatistics) ?? true,
        audioTestDeviceId:   prefs.getInt(_keyAudioTestDeviceId),
        audioTestDeviceName: prefs.getString(_keyAudioTestDeviceName),
        audioTestStereo:     prefs.getBool(_keyAudioTestStereo) ?? false,
        audioTestSampleRate: prefs.getInt(_keyAudioTestSampleRate) ?? 48000,
        audioTestGain:       prefs.getDouble(_keyAudioTestGain) ?? 3.0,
      );

      logDebug('✅ Settings loaded successfully');
      return settings;
    } catch (e) {
      logDebug('❌ Error loading settings: $e');
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
      logDebug('🗑️ Removing DeepL API key from SharedPreferences');
      final removed = await prefs.remove(_keyDeeplApiKey);
      logDebug('✅ DeepL API key removed (success: $removed)');

      // Force commit changes immediately (important on some platforms like Windows)
      await prefs.reload();

      // Verify it's actually gone
      final stillExists = prefs.containsKey(_keyDeeplApiKey);
      if (stillExists) {
        logDebug('⚠️ WARNING: Key still exists after removal and reload!');
        final value = prefs.getString(_keyDeeplApiKey);
        logDebug('   Value: ${value == null ? "NULL" : "present (length: ${value.length})"}');
      } else {
        logDebug('✓ Verified: Key no longer exists in SharedPreferences');
      }
    } else {
      logDebug('💾 Saving DeepL API key to SharedPreferences (length: ${apiKey.length})');
      await prefs.setString(_keyDeeplApiKey, apiKey);
      await prefs.reload();  // Force commit
      logDebug('✅ DeepL API key saved');
    }
  }

  /// Save OpenAI API key
  Future<void> saveOpenaiApiKey(String? apiKey) async {
    final prefs = await SharedPreferences.getInstance();
    if (apiKey == null || apiKey.isEmpty) {
      logDebug('🗑️ Removing OpenAI API key from SharedPreferences');
      final removed = await prefs.remove(_keyOpenaiApiKey);
      logDebug('✅ OpenAI API key removed (success: $removed)');

      // Force commit changes immediately (important on some platforms like Windows)
      await prefs.reload();

      // Verify it's actually gone
      final stillExists = prefs.containsKey(_keyOpenaiApiKey);
      if (stillExists) {
        logDebug('⚠️ WARNING: Key still exists after removal and reload!');
        final value = prefs.getString(_keyOpenaiApiKey);
        logDebug('   Value: ${value == null ? "NULL" : "present (length: ${value.length})"}');
      } else {
        logDebug('✓ Verified: Key no longer exists in SharedPreferences');
      }
    } else {
      logDebug('💾 Saving OpenAI API key to SharedPreferences (length: ${apiKey.length})');
      await prefs.setString(_keyOpenaiApiKey, apiKey);
      await prefs.reload();  // Force commit
      logDebug('✅ OpenAI API key saved');
    }
  }

  /// Save OpenAI model selection
  Future<void> saveOpenaiModel(String model) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyOpenaiModel, model);
  }

  /// Save AI knowledge level selection
  Future<void> saveAiKnowledgeLevel(String level) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyAiKnowledgeLevel, level);
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
    await saveAiKnowledgeLevel(settings.aiKnowledgeLevel);
    await saveMinItemsForBadges(settings.minItemsForBadges);
    await saveLastTrainedPackageId(settings.lastTrainedPackageId);
  }

  /// Clear all API keys (for security/logout)
  Future<void> clearApiKeys() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyDeeplApiKey);
    await prefs.remove(_keyOpenaiApiKey);
  }

  /// Save selected group ID for package list filter
  Future<void> saveSelectedGroupId(String? groupId) async {
    final prefs = await SharedPreferences.getInstance();
    if (groupId == null || groupId.isEmpty) {
      await prefs.remove(_keySelectedGroupId);
    } else {
      await prefs.setString(_keySelectedGroupId, groupId);
    }
  }

  /// Load selected group ID for package list filter
  Future<String?> loadSelectedGroupId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keySelectedGroupId);
  }

  /// Save the group last selected on the Training Settings page
  Future<void> saveTrainingSelectedGroupId(String? groupId) async {
    final prefs = await SharedPreferences.getInstance();
    if (groupId == null || groupId.isEmpty) {
      await prefs.remove(_keyTrainingSelectedGroupId);
    } else {
      await prefs.setString(_keyTrainingSelectedGroupId, groupId);
    }
  }

  /// Load the group last selected on the Training Settings page
  Future<String?> loadTrainingSelectedGroupId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyTrainingSelectedGroupId);
  }

  /// Save training examples visibility
  Future<void> saveShowTrainingExamples(bool show) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyShowTrainingExamples, show);
  }

  /// Save training statistics visibility
  Future<void> saveShowTrainingStatistics(bool show) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyShowTrainingStatistics, show);
  }

  /// Save Windows Audio Recording Test page settings
  Future<void> saveAudioTestSettings({
    int? deviceId,
    String? deviceName,
    required bool stereo,
    required int sampleRate,
    required double gain,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    if (deviceId != null) {
      await prefs.setInt(_keyAudioTestDeviceId, deviceId);
    } else {
      await prefs.remove(_keyAudioTestDeviceId);
    }
    if (deviceName != null && deviceName.isNotEmpty) {
      await prefs.setString(_keyAudioTestDeviceName, deviceName);
    } else {
      await prefs.remove(_keyAudioTestDeviceName);
    }
    await prefs.setBool(_keyAudioTestStereo, stereo);
    await prefs.setInt(_keyAudioTestSampleRate, sampleRate);
    await prefs.setDouble(_keyAudioTestGain, gain);
    logDebug('💾 Audio test settings saved: deviceId=$deviceId stereo=$stereo rate=$sampleRate gain=$gain');
  }
}

