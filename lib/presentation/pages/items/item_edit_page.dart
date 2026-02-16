// lib/presentation/pages/items/item_edit_page.dart
//
// Item Edit Page - Full-screen item editing page
//
// FEATURES:
// - Full-screen editing experience
// - Safe area handling for Android system UI
// - Edit preItem, text, postItem for both languages
// - Voice input for text fields (microphone button)
// - Auto-translation between languages
// - AI-powered example generation
// - Category management
// - Real-time validation
//

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:uuid/uuid.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/translation_service.dart';
import '../../../core/services/ai_service.dart';
import '../../../core/services/tts_service.dart';
import '../../../core/services/service_error_messages.dart';
import '../../../data/models/item.dart';
import '../../../data/models/item_language_data.dart';
import '../../../data/models/example_sentence.dart';
import '../../../data/models/category.dart';
import '../../../data/models/language_package.dart';
import '../../../data/repositories/item_repository.dart';
import '../../../data/repositories/category_repository.dart';
import '../../../l10n/app_localizations.dart';
import '../../providers/app_settings_provider.dart';

class ItemEditPage extends ConsumerStatefulWidget {
  final Item item;
  final LanguagePackage package;
  final bool isNewItem;

  const ItemEditPage({
    super.key,
    required this.item,
    required this.package,
    this.isNewItem = false,
  });

  /// Named constructor for creating a new item
  factory ItemEditPage.newItem({
    required LanguagePackage package,
  }) {
    // Create a new item with empty data
    final newItem = Item(
      id: const Uuid().v4(),
      packageId: package.id,
      categoryIds: const [],
      language1Data: ItemLanguageData(
        languageCode: package.languageCode1,
        preItem: '',
        text: '',
        postItem: '',
      ),
      language2Data: ItemLanguageData(
        languageCode: package.languageCode2,
        preItem: '',
        text: '',
        postItem: '',
      ),
      examples: const [],
      isKnown: false,
      isFavourite: false,
      isImportant: false,
      dontKnowCounter: 0,
      lastReviewedAt: null,
    );

    return ItemEditPage(
      item: newItem,
      package: package,
      isNewItem: true,
    );
  }

  @override
  ConsumerState<ItemEditPage> createState() => _ItemEditPageState();
}

class _ItemEditPageState extends ConsumerState<ItemEditPage> {
  final _formKey = GlobalKey<FormState>();
  final _itemRepo = ItemRepository();
  final _categoryRepo = CategoryRepository();
  final _ttsService = TtsService();
  late TranslationService _translationService;
  late AIService _aiService;

  // Speech recognition
  late stt.SpeechToText _speech;
  bool _speechAvailable = false;
  bool _isListening = false;

  // Language 1 controllers
  late TextEditingController _preItem1Controller;
  late TextEditingController _text1Controller;
  late TextEditingController _postItem1Controller;

  // Language 2 controllers
  late TextEditingController _preItem2Controller;
  late TextEditingController _text2Controller;
  late TextEditingController _postItem2Controller;

  bool _isSaving = false;
  bool _isTranslating = false;
  bool _isGeneratingExamples = false;

  // Status flags
  late bool _isKnown;
  late bool _isFavourite;
  late bool _isImportant;

  // Categories
  List<Category> _allCategories = [];
  List<String> _itemCategoryIds = [];

  List<ExampleSentence> _generatedExamples = [];

  @override
  void initState() {
    super.initState();
    _ttsService.initialize();
    _initializeControllers();
    _initializeSpeechRecognition();
    _isKnown = widget.item.isKnown;
    _isFavourite = widget.item.isFavourite;
    _isImportant = widget.item.isImportant;
    _itemCategoryIds = List.from(widget.item.categoryIds);
    _loadCategories();
  }

  Future<void> _initializeSpeechRecognition() async {
    _speech = stt.SpeechToText();
    try {
      _speechAvailable = await _speech.initialize(
        onStatus: (status) {
          if (mounted) {
            setState(() {
              _isListening = status == 'listening';
            });
          }
        },
        onError: (error) {
          if (mounted) {
            setState(() {
              _isListening = false;
            });
          }
        },
      );
    } catch (e) {
      _speechAvailable = false;
    }
  }

  void _initializeControllers() {
    _preItem1Controller = TextEditingController(text: widget.item.language1Data.preItem ?? '');
    _text1Controller = TextEditingController(text: widget.item.language1Data.text);
    _postItem1Controller = TextEditingController(text: widget.item.language1Data.postItem ?? '');

    _preItem2Controller = TextEditingController(text: widget.item.language2Data.preItem ?? '');
    _text2Controller = TextEditingController(text: widget.item.language2Data.text);
    _postItem2Controller = TextEditingController(text: widget.item.language2Data.postItem ?? '');
  }

  Future<void> _loadCategories() async {
    try {
      final categories = await _categoryRepo.getCategoriesForPackage(widget.package.id);
      if (mounted) {
        setState(() {
          _allCategories = categories;
        });
      }
    } catch (e) {
      // Handle error silently or show message
    }
  }

  @override
  void dispose() {
    _ttsService.stop();
    _preItem1Controller.dispose();
    _text1Controller.dispose();
    _postItem1Controller.dispose();
    _preItem2Controller.dispose();
    _text2Controller.dispose();
    _postItem2Controller.dispose();

    // Stop and dispose speech recognition
    if (_isListening) {
      _speech.stop();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final appSettings = ref.watch(appSettingsProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 1000;

    // Initialize services with API keys from settings and localized error messages
    final errorMessages = ServiceErrorMessages(l10n);
    _translationService = TranslationService(
      deeplApiKey: appSettings.deeplApiKey,
      errorMessages: errorMessages,
    );
    _aiService = AIService(
      apiKey: appSettings.openaiApiKey,
      errorMessages: errorMessages,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isNewItem ? l10n.addNewItem : l10n.editItem,
          style: theme.textTheme.titleMedium,
        ),
        actions: [
          if (_isSaving)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _saveItem,
              tooltip: l10n.save,
            ),
        ],
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppTheme.spacing16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isTablet)
                  // Tablet layout - horizontal
                  ..._buildTabletLayout(theme)
                else
                  // Phone layout - vertical
                  ..._buildPhoneLayout(theme),

                const SizedBox(height: AppTheme.spacing24),

                // AI Example Generation Section
                _buildExampleGenerationSection(theme),

                const SizedBox(height: AppTheme.spacing16),

                // API Key Information Message
                _buildApiKeyInfoMessage(theme, appSettings),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildTabletLayout(ThemeData theme) {
    final l10n = AppLocalizations.of(context)!;

    return [
      // Language sections in a row
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _buildLanguageSection(
              theme: theme,
              languageName: widget.package.languageName1,
              languageCode: widget.package.languageCode1,
              preItemController: _preItem1Controller,
              textController: _text1Controller,
              postItemController: _postItem1Controller,
              isLanguage1: true,
              minLines: 3,
            ),
          ),
          const SizedBox(width: AppTheme.spacing16),
          Expanded(
            child: _buildLanguageSection(
              theme: theme,
              languageName: widget.package.languageName2,
              languageCode: widget.package.languageCode2,
              preItemController: _preItem2Controller,
              textController: _text2Controller,
              postItemController: _postItem2Controller,
              isLanguage1: false,
              minLines: 3,
            ),
          ),
        ],
      ),
      const SizedBox(height: AppTheme.spacing16),

      // Translation buttons in a row
      _buildTranslationButtonsTablet(theme),

      const SizedBox(height: AppTheme.spacing16),

      // Status and Categories in one row
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: _buildStatusIndicators(theme, l10n),
          ),
          const SizedBox(width: AppTheme.spacing16),
          Expanded(
            flex: 1,
            child: _buildCategoriesSection(theme, l10n),
          ),
        ],
      ),
    ];
  }

  List<Widget> _buildPhoneLayout(ThemeData theme) {
    final l10n = AppLocalizations.of(context)!;

    return [
      // Language 1 section
      _buildLanguageSection(
        theme: theme,
        languageName: widget.package.languageName1,
        languageCode: widget.package.languageCode1,
        preItemController: _preItem1Controller,
        textController: _text1Controller,
        postItemController: _postItem1Controller,
        isLanguage1: true,
        minLines: 2,
      ),
      const SizedBox(height: AppTheme.spacing16),

      // Translation buttons in a row (compact)
      _buildTranslationButtonsPhone(theme),
      const SizedBox(height: AppTheme.spacing16),

      // Language 2 section
      _buildLanguageSection(
        theme: theme,
        languageName: widget.package.languageName2,
        languageCode: widget.package.languageCode2,
        preItemController: _preItem2Controller,
        textController: _text2Controller,
        postItemController: _postItem2Controller,
        isLanguage1: false,
        minLines: 2,
      ),

      const SizedBox(height: AppTheme.spacing16),

      // Status and Categories in one row
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: _buildStatusIndicators(theme, l10n),
          ),
          const SizedBox(width: AppTheme.spacing8),
          Expanded(
            flex: 1,
            child: _buildCategoriesSection(theme, l10n),
          ),
        ],
      ),
    ];
  }

  Widget _buildLanguageSection({
    required ThemeData theme,
    required String languageName,
    required String languageCode,
    required TextEditingController preItemController,
    required TextEditingController textController,
    required TextEditingController postItemController,
    required bool isLanguage1,
    required int minLines,
  }) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Language name header
            Row(
              children: [
                Icon(Icons.language, size: 20, color: theme.colorScheme.primary),
                const SizedBox(width: AppTheme.spacing8),
                Text(
                  languageName,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(Icons.volume_up, size: 20, color: theme.colorScheme.primary),
                  tooltip: 'Speak text',
                  onPressed: () {
                    final preText = preItemController.text.trim();
                    final mainText = textController.text.trim();

                    if (mainText.isEmpty) {
                      return;
                    }

                    // Combine preText + mainText (excluding postText)
                    final fullText = '${preText.isNotEmpty ? "$preText " : ""}$mainText';

                    _ttsService.speak(fullText, languageCode);
                  },
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacing12),

            // PreItem field
            TextFormField(
              controller: preItemController,
              style: theme.textTheme.bodySmall,
              decoration: InputDecoration(
                labelText: l10n.preTextOptional,
                hintText: l10n.forExampleToForVerbs,
              ),
            ),
            const SizedBox(height: AppTheme.spacing8),

            // Main text field with voice input - multi-line, dynamic height
            TextFormField(
              controller: textController,
              style: theme.textTheme.bodyMedium,
              minLines: minLines,
              maxLines: null, // Grows with content
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                labelText: '${l10n.mainText} *',
                suffixIcon: IconButton(
                  icon: _isListening
                      ? const Icon(Icons.mic, size: 20, color: Colors.red)
                      : const Icon(Icons.mic, size: 20),
                  tooltip: l10n.voiceInput,
                  onPressed: () => _startVoiceInput(textController, languageCode),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return l10n.fieldRequired;
                }
                return null;
              },
            ),
            const SizedBox(height: AppTheme.spacing8),

            // PostItem field
            TextFormField(
              controller: postItemController,
              style: theme.textTheme.bodySmall,
              decoration: InputDecoration(
                labelText: l10n.postTextOptional,
                hintText: l10n.additionalContext,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTranslationButtonsTablet(ThemeData theme) {
    final l10n = AppLocalizations.of(context)!;

    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _isTranslating ? null : () => _translate(true),
            icon: _isTranslating
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.arrow_forward, size: 16),
            label: Text(
              l10n.translateFromTo(widget.package.languageName1, widget.package.languageName2),
              style: theme.textTheme.bodySmall,
            ),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacing12,
                vertical: AppTheme.spacing12,
              ),
              side: BorderSide(
                color: theme.colorScheme.outline.withValues(alpha: 0.5),
              ),
            ),
          ),
        ),
        const SizedBox(width: AppTheme.spacing16),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _isTranslating ? null : () => _translate(false),
            icon: _isTranslating
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.arrow_back, size: 16),
            label: Text(
              l10n.translateFromTo(widget.package.languageName2, widget.package.languageName1),
              style: theme.textTheme.bodySmall,
            ),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacing12,
                vertical: AppTheme.spacing12,
              ),
              side: BorderSide(
                color: theme.colorScheme.outline.withValues(alpha: 0.5),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTranslationButtonsPhone(ThemeData theme) {
    final l10n = AppLocalizations.of(context)!;

    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _isTranslating ? null : () => _translate(true),
            icon: _isTranslating
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.arrow_downward, size: 16),
            label: Text(
              l10n.translate,
              style: theme.textTheme.bodySmall,
            ),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacing12,
                vertical: AppTheme.spacing8,
              ),
              side: BorderSide(
                color: theme.colorScheme.outline.withValues(alpha: 0.5),
              ),
            ),
          ),
        ),
        const SizedBox(width: AppTheme.spacing8),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _isTranslating ? null : () => _translate(false),
            icon: _isTranslating
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.arrow_upward, size: 16),
            label: Text(
              l10n.translate,
              style: theme.textTheme.bodySmall,
            ),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacing12,
                vertical: AppTheme.spacing8,
              ),
              side: BorderSide(
                color: theme.colorScheme.outline.withValues(alpha: 0.5),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildExampleGenerationSection(ThemeData theme) {
    final l10n = AppLocalizations.of(context)!;
    final currentText = _text1Controller.text.trim();

    return Card(
      elevation: 1,
      color: theme.colorScheme.secondaryContainer.withValues(alpha: 0.1),
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.auto_awesome, size: 20, color: theme.colorScheme.secondary),
                const SizedBox(width: AppTheme.spacing8),
                Text(
                  l10n.aiExampleSearch,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.secondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacing8),
            Text(
              currentText.isEmpty
                  ? l10n.generateExampleSentences(widget.package.languageName1)
                  : l10n.searchExamplesOnInternet(currentText),
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: AppTheme.spacing12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _isGeneratingExamples || currentText.isEmpty
                    ? null
                    : _generateExamples,
                icon: _isGeneratingExamples
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.search, size: 18),
                label: Text(
                  l10n.generateExamples,
                  style: theme.textTheme.bodySmall,
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacing12,
                    vertical: AppTheme.spacing12,
                  ),
                  side: BorderSide(
                    color: theme.colorScheme.outline.withValues(alpha: 0.5),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildApiKeyInfoMessage(ThemeData theme, dynamic appSettings) {
    final l10n = AppLocalizations.of(context)!;

    // Check if API keys are configured
    final hasDeepL = appSettings.deeplApiKey != null && appSettings.deeplApiKey!.isNotEmpty;
    final hasOpenAI = appSettings.openaiApiKey != null && appSettings.openaiApiKey!.isNotEmpty;
    final hasAnyKey = hasDeepL || hasOpenAI;

    return Card(
      elevation: 1,
      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              hasAnyKey ? Icons.info_outline : Icons.lightbulb_outline,
              size: 20,
              color: hasAnyKey
                  ? theme.colorScheme.primary
                  : theme.colorScheme.tertiary,
            ),
            const SizedBox(width: AppTheme.spacing8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.improveQualityWithApiKeys,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacing8),
                  // Show status of current configuration
                  Wrap(
                    spacing: AppTheme.spacing8,
                    runSpacing: AppTheme.spacing4,
                    children: [
                      _buildApiStatusChip(
                        theme,
                        'DeepL',
                        hasDeepL,
                      ),
                      _buildApiStatusChip(
                        theme,
                        'OpenAI',
                        hasOpenAI,
                      ),
                    ],
                  ),
                  if (!hasAnyKey) ...[
                    const SizedBox(height: AppTheme.spacing8),
                    Text(
                      l10n.noApiKeyFallbackMessage,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontSize: (theme.textTheme.bodySmall?.fontSize ?? 12) * 0.9,
                      ),
                    ),
                  ],
                  const SizedBox(height: AppTheme.spacing8),
                  InkWell(
                    onTap: () {
                      // Navigate to settings
                      Navigator.of(context).pushNamed('/settings');
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.settings,
                          size: 14,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: AppTheme.spacing4),
                        Text(
                          l10n.settings,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
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

  Widget _buildApiStatusChip(ThemeData theme, String serviceName, bool isConfigured) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacing8,
        vertical: AppTheme.spacing4,
      ),
      decoration: BoxDecoration(
        color: isConfigured
            ? theme.colorScheme.primaryContainer
            : theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
        border: Border.all(
          color: isConfigured
              ? theme.colorScheme.primary.withValues(alpha: 0.3)
              : theme.colorScheme.outline.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isConfigured ? Icons.check_circle : Icons.cancel,
            size: 12,
            color: isConfigured
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: AppTheme.spacing4),
          Text(
            serviceName,
            style: theme.textTheme.bodySmall?.copyWith(
              fontSize: (theme.textTheme.bodySmall?.fontSize ?? 12) * 0.85,
              color: isConfigured
                  ? theme.colorScheme.onPrimaryContainer
                  : theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusIndicators(ThemeData theme, AppLocalizations l10n) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Status',
              style: theme.textTheme.titleSmall?.copyWith(
                fontSize: (theme.textTheme.titleSmall?.fontSize ?? 14) * 0.85,
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppTheme.spacing8),
            Wrap(
              spacing: AppTheme.spacing8,
              runSpacing: AppTheme.spacing8,
              children: [
                // Known status
                FilterChip(
                  selected: _isKnown,
                  label: Text(
                    l10n.known,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontSize: (theme.textTheme.bodySmall?.fontSize ?? 12) * 0.85,
                    ),
                  ),
                  avatar: Icon(
                    _isKnown ? Icons.check_circle : Icons.check_circle_outline,
                    size: 18,
                    color: _isKnown ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
                  ),
                  onSelected: (value) {
                    setState(() {
                      _isKnown = value;
                    });
                  },
                ),
                // Favourite status
                FilterChip(
                  selected: _isFavourite,
                  label: Text(
                    l10n.favourite,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontSize: (theme.textTheme.bodySmall?.fontSize ?? 12) * 0.85,
                    ),
                  ),
                  avatar: Icon(
                    _isFavourite ? Icons.star : Icons.star_outline,
                    size: 18,
                    color: _isFavourite ? theme.colorScheme.tertiary : theme.colorScheme.onSurfaceVariant,
                  ),
                  onSelected: (value) {
                    setState(() {
                      _isFavourite = value;
                    });
                  },
                ),
                // Important status
                FilterChip(
                  selected: _isImportant,
                  label: Text(
                    l10n.important,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontSize: (theme.textTheme.bodySmall?.fontSize ?? 12) * 0.85,
                    ),
                  ),
                  avatar: Icon(
                    _isImportant ? Icons.label_important : Icons.label_important_outline,
                    size: 18,
                    color: _isImportant ? theme.colorScheme.secondary : theme.colorScheme.onSurfaceVariant,
                  ),
                  onSelected: (value) {
                    setState(() {
                      _isImportant = value;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoriesSection(ThemeData theme, AppLocalizations l10n) {
    final itemCategories = _allCategories
        .where((cat) => _itemCategoryIds.contains(cat.id))
        .toList();

    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.categories,
              style: theme.textTheme.titleSmall?.copyWith(
                fontSize: (theme.textTheme.titleSmall?.fontSize ?? 14) * 0.85,
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppTheme.spacing8),
            Wrap(
              spacing: AppTheme.spacing8,
              runSpacing: AppTheme.spacing8,
              children: [
                // Category chips
                ...itemCategories.map((category) {
                  return GestureDetector(
                    onTap: () => _confirmRemoveCategory(category),
                    child: Chip(
                      avatar: Icon(
                        Icons.label,
                        size: 16,
                        color: theme.colorScheme.primary,
                      ),
                      label: Text(
                        category.name,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: (theme.textTheme.bodySmall?.fontSize ?? 12) * 0.85,
                        ),
                      ),
                      backgroundColor: theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      labelPadding: const EdgeInsets.symmetric(horizontal: 4),
                    ),
                  );
                }),
                // Add category button
                ActionChip(
                  avatar: Icon(
                    Icons.add,
                    size: 16,
                    color: theme.colorScheme.primary,
                  ),
                  label: const Text(''),
                  padding: const EdgeInsets.all(0),
                  labelPadding: const EdgeInsets.all(0),
                  visualDensity: VisualDensity.compact,
                  backgroundColor: theme.colorScheme.primaryContainer,
                  onPressed: _showAddCategoryDialog,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmRemoveCategory(Category category) async {
    final l10n = AppLocalizations.of(context)!;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Category'),
        content: Text('Remove category "${category.name}" from this item?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Remove'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() {
        _itemCategoryIds.remove(category.id);
      });
    }
  }

  Future<void> _showAddCategoryDialog() async {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;

    // Get categories not already assigned to this item
    final availableCategories = _allCategories
        .where((cat) => !_itemCategoryIds.contains(cat.id))
        .toList();

    final TextEditingController categoryController = TextEditingController();
    Category? selectedCategory;

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          titlePadding: const EdgeInsets.fromLTRB(
            AppTheme.spacing12,
            AppTheme.spacing12,
            AppTheme.spacing12,
            AppTheme.spacing8,
          ),
          contentPadding: const EdgeInsets.fromLTRB(
            AppTheme.spacing12,
            AppTheme.spacing8,
            AppTheme.spacing12,
            AppTheme.spacing8,
          ),
          actionsPadding: const EdgeInsets.fromLTRB(
            AppTheme.spacing12,
            AppTheme.spacing8,
            AppTheme.spacing12,
            AppTheme.spacing12,
          ),
          title: Text(
            'Add Category',
            style: theme.textTheme.titleSmall,
          ),
          content: SizedBox(
            width: screenWidth * 0.25,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select existing or create new category:',
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: AppTheme.spacing8),

                // Autocomplete for category selection/creation
                Autocomplete<Category>(
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    if (textEditingValue.text.isEmpty) {
                      return availableCategories;
                    }
                    return availableCategories.where((category) {
                      return category.name
                          .toLowerCase()
                          .contains(textEditingValue.text.toLowerCase());
                    });
                  },
                  displayStringForOption: (Category option) => option.name,
                  fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
                    categoryController.text = textEditingController.text;
                    textEditingController.addListener(() {
                      categoryController.text = textEditingController.text;
                    });

                    return TextField(
                      controller: textEditingController,
                      focusNode: focusNode,
                      style: theme.textTheme.bodySmall,
                      decoration: InputDecoration(
                        hintText: 'Type to search or create new...',
                        prefixIcon: const Icon(Icons.search, size: 18),
                      ),
                    );
                  },
                  optionsViewBuilder: (context, onSelected, options) {
                    return Align(
                      alignment: Alignment.topLeft,
                      child: Material(
                        elevation: 4.0,
                        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxHeight: 150, maxWidth: 150),
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemCount: options.length,
                            itemBuilder: (context, index) {
                              final option = options.elementAt(index);
                              return ListTile(
                                dense: true,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: AppTheme.spacing8,
                                  vertical: AppTheme.spacing4,
                                ),
                                leading: const Icon(Icons.label_outline, size: 18),
                                title: Text(
                                  option.name,
                                  style: theme.textTheme.bodySmall,
                                ),
                                onTap: () => onSelected(option),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                  onSelected: (Category selection) {
                    setDialogState(() {
                      selectedCategory = selection;
                      categoryController.text = selection.name;
                    });
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.cancel),
            ),
            ElevatedButton(
              onPressed: () async {
                final categoryName = categoryController.text.trim();
                if (categoryName.isEmpty) {
                  return;
                }

                Category categoryToAdd;

                if (selectedCategory != null && selectedCategory!.name == categoryName) {
                  // Use existing category
                  categoryToAdd = selectedCategory!;
                } else {
                  // Create new category
                  categoryToAdd = Category(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    packageId: widget.package.id,
                    name: categoryName,
                  );
                  await _categoryRepo.insertCategory(categoryToAdd);
                  await _loadCategories();
                }

                setState(() {
                  _itemCategoryIds.add(categoryToAdd.id);
                });

                if (mounted) {
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  /// Starts voice input for the given text controller using speech recognition.
  /// The recognition uses the specified language code (e.g., 'en-US', 'hu-HU').
  /// Shows visual feedback during listening and displays the recognized text.
  Future<void> _startVoiceInput(TextEditingController controller, String languageCode) async {
    final l10n = AppLocalizations.of(context)!;

    // Check if speech recognition is available
    if (!_speechAvailable) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.speechRecognitionNotAvailable),
          backgroundColor: Theme.of(context).colorScheme.error,
          duration: const Duration(seconds: 3),
        ),
      );
      return;
    }

    // If already listening, stop
    if (_isListening) {
      await _speech.stop();
      setState(() => _isListening = false);
      return;
    }

    // Show listening indicator
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            const SizedBox(width: 12),
            Text(l10n.listeningForSpeech),
          ],
        ),
        duration: const Duration(seconds: 30),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );

    // Start listening
    try {
      await _speech.listen(
        onResult: (result) {
          if (result.finalResult) {
            setState(() {
              controller.text = result.recognizedWords;
              _isListening = false;
            });

            // Hide the listening snackbar
            if (mounted) {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();

              // Show success message
              if (result.recognizedWords.isNotEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('✓ ${result.recognizedWords}'),
                    backgroundColor: Colors.green,
                    duration: const Duration(seconds: 2),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l10n.speechNotRecognized),
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            }
          }
        },
        localeId: languageCode,
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 3),
        listenOptions: stt.SpeechListenOptions(
          partialResults: false,
          cancelOnError: true,
          listenMode: stt.ListenMode.confirmation,
        ),
      );

      setState(() => _isListening = true);
    } catch (e) {
      setState(() => _isListening = false);

      // Hide the listening snackbar and show error
      if (!mounted) return;

      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      String errorMessage = l10n.speechRecognitionError;
      if (e.toString().contains('permission')) {
        errorMessage = l10n.speechRecognitionPermissionDenied;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$errorMessage: $e'),
          backgroundColor: Theme.of(context).colorScheme.error,
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  Future<void> _translate(bool fromLang1ToLang2) async {
    final l10n = AppLocalizations.of(context)!;

    // Get source and target text
    final sourceText = fromLang1ToLang2
        ? _text1Controller.text.trim()
        : _text2Controller.text.trim();

    if (sourceText.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.pleaseEnterTextInLanguageFirst(
                fromLang1ToLang2 ? widget.package.languageName1 : widget.package.languageName2)),
          ),
        );
      }
      return;
    }

    setState(() => _isTranslating = true);

    try {
      final translatedText = await _translationService.translateText(
        text: sourceText,
        sourceLang: fromLang1ToLang2
            ? widget.package.languageCode1
            : widget.package.languageCode2,
        targetLang: fromLang1ToLang2
            ? widget.package.languageCode2
            : widget.package.languageCode1,
      );

      if (mounted) {
        setState(() {
          if (fromLang1ToLang2) {
            _text2Controller.text = translatedText;
          } else {
            _text1Controller.text = translatedText;
          }
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.translationCompletedSuccessfully(_translationService.getServiceName())),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.translationFailed}: ${e.toString().replaceAll('Exception: ', '')}'),
            backgroundColor: Theme.of(context).colorScheme.error,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isTranslating = false);
      }
    }
  }

  Future<void> _generateExamples() async {
    final l10n = AppLocalizations.of(context)!;

    // Check if API is configured
    if (!_aiService.isConfigured()) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.aiServiceNotConfigured),
            duration: const Duration(seconds: 4),
          ),
        );
      }
      return;
    }

    final text = _text1Controller.text.trim();
    if (text.isEmpty) {
      return;
    }

    setState(() => _isGeneratingExamples = true);

    try {
      final examples = await _aiService.generateExamples(
        text: text,
        language1Name: widget.package.languageName1,
        language2Name: widget.package.languageName2,
        language1Code: widget.package.languageCode1,
        language2Code: widget.package.languageCode2,
      );

      if (mounted) {
        setState(() {
          _generatedExamples = examples;
        });

        // Show selection dialog
        final selectedExamples = await _showExampleSelectionDialog(examples);

        if (selectedExamples != null && selectedExamples.isNotEmpty) {
          // Add selected examples to the item
          final updatedExamples = [...widget.item.examples, ...selectedExamples];

          // Update the item with new examples
          final updatedItem = widget.item.copyWith(examples: updatedExamples);
          await _itemRepo.updateItem(updatedItem);

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l10n.addedExamplesSuccessfully(selectedExamples.length)),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 2),
              ),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.failedToGenerateExamples}: ${e.toString().replaceAll('Exception: ', '')}'),
            backgroundColor: Theme.of(context).colorScheme.error,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isGeneratingExamples = false);
      }
    }
  }

  /// Show dialog for selecting which examples to add
  Future<List<ExampleSentence>?> _showExampleSelectionDialog(List<ExampleSentence> examples) async {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final selectedExamples = <int, bool>{};

    // Initialize all as selected
    for (int i = 0; i < examples.length; i++) {
      selectedExamples[i] = true;
    }

    return await showDialog<List<ExampleSentence>>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Row(
            children: [
              Icon(Icons.lightbulb_outline, color: theme.colorScheme.secondary),
              const SizedBox(width: AppTheme.spacing8),
              Text(l10n.selectExamplesToAdd),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.selectWhichExamples,
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: AppTheme.spacing12),
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: examples.length,
                    itemBuilder: (context, index) {
                      final example = examples[index];
                      final isSelected = selectedExamples[index] ?? false;

                      return Card(
                        margin: const EdgeInsets.only(bottom: AppTheme.spacing8),
                        color: isSelected
                            ? theme.colorScheme.primaryContainer.withValues(alpha: 0.3)
                            : null,
                        child: CheckboxListTile(
                          dense: true,
                          value: isSelected,
                          onChanged: (value) {
                            setDialogState(() {
                              selectedExamples[index] = value ?? false;
                            });
                          },
                          title: Text(
                            example.textLanguage1,
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: AppTheme.spacing4),
                            child: Text(
                              example.textLanguage2,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(null),
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () {
                // Select/Deselect all
                final allSelected = selectedExamples.values.every((v) => v);
                setDialogState(() {
                  for (int i = 0; i < examples.length; i++) {
                    selectedExamples[i] = !allSelected;
                  }
                });
              },
              child: Text(
                selectedExamples.values.every((v) => v) ? l10n.deselectAll : l10n.selectAll,
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                final selected = <ExampleSentence>[];
                selectedExamples.forEach((index, isSelected) {
                  if (isSelected && index < examples.length) {
                    selected.add(examples[index]);
                  }
                });

                if (selected.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.pleaseSelectAtLeastOne),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                } else {
                  Navigator.of(context).pop(selected);
                }
              },
              icon: const Icon(Icons.add, size: 18),
              label: Text('${l10n.addSelected} (${selectedExamples.values.where((v) => v).length})'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveItem() async {
    final l10n = AppLocalizations.of(context)!;

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isSaving = true);

    try {
      final updatedItem = widget.item.copyWith(
        language1Data: ItemLanguageData(
          languageCode: widget.item.language1Data.languageCode,
          text: _text1Controller.text.trim(),
          preItem: _preItem1Controller.text.trim().isEmpty ? null : _preItem1Controller.text.trim(),
          postItem: _postItem1Controller.text.trim().isEmpty ? null : _postItem1Controller.text.trim(),
        ),
        language2Data: ItemLanguageData(
          languageCode: widget.item.language2Data.languageCode,
          text: _text2Controller.text.trim(),
          preItem: _preItem2Controller.text.trim().isEmpty ? null : _preItem2Controller.text.trim(),
          postItem: _postItem2Controller.text.trim().isEmpty ? null : _postItem2Controller.text.trim(),
        ),
        isKnown: _isKnown,
        isFavourite: _isFavourite,
        isImportant: _isImportant,
        categoryIds: _itemCategoryIds,
      );

      await _itemRepo.updateItem(updatedItem);

      if (mounted) {
        Navigator.of(context).pop(true); // Return true to indicate success
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.isNewItem ? l10n.itemCreated : l10n.itemSaved),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.errorSavingItem}: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }
}

