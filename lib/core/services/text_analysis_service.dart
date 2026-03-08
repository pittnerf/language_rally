// lib/core/services/text_analysis_service.dart
//
// Text Analysis Service using OpenAI
//

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../data/models/extracted_item.dart';
import '../utils/debug_print.dart';

class TextAnalysisService {
  final String _apiKey;
  final String _model;
  static const String _baseUrl = 'https://api.openai.com/v1/chat/completions';

  TextAnalysisService({
    required String apiKey,
    String model = 'gpt-4-turbo',
  })  : _apiKey = apiKey,
        _model = model;

  /// Detect language of the given text
  Future<String> detectLanguage(String text) async {
    final prompt = '''Detect the language of the following text and respond with ONLY the ISO 639-1 language code (2 letters, lowercase) and nothing else.

Text: "$text"

Response (only the 2-letter code):''';

    try {
      final response = await _makeRequest(prompt, maxTokens: 10);
      return response.trim().toLowerCase();
    } catch (e) {
      throw Exception('Failed to detect language: $e');
    }
  }

  /// Extract words and/or expressions from text based on knowledge level
  Future<List<ExtractedItem>> extractItems({
    required String text,
    required String knowledgeLevel,
    required bool extractWords,
    required bool extractExpressions,
    bool extractFullItems = false,
    required String sourceLanguage,
    int? maxItems,
  }) async {
    if (!extractWords && !extractExpressions && !extractFullItems) {
      throw Exception('At least one extraction type must be selected');
    }

    // Estimate tokens for input text and prompt
    final textWordCount = text.split(RegExp(r'\s+')).length;
    final estimatedInputTokens = _estimateTokens(text);

    // Count sentences in the text for better chunking decision
    final sentenceCount = _countSentences(text);

    // For texts with many sentences, use sentence-based chunking
    // This preserves context better than word-based splitting
    const maxSentencesPerRequest = 20; // More than 20 sentences → use chunking

    if (sentenceCount > maxSentencesPerRequest) {
      logDebug('Text has $sentenceCount sentences (>$maxSentencesPerRequest), using sentence-based chunking');
      return await _extractItemsInChunks(
        text: text,
        knowledgeLevel: knowledgeLevel,
        extractWords: extractWords,
        extractExpressions: extractExpressions,
        extractFullItems: extractFullItems,
        sourceLanguage: sourceLanguage,
        maxItems: maxItems,
      );
    }

    // If text is too large for single request based on tokens, use chunking
    const maxContextTokens = 12000; // GPT safe limit
    const promptOverhead = 2000; // Tokens for our instructions

    if (estimatedInputTokens > maxContextTokens - promptOverhead) {
      logDebug('Text has $estimatedInputTokens estimated tokens (too large), using sentence-based chunking');
      return await _extractItemsInChunks(
        text: text,
        knowledgeLevel: knowledgeLevel,
        extractWords: extractWords,
        extractExpressions: extractExpressions,
        extractFullItems: extractFullItems,
        sourceLanguage: sourceLanguage,
        maxItems: maxItems,
      );
    }

    // If extractFullItems mode is enabled, use a different approach
    // Translate each non-empty line individually
    if (extractFullItems) {
      return await _extractFullItemsLineByLine(
        text: text,
        sourceLanguage: sourceLanguage,
        maxItems: maxItems,
      );
    }

    final types = <String>[];
    if (extractWords) types.add('individual words');
    if (extractExpressions) types.add('expressions/phrases (2-12 words, prefer longer meaningful expressions)');

    // Define what each level should focus on
    final levelGuidance = _getKnowledgeLevelGuidance(knowledgeLevel);

    // Calculate dynamic maxTokens for response based on expected output
    // Each item needs ~60 tokens in JSON format (increased for longer expressions)
    // For long texts, allow more items to be extracted
    // Use more aggressive ratio to extract more comprehensively
    final expectedItems = maxItems ?? (textWordCount ~/ 5).clamp(50, 600);
    // Allow up to 4000 tokens for response but will be clamped to safe limit in _makeRequest
    final dynamicMaxTokens = (expectedItems * 60).clamp(1500, 4000);

    final prompt = '''You are a language learning expert. Analyze the following text in $sourceLanguage and extract ALL important vocabulary ${types.join(' and ')} suitable for CEFR $knowledgeLevel level learners.

⚠️ CRITICAL REQUIREMENTS:
1. EXTRACT COMPREHENSIVELY - aim to extract ALL relevant vocabulary from the text
2. DO NOT stop early - continue until you have extracted every suitable item
3. PRIORITIZE QUALITY - focus on meaningful, useful vocabulary for learners

KNOWLEDGE LEVEL: $knowledgeLevel
You MUST extract ONLY vocabulary that is appropriate for $knowledgeLevel level learners. DO NOT extract advanced vocabulary that is beyond this level.

Text to analyze:
"""
$text
"""

IMPORTANT - Knowledge Level Requirements for $knowledgeLevel:
$levelGuidance

🎯 EXTRACTION REQUIREMENTS - READ CAREFULLY:

COMPREHENSIVENESS (CRITICAL):
- Extract ALL relevant vocabulary that matches $knowledgeLevel level
- DO NOT be conservative - extract generously
- Aim for MAXIMUM coverage of useful vocabulary in the text
- If you're unsure whether to include an item, INCLUDE it

VOCABULARY SELECTION:
- ${extractWords && !extractExpressions ? 'Extract ONLY single words (one word per item)' : ''}${!extractWords && extractExpressions ? 'Extract ONLY expressions/phrases (2-12 words, NO single words)' : ''}${extractWords && extractExpressions ? 'Extract both single words AND multi-word expressions/phrases (2-12 words)' : ''}
- For EXPRESSIONS, prioritize longer, more meaningful phrases (5-12 words preferred)
- Include: phrasal verbs, idioms, collocations, common expressions, verb phrases
- Strictly adhere to $knowledgeLevel vocabulary level

EXPRESSION EXAMPLES (PRIORITIZE THESE TYPES):
✅ GOOD - Longer, meaningful expressions:
  - "have a long-term impact on" (5 words)
  - "play a key role in shaping" (6 words)
  - "be perceived as less worthy" (5 words)
  - "adverse childhood experiences" (3 words)
  - "respond to a child's failures" (5 words)
  - "psychological well-being and quality of life" (6 words)

⚠️ ACCEPTABLE - Shorter but still useful:
  - "such as" (2 words)
  - "may have" (2 words)
  - "in adulthood" (2 words)

FROM YOUR EXAMPLE SENTENCE:
"Adverse childhood experiences, such as criticism, neglect, or harsh responses from caregivers, may have a long-term impact on psychological well-being and quality of life in adulthood."

EXPECTED EXTRACTION (showing comprehensive approach):
Words: adverse, childhood, experiences, criticism, neglect, harsh, responses, caregivers, long-term, impact, psychological, well-being, quality, adulthood
Expressions: "adverse childhood experiences", "such as", "harsh responses from caregivers", "may have a long-term impact on", "have a long-term impact on", "psychological well-being and quality of life", "quality of life", "in adulthood"

FORMATTING RULES:
1. Mark each item with "type": "word" for single words OR "type": "expression" for multi-word phrases
2. For nouns in languages like German: include article (der/die/das) in preItem, plural in postItem
3. For verbs: include past version in postItem (e.g., machte, h. gemacht)
4. For other languages with articles/prepositions: include them in preItem
${maxItems != null ? '5. Limit to maximum $maxItems items (but extract comprehensively up to this limit)\n' : ''}
6. Avoid exact duplicates
7. CRITICAL: Extract as MANY relevant items as possible - use the full available token space
8. Return ONLY a JSON array with this exact format:

[
  {
    "text": "main word or expression",
    "type": "word" OR "expression",
    "preItem": "article/preposition (if applicable, otherwise null)",
    "postItem": "additional info like plural form (if applicable, otherwise null)"
  }
]

Examples for German:
{"text": "Haus", "type": "word", "preItem": "das", "postItem": "pl. Häuser"}
{"text": "sich freuen", "type": "expression", "preItem": null, "postItem": "freute, h.s. gefreut"}
{"text": "auf etwas achten", "type": "expression", "preItem": null, "postItem": null}
{"text": "in Betracht ziehen", "type": "expression", "preItem": null, "postItem": null}
{"text": "einen großen Einfluss haben auf", "type": "expression", "preItem": null, "postItem": null}

Examples for English:
{"text": "cat", "type": "word", "preItem": null, "postItem": "pl: cats"}
{"text": "get along with", "type": "expression", "preItem": null, "postItem": null}
{"text": "take into account", "type": "expression", "preItem": null, "postItem": null}
{"text": "be on the lookout for", "type": "expression", "preItem": null, "postItem": null}
{"text": "as far as I'm concerned", "type": "expression", "preItem": null, "postItem": null}
{"text": "have a long-term impact on", "type": "expression", "preItem": null, "postItem": null}
{"text": "play a crucial role in determining", "type": "expression", "preItem": null, "postItem": null}

⚠️ IMPORTANT: 
- Expressions should be 2-12 words long (longer is better for meaningful phrases)
- PRIORITIZE longer expressions (5-12 words) that capture complete meanings
- Extract idioms, phrasal verbs, verb phrases, and common collocations
- Include both the complete phrase AND useful sub-phrases if applicable

CRITICAL: If extracting only expressions, DO NOT include any single-word items in the result.

Do not include any explanation, only the JSON array.''';

    // DEBUG: Print analysis details to console
    logDebug('═══════════════════════════════════════════════════════════');
    logDebug('AI TEXT ANALYSIS - PROMPT SENT TO OPENAI');
    logDebug('═══════════════════════════════════════════════════════════');
    logDebug('Knowledge Level: $knowledgeLevel');
    logDebug('Extract Words: $extractWords');
    logDebug('Extract Expressions: $extractExpressions');
    logDebug('Max Items: $maxItems');
    logDebug('Dynamic Max Tokens: $dynamicMaxTokens');
    logDebug('Text Word Count: $textWordCount');
    logDebug('───────────────────────────────────────────────────────────');
    logDebug('INPUT TEXT DETAILS:');
    logDebug('  Character count: ${text.length}');
    logDebug('  First 100 chars: ${text.substring(0, text.length > 100 ? 100 : text.length)}');
    logDebug('  Last 100 chars: ${text.length > 100 ? text.substring(text.length - 100) : "[text too short]"}');
    logDebug('───────────────────────────────────────────────────────────');
    logDebug('PROMPT DETAILS:');
    logDebug('  Prompt character count: ${prompt.length}');
    logDebug('  Prompt word count: ${prompt.split(RegExp(r'\s+')).length}');
    logDebug('  Estimated tokens: ${_estimateTokens(prompt)}');
    logDebug('───────────────────────────────────────────────────────────');
    // Note: Not printing full prompt to avoid logcat truncation issues
    // On Android, logcat truncates at ~4000 characters per line
    logDebug('NOTE: Full prompt not displayed due to logcat character limits');
    logDebug('      but the COMPLETE text is being sent to OpenAI API');
    logDebug('═══════════════════════════════════════════════════════════');

    try {
      final response = await _makeRequest(prompt, maxTokens: dynamicMaxTokens);

      // DEBUG: Print the response details
      logDebug('───────────────────────────────────────────────────────────');
      logDebug('OPENAI RESPONSE RECEIVED:');
      logDebug('  Response length: ${response.length} characters');
      logDebug('  Response starts with: ${response.substring(0, response.length > 80 ? 80 : response.length)}...');
      logDebug('  Response ends with: ...${response.length > 80 ? response.substring(response.length - 80) : response}');
      logDebug('───────────────────────────────────────────────────────────');

      // Extract JSON from response
      String jsonContent = response;
      if (response.contains('```json')) {
        final start = response.indexOf('[');
        final end = response.lastIndexOf(']') + 1;
        if (start >= 0 && end > start) {
          jsonContent = response.substring(start, end);
        }
      } else if (response.contains('```')) {
        final start = response.indexOf('[');
        final end = response.lastIndexOf(']') + 1;
        if (start >= 0 && end > start) {
          jsonContent = response.substring(start, end);
        }
      }

      final items = json.decode(jsonContent) as List;
      final extractedItems = items.map((item) {
        final typeValue = _removeQuotes(item['type']);
        return ExtractedItem(
          text: _removeQuotes(item['text']),
          type: typeValue.isEmpty ? 'word' : typeValue,
          preItem: _removeQuotes(item['preItem']),
          postItem: _removeQuotes(item['postItem']),
        );
      }).toList();

      // Post-process: Filter out single words if only expressions are requested
      if (!extractWords && extractExpressions) {
        return extractedItems.where((item) {
          // Check if it's actually a multi-word expression
          final wordCount = item.text.trim().split(RegExp(r'\s+')).length;
          return wordCount > 1 || item.type == 'expression';
        }).toList();
      }

      return extractedItems;
    } catch (e) {
      throw Exception('Failed to extract items: $e');
    }
  }

  /// Estimate tokens in text (rough approximation: 1 token ≈ 0.75 words for English)
  int _estimateTokens(String text) {
    final wordCount = text.split(RegExp(r'\s+')).length;
    return (wordCount * 1.4).ceil(); // Conservative estimate
  }

  /// Count sentences in text
  /// Uses sentence delimiters (. ! ?) followed by space/newline and capital letter
  int _countSentences(String text) {
    // Pattern matches: . ! ? followed by space/newline
    final sentencePattern = RegExp(
      r'[.!?](?:\s+[A-Z]|\n+)',
      multiLine: true,
    );
    final matches = sentencePattern.allMatches(text);
    // Add 1 because the last sentence may not have a delimiter after it
    return matches.length + 1;
  }

  /// Remove surrounding quotation marks from text
  /// Handles both single (') and double (") quotes
  String _removeQuotes(String? text) {
    if (text == null || text.isEmpty) return '';

    var cleaned = text.trim();

    // Remove surrounding double quotes
    if (cleaned.startsWith('"') && cleaned.endsWith('"') && cleaned.length > 1) {
      cleaned = cleaned.substring(1, cleaned.length - 1);
    }

    // Remove surrounding single quotes
    if (cleaned.startsWith("'") && cleaned.endsWith("'") && cleaned.length > 1) {
      cleaned = cleaned.substring(1, cleaned.length - 1);
    }

    // Remove any remaining leading/trailing quotes that might be unbalanced
    while (cleaned.startsWith('"') || cleaned.startsWith("'")) {
      cleaned = cleaned.substring(1);
    }
    while (cleaned.endsWith('"') || cleaned.endsWith("'")) {
      cleaned = cleaned.substring(0, cleaned.length - 1);
    }

    return cleaned.trim();
  }

  /// Extract items from large text by processing in chunks
  /// Uses sentence-based chunking to preserve context and avoid cutting mid-sentence
  Future<List<ExtractedItem>> _extractItemsInChunks({
    required String text,
    required String knowledgeLevel,
    required bool extractWords,
    required bool extractExpressions,
    bool extractFullItems = false,
    required String sourceLanguage,
    int? maxItems,
  }) async {
    // Split text into sentences using multiple delimiters
    // This regex handles: . ! ? followed by space/newline, and also handles abbreviations
    final sentencePattern = RegExp(
      r'(?<=[.!?])\s+(?=[A-Z])|(?<=[.!?])\n+',
      multiLine: true,
    );

    var sentences = text.split(sentencePattern)
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    // If splitting didn't work well (very few sentences), fall back to splitting by newlines
    if (sentences.length < 3) {
      sentences = text.split(RegExp(r'\n+'))
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();
    }

    logDebug('───────────────────────────────────────────────────────────');
    logDebug('SENTENCE-BASED CHUNKING: Detected ${sentences.length} sentences in text');

    // Group sentences into chunks (5-10 sentences per chunk)
    const minSentencesPerChunk = 5;
    const maxSentencesPerChunk = 10;
    final chunks = <String>[];

    for (int i = 0; i < sentences.length; i += maxSentencesPerChunk) {
      final end = (i + maxSentencesPerChunk < sentences.length)
          ? i + maxSentencesPerChunk
          : sentences.length;
      final chunkSentences = sentences.sublist(i, end);
      chunks.add(chunkSentences.join(' '));
    }

    logDebug('Creating ${chunks.length} chunks with $minSentencesPerChunk-$maxSentencesPerChunk sentences each');
    logDebug('───────────────────────────────────────────────────────────');

    for (int i = 0; i < chunks.length; i++) {
      final chunkSentenceCount = i + maxSentencesPerChunk <= sentences.length
          ? maxSentencesPerChunk
          : sentences.length - i * maxSentencesPerChunk;
      final chunkWordCount = chunks[i].split(RegExp(r'\s+')).length;
      final chunkCharCount = chunks[i].length;
      logDebug('  Chunk ${i + 1}: $chunkSentenceCount sentences, $chunkWordCount words, $chunkCharCount chars');
    }
    logDebug('───────────────────────────────────────────────────────────');

    // Process each chunk
    final allItems = <ExtractedItem>[];
    for (int i = 0; i < chunks.length; i++) {
      logDebug('Processing chunk ${i + 1}/${chunks.length}...');
      final chunkItems = await extractItems(
        text: chunks[i],
        knowledgeLevel: knowledgeLevel,
        extractWords: extractWords,
        extractExpressions: extractExpressions,
        extractFullItems: extractFullItems,
        sourceLanguage: sourceLanguage,
        maxItems: null, // Don't limit individual chunks
      );
      logDebug('Chunk ${i + 1} extracted ${chunkItems.length} items');
      allItems.addAll(chunkItems);
    }

    logDebug('───────────────────────────────────────────────────────────');
    logDebug('TOTAL ITEMS BEFORE DEDUPLICATION: ${allItems.length}');

    // Remove duplicates (same text)
    final uniqueItems = <String, ExtractedItem>{};
    for (final item in allItems) {
      final key = item.text.toLowerCase().trim();
      if (!uniqueItems.containsKey(key)) {
        uniqueItems[key] = item;
      }
    }

    var result = uniqueItems.values.toList();
    logDebug('TOTAL UNIQUE ITEMS: ${result.length}');

    // Apply maxItems limit if specified
    if (maxItems != null && result.length > maxItems) {
      result = result.take(maxItems).toList();
      logDebug('LIMITED TO: $maxItems items');
    }
    logDebug('═══════════════════════════════════════════════════════════');

    return result;
  }

  /// Get knowledge level specific guidance for extraction
  String _getKnowledgeLevelGuidance(String level) {
    switch (level) {
      case 'A1':
        return '''- Focus on: ONLY basic everyday words and very simple phrases
- Vocabulary: Numbers (1-100), colors, family members (mother, father), food (bread, water), basic greetings (hello, goodbye), most common verbs (be, have, go, want, like, eat, drink)
- Expressions: ONLY simple fixed phrases ("How are you?", "Thank you", "Good morning", "What is your name?")
- STRICTLY AVOID: Complex grammar, abstract concepts, technical terms, phrasal verbs, idioms, compound sentences
- STRICTLY AVOID: Advanced expressions like "be overshadowed by", "genuine level of", any business or academic vocabulary
- Examples of A1 words: cat, dog, big, small, red, one, two, yes, no, good, bad
- Examples of A1 expressions: "I am", "you are", "thank you", "excuse me"''';

      case 'A2':
        return '''- Focus on: Common everyday situations and basic routine tasks
- Vocabulary: Shopping (buy, sell, price), basic directions (left, right, straight), weather (rain, sun, cold), hobbies (swim, read, play), simple past tense (went, had, was)
- Expressions: Simple polite requests ("Could you help me?", "I would like"), basic time expressions ("in the morning", "next week")
- STRICTLY AVOID: Specialized vocabulary, complex sentence structures, advanced idioms, academic language
- STRICTLY AVOID: Business terms, abstract concepts, sophisticated expressions
- Examples of A2 words: yesterday, tomorrow, restaurant, hospital, expensive, cheap
- Examples of A2 expressions: "I went to", "I would like to", "Can you tell me"''';

      case 'B1':
        return '''- Focus on: Familiar topics, work, school, leisure
- Vocabulary: Abstract nouns (opinion, problem, decision), phrasal verbs
- Expressions: Giving opinions, making suggestions, explaining problems
- Include: Some idiomatic expressions, conditional phrases''';

      case 'B2':
        return '''- Focus on: Complex topics, detailed explanations
- Vocabulary: Academic terms, sophisticated adjectives, technical vocabulary
- Expressions: Discourse markers, formal phrases, nuanced meanings
- Include: Idiomatic expressions, collocations, professional language''';

      case 'C1':
        return '''- Focus on: Sophisticated language, subtle meanings
- Vocabulary: Advanced vocabulary, specialized terms, rare words
- Expressions: Complex idioms, literary phrases, formal/informal register shifts
- Include: Cultural references, metaphorical language''';

      case 'C2':
        return '''- Focus on: Native-like proficiency, nuanced expression
- Vocabulary: Rare and specialized terms, subtle distinctions
- Expressions: Complex idioms, proverbs, cultural references, stylistic variations
- Include: Everything appropriate for educated native speakers''';

      default:
        return '- Focus on general vocabulary appropriate for intermediate learners';
    }
  }

  /// Translate text using OpenAI
  Future<String> translate({
    required String text,
    required String sourceLang,
    required String targetLang,
  }) async {
    logDebug('🔄 OpenAI Translation Request:');
    logDebug('  Source Language: $sourceLang');
    logDebug('  Target Language: $targetLang');
    logDebug('  Text: "$text"');
    logDebug('  Text Length: ${text.length}');
    logDebug('  Text is empty: ${text.trim().isEmpty}');

    // Check if text is empty or null
    if (text.trim().isEmpty) {
      logDebug('  ⚠️ Text is empty, returning empty string');
      return ''; // Return empty string instead of making API call
    }

    final prompt = '''Translate the following text from $sourceLang to $targetLang. 

CRITICAL INSTRUCTIONS:
- Respond with ONLY the direct translation
- Do NOT add any explanations, apologies, or commentary
- Do NOT say things like "I'm sorry" or "you haven't provided"
- If the text is already provided below, translate it immediately

Text to translate: "$text"

Translation:''';

    try {
      logDebug('  📤 Sending translation request to OpenAI...');
      final response = await _makeRequest(prompt, maxTokens: 200);
      logDebug('  📥 OpenAI Response: "$response"');

      final cleaned = _removeQuotes(response.trim());
      logDebug('  🧹 Cleaned Response: "$cleaned"');

      // Filter out common error messages from OpenAI
      if (_isErrorMessage(cleaned)) {
        logDebug('  ❌ ERROR: OpenAI returned error message instead of translation');
        throw Exception('OpenAI returned error message: $cleaned');
      }

      logDebug('  ✅ Translation successful');
      return cleaned;
    } catch (e) {
      logDebug('  ❌ Translation failed: $e');
      throw Exception('Failed to translate: $e');
    }
  }

  /// Check if the response is an error message rather than a translation
  bool _isErrorMessage(String text) {
    final lowerText = text.toLowerCase();

    // Common error patterns from OpenAI
    final errorPatterns = [
      "i'm sorry",
      "i am sorry",
      "haven't provided",
      "havent provided",
      "no text to translate",
      "cannot translate",
      "unable to translate",
      "please provide",
      "you need to provide",
      "missing text",
    ];

    for (final pattern in errorPatterns) {
      if (lowerText.contains(pattern)) {
        return true;
      }
    }

    return false;
  }

  /// Generate grammatical metadata (preItem and postItem) for a word
  ///
  /// For nouns: returns article in preItem and plural form in postItem
  /// For verbs: returns infinitive marker in preItem and conjugations in postItem
  /// For other types: may return null for both
  ///
  /// Returns a map with 'preItem' and 'postItem' keys (values may be null)
  Future<Map<String, String?>> generateGrammaticalMetadata({
    required String text,
    required String language,
    required String wordType,
  }) async {
    logDebug('📚 Generating Grammatical Metadata:');
    logDebug('  Text: "$text"');
    logDebug('  Language: $language');
    logDebug('  Type: $wordType');

    final prompt = '''You are a language expert. For the following ${wordType == 'word' ? 'word' : 'expression'} in $language, provide grammatical metadata.

Word/Expression: "$text"
Language: $language

INSTRUCTIONS:
${wordType == 'word' ? '''
If this is a NOUN:
- preItem: the appropriate article (e.g., "der"/"die"/"das" for German, "the" for English, "le"/"la" for French)
- postItem: the plural form (e.g., "pl. Häuser" for German, "pl. houses" for English)

If this is a VERB:
- preItem: leave empty or use infinitive marker if applicable (e.g., "to" for English infinitive)
- postItem: past tense or key conjugation forms (e.g., "went, had gone" for English, "machte, h. gemacht" for German)

If this is an ADJECTIVE or OTHER:
- preItem: null
- postItem: comparative/superlative forms if applicable (e.g., "better, best"), otherwise null
''' : '''
For EXPRESSIONS/PHRASES:
- preItem: null (not applicable for multi-word expressions)
- postItem: null (not applicable for multi-word expressions)
'''}

Return ONLY a JSON object with this exact format:
{
  "preItem": "article or marker (or null)",
  "postItem": "plural/conjugation/forms (or null)"
}

IMPORTANT:
- Use null (not empty string) if a field is not applicable
- For German nouns, ALWAYS include the article (der/die/das) in preItem
- For verbs, include the most important conjugation forms in postItem
- Be concise and follow language-specific grammar rules
- Do not include explanations, only the JSON object

Examples:

German noun "Haus":
{"preItem": "das", "postItem": "pl. Häuser"}

English verb "make":
{"preItem": null, "postItem": "made, made"}

German verb "machen":
{"preItem": null, "postItem": "machte, h. gemacht"}

English noun "house":
{"preItem": "the", "postItem": "pl. houses"}

Expression "in Betracht ziehen":
{"preItem": null, "postItem": null}

Do not include any explanation, only the JSON object.''';

    try {
      logDebug('  📤 Sending request to OpenAI...');
      final response = await _makeRequest(prompt, maxTokens: 150);
      logDebug('  📥 OpenAI Response: "$response"');

      // Extract JSON from response
      String jsonContent = response;
      if (response.contains('```json')) {
        final start = response.indexOf('{');
        final end = response.lastIndexOf('}') + 1;
        if (start >= 0 && end > start) {
          jsonContent = response.substring(start, end);
        }
      } else if (response.contains('```')) {
        final start = response.indexOf('{');
        final end = response.lastIndexOf('}') + 1;
        if (start >= 0 && end > start) {
          jsonContent = response.substring(start, end);
        }
      }

      final data = json.decode(jsonContent) as Map<String, dynamic>;
      final result = <String, String?>{
        'preItem': _removeQuotes(data['preItem']?.toString()),
        'postItem': _removeQuotes(data['postItem']?.toString()),
      };

      // Convert empty strings to null
      if (result['preItem']?.isEmpty ?? false) result['preItem'] = null;
      if (result['postItem']?.isEmpty ?? false) result['postItem'] = null;

      logDebug('  ✅ Generated metadata:');
      logDebug('    preItem: "${result['preItem']}"');
      logDebug('    postItem: "${result['postItem']}"');

      return result;
    } catch (e) {
      logDebug('  ❌ Failed to generate metadata: $e');
      throw Exception('Failed to generate grammatical metadata: $e');
    }
  }

  /// Generate examples for a word/expression
  Future<List<Map<String, String>>> generateExamples({
    required String text,
    required String sourceLang,
    required String targetLang,
  }) async {
    final prompt = '''Generate 1-3 practical example sentences using the word or phrase "$text" in $sourceLang.

Requirements:
1. Examples should be natural, everyday sentences
2. Keep sentences short and clear (max 12 words)
3. Provide accurate translations to $targetLang

Return ONLY a JSON array with this exact format:
[
  {
    "language1": "example sentence in $sourceLang",
    "language2": "translation in $targetLang"
  }
]

Do not include any explanation, only the JSON array.''';

    try {
      final response = await _makeRequest(prompt, maxTokens: 500);

      // Extract JSON from response
      String jsonContent = response;
      if (response.contains('```json')) {
        final start = response.indexOf('[');
        final end = response.lastIndexOf(']') + 1;
        if (start >= 0 && end > start) {
          jsonContent = response.substring(start, end);
        }
      } else if (response.contains('```')) {
        final start = response.indexOf('[');
        final end = response.lastIndexOf(']') + 1;
        if (start >= 0 && end > start) {
          jsonContent = response.substring(start, end);
        }
      }

      final examples = json.decode(jsonContent) as List;
      return examples.map((e) => {
        'language1': _removeQuotes(e['language1']?.toString()),
        'language2': _removeQuotes(e['language2']?.toString()),
      }).toList();
    } catch (e) {
      throw Exception('Failed to generate examples: $e');
    }
  }

  /// Make HTTP request to OpenAI API
  Future<String> _makeRequest(String prompt, {int maxTokens = 500}) async {
    // Use the model selected by the user
    final model = _model;

    // Ensure maxTokens doesn't exceed model limits
    // gpt-3.5-turbo: max 4096 tokens (input + output combined)
    // gpt-4 models: max depends on variant (8K, 32K, 128K)
    // Safe max for output: 4000 tokens
    final safeMaxTokens = maxTokens.clamp(1, 4000);

    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'model': model,
          'messages': [
            {
              'role': 'system',
              'content': 'You are a helpful language learning assistant. Always respond concisely and follow instructions exactly.',
            },
          {
            'role': 'user',
            'content': prompt,
          }
        ],
        'temperature': 0.3,
        'max_tokens': safeMaxTokens,
      }),
    );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['choices'][0]['message']['content'];
      } else if (response.statusCode == 400) {
        // Bad Request - parse error details
        try {
          final errorData = json.decode(response.body);
          final errorMessage = errorData['error']?['message'] ?? 'Unknown error';
          final errorType = errorData['error']?['type'] ?? 'bad_request';
          throw Exception('OpenAI API error (400): $errorType - $errorMessage');
        } catch (e) {
          throw Exception('OpenAI API error (400): ${response.body}');
        }
      } else if (response.statusCode == 401) {
        throw Exception('Invalid API key');
      } else if (response.statusCode == 429) {
        throw Exception('API rate limit exceeded');
      } else {
        throw Exception('API request failed: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Network error: $e');
    }
  }

  /// Extract full items line by line - each non-empty line becomes an item
  /// This mode translates each line as a complete item without extraction
  Future<List<ExtractedItem>> _extractFullItemsLineByLine({
    required String text,
    required String sourceLanguage,
    int? maxItems,
  }) async {
    logDebug('═══════════════════════════════════════════════════════════');
    logDebug('EXTRACT FULL ITEMS MODE - Line by Line Translation');
    logDebug('═══════════════════════════════════════════════════════════');

    // Split text into non-empty lines
    final lines = text.split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();

    logDebug('Total lines to process: ${lines.length}');

    // Apply maxItems limit if specified
    final linesToProcess = maxItems != null && lines.length > maxItems
        ? lines.take(maxItems).toList()
        : lines;

    logDebug('Processing ${linesToProcess.length} lines');

    // Each line becomes an ExtractedItem with just the text
    // Translation will happen in the next step (AI Items Selection Page)
    final items = linesToProcess.map((line) {
      return ExtractedItem(
        text: line,
        type: 'expression', // Treat full items as expressions
        preItem: null,
        postItem: null,
        translatedText: null, // Will be filled in during next step
        translatedPreItem: null,
        translatedPostItem: null,
      );
    }).toList();

    logDebug('Created ${items.length} full items from lines');
    logDebug('═══════════════════════════════════════════════════════════');

    return items;
  }
}
