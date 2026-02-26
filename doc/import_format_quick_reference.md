# Quick Reference: New Import Format

## Basic Syntax
```
L1=<text>---L2=<text>---CAT=<category>
```

## All Available Fields
```
L1pre=<prefix>---L1=<main text>---L1post=<suffix>---
L2pre=<prefix>---L2=<main text>---L2post=<suffix>---
EX=<L1 example>:::<L2 example>---
EX=<L1 example2>:::<L2 example2>---
CAT=<category1>:::<category2>:::<category3>
```

## Field Reference

| Field | Required | Description | Example |
|-------|----------|-------------|---------|
| L1= | Yes* | Language 1 text | L1=Hello |
| L2= | Yes* | Language 2 text | L2=Szia |
| L1pre= | No | Language 1 prefix | L1pre=the |
| L1post= | No | Language 1 suffix | L1post=! |
| L2pre= | No | Language 2 prefix | L2pre=egy |
| L2post= | No | Language 2 suffix | L2post=! |
| EX= | No | Example (repeatable) | EX=Hi there:::Szia |
| CAT= | No | Categories (once) | CAT=Greetings:::Basic |

*At least L1 or L2 required

## Delimiters
- **Between fields**: `---` (triple dash)
- **Within examples**: `:::` (triple colon)
- **Within categories**: `:::` (triple colon)

## Examples

### Minimal
```
L1=Hello---L2=Szia
```

### With Category
```
L1=Hello---L2=Szia---CAT=Greetings
```

### With Prefix
```
L1pre=the---L1=dog---L2=kutya---CAT=Animals
```

### With Example
```
L1=Thank you---L2=Köszönöm---EX=Thank you very much:::Köszönöm szépen---CAT=Courtesy
```

### With Multiple Examples
```
L1=Hello---L2=Szia---EX=Hello everyone:::Szia mindenkinek---EX=Hello there:::Szia ott---CAT=Greetings
```

### With Multiple Categories
```
L1=dog---L2=kutya---CAT=Animals:::Pets:::Common Words
```

### Complete Example
```
L1pre=the---L1=Be on a lookout---L1post=!---L2pre=---L2=Legyen résen---L2post=!---EX=Be careful:::Legyen óvatos---CAT=Security:::Warnings
```

## Tips
- Empty lines are ignored
- Order of fields doesn't matter
- Whitespace is trimmed automatically
- If no category specified, items go to "Imported" category
- Duplicates are automatically skipped
- Progress is shown during import

## Common Mistakes

❌ Wrong delimiter:
```
L1=Hello|L2=Szia  // Wrong! Use ---
```

✅ Correct:
```
L1=Hello---L2=Szia
```

❌ Wrong example separator:
```
EX=Hello|Szia  // Wrong! Use :::
```

✅ Correct:
```
EX=Hello:::Szia
```

❌ Missing both L1 and L2:
```
L1pre=the---L1post=!---CAT=Test  // Error!
```

✅ At least one required:
```
L1=Hello---CAT=Test  // OK
L2=Szia---CAT=Test   // OK
```

