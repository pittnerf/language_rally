// lib/presentation/pages/items/item_browser_page.dart
//
// Item Browser Page - Browse and filter items in a language package
//
// FEATURES:
// - Scrollable item list with language data display (preItem, text, postItem)
// - Status icons: isKnown (check), isFavourite (star), isImportant (label)
// - Portrait mode: Full-width list, tap item to view details in dialog
// - Landscape mode: Split view (2/5 list, 3/5 details panel)
// - Filtering panel with:
//   * Text search for both languages (logical AND)
//   * Case-sensitive toggle (off by default)
//   * Only important items filter
//   * Known status dropdown (all/known/unknown)
// - Read-only support for purchased packages
// - Pronunciation buttons (AI placeholder implementation)
// - Multilingual UI (English/Hungarian)
// - Uses theme system (no hardcoded colors/fonts)
//
// USAGE:
// Add to your package list or details page:
//
// import '../items/item_browser_page.dart';
//
// // Example: Add browse button to package card
// ElevatedButton.icon(
//   icon: const Icon(Icons.list),
//   label: Text('Browse Items'),
//   onPressed: () {
//     Navigator.of(context).push(
//       MaterialPageRoute(
//         builder: (context) => ItemBrowserPage(package: yourPackage),
//       ),
//     );
//   },
// )
//
// INTEGRATION EXAMPLE for PackageCard:
// Add to the expanded card's floating action buttons section:
//
// FloatingActionButton.small(
//   heroTag: 'browse_${widget.package.id}',
//   onPressed: () {
//     Navigator.of(context).push(
//       MaterialPageRoute(
//         builder: (context) => ItemBrowserPage(package: widget.package),
//       ),
//     );
//   },
//   backgroundColor: Theme.of(context).colorScheme.primaryContainer,
//   foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
//   tooltip: 'Browse items',
//   child: const Icon(Icons.list, size: 20),
// ),
//
// LOCALIZATION KEYS:
// Added to app_en.arb and app_hu.arb:
// - browseItems, itemDetails, filterItems
// - searchLanguage1, searchLanguage2
// - caseSensitive, onlyImportant, knownStatus
// - allItems, itemsIKnew, itemsIDidNotKnow
// - known, important, favourite, examples, pronounce
// - noItemsFound, noItemsInPackage, clearFilters
// - itemCount, filteredItemCount
//

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/tts_service.dart';
import '../../../data/models/item.dart';
import '../../../data/models/language_package.dart';
import '../../../data/repositories/item_repository.dart';
import '../../../l10n/app_localizations.dart';

/// Item browser page for viewing and filtering items in a package
class ItemBrowserPage extends ConsumerStatefulWidget {
  final LanguagePackage package;

  const ItemBrowserPage({
    super.key,
    required this.package,
  });

  @override
  ConsumerState<ItemBrowserPage> createState() => _ItemBrowserPageState();
}

class _ItemBrowserPageState extends ConsumerState<ItemBrowserPage> {
  final _itemRepo = ItemRepository();
  final _ttsService = TtsService();
  List<Item> _allItems = [];
  List<Item> _filteredItems = [];
  bool _isLoading = true;
  Item? _selectedItem;

  // Filter state
  final _language1Controller = TextEditingController();
  final _language2Controller = TextEditingController();
  bool _caseSensitive = false;
  bool _onlyImportant = false;
  String _knownStatus = 'all'; // 'all', 'known', 'unknown'
  bool _isFilterPanelExpanded = false; // Start collapsed to save screen space

  @override
  void initState() {
    super.initState();
    _ttsService.initialize();
    _loadItems();
    _language1Controller.addListener(() {
      _applyFilters();
      setState(() {}); // Rebuild to show/hide clear button
    });
    _language2Controller.addListener(() {
      _applyFilters();
      setState(() {}); // Rebuild to show/hide clear button
    });
  }

  @override
  void dispose() {
    _ttsService.stop();
    _language1Controller.dispose();
    _language2Controller.dispose();
    super.dispose();
  }

  Future<void> _loadItems() async {
    setState(() => _isLoading = true);
    try {
      final items = await _itemRepo.getItemsForPackage(widget.package.id);
      setState(() {
        _allItems = items;
        _filteredItems = items;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void _applyFilters() {
    final query1 = _language1Controller.text;
    final query2 = _language2Controller.text;

    setState(() {
      _filteredItems = _allItems.where((item) {
        // Apply language 1 filter
        if (query1.isNotEmpty) {
          final text1 = item.language1Data.text;
          final match = _caseSensitive
              ? text1.contains(query1)
              : text1.toLowerCase().contains(query1.toLowerCase());
          if (!match) return false;
        }

        // Apply language 2 filter
        if (query2.isNotEmpty) {
          final text2 = item.language2Data.text;
          final match = _caseSensitive
              ? text2.contains(query2)
              : text2.toLowerCase().contains(query2.toLowerCase());
          if (!match) return false;
        }

        // Apply important filter
        if (_onlyImportant && !item.isImportant) return false;

        // Apply known status filter
        if (_knownStatus == 'known' && !item.isKnown) return false;
        if (_knownStatus == 'unknown' && item.isKnown) return false;

        return true;
      }).toList();
    });
  }

  void _clearFilters() {
    setState(() {
      _language1Controller.clear();
      _language2Controller.clear();
      _caseSensitive = false;
      _onlyImportant = false;
      _knownStatus = 'all';
      _applyFilters();
    });
  }

  void _pronounce(String text, String languageCode) async {
    if (text.isEmpty) return;

    try {
      final success = await _ttsService.speak(text, languageCode);

      if (!success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.ttsError),
            duration: const Duration(seconds: 2),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${AppLocalizations.of(context)!.ttsError}: $e'),
            duration: const Duration(seconds: 3),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      // appBar: AppBar(
      //  title: Text(l10n.browseItems),
      //  backgroundColor: theme.colorScheme.surface,
      //),
      body: Stack(
        children: [
          SafeArea(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      _buildFilterPanel(l10n, theme),
                      Expanded(
                        child: isLandscape
                            ? _buildLandscapeLayout(l10n, theme)
                            : _buildPortraitLayout(l10n, theme),
                      ),
                    ],
                  ),
          ),
          // Add back button since AppBar is hidden
          Positioned(
            top: AppTheme.spacing8,
            left: AppTheme.spacing8,
            child: SafeArea(
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                color: theme.colorScheme.surface,
                child: InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  child: Padding(
                    padding: const EdgeInsets.all(AppTheme.spacing8),
                    child: Icon(
                      Icons.arrow_back,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterPanel(AppLocalizations l10n, ThemeData theme) {
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    final hasActiveFilters = _language1Controller.text.isNotEmpty ||
        _language2Controller.text.isNotEmpty ||
        _caseSensitive ||
        _onlyImportant ||
        _knownStatus != 'all';

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.1),
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outlineVariant,
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header bar - always visible
          InkWell(
            onTap: () {
              setState(() {
                _isFilterPanelExpanded = !_isFilterPanelExpanded;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spacing12),
              child: Row(
                children: [
                  Icon(
                    _isFilterPanelExpanded ? Icons.expand_less : Icons.expand_more,
                    size: 24,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: AppTheme.spacing8),
                  Icon(
                    Icons.filter_list,
                    size: 20,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: AppTheme.spacing8),
                  Text(
                    l10n.filterItems,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  if (hasActiveFilters && !_isFilterPanelExpanded)
                    Container(
                      margin: const EdgeInsets.only(left: AppTheme.spacing8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacing8,
                        vertical: AppTheme.spacing4,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                      ),
                      child: Text(
                        '●',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  const Spacer(),
                  Text(
                    _filteredItems.length == _allItems.length
                        ? l10n.itemCount(_allItems.length)
                        : l10n.filteredItemCount(_filteredItems.length, _allItems.length),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  if (_isFilterPanelExpanded) ...[
                    const SizedBox(width: AppTheme.spacing8),
                    TextButton(
                      onPressed: _clearFilters,
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.spacing8,
                          vertical: AppTheme.spacing4,
                        ),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        l10n.clearFilters,
                        style: theme.textTheme.bodySmall,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          // Expandable filter content
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: const EdgeInsets.only(
                left: AppTheme.spacing12,
                right: AppTheme.spacing12,
                bottom: AppTheme.spacing12,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search fields
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _language1Controller,
                          style: theme.textTheme.bodySmall,
                          decoration: InputDecoration(
                            labelText: l10n.searchLanguage1(widget.package.languageName1),
                            labelStyle: theme.textTheme.bodySmall,
                            prefixIcon: const Icon(Icons.search, size: 18),
                            suffixIcon: _language1Controller.text.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear, size: 18),
                                    onPressed: () {
                                      _language1Controller.clear();
                                    },
                                  )
                                : null,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: AppTheme.spacing8,
                              vertical: AppTheme.spacing8,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppTheme.spacing8),
                      Expanded(
                        child: TextField(
                          controller: _language2Controller,
                          style: theme.textTheme.bodySmall,
                          decoration: InputDecoration(
                            labelText: l10n.searchLanguage2(widget.package.languageName2),
                            labelStyle: theme.textTheme.bodySmall,
                            prefixIcon: const Icon(Icons.search, size: 18),
                            suffixIcon: _language2Controller.text.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear, size: 18),
                                    onPressed: () {
                                      _language2Controller.clear();
                                    },
                                  )
                                : null,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: AppTheme.spacing8,
                              vertical: AppTheme.spacing8,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppTheme.spacing8),
                  // Filter options
                  if (isPortrait) ...[
                    // Portrait mode: FilterChips in first row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        FilterChip(
                          label: Text(l10n.caseSensitive, style: theme.textTheme.bodySmall),
                          selected: _caseSensitive,
                          onSelected: (value) {
                            setState(() {
                              _caseSensitive = value;
                              _applyFilters();
                            });
                          },
                        ),
                        const SizedBox(width: AppTheme.spacing8),
                        FilterChip(
                          label: Text(l10n.onlyImportant, style: theme.textTheme.bodySmall),
                          selected: _onlyImportant,
                          onSelected: (value) {
                            setState(() {
                              _onlyImportant = value;
                              _applyFilters();
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: AppTheme.spacing8),
                    // Portrait mode: Dropdown in second row
                    Row(
                      children: [
                        DropdownButton<String>(
                          value: _knownStatus,
                          items: [
                            DropdownMenuItem(value: 'all', child: Text(l10n.allItems, style: theme.textTheme.bodySmall)),
                            DropdownMenuItem(value: 'known', child: Text(l10n.itemsIKnew, style: theme.textTheme.bodySmall)),
                            DropdownMenuItem(value: 'unknown', child: Text(l10n.itemsIDidNotKnow, style: theme.textTheme.bodySmall)),
                          ],
                          onChanged: widget.package.isReadonly
                              ? null
                              : (value) {
                                  if (value != null) {
                                    setState(() {
                                      _knownStatus = value;
                                      _applyFilters();
                                    });
                                  }
                                },
                        ),
                      ],
                    ),
                  ] else
                    // Landscape mode: All filter options in one row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        FilterChip(
                          label: Text(l10n.caseSensitive, style: theme.textTheme.bodySmall),
                          selected: _caseSensitive,
                          onSelected: (value) {
                            setState(() {
                              _caseSensitive = value;
                              _applyFilters();
                            });
                          },
                        ),
                        const SizedBox(width: AppTheme.spacing8),
                        FilterChip(
                          label: Text(l10n.onlyImportant, style: theme.textTheme.bodySmall),
                          selected: _onlyImportant,
                          onSelected: (value) {
                            setState(() {
                              _onlyImportant = value;
                              _applyFilters();
                            });
                          },
                        ),
                        const SizedBox(width: AppTheme.spacing8),
                        DropdownButton<String>(
                          value: _knownStatus,
                          items: [
                            DropdownMenuItem(value: 'all', child: Text(l10n.allItems, style: theme.textTheme.bodySmall)),
                            DropdownMenuItem(value: 'known', child: Text(l10n.itemsIKnew, style: theme.textTheme.bodySmall)),
                            DropdownMenuItem(value: 'unknown', child: Text(l10n.itemsIDidNotKnow, style: theme.textTheme.bodySmall)),
                          ],
                          onChanged: widget.package.isReadonly
                              ? null
                              : (value) {
                                  if (value != null) {
                                    setState(() {
                                      _knownStatus = value;
                                      _applyFilters();
                                    });
                                  }
                                },
                        ),
                      ],
                    ),
                ],
              ),
            ),
            crossFadeState: _isFilterPanelExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }

  Widget _buildPortraitLayout(AppLocalizations l10n, ThemeData theme) {
    return _buildItemList(l10n, theme);
  }

  Widget _buildLandscapeLayout(AppLocalizations l10n, ThemeData theme) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 900;
    // print('isTablet: $isTablet, screenWidth: $screenWidth'  );

    return Row(
      children: [
        Expanded(
          flex: 1,
          child: _buildItemList(l10n, theme),
        ),
        Container(
          width: 1,
          color: theme.colorScheme.outlineVariant,
        ),
        Expanded(
          flex: 1,
          child: _selectedItem == null
              ? Center(
                  child: Text(
                    l10n.itemDetails,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                )
              : isTablet
                  ? _buildItemDetails(l10n, theme, _selectedItem!)
                  : _buildItemDetailsCompact(l10n, theme, _selectedItem!),
        ),
      ],
    );
  }

  Widget _buildItemList(AppLocalizations l10n, ThemeData theme) {
    if (_allItems.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 64,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: AppTheme.spacing8),
            Text(
              l10n.noItemsInPackage,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    if (_filteredItems.isEmpty) {
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
              l10n.noItemsFound,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppTheme.spacing8),
      itemCount: _filteredItems.length,
      itemBuilder: (context, index) {
        final item = _filteredItems[index];
        return _buildItemCard(l10n, theme, item);
      },
    );
  }

  Widget _buildItemCard(AppLocalizations l10n, ThemeData theme, Item item) {
    final isSelected = _selectedItem?.id == item.id;

    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacing8,
        vertical: AppTheme.spacing4,
      ),
      color: isSelected
          ? theme.colorScheme.primaryContainer
          : theme.colorScheme.surface,
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedItem = item;
          });
          if (MediaQuery.of(context).orientation == Orientation.portrait) {
            _showItemDetailsDialog(l10n, theme, item);
          }
        },
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacing8),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Language 1
                    _buildLanguageText(
                      theme,
                      item.language1Data,
                      isSelected
                          ? theme.colorScheme.onPrimaryContainer
                          : theme.colorScheme.onSurface,
                    ),
                    const SizedBox(height: AppTheme.spacing8),
                    // Language 2
                    _buildLanguageText(
                      theme,
                      item.language2Data,
                      isSelected
                          ? theme.colorScheme.onPrimaryContainer
                          : theme.colorScheme.onSurfaceVariant,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppTheme.spacing8),
              // Status icons
              Column(
                children: [
                  if (item.isKnown)
                    Icon(
                      Icons.check_circle,
                      size: 20,
                      color: theme.colorScheme.primary,
                    ),
                  if (item.isFavourite)
                    Icon(
                      Icons.star,
                      size: 20,
                      color: theme.colorScheme.tertiary,
                    ),
                  if (item.isImportant)
                    Icon(
                      Icons.label_important,
                      size: 20,
                      color: theme.colorScheme.secondary,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageText(ThemeData theme, dynamic languageData, Color color) {
    final preItem = languageData.preItem?.trim() ?? '';
    final text = languageData.text;
    final postItem = languageData.postItem?.trim() ?? '';

    final displayText = [
      if (preItem.isNotEmpty) '$preItem ',
      text,
      if (postItem.isNotEmpty) ' $postItem',
    ].join();

    return Text(
      displayText,
      style: theme.textTheme.bodySmall?.copyWith(color: color),
    );
  }

  void _showItemDetailsDialog(AppLocalizations l10n, ThemeData theme, Item item) {
    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600, maxHeight: 800),
          child: _buildItemDetailsForDialog(l10n, theme, item),
        ),
      ),
    );
  }

  // Separate method for dialog to ensure proper context handling
  Widget _buildItemDetailsForDialog(AppLocalizations l10n, ThemeData theme, Item item) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacing8),
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            l10n.itemDetails,
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: AppTheme.spacing8),

          // Language 1
          _buildLanguageSectionForDialog(
            l10n,
            theme,
            widget.package.languageName1,
            item.language1Data,
            item.language1Data.languageCode,
          ),
          const SizedBox(height: AppTheme.spacing8),

          // Language 2
          _buildLanguageSectionForDialog(
            l10n,
            theme,
            widget.package.languageName2,
            item.language2Data,
            item.language2Data.languageCode,
          ),
          const SizedBox(height: AppTheme.spacing8),

          // Status indicators
          Wrap(
            spacing: AppTheme.spacing8,
            runSpacing: AppTheme.spacing8,
            children: [
              if (item.isKnown)
                Chip(
                  avatar: Icon(
                    Icons.check_circle,
                    size: 20,
                    color: theme.colorScheme.primary,
                  ),
                  label: Text(l10n.known),
                ),
              if (item.isFavourite)
                Chip(
                  avatar: Icon(
                    Icons.star,
                    size: 20,
                    color: theme.colorScheme.tertiary,
                  ),
                  label: Text(l10n.favourite),
                ),
              if (item.isImportant)
                Chip(
                  avatar: Icon(
                    Icons.label_important,
                    size: 20,
                    color: theme.colorScheme.secondary,
                  ),
                  label: Text(l10n.important),
                ),
            ],
          ),
          const SizedBox(height: AppTheme.spacing8),

          // Examples
          Text(
            l10n.examples,
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: AppTheme.spacing8),
          if (item.examples.isEmpty)
            Text(
              l10n.noExamples,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            )
          else
            ...item.examples.map((example) => Padding(
                  padding: const EdgeInsets.only(bottom: AppTheme.spacing8),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppTheme.spacing8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            example.textLanguage1,
                            style: theme.textTheme.bodySmall,
                          ),
                          const SizedBox(height: AppTheme.spacing4),
                          Text(
                            example.textLanguage2,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
        ],
      ),
    );
  }

  // Language section for dialog with direct method calls (not using context from dialog)
  Widget _buildLanguageSectionForDialog(
    AppLocalizations l10n,
    ThemeData theme,
    String languageName,
    dynamic languageData,
    String languageCode,
  ) {
    final preItem = languageData.preItem?.trim() ?? '';
    final text = languageData.text;
    final postItem = languageData.postItem?.trim() ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              languageName,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.volume_up),
              tooltip: l10n.pronounce,
              onPressed: () async {
                // Call pronunciation directly without relying on dialog context for errors
                try {
                  await _ttsService.speak(text, languageCode);
                } catch (e) {
                  // Errors are logged in the service
                  // print('Pronunciation error: $e');
                }
              },
            ),
          ],
        ),
        const SizedBox(height: AppTheme.spacing8),
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
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              Text(
                text,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
              ),
              if (postItem.isNotEmpty)
                Text(
                  postItem,
                  style: theme.textTheme.titleMedium?.copyWith(
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

  Widget _buildItemDetails(AppLocalizations l10n, ThemeData theme, Item item) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacing8),
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            l10n.itemDetails,
            style: theme.textTheme.titleMedium,
          ),
           const SizedBox(height: AppTheme.spacing8),

          // Language 1
          _buildLanguageSection(
            l10n,
            theme,
            widget.package.languageName1,
            item.language1Data,
            item.language1Data.languageCode,
          ),
           const SizedBox(height: AppTheme.spacing8),

          // Language 2
          _buildLanguageSection(
            l10n,
            theme,
            widget.package.languageName2,
            item.language2Data,
            item.language2Data.languageCode,
          ),
           const SizedBox(height: AppTheme.spacing8),

          // Status indicators
          Wrap(
            // spacing: AppTheme.spacing8,
            runSpacing: AppTheme.spacing8,
            children: [
              if (item.isKnown)
                Chip(
                  avatar: Icon(
                    Icons.check_circle,
                    size: 20,
                    color: theme.colorScheme.primary,
                  ),
                  label: Text(l10n.known),
                ),
              if (item.isFavourite)
                Chip(
                  avatar: Icon(
                    Icons.star,
                    size: 20,
                    color: theme.colorScheme.tertiary,
                  ),
                  label: Text(l10n.favourite),
                ),
              if (item.isImportant)
                Chip(
                  avatar: Icon(
                    Icons.label_important,
                    size: 20,
                    color: theme.colorScheme.secondary,
                  ),
                  label: Text(l10n.important),
                ),
            ],
          ),
          const SizedBox(height: AppTheme.spacing8),

          // Examples
          Text(
            l10n.examples,
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: AppTheme.spacing8),
          if (item.examples.isEmpty)
            Text(
              l10n.noExamples,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            )
          else
            ...item.examples.map((example) => Padding(
                  padding: const EdgeInsets.only(bottom: AppTheme.spacing8),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppTheme.spacing8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            example.textLanguage1,
                            style: theme.textTheme.bodySmall,
                          ),
                          const SizedBox(height: AppTheme.spacing4),
                          Text(
                            example.textLanguage2,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
        ],
      ),
    );
  }

  Widget _buildLanguageSection(
    AppLocalizations l10n,
    ThemeData theme,
    String languageName,
    dynamic languageData,
    String languageCode,
  ) {
    final preItem = languageData.preItem?.trim() ?? '';
    final text = languageData.text;
    final postItem = languageData.postItem?.trim() ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              languageName,
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.volume_up),
              tooltip: l10n.pronounce,
              onPressed: () => _pronounce(text, languageCode),
            ),
          ],
        ),
        const SizedBox(height: AppTheme.spacing4),
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
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              Text(
                text,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
              ),
              if (postItem.isNotEmpty)
                Text(
                  postItem,
                  style: theme.textTheme.titleSmall?.copyWith(
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

  // Compact version for phones in landscape mode (half fonts and spacing)
  Widget _buildItemDetailsCompact(AppLocalizations l10n, ThemeData theme, Item item) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacing4), // Half of spacing8
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          //Text(
          //  l10n.itemDetails,
          //  style: theme.textTheme.titleSmall?.copyWith(
          //    fontSize: (theme.textTheme.titleSmall?.fontSize ?? 14) * 0.75,
          //  ),
          //),
          const SizedBox(height: AppTheme.spacing4), // Half of spacing8

          // Language 1
          _buildLanguageSectionCompact(
            l10n,
            theme,
            widget.package.languageName1,
            item.language1Data,
            item.language1Data.languageCode,
          ),
          const SizedBox(height: AppTheme.spacing4), // Half of spacing8

          // Language 2
          _buildLanguageSectionCompact(
            l10n,
            theme,
            widget.package.languageName2,
            item.language2Data,
            item.language2Data.languageCode,
          ),
          const SizedBox(height: AppTheme.spacing4), // Half of spacing8

          // Status indicators (compact)
          Wrap(
            spacing: AppTheme.spacing4, // Half of spacing8
            runSpacing: AppTheme.spacing4,
            children: [
              if (item.isKnown)
                _buildCompactChip(
                  theme,
                  Icons.check_circle,
                  l10n.known,
                  theme.colorScheme.primary,
                ),
              if (item.isFavourite)
                _buildCompactChip(
                  theme,
                  Icons.star,
                  l10n.favourite,
                  theme.colorScheme.tertiary,
                ),
              if (item.isImportant)
                _buildCompactChip(
                  theme,
                  Icons.label_important,
                  l10n.important,
                  theme.colorScheme.secondary,
                ),
            ],
          ),
          const SizedBox(height: AppTheme.spacing4), // Half of spacing8

          // Examples
          Text(
            l10n.examples,
            style: theme.textTheme.titleSmall?.copyWith(
              fontSize: (theme.textTheme.titleSmall?.fontSize ?? 14) ,
            ),
          ),
          const SizedBox(height: AppTheme.spacing4), // Half of spacing8
          if (item.examples.isEmpty)
            Text(
              l10n.noExamples,
              style: theme.textTheme.bodySmall?.copyWith(
                fontSize: (theme.textTheme.bodySmall?.fontSize ?? 12) ,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            )
          else
            ...item.examples.map((example) => Padding(
                  padding: const EdgeInsets.only(bottom: AppTheme.spacing4), // Half of spacing8
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppTheme.spacing4), // Half of spacing8
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            example.textLanguage1,
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontSize: (theme.textTheme.bodySmall?.fontSize ?? 12) ,
                            ),
                          ),
                          const SizedBox(height: 2.0), // Half of spacing4
                          Text(
                            example.textLanguage2,
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontSize: (theme.textTheme.bodySmall?.fontSize ?? 12) ,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
        ],
      ),
    );
  }

  Widget _buildCompactChip(ThemeData theme, IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacing4,
        vertical: 2.0,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 2.0),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              fontSize: (theme.textTheme.bodySmall?.fontSize ?? 12) * 0.75,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageSectionCompact(
    AppLocalizations l10n,
    ThemeData theme,
    String languageName,
    dynamic languageData,
    String languageCode,
  ) {
    final preItem = languageData.preItem?.trim() ?? '';
    final text = languageData.text;
    final postItem = languageData.postItem?.trim() ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              languageName,
              style: theme.textTheme.labelMedium?.copyWith(
                fontSize: (theme.textTheme.titleSmall?.fontSize ?? 14) ,
                color: theme.colorScheme.primary,
              ),
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.volume_up),
              iconSize: 16, // Smaller icon
              padding: const EdgeInsets.all(AppTheme.spacing4),
              constraints: const BoxConstraints(
                minWidth: 28,
                minHeight: 28,
              ),
              tooltip: l10n.pronounce,
              onPressed: () => _pronounce(text, languageCode),
            ),
          ],
        ),
        const SizedBox(height: 2.0), // Half of spacing4
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppTheme.spacing4), // Half of spacing8
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (preItem.isNotEmpty)
                Text(
                  preItem,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontSize: (theme.textTheme.titleSmall?.fontSize ?? 14),
                    color: theme.colorScheme.onSurfaceVariant,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              Text(
                text,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontSize: (theme.textTheme.titleSmall?.fontSize ?? 14) ,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              if (postItem.isNotEmpty)
                Text(
                  postItem,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontSize: (theme.textTheme.titleSmall?.fontSize ?? 14) ,
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
}

