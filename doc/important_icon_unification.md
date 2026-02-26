# Important Icon Unification

## Date: 2026-02-25

## Problem
The application was using inconsistent icons to indicate when an item is marked as "important" (`item.isImportant`):
- **training_rally_page.dart**: Used `Icons.star` 
- **item_browser_page.dart**: Used `Icons.label_important`
- **item_edit_page.dart**: Used `Icons.label_important` (filled) and `Icons.label_important_outline` (outline)

This inconsistency created confusion for users as they saw different visual representations of the same concept across different parts of the application.

## Solution
Unified the "important" indicator icon across the entire application by replacing all variations with:
- **Filled state**: `Icons.bookmark` (when item IS important)
- **Outline state**: `Icons.bookmark_border` (when item is NOT important, used in toggleable UI elements)

## Rationale
The bookmark icon was chosen because:
1. **Universal recognition**: Bookmarks are universally understood as a way to mark important or saved items
2. **Visual clarity**: The bookmark icon is distinctive and easily recognizable
3. **Semantic meaning**: It clearly conveys the concept of "marking something to remember"
4. **Better than alternatives**:
   - `Icons.star` - Already used for favorites (`item.isFavourite`)
   - `Icons.label_important` - Less intuitive and visually similar to other label/tag icons
   - `Icons.priority_high` - Too aggressive, implies urgency rather than importance

## Color Consistency
All important icons now consistently use `theme.colorScheme.secondary` for better visual consistency.

## Files Modified

### 1. training_rally_page.dart
**Line ~708**
- **Before**: `Icons.star` with `theme.colorScheme.primary`
- **After**: `Icons.bookmark` with `theme.colorScheme.secondary`

### 2. item_browser_page.dart (4 locations)

**Compact view (~769)**
- **Before**: `Icons.label_important`
- **After**: `Icons.bookmark`

**Expanded view with chip (~911)**
- **Before**: `Icons.label_important`
- **After**: `Icons.bookmark`

**Landscape expanded view (~1181)**
- **Before**: `Icons.label_important`
- **After**: `Icons.bookmark`

**Landscape compact view (~1380)**
- **Before**: `Icons.label_important`
- **After**: `Icons.bookmark`

### 3. item_edit_page.dart
**Line ~911**
- **Before**: `Icons.label_important` (selected) / `Icons.label_important_outline` (unselected)
- **After**: `Icons.bookmark` (selected) / `Icons.bookmark_border` (unselected)

## User Experience Impact
- ✅ Consistent visual language across all screens
- ✅ Clearer distinction between "important" (bookmark) and "favourite" (star)
- ✅ More intuitive icon that users immediately understand
- ✅ Better visual hierarchy with appropriate color (secondary)

## Testing Recommendations
1. Verify bookmark icon displays correctly in all views:
   - Training rally page status indicators
   - Item browser compact view
   - Item browser expanded view (both portrait and landscape)
   - Item edit page filter chip
2. Confirm the icon color is consistent (secondary color scheme)
3. Test the toggle behavior in item_edit_page (bookmark ↔ bookmark_border)
4. Verify no visual conflicts with the favourite star icon

## Related Icons in Application
- **Favourite**: `Icons.star` (filled) / `Icons.star_border` (outline) - Uses `tertiary` color
- **Important**: `Icons.bookmark` (filled) / `Icons.bookmark_border` (outline) - Uses `secondary` color
- **Known/Unknown status**: Checkmark (green) / Exclamation mark (red) - Indicates training progress

