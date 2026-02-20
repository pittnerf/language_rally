// lib/presentation/providers/theme_provider.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Available theme options
enum AppThemeOption {
  calmTeal('Calm Teal', 'Original soft teal and coral theme'),
  oceanBlue('Ocean Blue', 'Professional blue theme'),
  forestGreen('Forest Green', 'Natural green theme'),
  sunsetOrange('Sunset Orange', 'Warm orange theme'),
  purpleDreams('Purple Dreams', 'Creative purple theme');

  final String displayName;
  final String description;
  const AppThemeOption(this.displayName, this.description);
}

/// Theme configuration with both theme option and brightness
class ThemeConfig {
  final AppThemeOption themeOption;
  final bool isDarkMode;

  const ThemeConfig({
    required this.themeOption,
    required this.isDarkMode,
  });

  ThemeConfig copyWith({AppThemeOption? themeOption, bool? isDarkMode}) {
    return ThemeConfig(
      themeOption: themeOption ?? this.themeOption,
      isDarkMode: isDarkMode ?? this.isDarkMode,
    );
  }
}

final themeProvider = NotifierProvider<ThemeNotifier, ThemeConfig>(() {
  return ThemeNotifier();
});

class ThemeNotifier extends Notifier<ThemeConfig> {
  static const String _themeOptionKey = 'theme_option';
  static const String _darkModeKey = 'dark_mode';

  @override
  ThemeConfig build() {
    _loadThemeFromPreferences();
    return const ThemeConfig(
      themeOption: AppThemeOption.calmTeal,
      isDarkMode: false, // Light mode by default
    );
  }

  /// Load saved theme from SharedPreferences
  Future<void> _loadThemeFromPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Load theme option
      final themeOptionName = prefs.getString(_themeOptionKey);
      AppThemeOption themeOption = AppThemeOption.calmTeal;
      if (themeOptionName != null) {
        themeOption = AppThemeOption.values.firstWhere(
          (e) => e.name == themeOptionName,
          orElse: () => AppThemeOption.calmTeal,
        );
      }

      // Load dark mode
      final isDarkMode = prefs.getBool(_darkModeKey) ?? false;

      // Update state
      state = ThemeConfig(
        themeOption: themeOption,
        isDarkMode: isDarkMode,
      );
    } catch (e) {
      // If loading fails, keep default theme
      debugPrint('Error loading theme preferences: $e');
    }
  }

  /// Save theme option to SharedPreferences
  Future<void> _saveThemeOption(AppThemeOption option) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_themeOptionKey, option.name);
    } catch (e) {
      debugPrint('Error saving theme option: $e');
    }
  }

  /// Save dark mode to SharedPreferences
  Future<void> _saveDarkMode(bool isDark) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_darkModeKey, isDark);
    } catch (e) {
      debugPrint('Error saving dark mode: $e');
    }
  }

  void setThemeOption(AppThemeOption option) {
    state = state.copyWith(themeOption: option);
    _saveThemeOption(option);
  }

  void toggleBrightness() {
    final newDarkMode = !state.isDarkMode;
    state = state.copyWith(isDarkMode: newDarkMode);
    _saveDarkMode(newDarkMode);
  }

  void setDarkMode(bool isDark) {
    state = state.copyWith(isDarkMode: isDark);
    _saveDarkMode(isDark);
  }
}
