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
import 'package:uuid/uuid.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/tts_service.dart';
import '../../../data/models/item.dart';
import '../../../data/models/category.dart';
import '../../../data/models/language_package.dart';
import '../../../data/repositories/item_repository.dart';
import '../../../data/repositories/category_repository.dart';
import '../../../l10n/app_localizations.dart';
import 'item_edit_page.dart';

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
  final _categoryRepo = CategoryRepository();
  final _ttsService = TtsService();
  List<Item> _allItems = [];
  List<Item> _filteredItems = [];
  List<Category> _allCategories = [];
  bool _isLoading = true;
  Item? _selectedItem;

  // Filter state
  final _language1Controller = TextEditingController();
  final _language2Controller = TextEditingController();
  bool _caseSensitive = false;
  bool _onlyImportant = false;
  String _knownStatus = 'all'; // 'all', 'known', 'unknown'
  List<String> _selectedCategoryIds = []; // Multi-select category filter
  bool _isFilterPanelExpanded = false; // Start collapsed to save screen space

  @override
  void initState() {
    super.initState();
    _ttsService.initialize();
    _loadItems();
    _language1Controller.addListener(() {
      _applyFilters(autoSelectFirst: true);
      setState(() {}); // Rebuild to show/hide clear button
    });
    _language2Controller.addListener(() {
      _applyFilters(autoSelectFirst: true);
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
      final categories = await _categoryRepo.getCategoriesForPackage(widget.package.id);
      setState(() {
        _allItems = items;
        _filteredItems = items;
        _allCategories = categories;
        // Auto-select first item on initial load
        if (items.isNotEmpty) {
          _selectedItem = items.first;
        }
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void _applyFilters({bool clearSelectionIfFiltered = true, bool autoSelectFirst = false}) {
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

        // Apply category filter (if any categories selected)
        if (_selectedCategoryIds.isNotEmpty) {
          // Item must have at least one of the selected categories
          final hasSelectedCategory = item.categoryIds.any(
            (categoryId) => _selectedCategoryIds.contains(categoryId),
          );
          if (!hasSelectedCategory) return false;
        }

        return true;
      }).toList();

      // Clear selected item if it's no longer in the filtered results (only when filter changes)
      if (clearSelectionIfFiltered && _selectedItem != null && !_filteredItems.contains(_selectedItem)) {
        _selectedItem = null;
      }

      // Auto-select first item if requested and items available
      if (autoSelectFirst && _filteredItems.isNotEmpty) {
        _selectedItem = _filteredItems.first;
      }
    });
  }

  void _clearFilters() {
    setState(() {
      _language1Controller.clear();
      _language2Controller.clear();
      _caseSensitive = false;
      _onlyImportant = false;
      _knownStatus = 'all';
      _selectedCategoryIds = []; // Clear category filter
      _applyFilters(autoSelectFirst: true);
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
        _knownStatus != 'all' ||
        _selectedCategoryIds.isNotEmpty;

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
                              _applyFilters(autoSelectFirst: true);
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
                              _applyFilters(autoSelectFirst: true);
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
                                      _applyFilters(autoSelectFirst: true);
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
                              _applyFilters(autoSelectFirst: true);
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
                              _applyFilters(autoSelectFirst: true);
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
                                      _applyFilters(autoSelectFirst: true);
                                    });
                                  }
                                },
                        ),
                        const SizedBox(width: AppTheme.spacing8),
                        // Category multiselect filter
                        _buildCategoryMultiSelectButton(theme),
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
    return Stack(
      children: [
        _buildItemList(l10n, theme),
        // Floating Add button (only for non-readonly packages)
        if (!widget.package.isReadonly)
          _buildPortraitFloatingButton(theme, l10n),
      ],
    );
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
          child: Stack(
            children: [
              // Item details or placeholder
              _selectedItem == null
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

              // Floating action buttons (only for non-readonly packages)
              if (!widget.package.isReadonly)
                _buildLandscapeFloatingButtons(theme, l10n),
            ],
          ),
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
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) {
          // Get the latest item data
          final currentItem = _allItems.firstWhere(
            (i) => i.id == item.id,
            orElse: () => item,
          );
          return Dialog(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 600, maxHeight: 800),
              child: _buildItemDetailsForDialog(l10n, theme, currentItem, setDialogState),
            ),
          );
        },
      ),
    );
  }

  // Separate method for dialog to ensure proper context handling
  Widget _buildItemDetailsForDialog(AppLocalizations l10n, ThemeData theme, Item item, StateSetter setDialogState) {
    // Helper to reduce font size by 25%
    TextStyle? reduceFontSize(TextStyle? style) {
      if (style == null) return null;
      return style.copyWith(
        fontSize: (style.fontSize ?? 14) * 0.75,
      );
    }

    return Stack(
      children: [
        SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacing8),
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            l10n.itemDetails,
            style: reduceFontSize(theme.textTheme.headlineSmall),
          ),
          const SizedBox(height: AppTheme.spacing8),

          // Language 1
          _buildLanguageSectionForDialog(
            l10n,
            theme,
            widget.package.languageName1,
            item.language1Data,
            item.language1Data.languageCode,
            reduceFontSize,
          ),
          const SizedBox(height: AppTheme.spacing8),

          // Language 2
          _buildLanguageSectionForDialog(
            l10n,
            theme,
            widget.package.languageName2,
            item.language2Data,
            item.language2Data.languageCode,
            reduceFontSize,
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
                    size: 15, // 25% smaller than 20
                    color: theme.colorScheme.primary,
                  ),
                  label: Text(
                    l10n.known,
                    style: reduceFontSize(theme.textTheme.bodyMedium),
                  ),
                ),
              if (item.isFavourite)
                Chip(
                  avatar: Icon(
                    Icons.star,
                    size: 15, // 25% smaller than 20
                    color: theme.colorScheme.tertiary,
                  ),
                  label: Text(
                    l10n.favourite,
                    style: reduceFontSize(theme.textTheme.bodyMedium),
                  ),
                ),
              if (item.isImportant)
                Chip(
                  avatar: Icon(
                    Icons.label_important,
                    size: 15, // 25% smaller than 20
                    color: theme.colorScheme.secondary,
                  ),
                  label: Text(
                    l10n.important,
                    style: reduceFontSize(theme.textTheme.bodyMedium),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppTheme.spacing8),

          // Examples
          Text(
            l10n.examples,
            style: reduceFontSize(theme.textTheme.titleMedium),
          ),
          const SizedBox(height: AppTheme.spacing8),
          if (item.examples.isEmpty)
            Text(
              l10n.noExamples,
              style: reduceFontSize(theme.textTheme.bodySmall)?.copyWith(
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
                            style: reduceFontSize(theme.textTheme.bodySmall),
                          ),
                          const SizedBox(height: AppTheme.spacing4),
                          Text(
                            example.textLanguage2,
                            style: reduceFontSize(theme.textTheme.bodySmall)?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )),

          // Categories section
          const SizedBox(height: AppTheme.spacing8),
          _buildCategoryChipsForDialog(item, theme, setDialogState, reduceFontSize),
        ],
      ),
    ),
        // Floating buttons - Edit and Delete
        if (!widget.package.isReadonly)
          Positioned(
            top: AppTheme.spacing8,
            right: AppTheme.spacing8,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Delete button
                FloatingActionButton.small(
                  heroTag: 'delete_item_${item.id}',
                  onPressed: () => _confirmDeleteItem(item),
                  backgroundColor: theme.colorScheme.errorContainer,
                  child: Icon(
                    Icons.delete_outline,
                    size: 18,
                    color: theme.colorScheme.onErrorContainer,
                  ),
                ),
                const SizedBox(width: AppTheme.spacing8),
                // Edit button
                FloatingActionButton.small(
                  heroTag: 'edit_item_${item.id}',
                  onPressed: () => _showEditItemDialog(item, setDialogState),
                  backgroundColor: theme.colorScheme.primaryContainer,
                  child: Icon(
                    Icons.edit_outlined,
                    size: 18,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  // Language section for dialog with direct method calls (not using context from dialog)
  Widget _buildLanguageSectionForDialog(
    AppLocalizations l10n,
    ThemeData theme,
    String languageName,
    dynamic languageData,
    String languageCode,
    TextStyle? Function(TextStyle?) reduceFontSize,
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
              style: reduceFontSize(theme.textTheme.titleMedium)?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
            const Spacer(),
            IconButton(
              iconSize: 18, // 25% smaller than 24
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
                  style: reduceFontSize(theme.textTheme.titleMedium)?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              Text(
                text,
                style: reduceFontSize(theme.textTheme.titleMedium)?.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
              ),
              if (postItem.isNotEmpty)
                Text(
                  postItem,
                  style: reduceFontSize(theme.textTheme.titleMedium)?.copyWith(
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
    return Stack(
      children: [
        SingleChildScrollView(
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

              // Categories section (chips with add button)
              const SizedBox(height: AppTheme.spacing8),
              _buildCategoryChips(item, theme),
            ],
          ),
        ),
      ],
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

  /// Build category chips with double-click to remove
  Widget _buildCategoryChips(Item item, ThemeData theme) {
    final itemCategories = _allCategories
        .where((cat) => item.categoryIds.contains(cat.id))
        .toList();

    return Wrap(
      spacing: AppTheme.spacing8,
      runSpacing: AppTheme.spacing8,
      children: [
        // Category chips
        ...itemCategories.map((category) {
          return GestureDetector(
            onTap: widget.package.isReadonly
                ? null
                : () => _confirmRemoveCategory(item, category),
            child: Chip(
              avatar: Icon(
                Icons.label,
                size: 18,
                color: theme.colorScheme.primary,
              ),
              label: Text(category.name),
              backgroundColor: theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
            ),
          );
        }),
        // Add category button (shown after all chips)
        if (!widget.package.isReadonly)
          ActionChip(
            avatar: Icon(
              Icons.add,
              size: 18,
              color: theme.colorScheme.primary,
            ),
            label: const Text(''),
            padding: const EdgeInsets.all(0),
            labelPadding: const EdgeInsets.all(0),
            visualDensity: VisualDensity.compact,
            backgroundColor: theme.colorScheme.primaryContainer,
            onPressed: () => _showAddCategoryDialog(item),
          ),
      ],
    );
  }

  /// Build category chips for dialog with single-click to remove
  Widget _buildCategoryChipsForDialog(
    Item item,
    ThemeData theme,
    StateSetter setDialogState,
    TextStyle? Function(TextStyle?) reduceFontSize,
  ) {
    final itemCategories = _allCategories
        .where((cat) => item.categoryIds.contains(cat.id))
        .toList();

    return Wrap(
      spacing: AppTheme.spacing8,
      runSpacing: AppTheme.spacing8,
      children: [
        // Category chips
        ...itemCategories.map((category) {
          return GestureDetector(
            onTap: widget.package.isReadonly
                ? null
                : () => _confirmRemoveCategoryFromDialog(item, category, setDialogState),
            child: Chip(
              avatar: Icon(
                Icons.label,
                size: 13.5, // 25% smaller than 18 (18 * 0.75 = 13.5)
                color: theme.colorScheme.primary,
              ),
              label: Text(
                category.name,
                style: reduceFontSize(theme.textTheme.bodyMedium),
              ),
              backgroundColor: theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
            ),
          );
        }),
        // Add category button (shown after all chips)
        if (!widget.package.isReadonly)
          ActionChip(
            avatar: Icon(
              Icons.add,
              size: 13.5, // 25% smaller than 18
              color: theme.colorScheme.primary,
            ),
            label: const Text(''),
            padding: const EdgeInsets.all(0),
            labelPadding: const EdgeInsets.all(0),
            visualDensity: VisualDensity.compact,
            backgroundColor: theme.colorScheme.primaryContainer,
            onPressed: () => _showAddCategoryDialogFromDialog(item, setDialogState),
          ),
      ],
    );
  }

  /// Show add category dialog from within item details dialog
  Future<void> _showAddCategoryDialogFromDialog(Item item, StateSetter setDialogState) async {
    await _showAddCategoryDialog(item);
    // Refresh the dialog after adding category
    setDialogState(() {});
  }

  /// Confirm and remove a category from an item (called from dialog)
  Future<void> _confirmRemoveCategoryFromDialog(
    Item item,
    Category category,
    StateSetter setDialogState,
  ) async {
    final l10n = AppLocalizations.of(context)!;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Category'),
        content: Text('Remove category "${category.name}" from this item?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Remove'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _removeCategoryFromItem(item, category);
      // Refresh the dialog after removing category
      setDialogState(() {});
    }
  }

  /// Show dialog to add existing or create new category
  Future<void> _showAddCategoryDialog(Item item) async {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;

    // Get categories not already assigned to this item
    final availableCategories = _allCategories
        .where((cat) => !item.categoryIds.contains(cat.id))
        .toList();

    final TextEditingController categoryController = TextEditingController();
    Category? selectedCategory;

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          titlePadding: const EdgeInsets.fromLTRB(
            AppTheme.spacing12,
            AppTheme.spacing12,
            AppTheme.spacing12,
            AppTheme.spacing8,
          ),
          contentPadding: const EdgeInsets.fromLTRB(
            AppTheme.spacing12,
            AppTheme.spacing8,
            AppTheme.spacing12,
            AppTheme.spacing8,
          ),
          actionsPadding: const EdgeInsets.fromLTRB(
            AppTheme.spacing12,
            AppTheme.spacing8,
            AppTheme.spacing12,
            AppTheme.spacing12,
          ),
          title: Text(
            'Add Category',
            style: theme.textTheme.titleSmall,
          ),
          content: SizedBox(
            width: screenWidth * 0.25, // 50% of default dialog width (~50% of screen)
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select existing or create new category:',
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: AppTheme.spacing8),

                // Autocomplete for category selection/creation
                Autocomplete<Category>(
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    if (textEditingValue.text.isEmpty) {
                      return availableCategories;
                    }
                    return availableCategories.where((category) {
                      return category.name
                          .toLowerCase()
                          .contains(textEditingValue.text.toLowerCase());
                    });
                  },
                  displayStringForOption: (Category option) => option.name,
                  fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
                    categoryController.text = textEditingController.text;
                    textEditingController.addListener(() {
                      categoryController.text = textEditingController.text;
                    });

                    return TextField(
                      controller: textEditingController,
                      focusNode: focusNode,
                      style: theme.textTheme.bodySmall,
                      decoration: InputDecoration(
                        hintText: 'Type to search or create new...',
                        hintStyle: theme.textTheme.bodySmall,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                        ),
                        prefixIcon: const Icon(Icons.search, size: 18),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.spacing8,
                          vertical: AppTheme.spacing8,
                        ),
                        isDense: true,
                      ),
                      onSubmitted: (_) => onFieldSubmitted(),
                    );
                  },
                  optionsViewBuilder: (context, onSelected, options) {
                    return Align(
                      alignment: Alignment.topLeft,
                      child: Material(
                        elevation: 4.0,
                        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxHeight: 150, maxWidth: 150),
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemCount: options.length,
                            itemBuilder: (context, index) {
                              final option = options.elementAt(index);
                              return ListTile(
                                dense: true,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: AppTheme.spacing8,
                                  vertical: AppTheme.spacing4,
                                ),
                                leading: const Icon(Icons.label_outline, size: 18),
                                title: Text(
                                  option.name,
                                  style: theme.textTheme.bodySmall,
                                ),
                                subtitle: option.description != null
                                    ? Text(
                                        option.description!,
                                        style: theme.textTheme.bodySmall?.copyWith(
                                          fontSize: (theme.textTheme.bodySmall?.fontSize ?? 12) * 0.9,
                                        ),
                                      )
                                    : null,
                                onTap: () => onSelected(option),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                  onSelected: (Category selection) {
                    setDialogState(() {
                      selectedCategory = selection;
                    });
                  },
                ),

                const SizedBox(height: AppTheme.spacing4),
                Text(
                  'Tip: Select from the list or type a new name to create it',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: (theme.textTheme.bodySmall?.fontSize ?? 12) * 0.9,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacing12,
                  vertical: AppTheme.spacing8,
                ),
              ),
              child: Text(
                l10n.cancel,
                style: theme.textTheme.bodySmall,
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final categoryName = categoryController.text.trim();
                if (categoryName.isEmpty) {
                  Navigator.of(context).pop();
                  return;
                }

                // Check if we're creating new or using existing
                Category categoryToAdd;
                if (selectedCategory != null && selectedCategory!.name == categoryName) {
                  categoryToAdd = selectedCategory!;
                } else {
                  // Create new category
                  categoryToAdd = Category(
                    id: const Uuid().v4(),
                    packageId: widget.package.id,
                    name: categoryName,
                  );
                  await _categoryRepo.insertCategory(categoryToAdd);
                  _allCategories.add(categoryToAdd);
                }

                // Add category to item
                await _assignCategoryToItem(item, categoryToAdd);

                if (mounted) {
                  Navigator.of(context).pop();
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacing12,
                  vertical: AppTheme.spacing8,
                ),
              ),
              child: Text(
                'Add',
                style: theme.textTheme.bodySmall,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Assign a category to an item
  Future<void> _assignCategoryToItem(Item item, Category category) async {
    try {
      final updatedCategoryIds = [...item.categoryIds, category.id];
      final updatedItem = item.copyWith(categoryIds: updatedCategoryIds);

      await _itemRepo.updateItem(updatedItem);

      // Refresh the item in our lists
      final index = _allItems.indexWhere((i) => i.id == item.id);
      if (index != -1) {
        setState(() {
          _allItems[index] = updatedItem;
          // Keep selection when modifying item categories
          _applyFilters(clearSelectionIfFiltered: false, autoSelectFirst: false);
          if (_selectedItem?.id == item.id) {
            _selectedItem = updatedItem;
          }
        });
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Category "${category.name}" added'),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error adding category: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  /// Confirm and remove a category from an item
  Future<void> _confirmRemoveCategory(Item item, Category category) async {
    final l10n = AppLocalizations.of(context)!;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Category'),
        content: Text('Remove category "${category.name}" from this item?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Remove'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _removeCategoryFromItem(item, category);
    }
  }

  /// Remove a category from an item
  Future<void> _removeCategoryFromItem(Item item, Category category) async {
    try {
      final updatedCategoryIds = item.categoryIds.where((id) => id != category.id).toList();
      final updatedItem = item.copyWith(categoryIds: updatedCategoryIds);

      await _itemRepo.updateItem(updatedItem);

      // Refresh the item in our lists
      final index = _allItems.indexWhere((i) => i.id == item.id);
      if (index != -1) {
        setState(() {
          _allItems[index] = updatedItem;
          // Keep selection when modifying item categories
          _applyFilters(clearSelectionIfFiltered: false, autoSelectFirst: false);
          if (_selectedItem?.id == item.id) {
            _selectedItem = updatedItem;
          }
        });
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Category "${category.name}" removed'),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error removing category: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  /// Build category multiselect filter button
  Widget _buildCategoryMultiSelectButton(ThemeData theme) {
    final selectedCount = _selectedCategoryIds.length;

    return OutlinedButton.icon(
      icon: Icon(
        Icons.label_outline,
        size: 18,
        color: selectedCount > 0 ? theme.colorScheme.primary : null,
      ),
      label: Text(
        selectedCount > 0 ? 'Categories ($selectedCount)' : 'Categories',
        style: theme.textTheme.bodySmall?.copyWith(
          color: selectedCount > 0 ? theme.colorScheme.primary : null,
          fontWeight: selectedCount > 0 ? FontWeight.bold : null,
        ),
      ),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacing8,
          vertical: AppTheme.spacing4,
        ),
        minimumSize: Size.zero,
        side: BorderSide(
          color: selectedCount > 0
              ? theme.colorScheme.primary
              : theme.colorScheme.outline,
          width: selectedCount > 0 ? 2 : 1,
        ),
      ),
      onPressed: () => _showCategoryFilterDialog(),
    );
  }

  /// Show category multiselect filter dialog
  Future<void> _showCategoryFilterDialog() async {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;

    // Create a copy of current selections
    final tempSelectedIds = List<String>.from(_selectedCategoryIds);

    // Sort categories alphabetically (case-insensitive)
    final sortedCategories = List<Category>.from(_allCategories)
      ..sort((a, b) => a.name.toUpperCase().compareTo(b.name.toUpperCase()));

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          titlePadding: const EdgeInsets.fromLTRB(
            AppTheme.spacing12,
            AppTheme.spacing12,
            AppTheme.spacing8,
            AppTheme.spacing8,
          ),
          contentPadding: const EdgeInsets.fromLTRB(
            AppTheme.spacing12,
            AppTheme.spacing8,
            AppTheme.spacing12,
            AppTheme.spacing8,
          ),
          actionsPadding: const EdgeInsets.fromLTRB(
            AppTheme.spacing12,
            AppTheme.spacing8,
            AppTheme.spacing12,
            AppTheme.spacing12,
          ),
          title: Row(
            children: [
              Icon(Icons.label_outline, size: 18),
              const SizedBox(width: AppTheme.spacing4),
              Text(
                'Filter by Categories',
                style: theme.textTheme.titleSmall,
              ),
              const Spacer(),
              if (tempSelectedIds.isNotEmpty)
                TextButton(
                  onPressed: () {
                    setDialogState(() {
                      tempSelectedIds.clear();
                    });
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacing8,
                      vertical: AppTheme.spacing4,
                    ),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'Clear All',
                    style: theme.textTheme.bodySmall,
                  ),
                ),
            ],
          ),
          content: SizedBox(
            width: screenWidth * 0.25, // 50% smaller than default (was ~50%, now 25%)
            child: sortedCategories.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(AppTheme.spacing8),
                    child: Text(
                      'No categories found in this package',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodySmall,
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: sortedCategories.length,
                    itemBuilder: (context, index) {
                      final category = sortedCategories[index];
                      final isSelected = tempSelectedIds.contains(category.id);

                      return CheckboxListTile(
                        dense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.spacing4,
                          vertical: 0,
                        ),
                        title: Text(
                          category.name,
                          style: theme.textTheme.bodySmall,
                        ),
                        subtitle: category.description != null
                            ? Text(
                                category.description!,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontSize: (theme.textTheme.bodySmall?.fontSize ?? 12) * 0.9,
                                ),
                              )
                            : null,
                        value: isSelected,
                        onChanged: (bool? value) {
                          setDialogState(() {
                            if (value == true) {
                              tempSelectedIds.add(category.id);
                            } else {
                              tempSelectedIds.remove(category.id);
                            }
                          });
                        },
                        secondary: Icon(
                          Icons.label,
                          size: 18,
                          color: isSelected
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurfaceVariant,
                        ),
                      );
                    },
                  ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacing12,
                  vertical: AppTheme.spacing8,
                ),
              ),
              child: Text(
                'Cancel',
                style: theme.textTheme.bodySmall,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _selectedCategoryIds = tempSelectedIds;
                  _applyFilters(autoSelectFirst: true);
                });
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacing12,
                  vertical: AppTheme.spacing8,
                ),
              ),
              child: Text(
                'Apply',
                style: theme.textTheme.bodySmall,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Confirm and delete an item
  Future<void> _confirmDeleteItem(Item item) async {
    final l10n = AppLocalizations.of(context)!;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Item'),
        content: Text('Are you sure you want to delete this item?\n\n"${item.language1Data.text}" / "${item.language2Data.text}"\n\nThis action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _deleteItem(item);
    }
  }

  /// Delete an item
  Future<void> _deleteItem(Item item) async {
    try {
      await _itemRepo.deleteItem(item.id);

      // Remove from lists
      setState(() {
        _allItems.removeWhere((i) => i.id == item.id);
        _applyFilters(clearSelectionIfFiltered: false, autoSelectFirst: false);
        if (_selectedItem?.id == item.id) {
          _selectedItem = null;
        }
      });

      // Close the dialog
      if (mounted) {
        Navigator.of(context).pop(); // Close item details dialog

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Item deleted'),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting item: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  /// Show edit item dialog
  /// Show edit item page (portrait mode) - navigates to full-screen page
  Future<void> _showEditItemDialog(Item item, StateSetter parentDialogState) async {
    // Close the details dialog first
    Navigator.of(context).pop();

    // Navigate to edit page
    final updated = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => ItemEditPage(
          item: item,
          package: widget.package,
        ),
      ),
    );

    if (updated == true) {
      // Reload items to get the updated data
      await _loadItems();
      setState(() {
        // Update UI
      });
    }
  }

  /// Build floating action buttons for landscape mode (Edit, Add, Delete)
  Widget _buildLandscapeFloatingButtons(ThemeData theme, AppLocalizations l10n) {
    return Positioned(
      top: AppTheme.spacing8,
      right: AppTheme.spacing8,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Edit button (visible when item is selected)
          if (_selectedItem != null) ...[
            FloatingActionButton.small(
              heroTag: 'edit_landscape_${_selectedItem!.id}',
              onPressed: () => _showEditItemDialogLandscape(_selectedItem!),
              backgroundColor: theme.colorScheme.primaryContainer,
              child: Icon(
                Icons.edit,
                size: 20,
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(width: AppTheme.spacing8),
          ],

          // Add button (always visible)
          FloatingActionButton.small(
            heroTag: 'add_landscape',
            onPressed: _showAddItemDialog,
            backgroundColor: theme.colorScheme.secondaryContainer,
            child: Icon(
              Icons.add,
              size: 20,
              color: theme.colorScheme.onSecondaryContainer,
            ),
          ),

          // Delete button (visible when item is selected)
          if (_selectedItem != null) ...[
            const SizedBox(width: AppTheme.spacing8),
            FloatingActionButton.small(
              heroTag: 'delete_landscape_${_selectedItem!.id}',
              onPressed: () => _confirmDeleteItemLandscape(_selectedItem!),
              backgroundColor: theme.colorScheme.errorContainer,
              child: Icon(
                Icons.delete,
                size: 20,
                color: theme.colorScheme.onErrorContainer,
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Build floating action button for portrait mode (Add only)
  Widget _buildPortraitFloatingButton(ThemeData theme, AppLocalizations l10n) {
    return Positioned(
      right: AppTheme.spacing16,
      bottom: AppTheme.spacing16,
      child: FloatingActionButton(
        heroTag: 'add_portrait',
        onPressed: _showAddItemDialog,
        backgroundColor: theme.colorScheme.secondaryContainer,
        child: Icon(
          Icons.add,
          color: theme.colorScheme.onSecondaryContainer,
        ),
      ),
    );
  }

  /// Show edit item page in landscape mode (full screen)
  Future<void> _showEditItemDialogLandscape(Item item) async {
    final updated = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => ItemEditPage(
          item: item,
          package: widget.package,
        ),
      ),
    );

    if (updated == true) {
      // Reload items and refresh UI
      await _loadItems();
      setState(() {
        // Update selected item with new data
        _selectedItem = _allItems.firstWhere(
          (i) => i.id == item.id,
          orElse: () => item,
        );
      });
    }
  }

  /// Confirm and delete item in landscape mode
  Future<void> _confirmDeleteItemLandscape(Item item) async {
    final l10n = AppLocalizations.of(context)!;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteItem),
        content: Text('${l10n.confirmDeleteItem}\n\n"${item.language1Data.text}" / "${item.language2Data.text}"\n\n${l10n.thisActionCannotBeUndone}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _deleteItemLandscape(item);
    }
  }

  /// Delete item in landscape mode
  Future<void> _deleteItemLandscape(Item item) async {
    final l10n = AppLocalizations.of(context)!;

    try {
      await _itemRepo.deleteItem(item.id);

      // Remove from lists and clear selection
      setState(() {
        _allItems.removeWhere((i) => i.id == item.id);
        _applyFilters(clearSelectionIfFiltered: false, autoSelectFirst: false);
        if (_selectedItem?.id == item.id) {
          _selectedItem = null;
        }
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.itemDeleted),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.errorDeletingItem}: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  /// Show add item dialog
  Future<void> _showAddItemDialog() async {
    // Navigate to ItemEditPage with a new item
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ItemEditPage.newItem(package: widget.package),
      ),
    );

    // If item was created successfully, refresh the list
    if (result == true && mounted) {
      await _loadItems();

      // Show success indicator
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.itemCreated),
          backgroundColor: Theme.of(context).colorScheme.primary,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}





