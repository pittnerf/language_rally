import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:language_rally/l10n/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../providers/theme_provider.dart';
import '../font_test_page.dart';
import '../design_system_showcase.dart';
import '../packages/package_list_page.dart';
import '../packages/package_form_page.dart';
import '../training/training_settings_page.dart';
import '../dev/test_data_page.dart';
import '../settings/app_settings_page.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  void _showThemeSelector(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => Consumer(
        builder: (context, ref, child) {
          // Watch the theme provider to rebuild dialog when theme changes
          final currentConfig = ref.watch(themeProvider);

          // Use fixed text styles to prevent size changes when theme switches
          const titleTextStyle = TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            fontWeight: FontWeight.w400,
            height: 1.5,
            letterSpacing: 0.5,
          );

          const subtitleTextStyle = TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            fontWeight: FontWeight.w400,
            height: 1.33,
            letterSpacing: 0.4,
          );

          const headerTextStyle = TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            height: 1.5,
            letterSpacing: 0.15,
          );

          return AlertDialog(
            title: const Text('Choose Theme'),
            content: SizedBox(
              width: double.maxFinite,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Dark/Light mode toggle
                    SwitchListTile(
                      title: const Text('Dark Mode', style: titleTextStyle),
                      subtitle: const Text('Toggle between light and dark', style: subtitleTextStyle),
                      value: currentConfig.isDarkMode,
                      onChanged: (value) {
                        ref.read(themeProvider.notifier).setDarkMode(value);
                      },
                    ),
                    const Divider(),
                    const SizedBox(height: 8),
                    const Text('Color Theme:', style: headerTextStyle),
                    const SizedBox(height: 8),
                    // Theme options
                    ...AppThemeOption.values.map((option) {
                      return RadioListTile<AppThemeOption>(
                        title: Text(option.displayName, style: titleTextStyle),
                        subtitle: Text(option.description, style: subtitleTextStyle),
                        value: option,
                        // ignore: deprecated_member_use
                        groupValue: currentConfig.themeOption,
                        // ignore: deprecated_member_use
                        onChanged: (value) {
                          if (value != null) {
                            ref.read(themeProvider.notifier).setThemeOption(value);
                          }
                        },
                      );
                    }),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final themeConfig = ref.watch(themeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.appTitle),
        actions: [
          // Settings button
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: localizations.settings,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AppSettingsPage()),
              );
            },
          ),
          // Theme brightness toggle button
          IconButton(
            icon: Icon(themeConfig.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            tooltip: 'Toggle brightness',
            onPressed: () {
              ref.read(themeProvider.notifier).toggleBrightness();
            },
          ),
          // Theme selector button
          IconButton(
            icon: const Icon(Icons.palette),
            tooltip: 'Change theme',
            onPressed: () => _showThemeSelector(context, ref),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.spacing24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Text(
                localizations.welcome,
                style: Theme.of(context).textTheme.headlineLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppTheme.spacing32),

              // Start Training Rally Button
              FilledButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const TrainingSettingsPage()),
                  );
                },
                icon: const Icon(Icons.school),
                label: Text(localizations.startTrainingRally),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacing24,
                    vertical: AppTheme.spacing16,
                  ),
                ),
              ),
              const SizedBox(height: AppTheme.spacing16),

              // Font Test Button
              FilledButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const FontTestPage()),
                  );
                },
                icon: const Icon(Icons.font_download),
                label: Text(localizations.testInterFonts),
              ),
              const SizedBox(height: AppTheme.spacing16),

              // Package List Button
              FilledButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PackageListPage()),
                  );
                },
                icon: const Icon(Icons.library_books),
                label: Text(localizations.viewPackages),
              ),
              const SizedBox(height: AppTheme.spacing16),

              // Create Package Button
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PackageFormPage()),
                  );
                },
                icon: const Icon(Icons.add_circle_outline),
                label: Text(localizations.createNewPackage),
              ),
              const SizedBox(height: AppTheme.spacing16),

              // Test Data Generator Button (Dev Tool)
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const TestDataPage()),
                  );
                },
                icon: const Icon(Icons.science),
                label: Text(localizations.generateTestData),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                  foregroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
                ),
              ),
              const SizedBox(height: AppTheme.spacing16),

              // Design System Showcase Button
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const DesignSystemShowcase()),
                  );
                },
                icon: const Icon(Icons.palette),
                label: Text(localizations.designSystemShowcase),
              ),

              const SizedBox(height: AppTheme.spacing32),

              // Info card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppTheme.spacing16),
                  child: Column(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Theme.of(context).colorScheme.primary,
                        size: 32,
                      ),
                      const SizedBox(height: AppTheme.spacing8),
                      Text(
                        'Design System Ready',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: AppTheme.spacing8),
                      Text(
                        'Your app is configured with a complete Material 3 design system including Inter fonts, calm colors, and themed components.',
                        style: Theme.of(context).textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        ),
      ),
    );
  }
}
