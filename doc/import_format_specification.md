# Import Format Documentation

## Overview
The new import format allows you to import language items with full support for:
- Pre-text and post-text for both languages
- Multiple examples
- Multiple categories per item

## Format Specification

### Main Delimiter
Fields are separated by `---` (triple dash)

### Field Prefixes

| Prefix | Description | Required | Example |
|--------|-------------|----------|---------|
| `L1=` | Language 1 main text | Yes* | `L1=Hello` |
| `L2=` | Language 2 main text | Yes* | `L2=Szia` |
| `L1pre=` | Language 1 prefix | No | `L1pre=the` |
| `L1post=` | Language 1 suffix | No | `L1post=!` |
| `L2pre=` | Language 2 prefix | No | `L2pre=egy` |
| `L2post=` | Language 2 suffix | No | `L2post=!` |
| `EX=` | Example sentence | No | `EX=Hello world:::Szia világ` |
| `CAT=` | Categories | No | `CAT=Greetings:::Basic` |

\* At least one of L1 or L2 must be present

### Sub-delimiters

- **Examples**: Use `:::` to separate L1 and L2 text
  - Format: `EX=<L1 text>:::<L2 text>`
  - Can have multiple `EX=` fields per line
  
- **Categories**: Use `:::` to separate multiple categories
  - Format: `CAT=<cat1>:::<cat2>:::<cat3>`
  - Only one `CAT=` field per line

## Examples

### Simple Item
```
L1=Hello---L2=Szia---CAT=Greetings
```

### Item with Pre/Post Text
```
L1pre=the---L1=dog---L2=kutya---CAT=Animals
```

### Item with Examples
```
L1=Thank you---L2=Köszönöm---EX=Thank you very much:::Nagyon szépen köszönöm---CAT=Courtesy
```

### Complex Item with Everything
```
L1pre=the---L1=Be on a lookout for sensitive data---L1post=---L2pre=---L2=Legyen résen az érzékeny adatokkal kapcsolatban---L2post=---EX=Be careful when sharing files:::Legyen óvatos fájlmegosztáskor---EX=Always check before upload:::Mindig ellenőrizze feltöltés előtt---CAT=Security:::Awareness:::Data Protection
```

## Import Behavior

1. **Progress Tracking**: A progress dialog shows the current line being processed
2. **Validation**: Each line is validated for required fields and proper format
3. **Unknown Fields**: Lines with unknown field prefixes will be rejected
4. **Duplicates**: Duplicate items (same L1 and L2 text) are skipped
5. **Categories**: If no category is specified, items are added to an "Imported" category
6. **Error Handling**: Invalid lines are reported in the import results dialog

## Import Results

After import completes, you'll see:
- Number of successfully imported items
- Number of failed items
- Details about the first 10 items in each category
- Error messages for failed items

## Notes

- Empty lines are ignored
- Leading and trailing whitespace is trimmed
- Field order doesn't matter (except within examples and categories)
- Empty fields (e.g., `L1pre=---`) are treated as null/omitted

