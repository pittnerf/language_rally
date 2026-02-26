// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get helloWorld => 'Hello World!';

  @override
  String get welcome => 'Welcome to Language Rally';

  @override
  String get appTitle => 'Language Rally';

  @override
  String get createPackage => 'Create Package';

  @override
  String get editPackage => 'Edit Package';

  @override
  String get packageDetails => 'Package Details';

  @override
  String get languageCode1 => 'Source Language Code';

  @override
  String get languageName1 => 'Source Language Name';

  @override
  String get languageCode2 => 'Target Language Code';

  @override
  String get languageName2 => 'Target Language Name';

  @override
  String get description => 'Description';

  @override
  String get descriptionHint => 'Brief description of this language package';

  @override
  String get authorName => 'Author Name';

  @override
  String get authorEmail => 'Author Email';

  @override
  String get authorWebpage => 'Author Webpage';

  @override
  String get version => 'Version';

  @override
  String get items => 'items';

  @override
  String get packageIcon => 'Package Icon';

  @override
  String get packageGroup => 'Package Group';

  @override
  String get selectIcon => 'Select Icon';

  @override
  String get defaultIcon => 'Default Icon';

  @override
  String get customIcon => 'Custom Icon';

  @override
  String get upload => 'Upload icon';

  @override
  String get uploadCustomIcon => 'Upload Custom Icon (max 512x512, 1MB)';

  @override
  String get customIconUploaded => 'Custom icon uploaded successfully';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get confirmDelete => 'Are you sure you want to delete this package?';

  @override
  String get packageSaved => 'Package saved successfully';

  @override
  String get packageDeleted => 'Package deleted successfully';

  @override
  String get errorSavingPackage => 'Error saving package';

  @override
  String get errorDeletingPackage => 'Error deleting package';

  @override
  String get fieldRequired => 'This field is required';

  @override
  String get invalidEmail => 'Invalid email address';

  @override
  String get invalidUrl => 'Invalid URL';

  @override
  String get readOnlyPackage =>
      'This package is read-only and cannot be edited';

  @override
  String get purchasedPackage => 'Purchased packages cannot be edited';

  @override
  String get badges => 'Badges';

  @override
  String get noBadges => 'No badges earned yet';

  @override
  String get selectLanguageCode => 'Select Language Code';

  @override
  String get clearCounters => 'Clear Counters';

  @override
  String get confirmClearCounters =>
      'Are you sure you want to clear all training counters for this package? This will reset the \'don\'t know\' counters and training statistics.';

  @override
  String get clear => 'Clear';

  @override
  String get countersCleared => 'Counters cleared successfully';

  @override
  String get errorClearingCounters => 'Error clearing counters';

  @override
  String get deleteAll => 'Delete Package';

  @override
  String get confirmDeleteAllData =>
      'Are you sure you want to delete this package with ALL its data? This will permanently delete all categories, items, and training statistics. This action cannot be undone!';

  @override
  String get allDataDeleted => 'Package and all data deleted successfully';

  @override
  String get exportPackage => 'Export Package';

  @override
  String get selectExportLocation => 'Select Export Location';

  @override
  String get packageExported => 'Package exported successfully';

  @override
  String get errorExportingPackage => 'Error exporting package';

  @override
  String get importItems => 'Import Items';

  @override
  String get selectImportFile => 'Select Import File';

  @override
  String get importFormat => 'Import Format';

  @override
  String get importFormatDescription =>
      'Import items from a text file. Each line should contain an item in the following format:';

  @override
  String get importResults => 'Import Results';

  @override
  String get successfullyImported => 'Successfully imported';

  @override
  String get failedToImport => 'Failed to import';

  @override
  String get errorImportingItems => 'Error importing items';

  @override
  String get error => 'Error';

  @override
  String get ok => 'OK';

  @override
  String get close => 'Close';

  @override
  String get importPackage => 'Import Package';

  @override
  String get importPackageTooltip => 'Import package from ZIP file';

  @override
  String get selectPackageZipFile => 'Select Package ZIP File';

  @override
  String get couldNotAccessFile => 'Could not access the selected file.';

  @override
  String get importingPackage => 'Importing package...';

  @override
  String get packageImportedSuccessfully => 'Package imported successfully!';

  @override
  String packageImportedWithItems(Object count) {
    return 'Package imported successfully! ($count items)';
  }

  @override
  String packageImportedWithGroup(Object count, Object groupName) {
    return 'Package imported to \"$groupName\" group! ($count items)';
  }

  @override
  String get importError => 'Import Error';

  @override
  String get failedToImportPackage => 'Failed to import package';

  @override
  String get packageAlreadyExists => 'Package already exists';

  @override
  String packageExistsMessage(Object groupName) {
    return 'A package with the same language pair, description, author information, and version already exists in the \"$groupName\" group. Would you like to import it as a new package anyway?';
  }

  @override
  String get importAsNew => 'Import Anyway';

  @override
  String get zipFileNotFound => 'ZIP file not found';

  @override
  String get invalidPackageZip =>
      'Invalid package ZIP: missing package_data.json';

  @override
  String get invalidPackageFormat => 'Invalid package file format';

  @override
  String get languagePackages => 'Language Packages';

  @override
  String get loadingPackages => 'Loading packages...';

  @override
  String get tapAndHoldToReorder => 'Tap and hold to reorder cards';

  @override
  String get tapAndHoldToReorderList =>
      'Tap and hold ≡ to reorder • Tap ⋮ to toggle compact view';

  @override
  String get noPackagesYet => 'No packages yet';

  @override
  String get createFirstPackage => 'Create your first language package';

  @override
  String get versionLabel => 'Version';

  @override
  String get purchased => 'Purchased';

  @override
  String get compactView => 'Compact view';

  @override
  String get expand => 'Expand';

  @override
  String get allCategories => 'All Categories';

  @override
  String get categoriesInPackage => 'Categories in this package';

  @override
  String get categories => 'Categories';

  @override
  String get testInterFonts => 'Test Inter Fonts';

  @override
  String get viewPackages => 'View Packages';

  @override
  String get createNewPackage => 'Create New Package';

  @override
  String get generateTestData => 'Generate Test Data';

  @override
  String get designSystemShowcase => 'Design System Showcase';

  @override
  String get badgeEarned => 'Badge Earned!';

  @override
  String get achievement => 'Achievement';

  @override
  String get awesome => 'Awesome!';

  @override
  String get importFormatNotes => 'Notes:';

  @override
  String get importFormatLine1 => '• Each line represents one item';

  @override
  String get importFormatLine2 => '• Fields are separated by |';

  @override
  String get importFormatLine3 => '• Categories are separated by ;';

  @override
  String get importFormatLine4 => '• The last | is optional';

  @override
  String get importFormatLine5 => '• Empty lines are ignored';

  @override
  String get importFormatLine6 => '• Duplicates are skipped';

  @override
  String importProgress(Object current, Object total) {
    return 'Importing $current of $total';
  }

  @override
  String get importFormatNewDescription =>
      'Import items from a text file. Each line should contain an item with fields separated by ---';

  @override
  String get importFormatNewLine1 => '• Main delimiter: ---';

  @override
  String get importFormatNewLine2 =>
      '• L1=<text> - Language 1 main text (required if L2 is missing)';

  @override
  String get importFormatNewLine3 =>
      '• L2=<text> - Language 2 main text (required if L1 is missing)';

  @override
  String get importFormatNewLine4 =>
      '• L1pre=<text> - Language 1 prefix (optional)';

  @override
  String get importFormatNewLine5 =>
      '• L1post=<text> - Language 1 suffix (optional)';

  @override
  String get importFormatNewLine6 =>
      '• L2pre=<text> - Language 2 prefix (optional)';

  @override
  String get importFormatNewLine7 =>
      '• L2post=<text> - Language 2 suffix (optional)';

  @override
  String get importFormatNewLine8 =>
      '• EX=<L1 text>:::<L2 text> - Example (optional, can be multiple)';

  @override
  String get importFormatNewLine9 =>
      '• CAT=<cat1>:::<cat2>:::<cat3> - Categories (optional)';

  @override
  String get importFormatNewLine10 =>
      '• At least one of L1= or L2= must be present';

  @override
  String get importFormatNewLine11 => '• Empty lines are ignored';

  @override
  String get importFormatNewLine12 => '• Duplicates are skipped';

  @override
  String get invalidImportLine => 'Invalid line';

  @override
  String get missingRequiredFields => 'Missing \'L1=\' vagy \'L2=\'';

  @override
  String get unknownField => 'Unknown field prefix';

  @override
  String andMore(Object count) {
    return '... and $count more';
  }

  @override
  String get browseItems => 'Browse Items';

  @override
  String get itemDetails => 'Details';

  @override
  String get filterItems => 'Filter Items';

  @override
  String searchLanguage1(Object language) {
    return 'Search in $language';
  }

  @override
  String searchLanguage2(Object language) {
    return 'Search in $language';
  }

  @override
  String get caseSensitive => 'Case sensitive';

  @override
  String get knownStatus => 'Known status';

  @override
  String get allItems => 'All items';

  @override
  String get itemsIKnew => 'Items I knew';

  @override
  String get itemsIDidNotKnow => 'Items I did not know';

  @override
  String get known => 'Known';

  @override
  String get important => 'Important';

  @override
  String get favourite => 'Favourite';

  @override
  String get examples => 'Examples';

  @override
  String get examplesHint =>
      'Enter example sentences (one per line, use | to separate languages)';

  @override
  String get noExamples => 'No examples available';

  @override
  String get pronounce => 'Pronounce';

  @override
  String get ttsError => 'Text-to-speech not available';

  @override
  String get noItemsFound => 'No items found';

  @override
  String get noItemsInPackage => 'No items in this package yet';

  @override
  String get clearFilters => 'Clear Filters';

  @override
  String itemCount(Object count) {
    return '$count items';
  }

  @override
  String filteredItemCount(Object filtered, Object total) {
    return '$filtered of $total items';
  }

  @override
  String get trainingRally => 'Training Rally';

  @override
  String get startTraining => 'Start Training';

  @override
  String get trainingComingSoon => 'Training Rally - Coming Soon!';

  @override
  String get aiServiceNotConfigured =>
      'AI service not configured. Please add your OpenAI API key.';

  @override
  String pleaseEnterTextInLanguageFirst(Object language) {
    return 'Please enter text in $language first';
  }

  @override
  String translationCompletedSuccessfully(Object service) {
    return 'Translation completed successfully using $service!';
  }

  @override
  String get translationFailed => 'Translation failed';

  @override
  String addedExamplesSuccessfully(Object count) {
    return 'Added $count example(s) successfully!';
  }

  @override
  String get failedToGenerateExamples => 'Failed to generate examples';

  @override
  String get selectExamplesToAdd => 'Select Examples to Add';

  @override
  String get selectWhichExamples =>
      'Select which examples you want to add to this item:';

  @override
  String get deselectAll => 'Deselect All';

  @override
  String get selectAll => 'Select All';

  @override
  String get addSelected => 'Add Selected';

  @override
  String get pleaseSelectAtLeastOne => 'Please select at least one example';

  @override
  String get addNewItem => 'Add New Item';

  @override
  String get editItem => 'Edit Item';

  @override
  String get deleteItem => 'Delete Item';

  @override
  String get confirmDeleteItem => 'Are you sure you want to delete this item?';

  @override
  String get thisActionCannotBeUndone => 'This action cannot be undone.';

  @override
  String get itemDeleted => 'Item deleted';

  @override
  String get errorDeletingItem => 'Error deleting item';

  @override
  String get errorSavingItem => 'Error saving item';

  @override
  String get itemSaved => 'Item updated successfully';

  @override
  String get itemCreated => 'Item created successfully';

  @override
  String get preTextOptional => 'Pre-text (optional)';

  @override
  String get mainText => 'Main text';

  @override
  String get postTextOptional => 'Post-text (optional)';

  @override
  String get forExampleToForVerbs => 'e.g., \"to\" for verbs';

  @override
  String get additionalContext => 'Additional context';

  @override
  String get translate => 'Translate';

  @override
  String translateFromTo(Object from, Object to) {
    return 'Translate $from → $to';
  }

  @override
  String get aiExampleGeneration => 'AI Example Generation';

  @override
  String get aiExampleSearch => 'AI Example Search';

  @override
  String searchExamplesOnInternet(Object text) {
    return 'Search for example sentences on the internet using AI for \'$text\'';
  }

  @override
  String generateExampleSentences(Object language) {
    return 'Generate example sentences based on the main text in $language';
  }

  @override
  String get generateExamples => 'Generate Examples';

  @override
  String get voiceInput => 'Voice input';

  @override
  String get settings => 'Settings';

  @override
  String get uiLanguage => 'UI Language';

  @override
  String get uiLanguageDescription => 'Application interface language';

  @override
  String get uiLanguageHelper =>
      'Select the language for menus, buttons, and labels';

  @override
  String get userLanguage => 'User Language';

  @override
  String get userLanguageDescription =>
      'Your preferred mother tongue for creating new language packages';

  @override
  String get apiKeys => 'API Keys';

  @override
  String get deeplApiKey => 'DeepL API Key';

  @override
  String get deeplApiKeyDescription =>
      'For premium translation quality when editing language items (optional)';

  @override
  String get openaiApiKey => 'OpenAI API Key';

  @override
  String get openaiApiKeyDescription =>
      'For example generation with AI when editing language items (optional)';

  @override
  String get enterApiKey => 'Enter API key';

  @override
  String get optional => 'optional';

  @override
  String get required => 'required';

  @override
  String get settingsSaved => 'Settings saved successfully';

  @override
  String get errorSavingSettings => 'Error saving settings';

  @override
  String get usingGoogleTranslate => 'Using free Google Translate';

  @override
  String get usingDeepL => 'Using DeepL (premium)';

  @override
  String get textCannotBeEmpty => 'Text cannot be empty';

  @override
  String get noTranslationReceivedFromGoogle =>
      'No translation received from Google';

  @override
  String get googleTranslationFailed => 'Google translation failed';

  @override
  String get googleTranslationError => 'Google translation error';

  @override
  String get noTranslationReceivedFromDeepL =>
      'No translation received from DeepL';

  @override
  String get invalidDeepLApiKey => 'Invalid DeepL API key';

  @override
  String get deeplTranslationQuotaExceeded =>
      'DeepL translation quota exceeded';

  @override
  String get deeplTranslationFailed => 'DeepL translation failed';

  @override
  String get deeplTranslationError => 'DeepL translation error';

  @override
  String get invalidApiKeyConfigureOpenAI =>
      'Invalid API key. Please configure your OpenAI API key.';

  @override
  String get apiRateLimitExceeded =>
      'API rate limit exceeded. Please try again later.';

  @override
  String get aiRequestFailed => 'AI request failed';

  @override
  String get failedToParseAiResponse =>
      'Failed to parse AI response. Please try again.';

  @override
  String get aiGenerationError => 'AI generation error';

  @override
  String get voiceInputPlaceholder =>
      'Voice input will be implemented using speech_to_text package';

  @override
  String get improveQualityWithApiKeys =>
      '💡 Tip: The quality of translations and example searches can be significantly improved by adding your DeepL and OpenAI API keys in the application settings.';

  @override
  String get noApiKeyFallbackMessage =>
      'Without API keys, basic translation and limited examples are provided. For best results, configure your API keys in Settings.';

  @override
  String get listeningForSpeech => 'Listening... Speak now';

  @override
  String get speechRecognitionNotAvailable =>
      'Speech recognition is not available on this device';

  @override
  String get speechRecognitionPermissionDenied =>
      'Speech recognition permission was denied';

  @override
  String get speechRecognitionError => 'Speech recognition error';

  @override
  String get tapToSpeak => 'Tap microphone to speak';

  @override
  String get speechNotRecognized =>
      'No speech was recognized. Please try again.';

  @override
  String get trainingSettings => 'Training Settings';

  @override
  String get itemScope => 'Item Scope';

  @override
  String get lastNItems => 'Last N items';

  @override
  String get onlyUnknown => 'Only unknown items';

  @override
  String get onlyImportant => 'Only important items';

  @override
  String get onlyFavourite => 'Only favourite items';

  @override
  String get numberOfItems => 'Number of Items';

  @override
  String get itemOrder => 'Item Order';

  @override
  String get randomOrder => 'Random order';

  @override
  String get sequentialOrder => 'Sequential order';

  @override
  String get displayLanguage => 'Display Language';

  @override
  String get motherTongue => 'Mother tongue';

  @override
  String get targetLanguage => 'Target language';

  @override
  String get randomLanguage => 'Random';

  @override
  String get categoryFilter => 'Category Filter';

  @override
  String get categoryFilterHint =>
      'Select categories to include (empty = all categories)';

  @override
  String get noCategories => 'No categories available';

  @override
  String get dontKnowThreshold => 'Don\'t Know Threshold';

  @override
  String get dontKnowThresholdHint =>
      'Number of times an item needs to be marked as \'don\'t know\' before special handling';

  @override
  String get startTrainingRally => 'Start Training Rally';

  @override
  String get clearTrainingSettings => 'Clear Settings';

  @override
  String get confirmClearTrainingSettings =>
      'Are you sure you want to reset all training settings to default values?';

  @override
  String get trainingSettingsCleared => 'Training settings have been cleared';

  @override
  String get startingTraining => 'Starting training...';

  @override
  String get noMoreItemsToDisplay =>
      'No more items to display based on your filter settings.';

  @override
  String get noItems => 'No Items';

  @override
  String get trainingComplete => 'Training Complete';

  @override
  String get allItemsCompleted =>
      'Congratulations! You have completed all items in this training session.';

  @override
  String get closeTraining => 'Close Training';

  @override
  String get confirmCloseTraining =>
      'Are you sure you want to close the training? Your progress has been saved.';

  @override
  String get question => 'Question';

  @override
  String get answer => 'Answer';

  @override
  String get iKnow => 'I Know';

  @override
  String get iDontKnow => 'I Don\'t Know';

  @override
  String get nextItem => 'Next Item';

  @override
  String get iDidNotKnowEither => 'I Didn\'t Know Either';

  @override
  String get exportBeforeDelete => 'Export Before Deleting?';

  @override
  String get aiTextAnalysis => 'AI Text Analysis';

  @override
  String get aiTextAnalysisImport => 'AI Text Analysis Import';

  @override
  String get knowledgeLevel => 'Knowledge Level';

  @override
  String get a1Beginner => 'A1 - Beginner';

  @override
  String get a2Elementary => 'A2 - Elementary';

  @override
  String get b1Intermediate => 'B1 - Intermediate';

  @override
  String get b2UpperIntermediate => 'B2 - Upper Intermediate';

  @override
  String get c1Advanced => 'C1 - Advanced';

  @override
  String get c2Proficient => 'C2 - Proficient';

  @override
  String get pasteTextHere => 'Paste your text here...';

  @override
  String get extractWords => 'Extract Words';

  @override
  String get extractExpressions => 'Extract Expressions';

  @override
  String get maxItems => 'Maximum Items';

  @override
  String get maxItemsHint => 'Leave empty for no limit';

  @override
  String get categoryName => 'Category Name';

  @override
  String get categoryNameHint => 'Name for imported items category';

  @override
  String get analyzeText => 'Analyze Text';

  @override
  String get configureAnalysis => 'Configure Analysis';

  @override
  String get openaiModel => 'AI Model';

  @override
  String get openaiModelDescription => 'Select ChatGPT model';

  @override
  String get modelGpt35Turbo => 'GPT-3.5 Turbo';

  @override
  String get modelGpt35Turbo16k => 'GPT-3.5 Turbo 16K';

  @override
  String get modelGpt4 => 'GPT-4';

  @override
  String get modelGpt4Turbo => 'GPT-4 Turbo';

  @override
  String get modelGpt35TurboDesc =>
      'Fast and cost-effective; standard for production';

  @override
  String get modelGpt35Turbo16kDesc =>
      'Same as GPT-3.5, but 16K token context window';

  @override
  String get modelGpt4Desc =>
      'Higher accuracy/reasoning; slower and more expensive';

  @override
  String get modelGpt4TurboDesc =>
      'Faster, cheaper, high accuracy; improved context';

  @override
  String get analyzing => 'Analyzing...';

  @override
  String get languageDetected => 'Language Detected';

  @override
  String get itemsFound => 'Items Found';

  @override
  String get selectItemsToImport => 'Select Items to Import';

  @override
  String get importSelected => 'Import Selected';

  @override
  String get importing => 'Importing...';

  @override
  String get itemsImported => 'Items imported successfully';

  @override
  String get noItemsSelected => 'No items selected';

  @override
  String get selectAtLeastOneType =>
      'Select at least one type (words or expressions)';

  @override
  String get languageNotMatching =>
      'The detected language does not match any language in the package';

  @override
  String get openaiKeyRequired => 'OpenAI API key is required for this feature';

  @override
  String analyzingProgress(Object current, Object total) {
    return 'Analyzing: $current / $total';
  }

  @override
  String translatingProgress(Object current, Object total) {
    return 'Translating: $current / $total';
  }

  @override
  String get duplicate => 'Duplicate';

  @override
  String get detectingLanguage => 'Detecting language...';

  @override
  String get extractingItems => 'Extracting items...';

  @override
  String get checkingDuplicates => 'Checking for duplicates...';

  @override
  String get translating => 'Translating...';

  @override
  String get generatingExamples => 'Generating examples...';

  @override
  String get errorAnalyzingText => 'Error analyzing text';

  @override
  String get warning => 'Warning';

  @override
  String get textIsVeryLarge => 'The text is very large';

  @override
  String get words => 'words';

  @override
  String get continueAnalysis =>
      'This may take longer to process and will be analyzed in chunks. Do you want to continue';

  @override
  String get continueLabel => 'Continue';

  @override
  String get exportBeforeDeleteMessage =>
      'Would you like to export this package before deleting it? This will save all your data to a ZIP file.';

  @override
  String get deleteWithoutExport => 'Delete Without Export';

  @override
  String get exportAndDelete => 'Export and Delete';

  @override
  String get exportingPackage => 'Exporting package...';

  @override
  String packageExportedToPath(Object path) {
    return 'Package exported to: $path';
  }

  @override
  String errorLoadingItems(Object error) {
    return 'Error loading items: $error';
  }

  @override
  String badgeEarnedWithName(Object badgeName) {
    return 'Badge Earned: $badgeName!';
  }

  @override
  String badgeLostWithName(Object badgeName) {
    return 'Badge Lost: $badgeName';
  }

  @override
  String get speakText => 'Speak text';

  @override
  String get trainingSessionProgress => 'Training Session Progress';

  @override
  String get total => 'Total';

  @override
  String lastNValue(Object value) {
    return 'N = $value';
  }

  @override
  String errorLoadingSettings(Object error) {
    return 'Error loading settings: $error';
  }

  @override
  String get selectPackage => 'Select Package';

  @override
  String get noPackagesAvailable => 'No packages available';

  @override
  String get possibleSolutions => 'Possible Solutions';

  @override
  String get technicalDetails => 'Technical Details';

  @override
  String get checkApiKey => 'Check your OpenAI API key';

  @override
  String get ensureValidOpenAIKey => 'Ensure the API key is valid and active';

  @override
  String get verifyKeyInSettings => 'Verify the key in Settings';

  @override
  String get rateLimitExceeded => 'API rate limit exceeded';

  @override
  String get waitAndRetry => 'Wait a few minutes and try again';

  @override
  String get checkAccountQuota => 'Check your OpenAI account quota';

  @override
  String get invalidRequest => 'Invalid request format';

  @override
  String get tryReducingTextLength => 'Try reducing the text length';

  @override
  String get checkTextFormat => 'Check that the text format is correct';

  @override
  String get checkInternetConnection => 'Check your internet connection';

  @override
  String get retryInMoment => 'Retry in a moment';

  @override
  String get checkFirewall => 'Check firewall settings';

  @override
  String get textMayBeTooShort => 'Text may be too short';

  @override
  String get tryDifferentKnowledgeLevel => 'Try a different knowledge level';

  @override
  String get ensureTextInCorrectLanguage =>
      'Ensure text is in the correct language';

  @override
  String get requestTimedOut => 'Request timed out';

  @override
  String get textMayBeTooLong => 'Text may be too long';

  @override
  String get tryAgainOrReduceSize => 'Try again or reduce text size';

  @override
  String get unexpectedError => 'An unexpected error occurred';

  @override
  String get checkErrorDetails => 'Check error details below';

  @override
  String get tryAgainLater => 'Try again later';

  @override
  String get translationServiceFailed => 'Translation service failed';

  @override
  String get checkApiKeys => 'Check your API keys (DeepL, OpenAI)';

  @override
  String get retryImport => 'Retry the import';

  @override
  String get exampleGenerationFailed => 'Example generation failed';

  @override
  String get itemsStillImported => 'Items were still imported';

  @override
  String get canAddExamplesManually => 'You can add examples manually later';

  @override
  String get databaseError => 'Database error occurred';

  @override
  String get checkStorageSpace => 'Check available storage space';

  @override
  String get restartApp => 'Try restarting the app';
}
