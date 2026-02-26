# Grammatical Metadata Generation - Implementation

## Date: 2026-02-26

## Overview

Changed the AI import process to **generate** grammatical metadata (preItem and postItem) for the target language instead of translating it from the source language.

## Problem

**Previous Approach (INCORRECT):**
- preItem and postItem were being **translated** from source to target language
- Example: German "das" was translated to English "the" 
- Example: German "pl. Häuser" was translated to English "pl. houses"
- This approach doesn't work because grammatical structures differ between languages

**Why Translation Doesn't Work:**
- Articles differ: German has "der/die/das" (3 genders), English has "the" (no gender)
- Plural forms differ: German "Häuser" (umlaut change), English "houses" (add -s)
- Verb conjugations differ completely between languages
- Some languages have grammatical features others don't (e.g., cases, aspects)

## Solution

**New Approach (CORRECT):**
- Use OpenAI to **generate** appropriate grammatical metadata for each language independently
- Ask the AI model: "For the English word 'house', what is the article and plural form?"
- Ask the AI model: "For the German verb 'machen', what are the conjugation forms?"

## Implementation

### 1. New Service Method: `generateGrammaticalMetadata()`

**File:** `lib/core/services/text_analysis_service.dart`

**Purpose:** Generate language-specific grammatical metadata (preItem and postItem) for a word

**Parameters:**
- `text`: The word or expression
- `language`: The target language (e.g., "English", "German")
- `wordType`: Either "word" or "expression"

**Returns:**
```dart
Map<String, String?> {
  'preItem': String?,   // article or infinitive marker
  'postItem': String?,  // plural form or conjugations
}
```

**How it works:**

```dart
Future<Map<String, String?>> generateGrammaticalMetadata({
  required String text,
  required String language,
  required String wordType,
}) async {
  // Creates a specialized prompt for OpenAI
  // For nouns: asks for article + plural
  // For verbs: asks for conjugations
  // For expressions: returns null for both
  
  // Returns structured JSON response
}
```

**Example Prompts:**

For English noun "house":
```
For the following word in English, provide grammatical metadata.

Word: "house"
Language: English

If this is a NOUN:
- preItem: the appropriate article (e.g., "the" for English)
- postItem: the plural form (e.g., "pl. houses")

Return ONLY a JSON object:
{"preItem": "the", "postItem": "pl. houses"}
```

For German verb "machen":
```
For the following word in German, provide grammatical metadata.

Word: "machen"
Language: German

If this is a VERB:
- preItem: leave empty or use infinitive marker if applicable
- postItem: past tense or key conjugation forms (e.g., "machte, h. gemacht")

Return ONLY a JSON object:
{"preItem": null, "postItem": "machte, h. gemacht"}
```

### 2. Updated Import Process

**File:** `lib/presentation/pages/ai_import/ai_items_selection_page.dart`

**Changes:**

**BEFORE (Translation approach):**
```dart
// Translate preItem
String? translatedPreItem;
if (extractedItem.preItem != null) {
  translatedPreItem = await deeplService.translate(
    text: extractedItem.preItem!,
    targetLang: targetLangCode,
  );
  // Fallback to OpenAI if DeepL fails...
}

// Translate postItem
String? translatedPostItem;
if (extractedItem.postItem != null) {
  translatedPostItem = await deeplService.translate(
    text: extractedItem.postItem!,
    targetLang: targetLangCode,
  );
  // Fallback to OpenAI if DeepL fails...
}
```

**AFTER (Generation approach):**
```dart
// Generate grammatical metadata for target language
String? targetPreItem;
String? targetPostItem;

try {
  final metadata = await analysisService.generateGrammaticalMetadata(
    text: translatedText,  // Use the translated word
    language: widget.targetLanguage,
    wordType: extractedItem.type,
  );
  
  targetPreItem = metadata['preItem'];
  targetPostItem = metadata['postItem'];
} catch (e) {
  // If generation fails, continue without metadata
  targetPreItem = null;
  targetPostItem = null;
}
```

**Key Differences:**
1. Only **one API call** instead of two (for preItem and postItem separately)
2. Uses the **translated text** as input (not the source preItem/postItem)
3. Returns **language-appropriate** metadata, not a translation

## Examples

### Example 1: German → English (Noun)

**Input (from AI extraction):**
```json
{
  "text": "Haus",
  "type": "word",
  "preItem": "das",
  "postItem": "pl. Häuser"
}
```

**Process:**
1. Translate "Haus" → "house" (via DeepL/OpenAI)
2. Generate metadata for "house" in English:
   ```dart
   generateGrammaticalMetadata(
     text: "house",
     language: "English",
     wordType: "word"
   )
   → {"preItem": "the", "postItem": "pl. houses"}
   ```

**Result:**
```dart
Item(
  language1Data: ItemLanguageData(
    text: "Haus",
    preItem: "das",           // From AI extraction
    postItem: "pl. Häuser",   // From AI extraction
  ),
  language2Data: ItemLanguageData(
    text: "house",
    preItem: "the",           // ✅ Generated for English
    postItem: "pl. houses",   // ✅ Generated for English
  ),
)
```

### Example 2: English → German (Verb)

**Input (from AI extraction):**
```json
{
  "text": "make",
  "type": "word",
  "preItem": null,
  "postItem": "made, made"
}
```

**Process:**
1. Translate "make" → "machen" (via DeepL/OpenAI)
2. Generate metadata for "machen" in German:
   ```dart
   generateGrammaticalMetadata(
     text: "machen",
     language: "German",
     wordType: "word"
   )
   → {"preItem": null, "postItem": "machte, h. gemacht"}
   ```

**Result:**
```dart
Item(
  language1Data: ItemLanguageData(
    text: "make",
    preItem: null,              // From AI extraction
    postItem: "made, made",     // From AI extraction
  ),
  language2Data: ItemLanguageData(
    text: "machen",
    preItem: null,              // ✅ Generated for German
    postItem: "machte, h. gemacht",  // ✅ Generated for German
  ),
)
```

### Example 3: German → English (Expression)

**Input (from AI extraction):**
```json
{
  "text": "in Betracht ziehen",
  "type": "expression",
  "preItem": null,
  "postItem": null
}
```

**Process:**
1. Translate "in Betracht ziehen" → "take into account"
2. Generate metadata for "take into account" in English:
   ```dart
   generateGrammaticalMetadata(
     text: "take into account",
     language: "English",
     wordType: "expression"
   )
   → {"preItem": null, "postItem": null}  // Expressions don't have metadata
   ```

**Result:**
```dart
Item(
  language1Data: ItemLanguageData(
    text: "in Betracht ziehen",
    preItem: null,
    postItem: null,
  ),
  language2Data: ItemLanguageData(
    text: "take into account",
    preItem: null,   // ✅ Expressions don't need metadata
    postItem: null,  // ✅ Expressions don't need metadata
  ),
)
```

## Console Output

When importing, you'll now see:

```
📦 Processing Item 1/5
───────────────────────────────────────────────────────────
  Text: "Haus"
  Type: word
  PreItem: "das"
  PostItem: "pl. Häuser"

🔤 Translating Main Text...
🌐 DeepL Translation Request:
  Text: "Haus"
  📥 DeepL Response: "house"
  ✅ Translation successful

📚 Generating Grammatical Metadata for Target Language...
  Text: "house"
  Language: English
  Type: word
  📤 Sending request to OpenAI...
  📥 OpenAI Response: "{"preItem": "the", "postItem": "pl. houses"}"
  ✅ Generated metadata:
    preItem: "the"
    postItem: "pl. houses"

💾 Creating Item...
  Language1 Data:
    Text: "Haus"
    PreItem: "das"
    PostItem: "pl. Häuser"
  Language2 Data:
    Text: "house"
    PreItem: "the"           ← Generated!
    PostItem: "pl. houses"   ← Generated!
  ✅ Item saved to database
```

## Benefits

### 1. **Linguistically Correct**
- Each language gets its own appropriate grammatical metadata
- Respects language-specific rules and conventions
- No awkward "translations" of grammatical markers

### 2. **More Accurate**
- German nouns get correct articles (der/die/das) based on gender
- English verbs get correct irregular forms (go → went, gone)
- Language-specific features are preserved

### 3. **Efficient**
- Single API call for both preItem and postItem
- Reduces API usage compared to translating each separately
- Faster import process

### 4. **Flexible**
- Works for any language pair
- AI model knows language-specific rules
- Can handle edge cases and irregularities

### 5. **Consistent**
- Same approach for all word types (nouns, verbs, adjectives)
- Predictable behavior
- Easy to debug with detailed logging

## Technical Details

### API Call Structure

**OpenAI Request:**
```json
{
  "model": "gpt-4-turbo",
  "messages": [
    {
      "role": "system",
      "content": "You are a helpful language learning assistant..."
    },
    {
      "role": "user",
      "content": "For the following word in English, provide grammatical metadata..."
    }
  ],
  "temperature": 0.3,
  "max_tokens": 150
}
```

**OpenAI Response:**
```json
{
  "choices": [
    {
      "message": {
        "content": "{\"preItem\": \"the\", \"postItem\": \"pl. houses\"}"
      }
    }
  ]
}
```

### Error Handling

If metadata generation fails:
- Logs the error
- Sets both preItem and postItem to null
- Continues with import (doesn't fail the entire process)
- User can manually add metadata later if needed

### Performance

- Average time per item: ~2-3 seconds
  - Translation: ~1 second
  - Metadata generation: ~1 second
  - Example generation (if enabled): ~1 second
- For 10 items: ~20-30 seconds total
- Can be cancelled at any time

## Testing Checklist

✅ **German Nouns:**
- [ ] Import German noun → English gets "the" + "pl. [word]s"
- [ ] Check German article is der/die/das (preserved from source)
- [ ] Check English plural follows English rules

✅ **German Verbs:**
- [ ] Import German verb → English gets past tense forms
- [ ] Check German conjugation (machte, h. gemacht format)
- [ ] Check English irregular verbs handled correctly

✅ **Expressions:**
- [ ] Import expression → both languages have null metadata
- [ ] No attempt to add articles or forms to multi-word phrases

✅ **Reverse Direction:**
- [ ] English → German works correctly
- [ ] German metadata is generated (not translated)

✅ **Error Handling:**
- [ ] If metadata generation fails, import continues
- [ ] Items can be edited later to add metadata manually

✅ **Console Logging:**
- [ ] See metadata generation requests in console
- [ ] See OpenAI prompts and responses
- [ ] Can debug issues easily

## Files Modified

1. **`lib/core/services/text_analysis_service.dart`**
   - Added `generateGrammaticalMetadata()` method
   - ~120 lines of new code
   - Includes detailed prompt engineering
   - Comprehensive error handling and logging

2. **`lib/presentation/pages/ai_import/ai_items_selection_page.dart`**
   - Removed translation of preItem/postItem
   - Added call to `generateGrammaticalMetadata()`
   - Updated Item creation to use generated metadata
   - Simplified from ~80 lines to ~20 lines for this section

## Related Documentation

- See `ai_import_debugging_improvements.md` for overall AI import improvements
- See `import_items_fixes.md` for previous dontKnowCounter fix
- Translation services (DeepL/OpenAI) remain unchanged

