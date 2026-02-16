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
  String get selectIcon => 'Select Icon';

  @override
  String get defaultIcon => 'Default Icon';

  @override
  String get customIcon => 'Custom Icon';

  @override
  String get upload => 'Upload';

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
  String get onlyImportant => 'Only important items';

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
  String get userLanguage => 'User Language';

  @override
  String get userLanguageDescription => 'Your preferred UI language';

  @override
  String get apiKeys => 'API Keys';

  @override
  String get deeplApiKey => 'DeepL API Key';

  @override
  String get deeplApiKeyDescription =>
      'For premium translation quality (optional)';

  @override
  String get openaiApiKey => 'OpenAI API Key';

  @override
  String get openaiApiKeyDescription => 'For AI example generation';

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
}
