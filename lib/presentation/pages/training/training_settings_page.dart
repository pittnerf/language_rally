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
    final l10n = AppLocalizations.of(context)!;

    // Save current settings
    await _saveSettings();

    // TODO: Navigate to training rally page
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.startingTraining),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
      );
      // Navigator.of(context).push(...) - to training rally page
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

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
          style: theme.textTheme.titleMedium,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.spacing16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Package info
              _buildPackageInfo(theme, l10n),
              const SizedBox(height: AppTheme.spacing24),

              // Item scope
              _buildItemScopeSection(theme, l10n),
              const SizedBox(height: AppTheme.spacing16),

              // Last N items (only visible when itemScope is lastN)
              if (_itemScope == ItemScope.lastN) ...[
                _buildLastNItemsField(theme, l10n),
                const SizedBox(height: AppTheme.spacing16),
              ],

              // Item order
              _buildItemOrderSection(theme, l10n),
              const SizedBox(height: AppTheme.spacing16),

              // Display language
              _buildDisplayLanguageSection(theme, l10n),
              const SizedBox(height: AppTheme.spacing16),

              // Category filter
              _buildCategoryFilterSection(theme, l10n),
              const SizedBox(height: AppTheme.spacing16),

              // Don't know threshold
              _buildDontKnowThresholdField(theme, l10n),
              const SizedBox(height: AppTheme.spacing32),

              // Action buttons
              _buildActionButtons(theme, l10n),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPackageInfo(ThemeData theme, AppLocalizations l10n) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.package.packageName ?? '${widget.package.languageName1} - ${widget.package.languageName2}',
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppTheme.spacing8),
            Text(
              '${widget.package.languageCode1.split('-')[0].toUpperCase()} → ${widget.package.languageCode2.split('-')[0].toUpperCase()}',
              style: theme.textTheme.bodyMedium?.copyWith(
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
        padding: const EdgeInsets.all(AppTheme.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.itemScope,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppTheme.spacing12),
            RadioListTile<ItemScope>(
              title: Text(l10n.allItems, style: theme.textTheme.bodyMedium),
              value: ItemScope.all,
              groupValue: _itemScope,
              onChanged: (value) {
                if (value != null) {
                  setState(() => _itemScope = value);
                }
              },
              contentPadding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
            ),
            RadioListTile<ItemScope>(
              title: Text(l10n.lastNItems, style: theme.textTheme.bodyMedium),
              value: ItemScope.lastN,
              groupValue: _itemScope,
              onChanged: (value) {
                if (value != null) {
                  setState(() => _itemScope = value);
                }
              },
              contentPadding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
            ),
            RadioListTile<ItemScope>(
              title: Text(l10n.onlyUnknown, style: theme.textTheme.bodyMedium),
              value: ItemScope.onlyUnknown,
              groupValue: _itemScope,
              onChanged: (value) {
                if (value != null) {
                  setState(() => _itemScope = value);
                }
              },
              contentPadding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
            ),
            RadioListTile<ItemScope>(
              title: Text(l10n.onlyImportant, style: theme.textTheme.bodyMedium),
              value: ItemScope.onlyImportant,
              groupValue: _itemScope,
              onChanged: (value) {
                if (value != null) {
                  setState(() => _itemScope = value);
                }
              },
              contentPadding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLastNItemsField(ThemeData theme, AppLocalizations l10n) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.numberOfItems,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppTheme.spacing12),
            Row(
              children: [
                Expanded(
                  child: Slider(
                    value: _lastNItems.toDouble(),
                    min: 5,
                    max: 100,
                    divisions: 19,
                    label: _lastNItems.toString(),
                    onChanged: (value) {
                      setState(() => _lastNItems = value.toInt());
                    },
                  ),
                ),
                const SizedBox(width: AppTheme.spacing12),
                SizedBox(
                  width: 50,
                  child: Text(
                    _lastNItems.toString(),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
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
        padding: const EdgeInsets.all(AppTheme.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.itemOrder,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppTheme.spacing12),
            RadioListTile<ItemOrder>(
              title: Text(l10n.randomOrder, style: theme.textTheme.bodyMedium),
              value: ItemOrder.random,
              groupValue: _itemOrder,
              onChanged: (value) {
                if (value != null) {
                  setState(() => _itemOrder = value);
                }
              },
              contentPadding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
            ),
            RadioListTile<ItemOrder>(
              title: Text(l10n.sequentialOrder, style: theme.textTheme.bodyMedium),
              value: ItemOrder.sequential,
              groupValue: _itemOrder,
              onChanged: (value) {
                if (value != null) {
                  setState(() => _itemOrder = value);
                }
              },
              contentPadding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
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
        padding: const EdgeInsets.all(AppTheme.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.displayLanguage,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppTheme.spacing12),
            RadioListTile<DisplayLanguage>(
              title: Text('${l10n.motherTongue} (${widget.package.languageName1})', style: theme.textTheme.bodyMedium),
              value: DisplayLanguage.motherTongue,
              groupValue: _displayLanguage,
              onChanged: (value) {
                if (value != null) {
                  setState(() => _displayLanguage = value);
                }
              },
              contentPadding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
            ),
            RadioListTile<DisplayLanguage>(
              title: Text('${l10n.targetLanguage} (${widget.package.languageName2})', style: theme.textTheme.bodyMedium),
              value: DisplayLanguage.targetLanguage,
              groupValue: _displayLanguage,
              onChanged: (value) {
                if (value != null) {
                  setState(() => _displayLanguage = value);
                }
              },
              contentPadding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
            ),
            RadioListTile<DisplayLanguage>(
              title: Text(l10n.randomLanguage, style: theme.textTheme.bodyMedium),
              value: DisplayLanguage.random,
              groupValue: _displayLanguage,
              onChanged: (value) {
                if (value != null) {
                  setState(() => _displayLanguage = value);
                }
              },
              contentPadding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
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
        padding: const EdgeInsets.all(AppTheme.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.categoryFilter,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppTheme.spacing8),
            Text(
              l10n.categoryFilterHint,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: AppTheme.spacing12),
            if (_allCategories.isEmpty)
              Text(
                l10n.noCategories,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              )
            else
              Wrap(
                spacing: AppTheme.spacing8,
                runSpacing: AppTheme.spacing8,
                children: _allCategories.map((category) {
                  final isSelected = _selectedCategoryIds.contains(category.id);
                  return FilterChip(
                    selected: isSelected,
                    label: Text(
                      category.name,
                      style: theme.textTheme.bodyMedium,
                    ),
                    avatar: Icon(
                      isSelected ? Icons.check_circle : Icons.label_outline,
                      size: 18,
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

  Widget _buildDontKnowThresholdField(ThemeData theme, AppLocalizations l10n) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.dontKnowThreshold,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppTheme.spacing8),
            Text(
              l10n.dontKnowThresholdHint,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: AppTheme.spacing12),
            Row(
              children: [
                Expanded(
                  child: Slider(
                    value: _dontKnowThreshold.toDouble(),
                    min: 1,
                    max: 10,
                    divisions: 9,
                    label: _dontKnowThreshold.toString(),
                    onChanged: (value) {
                      setState(() => _dontKnowThreshold = value.toInt());
                    },
                  ),
                ),
                const SizedBox(width: AppTheme.spacing12),
                SizedBox(
                  width: 50,
                  child: Text(
                    _dontKnowThreshold.toString(),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(ThemeData theme, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Start Training button
        ElevatedButton.icon(
          onPressed: _startTraining,
          icon: const Icon(Icons.play_arrow, size: 24),
          label: Text(
            l10n.startTrainingRally,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onPrimary,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
            padding: const EdgeInsets.symmetric(
              vertical: AppTheme.spacing16,
              horizontal: AppTheme.spacing24,
            ),
            minimumSize: const Size.fromHeight(56),
          ),
        ),
        const SizedBox(height: AppTheme.spacing12),
        // Clear Settings button
        OutlinedButton.icon(
          onPressed: _clearSettings,
          icon: const Icon(Icons.clear_all, size: 20),
          label: Text(l10n.clearTrainingSettings),
          style: OutlinedButton.styleFrom(
            foregroundColor: theme.colorScheme.error,
            side: BorderSide(color: theme.colorScheme.error),
            padding: const EdgeInsets.symmetric(
              vertical: AppTheme.spacing12,
              horizontal: AppTheme.spacing24,
            ),
            minimumSize: const Size.fromHeight(48),
          ),
        ),
      ],
    );
  }
}

