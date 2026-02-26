// lib/core/services/text_analysis_service.dart
//
// Text Analysis Service using OpenAI
//

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../data/models/extracted_item.dart';

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
    required String sourceLanguage,
    int? maxItems,
  }) async {
    if (!extractWords && !extractExpressions) {
      throw Exception('At least one extraction type must be selected');
    }

    // Estimate tokens for input text and prompt
    final textWordCount = text.split(RegExp(r'\s+')).length;
    final estimatedInputTokens = _estimateTokens(text);

    // For texts with many words, we need to use chunking to extract comprehensively
    // Since GPT-3.5-turbo output is limited to ~4000 tokens, large texts need multiple passes
    const maxWordsPerRequest = 400; // Process in smaller chunks to extract more items

    if (textWordCount > maxWordsPerRequest) {
      // Text is large, need to chunk for comprehensive extraction
      return await _extractItemsInChunks(
        text: text,
        knowledgeLevel: knowledgeLevel,
        extractWords: extractWords,
        extractExpressions: extractExpressions,
        sourceLanguage: sourceLanguage,
        maxItems: maxItems,
      );
    }

    // If text is too large for single request, need to chunk
    const maxContextTokens = 12000; // GPT-3.5-turbo-16k safe limit
    const promptOverhead = 2000; // Tokens for our instructions

    if (estimatedInputTokens > maxContextTokens - promptOverhead) {
      // Text is too large, need to chunk
      return await _extractItemsInChunks(
        text: text,
        knowledgeLevel: knowledgeLevel,
        extractWords: extractWords,
        extractExpressions: extractExpressions,
        sourceLanguage: sourceLanguage,
        maxItems: maxItems,
      );
    }

    final types = <String>[];
    if (extractWords) types.add('individual words');
    if (extractExpressions) types.add('expressions/phrases (2-8 words)');

    // Define what each level should focus on
    final levelGuidance = _getKnowledgeLevelGuidance(knowledgeLevel);

    // Calculate dynamic maxTokens for response based on expected output
    // Each item needs ~50 tokens in JSON format
    // For long texts, allow more items to be extracted
    final expectedItems = maxItems ?? (textWordCount ~/ 8).clamp(30, 500);
    // gpt-3.5-turbo max tokens: 4096 total (input + output)
    // With ~2000 token prompt + text, safe output limit is ~2000 tokens
    // Allow up to 4000 tokens for response but will be clamped to safe limit in _makeRequest
    final dynamicMaxTokens = (expectedItems * 50).clamp(1000, 4000);

    final prompt = '''You are a language learning expert. Analyze the following text in $sourceLanguage and extract important vocabulary ${types.join(' and ')} suitable for CEFR $knowledgeLevel level learners.

CRITICAL - KNOWLEDGE LEVEL: $knowledgeLevel
You MUST extract ONLY vocabulary that is appropriate for $knowledgeLevel level learners. DO NOT extract advanced vocabulary that is beyond this level.

Text to analyze:
"""
$text
"""

IMPORTANT - Knowledge Level Requirements for $knowledgeLevel:
$levelGuidance

Extraction Requirements:
1. ⚠️ STRICTLY adhere to $knowledgeLevel vocabulary level - this is CRITICAL
2. Extract COMPREHENSIVELY: aim to identify ALL relevant vocabulary from the text that matches $knowledgeLevel level
3. Extract vocabulary that students at $knowledgeLevel level would be learning or practicing
4. AVOID words and expressions that are too advanced for $knowledgeLevel level
5. ${extractWords && !extractExpressions ? 'Extract ONLY single words (one word per item)' : ''}${!extractWords && extractExpressions ? 'Extract ONLY expressions/phrases (2-8 words, NO single words)' : ''}${extractWords && extractExpressions ? 'Extract both single words AND multi-word expressions/phrases (2-8 words)' : ''}
6. For expressions: Include idioms, phrasal verbs, collocations, and common phrases (2-8 words) appropriate for $knowledgeLevel level
7. Mark each item with "type": "word" for single words OR "type": "expression" for multi-word phrases
8. In case of words for nouns in languages like German, include the article (der/die/das) in preItem and plural form in postItem
9. In case of verbs include the past version into postItem (e.g., machte, h. gemacht)
10. For other languages with articles/prepositions, include them in preItem
${maxItems != null ? '11. Limit to maximum $maxItems items\n' : ''}
12. Avoid extracting duplicates
13. IMPORTANT: Extract as many relevant items as possible - do NOT stop early
14. Return ONLY a JSON array with this exact format:

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

Examples for English:
{"text": "cat", "type": "word", "preItem": null, "postItem": "pl: cats"}
{"text": "get along with", "type": "expression", "preItem": null, "postItem": null}
{"text": "take into account", "type": "expression", "preItem": null, "postItem": null}
{"text": "be on the lookout for", "type": "expression", "preItem": null, "postItem": null}
{"text": "as far as I'm concerned", "type": "expression", "preItem": null, "postItem": null}

IMPORTANT: Expressions can be 2-8 words long. Extract idioms, phrasal verbs, and common collocations.

CRITICAL: If extracting only expressions, DO NOT include any single-word items in the result.

Do not include any explanation, only the JSON array.''';

    // DEBUG: Print the full prompt to console
    print('═══════════════════════════════════════════════════════════');
    print('AI TEXT ANALYSIS - PROMPT SENT TO OPENAI');
    print('═══════════════════════════════════════════════════════════');
    print('Knowledge Level: $knowledgeLevel');
    print('Extract Words: $extractWords');
    print('Extract Expressions: $extractExpressions');
    print('Max Items: $maxItems');
    print('Dynamic Max Tokens: $dynamicMaxTokens');
    print('Text Word Count: $textWordCount');
    print('───────────────────────────────────────────────────────────');
    print('FULL PROMPT:');
    print(prompt);
    print('═══════════════════════════════════════════════════════════');

    try {
      final response = await _makeRequest(prompt, maxTokens: dynamicMaxTokens);

      // DEBUG: Print the response
      print('───────────────────────────────────────────────────────────');
      print('OPENAI RESPONSE (first 500 chars):');
      print(response.substring(0, response.length > 500 ? 500 : response.length));
      if (response.length > 500) {
        print('... (truncated, total length: ${response.length} chars)');
      }
      print('═══════════════════════════════════════════════════════════');

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
  Future<List<ExtractedItem>> _extractItemsInChunks({
    required String text,
    required String knowledgeLevel,
    required bool extractWords,
    required bool extractExpressions,
    required String sourceLanguage,
    int? maxItems,
  }) async {
    // Split text into manageable chunks (around 400 words per chunk for comprehensive extraction)
    final words = text.split(RegExp(r'\s+'));
    const chunkSize = 400; // Smaller chunks = more comprehensive extraction
    final chunks = <String>[];

    for (int i = 0; i < words.length; i += chunkSize) {
      final end = (i + chunkSize < words.length) ? i + chunkSize : words.length;
      chunks.add(words.sublist(i, end).join(' '));
    }

    print('───────────────────────────────────────────────────────────');
    print('CHUNKING: Text has ${words.length} words, splitting into ${chunks.length} chunks of ~$chunkSize words each');
    print('───────────────────────────────────────────────────────────');

    // Process each chunk
    final allItems = <ExtractedItem>[];
    for (int i = 0; i < chunks.length; i++) {
      print('Processing chunk ${i + 1}/${chunks.length}...');
      final chunkItems = await extractItems(
        text: chunks[i],
        knowledgeLevel: knowledgeLevel,
        extractWords: extractWords,
        extractExpressions: extractExpressions,
        sourceLanguage: sourceLanguage,
        maxItems: null, // Don't limit individual chunks
      );
      print('Chunk ${i + 1} extracted ${chunkItems.length} items');
      allItems.addAll(chunkItems);
    }

    print('───────────────────────────────────────────────────────────');
    print('TOTAL ITEMS BEFORE DEDUPLICATION: ${allItems.length}');

    // Remove duplicates (same text)
    final uniqueItems = <String, ExtractedItem>{};
    for (final item in allItems) {
      final key = item.text.toLowerCase().trim();
      if (!uniqueItems.containsKey(key)) {
        uniqueItems[key] = item;
      }
    }

    var result = uniqueItems.values.toList();
    print('TOTAL UNIQUE ITEMS: ${result.length}');

    // Apply maxItems limit if specified
    if (maxItems != null && result.length > maxItems) {
      result = result.take(maxItems).toList();
      print('LIMITED TO: $maxItems items');
    }
    print('═══════════════════════════════════════════════════════════');

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
    // Check if text is empty or null
    if (text.trim().isEmpty) {
      return ''; // Return empty string instead of making API call
    }

    final prompt = '''Translate the following text from $sourceLang to $targetLang. Respond with ONLY the translation, no explanations.

Text: "$text"

Translation:''';

    try {
      final response = await _makeRequest(prompt, maxTokens: 200);
      final cleaned = _removeQuotes(response.trim());

      // Filter out common error messages from OpenAI
      if (_isErrorMessage(cleaned)) {
        throw Exception('OpenAI returned error message instead of translation');
      }

      return cleaned;
    } catch (e) {
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
}
