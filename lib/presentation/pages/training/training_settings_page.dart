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
import '../../../data/repositories/app_settings_repository.dart';
import '../../../data/repositories/language_package_repository.dart';
import '../../../l10n/app_localizations.dart';
import 'training_rally_page.dart';

class TrainingSettingsPage extends ConsumerStatefulWidget {
  final LanguagePackage? package;

  const TrainingSettingsPage({
    super.key,
    this.package,
  });

  @override
  ConsumerState<TrainingSettingsPage> createState() => _TrainingSettingsPageState();
}

class _TrainingSettingsPageState extends ConsumerState<TrainingSettingsPage> {
  final _trainingSettingsRepo = TrainingSettingsRepository();
  final _categoryRepo = CategoryRepository();
  final _categoryScrollController = ScrollController();
  final _appSettingsRepo = AppSettingsRepository();
  final _packageRepo = LanguagePackageRepository();

  // Current selected package
  LanguagePackage? _currentPackage;
  List<LanguagePackage> _availablePackages = [];

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

  @override
  void dispose() {
    _categoryScrollController.dispose();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    setState(() => _isLoading = true);

    try {
      // Load all available packages
      final packages = await _packageRepo.getAllPackages();

      // Determine which package to use
      LanguagePackage? packageToUse;

      if (widget.package != null) {
        // Package was provided (coming from package list)
        packageToUse = widget.package;
      } else {
        // No package provided (coming from home page)
        // Try to load last trained package
        final appSettings = await _appSettingsRepo.loadSettings();
        if (appSettings.lastTrainedPackageId != null) {
          packageToUse = packages.firstWhere(
            (p) => p.id == appSettings.lastTrainedPackageId,
            orElse: () => packages.isNotEmpty ? packages.first : throw Exception('No packages available'),
          );
        } else {
          // No last trained package, use first available
          if (packages.isEmpty) {
            throw Exception('No packages available');
          }
          packageToUse = packages.first;
        }
      }

      if (packageToUse == null) {
        throw Exception('No valid package found');
      }

      // Load saved settings or create default
      final settings = await _trainingSettingsRepo.getSettingsForPackage(packageToUse.id);

      // Load categories
      final categories = await _categoryRepo.getCategoriesForPackage(packageToUse.id);

      if (mounted) {
        setState(() {
          _availablePackages = packages;
          _currentPackage = packageToUse;

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
            _lastNItems = 20;
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
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.errorLoadingSettings(e.toString())),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  /// Reload settings for a specific package (used when package is changed from dropdown)
  Future<void> _reloadSettingsForPackage(LanguagePackage package) async {
    try {
      // Load saved settings or create default
      final settings = await _trainingSettingsRepo.getSettingsForPackage(package.id);

      // Load categories
      final categories = await _categoryRepo.getCategoriesForPackage(package.id);

      if (mounted) {
        setState(() {
          _currentPackage = package;

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
            _lastNItems = 20;
            _itemOrder = ItemOrder.random;
            _displayLanguage = DisplayLanguage.random;
            _selectedCategoryIds = [];
            _dontKnowThreshold = 3;
          }
          _allCategories = categories;
        });
      }
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.errorLoadingSettings(e.toString())),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _saveSettings() async {
    if (_currentPackage == null) return;

    final settings = TrainingSettings(
      packageId: _currentPackage!.id,
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
    if (_currentPackage == null) return;

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
      await _trainingSettingsRepo.deleteSettings(_currentPackage!.id);
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
    if (_currentPackage == null) return;

    // Save current settings
    await _saveSettings();

    // Save the last trained package ID
    await _appSettingsRepo.saveLastTrainedPackageId(_currentPackage!.id);

    // Navigate to training rally page
    if (mounted) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => TrainingRallyPage(
            package: _currentPackage!,
            settings: TrainingSettings(
              packageId: _currentPackage!.id,
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bottomPadding = MediaQuery.of(context).padding.bottom;

          return Stack(
            children: [
              SafeArea(
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(
                    left: AppTheme.spacing8,
                    right: AppTheme.spacing8,
                    top: AppTheme.spacing8,
                    bottom: 80 + bottomPadding, // Space for floating buttons + system navigation
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
          // Floating action buttons at bottom - left and right
          Positioned(
            left: 8,
            right: 8,
            bottom: 8 + bottomPadding, // Add bottom padding for Android navigation
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Clear Settings button on the left
                Flexible(
                  child: ElevatedButton.icon(
                    onPressed: _clearSettings,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.errorContainer,
                      foregroundColor: theme.colorScheme.onErrorContainer,
                      padding: EdgeInsets.symmetric(
                        horizontal: isLandscape ? 12 : 8,
                        vertical: isLandscape ? 6 : 4,
                      ),
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    icon: Icon(Icons.clear_all, size: isLandscape ? 14 : 12),
                    label: Text(
                      l10n.clearTrainingSettings,
                      style: (isLandscape ? theme.textTheme.bodySmall : theme.textTheme.labelSmall),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Start Training button on the right
                Flexible(
                  child: ElevatedButton.icon(
                    onPressed: _startTraining,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                      padding: EdgeInsets.symmetric(
                        horizontal: isLandscape ? 12 : 8,
                        vertical: isLandscape ? 6 : 4,
                      ),
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    icon: Icon(Icons.play_arrow, size: isLandscape ? 16 : 14),
                    label: Text(
                      l10n.startTrainingRally,
                      style: (isLandscape ? theme.textTheme.bodySmall : theme.textTheme.labelSmall)?.copyWith(
                        color: theme.colorScheme.onPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    },
  ),
);
  }

  Widget _buildPackageInfo(ThemeData theme, AppLocalizations l10n) {
    if (_currentPackage == null) {
      return Card(
        elevation: 1,
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacing8),
          child: Text(
            l10n.noPackagesAvailable,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.error,
            ),
          ),
        ),
      );
    }

    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing8),
        child: widget.package == null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.selectPackage,
                    style: (isSmallScreen ? theme.textTheme.bodyMedium : theme.textTheme.titleSmall)?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacing8),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: _currentPackage!.id,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: isSmallScreen ? AppTheme.spacing4 : AppTheme.spacing8,
                              vertical: isSmallScreen ? AppTheme.spacing4 : AppTheme.spacing8,
                            ),
                            isDense: isSmallScreen,
                          ),
                          isExpanded: true,
                          items: _availablePackages.map((package) {
                            return DropdownMenuItem<String>(
                              value: package.id,
                              child: Text(
                                package.packageName ?? '${package.languageName1} - ${package.languageName2}',
                                style: isSmallScreen ? theme.textTheme.bodySmall : theme.textTheme.bodyMedium,
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) async {
                            if (newValue != null && newValue != _currentPackage!.id) {
                              final newPackage = _availablePackages.firstWhere(
                                (p) => p.id == newValue,
                              );
                              // Reload settings for the new package
                              await _reloadSettingsForPackage(newPackage);
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: AppTheme.spacing4),
                      Flexible(
                        child: Text(
                          '${_currentPackage!.languageCode1.split('-')[0].toUpperCase()} → ${_currentPackage!.languageCode2.split('-')[0].toUpperCase()}',
                          style: (isSmallScreen ? theme.textTheme.labelSmall : theme.textTheme.bodySmall)?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              )
            : Row(
                children: [
                  Expanded(
                    child: Text(
                      _currentPackage!.packageName ?? '${_currentPackage!.languageName1} - ${_currentPackage!.languageName2}',
                      style: (isSmallScreen ? theme.textTheme.titleSmall : theme.textTheme.titleMedium)?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacing8),
                  Text(
                    '${_currentPackage!.languageCode1.split('-')[0].toUpperCase()} → ${_currentPackage!.languageCode2.split('-')[0].toUpperCase()}',
                    style: (isSmallScreen ? theme.textTheme.labelSmall : theme.textTheme.bodySmall)?.copyWith(
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
            // Show lastNItems value control only when lastN is selected
            if (_itemScope == ItemScope.lastN) ...[
              const SizedBox(height: AppTheme.spacing8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          l10n.lastNValue(_lastNItems.toString()),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: _lastNItems > 5
                                  ? () => setState(() => _lastNItems -= 5)
                                  : null,
                              icon: const Icon(Icons.remove),
                              iconSize: 18,
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(
                                minWidth: 32,
                                minHeight: 32,
                              ),
                            ),
                            IconButton(
                              onPressed: _lastNItems < 200
                                  ? () => setState(() => _lastNItems += 5)
                                  : null,
                              icon: const Icon(Icons.add),
                              iconSize: 18,
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(
                                minWidth: 32,
                                minHeight: 32,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Slider(
                      value: _lastNItems.toDouble(),
                      min: 5,
                      max: 200,
                      divisions: 39, // (200-5)/5 = 39
                      label: _lastNItems.toString(),
                      onChanged: (value) {
                        setState(() => _lastNItems = value.round());
                      },
                    ),
                  ],
                ),
              ),
            ],
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
            _buildRadioOption<ItemScope>(
              theme,
              l10n.onlyFavourite,
              ItemScope.onlyFavourite,
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
              '${l10n.motherTongue} (${_currentPackage?.languageName1 ?? ''})',
              DisplayLanguage.motherTongue,
              _displayLanguage,
              (value) => setState(() => _displayLanguage = value),
            ),
            _buildRadioOption<DisplayLanguage>(
              theme,
              '${l10n.targetLanguage} (${_currentPackage?.languageName2 ?? ''})',
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
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  l10n.categoryFilter,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Flexible(
                  child: Text(
                    l10n.categoryFilterHint,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.right,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
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
              ConstrainedBox(
                constraints: const BoxConstraints(
                  maxHeight: 200, // Limit height to 200 pixels
                ),
                child: Scrollbar(
                  controller: _categoryScrollController,
                  thumbVisibility: true,
                  child: SingleChildScrollView(
                    controller: _categoryScrollController,
                    child: Wrap(
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
                  ),
                ),
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

