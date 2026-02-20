// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:language_rally/l10n/app_localizations.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'data/database_helper.dart';
import 'presentation/pages/home/home_page.dart';
import 'presentation/providers/locale_provider.dart';
import 'presentation/providers/theme_provider.dart';

void main() {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Configure system UI overlay style for edge-to-edge
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
  );

  // Initialize database factory for desktop platforms
  DatabaseHelper.initializeDatabaseFactory();

  runApp(const ProviderScope(child: LanguageRallyApp()));
}

class LanguageRallyApp extends ConsumerWidget {
  const LanguageRallyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeConfig = ref.watch(themeProvider);
    final locale = ref.watch(localeProvider);

    // Select theme based on configuration
    ThemeData lightTheme;
    ThemeData darkTheme;

    switch (themeConfig.themeOption) {
      case AppThemeOption.calmTeal:
        lightTheme = AppTheme.lightTheme;
        darkTheme = AppTheme.darkTheme;
      case AppThemeOption.oceanBlue:
        lightTheme = AppTheme.oceanLightTheme;
        darkTheme = AppTheme.oceanDarkTheme;
      case AppThemeOption.forestGreen:
        lightTheme = AppTheme.forestLightTheme;
        darkTheme = AppTheme.forestDarkTheme;
      case AppThemeOption.sunsetOrange:
        lightTheme = AppTheme.sunsetLightTheme;
        darkTheme = AppTheme.sunsetDarkTheme;
      case AppThemeOption.purpleDreams:
        lightTheme = AppTheme.purpleLightTheme;
        darkTheme = AppTheme.purpleDarkTheme;
    }

    return MaterialApp(
      title: 'Language Rally',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeConfig.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const HomePage(),
    );
  }
}
