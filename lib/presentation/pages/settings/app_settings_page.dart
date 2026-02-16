// lib/presentation/pages/settings/app_settings_page.dart
//
// Application Settings Page
//

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/language_codes.dart';
import '../../../l10n/app_localizations.dart';
import '../../providers/app_settings_provider.dart';

class AppSettingsPage extends ConsumerStatefulWidget {
  const AppSettingsPage({super.key});

  @override
  ConsumerState<AppSettingsPage> createState() => _AppSettingsPageState();
}

class _AppSettingsPageState extends ConsumerState<AppSettingsPage> {
  late TextEditingController _languageNameController;
  late TextEditingController _deeplApiKeyController;
  late TextEditingController _openaiApiKeyController;

  String? _selectedLanguageCode;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final settings = ref.read(appSettingsProvider);
    _languageNameController = TextEditingController(text: settings.userLanguageName);
    _deeplApiKeyController = TextEditingController(text: settings.deeplApiKey ?? '');
    _openaiApiKeyController = TextEditingController(text: settings.openaiApiKey ?? '');
    _selectedLanguageCode = settings.userLanguageCode;
  }

  @override
  void dispose() {
    _languageNameController.dispose();
    _deeplApiKeyController.dispose();
    _openaiApiKeyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final settings = ref.watch(appSettingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
        actions: [
          if (_isSaving)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.save),
              tooltip: l10n.save,
              onPressed: _saveSettings,
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Language Section
            _buildSectionHeader(
              theme,
              Icons.language,
              l10n.userLanguage,
              l10n.userLanguageDescription,
            ),
            const SizedBox(height: AppTheme.spacing12),
            _buildLanguageNameAutocomplete(context, l10n, theme),

            const SizedBox(height: AppTheme.spacing24),

            // API Keys Section
            _buildSectionHeader(
              theme,
              Icons.key,
              l10n.apiKeys,
              'Configure API keys for premium features',
            ),
            const SizedBox(height: AppTheme.spacing12),

            // DeepL API Key
            _buildApiKeyField(
              controller: _deeplApiKeyController,
              label: l10n.deeplApiKey,
              hint: l10n.enterApiKey,
              description: l10n.deeplApiKeyDescription,
              isOptional: true,
              theme: theme,
            ),
            const SizedBox(height: AppTheme.spacing16),

            // OpenAI API Key
            _buildApiKeyField(
              controller: _openaiApiKeyController,
              label: l10n.openaiApiKey,
              hint: l10n.enterApiKey,
              description: l10n.openaiApiKeyDescription,
              isOptional: false,
              theme: theme,
            ),

            const SizedBox(height: AppTheme.spacing24),

            // Current Status Card
            _buildStatusCard(theme, settings),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    ThemeData theme,
    IconData icon,
    String title,
    String description,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: theme.colorScheme.primary),
            const SizedBox(width: AppTheme.spacing8),
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppTheme.spacing4),
        Text(
          description,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildLanguageNameAutocomplete(
    BuildContext context,
    AppLocalizations l10n,
    ThemeData theme,
  ) {
    final allLanguages = LanguageCodes.getSortedLanguages();

    return Autocomplete<MapEntry<String, String>>(
      initialValue: TextEditingValue(text: _languageNameController.text),
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return allLanguages;
        }
        final query = textEditingValue.text.toLowerCase();
        return allLanguages.where((entry) {
          return entry.value.toLowerCase().contains(query) ||
                 entry.key.toLowerCase().contains(query);
        });
      },
      displayStringForOption: (MapEntry<String, String> option) => option.value,
      fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
        if (textEditingController.text != _languageNameController.text) {
          textEditingController.text = _languageNameController.text;
        }

        textEditingController.addListener(() {
          _languageNameController.text = textEditingController.text;
        });

        return TextFormField(
          controller: textEditingController,
          focusNode: focusNode,
          decoration: InputDecoration(
            labelText: l10n.userLanguage,
            hintText: 'e.g., English (United States)',
            prefixIcon: const Icon(Icons.translate),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            ),
            filled: true,
            fillColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
          ),
        );
      },
      optionsViewBuilder: (context, onSelected, options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4.0,
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 300, maxWidth: 400),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: options.length,
                itemBuilder: (context, index) {
                  final option = options.elementAt(index);
                  return ListTile(
                    leading: const Icon(Icons.language, size: 20),
                    title: Text(
                      option.value,
                      style: theme.textTheme.bodyMedium,
                    ),
                    subtitle: Text(
                      'Code: ${option.key}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    onTap: () => onSelected(option),
                  );
                },
              ),
            ),
          ),
        );
      },
      onSelected: (MapEntry<String, String> selection) {
        setState(() {
          _selectedLanguageCode = selection.key;
          _languageNameController.text = selection.value;
        });
      },
    );
  }

  Widget _buildApiKeyField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required String description,
    required bool isOptional,
    required ThemeData theme,
  }) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(width: AppTheme.spacing8),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacing8,
                vertical: AppTheme.spacing4,
              ),
              decoration: BoxDecoration(
                color: isOptional
                    ? theme.colorScheme.secondaryContainer
                    : theme.colorScheme.tertiaryContainer,
                borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
              ),
              child: Text(
                isOptional ? l10n.optional : l10n.required,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isOptional
                      ? theme.colorScheme.onSecondaryContainer
                      : theme.colorScheme.onTertiaryContainer,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppTheme.spacing4),
        Text(
          description,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppTheme.spacing8),
        TextFormField(
          controller: controller,
          obscureText: true,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: const Icon(Icons.vpn_key),
            suffixIcon: controller.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, size: 20),
                    onPressed: () {
                      setState(() {
                        controller.clear();
                      });
                    },
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            ),
            filled: true,
            fillColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
          ),
          onChanged: (_) => setState(() {}),
        ),
      ],
    );
  }

  Widget _buildStatusCard(ThemeData theme, dynamic settings) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, color: theme.colorScheme.primary),
                const SizedBox(width: AppTheme.spacing8),
                Text(
                  'Current Status',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            const Divider(height: AppTheme.spacing16),
            _buildStatusRow(
              theme,
              Icons.translate,
              'Translation Service',
              settings.deeplApiKey != null && settings.deeplApiKey!.isNotEmpty
                  ? l10n.usingDeepL
                  : l10n.usingGoogleTranslate,
              settings.deeplApiKey != null && settings.deeplApiKey!.isNotEmpty,
            ),
            const SizedBox(height: AppTheme.spacing8),
            _buildStatusRow(
              theme,
              Icons.auto_awesome,
              'AI Examples',
              settings.openaiApiKey != null && settings.openaiApiKey!.isNotEmpty
                  ? 'Configured (OpenAI)'
                  : 'Not configured',
              settings.openaiApiKey != null && settings.openaiApiKey!.isNotEmpty,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusRow(
    ThemeData theme,
    IconData icon,
    String label,
    String status,
    bool isActive,
  ) {
    return Row(
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.onSurfaceVariant),
        const SizedBox(width: AppTheme.spacing8),
        Expanded(
          child: Text(
            label,
            style: theme.textTheme.bodyMedium,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spacing8,
            vertical: AppTheme.spacing4,
          ),
          decoration: BoxDecoration(
            color: isActive
                ? theme.colorScheme.primaryContainer
                : theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
          ),
          child: Text(
            status,
            style: theme.textTheme.bodySmall?.copyWith(
              color: isActive
                  ? theme.colorScheme.onPrimaryContainer
                  : theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _saveSettings() async {
    final l10n = AppLocalizations.of(context)!;

    // Validate language selection
    if (_selectedLanguageCode == null || _languageNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select a language'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final notifier = ref.read(appSettingsProvider.notifier);

      // Save user language
      await notifier.setUserLanguage(
        languageCode: _selectedLanguageCode!,
        languageName: _languageNameController.text.trim(),
      );

      // Save DeepL API key
      final deeplKey = _deeplApiKeyController.text.trim();
      await notifier.setDeeplApiKey(deeplKey.isEmpty ? null : deeplKey);

      // Save OpenAI API key
      final openaiKey = _openaiApiKeyController.text.trim();
      await notifier.setOpenaiApiKey(openaiKey.isEmpty ? null : openaiKey);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.settingsSaved),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.errorSavingSettings}: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }
}

