import 'package:flutter/material.dart';
import 'package:language_rally/l10n/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../font_test_page.dart';
import '../design_system_showcase.dart';
import '../packages/package_list_page.dart';
import '../packages/package_form_page.dart';
import '../dev/test_data_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.appTitle),
      ),
      body: Center(
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

              // Font Test Button
              FilledButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const FontTestPage()),
                  );
                },
                icon: const Icon(Icons.font_download),
                label: const Text('Test Inter Fonts'),
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
                label: const Text('View Packages'),
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
                label: const Text('Create New Package'),
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
                label: const Text('Generate Test Data'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange.shade100,
                  foregroundColor: Colors.orange.shade900,
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
                label: const Text('Design System Showcase'),
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
    );
  }
}
