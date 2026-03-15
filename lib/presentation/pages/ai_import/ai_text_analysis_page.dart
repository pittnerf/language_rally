// lib/presentation/pages/ai_import/ai_text_analysis_page.dart
//
// AI Text Analysis Import - Step 1: Configuration and Text Input
//

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/text_analysis_service.dart';
import '../../../data/models/language_package.dart';
import '../../../data/models/item.dart';
import '../../../data/models/extracted_item.dart';
import '../../../data/repositories/category_repository.dart';
import '../../../data/repositories/item_repository.dart';
import '../../../l10n/app_localizations.dart';
import '../../providers/app_settings_provider.dart';
import '../settings/app_settings_page.dart';
import 'ai_items_selection_page.dart';
import '../../../core/utils/debug_print.dart';

class AITextAnalysisPage extends ConsumerStatefulWidget {
  final LanguagePackage package;

  const AITextAnalysisPage({super.key, required this.package});

  @override
  ConsumerState<AITextAnalysisPage> createState() => _AITextAnalysisPageState();
}

class _AITextAnalysisPageState extends ConsumerState<AITextAnalysisPage> {
  final _textController = TextEditingController();
  final _maxItemsController = TextEditingController();
  final _categoryController = TextEditingController();

  String _selectedLevel = 'A1';
  String _selectedModel = 'gpt-4-turbo';
  bool _extractWords = true;
  bool _extractExpressions = true;
  bool _extractFullItems = false;
  bool _generateExamples = false;
  bool _isAnalyzing = false;
  bool _cancelRequested = false;

  @override
  void initState() {
    super.initState();
    _categoryController.text = 'AI Imported';

    // Load saved model and knowledge level selection
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final settings = ref.read(appSettingsProvider);
      setState(() {
        _selectedModel = settings.openaiModel;
        _selectedLevel = settings.aiKnowledgeLevel;
      });
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _maxItemsController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.aiTextAnalysisImport,
          style: theme.textTheme.titleMedium,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.spacing4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildKnowledgeLevelAndCategorySection(theme, l10n),

              _buildModelSelectionSection(theme, l10n),
              _buildTextInputSection(theme, l10n),
              _buildOptionsAndMaxItemsSection(theme, l10n),

              _buildAnalyzeButton(theme, l10n),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKnowledgeLevelAndCategorySection(
    ThemeData theme,
    AppLocalizations l10n,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600; // Portrait mode on small screens

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing8),
        child: isSmallScreen
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Knowledge Level - Top
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.knowledgeLevel,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      DropdownButtonFormField<String>(
                        initialValue: _selectedLevel,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: AppTheme.spacing8,
                            vertical: AppTheme.spacing8,
                          ),
                        ),
                        style: theme.textTheme.bodyMedium,
                        items: [
                          DropdownMenuItem(
                            value: 'A1',
                            child: Text(l10n.a1Beginner),
                          ),
                          DropdownMenuItem(
                            value: 'A2',
                            child: Text(l10n.a2Elementary),
                          ),
                          DropdownMenuItem(
                            value: 'B1',
                            child: Text(l10n.b1Intermediate),
                          ),
                          DropdownMenuItem(
                            value: 'B2',
                            child: Text(l10n.b2UpperIntermediate),
                          ),
                          DropdownMenuItem(
                            value: 'C1',
                            child: Text(l10n.c1Advanced),
                          ),
                          DropdownMenuItem(
                            value: 'C2',
                            child: Text(l10n.c2Proficient),
                          ),
                        ],
                        onChanged: (value) async {
                          if (value != null) {
                            setState(() {
                              _selectedLevel = value;
                            });
                            // Save knowledge level selection
                            await ref
                                .read(appSettingsProvider.notifier)
                                .setAiKnowledgeLevel(value);
                          }
                        },
                      ),
                    ],
                  ),

                  // Category Name - Bottom
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.categoryName,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      TextField(
                        controller: _categoryController,
                        style: theme.textTheme.bodyMedium,
                        decoration: InputDecoration(
                          hintText: l10n.categoryNameHint,
                          hintStyle: theme.textTheme.bodySmall,
                          border: const OutlineInputBorder(),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: AppTheme.spacing8,
                            vertical: AppTheme.spacing8,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Knowledge Level - Left side
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.knowledgeLevel,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        DropdownButtonFormField<String>(
                          initialValue: _selectedLevel,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: AppTheme.spacing8,
                              vertical: AppTheme.spacing8,
                            ),
                          ),
                          style: theme.textTheme.bodyMedium,
                          items: [
                            DropdownMenuItem(
                              value: 'A1',
                              child: Text(l10n.a1Beginner),
                            ),
                            DropdownMenuItem(
                              value: 'A2',
                              child: Text(l10n.a2Elementary),
                            ),
                            DropdownMenuItem(
                              value: 'B1',
                              child: Text(l10n.b1Intermediate),
                            ),
                            DropdownMenuItem(
                              value: 'B2',
                              child: Text(l10n.b2UpperIntermediate),
                            ),
                            DropdownMenuItem(
                              value: 'C1',
                              child: Text(l10n.c1Advanced),
                            ),
                            DropdownMenuItem(
                              value: 'C2',
                              child: Text(l10n.c2Proficient),
                            ),
                          ],
                          onChanged: (value) async {
                            if (value != null) {
                              setState(() {
                                _selectedLevel = value;
                              });
                              // Save knowledge level selection
                              await ref
                                  .read(appSettingsProvider.notifier)
                                  .setAiKnowledgeLevel(value);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacing8),
                  // Category Name - Right side
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.categoryName,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        TextField(
                          controller: _categoryController,
                          style: theme.textTheme.bodyMedium,
                          decoration: InputDecoration(
                            hintText: l10n.categoryNameHint,
                            hintStyle: theme.textTheme.bodySmall,
                            border: const OutlineInputBorder(),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: AppTheme.spacing8,
                              vertical: AppTheme.spacing8,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildModelSelectionSection(ThemeData theme, AppLocalizations l10n) {
    String getModelDescription(String model) {
      switch (model) {
        case 'gpt-3.5-turbo':
          return l10n.modelGpt35TurboDesc;
        case 'gpt-3.5-turbo-16k':
          return l10n.modelGpt35Turbo16kDesc;
        case 'gpt-4':
          return l10n.modelGpt4Desc;
        case 'gpt-4-turbo':
          return l10n.modelGpt4TurboDesc;
        default:
          return '';
      }
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.openaiModel,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            DropdownButtonFormField<String>(
              initialValue: _selectedModel,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: AppTheme.spacing8,
                  vertical: AppTheme.spacing8,
                ),
              ),
              style: theme.textTheme.bodyMedium,
              items: [
                DropdownMenuItem(
                  value: 'gpt-3.5-turbo',
                  child: Text(l10n.modelGpt35Turbo),
                ),
                DropdownMenuItem(
                  value: 'gpt-3.5-turbo-16k',
                  child: Text(l10n.modelGpt35Turbo16k),
                ),
                DropdownMenuItem(value: 'gpt-4', child: Text(l10n.modelGpt4)),
                DropdownMenuItem(
                  value: 'gpt-4-turbo',
                  child: Text(l10n.modelGpt4Turbo),
                ),
              ],
              onChanged: (value) async {
                if (value != null) {
                  setState(() {
                    _selectedModel = value;
                  });
                  // Save model selection
                  await ref
                      .read(appSettingsProvider.notifier)
                      .setOpenaiModel(value);
                }
              },
            ),
            const SizedBox(height: AppTheme.spacing4),
            Text(
              getModelDescription(_selectedModel),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextInputSection(ThemeData theme, AppLocalizations l10n) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppTheme.spacing8,
          AppTheme.spacing4,
          AppTheme.spacing8,
          AppTheme.spacing8,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.pasteTextHere,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.content_paste, size: 20),
                  tooltip: l10n.pasteFromClipboard,
                  onPressed: _pasteFromClipboard,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacing4),
            TextField(
              controller: _textController,
              maxLines: 9,
              style: theme.textTheme.bodySmall,
              decoration: InputDecoration(
                hintText: l10n.pasteTextHere,
                hintStyle: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.all(AppTheme.spacing8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionsAndMaxItemsSection(
    ThemeData theme,
    AppLocalizations l10n,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600; // Portrait mode on small screens

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.configureAnalysis,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            isSmallScreen
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Checkboxes - Top
                      Transform.translate(
                        offset: const Offset(0, 0),
                        child: CheckboxListTile(
                          title: Text(
                            l10n.extractWords,
                            style: theme.textTheme.bodyMedium,
                          ),
                          value: _extractWords,
                          onChanged: (value) {
                            setState(() {
                              _extractWords = value ?? false;
                              if (_extractWords && _extractFullItems) {
                                _extractFullItems = false;
                              }
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                          visualDensity: const VisualDensity(
                            horizontal: 0,
                            vertical: -4,
                          ),
                        ),
                      ),
                      Transform.translate(
                        offset: const Offset(0, -8),
                        child: CheckboxListTile(
                          title: Text(
                            l10n.extractExpressions,
                            style: theme.textTheme.bodyMedium,
                          ),
                          value: _extractExpressions,
                          onChanged: (value) {
                            setState(() {
                              _extractExpressions = value ?? false;
                              if (_extractExpressions && _extractFullItems) {
                                _extractFullItems = false;
                              }
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                          visualDensity: const VisualDensity(
                            horizontal: 0,
                            vertical: -4,
                          ),
                        ),
                      ),
                      Transform.translate(
                        offset: const Offset(0, -16),
                        child: CheckboxListTile(
                          title: Text(
                            l10n.extractFullItems,
                            style: theme.textTheme.bodyMedium,
                          ),
                          value: _extractFullItems,
                          onChanged: (value) {
                            setState(() {
                              _extractFullItems = value ?? false;
                              if (_extractFullItems) {
                                // Auto-deselect words and expressions
                                _extractWords = false;
                                _extractExpressions = false;
                              }
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                          visualDensity: const VisualDensity(
                            horizontal: 0,
                            vertical: -4,
                          ),
                        ),
                      ),
                      Transform.translate(
                        offset: const Offset(0, -24),
                        child: CheckboxListTile(
                          title: Text(
                            l10n.generateExamples,
                            style: theme.textTheme.bodyMedium,
                          ),
                          value: _generateExamples,
                          onChanged: (value) {
                            setState(() {
                              _generateExamples = value ?? false;
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                          visualDensity: const VisualDensity(
                            horizontal: 0,
                            vertical: -4,
                          ),
                        ),
                      ),
                      // Max Items - Bottom
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.maxItems,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          TextField(
                            controller: _maxItemsController,
                            keyboardType: TextInputType.number,
                            style: theme.textTheme.bodyMedium,
                            decoration: InputDecoration(
                              hintText: l10n.maxItemsHint,
                              hintStyle: theme.textTheme.bodySmall,
                              border: const OutlineInputBorder(),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: AppTheme.spacing8,
                                vertical: AppTheme.spacing8,
                              ),
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                          ),
                        ],
                      ),
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Checkboxes - Left side
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CheckboxListTile(
                              title: Text(
                                l10n.extractWords,
                                style: theme.textTheme.bodyMedium,
                              ),
                              value: _extractWords,
                              onChanged: (value) {
                                setState(() {
                                  _extractWords = value ?? false;
                                  if (_extractWords && _extractFullItems) {
                                    _extractFullItems = false;
                                  }
                                });
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                              contentPadding: EdgeInsets.zero,
                              dense: true,
                              visualDensity: const VisualDensity(
                                horizontal: 0,
                                vertical: -4,
                              ),
                            ),
                            CheckboxListTile(
                              title: Text(
                                l10n.extractExpressions,
                                style: theme.textTheme.bodyMedium,
                              ),
                              value: _extractExpressions,
                              onChanged: (value) {
                                setState(() {
                                  _extractExpressions = value ?? false;
                                  if (_extractExpressions && _extractFullItems) {
                                    _extractFullItems = false;
                                  }
                                });
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                              contentPadding: EdgeInsets.zero,
                              dense: true,
                              visualDensity: const VisualDensity(
                                horizontal: 0,
                                vertical: -4,
                              ),
                            ),
                            CheckboxListTile(
                              title: Text(
                                l10n.extractFullItems,
                                style: theme.textTheme.bodyMedium,
                              ),
                              value: _extractFullItems,
                              onChanged: (value) {
                                setState(() {
                                  _extractFullItems = value ?? false;
                                  if (_extractFullItems) {
                                    // Auto-deselect words and expressions
                                    _extractWords = false;
                                    _extractExpressions = false;
                                  }
                                });
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                              contentPadding: EdgeInsets.zero,
                              dense: true,
                              visualDensity: const VisualDensity(
                                horizontal: 0,
                                vertical: -4,
                              ),
                            ),
                            CheckboxListTile(
                              title: Text(
                                l10n.generateExamples,
                                style: theme.textTheme.bodyMedium,
                              ),
                              value: _generateExamples,
                              onChanged: (value) {
                                setState(() {
                                  _generateExamples = value ?? false;
                                });
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                              contentPadding: EdgeInsets.zero,
                              dense: true,
                              visualDensity: const VisualDensity(
                                horizontal: 0,
                                vertical: -4,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppTheme.spacing8),
                      // Max Items - Right side
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.maxItems,
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            TextField(
                              controller: _maxItemsController,
                              keyboardType: TextInputType.number,
                              style: theme.textTheme.bodyMedium,
                              decoration: InputDecoration(
                                hintText: l10n.maxItemsHint,
                                hintStyle: theme.textTheme.bodySmall,
                                border: const OutlineInputBorder(),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: AppTheme.spacing8,
                                  vertical: AppTheme.spacing8,
                                ),
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalyzeButton(ThemeData theme, AppLocalizations l10n) {
    return ElevatedButton(
      onPressed: _isAnalyzing ? null : _analyzeText,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: AppTheme.spacing8),
      ),
      child: _isAnalyzing
          ? SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: theme.colorScheme.onPrimary,
              ),
            )
          : Text(l10n.analyzeText, style: theme.textTheme.titleSmall),
    );
  }

  Future<void> _pasteFromClipboard() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data != null && data.text != null) {
      setState(() {
        _textController.text = data.text!;
      });
    }
  }

  Future<void> _analyzeText() async {
    final l10n = AppLocalizations.of(context)!;
    final text = _textController.text.trim();

    // Validation
    if (text.isEmpty) {
      _showError(l10n.textCannotBeEmpty);
      return;
    }

    if (!_extractWords && !_extractExpressions && !_extractFullItems) {
      _showError(l10n.selectAtLeastOneType);
      return;
    }

    // Log text details BEFORE processing to verify no truncation
    logDebug('═══════════════════════════════════════════════════════════');
    logDebug('🚀 STARTING AI TEXT ANALYSIS');
    logDebug('═══════════════════════════════════════════════════════════');
    logDebug('TEXT INPUT VERIFICATION:');
    logDebug('  Total characters: ${text.length}');
    logDebug('  Total words: ${text.split(RegExp(r'\s+')).length}');
    logDebug('  First 100 chars: ${text.substring(0, text.length > 100 ? 100 : text.length)}');
    logDebug('  Last 100 chars: ${text.length > 100 ? text.substring(text.length - 100) : "[text too short]"}');
    logDebug('───────────────────────────────────────────────────────────');
    logDebug('SETTINGS:');
    logDebug('  Knowledge Level: $_selectedLevel');
    logDebug('  Extract Words: $_extractWords');
    logDebug('  Extract Expressions: $_extractExpressions');
    logDebug('  Extract Full Items: $_extractFullItems');
    logDebug('  Max Items: ${_maxItemsController.text.isEmpty ? "unlimited" : _maxItemsController.text}');
    logDebug('═══════════════════════════════════════════════════════════');

    // Check text size and warn user if it's very large
    final wordCount = text.split(RegExp(r'\s+')).length;
    if (wordCount > 2000) {
      final shouldContinue = await _showLargeTextWarning(wordCount);
      if (shouldContinue != true) {
        return;
      }
    }

    setState(() {
      _isAnalyzing = true;
      _cancelRequested = false;
    });

    // Keep the screen on during the entire analysis + import flow
    await WakelockPlus.enable();

    logDebug('═══════════════════════════════════════════════════════════');
    logDebug('🔍 STARTING TEXT ANALYSIS');
    logDebug('═══════════════════════════════════════════════════════════');
    logDebug('Text word count: $wordCount');
    logDebug('Knowledge Level: $_selectedLevel');
    logDebug('Extract Words: $_extractWords');
    logDebug('Extract Expressions: $_extractExpressions');
    logDebug('Extract Full Items: $_extractFullItems');
    logDebug('Generate Examples: $_generateExamples');
    logDebug('Model: $_selectedModel');

    try {
      final settings = ref.read(appSettingsProvider);

      // Check if OpenAI API key is configured
      if (settings.openaiApiKey == null ||
          settings.openaiApiKey!.trim().isEmpty) {
        if (mounted) {
          setState(() {
            _isAnalyzing = false;
          });
          _showDetailedErrorDialog(
            l10n.openaiKeyRequired,
            'OpenAI API key is not configured. Please add your API key in Settings.',
          );
        }
        return;
      }

      final analysisService = TextAnalysisService(
        apiKey: settings.openaiApiKey!,
        model: _selectedModel,
      );

      // Show progress dialog - Step 1
      _showProgressDialog(l10n.detectingLanguage, 1, 2);

      // Step 1: Detect language
      logDebug('\n🔤 Step 1: Detecting Language...');
      final detectedLang = await analysisService.detectLanguage(text);
      logDebug('  Detected Language: $detectedLang');

      // Check for cancellation
      if (_cancelRequested) {
        logDebug('  ❌ ANALYSIS CANCELLED BY USER');
        if (mounted) {
          Navigator.of(context).pop(); // Close progress dialog
          setState(() {
            _isAnalyzing = false;
            _cancelRequested = false;
          });
        }
        return;
      }

      // Check if detected language matches package languages
      final lang1Code = widget.package.languageCode1
          .split('-')[0]
          .toLowerCase();
      final lang2Code = widget.package.languageCode2
          .split('-')[0]
          .toLowerCase();

      String sourceLanguage;
      String targetLanguage;

      if (detectedLang == lang1Code) {
        sourceLanguage = widget.package.languageName1;
        targetLanguage = widget.package.languageName2;
      } else if (detectedLang == lang2Code) {
        sourceLanguage = widget.package.languageName2;
        targetLanguage = widget.package.languageName1;
      } else {
        logDebug(
          '  ❌ Language mismatch: $detectedLang not in [$lang1Code, $lang2Code]',
        );
        if (mounted) {
          Navigator.of(context).pop(); // Close progress dialog
          setState(() {
            _isAnalyzing = false;
          });
          _showError(l10n.languageNotMatching);
        }
        return;
      }

      logDebug('  Source Language: $sourceLanguage');
      logDebug('  Target Language: $targetLanguage');

      // Check for cancellation
      if (_cancelRequested) {
        logDebug('  ❌ ANALYSIS CANCELLED BY USER');
        if (mounted) {
          Navigator.of(context).pop(); // Close progress dialog
          setState(() {
            _isAnalyzing = false;
            _cancelRequested = false;
          });
        }
        return;
      }

      // Update progress - Step 2
      if (mounted) {
        Navigator.of(context).pop(); // Close previous dialog
        _showProgressDialog(l10n.extractingItems, 2, 2);
      }

      // Step 2: Extract items
      logDebug('\n📋 Step 2: Extracting Items...');
      final maxItems = _maxItemsController.text.isEmpty
          ? null
          : int.tryParse(_maxItemsController.text);

      logDebug('  Max Items: $maxItems');

      // Extract items with accounting for potential duplicates
      final extractedItems = await _extractItemsWithDuplicateCheck(
        analysisService: analysisService,
        text: text,
        knowledgeLevel: _selectedLevel,
        extractWords: _extractWords,
        extractExpressions: _extractExpressions,
        extractFullItems: _extractFullItems,
        sourceLanguage: sourceLanguage,
        targetLanguage: targetLanguage,
        detectedLang: detectedLang,
        maxItems: maxItems,
      );

      logDebug('  Extracted ${extractedItems.length} unique items');

      // Check for cancellation
      if (_cancelRequested) {
        logDebug('  ❌ ANALYSIS CANCELLED BY USER');
        if (mounted) {
          Navigator.of(context).pop(); // Close progress dialog
          setState(() {
            _isAnalyzing = false;
            _cancelRequested = false;
          });
        }
        return;
      }

      if (mounted) Navigator.of(context).pop(); // Close progress dialog

      if (extractedItems.isEmpty) {
        logDebug('  ⚠️ No items found');
        if (mounted) {
          setState(() {
            _isAnalyzing = false;
          });
          _showError(l10n.noItemsFoundOrAllDuplicates);
        }
        return;
      }

      logDebug('\n✅ ANALYSIS COMPLETED SUCCESSFULLY');
      logDebug('═══════════════════════════════════════════════════════════');

      // Navigate to selection page
      if (mounted) {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => AIItemsSelectionPage(
              package: widget.package,
              extractedItems: extractedItems,
              sourceLanguage: sourceLanguage,
              targetLanguage: targetLanguage,
              detectedLangCode: detectedLang,
              categoryName: _categoryController.text.trim(),
              generateExamples: _generateExamples,
            ),
          ),
        );

        // Don't pop - allow user to stay on AI text analysis page to import more items
      }
    } catch (e) {
      logDebug('\n❌ ERROR DURING ANALYSIS:');
      logDebug(e.toString());
      logDebug('═══════════════════════════════════════════════════════════');

      if (mounted) {
        Navigator.of(context).pop(); // Close progress dialog if open
        _showDetailedErrorDialog(l10n.errorAnalyzingText, e.toString());
      }
    } finally {
      // Re-enable screen lock now that we're done
      await WakelockPlus.disable();

      if (mounted) {
        setState(() {
          _isAnalyzing = false;
          _cancelRequested = false;
        });
      }
    }
  }

  void _showProgressDialog(String message, int currentStep, int totalSteps) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            LinearProgressIndicator(
              value: totalSteps > 0 ? currentStep / totalSteps : 0,
            ),

            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),

            Text(
              'Step $currentStep of $totalSteps',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),

            ElevatedButton(
              onPressed: () {
                setState(() {
                  _cancelRequested = true;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
          ],
        ),
      ),
    );
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
    bool isApiKeyIssue = false;

    if (errorMessage.contains('Invalid API key') ||
        errorMessage.contains('401') ||
        errorMessage.contains('OpenAI API key is required') ||
        errorMessage.contains('not configured')) {
      guidance =
          '• ${l10n.checkApiKey}\n• ${l10n.ensureValidOpenAIKey}\n• ${l10n.verifyKeyInSettings}';
      isApiKeyIssue = true;
    } else if (errorMessage.contains('rate limit') ||
        errorMessage.contains('429')) {
      guidance =
          '• ${l10n.rateLimitExceeded}\n• ${l10n.waitAndRetry}\n• ${l10n.checkAccountQuota}';
    } else if (errorMessage.contains('400') ||
        errorMessage.contains('Bad Request')) {
      guidance =
          '• ${l10n.invalidRequest}\n• ${l10n.tryReducingTextLength}\n• ${l10n.checkTextFormat}';
    } else if (errorMessage.contains('Network error') ||
        errorMessage.contains('Connection')) {
      guidance =
          '• ${l10n.checkInternetConnection}\n• ${l10n.retryInMoment}\n• ${l10n.checkFirewall}';
    } else if (errorMessage.contains('No items found')) {
      guidance =
          '• ${l10n.textMayBeTooShort}\n• ${l10n.tryDifferentKnowledgeLevel}\n• ${l10n.ensureTextInCorrectLanguage}';
    } else if (errorMessage.contains('timeout') ||
        errorMessage.contains('Timeout')) {
      guidance =
          '• ${l10n.requestTimedOut}\n• ${l10n.textMayBeTooLong}\n• ${l10n.tryAgainOrReduceSize}';
    } else {
      guidance =
          '• ${l10n.unexpectedError}\n• ${l10n.checkErrorDetails}\n• ${l10n.tryAgainLater}';
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
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(guidance, style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 16),
              ],
              ExpansionTile(
                title: Text(
                  l10n.technicalDetails,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                initiallyExpanded: false,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: SelectableText(
                      technicalDetails,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(fontFamily: 'monospace'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          if (isApiKeyIssue)
            TextButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AppSettingsPage()),
                );
              },
              icon: const Icon(Icons.settings),
              label: Text(l10n.settings),
            ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.close),
          ),
        ],
      ),
    );
  }

  Future<bool?> _showLargeTextWarning(int wordCount) {
    final l10n = AppLocalizations.of(context)!;
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.warning),
        content: Text(
          '${l10n.textIsVeryLarge} ($wordCount ${l10n.words})\n\n${l10n.continueAnalysis}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.continueLabel),
          ),
        ],
      ),
    );
  }

  /// Extract items with duplicate checking against existing items in the package
  /// If maxItems is specified, ensures we get that many unique items (not counting duplicates)
  Future<List<ExtractedItem>> _extractItemsWithDuplicateCheck({
    required TextAnalysisService analysisService,
    required String text,
    required String knowledgeLevel,
    required bool extractWords,
    required bool extractExpressions,
    required bool extractFullItems,
    required String sourceLanguage,
    required String targetLanguage,
    required String detectedLang,
    int? maxItems,
  }) async {
    // Get existing items in the package to check for duplicates
    final categories = await CategoryRepository().getCategoriesForPackage(widget.package.id);
    final categoryIds = categories.map((c) => c.id).toList();
    final existingItems = categoryIds.isNotEmpty
        ? await ItemRepository().getItemsForCategories(categoryIds)
        : <Item>[];

    logDebug('  Existing items in package: ${existingItems.length}');

    // Determine which language code to check for duplicates
    final lang1Code = widget.package.languageCode1.split('-')[0].toLowerCase();
    final detectedCode = detectedLang.toLowerCase();
    final isLang1Source = detectedCode == lang1Code;

    // Create a set of existing item texts for quick lookup
    final existingTexts = existingItems.map((item) {
      final text = isLang1Source
          ? item.language1Data.text.toLowerCase().trim()
          : item.language2Data.text.toLowerCase().trim();
      return text;
    }).toSet();

    logDebug('  Existing unique texts: ${existingTexts.length}');

    // If no maxItems specified, extract with a reasonable limit and filter duplicates
    if (maxItems == null) {
      final extracted = await analysisService.extractItems(
        text: text,
        knowledgeLevel: knowledgeLevel,
        extractWords: extractWords,
        extractExpressions: extractExpressions,
        extractFullItems: extractFullItems,
        sourceLanguage: sourceLanguage,
        maxItems: null,
      );

      // Filter out duplicates
      final uniqueItems = extracted.where((item) {
        return !existingTexts.contains(item.text.toLowerCase().trim());
      }).toList();

      logDebug('  Extracted: ${extracted.length}, After filtering duplicates: ${uniqueItems.length}');
      return uniqueItems;
    }

    // If maxItems is specified, we need to ensure we get that many UNIQUE items
    // Request more items initially to account for potential duplicates
    final requestMultiplier = 1.5; // Request 50% more to account for duplicates
    final initialRequest = (maxItems * requestMultiplier).ceil();

    logDebug('  Requesting $initialRequest items initially (target: $maxItems unique)');

    final extracted = await analysisService.extractItems(
      text: text,
      knowledgeLevel: knowledgeLevel,
      extractWords: extractWords,
      extractExpressions: extractExpressions,
      extractFullItems: extractFullItems,
      sourceLanguage: sourceLanguage,
      maxItems: initialRequest,
    );

    logDebug('  Extracted: ${extracted.length} items');

    // Filter out duplicates
    final uniqueItems = <ExtractedItem>[];
    for (final item in extracted) {
      final itemText = item.text.toLowerCase().trim();
      if (!existingTexts.contains(itemText)) {
        uniqueItems.add(item);
        // Stop when we reach the desired number
        if (uniqueItems.length >= maxItems) {
          break;
        }
      }
    }

    final duplicateCount = extracted.length - uniqueItems.length;
    logDebug('  Unique items: ${uniqueItems.length}, Duplicates filtered: $duplicateCount');

    // If we still don't have enough unique items, inform the user but return what we have
    if (uniqueItems.length < maxItems) {
      logDebug('  ⚠️ Warning: Only found ${uniqueItems.length} unique items (requested $maxItems)');
      logDebug('  This might be because the text doesn\'t contain enough unique items at this knowledge level');
    }

    return uniqueItems;
  }
}

