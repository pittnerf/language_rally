# Translation Service - Cascading Fallback Strategy

## Overview

The translation service has been updated to implement a robust cascading fallback strategy that tries multiple translation services in order of quality and availability.

## Fallback Order

The service now attempts translation in the following order:

1. **DeepL Pro** (`https://api.deepl.com/v2/translate`)
   - Highest quality neural translation
   - Requires DeepL API key
   - If fails, tries DeepL Free

2. **DeepL Free** (`https://api-free.deepl.com/v2/translate`)
   - Same quality as Pro
   - Free tier endpoint
   - Requires DeepL API key
   - 500,000 characters/month limit

3. **OpenAI GPT-3.5-turbo**
   - High quality AI translation
   - Requires OpenAI API key
   - Contextual and natural translations
   - Falls back to Google if fails

4. **Google Translate** (free, always available)
   - Free service, no API key needed
   - Always available as final fallback
   - Decent quality for most language pairs
   - Never fails (unless network issues)

## Key Features

### Intelligent Cascading
- Each service is tried in order
- If a service fails, automatically tries the next
- Collects error messages from all attempts
- Final exception includes all failure reasons

### API Key Management
- DeepL key enables both Pro and Free endpoints
- OpenAI key enables GPT-3.5-turbo translation
- Google Translate always available (no key needed)
- Service gracefully skips unavailable services

### Error Handling
- Distinguishes between different error types:
  - 403: Invalid API key
  - 456: Quota exceeded (DeepL)
  - 429: Rate limit exceeded (OpenAI)
  - Network errors
  - Parsing errors
- Provides detailed error messages
- Rethrows critical errors (invalid keys, quota issues)

## Usage

### Basic Translation

```dart
final translationService = TranslationService(
  deeplApiKey: 'your-deepl-key',  // Optional
  openaiApiKey: 'your-openai-key', // Optional
);

final translated = await translationService.translateText(
  text: 'Hello, world!',
  sourceLang: 'en-US',
  targetLang: 'es-ES',
);
```

### With All Services

```dart
// Will try: DeepL Pro → DeepL Free → OpenAI → Google
final service = TranslationService(
  deeplApiKey: 'your-deepl-key',
  openaiApiKey: 'your-openai-key',
);
```

### OpenAI + Google Only

```dart
// Will try: OpenAI → Google
final service = TranslationService(
  openaiApiKey: 'your-openai-key',
);
```

### Google Only

```dart
// Will use: Google Translate
final service = TranslationService();
```

## Methods

### `translateText()`
Main translation method with cascading fallback.

**Parameters:**
- `text`: Text to translate (required)
- `sourceLang`: Source language code (required)
- `targetLang`: Target language code (required)

**Returns:** Translated text as String

**Throws:** Exception if all services fail

### `isUsingDeepL()`
Returns `true` if DeepL API key is configured.

### `isUsingOpenAI()`
Returns `true` if OpenAI API key is configured.

### `isConfigured()`
Always returns `true` (Google Translate is always available).

### `getServiceName()`
Returns the name of the primary service being used:
- "DeepL (Pro/Free)" if DeepL key present
- "OpenAI + Google Translate" if only OpenAI key present
- "Google Translate" if no keys present

## Language Code Conversion

### DeepL Format
- Converts standard codes to DeepL format
- Examples:
  - `'en-US'` → `'EN'`
  - `'pt-BR'` → `'PT-BR'` (special case)
  - `'de-DE'` → `'DE'`

### Google Format
- Extracts language portion from code
- Examples:
  - `'en-US'` → `'en'`
  - `'zh-CN'` → `'zh-CN'` (special case)
  - `'es-ES'` → `'es'`

### OpenAI Format
- Uses human-readable language names
- Examples:
  - `'en'` → `'English'`
  - `'de'` → `'German'`
  - `'hu'` → `'Hungarian'`

## Error Messages

The service collects error messages from all attempted services:

```
All translation services failed:
DeepL Pro: Invalid API key
DeepL Free: Invalid API key
OpenAI: Rate limit exceeded
Google Translate: Network error
```

## Performance Characteristics

### DeepL
- **Speed**: Very fast (< 1 second)
- **Quality**: Excellent
- **Cost**: Free tier or paid plans
- **Reliability**: High

### OpenAI
- **Speed**: Moderate (1-3 seconds)
- **Quality**: Excellent, contextual
- **Cost**: ~$0.002 per 1000 tokens
- **Reliability**: High

### Google Translate
- **Speed**: Fast (< 1 second)
- **Quality**: Good to very good
- **Cost**: Free
- **Reliability**: Very high

## Best Practices

### For Best Translation Quality
1. Configure DeepL API key for best quality
2. Add OpenAI API key for complex translations
3. Google Translate is reliable fallback

### For Cost Optimization
1. Use DeepL Free tier (500K chars/month)
2. Reserve OpenAI for when DeepL fails
3. Google is always free

### For Maximum Reliability
1. Configure all services
2. Service will automatically fallback
3. Google ensures translation always succeeds

## Troubleshooting

### "All translation services failed"
- Check internet connection
- Verify API keys are valid
- Check API quotas
- Review error messages for specific issues

### DeepL Fails Immediately
- Check API key validity
- Verify you have quota remaining
- Try Free endpoint if Pro fails
- Falls back to OpenAI/Google automatically

### Slow Translations
- OpenAI can take 1-3 seconds
- Consider using DeepL for faster results
- Network latency may affect all services

## Migration from Previous Version

### Old Service (DeepL + Google)
```dart
TranslationService(deeplApiKey: key)
```

### New Service (All Services)
```dart
TranslationService(
  deeplApiKey: deeplKey,
  openaiApiKey: openaiKey,
)
```

**Benefits:**
- More fallback options
- Better reliability
- Higher quality translations (OpenAI)
- Automatic cascading (no code changes needed)

## Dependencies

- `http` package for API calls
- DeepL API (optional)
- OpenAI API (optional)
- Google Translate (always available)

No additional dependencies required!

