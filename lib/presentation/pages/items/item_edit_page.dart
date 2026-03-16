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

import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:uuid/uuid.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/translation_service.dart';
import '../../../core/services/ai_service.dart';
import '../../../core/services/tts_service.dart';
import '../../../core/services/service_error_messages.dart';
import '../../../core/services/speech_recognition_service.dart';
import '../../../core/utils/debug_print.dart';
import '../../../data/models/item.dart';
import '../../../data/models/item_language_data.dart';
import '../../../data/models/example_sentence.dart';
import '../../../data/models/category.dart';
import '../../../data/models/language_package.dart';
import '../../../data/repositories/item_repository.dart';
import '../../widgets/clickable_text.dart';
import '../../../data/repositories/category_repository.dart';
import '../../../l10n/app_localizations.dart';
import '../../providers/app_settings_provider.dart';
import '../settings/app_settings_page.dart';

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

  // Audio recording for Whisper API fallback
  final _audioRecorder = AudioRecorder();
  SpeechRecognitionService? _speechRecognitionService;
  bool _useWhisperAPI = false;
  final Map<String, bool> _languageAvailability = {};
  DateTime? _recordingStartTime;

  // Language 1 controllers
  late TextEditingController _preItem1Controller;
  late TextEditingController _text1Controller;
  late TextEditingController _postItem1Controller;

  // Language 2 controllers
  late TextEditingController _preItem2Controller;
  late TextEditingController _text2Controller;
  late TextEditingController _postItem2Controller;

  // Examples controller
  // Example management - each example has two controllers (language1 and language2)
  final List<Map<String, TextEditingController>> _exampleControllers = [];

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


  @override
  void initState() {
    super.initState();
    _ttsService.initialize();
    _initializeControllers();

    // Use post-frame callback to ensure settings are loaded before initializing speech recognition
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      logDebug('📍 ItemEditPage: postFrameCallback executing...');

      final currentSettings = ref.read(appSettingsProvider);
      logDebug('📊 Current settings state at postFrameCallback:');
      logDebug('   - openaiApiKey present: ${currentSettings.openaiApiKey != null && currentSettings.openaiApiKey!.isNotEmpty}');
      if (currentSettings.openaiApiKey != null && currentSettings.openaiApiKey!.isNotEmpty) {
        logDebug('   - openaiApiKey length: ${currentSettings.openaiApiKey!.length}');
      }

      logDebug('🚀 Calling _initializeSpeechRecognition()...');
      await _initializeSpeechRecognition();
      logDebug('✅ Initial speech recognition setup complete');
    });

    _isKnown = widget.item.isKnown;
    _isFavourite = widget.item.isFavourite;
    _isImportant = widget.item.isImportant;
    _itemCategoryIds = List.from(widget.item.categoryIds);
    _loadCategories();
  }

  Future<void> _initializeSpeechRecognition() async {
    _speech = stt.SpeechToText();

    logDebug('═══════════════════════════════════════════════════════════');
    logDebug('🎤 Initializing Speech Recognition for Item Edit Page');
    logDebug('═══════════════════════════════════════════════════════════');

    // Check if OpenAI API key is available for Whisper fallback
    final settings = ref.read(appSettingsProvider);
    final openaiApiKey = settings.openaiApiKey;

    logDebug('📊 Settings provider state:');
    logDebug('   - OpenAI API Key: ${openaiApiKey != null ? (openaiApiKey.isNotEmpty ? "present (${openaiApiKey.length} chars)" : "empty") : "null"}');

    if (openaiApiKey != null && openaiApiKey.isNotEmpty) {
      logDebug('✓ OpenAI API key available - Whisper API can be used as fallback');
      logDebug('   First 10 chars: ${openaiApiKey.substring(0, openaiApiKey.length > 10 ? 10 : openaiApiKey.length)}...');
      _speechRecognitionService = SpeechRecognitionService(apiKey: openaiApiKey);
      logDebug('✓ SpeechRecognitionService created');
    } else {
      logDebug('❌ No OpenAI API key - Whisper API fallback not available');
    }

    try {
      _speechAvailable = await _speech.initialize(
        onStatus: (status) {
          logDebug('   Speech status: $status');
          if (mounted) {
            setState(() {
              _isListening = status == 'listening';
            });
          }
        },
        onError: (error) {
          logDebug('   Speech error: $error');
          if (mounted) {
            setState(() {
              _isListening = false;
            });
          }
        },
      );

      if (_speechAvailable) {
        // Check which languages are available
        final availableLocales = await _speech.locales();
        logDebug('✓ Speech recognition available with ${availableLocales.length} locales');

        // Check if our package languages are supported
        final lang1 = widget.package.languageCode1.split('-')[0].toLowerCase();
        final lang2 = widget.package.languageCode2.split('-')[0].toLowerCase();

        _languageAvailability[widget.package.languageCode1] = availableLocales.any(
          (locale) => locale.localeId.toLowerCase().startsWith(lang1)
        );
        _languageAvailability[widget.package.languageCode2] = availableLocales.any(
          (locale) => locale.localeId.toLowerCase().startsWith(lang2)
        );

        logDebug('📋 Language availability:');
        logDebug('   ${widget.package.languageName1} (${widget.package.languageCode1}): ${_languageAvailability[widget.package.languageCode1]}');
        logDebug('   ${widget.package.languageName2} (${widget.package.languageCode2}): ${_languageAvailability[widget.package.languageCode2]}');
      } else {
        logDebug('❌ Native speech recognition not available on this device');
      }
    } catch (e) {
      logDebug('❌ Native speech recognition initialization failed: $e');
      logDebug('   Error type: ${e.runtimeType}');

      // Check if this is a Windows SAPI error
      if (e.toString().contains('HRESULT') || e.toString().contains('80045077')) {
        logDebug('');
        logDebug('ℹ️  This is a Windows SAPI error - EXPECTED on Windows desktop');
        logDebug('   👉 Solution: Whisper API will be used automatically if OpenAI key is configured');
        logDebug('');
      }

      _speechAvailable = false;
    }

    logDebug('═══════════════════════════════════════════════════════════');
    logDebug('📊 Final initialization state:');
    logDebug('   - Native speech available: $_speechAvailable');
    logDebug('   - Whisper service available: ${_speechRecognitionService?.isWhisperAvailable ?? false}');

    if (!_speechAvailable && _speechRecognitionService?.isWhisperAvailable == true) {
      logDebug('');
      logDebug('✅ READY FOR RECORDING:');
      logDebug('   - Native speech: Not available (expected on Windows)');
      logDebug('   - Whisper API: Available and ready to use');
      logDebug('   - Click microphone button to start recording');
      logDebug('');
    } else if (!_speechAvailable && _speechRecognitionService?.isWhisperAvailable == false) {
      logDebug('');
      logDebug('⚠️  WARNING: No speech input method available');
      logDebug('   - Native speech: Not available');
      logDebug('   - Whisper API: Not configured');
      logDebug('   - Action needed: Add OpenAI API key in Settings');
      logDebug('');
    }

    logDebug('═══════════════════════════════════════════════════════════');
  }

  void _initializeControllers() {
    _preItem1Controller = TextEditingController(text: widget.item.language1Data.preItem ?? '');
    _text1Controller = TextEditingController(text: widget.item.language1Data.text);
    _postItem1Controller = TextEditingController(text: widget.item.language1Data.postItem ?? '');

    _preItem2Controller = TextEditingController(text: widget.item.language2Data.preItem ?? '');
    _text2Controller = TextEditingController(text: widget.item.language2Data.text);
    _postItem2Controller = TextEditingController(text: widget.item.language2Data.postItem ?? '');

    // Initialize example controllers from existing examples
    _exampleControllers.clear();
    for (final example in widget.item.examples) {
      _exampleControllers.add({
        'language1': TextEditingController(text: example.textLanguage1),
        'language2': TextEditingController(text: example.textLanguage2),
      });
    }
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

    // Dispose all example controllers
    for (final controllers in _exampleControllers) {
      controllers['language1']?.dispose();
      controllers['language2']?.dispose();
    }
    _exampleControllers.clear();

    // Stop and dispose speech recognition
    if (_isListening) {
      _speech.stop();
    }

    // Dispose audio recorder
    _audioRecorder.dispose();

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
          else ...[

            IconButton(
              icon: const Icon(Icons.save, size: 28),
              onPressed: _saveItem,
              tooltip: l10n.save,
              color: theme.colorScheme.primary,
              iconSize: 28,
            ),
            const SizedBox(width: AppTheme.spacing24),
          ],
        ],
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppTheme.spacing8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isTablet)
                  // Tablet layout - horizontal
                  ..._buildTabletLayout(theme)
                else
                  // Phone layout - vertical
                  ..._buildPhoneLayout(theme),

                const SizedBox(height: AppTheme.spacing8),

                // AI Example Generation Section
                _buildExampleGenerationSection(theme),

                const SizedBox(height: AppTheme.spacing8),

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
              minLines: 2,
            ),
          ),
          const SizedBox(width: AppTheme.spacing8),
          Expanded(
            child: _buildLanguageSection(
              theme: theme,
              languageName: widget.package.languageName2,
              languageCode: widget.package.languageCode2,
              preItemController: _preItem2Controller,
              textController: _text2Controller,
              postItemController: _postItem2Controller,
              isLanguage1: false,
              minLines: 2,
            ),
          ),
        ],
      ),
      const SizedBox(height: AppTheme.spacing8),

      // Translation buttons in a row
      _buildTranslationButtonsTablet(theme),

      const SizedBox(height: AppTheme.spacing8),

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
      const SizedBox(height: AppTheme.spacing8),

      // Examples field
      _buildExamplesField(theme, l10n),
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
      const SizedBox(height: AppTheme.spacing8),

      // Translation buttons in a row (compact)
      _buildTranslationButtonsPhone(theme),
      const SizedBox(height: AppTheme.spacing8),

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

      const SizedBox(height: AppTheme.spacing8),

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

      const SizedBox(height: AppTheme.spacing8),

      // Examples field
      _buildExamplesField(theme, l10n),
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
        padding: const EdgeInsets.all(AppTheme.spacing8),
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
                  tooltip: l10n.speakText,
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
            //const SizedBox(height: AppTheme.spacing12),

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
                      ? const Icon(Icons.stop_circle, size: 24, color: Colors.red)
                      : const Icon(Icons.mic, size: 20),
                  tooltip: _isListening ? l10n.tapToStop : l10n.voiceInput,
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

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing8),
      child: Row(
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
    ),
    );
  }

  Widget _buildTranslationButtonsPhone(ThemeData theme) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing8),
      child: Row(
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
    ),
    );
  }

  Widget _buildExampleGenerationSection(ThemeData theme) {
    final l10n = AppLocalizations.of(context)!;
    final currentText = _text1Controller.text.trim();

    return Card(
      elevation: 1,
      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.9),
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
            const SizedBox(height: AppTheme.spacing8),
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
                  backgroundColor: theme.colorScheme.secondaryContainer,
                  foregroundColor: theme.colorScheme.onSecondaryContainer,
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
      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.9),
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
                  ClickableText(
                    text: l10n.improveQualityWithApiKeys,
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
                      // Settings button at the end
                      InkWell(
                        onTap: () {
                          // Navigate to settings
                          Navigator.of(context).pushNamed('/settings');
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppTheme.spacing8,
                            vertical: AppTheme.spacing4,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                          ),
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
    // Determine if we're in portrait mode on non-tablet
    final screenWidth = MediaQuery.of(context).size.width;
    final isPortraitNonTablet = screenWidth < 600;

    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.status,
              style: theme.textTheme.titleSmall?.copyWith(
                fontSize: (theme.textTheme.titleSmall?.fontSize ?? 14) * 0.85,
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            // const SizedBox(height: AppTheme.spacing8),
            if (isPortraitNonTablet)
              // Portrait mode on non-tablet: Use Column
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                      _isKnown ? Icons.check_circle : Icons.error,
                      size: 18,
                      color: _isKnown ? Colors.green : Colors.red,
                    ),
                    onSelected: (value) {
                      setState(() {
                        _isKnown = value;
                      });
                    },
                  ),
                  const SizedBox(height: AppTheme.spacing8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Favourite status with label
                      InkWell(
                        onTap: () {
                          setState(() {
                            _isFavourite = !_isFavourite;
                          });
                        },
                        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppTheme.spacing8,
                            vertical: AppTheme.spacing4,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _isFavourite ? Icons.star : Icons.star_outline,
                                size: 24,
                                color: _isFavourite ? theme.colorScheme.tertiary : theme.colorScheme.onSurfaceVariant,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                l10n.favourite,
                                style: theme.textTheme.labelSmall?.copyWith(
                                  fontSize: 10,
                                  color: _isFavourite ? theme.colorScheme.tertiary : theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: AppTheme.spacing4),
                      // Important status with label
                      InkWell(
                        onTap: () {
                          setState(() {
                            _isImportant = !_isImportant;
                          });
                        },
                        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppTheme.spacing8,
                            vertical: AppTheme.spacing4,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _isImportant ? Icons.bookmark : Icons.bookmark_border,
                                size: 24,
                                color: _isImportant ? theme.colorScheme.secondary : theme.colorScheme.onSurfaceVariant,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                l10n.important,
                                style: theme.textTheme.labelSmall?.copyWith(
                                  fontSize: 10,
                                  color: _isImportant ? theme.colorScheme.secondary : theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )
            else
              // Landscape or tablet: Use horizontal Row with scroll
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                        _isKnown ? Icons.check_circle : Icons.error,
                        size: 18,
                        color: _isKnown ? Colors.green : Colors.red,
                      ),
                      onSelected: (value) {
                        setState(() {
                          _isKnown = value;
                        });
                      },
                    ),
                    const SizedBox(width: AppTheme.spacing8),
                    // Favourite status with label
                    InkWell(
                      onTap: () {
                        setState(() {
                          _isFavourite = !_isFavourite;
                        });
                      },
                      borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                      child: Padding(
                        padding: const EdgeInsets.all(AppTheme.spacing8),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _isFavourite ? Icons.star : Icons.star_outline,
                              size: 24,
                              color: _isFavourite ? theme.colorScheme.tertiary : theme.colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              l10n.favourite,
                              style: theme.textTheme.labelSmall?.copyWith(
                                fontSize: 10,
                                color: _isFavourite ? theme.colorScheme.tertiary : theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: AppTheme.spacing8),
                    // Important status with label
                    InkWell(
                      onTap: () {
                        setState(() {
                          _isImportant = !_isImportant;
                        });
                      },
                      borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                      child: Padding(
                        padding: const EdgeInsets.all(AppTheme.spacing8),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _isImportant ? Icons.bookmark : Icons.bookmark_border,
                              size: 24,
                              color: _isImportant ? theme.colorScheme.secondary : theme.colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              l10n.important,
                              style: theme.textTheme.labelSmall?.copyWith(
                                fontSize: 10,
                                color: _isImportant ? theme.colorScheme.secondary : theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
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
              runSpacing: AppTheme.spacing4, // Reduced vertical spacing
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

  Widget _buildExamplesField(ThemeData theme, AppLocalizations l10n) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with title
            Row(
              children: [
                Text(
                  l10n.examples,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontSize: (theme.textTheme.titleSmall?.fontSize ?? 14) * 0.85,
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                // Add example button
                IconButton(
                  icon: const Icon(Icons.add_circle_outline, size: 20),
                  tooltip: l10n.addExample,
                  onPressed: _addNewExample,
                  color: theme.colorScheme.primary,
                ),
              ],
            ),
            // const SizedBox(height: AppTheme.spacing8),

            // List of example cards
            if (_exampleControllers.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppTheme.spacing16),
                  child: Text(
                    l10n.noExamplesYet,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              )
            else
              ...List.generate(_exampleControllers.length, (index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppTheme.spacing8),
                  child: _buildExampleCard(theme, l10n, index),
                );
              }),
          ],
        ),
      ),
    );
  }

  Widget _buildExampleCard(ThemeData theme, AppLocalizations l10n, int index) {
    final controllers = _exampleControllers[index];

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Language 1 input with delete button
            TextFormField(
              controller: controllers['language1'],
              style: theme.textTheme.bodySmall,
              decoration: InputDecoration(
                labelText: widget.package.languageCode1.substring(0, 2).toUpperCase(),
                labelStyle: theme.textTheme.bodySmall,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacing8,
                  vertical: AppTheme.spacing8,
                ),
                isDense: true,
                suffixIcon: IconButton(
                  icon: const Icon(Icons.delete_outline, size: 18),
                  tooltip: l10n.delete,
                  onPressed: () => _deleteExample(index),
                  color: theme.colorScheme.error,
                ),
              ),
              maxLines: 2,
              minLines: 1,
            ),
            const SizedBox(height: AppTheme.spacing8),

            // Language 2 input
            TextFormField(
              controller: controllers['language2'],
              style: theme.textTheme.bodySmall,
              decoration: InputDecoration(
                labelText: widget.package.languageCode2.substring(0, 2).toUpperCase(),
                labelStyle: theme.textTheme.bodySmall,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacing8,
                  vertical: AppTheme.spacing8,
                ),
                isDense: true,
              ),
              maxLines: 2,
              minLines: 1,
            ),
          ],
        ),
      ),
    );
  }

  void _addNewExample() {
    setState(() {
      _exampleControllers.add({
        'language1': TextEditingController(),
        'language2': TextEditingController(),
      });
    });
  }

  void _deleteExample(int index) {
    setState(() {
      // Dispose controllers before removing
      _exampleControllers[index]['language1']?.dispose();
      _exampleControllers[index]['language2']?.dispose();
      _exampleControllers.removeAt(index);
    });
  }

  Future<void> _confirmRemoveCategory(Category category) async {
    final l10n = AppLocalizations.of(context)!;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.removeCategory),
        content: Text(l10n.removeCategoryConfirm(category.name)),
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
            child: Text(l10n.remove),
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
                final navigator = Navigator.of(context);
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
                  navigator.pop();
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
  /// Automatically falls back to OpenAI Whisper API if native speech recognition
  /// is not available or the language is not supported.
  Future<void> _startVoiceInput(TextEditingController controller, String languageCode) async {
    final l10n = AppLocalizations.of(context)!;

    logDebug('🎤 _startVoiceInput called for language: $languageCode');
    logDebug('   Currently listening: $_isListening');

    // If already listening, stop
    if (_isListening) {
      logDebug('⏹️ Already listening, calling stop...');
      if (_useWhisperAPI) {
        await _stopWhisperRecording(controller, languageCode);
      } else {
        await _speech.stop();
        setState(() => _isListening = false);
      }
      return;
    }

    // Re-check API key availability
    final settings = ref.read(appSettingsProvider);
    final openaiApiKey = settings.openaiApiKey;

    if (openaiApiKey != null && openaiApiKey.isNotEmpty && _speechRecognitionService == null) {
      logDebug('✓ API key available, initializing Whisper service...');
      _speechRecognitionService = SpeechRecognitionService(apiKey: openaiApiKey);
    }

    // Check availability
    final languageAvailable = _languageAvailability[languageCode] ?? false;
    final whisperAvailable = _speechRecognitionService?.isWhisperAvailable ?? false;

    logDebug('📋 Mode selection:');
    logDebug('   - Native available: $_speechAvailable');
    logDebug('   - Language available: $languageAvailable');
    logDebug('   - Whisper available: $whisperAvailable');

    // Determine which mode to use
    if (_speechAvailable && languageAvailable) {
      logDebug('✅ Using native speech recognition');
      _useWhisperAPI = false;
      await _startNativeSpeechRecognition(controller, languageCode);
    } else if (whisperAvailable) {
      logDebug('✅ Using Whisper API (fallback)');
      _useWhisperAPI = true;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.cloud, color: Colors.white, size: 20),
              const SizedBox(width: 12),
              Expanded(child: Text(l10n.usingWhisperApiSlower)),
            ],
          ),
          duration: const Duration(seconds: 3),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
      );

      await _startWhisperRecording(controller, languageCode);
    } else {
      logDebug('❌ No speech input available');
      String message = !_speechAvailable
        ? l10n.speechRecognitionNotAvailable
        : l10n.languageNotSupportedAddApiKey(languageCode);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(context).colorScheme.error,
          duration: const Duration(seconds: 5),
          action: SnackBarAction(
            label: l10n.settings,
            textColor: Colors.white,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AppSettingsPage()),
              );
            },
          ),
        ),
      );
    }
  }

  /// Native speech recognition (original implementation)
  Future<void> _startNativeSpeechRecognition(
    TextEditingController controller,
    String languageCode,
  ) async {
    final l10n = AppLocalizations.of(context)!;

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

    try {
      await _speech.listen(
        onResult: (result) {
          if (!result.finalResult) {
            Future.microtask(() {
              if (mounted) {
                setState(() {
                  controller.text = result.recognizedWords;
                });
              }
            });
          } else {
            Future.microtask(() {
              if (mounted) {
                setState(() {
                  controller.text = result.recognizedWords;
                  _isListening = false;
                });

                ScaffoldMessenger.of(context).hideCurrentSnackBar();

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
            });
          }
        },
        localeId: languageCode,
        listenFor: const Duration(seconds: 60),
        pauseFor: const Duration(seconds: 4),
        listenOptions: stt.SpeechListenOptions(
          partialResults: true,
          cancelOnError: true,
          listenMode: stt.ListenMode.dictation,
        ),
      );

      setState(() => _isListening = true);
    } catch (e) {
      setState(() => _isListening = false);

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

  /// Start Whisper API recording
  Future<void> _startWhisperRecording(
    TextEditingController controller,
    String languageCode,
  ) async {
    final l10n = AppLocalizations.of(context)!;

    logDebug('🎙️ Starting Whisper recording...');

    // Check if running on Windows - audio recording is problematic on Windows desktop
    final isWindows = !kIsWeb && Platform.isWindows;
    if (isWindows) {
      logDebug('⚠️ WARNING: Running on Windows desktop');
      logDebug('   Audio recording has known issues on Windows with Flutter');
      logDebug('   The record package does not properly capture audio on Windows');
      logDebug('   Recommendation: Use Android or iOS device for voice input');
      logDebug('   Proceeding anyway, but recording will likely fail...');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              '⚠️ Audio recording not supported on Windows!\n\n'
              'The microphone recording feature does not work properly on Windows desktop.\n\n'
              '✅ Solution: Use this feature on Android or iOS device instead.\n\n'
              'Or type the text manually on Windows.'
            ),
            backgroundColor: Colors.orange,
            duration: const Duration(seconds: 10),
            action: SnackBarAction(
              label: 'OK',
              textColor: Colors.white,
              onPressed: () {},
            ),
          ),
        );
      }

      // Don't proceed with recording on Windows
      return;
    }

    try {
      logDebug('🔍 Checking recorder state before start...');
      final wasRecording = await _audioRecorder.isRecording();
      logDebug('   Was already recording: $wasRecording');

      if (wasRecording) {
        logDebug('⚠️ Recorder was already active, stopping it first...');
        await _audioRecorder.stop();
        await Future.delayed(const Duration(milliseconds: 500));
      }

      final hasPermission = await _audioRecorder.hasPermission();
      logDebug('📊 Microphone permission: $hasPermission');

      if (!hasPermission) {
        logDebug('❌ No microphone permission');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.microphonePermissionRequired),
              duration: const Duration(seconds: 5),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
        return;
      }

      final directory = await getTemporaryDirectory();
      final fileName = 'voice_input_${DateTime.now().millisecondsSinceEpoch}.m4a';
      final filePath = '${directory.path}/$fileName';

      logDebug('📁 Recording details:');
      logDebug('   - Directory: ${directory.path}');
      logDebug('   - File name: $fileName');
      logDebug('   - Full path: $filePath');

      // Check if file already exists (shouldn't, but let's verify)
      final file = File(filePath);
      if (await file.exists()) {
        logDebug('⚠️ File already exists, deleting it...');
        await file.delete();
      }

      logDebug('🎚️ Starting recording with config:');
      logDebug('   - Encoder: AAC-LC');
      logDebug('   - Sample rate: 44100 Hz');
      logDebug('   - Bit rate: 128000 bps');
      logDebug('   - Format: M4A');

      await _audioRecorder.start(
        const RecordConfig(
          encoder: AudioEncoder.aacLc,
          sampleRate: 44100,
          bitRate: 128000,
        ),
        path: filePath,
      );

      // Wait a moment for recording to initialize
      await Future.delayed(const Duration(milliseconds: 300));

      final isRecording = await _audioRecorder.isRecording();
      logDebug('📊 Recording status after start:');
      logDebug('   - Is recording: $isRecording');

      if (!isRecording) {
        logDebug('❌❌❌ CRITICAL: Recorder reports NOT recording after start!');
        logDebug('   This indicates the audio system failed to start');
        logDebug('   Possible causes:');
        logDebug('   1. No default audio input device configured');
        logDebug('   2. Audio device is in use by another application');
        logDebug('   3. Windows audio service issue');
        logDebug('   4. Codec/encoder not available');

        setState(() => _isListening = false);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Recording failed to start!\n\nCheck:\n1. Microphone is connected\n2. Microphone is set as default device\n3. No other app is using microphone'),
              backgroundColor: Theme.of(context).colorScheme.error,
              duration: const Duration(seconds: 8),
            ),
          );
        }
        return;
      }

      _recordingStartTime = DateTime.now();
      setState(() => _isListening = true);

      // Check if file was created
      await Future.delayed(const Duration(milliseconds: 500));
      final fileCreated = await file.exists();
      final initialSize = fileCreated ? await file.length() : 0;

      logDebug('📊 Initial recording check (500ms after start):');
      logDebug('   - File created: $fileCreated');
      logDebug('   - Initial file size: $initialSize bytes');

      if (initialSize == 0) {
        logDebug('⚠️⚠️⚠️ WARNING: No audio data written after 500ms!');
        logDebug('   This suggests the microphone is not capturing audio');
        logDebug('   Recording will continue, but result may be too small');
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.fiber_manual_record, color: Colors.red, size: 16),
                const SizedBox(width: 12),
                Expanded(child: Text('${l10n.recordingTapToStop}\n💡 Speak loudly and clearly for at least 2 seconds')),
              ],
            ),
            duration: const Duration(seconds: 60),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
      }

      logDebug('✅ Recording started successfully');
      logDebug('   User should speak now and tap stop when done');
    } catch (e, stackTrace) {
      logDebug('❌ Error starting recording: $e');
      logDebug('   Stack trace: $stackTrace');
      setState(() => _isListening = false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.errorStartingRecording}: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  /// Stop Whisper API recording and transcribe
  Future<void> _stopWhisperRecording(
    TextEditingController controller,
    String languageCode,
  ) async {
    final l10n = AppLocalizations.of(context)!;

    logDebug('⏹️ Stopping Whisper recording...');

    if (_recordingStartTime != null) {
      final duration = DateTime.now().difference(_recordingStartTime!);
      logDebug('⏱️ Recording duration: ${duration.inMilliseconds}ms');
    }

    try {
      // Check if still recording before stopping
      final isStillRecording = await _audioRecorder.isRecording();
      logDebug('📊 Is still recording before stop: $isStillRecording');

      final audioPath = await _audioRecorder.stop();
      setState(() => _isListening = false);

      if (!mounted) return;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      await Future.delayed(const Duration(milliseconds: 100));

      if (!mounted) return;
      if (audioPath == null || audioPath.isEmpty) {
        logDebug('❌ No audio path returned from recorder');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.noAudioRecorded),
            backgroundColor: Theme.of(context).colorScheme.error,
            duration: const Duration(seconds: 3),
          ),
        );
        return;
      }

      logDebug('📁 Audio saved to: $audioPath');

      final audioFile = File(audioPath);

      // Wait a moment for file to be fully written
      await Future.delayed(const Duration(milliseconds: 200));

      final fileExists = await audioFile.exists();
      logDebug('📊 File exists: $fileExists');

      if (!fileExists) {
        logDebug('❌ Audio file does not exist at path!');
        logDebug('   This means recording never created a file');

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Recording failed - no audio file created!\n\nPossible causes:\n1. Microphone not connected\n2. No audio input detected\n3. Windows audio settings issue'),
              backgroundColor: Theme.of(context).colorScheme.error,
              duration: const Duration(seconds: 8),
            ),
          );
        }
        return;
      }

      final fileSize = await audioFile.length();
      logDebug('📊 File size: $fileSize bytes (${(fileSize / 1024).toStringAsFixed(2)} KB)');

      // Calculate expected file size
      if (_recordingStartTime != null) {
        final actualDuration = DateTime.now().difference(_recordingStartTime!).inMilliseconds / 1000.0;
        final expectedSize = (128000 / 8) * actualDuration; // 128kbps = 16KB/sec
        logDebug('📊 Size analysis:');
        logDebug('   - Actual duration: ${actualDuration.toStringAsFixed(2)}s');
        logDebug('   - Expected size: ${expectedSize.toStringAsFixed(0)} bytes (~${(expectedSize / 1024).toStringAsFixed(2)} KB)');
        logDebug('   - Actual size: $fileSize bytes (${(fileSize / 1024).toStringAsFixed(2)} KB)');
        logDebug('   - Size ratio: ${(fileSize / expectedSize * 100).toStringAsFixed(1)}%');

        if (fileSize < expectedSize * 0.1) {
          logDebug('❌❌❌ CRITICAL: File is less than 10% of expected size!');
          logDebug('   This indicates NO audio was captured');
          logDebug('   Likely causes:');
          logDebug('   1. Microphone muted or volume at 0%');
          logDebug('   2. Wrong audio input device selected');
          logDebug('   3. Microphone not working');
          logDebug('   4. Windows is blocking audio access');
        }
      }

      if (fileSize < 1000) {
        logDebug('⚠️ Audio file too small for Whisper API');
        logDebug('   Minimum: ~1000 bytes (0.1 seconds)');
        logDebug('   Actual: $fileSize bytes');
        logDebug('');
        logDebug('🔧 TROUBLESHOOTING STEPS:');
        logDebug('   1. Check Windows Sound Settings → Input');
        logDebug('   2. Verify microphone is NOT muted');
        logDebug('   3. Test microphone level (speak and watch the bar)');
        logDebug('   4. Try selecting a different microphone if multiple exist');
        logDebug('   5. Check if microphone works in other apps (e.g., Voice Recorder)');
        logDebug('');

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${l10n.recordingTooShort}\n\nFile size: $fileSize bytes\nExpected: >15 KB\n\n⚠️ Microphone may not be working!\n\nCheck Windows Sound Settings → Input'),
              backgroundColor: Theme.of(context).colorScheme.error,
              duration: const Duration(seconds: 10),
            ),
          );
        }
        return;
      }

      logDebug('✅ File size acceptable, proceeding with transcription');

      if (mounted) {
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
                Text(l10n.processingAudio),
              ],
            ),
            duration: const Duration(seconds: 30),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
      }

      logDebug('📤 Sending to Whisper API...');

      final result = await _speechRecognitionService!.transcribeAudio(
        audioFilePath: audioPath,
        language: languageCode.split('-')[0],
      );

      logDebug('✅ Transcription: "${result.text}"');

      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();

        setState(() {
          controller.text = result.text;
        });

        if (result.text.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('✓ ${result.text}'),
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
    } catch (e, stackTrace) {
      logDebug('❌ Error transcribing: $e');
      logDebug('   Stack trace: $stackTrace');

      setState(() => _isListening = false);

      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.errorTranscribing}: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
            duration: const Duration(seconds: 5),
          ),
        );
      }
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
            duration: const Duration(seconds: 6),
            action: SnackBarAction(
              label: l10n.settings,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AppSettingsPage()),
                );
              },
            ),
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

        // Show selection dialog
        final selectedExamples = await _showExampleSelectionDialog(examples);

        if (selectedExamples != null && selectedExamples.isNotEmpty) {
          // Add selected examples to the controller list
          setState(() {
            for (final example in selectedExamples) {
              _exampleControllers.add({
                'language1': TextEditingController(text: example.textLanguage1),
                'language2': TextEditingController(text: example.textLanguage2),
              });
            }
          });

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
          titlePadding: const EdgeInsets.fromLTRB(
            AppTheme.spacing12,
            AppTheme.spacing12,
            AppTheme.spacing12,
            AppTheme.spacing8,
          ),
          contentPadding: const EdgeInsets.fromLTRB(
            AppTheme.spacing12,
            0,
            AppTheme.spacing12,
            AppTheme.spacing8,
          ),
          actionsPadding: const EdgeInsets.fromLTRB(
            AppTheme.spacing8,
            0,
            AppTheme.spacing8,
            AppTheme.spacing8,
          ),
          title: Row(
            children: [
              Icon(
                Icons.lightbulb_outline,
                color: theme.colorScheme.secondary,
                size: 18, // Reduced icon size
              ),
              const SizedBox(width: AppTheme.spacing4),
              Expanded(
                child: Text(
                  l10n.selectExamplesToAdd,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontSize: 16, // Reduced title font size
                  ),
                ),
              ),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.selectWhichExamples,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: 11, // Reduced description font size
                  ),
                ),
                const SizedBox(height: AppTheme.spacing8),
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: examples.length,
                    itemBuilder: (context, index) {
                      final example = examples[index];
                      final isSelected = selectedExamples[index] ?? false;

                      return Card(
                        margin: const EdgeInsets.only(bottom: AppTheme.spacing4), // Reduced margin
                        color: isSelected
                            ? theme.colorScheme.primaryContainer.withValues(alpha: 0.3)
                            : null,
                        child: CheckboxListTile(
                          dense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: AppTheme.spacing8, // Reduced horizontal padding
                            vertical: 0, // Reduced vertical padding
                          ),
                          visualDensity: VisualDensity.compact,
                          value: isSelected,
                          onChanged: (value) {
                            Future.microtask(() {
                              setDialogState(() {
                                selectedExamples[index] = value ?? false;
                              });
                            });
                          },
                          title: Text(
                            example.textLanguage1,
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 12, // Reduced font size
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 2), // Reduced padding
                            child: Text(
                              example.textLanguage2,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                                fontSize: 11, // Reduced font size
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
            // Compact buttons
            TextButton(
              onPressed: () => Navigator.of(context).pop(null),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacing8,
                  vertical: AppTheme.spacing4,
                ),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                l10n.cancel,
                style: const TextStyle(fontSize: 12), // Reduced button text size
              ),
            ),
            TextButton(
              onPressed: () {
                // Select/Deselect all
                final allSelected = selectedExamples.values.every((v) => v);
                Future.microtask(() {
                  setDialogState(() {
                    for (int i = 0; i < examples.length; i++) {
                      selectedExamples[i] = !allSelected;
                    }
                  });
                });
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacing8,
                  vertical: AppTheme.spacing4,
                ),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                selectedExamples.values.every((v) => v) ? l10n.deselectAll : l10n.selectAll,
                style: const TextStyle(fontSize: 12), // Reduced button text size
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
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacing8,
                  vertical: AppTheme.spacing4,
                ),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              icon: const Icon(Icons.add, size: 14), // Reduced icon size
              label: Text(
                '${l10n.addSelected} (${selectedExamples.values.where((v) => v).length})',
                style: const TextStyle(fontSize: 12), // Reduced button text size
              ),
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
      // Collect examples from individual controllers
      final List<ExampleSentence> parsedExamples = [];

      for (final controllers in _exampleControllers) {
        final lang1Text = controllers['language1']?.text.trim() ?? '';
        final lang2Text = controllers['language2']?.text.trim() ?? '';

        // Only add if both fields have text
        if (lang1Text.isNotEmpty && lang2Text.isNotEmpty) {
          parsedExamples.add(
            ExampleSentence(
              id: const Uuid().v4(),
              textLanguage1: lang1Text,
              textLanguage2: lang2Text,
            ),
          );
        }
      }

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
        examples: parsedExamples,
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

