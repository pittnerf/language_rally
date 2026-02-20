import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/app_settings.dart';
import '../../data/repositories/app_settings_repository.dart';

final appSettingsProvider = NotifierProvider<AppSettingsNotifier, AppSettings>(() => AppSettingsNotifier());

class AppSettingsNotifier extends Notifier<AppSettings> {
  final _repository = AppSettingsRepository();

  @override
  AppSettings build() {
    _loadSettings();
    return const AppSettings();
  }

  Future<void> _loadSettings() async {
    try {
      state = await _repository.loadSettings();
    } catch (e) {
      /* Ignore errors and use default settings */
    }
  }

  Future<void> setUserLanguage({required String languageCode, required String languageName}) async {
    await _repository.saveUserLanguage(languageCode: languageCode, languageName: languageName);
    state = state.copyWith(userLanguageCode: languageCode, userLanguageName: languageName);
  }

  Future<void> setDeeplApiKey(String? apiKey) async {
    await _repository.saveDeeplApiKey(apiKey);
    state = state.copyWith(deeplApiKey: apiKey);
  }

  Future<void> setOpenaiApiKey(String? apiKey) async {
    await _repository.saveOpenaiApiKey(apiKey);
    state = state.copyWith(openaiApiKey: apiKey);
  }
}
