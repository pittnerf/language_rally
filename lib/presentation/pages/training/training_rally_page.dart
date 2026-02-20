// lib/presentation/pages/training/training_rally_page.dart
//
// Training Rally Page - Interactive training session based on configured settings
//
// FEATURES:
// - Filters items based on training settings (all, last N, unknown, important)
// - Random or sequential item presentation
// - Display language selection (mother tongue, target language, random)
// - Progressive reveal (question -> answer with examples)
// - Track statistics (I know / I don't know)
// - Don't know counter tracking

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math' as math;
import '../../../core/theme/app_theme.dart';
import '../../../data/models/training_settings.dart';
import '../../../data/models/language_package.dart';
import '../../../data/models/item.dart';
import '../../../data/repositories/item_repository.dart';
import '../../../l10n/app_localizations.dart';

class TrainingRallyPage extends ConsumerStatefulWidget {
  final LanguagePackage package;
  final TrainingSettings settings;

  const TrainingRallyPage({
    super.key,
    required this.package,
    required this.settings,
  });

  @override
  ConsumerState<TrainingRallyPage> createState() => _TrainingRallyPageState();
}

class _TrainingRallyPageState extends ConsumerState<TrainingRallyPage> {
  final _itemRepo = ItemRepository();

  List<Item> _filteredItems = [];
  int _currentItemIndex = 0;
  bool _isLoading = true;
  bool _isAnswerRevealed = false;
  bool _displayLanguage1 = true; // true = show language1, false = show language2
  bool _userKnows = false; // Track if user clicked "I know"
  final _random = math.Random();

  @override
  void initState() {
    super.initState();
    _loadAndFilterItems();
  }

  Future<void> _loadAndFilterItems() async {
    setState(() => _isLoading = true);

    try {
      List<Item> allItems = await _itemRepo.getItemsForPackage(widget.package.id);

      // Apply item scope filter
      List<Item> filteredItems = [];
      switch (widget.settings.itemScope) {
        case ItemScope.all:
          filteredItems = allItems;
          break;
        case ItemScope.lastN:
          // Get last N items based on creation order
          filteredItems = allItems.length > widget.settings.lastNItems
              ? allItems.sublist(allItems.length - widget.settings.lastNItems)
              : allItems;
          break;
        case ItemScope.onlyUnknown:
          filteredItems = allItems.where((item) => !item.isKnown).toList();
          break;
        case ItemScope.onlyImportant:
          filteredItems = allItems.where((item) => item.isImportant).toList();
          break;
      }

      // Apply category filter if categories are selected
      if (widget.settings.selectedCategoryIds.isNotEmpty) {
        filteredItems = filteredItems.where((item) {
          return item.categoryIds.any((catId) => widget.settings.selectedCategoryIds.contains(catId));
        }).toList();
      }

      // Apply item order
      if (widget.settings.itemOrder == ItemOrder.random) {
        filteredItems.shuffle(_random);
      }
      // Sequential order is already maintained (no action needed)

      if (mounted) {
        setState(() {
          _filteredItems = filteredItems;
          _isLoading = false;
        });

        // Check if there are items to display
        if (_filteredItems.isEmpty) {
          _showNoItemsDialog();
        } else {
          // Determine display language for first item
          _determineDisplayLanguage();
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading items: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  void _determineDisplayLanguage() {
    switch (widget.settings.displayLanguage) {
      case DisplayLanguage.motherTongue:
        _displayLanguage1 = true;
        break;
      case DisplayLanguage.targetLanguage:
        _displayLanguage1 = false;
        break;
      case DisplayLanguage.random:
        _displayLanguage1 = _random.nextBool();
        break;
    }
  }

  void _showNoItemsDialog() {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(l10n.noItems),
        content: Text(l10n.noMoreItemsToDisplay),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(); // Close training page
            },
            child: Text(l10n.ok),
          ),
        ],
      ),
    );
  }

  Future<void> _handleKnowResponse(bool userKnows) async {
    final currentItem = _filteredItems[_currentItemIndex];

    setState(() {
      _isAnswerRevealed = true;
      _userKnows = userKnows;
    });

    if (userKnows) {
      // User knows - decrease don't know counter by 1 (if > 0)
      int newCounter = currentItem.dontKnowCounter > 0 ? currentItem.dontKnowCounter - 1 : 0;
      bool newIsKnown = newCounter == 0; // Set isKnown to true only if counter reaches 0

      final updatedItem = currentItem.copyWith(
        dontKnowCounter: newCounter,
        isKnown: newIsKnown,
      );
      await _itemRepo.updateItem(updatedItem);
      _filteredItems[_currentItemIndex] = updatedItem;
    } else {
      // User doesn't know - increase don't know counter
      final updatedItem = currentItem.copyWith(
        dontKnowCounter: currentItem.dontKnowCounter + 1,
        isKnown: false, // Clear isKnown flag
      );
      await _itemRepo.updateItem(updatedItem);
      _filteredItems[_currentItemIndex] = updatedItem;
    }
  }

  Future<void> _handleDidNotKnowEither() async {
    final currentItem = _filteredItems[_currentItemIndex];

    // Increment don't know counter (even if already incremented when clicking "I don't know")
    final updatedItem = currentItem.copyWith(
      dontKnowCounter: currentItem.dontKnowCounter + 1,
      isKnown: false,
    );
    await _itemRepo.updateItem(updatedItem);
    _filteredItems[_currentItemIndex] = updatedItem;

    _moveToNextItem();
  }

  void _moveToNextItem() {
    if (_currentItemIndex < _filteredItems.length - 1) {
      setState(() {
        _currentItemIndex++;
        _isAnswerRevealed = false;
        _userKnows = false;
        _determineDisplayLanguage();
      });
    } else {
      // No more items
      final l10n = AppLocalizations.of(context)!;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: Text(l10n.trainingComplete),
          content: Text(l10n.allItemsCompleted),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop(); // Close training page
              },
              child: Text(l10n.ok),
            ),
          ],
        ),
      );
    }
  }


  Future<void> _toggleImportant() async {
    final currentItem = _filteredItems[_currentItemIndex];
    final updatedItem = currentItem.copyWith(
      isImportant: !currentItem.isImportant,
    );
    await _itemRepo.updateItem(updatedItem);
    setState(() {
      _filteredItems[_currentItemIndex] = updatedItem;
    });
  }

  Future<void> _toggleFavourite() async {
    final currentItem = _filteredItems[_currentItemIndex];
    final updatedItem = currentItem.copyWith(
      isFavourite: !currentItem.isFavourite,
    );
    await _itemRepo.updateItem(updatedItem);
    setState(() {
      _filteredItems[_currentItemIndex] = updatedItem;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text(l10n.trainingRally),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_filteredItems.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text(l10n.trainingRally),
        ),
        body: Center(
          child: Text(l10n.noMoreItemsToDisplay),
        ),
      );
    }

    final currentItem = _filteredItems[_currentItemIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.trainingRally,
          style: theme.textTheme.titleSmall,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Text(
                '${_currentItemIndex + 1} / ${_filteredItems.length}',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.spacing16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Item status indicators (clickable for Important and Favourite)
              _buildStatusIndicators(theme, currentItem),
              const SizedBox(height: AppTheme.spacing16),

              // Action buttons in a single line
              _buildActionButtons(theme, l10n),
              const SizedBox(height: AppTheme.spacing16),

              // Question section (always visible)
              _buildQuestionSection(theme, l10n, currentItem),
              const SizedBox(height: AppTheme.spacing24),

              // Answer section (visible only after reveal)
              if (_isAnswerRevealed) ...[
                _buildAnswerSection(theme, l10n, currentItem),
                const SizedBox(height: AppTheme.spacing16),

                // Examples section
                if (currentItem.examples.isNotEmpty) ...[
                  _buildExamplesSection(theme, l10n, currentItem),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIndicators(ThemeData theme, Item item) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InkWell(
              onTap: _toggleImportant,
              borderRadius: BorderRadius.circular(8),
              child: _buildStatusBadge(
                theme,
                Icons.star,
                item.isImportant,
                theme.colorScheme.primary,
              ),
            ),
            InkWell(
              onTap: _toggleFavourite,
              borderRadius: BorderRadius.circular(8),
              child: _buildStatusBadge(
                theme,
                Icons.favorite,
                item.isFavourite,
                Colors.red,
              ),
            ),
            // isKnown is not clickable
            _buildStatusBadge(
              theme,
              (!item.isKnown || item.dontKnowCounter > 0) ? Icons.close : Icons.check_circle,
              item.isKnown && item.dontKnowCounter == 0,
              (!item.isKnown || item.dontKnowCounter > 0) ? theme.colorScheme.onErrorContainer : Colors.green,
            ),
            _buildCounterBadge(
              theme,
              Icons.help_outline,
              item.dontKnowCounter,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(ThemeData theme, IconData icon, bool isActive, Color activeColor) {
    final isErrorState = icon == Icons.close;
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isActive
            ? (isErrorState ? theme.colorScheme.errorContainer : activeColor.withValues(alpha: 0.1))
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        icon,
        color: isActive ? activeColor : theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
        size: 24,
      ),
    );
  }

  Widget _buildCounterBadge(ThemeData theme, IconData icon, int count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: count > 0
            ? theme.colorScheme.errorContainer
            : theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: count > 0
                ? theme.colorScheme.onErrorContainer
                : theme.colorScheme.onSurfaceVariant,
            size: 20,
          ),
          const SizedBox(width: 4),
          Text(
            count > 0 ? '$count until learned' : count.toString(),
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: count > 0
                  ? theme.colorScheme.onErrorContainer
                  : theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionSection(ThemeData theme, AppLocalizations l10n, Item item) {
    final languageData = _displayLanguage1 ? item.language1Data : item.language2Data;
    final preText = languageData.preItem ?? '';
    final mainText = languageData.text;
    final postText = languageData.postItem ?? '';
    final languageName = _displayLanguage1 ? widget.package.languageName1 : widget.package.languageName2;

    return Card(
      elevation: 2,
      color: theme.colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.question,
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppTheme.spacing4),
            Text(
              languageName,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: AppTheme.spacing12),
            if (preText.isNotEmpty) ...[
              Text(
                preText,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.8),
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: AppTheme.spacing4),
            ],
            Text(
              mainText,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (postText.isNotEmpty) ...[
              const SizedBox(height: AppTheme.spacing4),
              Text(
                postText,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.8),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerSection(ThemeData theme, AppLocalizations l10n, Item item) {
    final languageData = !_displayLanguage1 ? item.language1Data : item.language2Data;
    final preText = languageData.preItem ?? '';
    final mainText = languageData.text;
    final postText = languageData.postItem ?? '';
    final languageName = !_displayLanguage1 ? widget.package.languageName1 : widget.package.languageName2;

    return Card(
      elevation: 2,
      color: theme.colorScheme.secondaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.answer,
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.onSecondaryContainer,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppTheme.spacing4),
            Text(
              languageName,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSecondaryContainer.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: AppTheme.spacing12),
            if (preText.isNotEmpty) ...[
              Text(
                preText,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSecondaryContainer.withValues(alpha: 0.8),
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: AppTheme.spacing4),
            ],
            Text(
              mainText,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.onSecondaryContainer,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (postText.isNotEmpty) ...[
              const SizedBox(height: AppTheme.spacing4),
              Text(
                postText,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSecondaryContainer.withValues(alpha: 0.8),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildExamplesSection(ThemeData theme, AppLocalizations l10n, Item item) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.examples,
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppTheme.spacing8),
            ...item.examples.map((example) {
              return Padding(
                padding: const EdgeInsets.only(bottom: AppTheme.spacing8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '• ',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (example.textLanguage1.isNotEmpty)
                            Text(
                              example.textLanguage1,
                              style: theme.textTheme.bodyMedium,
                            ),
                          if (example.textLanguage2.isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Text(
                              example.textLanguage2,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(ThemeData theme, AppLocalizations l10n) {
    if (!_isAnswerRevealed) {
      // Initial state: "I know" and "I don't know" side by side
      return Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => _handleKnowResponse(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                minimumSize: const Size.fromHeight(52),
              ),
              icon: const Icon(Icons.check, size: 22),
              label: Text(
                l10n.iKnow,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => _handleKnowResponse(false),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                minimumSize: const Size.fromHeight(52),
              ),
              icon: const Icon(Icons.quiz, size: 22),
              label: Text(
                l10n.iDontKnow,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      // After reveal
      if (_userKnows) {
        // User clicked "I know" - show both "I didn't know either" and "Next item"
        return Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _handleDidNotKnowEither,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  minimumSize: const Size.fromHeight(52),
                ),
                icon: const Icon(Icons.close, size: 22),
                label: Text(
                  l10n.iDidNotKnowEither,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _moveToNextItem,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  minimumSize: const Size.fromHeight(52),
                ),
                icon: const Icon(Icons.arrow_forward, size: 22),
                label: Text(
                  l10n.nextItem,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
          ],
        );
      } else {
        // User clicked "I don't know" - show only "Next" button (full width)
        return ElevatedButton.icon(
          onPressed: _moveToNextItem,
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            minimumSize: const Size.fromHeight(52),
          ),
          icon: const Icon(Icons.arrow_forward, size: 22),
          label: Text(
            l10n.nextItem,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onPrimary,
            ),
          ),
        );
      }
    }
  }
}





