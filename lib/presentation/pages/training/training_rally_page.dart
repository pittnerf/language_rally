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
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/badge_helper.dart';
import '../../../core/services/tts_service.dart';
import '../../../data/models/training_settings.dart';
import '../../../data/models/language_package.dart';
import '../../../data/models/item.dart';
import '../../../data/models/badge_event.dart';
import '../../../data/models/training_statistics.dart';
import '../../../data/repositories/item_repository.dart';
import '../../../data/repositories/training_statistics_repository.dart';
import '../../../l10n/app_localizations.dart';
import '../../providers/app_settings_provider.dart';
import '../../widgets/feedback_animation.dart';

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
  final _statsRepo = TrainingStatisticsRepository();
  final _ttsService = TtsService();

  List<Item> _filteredItems = [];
  int _currentItemIndex = 0;
  bool _isLoading = true;
  bool _isAnswerRevealed = false;
  bool _displayLanguage1 =
      true; // true = show language1, false = show language2
  bool _userKnows = false; // Track if user clicked "I know"
  final _random = math.Random();

  // Training session history tracking
  int _totalGuesses = 0;
  int _successfulGuesses = 0;
  final List<double> _historyPercentages =
      []; // Stores success percentage after each guess

  // Badge tracking
  String? _currentBadge; // Current badge in this training session
  final List<BadgeEvent> _badgeEvents = []; // Badge events in this session
  int _minItemsForBadges =
      10; // Minimum items required for badges (loaded from settings)
  int _itemsSinceLastBadgeEvent =
      0; // Track items evaluated since last badge event

  // Feedback animation
  bool _showFeedbackAnimation = false;
  bool _feedbackIsSuccess = false;

  // Answer section positioning and cover animation
  final GlobalKey _answerSectionKey = GlobalKey();
  bool _showAnswerCover = true;

  // Random example selection for "examples" item type
  final Map<String, int> _selectedExampleIndexes =
      {}; // Map itemId to example index

  @override
  void initState() {
    super.initState();
    _ttsService.initialize();
    _loadSettings();
    _loadCurrentBadge();
    _loadAndFilterItems();
  }

  @override
  void dispose() {
    _ttsService.stop();
    super.dispose();
  }

  void _loadSettings() {
    final appSettings = ref.read(appSettingsProvider);
    _minItemsForBadges = appSettings.minItemsForBadges;
  }

  Future<void> _loadCurrentBadge() async {
    final stats = await _statsRepo.getStatisticsForPackage(widget.package.id);
    if (mounted) {
      setState(() {
        _currentBadge = stats?.currentBadge;
      });
    }
  }

  Future<void> _loadAndFilterItems() async {
    setState(() => _isLoading = true);

    try {
      List<Item> allItems = await _itemRepo.getItemsForPackage(
        widget.package.id,
      );

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
          filteredItems = allItems
              .where((item) => item.dontKnowCounter > 0 || !item.isKnown)
              .toList();
          break;
        case ItemScope.onlyImportant:
          filteredItems = allItems.where((item) => item.isImportant).toList();
          break;
        case ItemScope.onlyFavourite:
          filteredItems = allItems.where((item) => item.isFavourite).toList();
          break;
      }

      // Apply category filter if categories are selected
      if (widget.settings.selectedCategoryIds.isNotEmpty) {
        filteredItems = filteredItems.where((item) {
          return item.categoryIds.any(
            (catId) => widget.settings.selectedCategoryIds.contains(catId),
          );
        }).toList();
      }

      // Apply item type filter - only include items with examples when in examples mode
      if (widget.settings.itemType == ItemType.examples) {
        filteredItems = filteredItems
            .where((item) => item.examples.isNotEmpty)
            .toList();
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
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.errorLoadingItems(e.toString())),
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

  /// Get or select a random example index for an item
  /// Used when itemType is "examples" to consistently show the same random example
  int _getOrSelectRandomExampleIndex(Item item) {
    if (item.examples.isEmpty) return -1;

    if (!_selectedExampleIndexes.containsKey(item.id)) {
      _selectedExampleIndexes[item.id] = _random.nextInt(item.examples.length);
    }

    return _selectedExampleIndexes[item.id]!;
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
      _showAnswerCover = false; // Remove the cover
    });

    // Track statistics
    _totalGuesses++;
    if (userKnows) {
      _successfulGuesses++;
    }
    _updateHistoryPercentage();

    // Small delay to let cover animation start, then show feedback animation
    await Future.delayed(const Duration(milliseconds: 100));

    if (mounted) {
      setState(() {
        _showFeedbackAnimation = true;
        _feedbackIsSuccess = userKnows;
      });
    }

    if (userKnows) {
      // User knows - decrease don't know counter by 1 (if > 0)
      int newCounter = currentItem.dontKnowCounter > 0
          ? currentItem.dontKnowCounter - 1
          : 0;
      bool newIsKnown =
          newCounter == 0; // Set isKnown to true only if counter reaches 0

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

    // Track statistics - user didn't know either, so it's a failure
    // Note: This counts as an additional guess that failed
    _totalGuesses++;
    _updateHistoryPercentage();

    // Increment don't know counter (even if already incremented when clicking "I don't know")
    final updatedItem = currentItem.copyWith(
      dontKnowCounter: currentItem.dontKnowCounter + 1,
      isKnown: false,
    );
    await _itemRepo.updateItem(updatedItem);
    _filteredItems[_currentItemIndex] = updatedItem;

    _moveToNextItem();
  }

  void _updateHistoryPercentage() {
    if (_totalGuesses > 0) {
      final percentage = (_successfulGuesses / _totalGuesses) * 100;
      setState(() {
        _historyPercentages.add(percentage);
      });

      // Check for badge changes
      _checkBadgeChanges(percentage);
    }
  }

  Future<void> _checkBadgeChanges(double currentAccuracy) async {
    // Increment counter for items evaluated
    _itemsSinceLastBadgeEvent++;

    // Only check for badge changes if enough items have been evaluated since last badge event
    if (_itemsSinceLastBadgeEvent < _minItemsForBadges) {
      return;
    }

    // Get the badge based on current accuracy and total guesses
    final newBadgeId = BadgeHelper.getBadgeIdForAccuracy(
      currentAccuracy,
      totalAnswers: _totalGuesses,
      minAnswersRequired: _minItemsForBadges,
    );

    // Check if badge changed
    if (newBadgeId != _currentBadge) {
      // Reset counter since a badge event occurred
      _itemsSinceLastBadgeEvent = 0;

      // Badge lost or earned
      if (_currentBadge != null &&
          (newBadgeId == null ||
              BadgeHelper.badgeLevels.indexWhere((b) => b.id == newBadgeId) <
                  BadgeHelper.badgeLevels.indexWhere(
                    (b) => b.id == _currentBadge!,
                  ))) {
        // Badge lost
        _badgeEvents.add(
          BadgeEvent.lost(
            badgeId: _currentBadge!,
            totalAnswers: _totalGuesses,
            accuracy: currentAccuracy,
          ),
        );
        _showBadgeLostNotification(_currentBadge!);
      }

      if (newBadgeId != null && newBadgeId != _currentBadge) {
        // New badge earned
        _badgeEvents.add(
          BadgeEvent.earned(
            badgeId: newBadgeId,
            totalAnswers: _totalGuesses,
            accuracy: currentAccuracy,
          ),
        );
        _showBadgeEarnedNotification(newBadgeId);
      }

      setState(() {
        _currentBadge = newBadgeId;
      });

      // Save to database
      await _updatePackageBadge(newBadgeId);
    }
  }

  Future<void> _updatePackageBadge(String? badgeId) async {
    // Get or create statistics
    var stats = await _statsRepo.getStatisticsForPackage(widget.package.id);

    if (stats == null) {
      stats = TrainingStatistics(
        packageId: widget.package.id,
        lastTrainedAt: DateTime.now(),
        currentBadge: badgeId,
      );
    } else {
      stats = stats.copyWith(
        currentBadge: badgeId,
        lastTrainedAt: DateTime.now(),
      );
    }

    await _statsRepo.saveStatistics(stats);
  }

  void _showBadgeEarnedNotification(String badgeId) {
    final badgeLevel = BadgeHelper.getBadgeLevelById(badgeId);
    final l10n = AppLocalizations.of(context)!;

    if (badgeLevel != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Text(badgeLevel.emoji, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  l10n.badgeEarnedWithName(badgeLevel.name),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void _showBadgeLostNotification(String badgeId) {
    final badgeLevel = BadgeHelper.getBadgeLevelById(badgeId);
    final l10n = AppLocalizations.of(context)!;

    if (badgeLevel != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.warning, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  l10n.badgeLostWithName(badgeLevel.name),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.orange,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void _moveToNextItem() async {
    // For onlyUnknown scope, refresh the filtered items to reflect updated counters
    if (widget.settings.itemScope == ItemScope.onlyUnknown) {
      await _refreshFilteredItemsForUnknown();
    }

    if (_currentItemIndex < _filteredItems.length - 1) {
      setState(() {
        _currentItemIndex++;
        _isAnswerRevealed = false;
        _userKnows = false;
        _showAnswerCover = true; // Reset cover for next item
        _determineDisplayLanguage();
      });
    } else {
      // Reached the last item
      // Check if we should loop back or end training based on scope
      final shouldLoop =
          widget.settings.itemScope == ItemScope.all ||
          widget.settings.itemScope == ItemScope.lastN ||
          widget.settings.itemScope == ItemScope.onlyImportant ||
          widget.settings.itemScope == ItemScope.onlyFavourite;

      if (shouldLoop && _filteredItems.isNotEmpty) {
        // Loop back to the first item
        setState(() {
          _currentItemIndex = 0;
          _isAnswerRevealed = false;
          _userKnows = false;
          _showAnswerCover = true; // Reset cover for next item
          _determineDisplayLanguage();
        });
      } else if (widget.settings.itemScope == ItemScope.onlyUnknown &&
          _filteredItems.isEmpty) {
        // No more unknown items - training complete
        _showTrainingCompleteDialog();
      } else {
        // No more items in general
        _showTrainingCompleteDialog();
      }
    }
  }

  Future<void> _refreshFilteredItemsForUnknown() async {
    try {
      List<Item> allItems = await _itemRepo.getItemsForPackage(
        widget.package.id,
      );

      // Apply onlyUnknown filter
      List<Item> filteredItems = allItems
          .where((item) => item.dontKnowCounter > 0 || !item.isKnown)
          .toList();

      // Apply category filter if categories are selected
      if (widget.settings.selectedCategoryIds.isNotEmpty) {
        filteredItems = filteredItems.where((item) {
          return item.categoryIds.any(
            (catId) => widget.settings.selectedCategoryIds.contains(catId),
          );
        }).toList();
      }

      // Apply item order
      if (widget.settings.itemOrder == ItemOrder.random) {
        filteredItems.shuffle(_random);
      }

      if (mounted) {
        setState(() {
          _filteredItems = filteredItems;
          // If current index is out of bounds, reset to 0
          if (_currentItemIndex >= _filteredItems.length) {
            _currentItemIndex = 0;
          }
        });
      }
    } catch (e) {
      // Handle error silently or log it
      debugPrint('Error refreshing items: $e');
    }
  }

  void _showTrainingCompleteDialog() {
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
        appBar: AppBar(title: Text(l10n.trainingRally)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_filteredItems.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.trainingRally)),
        body: Center(child: Text(l10n.noMoreItemsToDisplay)),
      );
    }

    final currentItem = _filteredItems[_currentItemIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.trainingRally, style: theme.textTheme.titleSmall),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Text(
                '${_filteredItems.length} items',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(
                left: AppTheme.spacing8,
                right: AppTheme.spacing8,
                top: AppTheme.spacing8,
                bottom: 140, // Space for floating buttons
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Item status indicators (clickable for Important and Favourite)
                  _buildStatusIndicators(theme, currentItem),
                  //const SizedBox(height: AppTheme.spacing8),

                  // Question section (always visible)
                  _buildQuestionSection(theme, l10n, currentItem),
                  //const SizedBox(height: AppTheme.spacing8),

                  // Answer section (always visible, but covered when not revealed)
                  Stack(
                    key: _answerSectionKey,
                    clipBehavior: Clip.none,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildAnswerSection(theme, l10n, currentItem),
                          //const SizedBox(height: AppTheme.spacing8),

                          // Examples section
                          if (currentItem.examples.isNotEmpty) ...[
                            _buildExamplesSection(theme, l10n, currentItem),
                            //const SizedBox(height: AppTheme.spacing8),
                          ],
                        ],
                      ),
                      // Cover overlay with "?" icon
                      if (_showAnswerCover)
                        Positioned.fill(
                          child: AnimatedOpacity(
                            opacity: _showAnswerCover ? 1.0 : 0.0,
                            duration: const Duration(milliseconds: 300),
                            child: Card(
                              elevation: 4,
                              color: theme.colorScheme.surfaceContainerHighest
                                  .withValues(alpha: 1.0),
                              child: Center(
                                child: Icon(
                                  Icons.help_outline,
                                  size: 80,
                                  color: theme.colorScheme.primary.withValues(
                                    alpha: 0.6,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      // Feedback animation - positioned within this Stack
                      if (_showFeedbackAnimation)
                        Positioned(
                          right:
                              MediaQuery.of(context).size.width * 0.25 -
                              60, // From right edge, at 1/4 position
                          top: 0,
                          bottom: 0,
                          child: IgnorePointer(
                            child: Center(
                              child: FeedbackAnimation(
                                isSuccess: _feedbackIsSuccess,
                                onComplete: () {
                                  if (mounted) {
                                    setState(() {
                                      _showFeedbackAnimation = false;
                                    });
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),

                  // Training history chart
                  if (_historyPercentages.isNotEmpty) ...[
                    _buildHistoryChart(theme, l10n),
                  ],
                ],
              ),
            ),
          ),
          // Floating action buttons at the bottom
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildActionButtons(theme, l10n),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusIndicators(ThemeData theme, Item item) {
    final l10n = AppLocalizations.of(context)!;
    final screenWidth = MediaQuery.of(context).size.width;
    final isNarrow = screenWidth < 400; // Very narrow screens

    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 2,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: _toggleImportant,
                    borderRadius: BorderRadius.circular(8),
                    child: _buildStatusBadgeWithLabel(
                      theme,
                      Icons.bookmark,
                      item.isImportant,
                      theme.colorScheme.secondary,
                      l10n.important,
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: _toggleFavourite,
                    borderRadius: BorderRadius.circular(8),
                    child: _buildStatusBadgeWithLabel(
                      theme,
                      Icons.favorite,
                      item.isFavourite,
                      Colors.red,
                      l10n.favourite,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // isKnown is not clickable - Red exclamation for unknown, green checkmark for known
                  _buildStatusBadgeWithLabel(
                    theme,
                    (!item.isKnown || item.dontKnowCounter > 0)
                        ? Icons.error
                        : Icons.check_circle,
                    true, // Always active to show the proper color (red/green)
                    (!item.isKnown || item.dontKnowCounter > 0)
                        ? Colors.red
                        : Colors.green,
                    (!item.isKnown || item.dontKnowCounter > 0)
                        ? l10n.unknown
                        : l10n.known,
                    showBackground: false, // No background, just colored icon
                  ),
                  const SizedBox(width: 8),
                  _buildCounterBadge(
                    theme,
                    Icons.help_outline,
                    item.dontKnowCounter,
                    isNarrow,
                    l10n.stepsUntilLearned,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Current item badge and current training badge
            Flexible(
              flex: 1,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Current badge
                  if (_currentBadge != null && !isNarrow) ...[
                    Flexible(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.tertiaryContainer,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  BadgeHelper.getBadgeLevelById(
                                        _currentBadge!,
                                      )?.emoji ??
                                      '',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(width: 2),
                                Flexible(
                                  child: Text(
                                    BadgeHelper.getBadgeLevelById(
                                          _currentBadge!,
                                        )?.name ??
                                        '',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color:
                                          theme.colorScheme.onTertiaryContainer,
                                      fontSize: 11,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            l10n.badge,
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontSize: 8,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 4),
                  ],
                  // Current item counter
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          '${_currentItemIndex + 1}/${_filteredItems.length}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onPrimaryContainer,
                            fontSize: 11,
                          ),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        l10n.position,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 8,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadgeWithLabel(
    ThemeData theme,
    IconData icon,
    bool isActive,
    Color activeColor,
    String label, {
    bool showBackground = true,
  }) {
    final isErrorState = icon == Icons.error;
    final iconWidget = Icon(
      icon,
      color: isActive
          ? activeColor
          : theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
      size: 24,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showBackground)
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isActive
                  ? (isErrorState
                        ? theme.colorScheme.errorContainer
                        : activeColor.withValues(alpha: 0.1))
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: iconWidget,
          )
        else
          Padding(padding: const EdgeInsets.all(8), child: iconWidget),
        const SizedBox(height: 2),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            fontSize: 8,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildCounterBadge(
    ThemeData theme,
    IconData icon,
    int count,
    bool isNarrow,
    String label,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                count > 0
                    ? (isNarrow
                          ? '$count'
                          : '$count left') // Shorter text on narrow screens
                    : count.toString(),
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: count > 0
                      ? theme.colorScheme.onErrorContainer
                      : theme.colorScheme.onSurfaceVariant,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            fontSize: 8,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildQuestionSection(
    ThemeData theme,
    AppLocalizations l10n,
    Item item,
  ) {
    // Check if we're in "examples" mode
    final isExamplesMode = widget.settings.itemType == ItemType.examples;

    if (isExamplesMode && item.examples.isNotEmpty) {
      // Show a random example in the question language
      final exampleIndex = _getOrSelectRandomExampleIndex(item);
      final example = item.examples[exampleIndex];
      final exampleText = _displayLanguage1
          ? example.textLanguage1
          : example.textLanguage2;
      final languageCode =
          (_displayLanguage1
                  ? widget.package.languageCode1
                  : widget.package.languageCode2)
              .split('-')[0]
              .toUpperCase();

      // Check screen width for responsive design
      final screenWidth = MediaQuery.of(context).size.width;
      final isPortrait = screenWidth < 900;

      return Card(
        elevation: 2,
        color: theme.colorScheme.primaryContainer,
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacing8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '${l10n.question} - $languageCode',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.volume_up,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                    tooltip: 'Speak text',
                    onPressed: () {
                      final languageCodeFull = _displayLanguage1
                          ? item.language1Data.languageCode
                          : item.language2Data.languageCode;
                      _ttsService.speak(exampleText, languageCodeFull);
                    },
                  ),
                ],
              ),
              //const SizedBox(height: AppTheme.spacing8),
              Text(
                exampleText,
                style:
                    (isPortrait
                            ? theme.textTheme.titleMedium
                            : theme.textTheme.titleMedium)
                        ?.copyWith(
                          color: theme.colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.bold,
                        ),
              ),
            ],
          ),
        ),
      );
    }

    // Default: Dictionary items mode
    final languageData = _displayLanguage1
        ? item.language1Data
        : item.language2Data;
    final preText = languageData.preItem ?? '';
    final mainText = languageData.text;
    final postText = languageData.postItem ?? '';
    final languageCode =
        (_displayLanguage1
                ? widget.package.languageCode1
                : widget.package.languageCode2)
            .split('-')[0]
            .toUpperCase();

    // Check screen width for responsive design
    final screenWidth = MediaQuery.of(context).size.width;
    final isPortrait = screenWidth < 900;

    return Card(
      elevation: 2,
      color: theme.colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${l10n.question} - $languageCode',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: theme.colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.volume_up,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                  tooltip: 'Speak text',
                  onPressed: () {
                    final fullText =
                        '${preText.isNotEmpty ? "$preText " : ""}$mainText';
                    final languageCodeFull = _displayLanguage1
                        ? item.language1Data.languageCode
                        : item.language2Data.languageCode;
                    _ttsService.speak(fullText, languageCodeFull);
                  },
                ),
              ],
            ),
            //const SizedBox(height: AppTheme.spacing8),
            if (preText.isNotEmpty) ...[
              Text(
                preText,
                style:
                    (isPortrait
                            ? theme.textTheme.bodySmall
                            : theme.textTheme.bodyMedium)
                        ?.copyWith(
                          color: theme.colorScheme.onPrimaryContainer
                              .withValues(alpha: 0.8),
                          fontStyle: FontStyle.italic,
                        ),
              ),
              const SizedBox(height: AppTheme.spacing4),
            ],
            Text(
              mainText,
              style:
                  (isPortrait
                          ? theme.textTheme.titleMedium
                          : theme.textTheme.titleMedium)
                      ?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
            ),
            if (postText.isNotEmpty) ...[
              const SizedBox(height: AppTheme.spacing4),
              Text(
                postText,
                style:
                    (isPortrait
                            ? theme.textTheme.bodySmall
                            : theme.textTheme.bodyMedium)
                        ?.copyWith(
                          color: theme.colorScheme.onPrimaryContainer
                              .withValues(alpha: 0.8),
                          fontStyle: FontStyle.italic,
                        ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerSection(
    ThemeData theme,
    AppLocalizations l10n,
    Item item,
  ) {
    // Check if we're in "examples" mode
    final isExamplesMode = widget.settings.itemType == ItemType.examples;

    if (isExamplesMode && item.examples.isNotEmpty) {
      // Show the answer language pair of the random example, then the full item
      final exampleIndex = _getOrSelectRandomExampleIndex(item);
      final example = item.examples[exampleIndex];
      final exampleText = !_displayLanguage1
          ? example.textLanguage1
          : example.textLanguage2;
      final languageCode =
          (!_displayLanguage1
                  ? widget.package.languageCode1
                  : widget.package.languageCode2)
              .split('-')[0]
              .toUpperCase();

      // Check screen width for responsive design
      final screenWidth = MediaQuery.of(context).size.width;
      final isPortrait = screenWidth < 900;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Example answer
          Card(
            elevation: 2,
            color: theme.colorScheme.secondaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spacing8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${l10n.answer} - $languageCode',
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: theme.colorScheme.onSecondaryContainer,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.volume_up,
                          color: theme.colorScheme.onSecondaryContainer,
                        ),
                        tooltip: 'Speak text',
                        onPressed: () {
                          final languageCodeFull = !_displayLanguage1
                              ? item.language1Data.languageCode
                              : item.language2Data.languageCode;
                          _ttsService.speak(exampleText, languageCodeFull);
                        },
                      ),
                    ],
                  ),
                  //const SizedBox(height: AppTheme.spacing8),
                  Text(
                    exampleText,
                    style:
                        (isPortrait
                                ? theme.textTheme.titleMedium
                                : theme.textTheme.titleMedium)
                            ?.copyWith(
                              color: theme.colorScheme.onSecondaryContainer,
                              fontWeight: FontWeight.bold,
                            ),
                  ),
                ],
              ),
            ),
          ),
          //const SizedBox(height: AppTheme.spacing8),
          // Full item details (dictionary item)
          _buildFullItemCard(theme, l10n, item, isPortrait),
        ],
      );
    }

    // Default: Dictionary items mode
    final languageData = !_displayLanguage1
        ? item.language1Data
        : item.language2Data;
    final preText = languageData.preItem ?? '';
    final mainText = languageData.text;
    final postText = languageData.postItem ?? '';
    final languageCode =
        (!_displayLanguage1
                ? widget.package.languageCode1
                : widget.package.languageCode2)
            .split('-')[0]
            .toUpperCase();

    // Check screen width for responsive design
    final screenWidth = MediaQuery.of(context).size.width;
    final isPortrait = screenWidth < 900;

    return Card(
      elevation: 2,
      color: theme.colorScheme.secondaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${l10n.answer} - $languageCode',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: theme.colorScheme.onSecondaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.volume_up,
                    color: theme.colorScheme.onSecondaryContainer,
                  ),
                  tooltip: 'Speak text',
                  onPressed: () {
                    final fullText =
                        '${preText.isNotEmpty ? "$preText " : ""}$mainText';
                    final languageCodeFull = !_displayLanguage1
                        ? item.language1Data.languageCode
                        : item.language2Data.languageCode;
                    _ttsService.speak(fullText, languageCodeFull);
                  },
                ),
              ],
            ),
            //const SizedBox(height: AppTheme.spacing8),
            if (preText.isNotEmpty) ...[
              Text(
                preText,
                style:
                    (isPortrait
                            ? theme.textTheme.bodySmall
                            : theme.textTheme.bodyMedium)
                        ?.copyWith(
                          color: theme.colorScheme.onSecondaryContainer
                              .withValues(alpha: 0.8),
                          fontStyle: FontStyle.italic,
                        ),
              ),
              const SizedBox(height: AppTheme.spacing4),
            ],
            Text(
              mainText,
              style:
                  (isPortrait
                          ? theme.textTheme.titleMedium
                          : theme.textTheme.titleMedium)
                      ?.copyWith(
                        color: theme.colorScheme.onSecondaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
            ),
            if (postText.isNotEmpty) ...[
              const SizedBox(height: AppTheme.spacing4),
              Text(
                postText,
                style:
                    (isPortrait
                            ? theme.textTheme.bodySmall
                            : theme.textTheme.bodyMedium)
                        ?.copyWith(
                          color: theme.colorScheme.onSecondaryContainer
                              .withValues(alpha: 0.8),
                          fontStyle: FontStyle.italic,
                        ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Build full item card showing both languages (used in examples mode)
  Widget _buildFullItemCard(
    ThemeData theme,
    AppLocalizations l10n,
    Item item,
    bool isPortrait,
  ) {
    return Card(
      elevation: 1,
      color: theme.colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Language 1
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.package.languageCode1
                            .split('-')[0]
                            .toUpperCase(),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacing4),
                      if (item.language1Data.preItem?.isNotEmpty ?? false) ...[
                        Text(
                          item.language1Data.preItem!,
                          style:
                              (isPortrait
                                      ? theme.textTheme.bodySmall
                                      : theme.textTheme.bodyMedium)
                                  ?.copyWith(
                                    fontStyle: FontStyle.italic,
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                        ),
                        const SizedBox(height: 2),
                      ],
                      Text(
                        item.language1Data.text,
                        style:
                            (isPortrait
                                    ? theme.textTheme.bodyMedium
                                    : theme.textTheme.bodyLarge)
                                ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      if (item.language1Data.postItem?.isNotEmpty ?? false) ...[
                        const SizedBox(height: 2),
                        Text(
                          item.language1Data.postItem!,
                          style:
                              (isPortrait
                                      ? theme.textTheme.bodySmall
                                      : theme.textTheme.bodyMedium)
                                  ?.copyWith(
                                    fontStyle: FontStyle.italic,
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                        ),
                      ],
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.volume_up, size: 20),
                  tooltip: 'Speak',
                  onPressed: () {
                    final fullText =
                        '${item.language1Data.preItem?.isNotEmpty ?? false ? "${item.language1Data.preItem} " : ""}${item.language1Data.text}';
                    _ttsService.speak(
                      fullText,
                      item.language1Data.languageCode,
                    );
                  },
                ),
              ],
            ),
            //const SizedBox(height: AppTheme.spacing8),
            Divider(color: theme.colorScheme.outlineVariant),
            //const SizedBox(height: AppTheme.spacing8),
            // Language 2
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.package.languageCode2
                            .split('-')[0]
                            .toUpperCase(),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacing4),
                      if (item.language2Data.preItem?.isNotEmpty ?? false) ...[
                        Text(
                          item.language2Data.preItem!,
                          style:
                              (isPortrait
                                      ? theme.textTheme.bodySmall
                                      : theme.textTheme.bodyMedium)
                                  ?.copyWith(
                                    fontStyle: FontStyle.italic,
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                        ),
                        const SizedBox(height: 2),
                      ],
                      Text(
                        item.language2Data.text,
                        style:
                            (isPortrait
                                    ? theme.textTheme.bodyMedium
                                    : theme.textTheme.bodyLarge)
                                ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      if (item.language2Data.postItem?.isNotEmpty ?? false) ...[
                        const SizedBox(height: 2),
                        Text(
                          item.language2Data.postItem!,
                          style:
                              (isPortrait
                                      ? theme.textTheme.bodySmall
                                      : theme.textTheme.bodyMedium)
                                  ?.copyWith(
                                    fontStyle: FontStyle.italic,
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                        ),
                      ],
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.volume_up, size: 20),
                  tooltip: 'Speak',
                  onPressed: () {
                    final fullText =
                        '${item.language2Data.preItem?.isNotEmpty ?? false ? "${item.language2Data.preItem} " : ""}${item.language2Data.text}';
                    _ttsService.speak(
                      fullText,
                      item.language2Data.languageCode,
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExamplesSection(
    ThemeData theme,
    AppLocalizations l10n,
    Item item,
  ) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing8),
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
            //const SizedBox(height: AppTheme.spacing8),
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isPortrait = screenWidth < 900;

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(AppTheme.spacing8),
      child: SafeArea(
        top: false,
        child: !_isAnswerRevealed
            ? Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _handleKnowResponse(true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          vertical: AppTheme.spacing8,
                          horizontal: AppTheme.spacing8,
                        ),
                        minimumSize: const Size.fromHeight(48),
                        elevation: 4,
                      ),
                      icon: const Icon(Icons.check, size: 20),
                      label: Text(
                        l10n.iKnow,
                        style:
                            (isPortrait
                                    ? theme.textTheme.titleSmall
                                    : theme.textTheme.titleMedium)
                                ?.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacing8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _handleKnowResponse(false),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          vertical: AppTheme.spacing8,
                          horizontal: AppTheme.spacing8,
                        ),
                        minimumSize: const Size.fromHeight(48),
                        elevation: 4,
                      ),
                      icon: const Icon(Icons.quiz, size: 20),
                      label: Text(
                        l10n.iDontKnow,
                        style:
                            (isPortrait
                                    ? theme.textTheme.titleSmall
                                    : theme.textTheme.titleMedium)
                                ?.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              )
            : _userKnows
            ? Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _moveToNextItem,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(
                          vertical: AppTheme.spacing8,
                          horizontal: AppTheme.spacing8,
                        ),
                        minimumSize: const Size.fromHeight(48),
                        elevation: 4,
                      ),
                      icon: const Icon(Icons.arrow_forward, size: 20),
                      label: Text(
                        l10n.nextItem,
                        style:
                            (isPortrait
                                    ? theme.textTheme.titleSmall
                                    : theme.textTheme.titleMedium)
                                ?.copyWith(color: theme.colorScheme.onPrimary),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacing8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _handleDidNotKnowEither,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          vertical: AppTheme.spacing8,
                          horizontal: AppTheme.spacing8,
                        ),
                        minimumSize: const Size.fromHeight(48),
                        elevation: 4,
                      ),
                      icon: const Icon(Icons.close, size: 20),
                      label: Text(
                        l10n.iDidNotKnowEither,
                        style:
                            (isPortrait
                                    ? theme.textTheme.titleSmall
                                    : theme.textTheme.titleMedium)
                                ?.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              )
            : ElevatedButton.icon(
                onPressed: _moveToNextItem,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(
                    vertical: AppTheme.spacing8,
                    horizontal: AppTheme.spacing8,
                  ),
                  minimumSize: const Size.fromHeight(48),
                  elevation: 4,
                ),
                icon: const Icon(Icons.arrow_forward, size: 20),
                label: Text(
                  l10n.nextItem,
                  style:
                      (isPortrait
                              ? theme.textTheme.titleSmall
                              : theme.textTheme.titleMedium)
                          ?.copyWith(color: theme.colorScheme.onPrimary),
                ),
              ),
      ),
    );
  }

  Widget _buildHistoryChart(ThemeData theme, AppLocalizations l10n) {
    // Calculate current success rate
    final currentSuccessRate = _totalGuesses > 0
        ? (_successfulGuesses / _totalGuesses * 100).toStringAsFixed(1)
        : '0.0';

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Training Session Progress',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    '$currentSuccessRate%',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacing4),
            Row(
              children: [
                _buildStatChip(
                  theme,
                  l10n.iKnow,
                  _successfulGuesses,
                  Colors.green,
                ),
                const SizedBox(width: 8),
                _buildStatChip(
                  theme,
                  l10n.iDontKnow,
                  _totalGuesses - _successfulGuesses,
                  Colors.orange,
                ),
                const SizedBox(width: 8),
                _buildStatChip(
                  theme,
                  l10n.total,
                  _totalGuesses,
                  theme.colorScheme.primary,
                ),
              ],
            ),
            //const SizedBox(height: AppTheme.spacing8),
            SizedBox(
              height: 150,
              child: LineChart(
                LineChartData(
                  minY: 0,
                  maxY: 100,
                  lineBarsData: [
                    LineChartBarData(
                      spots: _historyPercentages.asMap().entries.map((entry) {
                        return FlSpot(entry.key.toDouble(), entry.value);
                      }).toList(),
                      isCurved: true,
                      color: theme.colorScheme.primary,
                      barWidth: 3,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 4,
                            color: theme.colorScheme.primary,
                            strokeWidth: 2,
                            strokeColor: theme.colorScheme.surface,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        color: theme.colorScheme.primary.withValues(alpha: 0.1),
                      ),
                    ),
                  ],
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        interval: 25,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '${value.toInt()}%',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: math.max(
                          1,
                          (_historyPercentages.length / 5).ceil().toDouble(),
                        ),
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() < _historyPercentages.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                '${value.toInt() + 1}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    horizontalInterval: 25,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: theme.colorScheme.outlineVariant.withValues(
                          alpha: 0.3,
                        ),
                        strokeWidth: 1,
                      );
                    },
                    drawVerticalLine: false,
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border(
                      left: BorderSide(
                        color: theme.colorScheme.outline,
                        width: 1,
                      ),
                      bottom: BorderSide(
                        color: theme.colorScheme.outline,
                        width: 1,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatChip(ThemeData theme, String label, int value, Color color) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isPortrait = screenWidth < 900;

    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isPortrait ? 4 : 8,
          vertical: isPortrait ? 4 : 6,
        ),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                '$label: ',
                style:
                    (isPortrait
                            ? theme.textTheme.labelSmall
                            : theme.textTheme.bodySmall)
                        ?.copyWith(color: color, fontWeight: FontWeight.w500),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              value.toString(),
              style:
                  (isPortrait
                          ? theme.textTheme.labelSmall
                          : theme.textTheme.bodySmall)
                      ?.copyWith(color: color, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
