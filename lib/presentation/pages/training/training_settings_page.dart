// lib/presentation/pages/training/training_settings_page.dart
//
// Training Settings Page - Full-screen configuration page for training rally
//
// FEATURES:
// - Configure item scope (all, last N, only unknown, only important)
// - Set item order (random, sequential)
// - Choose display language (mother tongue, target language, random)
// - Filter by categories
// - Set don't know threshold
// - Settings are persisted and remembered
// - Clear all settings button
// - Start training rally button

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/training_settings.dart';
import '../../../data/models/language_package.dart';
import '../../../data/models/category.dart';
import '../../../data/repositories/category_repository.dart';
import '../../../data/repositories/training_settings_repository.dart';
import '../../../l10n/app_localizations.dart';
import 'training_rally_page.dart';

class TrainingSettingsPage extends ConsumerStatefulWidget {
  final LanguagePackage package;

  const TrainingSettingsPage({
    super.key,
    required this.package,
  });

  @override
  ConsumerState<TrainingSettingsPage> createState() => _TrainingSettingsPageState();
}

class _TrainingSettingsPageState extends ConsumerState<TrainingSettingsPage> {
  final _trainingSettingsRepo = TrainingSettingsRepository();
  final _categoryRepo = CategoryRepository();

  // Settings values
  late ItemScope _itemScope;
  late int _lastNItems;
  late ItemOrder _itemOrder;
  late DisplayLanguage _displayLanguage;
  late List<String> _selectedCategoryIds;
  late int _dontKnowThreshold;

  List<Category> _allCategories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    setState(() => _isLoading = true);

    try {
      // Load saved settings or create default
      final settings = await _trainingSettingsRepo.getSettingsForPackage(widget.package.id);

      // Load categories
      final categories = await _categoryRepo.getCategoriesForPackage(widget.package.id);

      if (mounted) {
        setState(() {
          if (settings != null) {
            _itemScope = settings.itemScope;
            _lastNItems = settings.lastNItems;
            _itemOrder = settings.itemOrder;
            _displayLanguage = settings.displayLanguage;
            _selectedCategoryIds = List.from(settings.selectedCategoryIds);
            _dontKnowThreshold = settings.dontKnowThreshold;
          } else {
            // Default values
            _itemScope = ItemScope.all;
            _lastNItems = 10;
            _itemOrder = ItemOrder.random;
            _displayLanguage = DisplayLanguage.random;
            _selectedCategoryIds = [];
            _dontKnowThreshold = 3;
          }
          _allCategories = categories;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading settings: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _saveSettings() async {
    final settings = TrainingSettings(
      packageId: widget.package.id,
      itemScope: _itemScope,
      lastNItems: _lastNItems,
      itemOrder: _itemOrder,
      displayLanguage: _displayLanguage,
      selectedCategoryIds: _selectedCategoryIds,
      dontKnowThreshold: _dontKnowThreshold,
    );

    await _trainingSettingsRepo.saveSettings(settings);
  }

  Future<void> _clearSettings() async {
    final l10n = AppLocalizations.of(context)!;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.clearTrainingSettings),
        content: Text(l10n.confirmClearTrainingSettings),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            child: Text(l10n.clear),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _trainingSettingsRepo.deleteSettings(widget.package.id);
      await _loadSettings(); // Reload default settings

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.trainingSettingsCleared),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
      }
    }
  }

  Future<void> _startTraining() async {
    // Save current settings
    await _saveSettings();

    // Navigate to training rally page
    if (mounted) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => TrainingRallyPage(
            package: widget.package,
            settings: TrainingSettings(
              packageId: widget.package.id,
              itemScope: _itemScope,
              lastNItems: _lastNItems,
              itemOrder: _itemOrder,
              displayLanguage: _displayLanguage,
              selectedCategoryIds: _selectedCategoryIds,
              dontKnowThreshold: _dontKnowThreshold,
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isLandscape = MediaQuery.of(context).size.width >= 600;

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text(l10n.trainingSettings),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.trainingSettings,
          style: theme.textTheme.titleSmall,
        ),
      ),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(
                left: AppTheme.spacing8,
                right: AppTheme.spacing8,
                top: AppTheme.spacing8,
                bottom: 120, // Space for floating buttons
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Package info
                  _buildPackageInfo(theme, l10n),
                  const SizedBox(height: AppTheme.spacing8),

                  // Main settings in landscape: side by side
                  if (isLandscape) ...[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _buildItemScopeSection(theme, l10n)),
                        const SizedBox(width: AppTheme.spacing8),
                        Expanded(child: _buildItemOrderSection(theme, l10n)),
                        const SizedBox(width: AppTheme.spacing8),
                        Expanded(child: _buildDisplayLanguageSection(theme, l10n)),
                      ],
                    ),
                    const SizedBox(height: AppTheme.spacing8),
                  ] else ...[
                    // Portrait mode: stacked
                    _buildItemScopeSection(theme, l10n),
                    const SizedBox(height: AppTheme.spacing8),
                    _buildItemOrderSection(theme, l10n),
                    const SizedBox(height: AppTheme.spacing8),
                    _buildDisplayLanguageSection(theme, l10n),
                    const SizedBox(height: AppTheme.spacing8),
                  ],


                  // Category filter
                  _buildCategoryFilterSection(theme, l10n),
                ],
              ),
            ),
          ),
          // Floating action buttons at bottom right
          Positioned(
            right: 16,
            bottom: 16,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                FloatingActionButton.extended(
                  onPressed: _startTraining,
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  icon: const Icon(Icons.play_arrow, size: 20),
                  label: Text(
                    l10n.startTrainingRally,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                  heroTag: 'start_training',
                ),
                const SizedBox(height: 12),
                FloatingActionButton.extended(
                  onPressed: _clearSettings,
                  backgroundColor: theme.colorScheme.errorContainer,
                  foregroundColor: theme.colorScheme.onErrorContainer,
                  icon: const Icon(Icons.clear_all, size: 18),
                  label: Text(
                    l10n.clearTrainingSettings,
                    style: theme.textTheme.bodyMedium,
                  ),
                  heroTag: 'clear_settings',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPackageInfo(ThemeData theme, AppLocalizations l10n) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing8),
        child: Row(
          children: [
            Expanded(
              child: Text(
                widget.package.packageName ?? '${widget.package.languageName1} - ${widget.package.languageName2}',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: AppTheme.spacing8),
            Text(
              '${widget.package.languageCode1.split('-')[0].toUpperCase()} → ${widget.package.languageCode2.split('-')[0].toUpperCase()}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemScopeSection(ThemeData theme, AppLocalizations l10n) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.itemScope,
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppTheme.spacing4),
            _buildRadioOption<ItemScope>(
              theme,
              l10n.allItems,
              ItemScope.all,
              _itemScope,
              (value) => setState(() => _itemScope = value),
            ),
            _buildRadioOption<ItemScope>(
              theme,
              l10n.lastNItems,
              ItemScope.lastN,
              _itemScope,
              (value) => setState(() => _itemScope = value),
            ),
            _buildRadioOption<ItemScope>(
              theme,
              l10n.onlyUnknown,
              ItemScope.onlyUnknown,
              _itemScope,
              (value) => setState(() => _itemScope = value),
            ),
            _buildRadioOption<ItemScope>(
              theme,
              l10n.onlyImportant,
              ItemScope.onlyImportant,
              _itemScope,
              (value) => setState(() => _itemScope = value),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildItemOrderSection(ThemeData theme, AppLocalizations l10n) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.itemOrder,
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppTheme.spacing4),
            _buildRadioOption<ItemOrder>(
              theme,
              l10n.randomOrder,
              ItemOrder.random,
              _itemOrder,
              (value) => setState(() => _itemOrder = value),
            ),
            _buildRadioOption<ItemOrder>(
              theme,
              l10n.sequentialOrder,
              ItemOrder.sequential,
              _itemOrder,
              (value) => setState(() => _itemOrder = value),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDisplayLanguageSection(ThemeData theme, AppLocalizations l10n) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.displayLanguage,
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppTheme.spacing4),
            _buildRadioOption<DisplayLanguage>(
              theme,
              '${l10n.motherTongue} (${widget.package.languageName1})',
              DisplayLanguage.motherTongue,
              _displayLanguage,
              (value) => setState(() => _displayLanguage = value),
            ),
            _buildRadioOption<DisplayLanguage>(
              theme,
              '${l10n.targetLanguage} (${widget.package.languageName2})',
              DisplayLanguage.targetLanguage,
              _displayLanguage,
              (value) => setState(() => _displayLanguage = value),
            ),
            _buildRadioOption<DisplayLanguage>(
              theme,
              l10n.randomLanguage,
              DisplayLanguage.random,
              _displayLanguage,
              (value) => setState(() => _displayLanguage = value),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryFilterSection(ThemeData theme, AppLocalizations l10n) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.categoryFilter,
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppTheme.spacing4),
            Text(
              l10n.categoryFilterHint,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: AppTheme.spacing8),
            if (_allCategories.isEmpty)
              Text(
                l10n.noCategories,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              )
            else
              Wrap(
                spacing: AppTheme.spacing8,
                runSpacing: AppTheme.spacing4,
                children: _allCategories.map((category) {
                  final isSelected = _selectedCategoryIds.contains(category.id);
                  return FilterChip(
                    selected: isSelected,
                    label: Text(
                      category.name,
                      style: theme.textTheme.bodySmall,
                    ),
                    avatar: Icon(
                      isSelected ? Icons.check_circle : Icons.label_outline,
                      size: 16,
                      color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
                    ),
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedCategoryIds.add(category.id);
                        } else {
                          _selectedCategoryIds.remove(category.id);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }


  /// Helper method to build a radio option without using deprecated RadioListTile
  Widget _buildRadioOption<T>(
    ThemeData theme,
    String label,
    T value,
    T groupValue,
    void Function(T) onChanged,
  ) {
    final isSelected = value == groupValue;
    return InkWell(
      onTap: () => onChanged(value),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurfaceVariant,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: theme.textTheme.bodySmall,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

