// lib/presentation/pages/ai_import/ai_item_creator_page.dart
//
// AI Item Creator - Create language items with AI assistance and translation support
//

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/text_analysis_service.dart';
import '../../../data/models/language_package.dart';
import '../../../data/models/item.dart';
import '../../../data/models/item_language_data.dart';
import '../../../data/models/category.dart';
import '../../../data/repositories/item_repository.dart';
import '../../../data/repositories/category_repository.dart';
import '../../../data/repositories/language_package_repository.dart';
import '../../../l10n/app_localizations.dart';
import '../../providers/app_settings_provider.dart';
import '../settings/app_settings_page.dart';
import '../../../data/models/example_sentence.dart';

class AIItemCreatorPage extends ConsumerStatefulWidget {
  const AIItemCreatorPage({super.key});

  @override
  ConsumerState<AIItemCreatorPage> createState() => _AIItemCreatorPageState();
}

class _AIItemCreatorPageState extends ConsumerState<AIItemCreatorPage> {
  LanguagePackage? _selectedPackage;
  List<LanguagePackage> _availablePackages = [];

  String _selectedModel = 'gpt-4-turbo';
  String _selectedLanguage = 'en';

  final _promptController = TextEditingController();
  final _aiResponseController = TextEditingController();

  final _item1Controller = TextEditingController();
  final _item2Controller = TextEditingController();

  final _example1Item1Controller = TextEditingController();
  final _example1Item2Controller = TextEditingController();
  final _example2Item1Controller = TextEditingController();
  final _example2Item2Controller = TextEditingController();

  List<Category> _selectedCategories = [];
  bool _isImportant = false;
  bool _isFavourite = false;

  bool _isLoading = false;
  bool _isSending = false;
  bool _isGeneratingExamples = false;

  final _itemRepo = ItemRepository();
  final _categoryRepo = CategoryRepository();
  final _packageRepo = LanguagePackageRepository();

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    // Load saved package and model selection
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final settings = ref.read(appSettingsProvider);

      setState(() {
        _selectedModel = settings.openaiModel;
        _selectedLanguage = settings.userLanguageCode;
      });

      // Load available non-purchased packages
      final packages = await _packageRepo.getAllPackages();
      final nonPurchasedPackages = packages.where((p) => !p.isPurchased).toList();

      setState(() {
        _availablePackages = nonPurchasedPackages;

        if (nonPurchasedPackages.isNotEmpty) {
          _selectedPackage = nonPurchasedPackages.first;
        }
      });
    });
  }

  @override
  void dispose() {
    _promptController.dispose();
    _aiResponseController.dispose();
    _item1Controller.dispose();
    _item2Controller.dispose();
    _example1Item1Controller.dispose();
    _example1Item2Controller.dispose();
    _example2Item1Controller.dispose();
    _example2Item2Controller.dispose();
    super.dispose();
  }

  Future<void> _onPackageChanged(LanguagePackage? package) async {
    if (package != null) {
      setState(() {
        _selectedPackage = package;
      });

      // Load categories for this package
      final categories = await _categoryRepo.getCategoriesForPackage(package.id);
      setState(() {
        _selectedCategories = categories.isNotEmpty ? [categories.first] : [];
      });
    }
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
        'OpenAI API key is not configured. Please add your API key in Settings.',
        isApiKeyIssue: true,
      );
      return;
    }

    setState(() {
      _isSending = true;
    });

    try {
      final analysisService = TextAnalysisService(
        apiKey: settings.openaiApiKey!,
        model: _selectedModel,
      );

      // Use a simple approach for chatting - send prompt directly
      // For now, use generateExamples as a workaround for prompt response
      // A better solution would be to add a generic "chat" method to TextAnalysisService
      final response = await analysisService.generateExamples(
        text: _promptController.text,
        sourceLang: _selectedLanguage,
        targetLang: _selectedLanguage,
      );

      // Format the response
      final responseText = response
          .map((e) => '${e['language1'] ?? ''}\n${e['language2'] ?? ''}')
          .join('\n\n');
      setState(() {
        _aiResponseController.text = responseText.isNotEmpty ? responseText : 'Processing complete';
      });
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

  Future<void> _translateWithDeepl(String text, bool toLang2) async {
    final l10n = AppLocalizations.of(context)!;

    if (_selectedPackage == null) {
      _showSnackBar(l10n.selectPackageFirst);
      return;
    }

    final settings = ref.read(appSettingsProvider);
    if (settings.deeplApiKey == null || settings.deeplApiKey!.trim().isEmpty) {
      _showSnackBar(l10n.deeplKeyRequired);
      return;
    }

    // TODO: Implement Deepl translation
    // This is a placeholder - implement actual Deepl API call
    _showSnackBar('Translation feature coming soon');
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
        'OpenAI API key is not configured.',
        isApiKeyIssue: true,
      );
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
        sourceLang: _selectedPackage?.languageName1 ?? _selectedLanguage,
        targetLang: _selectedPackage?.languageName2 ?? _selectedLanguage,
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

    if (_selectedPackage == null) {
      _showSnackBar(l10n.selectPackageFirst);
      return;
    }

    if (_item1Controller.text.trim().isEmpty && _item2Controller.text.trim().isEmpty) {
      _showSnackBar(l10n.enterAtLeastOneItem);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Create category if not exists
      Category? category;
      if (_selectedCategories.isNotEmpty) {
        category = _selectedCategories.first;
      } else {
        // Create a default category
        category = Category(
          id: DateTime.now().toString(),
          packageId: _selectedPackage!.id,
          name: 'AI Created',
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
        id: '${DateTime.now().millisecondsSinceEpoch}_${_item1Controller.text.hashCode}',
        packageId: _selectedPackage!.id,
        categoryIds: [category.id],
        language1Data: ItemLanguageData(
          languageCode: _selectedPackage!.languageCode1,
          text: _item1Controller.text.trim(),
          preItem: null,
          postItem: null,
        ),
        language2Data: ItemLanguageData(
          languageCode: _selectedPackage!.languageCode2,
          text: _item2Controller.text.trim(),
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
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _clearAllFields() {
    setState(() {
      _promptController.clear();
      _aiResponseController.clear();
      _item1Controller.clear();
      _item2Controller.clear();
      _example1Item1Controller.clear();
      _example1Item2Controller.clear();
      _example2Item1Controller.clear();
      _example2Item2Controller.clear();
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
    });
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final isEnabled = _selectedPackage != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.aiItemCreator, style: theme.textTheme.titleMedium),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacing12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Package selection
            _buildPackageSelectionCard(theme, l10n),
            const SizedBox(height: AppTheme.spacing12),

            // Model and language selection
            _buildModelLanguageCard(theme, l10n),
            const SizedBox(height: AppTheme.spacing12),

            // Chat section
            if (isEnabled) ...[
              _buildChatSection(theme, l10n),
              const SizedBox(height: AppTheme.spacing12),
            ],

            // Item input section
            if (isEnabled) ...[
              _buildItemInputSection(theme, l10n),
              const SizedBox(height: AppTheme.spacing12),
            ],

            // Translation buttons
            if (isEnabled) ...[
              _buildTranslationButtonsRow(theme, l10n),
              const SizedBox(height: AppTheme.spacing12),
            ],

            // Examples section
            if (isEnabled) ...[
              _buildExamplesSection(theme, l10n),
              const SizedBox(height: AppTheme.spacing12),
            ],

            // Category and flags section
            if (isEnabled) ...[
              _buildCategoryAndFlagsSection(theme, l10n),
              const SizedBox(height: AppTheme.spacing12),
            ],

            // Action buttons
            if (isEnabled) ...[
              _buildActionButtons(theme, l10n),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPackageSelectionCard(ThemeData theme, AppLocalizations l10n) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.selectPackage,
              style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppTheme.spacing8),
            DropdownButtonFormField<LanguagePackage>(
              initialValue: _selectedPackage,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: AppTheme.spacing8),
                border: OutlineInputBorder(),
              ),
              items: _availablePackages.map((p) {
                return DropdownMenuItem(
                  value: p,
                  child: Text(
                    p.packageName ?? '${p.languageName1} → ${p.languageName2}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: _onPackageChanged,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModelLanguageCard(ThemeData theme, AppLocalizations l10n) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.openaiModel,
                    style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: AppTheme.spacing4),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedModel,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: AppTheme.spacing8),
                      border: OutlineInputBorder(),
                    ),
                    items: [
                      DropdownMenuItem(value: 'gpt-3.5-turbo', child: Text(l10n.modelGpt35Turbo)),
                      DropdownMenuItem(value: 'gpt-4', child: Text(l10n.modelGpt4)),
                      DropdownMenuItem(value: 'gpt-4-turbo', child: Text(l10n.modelGpt4Turbo)),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _selectedModel = value);
                        ref.read(appSettingsProvider.notifier).setOpenaiModel(value);
                      }
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppTheme.spacing12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.userLanguage,
                    style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: AppTheme.spacing4),
                  TextFormField(
                    initialValue: _selectedLanguage,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: AppTheme.spacing8),
                      border: OutlineInputBorder(),
                    ),
                    readOnly: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatSection(ThemeData theme, AppLocalizations l10n) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.chatWithAI,
              style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppTheme.spacing8),
            TextField(
              controller: _promptController,
              decoration: InputDecoration(
                hintText: l10n.enterYourPrompt,
                border: const OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: AppTheme.spacing8),
            ElevatedButton.icon(
              onPressed: _isSending ? null : _sendPrompt,
              icon: _isSending ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.send),
              label: Text(_isSending ? l10n.sending : l10n.send),
            ),
            if (_aiResponseController.text.isNotEmpty) ...[
              const SizedBox(height: AppTheme.spacing12),
              Text(
                l10n.aiResponse,
                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: AppTheme.spacing8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppTheme.spacing8),
                decoration: BoxDecoration(
                  border: Border.all(color: theme.colorScheme.outline),
                  borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                ),
                child: SelectableText(_aiResponseController.text),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildItemInputSection(ThemeData theme, AppLocalizations l10n) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.itemInputs,
              style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
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

  Widget _buildTranslationButtonsRow(ThemeData theme, AppLocalizations l10n) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _translateWithDeepl(_item1Controller.text, false),
            icon: const Icon(Icons.translate),
            label: Text(l10n.translateLang1ToLang2),
          ),
        ),
        const SizedBox(width: AppTheme.spacing8),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _translateWithDeepl(_item2Controller.text, true),
            icon: const Icon(Icons.translate),
            label: Text(l10n.translateLang2ToLang1),
          ),
        ),
      ],
    );
  }

  Widget _buildExamplesSection(ThemeData theme, AppLocalizations l10n) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.examples,
                  style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  onPressed: _isGeneratingExamples ? null : _generateExamples,
                  icon: _isGeneratingExamples ? const SizedBox(height: 16, width: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.auto_awesome),
                  label: Text(_isGeneratingExamples ? l10n.generating : l10n.generateExamples),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacing12),
            TextField(
              controller: _example1Item1Controller,
              decoration: InputDecoration(
                labelText: '${l10n.example} 1 - ${_selectedPackage?.languageName1 ?? ""}',
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: AppTheme.spacing8),
            TextField(
              controller: _example1Item2Controller,
              decoration: InputDecoration(
                labelText: '${l10n.example} 1 - ${_selectedPackage?.languageName2 ?? ""}',
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: AppTheme.spacing12),
            TextField(
              controller: _example2Item1Controller,
              decoration: InputDecoration(
                labelText: '${l10n.example} 2 - ${_selectedPackage?.languageName1 ?? ""}',
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: AppTheme.spacing8),
            TextField(
              controller: _example2Item2Controller,
              decoration: InputDecoration(
                labelText: '${l10n.example} 2 - ${_selectedPackage?.languageName2 ?? ""}',
                border: const OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryAndFlagsSection(ThemeData theme, AppLocalizations l10n) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.flags,
              style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppTheme.spacing8),
            CheckboxListTile(
              title: Text(l10n.important),
              value: _isImportant,
              onChanged: (value) {
                setState(() => _isImportant = value ?? false);
              },
              dense: true,
            ),
            CheckboxListTile(
              title: Text(l10n.favorite),
              value: _isFavourite,
              onChanged: (value) {
                setState(() => _isFavourite = value ?? false);
              },
              dense: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(ThemeData theme, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton.icon(
          onPressed: _isLoading ? null : _saveItems,
          icon: _isLoading ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.save),
          label: Text(_isLoading ? l10n.saving : l10n.saveItems),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: AppTheme.spacing12),
          ),
        ),
        const SizedBox(height: AppTheme.spacing8),
        Row(
          children: [
            Expanded(
              child: TextButton.icon(
                onPressed: _clearItemFields,
                icon: const Icon(Icons.clear),
                label: Text(l10n.clearItems),
              ),
            ),
            const SizedBox(width: AppTheme.spacing8),
            Expanded(
              child: TextButton.icon(
                onPressed: _clearAllFields,
                icon: const Icon(Icons.delete_sweep),
                label: Text(l10n.clearAll),
              ),
            ),
          ],
        ),
      ],
    );
  }
}










