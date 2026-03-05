// lib/presentation/pages/training/pronunciation_practice_page.dart
//
// Pronunciation Practice Page - Interactive pronunciation training session
//
// FEATURES:
// - Record and compare user pronunciation
// - Visual feedback with tachometer showing match rate
// - Text-to-speech for listening to correct pronunciation
// - Item filtering based on training settings
// - Progress tracking with status indicators

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'dart:math' as math;
import '../../../core/theme/app_theme.dart';
import '../../../core/services/tts_service.dart';
import '../../../data/models/training_settings.dart';
import '../../../data/models/language_package.dart';
import '../../../data/models/item.dart';
import '../../../data/repositories/item_repository.dart';
import '../../../data/repositories/category_repository.dart';
import '../../../l10n/app_localizations.dart';

class PronunciationPracticePage extends ConsumerStatefulWidget {
  final LanguagePackage package;
  final TrainingSettings settings;

  const PronunciationPracticePage({
    super.key,
    required this.package,
    required this.settings,
  });

  @override
  ConsumerState<PronunciationPracticePage> createState() =>
      _PronunciationPracticePageState();
}

class _PronunciationPracticePageState
    extends ConsumerState<PronunciationPracticePage> {
  final _itemRepo = ItemRepository();
  final _categoryRepo = CategoryRepository();
  final _ttsService = TtsService();
  final _speech = stt.SpeechToText();

  List<Item> _filteredItems = [];
  int _currentItemIndex = 0;
  bool _isLoading = true;
  bool _displayLanguage1 = true;

  // Pronunciation practice state
  bool _isRecording = false;
  bool _hasRecorded = false;
  double _matchRate = 0.0;
  String _recordedText = '';
  bool _speechAvailable = false;

  // Statistics
  int _totalPracticed = 0;

  @override
  void initState() {
    super.initState();
    _ttsService.initialize();
    _initializeSpeech();
    _loadAndFilterItems();
  }

  @override
  void dispose() {
    _ttsService.stop();
    _speech.stop();
    super.dispose();
  }

  Future<void> _initializeSpeech() async {
    _speechAvailable = await _speech.initialize(
      onError: (error) => print('Speech recognition error: $error'),
      onStatus: (status) => print('Speech recognition status: $status'),
    );
    if (mounted) setState(() {});
  }

  Future<void> _loadAndFilterItems() async {
    setState(() => _isLoading = true);

    try {
      List<Item> items = [];

      if (widget.settings.selectedCategoryIds.isNotEmpty) {
        items = await _itemRepo
            .getItemsForCategories(widget.settings.selectedCategoryIds);
      } else {
        final categories =
            await _categoryRepo.getCategoriesForPackage(widget.package.id);
        final categoryIds = categories.map((c) => c.id).toList();
        if (categoryIds.isNotEmpty) {
          items = await _itemRepo.getItemsForCategories(categoryIds);
        }
      }

      // Filter based on item scope
      final filteredItems = _filterItemsByScope(items);

      // Shuffle if random order
      if (widget.settings.itemOrder == ItemOrder.random) {
        filteredItems.shuffle();
      }

      // Determine display language
      _determineDisplayLanguage();

      setState(() {
        _filteredItems = filteredItems;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  List<Item> _filterItemsByScope(List<Item> items) {
    switch (widget.settings.itemScope) {
      case ItemScope.all:
        return items;
      case ItemScope.lastN:
        // Since Item doesn't have createdAt, use lastReviewedAt or just take last N items
        final sorted = items.toList()
          ..sort((a, b) {
            final aDate = a.lastReviewedAt ?? DateTime(1970);
            final bDate = b.lastReviewedAt ?? DateTime(1970);
            return bDate.compareTo(aDate);
          });
        return sorted.take(widget.settings.lastNItems).toList();
      case ItemScope.onlyUnknown:
        return items.where((item) => !item.isKnown).toList();
      case ItemScope.onlyImportant:
        return items.where((item) => item.isImportant).toList();
      case ItemScope.onlyFavourite:
        return items.where((item) => item.isFavourite).toList();
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
        _displayLanguage1 = math.Random().nextBool();
        break;
    }
  }

  Future<void> _startRecording() async {
    if (!_speechAvailable) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.voiceInputPlaceholder),
        ),
      );
      return;
    }

    final currentItem = _filteredItems[_currentItemIndex];
    final languageData =
        _displayLanguage1 ? currentItem.language1Data : currentItem.language2Data;
    final languageCode = languageData.languageCode.split('-')[0];

    setState(() {
      _isRecording = true;
      _hasRecorded = false;
      _matchRate = 0.0;
      _recordedText = '';
    });

    await _speech.listen(
      onResult: (result) {
        if (mounted) {
          setState(() {
            _recordedText = result.recognizedWords;
          });
        }
      },
      localeId: languageCode,
      pauseFor: const Duration(seconds: 3),
      listenFor: const Duration(seconds: 30),
    );
  }

  Future<void> _stopRecording() async {
    await _speech.stop();

    if (mounted) {
      setState(() => _isRecording = false);

      if (_recordedText.isNotEmpty) {
        // Speak the correct pronunciation
        final currentItem = _filteredItems[_currentItemIndex];
        final languageData = _displayLanguage1
            ? currentItem.language1Data
            : currentItem.language2Data;
        final fullText =
            '${languageData.preItem?.isNotEmpty ?? false ? "${languageData.preItem} " : ""}${languageData.text}';

        await _ttsService.speak(fullText, languageData.languageCode);

        // Calculate match rate
        _calculateMatchRate(currentItem);

        setState(() {
          _hasRecorded = true;
          _totalPracticed++;
        });
      }
    }
  }

  void _calculateMatchRate(Item item) {
    final languageData =
        _displayLanguage1 ? item.language1Data : item.language2Data;
    final fullText =
        '${languageData.preItem?.isNotEmpty ?? false ? "${languageData.preItem} " : ""}${languageData.text}'
            .toLowerCase()
            .trim();
    final recorded = _recordedText.toLowerCase().trim();

    if (recorded.isEmpty) {
      setState(() => _matchRate = 0.0);
      return;
    }

    // Simple similarity calculation based on:
    // 1. Word match count
    // 2. Character similarity (Levenshtein-like)
    final expectedWords = fullText.split(RegExp(r'\s+'));
    final recordedWords = recorded.split(RegExp(r'\s+'));

    // Word-level matching
    int matchedWords = 0;
    for (final word in recordedWords) {
      if (expectedWords.any((expected) => expected.contains(word) || word.contains(expected))) {
        matchedWords++;
      }
    }

    final wordMatchRate = expectedWords.isNotEmpty
        ? matchedWords / expectedWords.length
        : 0.0;

    // Character-level similarity
    final charMatchRate = _calculateStringSimilarity(fullText, recorded);

    // Combine both metrics (70% word match, 30% char match)
    final combinedRate = (wordMatchRate * 0.7 + charMatchRate * 0.3);

    setState(() {
      _matchRate = (combinedRate * 100).clamp(0.0, 100.0);
    });
  }

  double _calculateStringSimilarity(String s1, String s2) {
    if (s1 == s2) return 1.0;
    if (s1.isEmpty || s2.isEmpty) return 0.0;

    final len1 = s1.length;
    final len2 = s2.length;
    final maxLen = math.max(len1, len2);

    int matches = 0;
    for (int i = 0; i < math.min(len1, len2); i++) {
      if (s1[i] == s2[i]) matches++;
    }

    return matches / maxLen;
  }

  void _nextItem() {
    if (_currentItemIndex < _filteredItems.length - 1) {
      setState(() {
        _currentItemIndex++;
        _hasRecorded = false;
        _matchRate = 0.0;
        _recordedText = '';

        // Redetermine display language if random
        if (widget.settings.displayLanguage == DisplayLanguage.random) {
          _displayLanguage1 = math.Random().nextBool();
        }
      });
    } else {
      _endPractice();
    }
  }

  void _endPractice() {
    Navigator.of(context).pop();
  }

  void _speakCurrentItem() {
    if (_filteredItems.isEmpty) return;

    final currentItem = _filteredItems[_currentItemIndex];
    final languageData =
        _displayLanguage1 ? currentItem.language1Data : currentItem.language2Data;
    final fullText =
        '${languageData.preItem?.isNotEmpty ?? false ? "${languageData.preItem} " : ""}${languageData.text}';

    _ttsService.speak(fullText, languageData.languageCode);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final isTablet = mediaQuery.size.shortestSide >= 600;

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.pronunciationPractice)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_filteredItems.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.pronunciationPractice)),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.spacing24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.inbox,
                  size: 64,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(height: AppTheme.spacing16),
                Text(
                  l10n.noItemsToTrain,
                  style: theme.textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

    final currentItem = _filteredItems[_currentItemIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.pronunciationPractice,
          style: theme.textTheme.titleMedium,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(isTablet ? AppTheme.spacing16 : AppTheme.spacing8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Status indicators
              _buildStatusIndicators(theme, l10n),
              SizedBox(height: isTablet ? AppTheme.spacing16 : AppTheme.spacing8),

              // Item to pronounce
              _buildPronunciationItem(theme, l10n, currentItem, isTablet),
              SizedBox(height: isTablet ? AppTheme.spacing16 : AppTheme.spacing8),

              // Tachometer (only shown after recording)
              if (_hasRecorded) ...[
                _buildTachometer(theme, l10n, isTablet),
                SizedBox(height: isTablet ? AppTheme.spacing16 : AppTheme.spacing8),
              ],

              // Navigation buttons
              _buildNavigationButtons(theme, l10n, isTablet),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIndicators(ThemeData theme, AppLocalizations l10n) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatusItem(
              theme,
              Icons.format_list_numbered,
              l10n.items,
              '${_currentItemIndex + 1}/${_filteredItems.length}',
            ),
            _buildStatusItem(
              theme,
              Icons.check_circle,
              l10n.practiced,
              _totalPracticed.toString(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusItem(
    ThemeData theme,
    IconData icon,
    String label,
    String value,
  ) {
    return Column(
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.primary),
        const SizedBox(height: AppTheme.spacing4),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildPronunciationItem(
    ThemeData theme,
    AppLocalizations l10n,
    Item item,
    bool isTablet,
  ) {
    final languageData =
        _displayLanguage1 ? item.language1Data : item.language2Data;
    final preText = languageData.preItem ?? '';
    final mainText = languageData.text;
    final languageCode = (_displayLanguage1
            ? widget.package.languageCode1
            : widget.package.languageCode2)
        .split('-')[0]
        .toUpperCase();

    return Card(
      elevation: 2,
      color: theme.colorScheme.primaryContainer,
      child: Padding(
        padding: EdgeInsets.all(isTablet ? AppTheme.spacing16 : AppTheme.spacing8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with language code and speaker icon
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${l10n.pronounce} - $languageCode',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                      fontSize: isTablet ? null : 14,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.volume_up,
                    color: theme.colorScheme.onPrimaryContainer,
                    size: isTablet ? 24 : 20,
                  ),
                  tooltip: l10n.listenToPronunciation,
                  onPressed: _speakCurrentItem,
                ),
              ],
            ),
            SizedBox(height: isTablet ? AppTheme.spacing12 : AppTheme.spacing8),

            // Text to pronounce
            if (preText.isNotEmpty) ...[
              Text(
                preText,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.8),
                  fontStyle: FontStyle.italic,
                  fontSize: isTablet ? null : 12,
                ),
              ),
              const SizedBox(height: AppTheme.spacing4),
            ],
            Text(
              mainText,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.bold,
                fontSize: isTablet ? null : 18,
              ),
            ),
            SizedBox(height: isTablet ? AppTheme.spacing16 : AppTheme.spacing12),

            // Microphone button
            Center(
              child: Column(
                children: [
                  Container(
                    width: isTablet ? 80 : 60,
                    height: isTablet ? 80 : 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _isRecording
                          ? theme.colorScheme.error
                          : theme.colorScheme.secondary,
                      boxShadow: _isRecording
                          ? [
                              BoxShadow(
                                color: theme.colorScheme.error.withValues(alpha: 0.5),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ]
                          : null,
                    ),
                    child: IconButton(
                      icon: Icon(
                        _isRecording ? Icons.stop : Icons.mic,
                        color: _isRecording
                            ? theme.colorScheme.onError
                            : theme.colorScheme.onSecondary,
                        size: isTablet ? 40 : 30,
                      ),
                      onPressed: _isRecording ? _stopRecording : _startRecording,
                    ),
                  ),
                  SizedBox(height: isTablet ? AppTheme.spacing12 : AppTheme.spacing8),
                  Text(
                    _isRecording
                        ? l10n.recording
                        : (_hasRecorded ? l10n.recorded : l10n.tapToRecord),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.w500,
                      fontSize: isTablet ? null : 12,
                    ),
                  ),
                  if (_recordedText.isNotEmpty) ...[
                    SizedBox(height: isTablet ? AppTheme.spacing8 : AppTheme.spacing4),
                    Text(
                      '"$_recordedText"',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.7),
                        fontStyle: FontStyle.italic,
                        fontSize: isTablet ? null : 11,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTachometer(ThemeData theme, AppLocalizations l10n, bool isTablet) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(isTablet ? AppTheme.spacing16 : AppTheme.spacing12),
        child: Column(
          children: [
            Text(
              l10n.pronunciationAccuracy,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: isTablet ? null : 14,
              ),
            ),
            SizedBox(height: isTablet ? AppTheme.spacing16 : AppTheme.spacing12),

            // Tachometer widget
            SizedBox(
              height: isTablet ? 200 : 150,
              child: CustomPaint(
                painter: TachometerPainter(
                  percentage: _matchRate,
                  theme: theme,
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: isTablet ? 40 : 30),
                      TweenAnimationBuilder<double>(
                        duration: const Duration(milliseconds: 1000),
                        curve: Curves.easeOutCubic,
                        tween: Tween<double>(begin: 0, end: _matchRate),
                        builder: (context, value, child) {
                          return Text(
                            '${value.toStringAsFixed(0)}%',
                            style: theme.textTheme.displayMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: _getMatchRateColor(theme, value),
                              fontSize: isTablet ? 48 : 36,
                            ),
                          );
                        },
                      ),
                      Text(
                        _getMatchRateLabel(l10n, _matchRate),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontSize: isTablet ? null : 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getMatchRateColor(ThemeData theme, double rate) {
    if (rate >= 80) return Colors.green;
    if (rate >= 60) return Colors.lightGreen;
    if (rate >= 40) return Colors.orange;
    if (rate >= 20) return Colors.deepOrange;
    return theme.colorScheme.error;
  }

  String _getMatchRateLabel(AppLocalizations l10n, double rate) {
    if (rate >= 80) return l10n.excellent;
    if (rate >= 60) return l10n.good;
    if (rate >= 40) return l10n.fair;
    if (rate >= 20) return l10n.needsImprovement;
    return l10n.tryAgain;
  }

  Widget _buildNavigationButtons(ThemeData theme, AppLocalizations l10n, bool isTablet) {
    final buttonPadding = isTablet
        ? const EdgeInsets.symmetric(horizontal: AppTheme.spacing16, vertical: AppTheme.spacing12)
        : const EdgeInsets.symmetric(horizontal: AppTheme.spacing12, vertical: AppTheme.spacing8);
    final fontSize = isTablet ? 16.0 : 14.0;
    final iconSize = isTablet ? 24.0 : 20.0;

    return Row(
      children: [
        Expanded(
          child: FilledButton.icon(
            onPressed: _nextItem,
            icon: Icon(Icons.arrow_forward, size: iconSize),
            label: Text(
              l10n.nextItem,
              style: TextStyle(fontSize: fontSize),
            ),
            style: FilledButton.styleFrom(
              padding: buttonPadding,
            ),
          ),
        ),
        SizedBox(width: isTablet ? AppTheme.spacing12 : AppTheme.spacing8),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _endPractice,
            icon: Icon(Icons.stop, size: iconSize),
            label: Text(
              l10n.endPractice,
              style: TextStyle(fontSize: fontSize),
            ),
            style: OutlinedButton.styleFrom(
              padding: buttonPadding,
            ),
          ),
        ),
      ],
    );
  }
}

// Custom painter for the tachometer
class TachometerPainter extends CustomPainter {
  final double percentage;
  final ThemeData theme;

  TachometerPainter({
    required this.percentage,
    required this.theme,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.75);
    final radius = size.width * 0.35;

    // Draw background arc (gray)
    final backgroundPaint = Paint()
      ..color = theme.colorScheme.surfaceContainerHighest
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi,
      math.pi,
      false,
      backgroundPaint,
    );

    // Draw colored zones
    final zones = [
      {'start': 0.0, 'end': 0.2, 'color': theme.colorScheme.error},
      {'start': 0.2, 'end': 0.4, 'color': Colors.deepOrange},
      {'start': 0.4, 'end': 0.6, 'color': Colors.orange},
      {'start': 0.6, 'end': 0.8, 'color': Colors.lightGreen},
      {'start': 0.8, 'end': 1.0, 'color': Colors.green},
    ];

    for (final zone in zones) {
      final zonePaint = Paint()
        ..color = (zone['color'] as Color).withValues(alpha: 0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 20
        ..strokeCap = StrokeCap.round;

      final startAngle = math.pi + (math.pi * (zone['start'] as double));
      final sweepAngle = math.pi * ((zone['end'] as double) - (zone['start'] as double));

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        zonePaint,
      );
    }

    // Draw progress arc (animated)
    if (percentage > 0) {
      final progressPaint = Paint()
        ..color = _getColorForPercentage(percentage / 100)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 20
        ..strokeCap = StrokeCap.round;

      final sweepAngle = math.pi * (percentage / 100);

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        math.pi,
        sweepAngle,
        false,
        progressPaint,
      );

      // Draw needle
      final needleAngle = math.pi + sweepAngle;
      final needleEnd = Offset(
        center.dx + radius * 0.8 * math.cos(needleAngle),
        center.dy + radius * 0.8 * math.sin(needleAngle),
      );

      final needlePaint = Paint()
        ..color = theme.colorScheme.onSurface
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round;

      canvas.drawLine(center, needleEnd, needlePaint);

      // Draw needle center circle
      canvas.drawCircle(
        center,
        6,
        Paint()
          ..color = theme.colorScheme.onSurface
          ..style = PaintingStyle.fill,
      );
    }
  }

  Color _getColorForPercentage(double normalizedPercentage) {
    if (normalizedPercentage >= 0.8) return Colors.green;
    if (normalizedPercentage >= 0.6) return Colors.lightGreen;
    if (normalizedPercentage >= 0.4) return Colors.orange;
    if (normalizedPercentage >= 0.2) return Colors.deepOrange;
    return theme.colorScheme.error;
  }

  @override
  bool shouldRepaint(TachometerPainter oldDelegate) {
    return oldDelegate.percentage != percentage;
  }
}

