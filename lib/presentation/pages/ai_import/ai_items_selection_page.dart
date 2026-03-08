// lib/presentation/pages/ai_import/ai_items_selection_page.dart
//
// AI Text Analysis Import - Step 2: Items Selection and Import
//

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/text_analysis_service.dart';
import '../../../core/services/deepl_service.dart';
import '../../../data/models/language_package.dart';
import '../../../data/models/extracted_item.dart';
import '../../../data/models/item.dart';
import '../../../data/models/item_language_data.dart';
import '../../../data/models/category.dart';
import '../../../data/models/example_sentence.dart';
import '../../../data/repositories/item_repository.dart';
import '../../../data/repositories/category_repository.dart';
import '../../../l10n/app_localizations.dart';
import '../../providers/app_settings_provider.dart';
import '../../../core/utils/debug_print.dart';

class AIItemsSelectionPage extends ConsumerStatefulWidget {
  final LanguagePackage package;
  final List<ExtractedItem> extractedItems;
  final String sourceLanguage;
  final String targetLanguage;
  final String detectedLangCode;
  final String categoryName;
  final bool generateExamples;

  const AIItemsSelectionPage({
    super.key,
    required this.package,
    required this.extractedItems,
    required this.sourceLanguage,
    required this.targetLanguage,
    required this.detectedLangCode,
    required this.categoryName,
    required this.generateExamples,
  });

  @override
  ConsumerState<AIItemsSelectionPage> createState() => _AIItemsSelectionPageState();
}

class _AIItemsSelectionPageState extends ConsumerState<AIItemsSelectionPage> {
  final _itemRepo = ItemRepository();
  final _categoryRepo = CategoryRepository();
  bool _isLoading = false;
  bool _isImporting = false;
  bool _cancelRequested = false;

  @override
  void initState() {
    super.initState();
    _checkDuplicates();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.selectItemsToImport,
          style: theme.textTheme.titleMedium,
        ),
        actions: [
          TextButton(
            onPressed: _selectAll,
            child: Text(l10n.selectAll),
          ),
          TextButton(
            onPressed: _deselectAll,
            child: Text(l10n.deselectAll),
          ),
        ],
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  _buildSummary(theme, l10n),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(AppTheme.spacing8),
                      itemCount: widget.extractedItems.length,
                      itemBuilder: (context, index) {
                        return _buildItemCard(
                          theme,
                          l10n,
                          widget.extractedItems[index],
                          index,
                        );
                      },
                    ),
                  ),
                  _buildImportButton(theme, l10n),
                ],
              ),
      ),
    );
  }

  Widget _buildSummary(ThemeData theme, AppLocalizations l10n) {
    final selectedCount = widget.extractedItems.where((i) => i.isSelected).length;
    final duplicateCount = widget.extractedItems.where((i) => i.isDuplicate).length;

    // Determine if we should show compact view (portrait mode on non-tablet)
    final screenWidth = MediaQuery.of(context).size.width;
    final isCompactView = screenWidth < 600;

    // Extract 2-letter language code from sourceLanguage (e.g., "English" -> "EN")
    String languageDisplay = widget.sourceLanguage;
    if (isCompactView) {
      // Try to extract from detectedLangCode first (it's already in format like "en")
      languageDisplay = widget.detectedLangCode.split('-')[0].toUpperCase();
    }

    return Card(
      margin: const EdgeInsets.all(AppTheme.spacing8),
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.language, size: 20, color: theme.colorScheme.primary),
                const SizedBox(width: AppTheme.spacing8),
                Flexible(
                  child: Text(
                    '${l10n.languageDetected}: $languageDisplay',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacing8),
            Text(
              '${l10n.itemsFound}: ${widget.extractedItems.length}',
              style: theme.textTheme.bodySmall,
            ),
            Text(
              'Selected: $selectedCount',
              style: theme.textTheme.bodySmall,
            ),
            if (duplicateCount > 0)
              Text(
                '${l10n.duplicate}: $duplicateCount',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemCard(
    ThemeData theme,
    AppLocalizations l10n,
    ExtractedItem item,
    int index,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppTheme.spacing8),
      color: item.isDuplicate
          ? theme.colorScheme.errorContainer.withValues(alpha: 0.3)
          : null,
      child: CheckboxListTile(
        value: item.isSelected,
        onChanged: item.isDuplicate
            ? null
            : (value) {
                setState(() {
                  item.isSelected = value ?? false;
                });
              },
        title: Row(
          children: [
            if (item.preItem != null) ...[
              Text(
                '${item.preItem} ',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ],
            Expanded(
              child: Text(
                item.text,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (item.postItem != null) ...[
              Text(
                ' ${item.postItem}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ],
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: item.type == 'word'
                        ? theme.colorScheme.primaryContainer
                        : theme.colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    item.type,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontSize: 10,
                    ),
                  ),
                ),
                if (item.isDuplicate) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.errorContainer,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      l10n.duplicate,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: 10,
                        color: theme.colorScheme.error,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
        dense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacing8,
          vertical: 4,
        ),
      ),
    );
  }

  Widget _buildImportButton(ThemeData theme, AppLocalizations l10n) {
    final selectedCount = widget.extractedItems.where((i) => i.isSelected).length;

    return Container(
      padding: const EdgeInsets.all(AppTheme.spacing8),
      child: ElevatedButton(
        onPressed: (_isImporting || selectedCount == 0) ? null : _importItems,
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(48),
        ),
        child: _isImporting
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Text(
                '${l10n.importSelected} ($selectedCount)',
                style: theme.textTheme.titleSmall,
              ),
      ),
    );
  }

  Future<void> _checkDuplicates() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Get existing items in the package
      final categories = await _categoryRepo.getCategoriesForPackage(widget.package.id);
      final categoryIds = categories.map((c) => c.id).toList();

      final existingItems = categoryIds.isNotEmpty
          ? await _itemRepo.getItemsForCategories(categoryIds)
          : <Item>[];

      // Check for duplicates
      for (final extractedItem in widget.extractedItems) {
        final isDuplicate = existingItems.any((existing) {
          final lang1Code = widget.package.languageCode1.split('-')[0].toLowerCase();
          final detectedCode = widget.detectedLangCode.toLowerCase();

          final existingText = detectedCode == lang1Code
              ? existing.language1Data.text.toLowerCase()
              : existing.language2Data.text.toLowerCase();

          return existingText == extractedItem.text.toLowerCase();
        });

        if (isDuplicate) {
          extractedItem.isDuplicate = true;
          extractedItem.isSelected = false;
        }
      }
    } catch (e) {
      // Continue even if duplicate check fails
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _selectAll() {
    setState(() {
      for (final item in widget.extractedItems) {
        if (!item.isDuplicate) {
          item.isSelected = true;
        }
      }
    });
  }

  void _deselectAll() {
    setState(() {
      for (final item in widget.extractedItems) {
        item.isSelected = false;
      }
    });
  }

  Future<void> _importItems() async {
    final l10n = AppLocalizations.of(context)!;
    final selectedItems = widget.extractedItems.where((i) => i.isSelected).toList();

    if (selectedItems.isEmpty) {
      _showError(l10n.noItemsSelected);
      return;
    }

    setState(() {
      _isImporting = true;
      _cancelRequested = false;
    });

    logDebug('═══════════════════════════════════════════════════════════');
    logDebug('🚀 STARTING IMPORT PROCESS');
    logDebug('═══════════════════════════════════════════════════════════');
    logDebug('Selected Items: ${selectedItems.length}');
    logDebug('Package ID: ${widget.package.id}');
    logDebug('Package Language 1: ${widget.package.languageCode1}');
    logDebug('Package Language 2: ${widget.package.languageCode2}');
    logDebug('Detected Language Code: ${widget.detectedLangCode}');
    logDebug('Source Language: ${widget.sourceLanguage}');
    logDebug('Target Language: ${widget.targetLanguage}');
    logDebug('Category Name: ${widget.categoryName}');
    logDebug('Generate Examples: ${widget.generateExamples}');

    try {
      final settings = ref.read(appSettingsProvider);
      logDebug('\n📋 Settings:');
      logDebug('  OpenAI API Key configured: ${settings.openaiApiKey != null && settings.openaiApiKey!.isNotEmpty}');
      logDebug('  DeepL API Key configured: ${settings.deeplApiKey != null && settings.deeplApiKey!.isNotEmpty}');
      logDebug('  OpenAI Model: ${settings.openaiModel}');

      final analysisService = TextAnalysisService(
        apiKey: settings.openaiApiKey!,
        model: settings.openaiModel,
      );
      final deeplService = DeepLService(apiKey: settings.deeplApiKey);

      // Get or create category
      logDebug('\n📁 Getting/Creating Category...');
      final categories = await _categoryRepo.getCategoriesForPackage(widget.package.id);
      Category? category = categories.firstWhere(
        (c) => c.name.toLowerCase() == widget.categoryName.toLowerCase(),
        orElse: () => Category(
          id: const Uuid().v4(),
          packageId: widget.package.id,
          name: widget.categoryName,
          description: null,
        ),
      );

      if (!categories.contains(category)) {
        logDebug('  Creating new category: ${category.name}');
        await _categoryRepo.insertCategory(category);
      } else {
        logDebug('  Using existing category: ${category.name}');
      }

      // Determine language codes
      final isLang1Source = widget.detectedLangCode.toLowerCase() ==
          widget.package.languageCode1.split('-')[0].toLowerCase();

      final sourceLangCode = isLang1Source
          ? widget.package.languageCode1
          : widget.package.languageCode2;
      final targetLangCode = isLang1Source
          ? widget.package.languageCode2
          : widget.package.languageCode1;

      logDebug('\n🔄 Language Direction:');
      logDebug('  Is Language1 Source: $isLang1Source');
      logDebug('  Source Language Code: $sourceLangCode');
      logDebug('  Target Language Code: $targetLangCode');

      // Show progress dialog
      _showProgressDialog(l10n, 0, selectedItems.length);

      // Process each item
      for (int i = 0; i < selectedItems.length; i++) {
        // Check if cancel was requested
        if (_cancelRequested) {
          logDebug('\n❌ IMPORT CANCELLED BY USER');
          break;
        }

        final extractedItem = selectedItems[i];

        logDebug('\n───────────────────────────────────────────────────────────');
        logDebug('📦 Processing Item ${i + 1}/${selectedItems.length}');
        logDebug('───────────────────────────────────────────────────────────');
        logDebug('  Text: "${extractedItem.text}"');
        logDebug('  Type: ${extractedItem.type}');
        logDebug('  PreItem: "${extractedItem.preItem}"');
        logDebug('  PostItem: "${extractedItem.postItem}"');

        // Update progress
        _updateProgress(l10n, i + 1, selectedItems.length);

        // Translate main text
        logDebug('\n🔤 Translating Main Text...');
        String? translatedText = await deeplService.translate(
          text: extractedItem.text,
          targetLang: targetLangCode,
          sourceLang: sourceLangCode,
        );

        if (translatedText == null) {
          logDebug('  DeepL returned null, trying OpenAI...');
          translatedText = await analysisService.translate(
            text: extractedItem.text,
            sourceLang: widget.sourceLanguage,
            targetLang: widget.targetLanguage,
          );
          logDebug('  OpenAI translation: "$translatedText"');
        }

        // Generate grammatical metadata (preItem and postItem) for the target language
        logDebug('\n📚 Generating Grammatical Metadata for Target Language...');
        String? targetPreItem;
        String? targetPostItem;

        try {
          final metadata = await analysisService.generateGrammaticalMetadata(
            text: translatedText,
            language: widget.targetLanguage,
            wordType: extractedItem.type,
          );

          targetPreItem = metadata['preItem'];
          targetPostItem = metadata['postItem'];

          logDebug('  Target PreItem: "$targetPreItem"');
          logDebug('  Target PostItem: "$targetPostItem"');
        } catch (e) {
          // If metadata generation fails, continue without it
          logDebug('  ❌ Failed to generate metadata: $e');
          targetPreItem = null;
          targetPostItem = null;
        }

        // Generate examples if requested
        List<ExampleSentence> examples = [];
        if (widget.generateExamples) {
          logDebug('\n📝 Generating Examples...');
          try {
            final exampleMaps = await analysisService.generateExamples(
              text: extractedItem.text,
              sourceLang: widget.sourceLanguage,
              targetLang: widget.targetLanguage,
            );

            logDebug('  Generated ${exampleMaps.length} examples');

            // Map examples correctly based on language direction
            examples = exampleMaps.map((ex) {
              // isLang1Source: true means detected language is Language1
              // So language1 from API response is the source language
              return ExampleSentence(
                id: const Uuid().v4(),
                textLanguage1: isLang1Source ? ex['language1']! : ex['language2']!,
                textLanguage2: isLang1Source ? ex['language2']! : ex['language1']!,
              );
            }).toList();
          } catch (e) {
            // Log error but continue without examples
            logDebug('  ❌ Failed to generate examples: $e');
          }
        }

        // Create item
        logDebug('\n💾 Creating Item...');
        final item = Item(
          id: const Uuid().v4(),
          packageId: widget.package.id,
          categoryIds: [category.id],
          language1Data: ItemLanguageData(
            languageCode: widget.package.languageCode1,
            text: isLang1Source ? extractedItem.text : translatedText,
            preItem: isLang1Source ? extractedItem.preItem : targetPreItem,
            postItem: isLang1Source ? extractedItem.postItem : targetPostItem,
          ),
          language2Data: ItemLanguageData(
            languageCode: widget.package.languageCode2,
            text: isLang1Source ? translatedText : extractedItem.text,
            preItem: isLang1Source ? targetPreItem : extractedItem.preItem,
            postItem: isLang1Source ? targetPostItem : extractedItem.postItem,
          ),
          examples: examples,
          isKnown: false,
          isFavourite: false,
          isImportant: false,
          dontKnowCounter: 1,
          lastReviewedAt: null,
        );

        logDebug('  Language1 Data:');
        logDebug('    Text: "${item.language1Data.text}"');
        logDebug('    PreItem: "${item.language1Data.preItem}"');
        logDebug('    PostItem: "${item.language1Data.postItem}"');
        logDebug('  Language2 Data:');
        logDebug('    Text: "${item.language2Data.text}"');
        logDebug('    PreItem: "${item.language2Data.preItem}"');
        logDebug('    PostItem: "${item.language2Data.postItem}"');
        logDebug('  Examples: ${item.examples.length}');

        await _itemRepo.insertItem(item);
        logDebug('  ✅ Item saved to database');
      }

      logDebug('\n═══════════════════════════════════════════════════════════');
      if (_cancelRequested) {
        logDebug('❌ IMPORT CANCELLED');
      } else {
        logDebug('✅ IMPORT COMPLETED SUCCESSFULLY');
      }
      logDebug('═══════════════════════════════════════════════════════════');

      if (mounted) {
        Navigator.of(context).pop(); // Close progress dialog

        if (_cancelRequested) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.cancel),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.itemsImported),
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
          );
        }

        // Go back to previous page
        Navigator.of(context).pop();
      }
    } catch (e) {
      logDebug('\n❌ ERROR DURING IMPORT:');
      logDebug(e.toString());
      logDebug('═══════════════════════════════════════════════════════════');

      if (mounted) {
        Navigator.of(context).pop(); // Close progress dialog
        _showDetailedErrorDialog(l10n.errorImportingItems, e.toString());
      }
    } finally {
      if (mounted) {
        setState(() {
          _isImporting = false;
          _cancelRequested = false;
        });
      }
    }
  }

  void _showProgressDialog(AppLocalizations l10n, int current, int total) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            LinearProgressIndicator(
              value: total > 0 ? current / total : 0,
            ),
            const SizedBox(height: AppTheme.spacing8),
            Text(
              '${l10n.importing} $current / $total',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppTheme.spacing8),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _cancelRequested = true;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
              child: Text(l10n.cancel),
            ),
          ],
        ),
      ),
    );
  }

  void _updateProgress(AppLocalizations l10n, int current, int total) {
    if (mounted) {
      Navigator.of(context).pop();
      _showProgressDialog(l10n, current, total);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }

  void _showDetailedErrorDialog(String title, String errorMessage) {
    final l10n = AppLocalizations.of(context)!;

    // Parse error message to provide specific guidance
    String guidance = '';
    String technicalDetails = errorMessage;

    if (errorMessage.contains('translation') || errorMessage.contains('translate')) {
      guidance = '• ${l10n.translationServiceFailed}\n• ${l10n.checkApiKeys}\n• ${l10n.retryImport}';
    } else if (errorMessage.contains('Invalid API key') || errorMessage.contains('401')) {
      guidance = '• ${l10n.checkApiKey}\n• ${l10n.ensureValidOpenAIKey}\n• ${l10n.verifyKeyInSettings}';
    } else if (errorMessage.contains('rate limit') || errorMessage.contains('429')) {
      guidance = '• ${l10n.rateLimitExceeded}\n• ${l10n.waitAndRetry}\n• ${l10n.checkAccountQuota}';
    } else if (errorMessage.contains('Network error') || errorMessage.contains('Connection')) {
      guidance = '• ${l10n.checkInternetConnection}\n• ${l10n.retryInMoment}\n• ${l10n.checkFirewall}';
    } else if (errorMessage.contains('example') || errorMessage.contains('Failed to generate')) {
      guidance = '• ${l10n.exampleGenerationFailed}\n• ${l10n.itemsStillImported}\n• ${l10n.canAddExamplesManually}';
    } else if (errorMessage.contains('database') || errorMessage.contains('insert')) {
      guidance = '• ${l10n.databaseError}\n• ${l10n.checkStorageSpace}\n• ${l10n.restartApp}';
    } else {
      guidance = '• ${l10n.unexpectedError}\n• ${l10n.checkErrorDetails}\n• ${l10n.tryAgainLater}';
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.error_outline,
              color: Theme.of(context).colorScheme.error,
              size: 28,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (guidance.isNotEmpty) ...[
                Text(
                  l10n.possibleSolutions,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  guidance,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
              ],
              ExpansionTile(
                title: Text(
                  l10n.technicalDetails,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                initiallyExpanded: false,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: SelectableText(
                      technicalDetails,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.close),
          ),
        ],
      ),
    );
  }
}

