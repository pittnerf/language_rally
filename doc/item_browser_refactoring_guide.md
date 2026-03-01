# Item Browser Refactoring - Method Extraction Guide

## Quick Reference: Which Methods Go Where

### ✅ ALREADY DONE: item_browser_dialogs.dart
All category-related methods are extracted.

---

## 🎯 TODO: Create item_browser_widgets_mixin.dart

### Extract These Widget Methods (in order of appearance):

1. **_buildFilterPanel** (line ~258) - Large filter panel UI
2. **_buildPortraitLayout** (line ~540)
3. **_buildLandscapeLayout** (line ~551)
4. **_buildItemList** (line ~590)
5. **_buildItemCard** (line ~645)
6. **_buildLanguageText** (line ~784)
7. **_showItemDetailsDialog** (line ~808)
8. **_buildItemDetailsForDialog** (line ~857)
9. **_buildLanguageSectionForDialog** (line ~1060)
10. **_buildItemDetails** (line ~1142)
11. **_buildLanguageSection** (line ~1283)
12. **_buildItemDetailsCompact** (line ~1358)
13. **_buildCompactChip** (line ~1575)
14. **_buildLanguageSectionCompact** (line ~1607)
15. **_buildLandscapeFloatingButtons** (line ~2340)
16. **_buildPortraitFloatingButton** (line ~2401)

### Extract These Action Methods:

17. **_showEditItemDialog** (line ~2055)
18. **_showEditItemDialogLandscape** (line ~2423)
19. **_confirmDeleteItem** (line ~1910)
20. **_deleteItem** (line ~1952)
21. **_confirmDeleteItemLandscape** (line ~2451)
22. **_deleteItemLandscape** (line ~2479)
23. **_showAddItemDialog** (line ~2522)

---

## 📝 TODO: Keep in main item_browser_page.dart

### State Management:
- All class fields (_allItems, _filteredItems, etc.)
- initState, dispose
- _loadItems
- _applyFilters
- _clearFilters
- _toggleFavourite
- _toggleImportant
- _pronounce
- build method (but call mixin methods)

### Getters for Mixins:
```dart
// Implement these getters for mixins to access state
@override
LanguagePackage get package => widget.package;

@override
List<Item> get allItems => _allItems;
set allItems(List<Item> items) => _allItems = items;

@override
List<Item> get filteredItems => _filteredItems;

@override
Item? get selectedItem => _selectedItem;
set selectedItem(Item? item) => _selectedItem = item;

@override
TtsService get ttsService => _ttsService;

@override
ItemRepository get itemRepo => _itemRepo;

@override
CategoryRepository get categoryRepo => _categoryRepo;

@override
void setStateCallback(VoidCallback fn) => setState(fn);

@override
void applyFiltersCallback({
  required bool clearSelectionIfFiltered,
  required bool autoSelectFirst,
}) => _applyFilters(
  clearSelectionIfFiltered: clearSelectionIfFiltered,
  autoSelectFirst: autoSelectFirst,
);
```

---

## 🚀 Refactoring Steps (IDE Method)

### Step 1: Create Widgets Mixin File

```dart
// item_browser_widgets_mixin.dart
import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/tts_service.dart';
import '../../../data/models/item.dart';
import '../../../data/models/language_package.dart';
import '../../../l10n/app_localizations.dart';
import 'item_edit_page.dart';

mixin ItemBrowserWidgetsMixin {
  // Required from parent
  BuildContext get context;
  LanguagePackage get package;
  List<Item> get allItems;
  List<Item> get filteredItems;
  Item? get selectedItem;
  set selectedItem(Item? item);
  TtsService get ttsService;
  bool get isCompactView;
  bool get isFilterPanelExpanded;
  set isFilterPanelExpanded(bool value);
  TextEditingController get language1Controller;
  TextEditingController get language2Controller;
  bool get caseSensitive;
  bool get onlyImportant;
  String get knownStatus;
  List<String> get selectedCategoryIds;
  
  // Callbacks
  void setStateCallback(VoidCallback fn);
  void onClearFilters();
  void onToggleFavourite(Item item);
  void onToggleImportant(Item item);
  void onDeleteItem(Item item);
  void onEditItem(Item item);
  void onShowAddItemDialog();
  void onApplyFilters({bool autoSelectFirst});
  
  // Paste all widget methods here (remove _ prefix, make public)
  Widget buildFilterPanel(AppLocalizations l10n, ThemeData theme) {
    // ...paste _buildFilterPanel body
  }
  
  // ... continue with all other methods
}
```

### Step 2: Update Main File

1. Add mixin to class declaration:
```dart
class _ItemBrowserPageState extends ConsumerState<ItemBrowserPage>
    with ItemBrowserWidgetsMixin, ItemBrowserDialogsMixin {
```

2. Add import:
```dart
import 'item_browser_widgets_mixin.dart';
```

3. Implement required getters (see list above)

4. Change method calls:
   - `_buildFilterPanel(...)` → `buildFilterPanel(...)`
   - `_buildItemCard(...)` → `buildItemCard(...)`
   - etc.

5. Delete the moved methods from main file

### Step 3: Format and Test

```bash
dart format lib/presentation/pages/items/
flutter analyze lib/presentation/pages/items/
```

---

## ⚡ Quick IDE Refactoring (Recommended)

### Using VS Code / Android Studio:

1. **Select method** (e.g., _buildFilterPanel entire method)
2. **Cut** (Ctrl+X)
3. **Open** item_browser_widgets_mixin.dart
4. **Paste** inside mixin
5. **Rename** _buildFilterPanel → buildFilterPanel (remove _)
6. **Repeat** for all 23 methods
7. **Format** all files
8. **Fix** any compilation errors

This is **much faster** than manual rewriting!

---

## 🔍 Method Categories

### Pure UI Widgets (no state changes):
- buildFilterPanel ✅
- buildItemList ✅
- buildItemCard ✅
- buildItemDetails ✅
- buildItemDetailsCompact ✅
- buildLanguageSection ✅
- buildLanguageSectionCompact ✅
- buildCompactChip ✅
- buildLanguageText ✅

### Dialog/Modal Widgets:
- showItemDetailsDialog ✅
- buildItemDetailsForDialog ✅
- showEditItemDialog ✅
- confirmDeleteItem ✅

### Action Methods (use callbacks):
- deleteItem → calls onDeleteItem callback
- etc.

---

## ✅ Verification Checklist

After refactoring:

- [ ] No compilation errors
- [ ] All imports present
- [ ] Mixin getters implemented
- [ ] Method calls updated (no _ prefix)
- [ ] Files formatted
- [ ] App runs successfully
- [ ] Filter panel works
- [ ] Item selection works
- [ ] Delete/Edit works
- [ ] Category management works

---

## 📦 Final File Structure

```
items/
├── item_browser_page.dart              (~600 lines)  ← State management
├── item_browser_widgets_mixin.dart     (~1400 lines) ← UI widgets
├── item_browser_dialogs.dart          (~700 lines)  ← Category dialogs ✅
└── item_edit_page.dart                              ← Existing
```

---

*This guide provides the exact roadmap for refactoring. Use IDE cut/paste for fastest results!*

