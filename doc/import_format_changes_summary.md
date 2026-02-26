# Import Format Changes - Summary

## Changes Made

### 1. New Import Format Structure
The import format has been completely redesigned to support:
- Pre-text and post-text for both languages (L1pre, L1post, L2pre, L2post)
- Multiple examples per item (EX=L1:::L2)
- Multiple categories per item (CAT=cat1:::cat2:::cat3)
- More flexible field ordering

**Main delimiter**: `---` (triple dash)
**Sub-delimiter**: `:::` (triple colon) for examples and categories

### 2. Modified Files

#### `/lib/presentation/pages/packages/package_form_page.dart`
- **Added import**: `example_sentence.dart` model
- **Modified `_importItems()` method**: 
  - Added progress tracking with ValueNotifier
  - Added progress dialog display
  - Better error handling with dialog cleanup
  
- **Completely rewrote `_processImportLines()` method**:
  - Accepts optional progress callback parameter
  - Parses new format with field prefixes (L1=, L2=, L1pre=, etc.)
  - Validates that at least L1 or L2 is present
  - Detects unknown field prefixes and reports errors
  - Converts example maps to ExampleSentence objects
  - Reports progress on each line processed
  - Better error messages with line numbers
  
- **Updated `_showImportFormatDialog()` method**:
  - Shows new format documentation
  - Displays example with all fields
  - Lists all available field types
  
- **Added new classes**:
  - `_ImportProgress`: Holds current/total progress state
  - `_ImportProgressDialog`: Widget to display import progress

#### `/lib/l10n/app_en.arb`
Added localization strings:
- `importProgress`: "Importing: {current} / {total}"
- `importFormatNewDescription`: Format description
- `importFormatNewLine1` through `importFormatNewLine12`: Format notes
- `invalidImportLine`: "Invalid line"
- `missingRequiredFields`: "Missing L1 or L2"
- `unknownField`: "Unknown field prefix"

#### `/lib/l10n/app_hu.arb`
Added Hungarian translations for all new strings above.

### 3. Documentation Files Created

#### `/doc/import_format_specification.md`
Complete documentation of the new import format including:
- Field specifications table
- Examples for different scenarios
- Import behavior description
- Error handling details

#### `/sample_import.txt`
Sample import file demonstrating:
- Simple items
- Items with pre/post text
- Items with examples
- Items with multiple categories
- Complex items with all fields

## Key Features

### 1. Progress Tracking
- Shows a dialog during import with a progress bar
- Updates in real-time: "Importing: X / Y"
- Non-dismissible to prevent interruption

### 2. Comprehensive Validation
- Checks for required fields (L1 or L2)
- Detects unknown field prefixes
- Reports line numbers in error messages
- Validates example and category format

### 3. Flexible Format
- Field order doesn't matter
- Optional fields can be omitted entirely
- Empty fields (e.g., `L1pre=---`) are treated as null
- Whitespace is automatically trimmed

### 4. Error Recovery
- Invalid lines are skipped but reported
- Duplicate detection prevents re-importing
- Transaction-like behavior (no partial imports on unknown fields)

## Breaking Changes

**Old Format**: `L1|L2|cat1;cat2;cat3`
**New Format**: `L1=text---L2=text---CAT=cat1:::cat2:::cat3`

The old format is **no longer supported**. Users must update their import files to use the new format.

## Migration Guide

### Old Format Example
```
Hello|Szia|Greetings
Thank you|Köszönöm|Courtesy
```

### New Format Equivalent
```
L1=Hello---L2=Szia---CAT=Greetings
L1=Thank you---L2=Köszönöm---CAT=Courtesy
```

### With Additional Features
```
L1=Hello---L2=Szia---EX=Hello everyone:::Szia mindenkinek---CAT=Greetings
L1pre=a---L1=dog---L2=kutya---CAT=Animals
```

## Testing Recommendations

1. **Test with sample_import.txt**: 
   - Open the package form page
   - Click "Import Items"
   - Select the sample_import.txt file
   - Verify progress dialog appears
   - Check import results

2. **Test error cases**:
   - Missing both L1 and L2
   - Unknown field prefix
   - Malformed examples (wrong delimiter)
   - Duplicate items

3. **Test edge cases**:
   - Empty pre/post fields
   - Very long text
   - Special characters
   - No categories specified

## Future Enhancements

Potential improvements:
1. Support for old format with auto-detection
2. CSV/TSV format support
3. Batch import from multiple files
4. Import templates/presets
5. Undo import functionality

