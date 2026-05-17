// lib/presentation/pages/ai_import/ai_item_creator_page.dart
//
// AI Item Creator - Create language items with AI assistance and translation support
//
// lib/presentation/pages/ai_import/ai_item_creator_page.dart
//
// AI Item Creator - Create language items with AI assistance and translation support
//

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../../../core/constants/openai_model_catalog.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/text_analysis_service.dart';
import '../../../core/services/translation_service.dart';
import '../../../core/services/service_error_messages.dart';
import '../../../data/models/language_package.dart';
import '../../../data/models/item.dart';
import '../../../data/models/item_language_data.dart';
import '../../../data/models/category.dart';
import '../../../data/repositories/item_repository.dart';
import '../../../data/repositories/category_repository.dart';
import '../../../data/repositories/language_package_repository.dart';
import '../../../l10n/app_localizations.dart';
import '../../providers/app_settings_provider.dart';
import '../packages/package_form_page.dart';
import '../settings/app_settings_page.dart';
import '../../../data/models/example_sentence.dart';

class AIItemCreatorPage extends ConsumerStatefulWidget {
  const AIItemCreatorPage({
    super.key,
    this.initialPackage,
  });

  final LanguagePackage? initialPackage;

  @override
  ConsumerState<AIItemCreatorPage> createState() => _AIItemCreatorPageState();
}

class _AIItemCreatorPageState extends ConsumerState<AIItemCreatorPage> {
  List<LanguagePackage> _allPackages = [];
  LanguagePackage? _selectedPackage;
  List<LanguagePackage> _availablePackages = [];

  String _selectedModel = OpenAiModelCatalog.defaultModelId;

  final _promptController = TextEditingController();
  final _aiResponseController = TextEditingController();

  final _item1Controller = TextEditingController();
  final _item2Controller = TextEditingController();

  final _example1Item1Controller = TextEditingController();
  final _example1Item2Controller = TextEditingController();
  final _example2Item1Controller = TextEditingController();
  final _example2Item2Controller = TextEditingController();

  final List<Map<String, String>> _chatHistory = [];
  List<Map<String, String>> _aiSuggestedItems = [];
  List<String> _aiNextPromptSuggestions = [];

  List<Category> _selectedCategories = [];
  bool _isImportant = false;
  bool _isFavourite = false;

  bool _isLoading = false;
  bool _isSending = false;
  bool _isGeneratingExamples = false;
  bool _isTranslating = false;
  bool _isListeningPrompt = false;
  bool _isModelPanelExpanded = true;

  final _scrollController = ScrollController();
  final _rightScrollController = ScrollController();

  final _chatSectionKey = GlobalKey();
  final _itemInputSectionKey = GlobalKey();

  final _itemRepo = ItemRepository();
  final _categoryRepo = CategoryRepository();
  final _packageRepo = LanguagePackageRepository();
  final stt.SpeechToText _speech = stt.SpeechToText();

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _refreshPackagesAndPromptSelection(showEmptyPackagesPrompt: true);
      if (!mounted) {
        return;
      }

      final settings = ref.read(appSettingsProvider);
      _warnIfApiKeysMissing(settings.openaiApiKey, settings.deeplApiKey);
    });
  }

  Future<void> _refreshPackagesAndPromptSelection({
    required bool showEmptyPackagesPrompt,
  }) async {
    await ref.read(appSettingsProvider.notifier).refreshFromStorage();
    final settings = ref.read(appSettingsProvider);
    final packages = await _packageRepo.getAllPackages();
    final nonPurchasedPackages = packages.where((p) => !p.isPurchased).toList();

    if (!mounted) {
      return;
    }

    setState(() {
      _selectedModel = OpenAiModelCatalog.normalizeSelection(
        settings.openaiModel,
      );
      _allPackages = packages;
      _availablePackages = nonPurchasedPackages;
      _selectedPackage = null;
      _selectedCategories = [];
    });

    if (!mounted) {
      return;
    }

    final preselectedPackage = _resolvePreselectedPackage(_availablePackages);
    if (preselectedPackage != null) {
      await _applySelectedPackage(preselectedPackage, persistSelection: false);
      return;
    }

    if (_availablePackages.isEmpty) {
      if (showEmptyPackagesPrompt) {
        await _showNoEligiblePackagesDialog(isDatabaseEmpty: _allPackages.isEmpty);
      }
      return;
    }

    await _promptForPackageSelection(settings.lastAiItemCreatorPackageId);
  }

  LanguagePackage? _resolvePreselectedPackage(List<LanguagePackage> packages) {
    final incomingPackage = widget.initialPackage;
    if (incomingPackage == null) {
      return null;
    }

    for (final package in packages) {
      if (package.id == incomingPackage.id) {
        return package;
      }
    }

    return null;
  }

  LanguagePackage? _resolveInitialPackage(
    List<LanguagePackage> packages,
    String? savedPackageId,
  ) {
    if (packages.isEmpty) {
      return null;
    }

    if (savedPackageId != null && savedPackageId.trim().isNotEmpty) {
      for (final package in packages) {
        if (package.id == savedPackageId) {
          return package;
        }
      }
    }

    return packages.first;
  }

  Future<void> _applySelectedPackage(
    LanguagePackage package, {
    bool persistSelection = true,
  }) async {
    if (mounted) {
      setState(() {
        _selectedPackage = package;
      });
    }

    final categories = await _categoryRepo.getCategoriesForPackage(package.id);

    if (!mounted) {
      return;
    }

    setState(() {
      _selectedCategories = categories.isNotEmpty ? [categories.first] : [];
    });

    if (persistSelection) {
      await ref
          .read(appSettingsProvider.notifier)
          .setLastAiItemCreatorPackageId(package.id);
    }
  }

  Future<void> _promptForPackageSelection(String? savedPackageId) async {
    if (_availablePackages.isEmpty || !mounted) {
      return;
    }

    final l10n = AppLocalizations.of(context)!;
    var dialogSelection =
        _resolveInitialPackage(_availablePackages, savedPackageId) ??
            _availablePackages.first;

    final selectedPackage = await showDialog<LanguagePackage>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(l10n.aiItemCreatorSelectPackageDialogTitle),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.aiItemCreatorSelectPackageDialogMessage),
                  const SizedBox(height: AppTheme.spacing8),
                  DropdownButtonFormField<LanguagePackage>(
                    key: ValueKey(dialogSelection.id),
                    initialValue: dialogSelection,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: AppTheme.spacing8,
                      ),
                      border: OutlineInputBorder(),
                    ),
                    items: _availablePackages.map((package) {
                      return DropdownMenuItem<LanguagePackage>(
                        value: package,
                        child: Text(
                          package.packageName ??
                              '${package.languageName1} → ${package.languageName2}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value == null) {
                        return;
                      }

                      setDialogState(() {
                        dialogSelection = value;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: Text(l10n.cancel),
                ),
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(dialogSelection),
                  child: Text(l10n.ok),
                ),
              ],
            );
          },
        );
      },
    );

    if (!mounted || selectedPackage == null) {
      return;
    }

    await _applySelectedPackage(selectedPackage);
  }

  Future<void> _showNoEligiblePackagesDialog({required bool isDatabaseEmpty}) async {
    if (!mounted) {
      return;
    }

    final l10n = AppLocalizations.of(context)!;
    final selectedAction = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.selectPackage),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isDatabaseEmpty ? l10n.noPackagesYet : l10n.noPackagesAvailable,
            ),
            if (isDatabaseEmpty) ...[
              const SizedBox(height: AppTheme.spacing8),
              Text(l10n.createFirstPackage),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.close),
          ),
          TextButton.icon(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            icon: const Icon(Icons.add),
            label: Text(l10n.createNewPackage),
          ),
        ],
      ),
    );

    if (!mounted || selectedAction != true) {
      return;
    }

    await _openPackageForm();
  }

  Future<void> _openPackageForm() async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const PackageFormPage()),
    );

    if (!mounted) {
      return;
    }

    await _refreshPackagesAndPromptSelection(showEmptyPackagesPrompt: false);
  }

  Future<void> _openPackageSelectionDialog() async {
    final settings = ref.read(appSettingsProvider);
    await _promptForPackageSelection(settings.lastAiItemCreatorPackageId);
  }

  void _warnIfApiKeysMissing(String? openAiApiKey, String? deeplApiKey) {
    final l10n = AppLocalizations.of(context)!;
    final missingKeys = <String>[];

    if (openAiApiKey == null || openAiApiKey.trim().isEmpty) {
      missingKeys.add(l10n.openaiApiKey);
    }
    if (deeplApiKey == null || deeplApiKey.trim().isEmpty) {
      missingKeys.add(l10n.deeplApiKey);
    }

    if (missingKeys.isEmpty || !mounted) {
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.warning),
        content: Text(
          l10n.aiItemCreatorMissingApiKeysWarning(missingKeys.join(', ')),
        ),
        actions: [
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

  @override
  void dispose() {
    _speech.stop();
    _promptController.dispose();
    _aiResponseController.dispose();
    _item1Controller.dispose();
    _item2Controller.dispose();
    _example1Item1Controller.dispose();
    _example1Item2Controller.dispose();
    _example2Item1Controller.dispose();
    _example2Item2Controller.dispose();
    _scrollController.dispose();
    _rightScrollController.dispose();
    super.dispose();
  }


  Future<void> _sendPrompt() async {
    final l10n = AppLocalizations.of(context)!;

    if (_promptController.text.trim().isEmpty) {
      _showSnackBar(l10n.promptCannotBeEmpty);
      return;
    }

    final settings = ref.read(appSettingsProvider);
    if (settings.openaiApiKey == null || settings.openaiApiKey!.trim().isEmpty) {
      _showDetailedErrorDialog(
        l10n.openaiKeyRequired,
        l10n.aiItemCreatorOpenAiKeyNotConfiguredDetailed,
        isApiKeyIssue: true,
      );
      return;
    }
    final package = _selectedPackage;

    setState(() {
      _isSending = true;
      _aiSuggestedItems = [];
      _aiNextPromptSuggestions = [];
    });

    try {
      if (package == null) {
        _showSnackBar(l10n.selectPackageFirst);
        return;
      }

      final analysisService = TextAnalysisService(
        apiKey: settings.openaiApiKey!,
        model: _selectedModel,
      );

      final userMessage = _promptController.text.trim();
      final responseData = await analysisService.chatPracticeSessionStructured(
        userMessage: userMessage,
        userLanguageCode: settings.userLanguageCode,
        languageCode1: package.languageCode1,
        languageCode2: package.languageCode2,
        languageName1: package.languageName1,
        languageName2: package.languageName2,
        history: List<Map<String, String>>.from(_chatHistory),
      );
      final response = (responseData['answer'] as String?)?.trim() ?? '';
      final items = (responseData['items'] as List?)
              ?.map((e) => Map<String, String>.from(e as Map))
              .toList() ??
          <Map<String, String>>[];
      final suggestions = (responseData['suggestions'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          <String>[];

      setState(() {
        _chatHistory.add({'role': 'user', 'content': userMessage});
        _chatHistory.add({
          'role': 'assistant',
          'content': response.trim().isEmpty
              ? l10n.aiItemCreatorProcessingComplete
              : response.trim(),
        });
        _aiResponseController.text = response;
        _aiSuggestedItems = items;
        _aiNextPromptSuggestions = suggestions;
        _promptController.clear();
      });

      _scrollToLastAiMessage();
    } catch (e) {
      if (mounted) {
        _showDetailedErrorDialog(l10n.error, e.toString());
      }
    } finally {
      setState(() {
        _isSending = false;
      });
    }
  }

  Future<void> _translate(bool fromLang1ToLang2) async {
    final l10n = AppLocalizations.of(context)!;

    if (_selectedPackage == null) {
      _showSnackBar(l10n.selectPackageFirst);
      return;
    }

    final sourceText = fromLang1ToLang2
        ? _item1Controller.text.trim()
        : _item2Controller.text.trim();

    if (sourceText.isEmpty) {
      _showSnackBar(
        l10n.pleaseEnterTextInLanguageFirst(
          fromLang1ToLang2
              ? _selectedPackage!.languageName1
              : _selectedPackage!.languageName2,
        ),
      );
      return;
    }

    setState(() {
      _isTranslating = true;
    });

    try {
      final settings = ref.read(appSettingsProvider);
      final errorMessages = ServiceErrorMessages(l10n);
      final translationService = TranslationService(
        deeplApiKey: settings.deeplApiKey,
        openaiApiKey: settings.openaiApiKey,
        openaiModel: settings.openaiModel,
        errorMessages: errorMessages,
      );

      final translatedText = await translationService.translateText(
        text: sourceText,
        sourceLang: fromLang1ToLang2
            ? _selectedPackage!.languageCode1
            : _selectedPackage!.languageCode2,
        targetLang: fromLang1ToLang2
            ? _selectedPackage!.languageCode2
            : _selectedPackage!.languageCode1,
      );
      final usedOpenAiWithoutDeepL = translationService.usedOpenAiWithoutDeepL();

      if (!mounted) return;

      setState(() {
        if (fromLang1ToLang2) {
          _item2Controller.text = translatedText;
        } else {
          _item1Controller.text = translatedText;
        }
      });

      _showSnackBar(
        l10n.translationCompletedSuccessfully(translationService.getServiceName()),
      );

      if (usedOpenAiWithoutDeepL) {
        _showSnackBar(l10n.improveQualityWithApiKeys);
      }
    } catch (e) {
      if (!mounted) return;
      _showSnackBar(
        '${l10n.translationFailed}: ${e.toString().replaceAll('Exception: ', '')}',
      );
    } finally {
      if (mounted) {
        setState(() {
          _isTranslating = false;
        });
      }
    }
  }

  Future<void> _generateExamples() async {
    final l10n = AppLocalizations.of(context)!;

    if (_item1Controller.text.trim().isEmpty && _item2Controller.text.trim().isEmpty) {
      _showSnackBar(l10n.enterAtLeastOneItem);
      return;
    }

    final settings = ref.read(appSettingsProvider);
    if (settings.openaiApiKey == null || settings.openaiApiKey!.trim().isEmpty) {
      _showDetailedErrorDialog(
        l10n.openaiKeyRequired,
        l10n.aiItemCreatorOpenAiKeyNotConfigured,
        isApiKeyIssue: true,
      );
      return;
    }

    final package = _selectedPackage;
    if (package == null) {
      _showSnackBar(l10n.selectPackageFirst);
      return;
    }

    setState(() {
      _isGeneratingExamples = true;
    });

    try {
      final analysisService = TextAnalysisService(
        apiKey: settings.openaiApiKey!,
        model: _selectedModel,
      );

      // Use the item from language1 as the source
      final sourceText = _item1Controller.text.isNotEmpty
          ? _item1Controller.text
          : _item2Controller.text;

      // Generate examples using the service
      final examples = await analysisService.generateExamples(
        text: sourceText,
        sourceLang: package.languageName1,
        targetLang: package.languageName2,
      );

      if (examples.isNotEmpty) {
        // Populate first example if available
        if (examples.isNotEmpty) {
          final firstExample = examples[0];
          setState(() {
            _example1Item1Controller.text = firstExample['language1'] ?? '';
            _example1Item2Controller.text = firstExample['language2'] ?? '';
          });
        }

        // Populate second example if available
        if (examples.length > 1) {
          final secondExample = examples[1];
          setState(() {
            _example2Item1Controller.text = secondExample['language1'] ?? '';
            _example2Item2Controller.text = secondExample['language2'] ?? '';
          });
        }
      }
    } catch (e) {
      if (mounted) {
        _showDetailedErrorDialog(l10n.error, e.toString());
      }
    } finally {
      setState(() {
        _isGeneratingExamples = false;
      });
    }
  }

  Future<void> _saveItems() async {
    final l10n = AppLocalizations.of(context)!;

    final item1Text = _item1Controller.text.trim();
    final item2Text = _item2Controller.text.trim();

    if (item1Text.isEmpty || item2Text.isEmpty) {
      _showSnackBar(l10n.aiItemCreatorBothItemsRequired);
      return;
    }

    if (_selectedPackage == null) {
      _showSnackBar(l10n.selectPackageFirst);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final duplicateExists = await _doesDuplicateItemExist(
        packageId: _selectedPackage!.id,
        item1Text: item1Text,
        item2Text: item2Text,
      );

      if (duplicateExists) {
        if (mounted) {
          _showDetailedErrorDialog(l10n.duplicate, l10n.aiItemCreatorDuplicateItemMessage);
        }
        return;
      }

      // Create category if not exists
      Category? category;
      if (_selectedCategories.isNotEmpty) {
        category = _selectedCategories.first;
      } else {
        // Create a default category
        category = Category(
          id: DateTime.now().toString(),
          packageId: _selectedPackage!.id,
          name: l10n.aiItemCreatorDefaultCategoryName,
        );
        await _categoryRepo.insertCategory(category);
      }

      // Build examples list
      final examples = <ExampleSentence>[];
      if (_example1Item1Controller.text.isNotEmpty && _example1Item2Controller.text.isNotEmpty) {
        examples.add(ExampleSentence(
          id: '${DateTime.now().millisecondsSinceEpoch}_1',
          textLanguage1: _example1Item1Controller.text,
          textLanguage2: _example1Item2Controller.text,
        ));
      }
      if (_example2Item1Controller.text.isNotEmpty && _example2Item2Controller.text.isNotEmpty) {
        examples.add(ExampleSentence(
          id: '${DateTime.now().millisecondsSinceEpoch}_2',
          textLanguage1: _example2Item1Controller.text,
          textLanguage2: _example2Item2Controller.text,
        ));
      }

      // Create item with proper structure
      final item = Item(
        id: '${DateTime.now().millisecondsSinceEpoch}_${item1Text.hashCode}_${item2Text.hashCode}',
        packageId: _selectedPackage!.id,
        categoryIds: [category.id],
        language1Data: ItemLanguageData(
          languageCode: _selectedPackage!.languageCode1,
          text: item1Text,
          preItem: null,
          postItem: null,
        ),
        language2Data: ItemLanguageData(
          languageCode: _selectedPackage!.languageCode2,
          text: item2Text,
          preItem: null,
          postItem: null,
        ),
        examples: examples,
        isKnown: false,
        isFavourite: _isFavourite,
        isImportant: _isImportant,
        dontKnowCounter: 0,
        lastReviewedAt: null,
      );

      // Save item
      await _itemRepo.insertItem(item);

      if (mounted) {
        _showSnackBar(l10n.itemSavedSuccessfully);
        _clearItemFields();
      }
    } catch (e) {
      if (mounted) {
        _showDetailedErrorDialog(l10n.error, e.toString());
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String _normalizeItemText(String text) {
    return text.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');
  }

  Future<bool> _doesDuplicateItemExist({
    required String packageId,
    required String item1Text,
    required String item2Text,
  }) async {
    final existingItems = await _itemRepo.getItemsForPackage(packageId);
    final normalizedItem1 = _normalizeItemText(item1Text);
    final normalizedItem2 = _normalizeItemText(item2Text);

    return existingItems.any((item) {
      final existingItem1 = _normalizeItemText(item.language1Data.text);
      final existingItem2 = _normalizeItemText(item.language2Data.text);
      return existingItem1 == normalizedItem1 && existingItem2 == normalizedItem2;
    });
  }

  void _clearItemFields() {
    setState(() {
      _item1Controller.clear();
      _item2Controller.clear();
      _example1Item1Controller.clear();
      _example1Item2Controller.clear();
      _example2Item1Controller.clear();
      _example2Item2Controller.clear();
      _isFavourite = false;
      _isImportant = false;
    });
  }

  void _clearExamplePair(int pairIndex) {
    setState(() {
      if (pairIndex == 1) {
        _example1Item1Controller.clear();
        _example1Item2Controller.clear();
      } else if (pairIndex == 2) {
        _example2Item1Controller.clear();
        _example2Item2Controller.clear();
      }
    });
  }

  void _startNewConversation() {
    setState(() {
      _chatHistory.clear();
      _aiSuggestedItems = [];
      _aiNextPromptSuggestions = [];
      _aiResponseController.clear();
      _promptController.clear();
    });
  }

  bool _matchesLanguageCode(String a, String b) {
    final normalizedA = a.trim().toLowerCase().split('-').first;
    final normalizedB = b.trim().toLowerCase().split('-').first;
    return normalizedA == normalizedB;
  }

  String _shortLanguageCode(String languageCode) {
    return languageCode.trim().split('-').first.toUpperCase();
  }

  Future<void> _onSuggestedItemTapped(Map<String, String> item) async {
    if (_selectedPackage == null || _isSending || _isTranslating) return;

    final text = (item['text'] ?? '').trim();
    final code = (item['languageCode'] ?? '').trim();
    if (text.isEmpty) return;

    final package = _selectedPackage!;
    if (_matchesLanguageCode(code, package.languageCode1)) {
      setState(() {
        _item1Controller.text = text;
      });
      await _translate(true);
      _scrollToItemInputSection();
      return;
    }

    if (_matchesLanguageCode(code, package.languageCode2)) {
      setState(() {
        _item2Controller.text = text;
      });
      await _translate(false);
      _scrollToItemInputSection();
      return;
    }

    // Fallback: place in language 1 field and translate to language 2.
    setState(() {
      _item1Controller.text = text;
    });
    await _translate(true);
    _scrollToItemInputSection();
  }

  Future<void> _onConversationSuggestionTapped(String suggestion) async {
    if (_isSending) return;
    final prompt = suggestion.trim();
    if (prompt.isEmpty) return;
    setState(() {
      _promptController.text = prompt;
    });
    await _sendPrompt();
  }

  Future<void> _pastePromptFromClipboard() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    final text = data?.text;
    if (text == null || text.isEmpty) {
      return;
    }

    setState(() {
      _promptController.text = text;
      _promptController.selection = TextSelection.collapsed(offset: text.length);
    });
  }

  Future<void> _togglePromptVoiceInput() async {
    final l10n = AppLocalizations.of(context)!;

    if (_isListeningPrompt) {
      await _speech.stop();
      if (mounted) {
        setState(() => _isListeningPrompt = false);
      }
      return;
    }

    final available = await _speech.initialize(
      onStatus: (status) {
        if (!mounted) {
          return;
        }

        if (status == 'done' || status == 'notListening') {
          setState(() => _isListeningPrompt = false);
        }
      },
      onError: (error) {
        if (!mounted) {
          return;
        }

        setState(() => _isListeningPrompt = false);
        final message = error.permanent
            ? l10n.speechRecognitionPermissionDenied
            : '${l10n.speechRecognitionError}: ${error.errorMsg}';
        _showSnackBar(message);
      },
    );

    if (!available) {
      _showSnackBar(l10n.speechRecognitionNotAvailable);
      return;
    }

    final localeId = ref.read(appSettingsProvider).userLanguageCode;

    setState(() => _isListeningPrompt = true);
    _showSnackBar(l10n.listeningForSpeech);

    await _speech.listen(
      localeId: localeId,
      listenFor: const Duration(seconds: 60),
      pauseFor: const Duration(seconds: 4),
      listenOptions: stt.SpeechListenOptions(
        partialResults: true,
        cancelOnError: true,
        listenMode: stt.ListenMode.dictation,
      ),
      onResult: (result) {
        if (!mounted) {
          return;
        }

        setState(() {
          _promptController.text = result.recognizedWords;
          _promptController.selection = TextSelection.collapsed(
            offset: _promptController.text.length,
          );
        });

        if (result.finalResult) {
          setState(() => _isListeningPrompt = false);
          if (result.recognizedWords.trim().isEmpty) {
            _showSnackBar(l10n.speechNotRecognized);
          }
        }
      },
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _showDetailedErrorDialog(String title, String message, {bool isApiKeyIssue = false}) {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
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

  /// Scrolls so the bottom of the chat section (= last AI message) is visible.
  void _scrollToLastAiMessage() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctx = _chatSectionKey.currentContext;
      if (ctx == null || !mounted) return;
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        alignment: 1.0, // show bottom of the chat card (= last message)
      );
    });
  }

  /// Scrolls so the Item Inputs card is visible.
  void _scrollToItemInputSection() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctx = _itemInputSectionKey.currentContext;
      if (ctx == null || !mounted) return;
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        alignment: 0.0,
      );
    });
  }

  // ---------------------------------------------------------------------------
  // Layout detection helpers
  // ---------------------------------------------------------------------------

  /// Returns true when the narrower dimension of the screen is >= 600 dp,
  /// which is the standard Flutter tablet breakpoint.
  static bool _isTablet(BoxConstraints c) =>
      c.maxWidth.clamp(0, double.infinity) >= c.maxHeight
          ? c.maxHeight >= 600
          : c.maxWidth >= 600;

  static bool _isLandscape(BoxConstraints c) => c.maxWidth > c.maxHeight;

  // ---------------------------------------------------------------------------
  // build()
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 72,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.aiItemCreator, style: theme.textTheme.titleMedium),
            const SizedBox(height: 2),
            Text(
              l10n.aiItemCreatorAppBarHint,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.75),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final tablet = _isTablet(constraints);
            final landscape = _isLandscape(constraints);

            if (tablet && landscape) {
              return _buildTabletHorizontalLayout(theme, l10n);
            }

            // All other layouts: single column (tablet-portrait, phone-landscape,
            // phone-portrait) — will be specialised in a later step.
            return _buildSingleColumnLayout(theme, l10n);
          },
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Single-column layout  (phone-portrait baseline, reused by other modes
  // until they get their own specialised implementation)
  // ---------------------------------------------------------------------------

  Widget _buildSingleColumnLayout(ThemeData theme, AppLocalizations l10n) {
    final isEnabled = _selectedPackage != null;

    return Scrollbar(
      controller: _scrollController,
      child: ListView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppTheme.spacing4),
        children: [
          _buildModelLanguageCard(theme, l10n),

          if (!isEnabled)
            _buildNoPackagesCard(theme, l10n),

          if (isEnabled) ...[
            _buildChatSection(theme, l10n),
            _buildAiSuggestionsCard(theme, l10n, isPhoneLayout: true),
            _buildItemInputSection(theme, l10n),
            _buildExamplesSection(theme, l10n),
            // _buildActionButtons(theme, l10n),
          ],
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Tablet horizontal layout  (tablet + landscape)
  //
  //  ┌────────────────────────────┬───────────────────────────┐
  //  │  LEFT PANE  55%            │  RIGHT PANE  45%          │
  //  │  • Model selection card    │  • Item input section     │
  //  │  • Chat section            │  • Examples section       │
  //  │  • AI suggestions card     │  • Flags section          │
  //  │                            │  • Action buttons         │
  //  └────────────────────────────┴───────────────────────────┘
  //
  //  Both panes scroll independently.
  // ---------------------------------------------------------------------------

  Widget _buildTabletHorizontalLayout(ThemeData theme, AppLocalizations l10n) {
    final isEnabled = _selectedPackage != null;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── LEFT PANE ──────────────────────────────────────────────────────
        Expanded(
          flex: 55,
          child: Scrollbar(
            controller: _scrollController,
            child: ListView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(AppTheme.spacing4),
              children: [
                _buildModelLanguageCard(theme, l10n),

                if (!isEnabled)
                  _buildNoPackagesCard(theme, l10n),

                if (isEnabled) ...[
                  _buildChatSection(theme, l10n),
                  _buildAiSuggestionsCard(theme, l10n, isPhoneLayout: false),
                ],
              ],
            ),
          ),
        ),

        // ── DIVIDER ────────────────────────────────────────────────────────
        VerticalDivider(
          width: 1,
          thickness: 1,
          color: theme.colorScheme.outlineVariant,
        ),

        // ── RIGHT PANE ─────────────────────────────────────────────────────
        Expanded(
          flex: 45,
          child: Scrollbar(
            controller: _rightScrollController,
            child: ListView(
              controller: _rightScrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(AppTheme.spacing4),
              children: [
                if (!isEnabled)
                  _buildNoPackagesCard(theme, l10n),

                if (isEnabled) ...[
                  _buildItemInputSection(theme, l10n),
                  _buildExamplesSection(theme, l10n),
                  // _buildActionButtons(theme, l10n),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNoPackagesCard(ThemeData theme, AppLocalizations l10n) {
    final hasEligiblePackages = _availablePackages.isNotEmpty;
    final isDatabaseEmpty = _allPackages.isEmpty;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isDatabaseEmpty ? l10n.noPackagesYet : l10n.selectPackage,
              style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppTheme.spacing8),
            Text(
              isDatabaseEmpty
                  ? l10n.createFirstPackage
                  : hasEligiblePackages
                      ? l10n.selectPackageFirst
                      : l10n.noNonPurchasedPackagesAvailable,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: AppTheme.spacing12),
            FilledButton.icon(
              onPressed: hasEligiblePackages ? _openPackageSelectionDialog : _openPackageForm,
              icon: Icon(hasEligiblePackages ? Icons.list_alt : Icons.add),
              label: Text(hasEligiblePackages ? l10n.selectPackage : l10n.createNewPackage),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModelLanguageCard(ThemeData theme, AppLocalizations l10n) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.openaiModel,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  onPressed: () {
                    setState(() {
                      _isModelPanelExpanded = !_isModelPanelExpanded;
                    });
                  },
                  icon: Icon(
                    _isModelPanelExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                  ),
                ),
              ],
            ),
            if (_isModelPanelExpanded) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 2,
                    child: DropdownButtonFormField<String>(
                      initialValue: _selectedModel,
                      isExpanded: true,
                      style: theme.textTheme.bodySmall,
                      decoration: const InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: AppTheme.spacing8,
                          vertical: AppTheme.spacing8,
                        ),
                        border: OutlineInputBorder(),
                      ),
                      items: OpenAiModelCatalog.buildDropdownItems(l10n),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _selectedModel = value);
                          ref.read(appSettingsProvider.notifier).setOpenaiModel(value);
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacing8),
                  Expanded(
                    flex: 3,
                    child: Text(
                      OpenAiModelCatalog.descriptionFor(_selectedModel, l10n),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.spacing4),
              Text(
                l10n.aiItemCreatorModelCostTip,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildChatSection(ThemeData theme, AppLocalizations l10n) {
    if (_chatHistory.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      key: _chatSectionKey,
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.aiItemCreatorConversation,
              style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppTheme.spacing8),
            ..._chatHistory.map((message) {
              final isUser = message['role'] == 'user';
              final bubbleColor = isUser
                  ? theme.colorScheme.primaryContainer
                  : theme.colorScheme.surfaceContainerHighest;

              return Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: AppTheme.spacing8),
                child: Column(
                  crossAxisAlignment:
                      isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    Text(
                      isUser ? l10n.aiItemCreatorYou : l10n.aiItemCreatorCoach,
                      style: theme.textTheme.labelSmall,
                    ),
                    const SizedBox(height: AppTheme.spacing4),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppTheme.spacing8),
                      decoration: BoxDecoration(
                        color: bubbleColor,
                        border: Border.all(color: theme.colorScheme.outline),
                        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                      ),
                      child: SelectableText(message['content'] ?? ''),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildItemInputSection(ThemeData theme, AppLocalizations l10n) {
    final package = _selectedPackage;
    final lang1Code = package != null
        ? _shortLanguageCode(package.languageCode1)
        : l10n.language1;
    final lang2Code = package != null
        ? _shortLanguageCode(package.languageCode2)
        : l10n.language2;

    return Card(
      key: _itemInputSectionKey,
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.itemInputs,
                    style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  tooltip: l10n.clearItems,
                  icon: const Icon(Icons.clear),
                  onPressed: _clearItemFields,
                ),
                IconButton(
                  tooltip: l10n.saveItems,
                  icon: _isLoading
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.save),
                  onPressed: _isLoading ? null : _saveItems,
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacing8),
            TextField(
              controller: _item1Controller,
              decoration: InputDecoration(
                labelText: _selectedPackage != null ? _selectedPackage!.languageName1 : l10n.language1,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: AppTheme.spacing8),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isTranslating ? null : () => _translate(true),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacing8,
                        vertical: AppTheme.spacing8,
                      ),
                      textStyle: theme.textTheme.labelSmall,
                    ),
                    icon: _isTranslating
                        ? const SizedBox(
                            height: 14,
                            width: 14,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.arrow_downward, size: 14),
                    label: Text(l10n.translateToLanguageCode(lang2Code)),
                  ),
                ),
                const SizedBox(width: AppTheme.spacing8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isTranslating ? null : () => _translate(false),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacing8,
                        vertical: AppTheme.spacing8,
                      ),
                      textStyle: theme.textTheme.labelSmall,
                    ),
                    icon: _isTranslating
                        ? const SizedBox(
                            height: 14,
                            width: 14,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.arrow_upward, size: 14),
                    label: Text(l10n.translateToLanguageCode(lang1Code)),
                  ),
                ),
                const SizedBox(width: AppTheme.spacing8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isGeneratingExamples ? null : _generateExamples,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacing8,
                        vertical: AppTheme.spacing8,
                      ),
                      textStyle: theme.textTheme.labelSmall,
                    ),
                    icon: _isGeneratingExamples
                        ? const SizedBox(
                            height: 14,
                            width: 14,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.auto_awesome, size: 14),
                    label: Text(_isGeneratingExamples ? l10n.generating : l10n.generateExamples),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacing8),
            TextField(
              controller: _item2Controller,
              decoration: InputDecoration(
                labelText: _selectedPackage != null ? _selectedPackage!.languageName2 : l10n.language2,
                border: const OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAiSuggestionsCard(ThemeData theme, AppLocalizations l10n, {bool isPhoneLayout = false}) {
    final buttonPadding = isPhoneLayout
        ? const EdgeInsets.symmetric(horizontal: AppTheme.spacing4, vertical: AppTheme.spacing4)
        : const EdgeInsets.symmetric(horizontal: AppTheme.spacing8, vertical: AppTheme.spacing8);
    final buttonTextStyle = isPhoneLayout
        ? theme.textTheme.labelSmall
        : theme.textTheme.labelMedium;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.chatWithAI,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    _isListeningPrompt ? Icons.stop_circle : Icons.mic,
                    color: _isListeningPrompt ? theme.colorScheme.error : null,
                  ),
                  tooltip: _isListeningPrompt ? l10n.tapToStop : l10n.voiceInput,
                  onPressed: _togglePromptVoiceInput,
                ),
                IconButton(
                  icon: const Icon(Icons.content_paste),
                  tooltip: l10n.pasteFromClipboard,
                  onPressed: _pastePromptFromClipboard,
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacing8),
            TextField(
              controller: _promptController,
              decoration: InputDecoration(
                hintText: l10n.aiItemCreatorPromptHint,
                border: const OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: AppTheme.spacing8),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isSending ? null : _sendPrompt,
                    style: ElevatedButton.styleFrom(
                      padding: buttonPadding,
                      textStyle: buttonTextStyle,
                    ),
                    icon: _isSending
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.send),
                    label: Text(_isSending ? l10n.sending : l10n.send),
                  ),
                ),
                const SizedBox(width: AppTheme.spacing8),
                TextButton.icon(
                  onPressed: _chatHistory.isEmpty ? null : _startNewConversation,
                  style: TextButton.styleFrom(
                    padding: buttonPadding,
                    textStyle: buttonTextStyle,
                  ),
                  icon: const Icon(Icons.refresh),
                  label: Text(l10n.aiItemCreatorStartNewConversation),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacing8),
            Text(
              l10n.aiItemCreatorAiSuggestions,
              style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppTheme.spacing8),
            Text(
              l10n.aiItemCreatorTapChipToFill,
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: AppTheme.spacing8),
            if (_aiSuggestedItems.isEmpty)
              Text(
                l10n.aiItemCreatorNoSuggestedItems,
                style: theme.textTheme.bodySmall,
              )
            else
              Wrap(
                spacing: AppTheme.spacing4,
                runSpacing: AppTheme.spacing4,
                children: _aiSuggestedItems.map((item) {
                  final text = item['text'] ?? '';
                  final code = item['languageCode'] ?? '';
                  final package = _selectedPackage;
                  final isLang1 = package != null && _matchesLanguageCode(code, package.languageCode1);
                  final isLang2 = package != null && _matchesLanguageCode(code, package.languageCode2);

                  final chipBgColor = isLang1
                      ? theme.colorScheme.primaryContainer
                      : (isLang2
                          ? theme.colorScheme.secondaryContainer
                          : theme.colorScheme.surfaceContainerHighest);

                  final badgeLabel = isLang1
                      ? package.languageCode1.toUpperCase()
                      : (isLang2
                          ? package.languageCode2.toUpperCase()
                          : code.toUpperCase());

                  return ActionChip(
                    onPressed: (_isSending || _isTranslating)
                        ? null
                        : () => _onSuggestedItemTapped(item),
                    backgroundColor: chipBgColor,
                    avatar: CircleAvatar(
                      radius: 12,
                      child: Text(
                        badgeLabel,
                        style: theme.textTheme.labelSmall,
                      ),
                    ),
                    label: Text(text),
                  );
                }).toList(),
              ),
            const SizedBox(height: AppTheme.spacing8),
            Text(
              l10n.aiItemCreatorNextSteps,
              style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppTheme.spacing8),
            if (_aiNextPromptSuggestions.isEmpty)
              Text(
                l10n.aiItemCreatorNoNextSteps,
                style: theme.textTheme.bodySmall,
              )
            else
              Wrap(
                spacing: AppTheme.spacing4,
                runSpacing: AppTheme.spacing4,
                children: _aiNextPromptSuggestions.map((suggestion) {
                  return ActionChip(
                    onPressed: _isSending
                        ? null
                        : () => _onConversationSuggestionTapped(suggestion),
                    label: Text(suggestion),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildExamplesSection(ThemeData theme, AppLocalizations l10n) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /*
            Text(
              l10n.examples,
              style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppTheme.spacing8),
            */

            Row(
              children: [
                Expanded(
                  child: Text(
                    '${l10n.example} 1',
                    style: theme.textTheme.titleSmall,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  tooltip: l10n.delete,
                  onPressed: () => _clearExamplePair(1),
                ),
              ],
            ),
            TextField(
              controller: _example1Item1Controller,
              maxLines: null,
              minLines: 1,
              decoration: InputDecoration(
                labelText: '${l10n.example} 1 - ${_selectedPackage?.languageName1 ?? ""}',
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: AppTheme.spacing8),
            TextField(
              controller: _example1Item2Controller,
              maxLines: null,
              minLines: 1,
              decoration: InputDecoration(
                labelText: '${l10n.example} 1 - ${_selectedPackage?.languageName2 ?? ""}',
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: AppTheme.spacing8),
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${l10n.example} 2',
                    style: theme.textTheme.titleSmall,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  tooltip: l10n.delete,
                  onPressed: () => _clearExamplePair(2),
                ),
              ],
            ),
            TextField(
              controller: _example2Item1Controller,
              maxLines: null,
              minLines: 1,
              decoration: InputDecoration(
                labelText: '${l10n.example} 2 - ${_selectedPackage?.languageName1 ?? ""}',
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: AppTheme.spacing8),
            TextField(
              controller: _example2Item2Controller,
              maxLines: null,
              minLines: 1,
              decoration: InputDecoration(
                labelText: '${l10n.example} 2 - ${_selectedPackage?.languageName2 ?? ""}',
                border: const OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: AppTheme.spacing12),
            Text(
              l10n.flags,
              style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppTheme.spacing8),
            Wrap(
              runSpacing: AppTheme.spacing8,
              children: [
                InkWell(
                  onTap: () {
                    setState(() => _isFavourite = !_isFavourite);
                  },
                  borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                  child: Chip(
                    avatar: Icon(
                      _isFavourite ? Icons.star : Icons.star_outline,
                      size: 15,
                      color: _isFavourite
                          ? theme.colorScheme.tertiary
                          : theme.colorScheme.onSurfaceVariant,
                    ),
                    label: Text(
                      l10n.favorite,
                      style: theme.textTheme.bodyMedium,
                    ),
                    backgroundColor: _isFavourite
                        ? theme.colorScheme.tertiaryContainer.withValues(alpha: 0.3)
                        : null,
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() => _isImportant = !_isImportant);
                  },
                  borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                  child: Chip(
                    avatar: Icon(
                      _isImportant ? Icons.bookmark : Icons.bookmark_border,
                      size: 15,
                      color: _isImportant
                          ? theme.colorScheme.secondary
                          : theme.colorScheme.onSurfaceVariant,
                    ),
                    label: Text(
                      l10n.important,
                      style: theme.textTheme.bodyMedium,
                    ),
                    backgroundColor: _isImportant
                        ? theme.colorScheme.secondaryContainer.withValues(alpha: 0.3)
                        : null,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

}


