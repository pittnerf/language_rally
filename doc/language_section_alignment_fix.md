# Language Section Row Height and Alignment Fix

## Problem Description

The language section rows (showing language text with speaker icon) had two issues:
1. **Height Problem**: When the text was only one line, the container was still taking up 2 lines of height
2. **Vertical Alignment Problem**: The speaker icon was not vertically centered with the text

## Root Causes

### 1. Height Issue
The `Column` widget containing the text elements didn't have `mainAxisSize: MainAxisSize.min`, causing it to expand to fill available space even when only one line of text was present.

### 2. Alignment Issue
- The `Row` had `crossAxisAlignment: CrossAxisAlignment.start` instead of `center`
- The `IconButton` had default padding (8px on all sides) which added extra height

## Solution Applied

### Files Modified
- `lib/presentation/pages/items/item_browser_page.dart`

### Methods Fixed
1. `_buildLanguageSection` (line ~1610) - Standard view
2. `_buildLanguageSectionCompact` (line ~1884) - Compact view for landscape
3. `_buildLanguageSectionForDialog` (line ~1361) - Dialog view

### Changes Made

#### 1. Changed Row CrossAxisAlignment
```dart
// BEFORE
Row(
  crossAxisAlignment: CrossAxisAlignment.start,  // ❌ Aligns to top
  children: [...]
)

// AFTER
Row(
  crossAxisAlignment: CrossAxisAlignment.center,  // ✅ Centers vertically
  children: [...]
)
```

#### 2. Added MainAxisSize.min to Column
```dart
// BEFORE
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [...]  // ❌ Expands to fill space
)

// AFTER
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  mainAxisSize: MainAxisSize.min,  // ✅ Only takes needed height
  children: [...]
)
```

#### 3. Removed IconButton Padding and Set Constraints
```dart
// BEFORE
IconButton(
  icon: const Icon(Icons.volume_up),
  tooltip: l10n.pronounce,
  onPressed: () {...},  // ❌ Has default padding (8px)
)

// AFTER
IconButton(
  icon: const Icon(Icons.volume_up),
  tooltip: l10n.pronounce,
  padding: EdgeInsets.zero,  // ✅ No extra padding
  constraints: const BoxConstraints(
    minWidth: 40,
    minHeight: 40,  // ✅ Still maintains touchable area
  ),
  onPressed: () {...},
)
```

## Complete Code Structure

```dart
Row(
  crossAxisAlignment: CrossAxisAlignment.center,  // ✅ Vertical centering
  children: [
    Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,  // ✅ Minimal height
        children: [
          if (preItem.isNotEmpty) 
            Text(
              preItem, 
              style: ...copyWith(height: 1.0),  // ✅ Compact height
            ),
          Text(
            text, 
            style: ...copyWith(height: 1.0),  // ✅ Compact height
          ),
          if (postItem.isNotEmpty) 
            Text(
              postItem, 
              style: ...copyWith(height: 1.0),  // ✅ Compact height
            ),
        ],
      ),
    ),
    IconButton(
      icon: const Icon(Icons.volume_up),
      tooltip: l10n.pronounce,
      padding: EdgeInsets.zero,          // ✅ No extra padding
      constraints: const BoxConstraints(  // ✅ Compact size
        minWidth: 40,
        minHeight: 40,
      ),
      onPressed: () {...},
    ),
  ],
)
```

## Results

### Before Fix:
- ❌ Container height: 2 lines even for single-line text
- ❌ Speaker icon: Aligned to top, not centered with text
- ❌ Extra whitespace below text
- ❌ Inconsistent visual appearance

### After Fix:
- ✅ Container height: Exactly matches content (1 line for 1 line of text)
- ✅ Speaker icon: Perfectly centered vertically with the text
- ✅ No extra whitespace
- ✅ Clean, compact appearance
- ✅ Still maintains adequate touch target for icon button (40x40)

## Impact

This fix improves:
1. **Visual Consistency**: UI elements now have proper alignment
2. **Space Efficiency**: No wasted vertical space
3. **User Experience**: Better visual hierarchy and cleaner look
4. **Responsiveness**: Works correctly for both single-line and multi-line text

## Applies To

- Item browser detail view
- Item browser compact view (landscape on phones)
- Both language sections (Language 1 and Language 2)
- All items in the package

## Testing

Test scenarios:
1. ✅ Single-line text (short word/phrase) - should be 1 line height
2. ✅ Multi-line text (long phrase) - should wrap naturally
3. ✅ With preItem (italic prefix)
4. ✅ With postItem (italic suffix)
5. ✅ Speaker icon alignment - should be centered with text
6. ✅ Icon button clickable area - should still be easily tappable
7. ✅ Both portrait and landscape orientations
8. ✅ Standard and compact views

