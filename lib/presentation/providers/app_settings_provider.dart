import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/app_settings.dart';
import '../../data/repositories/app_settings_repository.dart';
import '../../core/utils/debug_print.dart';

final appSettingsProvider = NotifierProvider<AppSettingsNotifier, AppSettings>(() => AppSettingsNotifier());

class AppSettingsNotifier extends Notifier<AppSettings> {
  final _repository = AppSettingsRepository();

  @override
  AppSettings build() {
    _loadSettings();
    return const AppSettings();
  }

  Future<void> _loadSettings() async {
    logDebug('🔄 AppSettingsProvider._loadSettings() called');
    try {
      final loadedSettings = await _repository.loadSettings();
      logDebug('📦 Updating provider state with loaded settings:');
      logDebug('   - deeplApiKey: ${loadedSettings.deeplApiKey == null ? "NULL" : "present (length: ${loadedSettings.deeplApiKey!.length})"}');
      logDebug('   - openaiApiKey: ${loadedSettings.openaiApiKey == null ? "NULL" : "present (length: ${loadedSettings.openaiApiKey!.length})"}');
      state = loadedSettings;
      logDebug('✅ Provider state updated');
    } catch (e) {
      logDebug('❌ Error in _loadSettings: $e');
      /* Ignore errors and use default settings */
    }
  }

  Future<void> setUserLanguage({required String languageCode, required String languageName}) async {
    await _repository.saveUserLanguage(languageCode: languageCode, languageName: languageName);
    state = state.copyWith(userLanguageCode: languageCode, userLanguageName: languageName);
  }

  Future<void> setDeeplApiKey(String? apiKey) async {
    logDebug('🔧 setDeeplApiKey called with: ${apiKey == null ? "NULL" : "present (length: ${apiKey.length})"}');
    await _repository.saveDeeplApiKey(apiKey);
    logDebug('📝 Updating provider state...');
    logDebug('   - Current state deeplApiKey: ${state.deeplApiKey == null ? "NULL" : "present (length: ${state.deeplApiKey!.length})"}');
    state = state.copyWith(deeplApiKey: apiKey);
    logDebug('   - New state deeplApiKey: ${state.deeplApiKey == null ? "NULL" : "present (length: ${state.deeplApiKey!.length})"}');
  }

  Future<void> setOpenaiApiKey(String? apiKey) async {
    logDebug('🔧 setOpenaiApiKey called with: ${apiKey == null ? "NULL" : "present (length: ${apiKey.length})"}');
    await _repository.saveOpenaiApiKey(apiKey);
    logDebug('📝 Updating provider state...');
    logDebug('   - Current state openaiApiKey: ${state.openaiApiKey == null ? "NULL" : "present (length: ${state.openaiApiKey!.length})"}');
    state = state.copyWith(openaiApiKey: apiKey);
    logDebug('   - New state openaiApiKey: ${state.openaiApiKey == null ? "NULL" : "present (length: ${state.openaiApiKey!.length})"}');
  }

  Future<void> setOpenaiModel(String model) async {
    await _repository.saveOpenaiModel(model);
    state = state.copyWith(openaiModel: model);
  }

  Future<void> setAiKnowledgeLevel(String level) async {
    await _repository.saveAiKnowledgeLevel(level);
    state = state.copyWith(aiKnowledgeLevel: level);
  }

  Future<void> setShowTrainingExamples(bool show) async {
    await _repository.saveShowTrainingExamples(show);
    state = state.copyWith(showTrainingExamples: show);
  }

  Future<void> setShowTrainingStatistics(bool show) async {
    await _repository.saveShowTrainingStatistics(show);
    state = state.copyWith(showTrainingStatistics: show);
  }
}
