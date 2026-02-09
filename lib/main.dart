// lib/main.dart
import 'package:flutter/material.dart';
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

  // Initialize database factory for desktop platforms
  DatabaseHelper.initializeDatabaseFactory();

  runApp(const ProviderScope(child: LanguageRallyApp()));
}

class LanguageRallyApp extends ConsumerWidget {
  const LanguageRallyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final locale = ref.watch(localeProvider);

    return MaterialApp(
      title: 'Language Rally',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const HomePage(),
    );
  }
}
