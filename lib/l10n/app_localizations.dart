import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hu.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hu'),
  ];

  /// No description provided for @helloWorld.
  ///
  /// In en, this message translates to:
  /// **'Hello World!'**
  String get helloWorld;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Language Rally'**
  String get welcome;

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Language Rally'**
  String get appTitle;

  /// No description provided for @createPackage.
  ///
  /// In en, this message translates to:
  /// **'Create Package'**
  String get createPackage;

  /// No description provided for @editPackage.
  ///
  /// In en, this message translates to:
  /// **'Edit Package'**
  String get editPackage;

  /// No description provided for @packageDetails.
  ///
  /// In en, this message translates to:
  /// **'Package Details'**
  String get packageDetails;

  /// No description provided for @languageCode1.
  ///
  /// In en, this message translates to:
  /// **'Source Language Code'**
  String get languageCode1;

  /// No description provided for @languageName1.
  ///
  /// In en, this message translates to:
  /// **'Source Language Name'**
  String get languageName1;

  /// No description provided for @languageCode2.
  ///
  /// In en, this message translates to:
  /// **'Target Language Code'**
  String get languageCode2;

  /// No description provided for @languageName2.
  ///
  /// In en, this message translates to:
  /// **'Target Language Name'**
  String get languageName2;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @descriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Brief description of this language package'**
  String get descriptionHint;

  /// No description provided for @authorName.
  ///
  /// In en, this message translates to:
  /// **'Author Name'**
  String get authorName;

  /// No description provided for @authorEmail.
  ///
  /// In en, this message translates to:
  /// **'Author Email'**
  String get authorEmail;

  /// No description provided for @authorWebpage.
  ///
  /// In en, this message translates to:
  /// **'Author Webpage'**
  String get authorWebpage;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @items.
  ///
  /// In en, this message translates to:
  /// **'items'**
  String get items;

  /// No description provided for @packageIcon.
  ///
  /// In en, this message translates to:
  /// **'Package Icon'**
  String get packageIcon;

  /// No description provided for @packageGroup.
  ///
  /// In en, this message translates to:
  /// **'Package Group'**
  String get packageGroup;

  /// No description provided for @selectIcon.
  ///
  /// In en, this message translates to:
  /// **'Select Icon'**
  String get selectIcon;

  /// No description provided for @defaultIcon.
  ///
  /// In en, this message translates to:
  /// **'Default Icon'**
  String get defaultIcon;

  /// No description provided for @customIcon.
  ///
  /// In en, this message translates to:
  /// **'Custom Icon'**
  String get customIcon;

  /// No description provided for @upload.
  ///
  /// In en, this message translates to:
  /// **'Upload icon'**
  String get upload;

  /// No description provided for @uploadCustomIcon.
  ///
  /// In en, this message translates to:
  /// **'Upload Custom Icon (max 512x512, 1MB)'**
  String get uploadCustomIcon;

  /// No description provided for @customIconUploaded.
  ///
  /// In en, this message translates to:
  /// **'Custom icon uploaded successfully'**
  String get customIconUploaded;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @confirmDelete.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this package?'**
  String get confirmDelete;

  /// No description provided for @packageSaved.
  ///
  /// In en, this message translates to:
  /// **'Package saved successfully'**
  String get packageSaved;

  /// No description provided for @packageDeleted.
  ///
  /// In en, this message translates to:
  /// **'Package deleted successfully'**
  String get packageDeleted;

  /// No description provided for @errorSavingPackage.
  ///
  /// In en, this message translates to:
  /// **'Error saving package'**
  String get errorSavingPackage;

  /// No description provided for @errorDeletingPackage.
  ///
  /// In en, this message translates to:
  /// **'Error deleting package'**
  String get errorDeletingPackage;

  /// No description provided for @fieldRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get fieldRequired;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid email address'**
  String get invalidEmail;

  /// No description provided for @invalidUrl.
  ///
  /// In en, this message translates to:
  /// **'Invalid URL'**
  String get invalidUrl;

  /// No description provided for @readOnlyPackage.
  ///
  /// In en, this message translates to:
  /// **'This package is read-only and cannot be edited'**
  String get readOnlyPackage;

  /// No description provided for @purchasedPackage.
  ///
  /// In en, this message translates to:
  /// **'Purchased packages cannot be edited'**
  String get purchasedPackage;

  /// No description provided for @badges.
  ///
  /// In en, this message translates to:
  /// **'Badges'**
  String get badges;

  /// No description provided for @noBadges.
  ///
  /// In en, this message translates to:
  /// **'No badges earned yet'**
  String get noBadges;

  /// No description provided for @selectLanguageCode.
  ///
  /// In en, this message translates to:
  /// **'Select Language Code'**
  String get selectLanguageCode;

  /// No description provided for @clearCounters.
  ///
  /// In en, this message translates to:
  /// **'Clear Counters'**
  String get clearCounters;

  /// No description provided for @confirmClearCounters.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to clear all training counters for this package? This will reset the \'don\'t know\' counters and training statistics.'**
  String get confirmClearCounters;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @countersCleared.
  ///
  /// In en, this message translates to:
  /// **'Counters cleared successfully'**
  String get countersCleared;

  /// No description provided for @errorClearingCounters.
  ///
  /// In en, this message translates to:
  /// **'Error clearing counters'**
  String get errorClearingCounters;

  /// No description provided for @deleteAll.
  ///
  /// In en, this message translates to:
  /// **'Delete Package'**
  String get deleteAll;

  /// No description provided for @confirmDeleteAllData.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this package with ALL its data? This will permanently delete all categories, items, and training statistics. This action cannot be undone!'**
  String get confirmDeleteAllData;

  /// No description provided for @allDataDeleted.
  ///
  /// In en, this message translates to:
  /// **'Package and all data deleted successfully'**
  String get allDataDeleted;

  /// No description provided for @exportPackage.
  ///
  /// In en, this message translates to:
  /// **'Export Package'**
  String get exportPackage;

  /// No description provided for @selectExportLocation.
  ///
  /// In en, this message translates to:
  /// **'Select Export Location'**
  String get selectExportLocation;

  /// No description provided for @packageExported.
  ///
  /// In en, this message translates to:
  /// **'Package exported successfully'**
  String get packageExported;

  /// No description provided for @errorExportingPackage.
  ///
  /// In en, this message translates to:
  /// **'Error exporting package'**
  String get errorExportingPackage;

  /// No description provided for @importItems.
  ///
  /// In en, this message translates to:
  /// **'Import Items'**
  String get importItems;

  /// No description provided for @selectImportFile.
  ///
  /// In en, this message translates to:
  /// **'Select Import File'**
  String get selectImportFile;

  /// No description provided for @importFormat.
  ///
  /// In en, this message translates to:
  /// **'Import Format'**
  String get importFormat;

  /// No description provided for @importFormatDescription.
  ///
  /// In en, this message translates to:
  /// **'Import items from a text file. Each line should contain an item in the following format:'**
  String get importFormatDescription;

  /// No description provided for @importResults.
  ///
  /// In en, this message translates to:
  /// **'Import Results'**
  String get importResults;

  /// No description provided for @successfullyImported.
  ///
  /// In en, this message translates to:
  /// **'Successfully imported'**
  String get successfullyImported;

  /// No description provided for @failedToImport.
  ///
  /// In en, this message translates to:
  /// **'Failed to import'**
  String get failedToImport;

  /// No description provided for @errorImportingItems.
  ///
  /// In en, this message translates to:
  /// **'Error importing items'**
  String get errorImportingItems;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @importPackage.
  ///
  /// In en, this message translates to:
  /// **'Import Package'**
  String get importPackage;

  /// No description provided for @importPackageTooltip.
  ///
  /// In en, this message translates to:
  /// **'Import package from ZIP file'**
  String get importPackageTooltip;

  /// No description provided for @selectPackageZipFile.
  ///
  /// In en, this message translates to:
  /// **'Select Package ZIP File'**
  String get selectPackageZipFile;

  /// No description provided for @couldNotAccessFile.
  ///
  /// In en, this message translates to:
  /// **'Could not access the selected file.'**
  String get couldNotAccessFile;

  /// No description provided for @importingPackage.
  ///
  /// In en, this message translates to:
  /// **'Importing package...'**
  String get importingPackage;

  /// No description provided for @packageImportedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Package imported successfully!'**
  String get packageImportedSuccessfully;

  /// No description provided for @packageImportedWithItems.
  ///
  /// In en, this message translates to:
  /// **'Package imported successfully! ({count} items)'**
  String packageImportedWithItems(Object count);

  /// No description provided for @packageImportedWithGroup.
  ///
  /// In en, this message translates to:
  /// **'Package imported to \"{groupName}\" group! ({count} items)'**
  String packageImportedWithGroup(Object count, Object groupName);

  /// No description provided for @importError.
  ///
  /// In en, this message translates to:
  /// **'Import Error'**
  String get importError;

  /// No description provided for @failedToImportPackage.
  ///
  /// In en, this message translates to:
  /// **'Failed to import package'**
  String get failedToImportPackage;

  /// No description provided for @packageAlreadyExists.
  ///
  /// In en, this message translates to:
  /// **'Package already exists'**
  String get packageAlreadyExists;

  /// No description provided for @packageExistsMessage.
  ///
  /// In en, this message translates to:
  /// **'A package with the same language pair, description, author information, and version already exists in the \"{groupName}\" group. Would you like to import it as a new package anyway?'**
  String packageExistsMessage(Object groupName);

  /// No description provided for @importAsNew.
  ///
  /// In en, this message translates to:
  /// **'Import Anyway'**
  String get importAsNew;

  /// No description provided for @zipFileNotFound.
  ///
  /// In en, this message translates to:
  /// **'ZIP file not found'**
  String get zipFileNotFound;

  /// No description provided for @invalidPackageZip.
  ///
  /// In en, this message translates to:
  /// **'Invalid package ZIP: missing package_data.json'**
  String get invalidPackageZip;

  /// No description provided for @invalidPackageFormat.
  ///
  /// In en, this message translates to:
  /// **'Invalid package file format'**
  String get invalidPackageFormat;

  /// No description provided for @languagePackages.
  ///
  /// In en, this message translates to:
  /// **'Language Packages'**
  String get languagePackages;

  /// No description provided for @loadingPackages.
  ///
  /// In en, this message translates to:
  /// **'Loading packages...'**
  String get loadingPackages;

  /// No description provided for @tapAndHoldToReorder.
  ///
  /// In en, this message translates to:
  /// **'Tap and hold to reorder cards'**
  String get tapAndHoldToReorder;

  /// No description provided for @tapAndHoldToReorderList.
  ///
  /// In en, this message translates to:
  /// **'Tap and hold ≡ to reorder • Tap ⋮ to toggle compact view'**
  String get tapAndHoldToReorderList;

  /// No description provided for @noPackagesYet.
  ///
  /// In en, this message translates to:
  /// **'No packages yet'**
  String get noPackagesYet;

  /// No description provided for @createFirstPackage.
  ///
  /// In en, this message translates to:
  /// **'Create your first language package'**
  String get createFirstPackage;

  /// No description provided for @versionLabel.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get versionLabel;

  /// No description provided for @purchased.
  ///
  /// In en, this message translates to:
  /// **'Purchased'**
  String get purchased;

  /// No description provided for @compactView.
  ///
  /// In en, this message translates to:
  /// **'Compact view'**
  String get compactView;

  /// No description provided for @expand.
  ///
  /// In en, this message translates to:
  /// **'Expand'**
  String get expand;

  /// No description provided for @allCategories.
  ///
  /// In en, this message translates to:
  /// **'All Categories'**
  String get allCategories;

  /// No description provided for @categoriesInPackage.
  ///
  /// In en, this message translates to:
  /// **'Categories in this package'**
  String get categoriesInPackage;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @testInterFonts.
  ///
  /// In en, this message translates to:
  /// **'Test Inter Fonts'**
  String get testInterFonts;

  /// No description provided for @viewPackages.
  ///
  /// In en, this message translates to:
  /// **'View Packages'**
  String get viewPackages;

  /// No description provided for @createNewPackage.
  ///
  /// In en, this message translates to:
  /// **'Create New Package'**
  String get createNewPackage;

  /// No description provided for @generateTestData.
  ///
  /// In en, this message translates to:
  /// **'Generate Test Data'**
  String get generateTestData;

  /// No description provided for @designSystemShowcase.
  ///
  /// In en, this message translates to:
  /// **'Design System Showcase'**
  String get designSystemShowcase;

  /// No description provided for @badgeEarned.
  ///
  /// In en, this message translates to:
  /// **'Badge Earned!'**
  String get badgeEarned;

  /// No description provided for @achievement.
  ///
  /// In en, this message translates to:
  /// **'Achievement'**
  String get achievement;

  /// No description provided for @awesome.
  ///
  /// In en, this message translates to:
  /// **'Awesome!'**
  String get awesome;

  /// No description provided for @importFormatNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes:'**
  String get importFormatNotes;

  /// No description provided for @importFormatLine1.
  ///
  /// In en, this message translates to:
  /// **'• Each line represents one item'**
  String get importFormatLine1;

  /// No description provided for @importFormatLine2.
  ///
  /// In en, this message translates to:
  /// **'• Fields are separated by |'**
  String get importFormatLine2;

  /// No description provided for @importFormatLine3.
  ///
  /// In en, this message translates to:
  /// **'• Categories are separated by ;'**
  String get importFormatLine3;

  /// No description provided for @importFormatLine4.
  ///
  /// In en, this message translates to:
  /// **'• The last | is optional'**
  String get importFormatLine4;

  /// No description provided for @importFormatLine5.
  ///
  /// In en, this message translates to:
  /// **'• Empty lines are ignored'**
  String get importFormatLine5;

  /// No description provided for @importFormatLine6.
  ///
  /// In en, this message translates to:
  /// **'• Duplicates are skipped'**
  String get importFormatLine6;

  /// No description provided for @andMore.
  ///
  /// In en, this message translates to:
  /// **'... and {count} more'**
  String andMore(Object count);

  /// No description provided for @browseItems.
  ///
  /// In en, this message translates to:
  /// **'Browse Items'**
  String get browseItems;

  /// No description provided for @itemDetails.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get itemDetails;

  /// No description provided for @filterItems.
  ///
  /// In en, this message translates to:
  /// **'Filter Items'**
  String get filterItems;

  /// No description provided for @searchLanguage1.
  ///
  /// In en, this message translates to:
  /// **'Search in {language}'**
  String searchLanguage1(Object language);

  /// No description provided for @searchLanguage2.
  ///
  /// In en, this message translates to:
  /// **'Search in {language}'**
  String searchLanguage2(Object language);

  /// No description provided for @caseSensitive.
  ///
  /// In en, this message translates to:
  /// **'Case sensitive'**
  String get caseSensitive;

  /// No description provided for @onlyImportant.
  ///
  /// In en, this message translates to:
  /// **'Only important items'**
  String get onlyImportant;

  /// No description provided for @knownStatus.
  ///
  /// In en, this message translates to:
  /// **'Known status'**
  String get knownStatus;

  /// No description provided for @allItems.
  ///
  /// In en, this message translates to:
  /// **'All items'**
  String get allItems;

  /// No description provided for @itemsIKnew.
  ///
  /// In en, this message translates to:
  /// **'Items I knew'**
  String get itemsIKnew;

  /// No description provided for @itemsIDidNotKnow.
  ///
  /// In en, this message translates to:
  /// **'Items I did not know'**
  String get itemsIDidNotKnow;

  /// No description provided for @known.
  ///
  /// In en, this message translates to:
  /// **'Known'**
  String get known;

  /// No description provided for @important.
  ///
  /// In en, this message translates to:
  /// **'Important'**
  String get important;

  /// No description provided for @favourite.
  ///
  /// In en, this message translates to:
  /// **'Favourite'**
  String get favourite;

  /// No description provided for @examples.
  ///
  /// In en, this message translates to:
  /// **'Examples'**
  String get examples;

  /// No description provided for @examplesHint.
  ///
  /// In en, this message translates to:
  /// **'Enter example sentences (one per line, use | to separate languages)'**
  String get examplesHint;

  /// No description provided for @noExamples.
  ///
  /// In en, this message translates to:
  /// **'No examples available'**
  String get noExamples;

  /// No description provided for @pronounce.
  ///
  /// In en, this message translates to:
  /// **'Pronounce'**
  String get pronounce;

  /// No description provided for @ttsError.
  ///
  /// In en, this message translates to:
  /// **'Text-to-speech not available'**
  String get ttsError;

  /// No description provided for @noItemsFound.
  ///
  /// In en, this message translates to:
  /// **'No items found'**
  String get noItemsFound;

  /// No description provided for @noItemsInPackage.
  ///
  /// In en, this message translates to:
  /// **'No items in this package yet'**
  String get noItemsInPackage;

  /// No description provided for @clearFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear Filters'**
  String get clearFilters;

  /// No description provided for @itemCount.
  ///
  /// In en, this message translates to:
  /// **'{count} items'**
  String itemCount(Object count);

  /// No description provided for @filteredItemCount.
  ///
  /// In en, this message translates to:
  /// **'{filtered} of {total} items'**
  String filteredItemCount(Object filtered, Object total);

  /// No description provided for @trainingRally.
  ///
  /// In en, this message translates to:
  /// **'Training Rally'**
  String get trainingRally;

  /// No description provided for @startTraining.
  ///
  /// In en, this message translates to:
  /// **'Start Training'**
  String get startTraining;

  /// No description provided for @trainingComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Training Rally - Coming Soon!'**
  String get trainingComingSoon;

  /// No description provided for @aiServiceNotConfigured.
  ///
  /// In en, this message translates to:
  /// **'AI service not configured. Please add your OpenAI API key.'**
  String get aiServiceNotConfigured;

  /// No description provided for @pleaseEnterTextInLanguageFirst.
  ///
  /// In en, this message translates to:
  /// **'Please enter text in {language} first'**
  String pleaseEnterTextInLanguageFirst(Object language);

  /// No description provided for @translationCompletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Translation completed successfully using {service}!'**
  String translationCompletedSuccessfully(Object service);

  /// No description provided for @translationFailed.
  ///
  /// In en, this message translates to:
  /// **'Translation failed'**
  String get translationFailed;

  /// No description provided for @addedExamplesSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Added {count} example(s) successfully!'**
  String addedExamplesSuccessfully(Object count);

  /// No description provided for @failedToGenerateExamples.
  ///
  /// In en, this message translates to:
  /// **'Failed to generate examples'**
  String get failedToGenerateExamples;

  /// No description provided for @selectExamplesToAdd.
  ///
  /// In en, this message translates to:
  /// **'Select Examples to Add'**
  String get selectExamplesToAdd;

  /// No description provided for @selectWhichExamples.
  ///
  /// In en, this message translates to:
  /// **'Select which examples you want to add to this item:'**
  String get selectWhichExamples;

  /// No description provided for @deselectAll.
  ///
  /// In en, this message translates to:
  /// **'Deselect All'**
  String get deselectAll;

  /// No description provided for @selectAll.
  ///
  /// In en, this message translates to:
  /// **'Select All'**
  String get selectAll;

  /// No description provided for @addSelected.
  ///
  /// In en, this message translates to:
  /// **'Add Selected'**
  String get addSelected;

  /// No description provided for @pleaseSelectAtLeastOne.
  ///
  /// In en, this message translates to:
  /// **'Please select at least one example'**
  String get pleaseSelectAtLeastOne;

  /// No description provided for @addNewItem.
  ///
  /// In en, this message translates to:
  /// **'Add New Item'**
  String get addNewItem;

  /// No description provided for @editItem.
  ///
  /// In en, this message translates to:
  /// **'Edit Item'**
  String get editItem;

  /// No description provided for @deleteItem.
  ///
  /// In en, this message translates to:
  /// **'Delete Item'**
  String get deleteItem;

  /// No description provided for @confirmDeleteItem.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this item?'**
  String get confirmDeleteItem;

  /// No description provided for @thisActionCannotBeUndone.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone.'**
  String get thisActionCannotBeUndone;

  /// No description provided for @itemDeleted.
  ///
  /// In en, this message translates to:
  /// **'Item deleted'**
  String get itemDeleted;

  /// No description provided for @errorDeletingItem.
  ///
  /// In en, this message translates to:
  /// **'Error deleting item'**
  String get errorDeletingItem;

  /// No description provided for @errorSavingItem.
  ///
  /// In en, this message translates to:
  /// **'Error saving item'**
  String get errorSavingItem;

  /// No description provided for @itemSaved.
  ///
  /// In en, this message translates to:
  /// **'Item updated successfully'**
  String get itemSaved;

  /// No description provided for @itemCreated.
  ///
  /// In en, this message translates to:
  /// **'Item created successfully'**
  String get itemCreated;

  /// No description provided for @preTextOptional.
  ///
  /// In en, this message translates to:
  /// **'Pre-text (optional)'**
  String get preTextOptional;

  /// No description provided for @mainText.
  ///
  /// In en, this message translates to:
  /// **'Main text'**
  String get mainText;

  /// No description provided for @postTextOptional.
  ///
  /// In en, this message translates to:
  /// **'Post-text (optional)'**
  String get postTextOptional;

  /// No description provided for @forExampleToForVerbs.
  ///
  /// In en, this message translates to:
  /// **'e.g., \"to\" for verbs'**
  String get forExampleToForVerbs;

  /// No description provided for @additionalContext.
  ///
  /// In en, this message translates to:
  /// **'Additional context'**
  String get additionalContext;

  /// No description provided for @translate.
  ///
  /// In en, this message translates to:
  /// **'Translate'**
  String get translate;

  /// No description provided for @translateFromTo.
  ///
  /// In en, this message translates to:
  /// **'Translate {from} → {to}'**
  String translateFromTo(Object from, Object to);

  /// No description provided for @aiExampleGeneration.
  ///
  /// In en, this message translates to:
  /// **'AI Example Generation'**
  String get aiExampleGeneration;

  /// No description provided for @aiExampleSearch.
  ///
  /// In en, this message translates to:
  /// **'AI Example Search'**
  String get aiExampleSearch;

  /// No description provided for @searchExamplesOnInternet.
  ///
  /// In en, this message translates to:
  /// **'Search for example sentences on the internet using AI for \'{text}\''**
  String searchExamplesOnInternet(Object text);

  /// No description provided for @generateExampleSentences.
  ///
  /// In en, this message translates to:
  /// **'Generate example sentences based on the main text in {language}'**
  String generateExampleSentences(Object language);

  /// No description provided for @generateExamples.
  ///
  /// In en, this message translates to:
  /// **'Generate Examples'**
  String get generateExamples;

  /// No description provided for @voiceInput.
  ///
  /// In en, this message translates to:
  /// **'Voice input'**
  String get voiceInput;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @userLanguage.
  ///
  /// In en, this message translates to:
  /// **'User Language'**
  String get userLanguage;

  /// No description provided for @userLanguageDescription.
  ///
  /// In en, this message translates to:
  /// **'Your preferred UI language'**
  String get userLanguageDescription;

  /// No description provided for @apiKeys.
  ///
  /// In en, this message translates to:
  /// **'API Keys'**
  String get apiKeys;

  /// No description provided for @deeplApiKey.
  ///
  /// In en, this message translates to:
  /// **'DeepL API Key'**
  String get deeplApiKey;

  /// No description provided for @deeplApiKeyDescription.
  ///
  /// In en, this message translates to:
  /// **'For premium translation quality (optional)'**
  String get deeplApiKeyDescription;

  /// No description provided for @openaiApiKey.
  ///
  /// In en, this message translates to:
  /// **'OpenAI API Key'**
  String get openaiApiKey;

  /// No description provided for @openaiApiKeyDescription.
  ///
  /// In en, this message translates to:
  /// **'For AI example generation'**
  String get openaiApiKeyDescription;

  /// No description provided for @enterApiKey.
  ///
  /// In en, this message translates to:
  /// **'Enter API key'**
  String get enterApiKey;

  /// No description provided for @optional.
  ///
  /// In en, this message translates to:
  /// **'optional'**
  String get optional;

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'required'**
  String get required;

  /// No description provided for @settingsSaved.
  ///
  /// In en, this message translates to:
  /// **'Settings saved successfully'**
  String get settingsSaved;

  /// No description provided for @errorSavingSettings.
  ///
  /// In en, this message translates to:
  /// **'Error saving settings'**
  String get errorSavingSettings;

  /// No description provided for @usingGoogleTranslate.
  ///
  /// In en, this message translates to:
  /// **'Using free Google Translate'**
  String get usingGoogleTranslate;

  /// No description provided for @usingDeepL.
  ///
  /// In en, this message translates to:
  /// **'Using DeepL (premium)'**
  String get usingDeepL;

  /// No description provided for @textCannotBeEmpty.
  ///
  /// In en, this message translates to:
  /// **'Text cannot be empty'**
  String get textCannotBeEmpty;

  /// No description provided for @noTranslationReceivedFromGoogle.
  ///
  /// In en, this message translates to:
  /// **'No translation received from Google'**
  String get noTranslationReceivedFromGoogle;

  /// No description provided for @googleTranslationFailed.
  ///
  /// In en, this message translates to:
  /// **'Google translation failed'**
  String get googleTranslationFailed;

  /// No description provided for @googleTranslationError.
  ///
  /// In en, this message translates to:
  /// **'Google translation error'**
  String get googleTranslationError;

  /// No description provided for @noTranslationReceivedFromDeepL.
  ///
  /// In en, this message translates to:
  /// **'No translation received from DeepL'**
  String get noTranslationReceivedFromDeepL;

  /// No description provided for @invalidDeepLApiKey.
  ///
  /// In en, this message translates to:
  /// **'Invalid DeepL API key'**
  String get invalidDeepLApiKey;

  /// No description provided for @deeplTranslationQuotaExceeded.
  ///
  /// In en, this message translates to:
  /// **'DeepL translation quota exceeded'**
  String get deeplTranslationQuotaExceeded;

  /// No description provided for @deeplTranslationFailed.
  ///
  /// In en, this message translates to:
  /// **'DeepL translation failed'**
  String get deeplTranslationFailed;

  /// No description provided for @deeplTranslationError.
  ///
  /// In en, this message translates to:
  /// **'DeepL translation error'**
  String get deeplTranslationError;

  /// No description provided for @invalidApiKeyConfigureOpenAI.
  ///
  /// In en, this message translates to:
  /// **'Invalid API key. Please configure your OpenAI API key.'**
  String get invalidApiKeyConfigureOpenAI;

  /// No description provided for @apiRateLimitExceeded.
  ///
  /// In en, this message translates to:
  /// **'API rate limit exceeded. Please try again later.'**
  String get apiRateLimitExceeded;

  /// No description provided for @aiRequestFailed.
  ///
  /// In en, this message translates to:
  /// **'AI request failed'**
  String get aiRequestFailed;

  /// No description provided for @failedToParseAiResponse.
  ///
  /// In en, this message translates to:
  /// **'Failed to parse AI response. Please try again.'**
  String get failedToParseAiResponse;

  /// No description provided for @aiGenerationError.
  ///
  /// In en, this message translates to:
  /// **'AI generation error'**
  String get aiGenerationError;

  /// No description provided for @voiceInputPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Voice input will be implemented using speech_to_text package'**
  String get voiceInputPlaceholder;

  /// No description provided for @improveQualityWithApiKeys.
  ///
  /// In en, this message translates to:
  /// **'💡 Tip: The quality of translations and example searches can be significantly improved by adding your DeepL and OpenAI API keys in the application settings.'**
  String get improveQualityWithApiKeys;

  /// No description provided for @noApiKeyFallbackMessage.
  ///
  /// In en, this message translates to:
  /// **'Without API keys, basic translation and limited examples are provided. For best results, configure your API keys in Settings.'**
  String get noApiKeyFallbackMessage;

  /// No description provided for @listeningForSpeech.
  ///
  /// In en, this message translates to:
  /// **'Listening... Speak now'**
  String get listeningForSpeech;

  /// No description provided for @speechRecognitionNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Speech recognition is not available on this device'**
  String get speechRecognitionNotAvailable;

  /// No description provided for @speechRecognitionPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Speech recognition permission was denied'**
  String get speechRecognitionPermissionDenied;

  /// No description provided for @speechRecognitionError.
  ///
  /// In en, this message translates to:
  /// **'Speech recognition error'**
  String get speechRecognitionError;

  /// No description provided for @tapToSpeak.
  ///
  /// In en, this message translates to:
  /// **'Tap microphone to speak'**
  String get tapToSpeak;

  /// No description provided for @speechNotRecognized.
  ///
  /// In en, this message translates to:
  /// **'No speech was recognized. Please try again.'**
  String get speechNotRecognized;

  /// No description provided for @trainingSettings.
  ///
  /// In en, this message translates to:
  /// **'Training Settings'**
  String get trainingSettings;

  /// No description provided for @itemScope.
  ///
  /// In en, this message translates to:
  /// **'Item Scope'**
  String get itemScope;

  /// No description provided for @lastNItems.
  ///
  /// In en, this message translates to:
  /// **'Last N items'**
  String get lastNItems;

  /// No description provided for @onlyUnknown.
  ///
  /// In en, this message translates to:
  /// **'Only unknown items'**
  String get onlyUnknown;

  /// No description provided for @numberOfItems.
  ///
  /// In en, this message translates to:
  /// **'Number of Items'**
  String get numberOfItems;

  /// No description provided for @itemOrder.
  ///
  /// In en, this message translates to:
  /// **'Item Order'**
  String get itemOrder;

  /// No description provided for @randomOrder.
  ///
  /// In en, this message translates to:
  /// **'Random order'**
  String get randomOrder;

  /// No description provided for @sequentialOrder.
  ///
  /// In en, this message translates to:
  /// **'Sequential order'**
  String get sequentialOrder;

  /// No description provided for @displayLanguage.
  ///
  /// In en, this message translates to:
  /// **'Display Language'**
  String get displayLanguage;

  /// No description provided for @motherTongue.
  ///
  /// In en, this message translates to:
  /// **'Mother tongue'**
  String get motherTongue;

  /// No description provided for @targetLanguage.
  ///
  /// In en, this message translates to:
  /// **'Target language'**
  String get targetLanguage;

  /// No description provided for @randomLanguage.
  ///
  /// In en, this message translates to:
  /// **'Random'**
  String get randomLanguage;

  /// No description provided for @categoryFilter.
  ///
  /// In en, this message translates to:
  /// **'Category Filter'**
  String get categoryFilter;

  /// No description provided for @categoryFilterHint.
  ///
  /// In en, this message translates to:
  /// **'Select categories to include (empty = all categories)'**
  String get categoryFilterHint;

  /// No description provided for @noCategories.
  ///
  /// In en, this message translates to:
  /// **'No categories available'**
  String get noCategories;

  /// No description provided for @dontKnowThreshold.
  ///
  /// In en, this message translates to:
  /// **'Don\'t Know Threshold'**
  String get dontKnowThreshold;

  /// No description provided for @dontKnowThresholdHint.
  ///
  /// In en, this message translates to:
  /// **'Number of times an item needs to be marked as \'don\'t know\' before special handling'**
  String get dontKnowThresholdHint;

  /// No description provided for @startTrainingRally.
  ///
  /// In en, this message translates to:
  /// **'Start Training Rally'**
  String get startTrainingRally;

  /// No description provided for @clearTrainingSettings.
  ///
  /// In en, this message translates to:
  /// **'Clear Settings'**
  String get clearTrainingSettings;

  /// No description provided for @confirmClearTrainingSettings.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to reset all training settings to default values?'**
  String get confirmClearTrainingSettings;

  /// No description provided for @trainingSettingsCleared.
  ///
  /// In en, this message translates to:
  /// **'Training settings have been cleared'**
  String get trainingSettingsCleared;

  /// No description provided for @startingTraining.
  ///
  /// In en, this message translates to:
  /// **'Starting training...'**
  String get startingTraining;

  /// No description provided for @noMoreItemsToDisplay.
  ///
  /// In en, this message translates to:
  /// **'No more items to display based on your filter settings.'**
  String get noMoreItemsToDisplay;

  /// No description provided for @noItems.
  ///
  /// In en, this message translates to:
  /// **'No Items'**
  String get noItems;

  /// No description provided for @trainingComplete.
  ///
  /// In en, this message translates to:
  /// **'Training Complete'**
  String get trainingComplete;

  /// No description provided for @allItemsCompleted.
  ///
  /// In en, this message translates to:
  /// **'Congratulations! You have completed all items in this training session.'**
  String get allItemsCompleted;

  /// No description provided for @closeTraining.
  ///
  /// In en, this message translates to:
  /// **'Close Training'**
  String get closeTraining;

  /// No description provided for @confirmCloseTraining.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to close the training? Your progress has been saved.'**
  String get confirmCloseTraining;

  /// No description provided for @question.
  ///
  /// In en, this message translates to:
  /// **'Question'**
  String get question;

  /// No description provided for @answer.
  ///
  /// In en, this message translates to:
  /// **'Answer'**
  String get answer;

  /// No description provided for @iKnow.
  ///
  /// In en, this message translates to:
  /// **'I Know'**
  String get iKnow;

  /// No description provided for @iDontKnow.
  ///
  /// In en, this message translates to:
  /// **'I Don\'t Know'**
  String get iDontKnow;

  /// No description provided for @nextItem.
  ///
  /// In en, this message translates to:
  /// **'Next Item'**
  String get nextItem;

  /// No description provided for @iDidNotKnowEither.
  ///
  /// In en, this message translates to:
  /// **'I Didn\'t Know Either'**
  String get iDidNotKnowEither;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'hu'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hu':
      return AppLocalizationsHu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
