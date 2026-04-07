// lib/presentation/pages/items/global_search_page.dart
//
// Global Search Page - Search for words/expressions across ALL language packages.
//
// FEATURES:
// - Collects unique language codes from all installed packages (ascending order)
// - Dropdown to select which language to search in
// - Text field for the search term(s) - substring / partial match (case-insensitive)
// - Search button; also submittable from keyboard
// - Searches language1Data or language2Data depending on which position holds the
//   selected language code, and additionally searches in example sentences
// - Results grouped/sorted: direct text matches first, then example-only matches
// - Each result card shows both language texts, highlights the matched substring,
//   package name, TTS buttons, and a "View" button that opens the item detail dialog
// - Item detail dialog has a "Go to Package" button that navigates to ItemBrowserPage

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/tts_service.dart';
import '../../../data/models/item.dart';
import '../../../data/models/item_language_data.dart';
import '../../../data/models/example_sentence.dart';
import '../../../data/models/language_package.dart';
import '../../../data/repositories/item_repository.dart';
import '../../../data/repositories/language_package_repository.dart';
import '../../../l10n/app_localizations.dart';
import 'item_browser_page.dart';

// ── Internal model ────────────────────────────────────────────────────────────

class _SearchResult {
  final Item item;
  final LanguagePackage package;
  /// True when the match is in item.language1Data (the language in position 1).
  final bool matchInLanguage1;
  /// True when the match is in item.language2Data (the language in position 2).
  final bool matchInLanguage2;
  /// Examples that contain the search term (may be empty).
  final List<ExampleSentence> matchingExamples;

  const _SearchResult({
    required this.item,
    required this.package,
    required this.matchInLanguage1,
    required this.matchInLanguage2,
    required this.matchingExamples,
  });

  /// True when only examples matched, not the main item texts.
  bool get isExampleOnlyMatch =>
      !matchInLanguage1 && !matchInLanguage2 && matchingExamples.isNotEmpty;
}

// ── Page ─────────────────────────────────────────────────────────────────────

class GlobalSearchPage extends ConsumerStatefulWidget {
  const GlobalSearchPage({super.key});

  @override
  ConsumerState<GlobalSearchPage> createState() => _GlobalSearchPageState();
}

class _GlobalSearchPageState extends ConsumerState<GlobalSearchPage> {
  // Repositories
  final _packageRepo = LanguagePackageRepository();
  final _itemRepo = ItemRepository();
  final _ttsService = TtsService();

  // Search state
  final _searchController = TextEditingController();
  String? _selectedLanguageCode;
  bool _isLoadingPackages = true;
  bool _isSearching = false;
  bool _searchPerformed = false;
  String? _lastSearchQuery;

  // Progress / cancellation
  bool _isCancelled = false;
  bool _searchCancelledByUser = false;
  int _progressCurrent = 0;
  int _progressTotal = 0;

  // Data
  List<LanguagePackage> _allPackages = [];
  List<String> _uniqueLanguageCodes = [];
  List<_SearchResult> _results = [];

  // ── Lifecycle ──────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _ttsService.initialize();
    _loadPackages();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _ttsService.stop();
    super.dispose();
  }

  // ── Data loading ───────────────────────────────────────────────────────────

  Future<void> _loadPackages() async {
    try {
      final packages = await _packageRepo.getAllPackages();
      final codeSet = <String>{};
      for (final pkg in packages) {
        if (pkg.languageCode1.isNotEmpty) codeSet.add(pkg.languageCode1);
        if (pkg.languageCode2.isNotEmpty) codeSet.add(pkg.languageCode2);
      }
      final sortedCodes = codeSet.toList()..sort();
      if (mounted) {
        setState(() {
          _allPackages = packages;
          _uniqueLanguageCodes = sortedCodes;
          _isLoadingPackages = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoadingPackages = false);
    }
  }

  // ── Search logic ───────────────────────────────────────────────────────────

  Future<void> _performSearch() async {
    final l10n = AppLocalizations.of(context)!;
    final query = _searchController.text.trim();

    if (_selectedLanguageCode == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.globalSearchSelectLanguageFirst),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }
    if (query.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.globalSearchEnterTermFirst),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    setState(() {
      _isSearching = true;
      _searchPerformed = false;
      _isCancelled = false;
      _searchCancelledByUser = false;
      _progressCurrent = 0;
      _progressTotal = 0;
    });

    try {
      final results = await _doSearch(
        _selectedLanguageCode!,
        query,
        (current, total) {
          if (mounted) {
            setState(() {
              _progressCurrent = current;
              _progressTotal = total;
            });
          }
        },
      );
      if (mounted) {
        setState(() {
          _results = results;
          _lastSearchQuery = query;
          _isSearching = false;
          _searchPerformed = true;
          _searchCancelledByUser = _isCancelled;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _isSearching = false;
          _searchPerformed = true;
          _searchCancelledByUser = false;
        });
      }
    }
  }

  Future<List<_SearchResult>> _doSearch(
    String languageCode,
    String query,
    void Function(int current, int total) onProgress,
  ) async {
    final lowerQuery = query.toLowerCase();
    final results = <_SearchResult>[];

    // Narrow down to packages that have the selected language code.
    final matchingPackages = _allPackages
        .where((p) =>
            p.languageCode1 == languageCode || p.languageCode2 == languageCode)
        .toList();

    for (int i = 0; i < matchingPackages.length; i++) {
      // ── Cancellation check ─────────────────────────────────────────────
      if (_isCancelled) break;

      // ── Progress update ────────────────────────────────────────────────
      onProgress(i + 1, matchingPackages.length);

      final package = matchingPackages[i];
      final isLang1 = package.languageCode1 == languageCode;
      final isLang2 = package.languageCode2 == languageCode;

      final items = await _itemRepo.getItemsForPackage(package.id);

      for (final item in items) {
        if (_isCancelled) break;

        bool matchInLang1 = false;
        bool matchInLang2 = false;
        final matchingExamples = <ExampleSentence>[];

        // ── Main text match ──────────────────────────────────────────────
        if (isLang1) {
          matchInLang1 = _dataContains(item.language1Data, lowerQuery);
        }
        if (isLang2) {
          matchInLang2 = _dataContains(item.language2Data, lowerQuery);
        }

        // ── Example match ────────────────────────────────────────────────
        for (final ex in item.examples) {
          bool exMatch = false;
          if (isLang1 && ex.textLanguage1.toLowerCase().contains(lowerQuery)) {
            exMatch = true;
          }
          if (isLang2 && ex.textLanguage2.toLowerCase().contains(lowerQuery)) {
            exMatch = true;
          }
          if (exMatch) matchingExamples.add(ex);
        }

        if (matchInLang1 || matchInLang2 || matchingExamples.isNotEmpty) {
          results.add(_SearchResult(
            item: item,
            package: package,
            matchInLanguage1: matchInLang1,
            matchInLanguage2: matchInLang2,
            matchingExamples: matchingExamples,
          ));
        }
      }
    }

    // Sort: direct matches first, then example-only; within each group,
    // sort alphabetically by language1 text.
    results.sort((a, b) {
      final aScore = (a.matchInLanguage1 || a.matchInLanguage2) ? 0 : 1;
      final bScore = (b.matchInLanguage1 || b.matchInLanguage2) ? 0 : 1;
      if (aScore != bScore) return aScore.compareTo(bScore);
      return a.item.language1Data.text
          .toLowerCase()
          .compareTo(b.item.language1Data.text.toLowerCase());
    });

    return results;
  }

  /// Returns true if the given [data]'s text / preItem / postItem contains [query].
  bool _dataContains(ItemLanguageData data, String lowerQuery) {
    if (data.text.toLowerCase().contains(lowerQuery)) return true;
    if (data.preItem?.toLowerCase().contains(lowerQuery) ?? false) return true;
    if (data.postItem?.toLowerCase().contains(lowerQuery) ?? false) return true;
    return false;
  }

  // ── Navigation ─────────────────────────────────────────────────────────────

  void _openPackage(LanguagePackage package, {String? initialItemId}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ItemBrowserPage(
          package: package,
          initialItemId: initialItemId,
        ),
      ),
    );
  }

  // ── Cancellation ───────────────────────────────────────────────────────────

  void _cancelSearch() {
    setState(() => _isCancelled = true);
  }

  // ── Item detail dialog ─────────────────────────────────────────────────────

  void _showItemDetail(_SearchResult result) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    // Find the live index so we can update _results after flag toggles.
    final resultIndex = _results.indexOf(result);

    showDialog(
      context: context,
      builder: (dialogContext) {
        // Local mutable copies of the three flags – StatefulBuilder keeps
        // them alive across rebuilds inside the dialog.
        bool isKnown = result.item.isKnown;
        bool isFavourite = result.item.isFavourite;
        bool isImportant = result.item.isImportant;

        return StatefulBuilder(
          builder: (context, setDialogState) {
            // ── Helper: toggle a flag, persist to DB, sync back to result list ──
            Future<void> toggleFlag({
              bool? newKnown,
              bool? newFavourite,
              bool? newImportant,
            }) async {
              setDialogState(() {
                if (newKnown != null) isKnown = newKnown;
                if (newFavourite != null) isFavourite = newFavourite;
                if (newImportant != null) isImportant = newImportant;
              });

              // Persist
              final updated = result.item.copyWith(
                isKnown: isKnown,
                isFavourite: isFavourite,
                isImportant: isImportant,
              );
              await _itemRepo.updateItem(updated);

              // Sync back into _results so the card reflects the change
              if (mounted && resultIndex >= 0) {
                setState(() {
                  _results[resultIndex] = _SearchResult(
                    item: updated,
                    package: result.package,
                    matchInLanguage1: result.matchInLanguage1,
                    matchInLanguage2: result.matchInLanguage2,
                    matchingExamples: result.matchingExamples,
                  );
                });
              }
            }

            return Dialog(
              insetPadding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacing8,
                vertical: AppTheme.spacing24,
              ),
              child: SizedBox(
                width: double.maxFinite,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppTheme.spacing16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // ── Header ──────────────────────────────────────────
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              l10n.itemDetails,
                              style: theme.textTheme.titleLarge,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.of(dialogContext).pop(),
                            tooltip: l10n.close,
                          ),
                        ],
                      ),

                      // ── Package chip ─────────────────────────────────────
                      Chip(
                        avatar: Icon(
                          Icons.folder_outlined,
                          size: 14,
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                        label: Text(
                          result.package.packageName ??
                              '${result.package.languageCode1}↔${result.package.languageCode2}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                        ),
                        backgroundColor: theme.colorScheme.primaryContainer,
                      ),

                      const SizedBox(height: AppTheme.spacing8),

                      // ── Language 1 ───────────────────────────────────────
                      _buildDetailLanguageSection(
                        l10n,
                        theme,
                        result.package.languageName1,
                        result.item.language1Data,
                        highlight: _lastSearchQuery,
                        isHighlighted: result.matchInLanguage1,
                      ),

                      const SizedBox(height: AppTheme.spacing8),

                      // ── Language 2 ───────────────────────────────────────
                      _buildDetailLanguageSection(
                        l10n,
                        theme,
                        result.package.languageName2,
                        result.item.language2Data,
                        highlight: _lastSearchQuery,
                        isHighlighted: result.matchInLanguage2,
                      ),

                      const SizedBox(height: AppTheme.spacing12),

                      // ── Status flags (Known / Favourite / Important) ──────
                      Card(
                        elevation: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(AppTheme.spacing8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.status,
                                style: theme.textTheme.titleSmall?.copyWith(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: AppTheme.spacing8),
                              // Known FilterChip
                              FilterChip(
                                selected: isKnown,
                                label: Text(
                                  l10n.known,
                                  style: theme.textTheme.bodySmall,
                                ),
                                avatar: Icon(
                                  isKnown
                                      ? Icons.check_circle
                                      : Icons.error,
                                  size: 18,
                                  color: isKnown
                                      ? Colors.green
                                      : Colors.red,
                                ),
                                onSelected: (value) =>
                                    toggleFlag(newKnown: value),
                              ),
                              const SizedBox(height: AppTheme.spacing8),
                              // Favourite + Important side by side
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Favourite
                                  InkWell(
                                    onTap: () => toggleFlag(
                                        newFavourite: !isFavourite),
                                    borderRadius: BorderRadius.circular(
                                        AppTheme.radiusSmall),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: AppTheme.spacing8,
                                        vertical: AppTheme.spacing4,
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            isFavourite
                                                ? Icons.star
                                                : Icons.star_outline,
                                            size: 24,
                                            color: isFavourite
                                                ? theme.colorScheme.tertiary
                                                : theme.colorScheme
                                                    .onSurfaceVariant,
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            l10n.favourite,
                                            style: theme.textTheme.labelSmall
                                                ?.copyWith(
                                              fontSize: 10,
                                              color: isFavourite
                                                  ? theme
                                                      .colorScheme.tertiary
                                                  : theme.colorScheme
                                                      .onSurfaceVariant,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: AppTheme.spacing4),
                                  // Important
                                  InkWell(
                                    onTap: () => toggleFlag(
                                        newImportant: !isImportant),
                                    borderRadius: BorderRadius.circular(
                                        AppTheme.radiusSmall),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: AppTheme.spacing8,
                                        vertical: AppTheme.spacing4,
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            isImportant
                                                ? Icons.bookmark
                                                : Icons.bookmark_border,
                                            size: 24,
                                            color: isImportant
                                                ? theme
                                                    .colorScheme.secondary
                                                : theme.colorScheme
                                                    .onSurfaceVariant,
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            l10n.important,
                                            style: theme.textTheme.labelSmall
                                                ?.copyWith(
                                              fontSize: 10,
                                              color: isImportant
                                                  ? theme
                                                      .colorScheme.secondary
                                                  : theme.colorScheme
                                                      .onSurfaceVariant,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      // ── Examples ─────────────────────────────────────────
                      if (result.item.examples.isNotEmpty) ...[
                        const SizedBox(height: AppTheme.spacing12),
                        Text(
                          l10n.examples,
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ...result.item.examples.map(
                          (ex) => Padding(
                            padding:
                                const EdgeInsets.only(top: AppTheme.spacing4),
                            child: Card(
                              color:
                                  theme.colorScheme.surfaceContainerHighest,
                              child: Padding(
                                padding:
                                    const EdgeInsets.all(AppTheme.spacing8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (ex.textLanguage1.trim().isNotEmpty)
                                      _buildHighlightedText(
                                        ex.textLanguage1,
                                        result.matchInLanguage1
                                            ? (_lastSearchQuery ?? '')
                                            : '',
                                        theme,
                                        style: theme.textTheme.bodySmall,
                                      ),
                                    if (ex.textLanguage2.trim().isNotEmpty) ...[
                                      const SizedBox(
                                          height: AppTheme.spacing4),
                                      _buildHighlightedText(
                                        ex.textLanguage2,
                                        result.matchInLanguage2
                                            ? (_lastSearchQuery ?? '')
                                            : '',
                                        theme,
                                        style:
                                            theme.textTheme.bodySmall?.copyWith(
                                          color: theme
                                              .colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],

                      const SizedBox(height: AppTheme.spacing16),

                      // ── Go to Package button ─────────────────────────────
                      SizedBox(
                        width: double.maxFinite,
                        child: FilledButton.icon(
                          onPressed: () {
                            Navigator.of(dialogContext).pop();
                            _openPackage(
                              result.package,
                              initialItemId: result.item.id,
                            );
                          },
                          icon: const Icon(Icons.open_in_new),
                          label: Text(l10n.globalSearchGoToPackage),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDetailLanguageSection(
    AppLocalizations l10n,
    ThemeData theme,
    String languageName,
    ItemLanguageData data, {
    String? highlight,
    bool isHighlighted = false,
  }) {
    final preItem = data.preItem?.trim() ?? '';
    final text = data.text;
    final postItem = data.postItem?.trim() ?? '';
    final fullText =
        '${preItem.isNotEmpty ? "$preItem " : ""}$text${postItem.isNotEmpty ? " $postItem" : ""}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (isHighlighted)
              Icon(
                Icons.check_circle,
                size: 14,
                color: theme.colorScheme.primary,
              ),
            if (isHighlighted) const SizedBox(width: AppTheme.spacing4),
            Text(
              languageName,
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.volume_up, size: 18),
              tooltip: l10n.pronounce,
              padding: EdgeInsets.zero,
              constraints:
                  const BoxConstraints(minWidth: 32, minHeight: 32),
              onPressed: () async {
                await _ttsService.speak(fullText, data.languageCode);
              },
            ),
          ],
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppTheme.spacing8),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (preItem.isNotEmpty)
                Text(
                  preItem,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              _buildHighlightedText(
                text,
                highlight ?? '',
                theme,
                style: theme.textTheme.bodyMedium,
              ),
              if (postItem.isNotEmpty)
                Text(
                  postItem,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontStyle: FontStyle.italic,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.globalSearch),
        backgroundColor: theme.colorScheme.surface,
        surfaceTintColor: Colors.transparent,
      ),
      body: Column(
        children: [
          _buildSearchForm(l10n, theme),
          const Divider(height: 1),
          Expanded(
            child: _isSearching
                ? _buildSearchingProgress(l10n, theme)
                : _buildResultsArea(l10n, theme),
          ),
        ],
      ),
    );
  }

  // ── Progress widget shown while searching ──────────────────────────────────

  Widget _buildSearchingProgress(AppLocalizations l10n, ThemeData theme) {
    final hasTotal = _progressTotal > 0;
    final progressValue =
        hasTotal ? _progressCurrent / _progressTotal : null; // null = indeterminate

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacing32,
          vertical: AppTheme.spacing24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Animated progress bar ────────────────────────────────────
            ClipRRect(
              borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
              child: LinearProgressIndicator(
                value: progressValue,
                minHeight: 8,
                backgroundColor:
                    theme.colorScheme.surfaceContainerHighest,
                color: theme.colorScheme.primary,
              ),
            ),

            const SizedBox(height: AppTheme.spacing12),

            // ── Progress label ────────────────────────────────────────────
            Text(
              hasTotal
                  ? l10n.globalSearchProgressOf(
                      _progressCurrent, _progressTotal)
                  : l10n.globalSearchSearching,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: AppTheme.spacing24),

            // ── Cancel button ─────────────────────────────────────────────
            OutlinedButton.icon(
              onPressed: _cancelSearch,
              icon: const Icon(Icons.stop_circle_outlined),
              label: Text(l10n.globalSearchCancelSearch),
              style: OutlinedButton.styleFrom(
                foregroundColor: theme.colorScheme.error,
                side: BorderSide(color: theme.colorScheme.error),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchForm(AppLocalizations l10n, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacing16),
      decoration: BoxDecoration(
        color:
            theme.colorScheme.primaryContainer.withValues(alpha: 0.1),
        border: Border(
          bottom:
              BorderSide(color: theme.colorScheme.outlineVariant, width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Language code picker ───────────────────────────────────────
          if (_isLoadingPackages)
            Row(
              children: [
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                const SizedBox(width: AppTheme.spacing8),
                Text(
                  l10n.globalSearchLoadingPackages,
                  style: theme.textTheme.bodySmall,
                ),
              ],
            )
          else if (_uniqueLanguageCodes.isEmpty)
            Text(
              l10n.globalSearchNoPackages,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            )
          else
            InputDecorator(
              decoration: InputDecoration(
                labelText: l10n.globalSearchSelectLanguage,
                prefixIcon: const Icon(Icons.language),
                border: const OutlineInputBorder(),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacing8,
                  vertical: AppTheme.spacing4,
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedLanguageCode,
                  isExpanded: true,
                  isDense: true,
                  items: _uniqueLanguageCodes
                      .map(
                        (code) => DropdownMenuItem(
                          value: code,
                          child: Text(code, style: theme.textTheme.bodyMedium),
                        ),
                      )
                      .toList(),
                  onChanged: (value) =>
                      setState(() => _selectedLanguageCode = value),
                ),
              ),
            ),

          const SizedBox(height: AppTheme.spacing8),

          // ── Search text field ──────────────────────────────────────────
          TextField(
            controller: _searchController,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              labelText: l10n.globalSearchEnterWord,
              hintText: l10n.globalSearchEnterWordHint,
              prefixIcon: const Icon(Icons.search),
              border: const OutlineInputBorder(),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacing8,
                vertical: AppTheme.spacing12,
              ),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () =>
                          setState(() => _searchController.clear()),
                    )
                  : null,
            ),
            onSubmitted: (_) => _performSearch(),
            onChanged: (_) => setState(() {}),
          ),

          const SizedBox(height: AppTheme.spacing8),

          // ── Search button ──────────────────────────────────────────────
          ElevatedButton.icon(
            onPressed: (_isSearching || _uniqueLanguageCodes.isEmpty)
                ? null
                : _performSearch,
            icon: const Icon(Icons.search),
            label: Text(l10n.globalSearchButton),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsArea(AppLocalizations l10n, ThemeData theme) {
    // Initial / idle state
    if (!_searchPerformed) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.manage_search,
              size: 72,
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
            ),
            const SizedBox(height: AppTheme.spacing8),
            Text(
              l10n.globalSearchTitle,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    // No results
    if (_results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: AppTheme.spacing8),
            Text(
              l10n.globalSearchNoResults(_lastSearchQuery ?? ''),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    // Results list
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Cancelled banner ─────────────────────────────────────────────
        if (_searchCancelledByUser)
          Container(
            width: double.maxFinite,
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacing16,
              vertical: AppTheme.spacing8,
            ),
            color: theme.colorScheme.errorContainer.withValues(alpha: 0.5),
            child: Row(
              children: [
                Icon(Icons.warning_amber_rounded,
                    size: 16, color: theme.colorScheme.error),
                const SizedBox(width: AppTheme.spacing8),
                Expanded(
                  child: Text(
                    l10n.globalSearchCancelledMessage(_results.length),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onErrorContainer,
                    ),
                  ),
                ),
              ],
            ),
          ),

        // ── Results count banner ─────────────────────────────────────────
        Container(
          width: double.maxFinite,
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spacing16,
            vertical: AppTheme.spacing8,
          ),
          color: theme.colorScheme.secondaryContainer.withValues(alpha: 0.35),
          child: Text(
            l10n.globalSearchResultsCount(_results.length),
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.secondary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        // Result cards
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacing8,
              vertical: AppTheme.spacing4,
            ),
            itemCount: _results.length,
            itemBuilder: (context, index) =>
                _buildResultCard(l10n, theme, _results[index]),
          ),
        ),
      ],
    );
  }

  Widget _buildResultCard(
    AppLocalizations l10n,
    ThemeData theme,
    _SearchResult result,
  ) {
    final lang1 = result.item.language1Data;
    final lang2 = result.item.language2Data;

    String buildDisplay(ItemLanguageData d) {
      final pre = d.preItem?.trim() ?? '';
      final post = d.postItem?.trim() ?? '';
      return [if (pre.isNotEmpty) pre, d.text, if (post.isNotEmpty) post]
          .join(' ')
          .trim();
    }

    final display1 = buildDisplay(lang1);
    final display2 = buildDisplay(lang2);
    final query = _lastSearchQuery ?? '';

    return Card(
      margin: const EdgeInsets.symmetric(
        vertical: AppTheme.spacing4,
        horizontal: AppTheme.spacing4,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        onTap: () => _showItemDetail(result),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacing12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Language texts ───────────────────────────────────────
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Language 1 row
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (result.matchInLanguage1)
                              Padding(
                                padding: const EdgeInsets.only(
                                    right: AppTheme.spacing4),
                                child: Icon(
                                  Icons.check_circle,
                                  size: 13,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            Expanded(
                              child: _buildHighlightedText(
                                display1,
                                result.matchInLanguage1 ? query : '',
                                theme,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            _ttsButton(display1, lang1.languageCode, theme),
                          ],
                        ),
                        const SizedBox(height: 2),
                        // Language 2 row
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (result.matchInLanguage2)
                              Padding(
                                padding: const EdgeInsets.only(
                                    right: AppTheme.spacing4),
                                child: Icon(
                                  Icons.check_circle,
                                  size: 13,
                                  color: theme.colorScheme.secondary,
                                ),
                              ),
                            Expanded(
                              child: _buildHighlightedText(
                                display2,
                                result.matchInLanguage2 ? query : '',
                                theme,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color:
                                      theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                            _ttsButton(display2, lang2.languageCode, theme,
                                secondary: true),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // ── Example snippet (only when match is in examples) ─────
              if (result.isExampleOnlyMatch &&
                  result.matchingExamples.isNotEmpty) ...[
                const SizedBox(height: AppTheme.spacing4),
                Container(
                  padding: const EdgeInsets.all(AppTheme.spacing8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.tertiaryContainer
                        .withValues(alpha: 0.3),
                    borderRadius:
                        BorderRadius.circular(AppTheme.radiusSmall),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.format_quote,
                            size: 12,
                            color: theme.colorScheme.tertiary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            l10n.globalSearchMatchInExamples,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.tertiary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      ...result.matchingExamples.take(2).map((ex) {
                        final exText =
                            _selectedLanguageCode == result.package.languageCode1
                                ? ex.textLanguage1
                                : ex.textLanguage2;
                        return Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: _buildHighlightedText(
                            exText,
                            query,
                            theme,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            maxLines: 2,
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: AppTheme.spacing4),

              // ── Footer: package name + View button ───────────────────
              Row(
                children: [
                  Icon(
                    Icons.folder_outlined,
                    size: 12,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      result.package.packageName ??
                          '${result.package.languageCode1}↔${result.package.languageCode2}',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () => _showItemDetail(result),
                    icon: const Icon(Icons.open_in_new, size: 14),
                    label: Text(
                      l10n.globalSearchViewItem,
                      style: theme.textTheme.labelSmall,
                    ),
                    style: TextButton.styleFrom(
                      minimumSize: Size.zero,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacing4,
                        vertical: 2,
                      ),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  /// Small TTS icon button for use inside a result card.
  Widget _ttsButton(
    String text,
    String languageCode,
    ThemeData theme, {
    bool secondary = false,
  }) {
    return InkWell(
      onTap: () => _ttsService.speak(text, languageCode),
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Icon(
          Icons.volume_up,
          size: 14,
          color: secondary
              ? theme.colorScheme.onSurfaceVariant
              : theme.colorScheme.primary,
        ),
      ),
    );
  }

  /// Builds a [RichText] that highlights all occurrences of [query] inside
  /// [text] using the theme's tertiaryContainer colour.
  Widget _buildHighlightedText(
    String text,
    String query,
    ThemeData theme, {
    TextStyle? style,
    int? maxLines,
  }) {
    if (query.isEmpty) {
      return Text(text, style: style, maxLines: maxLines,
          overflow:
              maxLines != null ? TextOverflow.ellipsis : TextOverflow.clip);
    }

    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();
    final spans = <TextSpan>[];
    int start = 0;

    while (start < text.length) {
      final index = lowerText.indexOf(lowerQuery, start);
      if (index == -1) {
        spans.add(TextSpan(text: text.substring(start)));
        break;
      }
      if (index > start) {
        spans.add(TextSpan(text: text.substring(start, index)));
      }
      spans.add(
        TextSpan(
          text: text.substring(index, index + query.length),
          style: TextStyle(
            backgroundColor: theme.colorScheme.tertiaryContainer,
            color: theme.colorScheme.onTertiaryContainer,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
      start = index + query.length;
    }

    return RichText(
      text: TextSpan(style: style, children: spans),
      maxLines: maxLines,
      overflow: maxLines != null ? TextOverflow.ellipsis : TextOverflow.clip,
    );
  }
}


