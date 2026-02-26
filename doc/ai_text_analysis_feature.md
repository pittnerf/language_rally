# AI Text Analysis Import Feature - Documentation

## Overview

The AI Text Analysis Import feature allows users to analyze any text in their target language and automatically extract important words and expressions, translate them, and import them as training items into their language package. This feature uses OpenAI for analysis and DeepL (with OpenAI fallback) for translation.

## Features

### 1. **Smart Text Analysis**
- Detects language automatically
- Extracts words and/or expressions based on CEFR knowledge level (A1-C2)
- Identifies important vocabulary appropriate for the selected proficiency level
- Handles articles and prepositions (e.g., German "der/die/das", plural forms)

### 2. **Flexible Configuration**
- **Knowledge Level**: A1 (Beginner) through C2 (Proficient)
- **Extract Words**: Individual vocabulary items
- **Extract Expressions**: Phrases and idiomatic expressions
- **Max Items**: Limit the number of items to extract (or unlimited)
- **Generate Examples**: Automatically create example sentences
- **Custom Category**: Assign imported items to a specific category

### 3. **Intelligent Translation**
- Uses DeepL API for high-quality translation (if available)
- Falls back to OpenAI if DeepL fails or is not configured
- Translates main text, prefixes, and postfixes
- Generates bilingual example sentences

### 4. **Duplicate Detection**
- Automatically checks for existing items in the package
- Marks duplicates and prevents re-importing
- Allows user to select/deselect items before import

### 5. **Progress Tracking**
- Real-time progress indication during analysis
- Progress bar during import
- Status messages for each step

## How to Use

### Prerequisites

1. **OpenAI API Key Required**: This feature requires an active OpenAI API key
   - Configure in Settings → OpenAI API Key
   - If not configured, the feature will show an error and return to the previous page

2. **DeepL API Key Optional**: For better translation quality
   - Configure in Settings → DeepL API Key
   - Falls back to OpenAI if not available

### Step 1: Open AI Text Analysis

From a language package:
1. Open package in edit mode (Package Form Page)
2. Click **"AI Text Analysis"** button (purple button with psychology icon)

### Step 2: Configure Analysis

1. **Select Knowledge Level**: Choose appropriate CEFR level (A1-C2)
   - A1: Beginner - Basic words and phrases
   - A2: Elementary - Common everyday expressions
   - B1: Intermediate - Standard language on familiar topics
   - B2: Upper Intermediate - Complex text on concrete/abstract topics
   - C1: Advanced - Wide range of demanding texts
   - C2: Proficient - Virtually everything with ease

2. **Paste Text**: Copy and paste the text you want to analyze
   - Use the paste icon button for quick clipboard paste
   - Can be any length (longer texts provide more vocabulary)

3. **Select Extraction Options**:
   - ☑️ **Extract Words**: Individual vocabulary items
   - ☑️ **Extract Expressions**: Phrases, idioms, collocations
   - You can select both or just one

4. **Set Maximum Items** (optional):
   - Leave empty for no limit
   - Enter a number to limit extraction (e.g., 20, 50, 100)

5. **Generate Examples** (optional):
   - ☑️ Check to automatically create 3 example sentences for each item
   - Examples are contextual and translated to both languages

6. **Category Name**:
   - Default: "AI Imported"
   - Change to organize items into specific categories

7. Click **"Analyze Text"** button

### Step 3: Language Detection

The system automatically:
1. Detects the language of the text
2. Verifies it matches one of the package languages (Language 1 or Language 2)
3. Shows error if language doesn't match
4. Determines source and target languages for translation

### Step 4: Item Extraction

The AI analyzes the text and:
1. Identifies vocabulary appropriate for the selected level
2. Extracts words and/or expressions as requested
3. For languages with articles (German, French, etc.):
   - Includes articles as `preItem` (der, die, das, le, la, etc.)
   - Includes plural forms or additional info as `postItem`
4. Applies max items limit if specified

### Step 5: Review and Select Items

A list of extracted items is displayed with:
- **Main text**: The word or expression
- **Type badge**: "word" or "expression"
- **Duplicate badge**: Red badge if item already exists
- **Checkbox**: Select/deselect items for import

Actions:
- **Select All**: Check all non-duplicate items
- **Deselect All**: Uncheck all items
- **Manual Selection**: Check/uncheck individual items

Duplicates are:
- Automatically detected by comparing with existing package items
- Marked with red "Duplicate" badge
- Disabled (cannot be selected for import)

### Step 6: Import Selected Items

1. Review selected items
2. Click **"Import Selected (X)"** button
3. Progress bar shows import status

During import, for each item:
1. **Translate** using DeepL (or OpenAI if DeepL fails)
2. **Generate Examples** (if option was checked)
   - Creates 3 contextual example sentences
   - Translates examples to both languages
3. **Create Category** (if it doesn't exist)
4. **Save Item** to database

### Step 7: Complete

- Success message is displayed
- Returns to Package Form Page
- Items are now available for training

## Technical Details

### Language Detection

- Uses OpenAI GPT-3.5-turbo to detect language
- Returns ISO 639-1 language code (2 letters)
- Compares with package language codes
- Error if detected language doesn't match package languages

### Item Extraction

Prompt includes:
- Target knowledge level (CEFR)
- Source language
- Whether to extract words, expressions, or both
- Maximum items limit (if specified)

AI returns structured JSON:
```json
[
  {
    "text": "main word or expression",
    "type": "word" or "expression",
    "preItem": "article/preposition if applicable",
    "postItem": "plural form or additional info"
  }
]
```

### Translation Strategy

1. **Primary: DeepL API**
   - High-quality neural translation
   - Supports 31 languages
   - Fast and accurate
   - Requires API key

2. **Fallback: OpenAI**
   - Used if DeepL fails or is not configured
   - GPT-3.5-turbo translation
   - Supports virtually all languages
   - Contextual translation

### Example Generation

When enabled, for each item:
1. Generates 3 practical example sentences
2. Examples show different contexts and usage patterns
3. Sentences are short (max 12-15 words)
4. Translated to both languages
5. Stored as ExampleSentence objects

### Data Storage

Each imported item contains:
- **Language 1 Data**: text, preItem, postItem, languageCode
- **Language 2 Data**: translated text, preItem, postItem, languageCode
- **Examples**: Array of ExampleSentence (language1, language2)
- **Category IDs**: Associated categories
- **Training Metadata**: isKnown=false, dontKnowCounter=0, etc.

## File Structure

```
lib/
├── core/services/
│   ├── text_analysis_service.dart    # OpenAI text analysis
│   └── deepl_service.dart             # DeepL translation
├── data/models/
│   └── extracted_item.dart            # Model for extracted items
└── presentation/pages/ai_import/
    ├── ai_text_analysis_page.dart     # Step 1: Configuration
    └── ai_items_selection_page.dart   # Step 2: Selection & Import
```

## API Requirements

### OpenAI API
- **Required**: Yes
- **Model**: GPT-3.5-turbo
- **Usage**:
  - Language detection: ~10 tokens
  - Text analysis: ~500-2000 tokens
  - Translation: ~100-200 tokens per item
  - Example generation: ~300-500 tokens per item
- **Cost**: ~$0.002 per 1000 tokens (as of 2024)

### DeepL API
- **Required**: No (optional)
- **Type**: Free or Pro tier
- **Usage**:
  - Translation: Characters based on plan
- **Cost**: Free tier: 500,000 characters/month

## Error Handling

### Common Errors

1. **"OpenAI API key is required"**
   - Solution: Configure OpenAI API key in Settings

2. **"Language not matching"**
   - Detected language doesn't match package languages
   - Solution: Ensure text is in Language 1 or Language 2 of the package

3. **"Text cannot be empty"**
   - Solution: Paste text into the text box

4. **"Select at least one type"**
   - Solution: Check "Extract Words" and/or "Extract Expressions"

5. **"No items found"**
   - Text might be too short
   - Knowledge level might be too high/low
   - Solution: Try different text or adjust knowledge level

### API Errors

- **401 Unauthorized**: Invalid API key
- **429 Rate Limit**: Too many requests, wait and retry
- **500 Server Error**: API temporarily unavailable, retry later

## Best Practices

### For Best Results

1. **Text Selection**:
   - Use authentic texts (articles, stories, dialogues)
   - Length: 200-1000 words is optimal
   - Avoid very technical or specialized texts
   - Match text complexity to knowledge level

2. **Knowledge Level**:
   - Be realistic about your level
   - Start one level below to build confidence
   - Move up as vocabulary grows

3. **Extraction Options**:
   - Beginners: Words + Expressions + Examples
   - Intermediate: Focus on expressions
   - Advanced: Expressions + technical vocabulary

4. **Max Items**:
   - New learners: Limit to 20-30 items per session
   - Advanced: Can handle 50-100 items
   - Don't overwhelm yourself

5. **Categories**:
   - Use descriptive names (e.g., "News Article - Environment")
   - Group related content together
   - Makes training more organized

## Limitations

1. **Language Support**: Limited to languages supported by package
2. **API Dependency**: Requires internet connection and valid API keys
3. **Cost**: OpenAI API calls have associated costs
4. **Context**: AI may occasionally misidentify importance of vocabulary
5. **Quality**: Translation quality depends on language pair and API

## Privacy & Security

- Text is sent to OpenAI/DeepL servers for processing
- No data is stored permanently by third parties
- API keys are stored locally on device
- Use appropriate texts (avoid sensitive information)

## Troubleshooting

### Import Takes Too Long
- Reduce max items limit
- Disable example generation
- Check internet connection

### Poor Quality Extractions
- Adjust knowledge level
- Try different text sources
- Ensure text is in correct language

### Translation Errors
- Check DeepL API key validity
- OpenAI fallback should work
- Verify language codes in package

## Future Enhancements

Potential improvements:
- Batch processing multiple texts
- Custom extraction rules
- Image text extraction (OCR)
- Audio transcription + analysis
- Progress saving/resume
- Custom AI prompts
- Quality scoring for items
- Spaced repetition pre-filtering

