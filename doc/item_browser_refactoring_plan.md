# Item Browser Refactoring Plan

## Current File Size
- **item_browser_page.dart**: 2840 lines

## Refactoring Strategy

### 3 Files Split:

1. **item_browser_page.dart** (Main file - ~600 lines)
   - ItemBrowserPage widget
   - _ItemBrowserPageState with core state management
   - Lifecycle methods (initState, dispose)
   - Data loading (_loadItems)
   - Filter logic (_applyFilters, _clearFilters)
   - Toggle methods (_toggleFavourite, _toggleImportant)
   - TTS (_pronounce)
   - Main build method
   - Delete/Edit item actions

2. **item_browser_widgets.dart** (UI Widgets - ~1400 lines)
   - Mixin: ItemBrowserWidgetsMixin
   - _buildFilterPanel
   - _buildPortraitLayout / _buildLandscapeLayout
   - _buildItemList
   - _buildItemCard
   - _buildLanguageText
   - _showItemDetailsDialog
   - _buildItemDetailsForDialog
   - _buildLanguageSectionForDialog
   - _buildItemDetails
   - _buildLanguageSection
   - _buildItemDetailsCompact
   - _buildCompactChip
   - _buildLanguageSectionCompact
   - Floating buttons (_buildLandscapeFloatingButtons, _buildPortraitFloatingButton)
   - Confirmation/deletion dialogs

3. **item_browser_dialogs.dart** (Category Management - ~700 lines) ✓ CREATED
   - Mixin: ItemBrowserDialogsMixin
   - Category chip widgets
   - Add/Remove category dialogs
   - Category filter dialog

## Implementation Steps

1. ✓ Create item_browser_dialogs.dart with category management
2. Create item_browser_widgets.dart with all UI widgets
3. Refactor main file to use both mixins
4. Test compilation
5. Format all files

## Mixin Interface Requirements

### ItemBrowserWidgetsMixin needs access to:
- BuildContext context
- LanguagePackage package
- List<Item> allItems / filteredItems
- Item? selectedItem
- Filter state variables
- TtsService
- Callbacks for toggle, delete, edit operations

### ItemBrowserDialogsMixin needs access to:
- BuildContext context
- LanguagePackage package
- List<Category> allCategories
- ItemRepository / CategoryRepository
- setState callback
- applyFilters callback


