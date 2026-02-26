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

    return Card(
      margin: const EdgeInsets.all(AppTheme.spacing8),
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.language, size: 20, color: theme.colorScheme.primary),
                const SizedBox(width: AppTheme.spacing8),
                Text(
                  '${l10n.languageDetected}: ${widget.sourceLanguage}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
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
          horizontal: AppTheme.spacing12,
          vertical: 4,
        ),
      ),
    );
  }

  Widget _buildImportButton(ThemeData theme, AppLocalizations l10n) {
    final selectedCount = widget.extractedItems.where((i) => i.isSelected).length;

    return Container(
      padding: const EdgeInsets.all(AppTheme.spacing12),
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
    });

    try {
      final settings = ref.read(appSettingsProvider);
      final analysisService = TextAnalysisService(
        apiKey: settings.openaiApiKey!,
        model: settings.openaiModel,
      );
      final deeplService = DeepLService(apiKey: settings.deeplApiKey);

      // Get or create category
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
        await _categoryRepo.insertCategory(category);
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

      // Show progress dialog
      _showProgressDialog(l10n, 0, selectedItems.length);

      // Process each item
      for (int i = 0; i < selectedItems.length; i++) {
        final extractedItem = selectedItems[i];

        // Update progress
        _updateProgress(l10n, i + 1, selectedItems.length);

        // Translate main text
        String? translatedText = await deeplService.translate(
          text: extractedItem.text,
          targetLang: targetLangCode,
          sourceLang: sourceLangCode,
        );

        translatedText ??= await analysisService.translate(
          text: extractedItem.text,
          sourceLang: widget.sourceLanguage,
          targetLang: widget.targetLanguage,
        );

        // Translate preItem if exists and is not empty
        String? translatedPreItem;
        if (extractedItem.preItem != null && extractedItem.preItem!.trim().isNotEmpty) {
          translatedPreItem = await deeplService.translate(
            text: extractedItem.preItem!,
            targetLang: targetLangCode,
            sourceLang: sourceLangCode,
          );

          // Only use OpenAI fallback if DeepL returned null and preItem is not empty
          if (translatedPreItem == null || translatedPreItem.trim().isEmpty) {
            try {
              translatedPreItem = await analysisService.translate(
                text: extractedItem.preItem!,
                sourceLang: widget.sourceLanguage,
                targetLang: widget.targetLanguage,
              );

              // If translation returned empty or looks like an error, set to null
              if (translatedPreItem.trim().isEmpty) {
                translatedPreItem = null;
              }
            } catch (e) {
              // If translation fails, just leave it as null
              debugPrint('Failed to translate preItem "${extractedItem.preItem}": $e');
              translatedPreItem = null;
            }
          }
        }

        // Generate examples if requested
        List<ExampleSentence> examples = [];
        if (widget.generateExamples) {
          try {
            final exampleMaps = await analysisService.generateExamples(
              text: extractedItem.text,
              sourceLang: widget.sourceLanguage,
              targetLang: widget.targetLanguage,
            );

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
            debugPrint('Failed to generate examples for "${extractedItem.text}": $e');
          }
        }

        // Create item
        final item = Item(
          id: const Uuid().v4(),
          packageId: widget.package.id,
          categoryIds: [category.id],
          language1Data: ItemLanguageData(
            languageCode: widget.package.languageCode1,
            text: isLang1Source ? extractedItem.text : translatedText,
            preItem: isLang1Source ? extractedItem.preItem : translatedPreItem,
            postItem: isLang1Source ? extractedItem.postItem : null,
          ),
          language2Data: ItemLanguageData(
            languageCode: widget.package.languageCode2,
            text: isLang1Source ? translatedText : extractedItem.text,
            preItem: isLang1Source ? translatedPreItem : extractedItem.preItem,
            postItem: isLang1Source ? null : extractedItem.postItem,
          ),
          examples: examples,
          isKnown: false,
          isFavourite: false,
          isImportant: false,
          dontKnowCounter: 0,
          lastReviewedAt: null,
        );

        await _itemRepo.insertItem(item);
      }

      if (mounted) {
        Navigator.of(context).pop(); // Close progress dialog

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.itemsImported),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );

        // Go back to previous page
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop(); // Close progress dialog
        _showDetailedErrorDialog(l10n.errorImportingItems, e.toString());
      }
    } finally {
      if (mounted) {
        setState(() {
          _isImporting = false;
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
            const SizedBox(height: AppTheme.spacing12),
            Text(
              '${l10n.importing} $current / $total',
              style: Theme.of(context).textTheme.bodyMedium,
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

