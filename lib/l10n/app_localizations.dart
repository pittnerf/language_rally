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

  /// No description provided for @packageName.
  ///
  /// In en, this message translates to:
  /// **'Package Name'**
  String get packageName;

  /// No description provided for @packageNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Spanish Essentials, German Basics'**
  String get packageNameHint;

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

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

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

  /// No description provided for @typeToSearchLanguages.
  ///
  /// In en, this message translates to:
  /// **'Type to search languages...'**
  String get typeToSearchLanguages;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search...'**
  String get search;

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
  /// **'Import Items (JSON)'**
  String get importItems;

  /// No description provided for @importItemsDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Import Items (JSON)'**
  String get importItemsDialogTitle;

  /// No description provided for @importItemsFromLocalJson.
  ///
  /// In en, this message translates to:
  /// **'Import from local JSON file'**
  String get importItemsFromLocalJson;

  /// No description provided for @enterItemsUrl.
  ///
  /// In en, this message translates to:
  /// **'Items JSON URL (https://…)'**
  String get enterItemsUrl;

  /// No description provided for @downloadingItems.
  ///
  /// In en, this message translates to:
  /// **'Downloading items…'**
  String get downloadingItems;

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

  /// No description provided for @importPackage.
  ///
  /// In en, this message translates to:
  /// **'Import Package'**
  String get importPackage;

  /// No description provided for @importPackageTooltip.
  ///
  /// In en, this message translates to:
  /// **'Import package from ZIP file or URL'**
  String get importPackageTooltip;

  /// No description provided for @importPackageDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Import Language Package'**
  String get importPackageDialogTitle;

  /// No description provided for @importFromLocalFile.
  ///
  /// In en, this message translates to:
  /// **'Import from local file'**
  String get importFromLocalFile;

  /// No description provided for @importFromUrl.
  ///
  /// In en, this message translates to:
  /// **'Import from URL'**
  String get importFromUrl;

  /// No description provided for @enterPackageUrl.
  ///
  /// In en, this message translates to:
  /// **'Package URL (https://…)'**
  String get enterPackageUrl;

  /// No description provided for @downloadingPackage.
  ///
  /// In en, this message translates to:
  /// **'Downloading package…'**
  String get downloadingPackage;

  /// No description provided for @downloadFailed.
  ///
  /// In en, this message translates to:
  /// **'Download failed. Please check the URL and your internet connection.'**
  String get downloadFailed;

  /// No description provided for @invalidUrl.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid http:// or https:// URL.'**
  String get invalidUrl;

  /// No description provided for @orLabel.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get orLabel;

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
  /// **'compact'**
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

  /// No description provided for @importFormatNewDescription.
  ///
  /// In en, this message translates to:
  /// **'Import items from a text file. Each line should contain an item with fields separated by ---'**
  String get importFormatNewDescription;

  /// No description provided for @importFormatNewLine1.
  ///
  /// In en, this message translates to:
  /// **'• Main delimiter: ---'**
  String get importFormatNewLine1;

  /// No description provided for @importFormatNewLine2.
  ///
  /// In en, this message translates to:
  /// **'• L1=<text> - Language 1 main text (required if L2 is missing)'**
  String get importFormatNewLine2;

  /// No description provided for @importFormatNewLine3.
  ///
  /// In en, this message translates to:
  /// **'• L2=<text> - Language 2 main text (required if L1 is missing)'**
  String get importFormatNewLine3;

  /// No description provided for @importFormatNewLine4.
  ///
  /// In en, this message translates to:
  /// **'• L1pre=<text> - Language 1 prefix (optional)'**
  String get importFormatNewLine4;

  /// No description provided for @importFormatNewLine5.
  ///
  /// In en, this message translates to:
  /// **'• L1post=<text> - Language 1 suffix (optional)'**
  String get importFormatNewLine5;

  /// No description provided for @importFormatNewLine6.
  ///
  /// In en, this message translates to:
  /// **'• L2pre=<text> - Language 2 prefix (optional)'**
  String get importFormatNewLine6;

  /// No description provided for @importFormatNewLine7.
  ///
  /// In en, this message translates to:
  /// **'• L2post=<text> - Language 2 suffix (optional)'**
  String get importFormatNewLine7;

  /// No description provided for @importFormatNewLine8.
  ///
  /// In en, this message translates to:
  /// **'• EX=<L1 text>:::<L2 text> - Example (optional, can be multiple)'**
  String get importFormatNewLine8;

  /// No description provided for @importFormatNewLine9.
  ///
  /// In en, this message translates to:
  /// **'• CAT=<cat1>:::<cat2>:::<cat3> - Categories (optional)'**
  String get importFormatNewLine9;

  /// No description provided for @importFormatNewLine10.
  ///
  /// In en, this message translates to:
  /// **'• At least one of L1= or L2= must be present'**
  String get importFormatNewLine10;

  /// No description provided for @importFormatNewLine11.
  ///
  /// In en, this message translates to:
  /// **'• Empty lines are ignored'**
  String get importFormatNewLine11;

  /// No description provided for @importFormatNewLine12.
  ///
  /// In en, this message translates to:
  /// **'• Duplicates are skipped'**
  String get importFormatNewLine12;

  /// No description provided for @invalidImportLine.
  ///
  /// In en, this message translates to:
  /// **'Invalid line'**
  String get invalidImportLine;

  /// No description provided for @missingRequiredFields.
  ///
  /// In en, this message translates to:
  /// **'Missing \'L1=\' vagy \'L2=\''**
  String get missingRequiredFields;

  /// No description provided for @unknownField.
  ///
  /// In en, this message translates to:
  /// **'Unknown field prefix'**
  String get unknownField;

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

  /// No description provided for @knownStatus.
  ///
  /// In en, this message translates to:
  /// **'Known status'**
  String get knownStatus;

  /// No description provided for @filterStatusAll.
  ///
  /// In en, this message translates to:
  /// **'all'**
  String get filterStatusAll;

  /// No description provided for @filterStatusKnown.
  ///
  /// In en, this message translates to:
  /// **'known'**
  String get filterStatusKnown;

  /// No description provided for @filterStatusUnknown.
  ///
  /// In en, this message translates to:
  /// **'unknown'**
  String get filterStatusUnknown;

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

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

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

  /// No description provided for @badge.
  ///
  /// In en, this message translates to:
  /// **'Badge'**
  String get badge;

  /// No description provided for @position.
  ///
  /// In en, this message translates to:
  /// **'Position'**
  String get position;

  /// No description provided for @stepsUntilLearned.
  ///
  /// In en, this message translates to:
  /// **'Steps until learned'**
  String get stepsUntilLearned;

  /// No description provided for @examples.
  ///
  /// In en, this message translates to:
  /// **'Examples'**
  String get examples;

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

  /// No description provided for @addItem.
  ///
  /// In en, this message translates to:
  /// **'Add item'**
  String get addItem;

  /// No description provided for @emptyPackageHint.
  ///
  /// In en, this message translates to:
  /// **'Add items manually or use AI to import items quickly'**
  String get emptyPackageHint;

  /// No description provided for @noItemsToTrain.
  ///
  /// In en, this message translates to:
  /// **'No items available for practice with current settings'**
  String get noItemsToTrain;

  /// No description provided for @clearFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
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

  /// No description provided for @uiLanguage.
  ///
  /// In en, this message translates to:
  /// **'UI Language'**
  String get uiLanguage;

  /// No description provided for @uiLanguageDescription.
  ///
  /// In en, this message translates to:
  /// **'Application interface language'**
  String get uiLanguageDescription;

  /// No description provided for @uiLanguageHelper.
  ///
  /// In en, this message translates to:
  /// **'Select the language for menus, buttons, and labels'**
  String get uiLanguageHelper;

  /// No description provided for @userLanguage.
  ///
  /// In en, this message translates to:
  /// **'User Language'**
  String get userLanguage;

  /// No description provided for @userLanguageDescription.
  ///
  /// In en, this message translates to:
  /// **'Your preferred mother tongue for creating new language packages'**
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
  /// **'For premium translation quality when editing language items. See https://www.deepl.com/pro-api'**
  String get deeplApiKeyDescription;

  /// No description provided for @openaiApiKey.
  ///
  /// In en, this message translates to:
  /// **'OpenAI API Key'**
  String get openaiApiKey;

  /// No description provided for @openaiApiKeyDescription.
  ///
  /// In en, this message translates to:
  /// **'For example generation with AI when editing language items. See https://platform.openai.com/api-keys'**
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

  /// No description provided for @tapToStop.
  ///
  /// In en, this message translates to:
  /// **'Tap to stop recording'**
  String get tapToStop;

  /// No description provided for @speechNotRecognized.
  ///
  /// In en, this message translates to:
  /// **'No speech was recognized. Please try again.'**
  String get speechNotRecognized;

  /// No description provided for @usingWhisperApiSlower.
  ///
  /// In en, this message translates to:
  /// **'Using cloud AI for speech recognition (may be slower)'**
  String get usingWhisperApiSlower;

  /// No description provided for @languageNotSupportedAddApiKey.
  ///
  /// In en, this message translates to:
  /// **'Language {languageCode} not supported natively. Add OpenAI API key in Settings for AI-powered speech recognition.'**
  String languageNotSupportedAddApiKey(String languageCode);

  /// No description provided for @recordingTapToStop.
  ///
  /// In en, this message translates to:
  /// **'Recording... Tap again to stop'**
  String get recordingTapToStop;

  /// No description provided for @speakClearlyKeepRecording.
  ///
  /// In en, this message translates to:
  /// **'Speak clearly. Record at least 1 second.'**
  String get speakClearlyKeepRecording;

  /// No description provided for @pleaseRecordLonger.
  ///
  /// In en, this message translates to:
  /// **'Please speak for at least 1 second and tap stop.'**
  String get pleaseRecordLonger;

  /// No description provided for @errorStartingRecording.
  ///
  /// In en, this message translates to:
  /// **'Error starting recording'**
  String get errorStartingRecording;

  /// No description provided for @noAudioRecorded.
  ///
  /// In en, this message translates to:
  /// **'No audio was recorded'**
  String get noAudioRecorded;

  /// No description provided for @errorTranscribing.
  ///
  /// In en, this message translates to:
  /// **'Error transcribing audio'**
  String get errorTranscribing;

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

  /// No description provided for @onlyImportant.
  ///
  /// In en, this message translates to:
  /// **'Only important items'**
  String get onlyImportant;

  /// No description provided for @onlyFavourite.
  ///
  /// In en, this message translates to:
  /// **'Only favourite items'**
  String get onlyFavourite;

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

  /// No description provided for @itemType.
  ///
  /// In en, this message translates to:
  /// **'Item Type'**
  String get itemType;

  /// No description provided for @dictionaryItems.
  ///
  /// In en, this message translates to:
  /// **'Dictionary items'**
  String get dictionaryItems;

  /// No description provided for @examplesType.
  ///
  /// In en, this message translates to:
  /// **'Examples'**
  String get examplesType;

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

  /// No description provided for @previousItem.
  ///
  /// In en, this message translates to:
  /// **'Previous Item'**
  String get previousItem;

  /// No description provided for @iDidNotKnowEither.
  ///
  /// In en, this message translates to:
  /// **'I Didn\'t Know Either'**
  String get iDidNotKnowEither;

  /// No description provided for @exportBeforeDelete.
  ///
  /// In en, this message translates to:
  /// **'Export Before Deleting?'**
  String get exportBeforeDelete;

  /// No description provided for @aiTextAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Import items with AI'**
  String get aiTextAnalysis;

  /// No description provided for @aiTextAnalysisImport.
  ///
  /// In en, this message translates to:
  /// **'Import items with AI Text Analysis'**
  String get aiTextAnalysisImport;

  /// No description provided for @knowledgeLevel.
  ///
  /// In en, this message translates to:
  /// **'Knowledge Level'**
  String get knowledgeLevel;

  /// No description provided for @a1Beginner.
  ///
  /// In en, this message translates to:
  /// **'A1 - Beginner'**
  String get a1Beginner;

  /// No description provided for @a2Elementary.
  ///
  /// In en, this message translates to:
  /// **'A2 - Elementary'**
  String get a2Elementary;

  /// No description provided for @b1Intermediate.
  ///
  /// In en, this message translates to:
  /// **'B1 - Intermediate'**
  String get b1Intermediate;

  /// No description provided for @b2UpperIntermediate.
  ///
  /// In en, this message translates to:
  /// **'B2 - Upper Intermediate'**
  String get b2UpperIntermediate;

  /// No description provided for @c1Advanced.
  ///
  /// In en, this message translates to:
  /// **'C1 - Advanced'**
  String get c1Advanced;

  /// No description provided for @c2Proficient.
  ///
  /// In en, this message translates to:
  /// **'C2 - Proficient'**
  String get c2Proficient;

  /// No description provided for @pasteTextHere.
  ///
  /// In en, this message translates to:
  /// **'Paste your text here...'**
  String get pasteTextHere;

  /// No description provided for @extractWords.
  ///
  /// In en, this message translates to:
  /// **'Extract Words'**
  String get extractWords;

  /// No description provided for @extractExpressions.
  ///
  /// In en, this message translates to:
  /// **'Extract Expressions'**
  String get extractExpressions;

  /// No description provided for @maxItems.
  ///
  /// In en, this message translates to:
  /// **'Maximum New Items'**
  String get maxItems;

  /// No description provided for @maxItemsHint.
  ///
  /// In en, this message translates to:
  /// **'Leave empty for no limit'**
  String get maxItemsHint;

  /// No description provided for @generateExamples.
  ///
  /// In en, this message translates to:
  /// **'Generate Examples'**
  String get generateExamples;

  /// No description provided for @categoryName.
  ///
  /// In en, this message translates to:
  /// **'Category Name'**
  String get categoryName;

  /// No description provided for @categoryNameHint.
  ///
  /// In en, this message translates to:
  /// **'Name for imported items category'**
  String get categoryNameHint;

  /// No description provided for @analyzeText.
  ///
  /// In en, this message translates to:
  /// **'Analyze Text'**
  String get analyzeText;

  /// No description provided for @configureAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Configure Items To Extract'**
  String get configureAnalysis;

  /// No description provided for @openaiModel.
  ///
  /// In en, this message translates to:
  /// **'AI Model'**
  String get openaiModel;

  /// No description provided for @openaiModelDescription.
  ///
  /// In en, this message translates to:
  /// **'Select ChatGPT model'**
  String get openaiModelDescription;

  /// No description provided for @modelGpt35Turbo.
  ///
  /// In en, this message translates to:
  /// **'GPT-3.5 Turbo'**
  String get modelGpt35Turbo;

  /// No description provided for @modelGpt35Turbo16k.
  ///
  /// In en, this message translates to:
  /// **'GPT-3.5 Turbo 16K'**
  String get modelGpt35Turbo16k;

  /// No description provided for @modelGpt4.
  ///
  /// In en, this message translates to:
  /// **'GPT-4'**
  String get modelGpt4;

  /// No description provided for @modelGpt4Turbo.
  ///
  /// In en, this message translates to:
  /// **'GPT-4 Turbo'**
  String get modelGpt4Turbo;

  /// No description provided for @modelGpt35TurboDesc.
  ///
  /// In en, this message translates to:
  /// **'Fast and cost-effective; standard for production'**
  String get modelGpt35TurboDesc;

  /// No description provided for @modelGpt35Turbo16kDesc.
  ///
  /// In en, this message translates to:
  /// **'Same as GPT-3.5, but 16K token context window'**
  String get modelGpt35Turbo16kDesc;

  /// No description provided for @modelGpt4Desc.
  ///
  /// In en, this message translates to:
  /// **'Higher accuracy/reasoning; slower and more expensive'**
  String get modelGpt4Desc;

  /// No description provided for @modelGpt4TurboDesc.
  ///
  /// In en, this message translates to:
  /// **'Faster, cheaper, high accuracy; improved context'**
  String get modelGpt4TurboDesc;

  /// No description provided for @analyzing.
  ///
  /// In en, this message translates to:
  /// **'Analyzing...'**
  String get analyzing;

  /// No description provided for @languageDetected.
  ///
  /// In en, this message translates to:
  /// **'Language Detected'**
  String get languageDetected;

  /// No description provided for @itemsFound.
  ///
  /// In en, this message translates to:
  /// **'Items Found'**
  String get itemsFound;

  /// No description provided for @selectItemsToImport.
  ///
  /// In en, this message translates to:
  /// **'Select Items to Import'**
  String get selectItemsToImport;

  /// No description provided for @selectAll.
  ///
  /// In en, this message translates to:
  /// **'Select All'**
  String get selectAll;

  /// No description provided for @deselectAll.
  ///
  /// In en, this message translates to:
  /// **'Deselect All'**
  String get deselectAll;

  /// No description provided for @importSelected.
  ///
  /// In en, this message translates to:
  /// **'Import Selected'**
  String get importSelected;

  /// No description provided for @importing.
  ///
  /// In en, this message translates to:
  /// **'Importing...'**
  String get importing;

  /// No description provided for @itemsImported.
  ///
  /// In en, this message translates to:
  /// **'Items imported successfully'**
  String get itemsImported;

  /// No description provided for @noItemsSelected.
  ///
  /// In en, this message translates to:
  /// **'No items selected'**
  String get noItemsSelected;

  /// No description provided for @textCannotBeEmpty.
  ///
  /// In en, this message translates to:
  /// **'Text cannot be empty'**
  String get textCannotBeEmpty;

  /// No description provided for @selectAtLeastOneType.
  ///
  /// In en, this message translates to:
  /// **'Select at least one type (words or expressions)'**
  String get selectAtLeastOneType;

  /// No description provided for @languageNotMatching.
  ///
  /// In en, this message translates to:
  /// **'The detected language does not match any language in the package'**
  String get languageNotMatching;

  /// No description provided for @openaiKeyRequired.
  ///
  /// In en, this message translates to:
  /// **'OpenAI API key is required for this feature'**
  String get openaiKeyRequired;

  /// No description provided for @analyzingProgress.
  ///
  /// In en, this message translates to:
  /// **'Analyzing: {current} / {total}'**
  String analyzingProgress(Object current, Object total);

  /// No description provided for @translatingProgress.
  ///
  /// In en, this message translates to:
  /// **'Translating: {current} / {total}'**
  String translatingProgress(Object current, Object total);

  /// No description provided for @duplicate.
  ///
  /// In en, this message translates to:
  /// **'Duplicate'**
  String get duplicate;

  /// No description provided for @importProgress.
  ///
  /// In en, this message translates to:
  /// **'Importing {current} of {total}'**
  String importProgress(Object current, Object total);

  /// No description provided for @detectingLanguage.
  ///
  /// In en, this message translates to:
  /// **'Detecting language...'**
  String get detectingLanguage;

  /// No description provided for @extractingItems.
  ///
  /// In en, this message translates to:
  /// **'Extracting items...'**
  String get extractingItems;

  /// No description provided for @checkingDuplicates.
  ///
  /// In en, this message translates to:
  /// **'Checking for duplicates...'**
  String get checkingDuplicates;

  /// No description provided for @translating.
  ///
  /// In en, this message translates to:
  /// **'Translating...'**
  String get translating;

  /// No description provided for @generatingExamples.
  ///
  /// In en, this message translates to:
  /// **'Generating examples...'**
  String get generatingExamples;

  /// No description provided for @errorAnalyzingText.
  ///
  /// In en, this message translates to:
  /// **'Error analyzing text'**
  String get errorAnalyzingText;

  /// No description provided for @errorImportingItems.
  ///
  /// In en, this message translates to:
  /// **'Error importing items'**
  String get errorImportingItems;

  /// No description provided for @warning.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get warning;

  /// No description provided for @textIsVeryLarge.
  ///
  /// In en, this message translates to:
  /// **'The text is very large'**
  String get textIsVeryLarge;

  /// No description provided for @words.
  ///
  /// In en, this message translates to:
  /// **'words'**
  String get words;

  /// No description provided for @continueAnalysis.
  ///
  /// In en, this message translates to:
  /// **'This may take longer to process and will be analyzed in chunks. Do you want to continue'**
  String get continueAnalysis;

  /// No description provided for @continueLabel.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueLabel;

  /// No description provided for @exportBeforeDeleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Would you like to export this package before deleting it? This will save all your data to a ZIP file.'**
  String get exportBeforeDeleteMessage;

  /// No description provided for @deleteWithoutExport.
  ///
  /// In en, this message translates to:
  /// **'Delete Without Export'**
  String get deleteWithoutExport;

  /// No description provided for @exportAndDelete.
  ///
  /// In en, this message translates to:
  /// **'Export and Delete'**
  String get exportAndDelete;

  /// No description provided for @exportingPackage.
  ///
  /// In en, this message translates to:
  /// **'Exporting package...'**
  String get exportingPackage;

  /// No description provided for @packageExportedToPath.
  ///
  /// In en, this message translates to:
  /// **'Package exported to: {path}'**
  String packageExportedToPath(Object path);

  /// No description provided for @errorLoadingItems.
  ///
  /// In en, this message translates to:
  /// **'Error loading items: {error}'**
  String errorLoadingItems(Object error);

  /// No description provided for @badgeEarnedWithName.
  ///
  /// In en, this message translates to:
  /// **'Badge Earned: {badgeName}!'**
  String badgeEarnedWithName(Object badgeName);

  /// No description provided for @badgeLostWithName.
  ///
  /// In en, this message translates to:
  /// **'Badge Lost: {badgeName}'**
  String badgeLostWithName(Object badgeName);

  /// No description provided for @trainingSessionProgress.
  ///
  /// In en, this message translates to:
  /// **'Training Session Stats'**
  String get trainingSessionProgress;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @lastNValue.
  ///
  /// In en, this message translates to:
  /// **'N = {value}'**
  String lastNValue(Object value);

  /// No description provided for @errorLoadingSettings.
  ///
  /// In en, this message translates to:
  /// **'Error loading settings: {error}'**
  String errorLoadingSettings(Object error);

  /// No description provided for @selectPackage.
  ///
  /// In en, this message translates to:
  /// **'Select Package'**
  String get selectPackage;

  /// No description provided for @noPackagesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No packages available'**
  String get noPackagesAvailable;

  /// No description provided for @possibleSolutions.
  ///
  /// In en, this message translates to:
  /// **'Possible Solutions'**
  String get possibleSolutions;

  /// No description provided for @technicalDetails.
  ///
  /// In en, this message translates to:
  /// **'Technical Details'**
  String get technicalDetails;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @checkApiKey.
  ///
  /// In en, this message translates to:
  /// **'Check your OpenAI API key'**
  String get checkApiKey;

  /// No description provided for @ensureValidOpenAIKey.
  ///
  /// In en, this message translates to:
  /// **'Ensure the API key is valid and active'**
  String get ensureValidOpenAIKey;

  /// No description provided for @verifyKeyInSettings.
  ///
  /// In en, this message translates to:
  /// **'Verify the key in Settings'**
  String get verifyKeyInSettings;

  /// No description provided for @rateLimitExceeded.
  ///
  /// In en, this message translates to:
  /// **'API rate limit exceeded'**
  String get rateLimitExceeded;

  /// No description provided for @waitAndRetry.
  ///
  /// In en, this message translates to:
  /// **'Wait a few minutes and try again'**
  String get waitAndRetry;

  /// No description provided for @checkAccountQuota.
  ///
  /// In en, this message translates to:
  /// **'Check your OpenAI account quota'**
  String get checkAccountQuota;

  /// No description provided for @invalidRequest.
  ///
  /// In en, this message translates to:
  /// **'Invalid request format'**
  String get invalidRequest;

  /// No description provided for @tryReducingTextLength.
  ///
  /// In en, this message translates to:
  /// **'Try reducing the text length'**
  String get tryReducingTextLength;

  /// No description provided for @checkTextFormat.
  ///
  /// In en, this message translates to:
  /// **'Check that the text format is correct'**
  String get checkTextFormat;

  /// No description provided for @checkInternetConnection.
  ///
  /// In en, this message translates to:
  /// **'Check your internet connection'**
  String get checkInternetConnection;

  /// No description provided for @retryInMoment.
  ///
  /// In en, this message translates to:
  /// **'Retry in a moment'**
  String get retryInMoment;

  /// No description provided for @checkFirewall.
  ///
  /// In en, this message translates to:
  /// **'Check firewall settings'**
  String get checkFirewall;

  /// No description provided for @textMayBeTooShort.
  ///
  /// In en, this message translates to:
  /// **'Text may be too short'**
  String get textMayBeTooShort;

  /// No description provided for @tryDifferentKnowledgeLevel.
  ///
  /// In en, this message translates to:
  /// **'Try a different knowledge level'**
  String get tryDifferentKnowledgeLevel;

  /// No description provided for @ensureTextInCorrectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Ensure text is in the correct language'**
  String get ensureTextInCorrectLanguage;

  /// No description provided for @requestTimedOut.
  ///
  /// In en, this message translates to:
  /// **'Request timed out'**
  String get requestTimedOut;

  /// No description provided for @textMayBeTooLong.
  ///
  /// In en, this message translates to:
  /// **'Text may be too long'**
  String get textMayBeTooLong;

  /// No description provided for @tryAgainOrReduceSize.
  ///
  /// In en, this message translates to:
  /// **'Try again or reduce text size'**
  String get tryAgainOrReduceSize;

  /// No description provided for @unexpectedError.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred'**
  String get unexpectedError;

  /// No description provided for @checkErrorDetails.
  ///
  /// In en, this message translates to:
  /// **'Check error details below'**
  String get checkErrorDetails;

  /// No description provided for @tryAgainLater.
  ///
  /// In en, this message translates to:
  /// **'Try again later'**
  String get tryAgainLater;

  /// No description provided for @translationServiceFailed.
  ///
  /// In en, this message translates to:
  /// **'Translation service failed'**
  String get translationServiceFailed;

  /// No description provided for @checkApiKeys.
  ///
  /// In en, this message translates to:
  /// **'Check your API keys (DeepL, OpenAI)'**
  String get checkApiKeys;

  /// No description provided for @retryImport.
  ///
  /// In en, this message translates to:
  /// **'Retry the import'**
  String get retryImport;

  /// No description provided for @exampleGenerationFailed.
  ///
  /// In en, this message translates to:
  /// **'Example generation failed'**
  String get exampleGenerationFailed;

  /// No description provided for @itemsStillImported.
  ///
  /// In en, this message translates to:
  /// **'Items were still imported'**
  String get itemsStillImported;

  /// No description provided for @canAddExamplesManually.
  ///
  /// In en, this message translates to:
  /// **'You can add examples manually later'**
  String get canAddExamplesManually;

  /// No description provided for @databaseError.
  ///
  /// In en, this message translates to:
  /// **'Database error occurred'**
  String get databaseError;

  /// No description provided for @checkStorageSpace.
  ///
  /// In en, this message translates to:
  /// **'Check available storage space'**
  String get checkStorageSpace;

  /// No description provided for @restartApp.
  ///
  /// In en, this message translates to:
  /// **'Try restarting the app'**
  String get restartApp;

  /// No description provided for @groupLabel.
  ///
  /// In en, this message translates to:
  /// **'Group:'**
  String get groupLabel;

  /// No description provided for @amendGroups.
  ///
  /// In en, this message translates to:
  /// **'Amend'**
  String get amendGroups;

  /// No description provided for @exportItemsJson.
  ///
  /// In en, this message translates to:
  /// **'Export Items (JSON)'**
  String get exportItemsJson;

  /// No description provided for @exportItemsJsonTooltip.
  ///
  /// In en, this message translates to:
  /// **'Export all items as JSON file'**
  String get exportItemsJsonTooltip;

  /// No description provided for @noCategoriesInPackage.
  ///
  /// In en, this message translates to:
  /// **'No categories found in this package'**
  String get noCategoriesInPackage;

  /// No description provided for @noItemsToExport.
  ///
  /// In en, this message translates to:
  /// **'No items found to export'**
  String get noItemsToExport;

  /// No description provided for @itemsExportedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Successfully exported {count} items to:\n{path}'**
  String itemsExportedSuccessfully(int count, String path);

  /// No description provided for @errorExportingItems.
  ///
  /// In en, this message translates to:
  /// **'Error exporting items'**
  String get errorExportingItems;

  /// No description provided for @languageMismatch.
  ///
  /// In en, this message translates to:
  /// **'Language Mismatch'**
  String get languageMismatch;

  /// No description provided for @languageMismatchDescription.
  ///
  /// In en, this message translates to:
  /// **'The languages in the JSON file do not match the package languages:'**
  String get languageMismatchDescription;

  /// No description provided for @packageLanguages.
  ///
  /// In en, this message translates to:
  /// **'Package: {lang1} → {lang2}'**
  String packageLanguages(String lang1, String lang2);

  /// No description provided for @jsonFileLanguages.
  ///
  /// In en, this message translates to:
  /// **'JSON file: {lang1} → {lang2}'**
  String jsonFileLanguages(String lang1, String lang2);

  /// No description provided for @continueImportQuestion.
  ///
  /// In en, this message translates to:
  /// **'Do you want to continue importing anyway?'**
  String get continueImportQuestion;

  /// No description provided for @continueImport.
  ///
  /// In en, this message translates to:
  /// **'Continue Import'**
  String get continueImport;

  /// No description provided for @pleaseSelectPackageGroup.
  ///
  /// In en, this message translates to:
  /// **'Please select a package group'**
  String get pleaseSelectPackageGroup;

  /// No description provided for @customIconLabel.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get customIconLabel;

  /// No description provided for @defaultIconLabel.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get defaultIconLabel;

  /// No description provided for @icon2Label.
  ///
  /// In en, this message translates to:
  /// **'Open Book'**
  String get icon2Label;

  /// No description provided for @icon3Label.
  ///
  /// In en, this message translates to:
  /// **'Colored Book'**
  String get icon3Label;

  /// No description provided for @icon4Label.
  ///
  /// In en, this message translates to:
  /// **'Conversation'**
  String get icon4Label;

  /// No description provided for @icon5Label.
  ///
  /// In en, this message translates to:
  /// **'Graduation'**
  String get icon5Label;

  /// No description provided for @icon6Label.
  ///
  /// In en, this message translates to:
  /// **'Brain'**
  String get icon6Label;

  /// No description provided for @icon7Label.
  ///
  /// In en, this message translates to:
  /// **'Book Stack'**
  String get icon7Label;

  /// No description provided for @icon8Label.
  ///
  /// In en, this message translates to:
  /// **'Flashcard'**
  String get icon8Label;

  /// No description provided for @icon9Label.
  ///
  /// In en, this message translates to:
  /// **'Globe'**
  String get icon9Label;

  /// No description provided for @icon10Label.
  ///
  /// In en, this message translates to:
  /// **'Pencil'**
  String get icon10Label;

  /// No description provided for @icon11Label.
  ///
  /// In en, this message translates to:
  /// **'Trophy'**
  String get icon11Label;

  /// No description provided for @icon12Label.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get icon12Label;

  /// No description provided for @customIconFile.
  ///
  /// In en, this message translates to:
  /// **'Custom Icon'**
  String get customIconFile;

  /// No description provided for @importedIconFile.
  ///
  /// In en, this message translates to:
  /// **'Imported Icon'**
  String get importedIconFile;

  /// No description provided for @unableToReadImageFile.
  ///
  /// In en, this message translates to:
  /// **'Unable to read image file. Please select a valid image.'**
  String get unableToReadImageFile;

  /// No description provided for @iconDimensionsTooLarge.
  ///
  /// In en, this message translates to:
  /// **'Icon dimensions are too large ({width}x{height}). Maximum allowed is 512x512 pixels.'**
  String iconDimensionsTooLarge(int width, int height);

  /// No description provided for @iconFileTooLarge.
  ///
  /// In en, this message translates to:
  /// **'Icon file is too large. Maximum size is 1MB.'**
  String get iconFileTooLarge;

  /// No description provided for @failedToUploadIcon.
  ///
  /// In en, this message translates to:
  /// **'Failed to upload icon: {error}'**
  String failedToUploadIcon(String error);

  /// No description provided for @pleaseSelectValidLanguage.
  ///
  /// In en, this message translates to:
  /// **'Please select a valid language from the list'**
  String get pleaseSelectValidLanguage;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @addExample.
  ///
  /// In en, this message translates to:
  /// **'Add example'**
  String get addExample;

  /// No description provided for @noExamplesYet.
  ///
  /// In en, this message translates to:
  /// **'No examples yet. Click + to add.'**
  String get noExamplesYet;

  /// No description provided for @speakText.
  ///
  /// In en, this message translates to:
  /// **'Speak text'**
  String get speakText;

  /// No description provided for @removeCategory.
  ///
  /// In en, this message translates to:
  /// **'Remove Category'**
  String get removeCategory;

  /// No description provided for @removeCategoryConfirm.
  ///
  /// In en, this message translates to:
  /// **'Remove category \"{categoryName}\" from this item?'**
  String removeCategoryConfirm(String categoryName);

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @extractFullItems.
  ///
  /// In en, this message translates to:
  /// **'Extract Full Items'**
  String get extractFullItems;

  /// No description provided for @pasteFromClipboard.
  ///
  /// In en, this message translates to:
  /// **'Paste from clipboard'**
  String get pasteFromClipboard;

  /// No description provided for @noItemsFoundOrAllDuplicates.
  ///
  /// In en, this message translates to:
  /// **'No items found in the text, or all items already exist in the package'**
  String get noItemsFoundOrAllDuplicates;

  /// No description provided for @aboutLanguageRally.
  ///
  /// In en, this message translates to:
  /// **'About Language Rally'**
  String get aboutLanguageRally;

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'🚀 Welcome to Language Rally'**
  String get welcomeTitle;

  /// No description provided for @welcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Level up your language skills — the smart and playful way.'**
  String get welcomeSubtitle;

  /// No description provided for @welcomeIntro.
  ///
  /// In en, this message translates to:
  /// **'Learn vocabulary and expressions efficiently by practicing what you actually care about. No boring lists. No wasted time.'**
  String get welcomeIntro;

  /// No description provided for @sectionPlayYourGame.
  ///
  /// In en, this message translates to:
  /// **'🎮 Play Your Own Game'**
  String get sectionPlayYourGame;

  /// No description provided for @sectionPlayYourGameDesc.
  ///
  /// In en, this message translates to:
  /// **'Create your own vocabulary packages. Train only the words and expressions you want to master. Already know it? It will be marked and skipped!'**
  String get sectionPlayYourGameDesc;

  /// No description provided for @sectionAITeammate.
  ///
  /// In en, this message translates to:
  /// **'🤖 AI as Your Teammate'**
  String get sectionAITeammate;

  /// No description provided for @sectionAITeammateDesc.
  ///
  /// In en, this message translates to:
  /// **'Paste any text and let AI:\n• Extract useful vocabulary\n• Pick expressions that match your level\n• Build ready-to-train packages in seconds'**
  String get sectionAITeammateDesc;

  /// No description provided for @sectionTrainSmart.
  ///
  /// In en, this message translates to:
  /// **'🔁 Train Smart'**
  String get sectionTrainSmart;

  /// No description provided for @sectionTrainSmartDesc.
  ///
  /// In en, this message translates to:
  /// **'Our spaced repetition system shows items exactly when your brain needs them. Maximum progress. Minimum effort.'**
  String get sectionTrainSmartDesc;

  /// No description provided for @sectionRealExamples.
  ///
  /// In en, this message translates to:
  /// **'🌍 Real Examples. Great Translations.'**
  String get sectionRealExamples;

  /// No description provided for @sectionRealExamplesDesc.
  ///
  /// In en, this message translates to:
  /// **'Get real-world usage examples. Translate with premium quality via DeepL. Practice pronunciation and sound confident.'**
  String get sectionRealExamplesDesc;

  /// No description provided for @sectionTeachersWelcome.
  ///
  /// In en, this message translates to:
  /// **'👩‍🏫 Teachers Welcome'**
  String get sectionTeachersWelcome;

  /// No description provided for @sectionTeachersWelcomeDesc.
  ///
  /// In en, this message translates to:
  /// **'Create a package → Copy & Paste items or extract,  translate, add examples with the AI → Export → Upload/Send → Done. Your students import it and start practicing instantly.'**
  String get sectionTeachersWelcomeDesc;

  /// No description provided for @sectionUnlockAI.
  ///
  /// In en, this message translates to:
  /// **'🔑 Unlock Full AI Power'**
  String get sectionUnlockAI;

  /// No description provided for @sectionUnlockAIDesc.
  ///
  /// In en, this message translates to:
  /// **'For high-quality translation and AI features, simply:\n1. Create your DeepL API key\n   https://www.deepl.com/pro-api\n2. Create your OpenAI API key\n   https://platform.openai.com/api-keys\n3. Paste both keys into Settings\n\nA small investment unlocks powerful, professional-grade language tools.\n(We recommend using paid API access for best results.)'**
  String get sectionUnlockAIDesc;

  /// No description provided for @readyToStart.
  ///
  /// In en, this message translates to:
  /// **'Ready to start your rally? 🏁'**
  String get readyToStart;

  /// No description provided for @welcomeDescription.
  ///
  /// In en, this message translates to:
  /// **'Language Rally is your comprehensive language learning companion. Create custom vocabulary packages, organize items by categories, and train with an intelligent spaced repetition system.'**
  String get welcomeDescription;

  /// No description provided for @browseStore.
  ///
  /// In en, this message translates to:
  /// **'Browse Store'**
  String get browseStore;

  /// No description provided for @featureInteractiveTraining.
  ///
  /// In en, this message translates to:
  /// **'Interactive Training'**
  String get featureInteractiveTraining;

  /// No description provided for @featureInteractiveTrainingDesc.
  ///
  /// In en, this message translates to:
  /// **'Practice with adaptive learning algorithms'**
  String get featureInteractiveTrainingDesc;

  /// No description provided for @featureSmartOrganization.
  ///
  /// In en, this message translates to:
  /// **'Smart Organization'**
  String get featureSmartOrganization;

  /// No description provided for @featureSmartOrganizationDesc.
  ///
  /// In en, this message translates to:
  /// **'Categorize and filter your vocabulary'**
  String get featureSmartOrganizationDesc;

  /// No description provided for @featureTrackProgress.
  ///
  /// In en, this message translates to:
  /// **'Track Progress'**
  String get featureTrackProgress;

  /// No description provided for @featureTrackProgressDesc.
  ///
  /// In en, this message translates to:
  /// **'Monitor your learning with detailed statistics'**
  String get featureTrackProgressDesc;

  /// No description provided for @featureImportExport.
  ///
  /// In en, this message translates to:
  /// **'Import & Export'**
  String get featureImportExport;

  /// No description provided for @featureImportExportDesc.
  ///
  /// In en, this message translates to:
  /// **'Share packages and sync across devices'**
  String get featureImportExportDesc;

  /// No description provided for @startAppTour.
  ///
  /// In en, this message translates to:
  /// **'Start App Tour'**
  String get startAppTour;

  /// No description provided for @quickStartGuide.
  ///
  /// In en, this message translates to:
  /// **'Quick Start Guide'**
  String get quickStartGuide;

  /// No description provided for @tourStep1Title.
  ///
  /// In en, this message translates to:
  /// **'Create or Import Packages'**
  String get tourStep1Title;

  /// No description provided for @tourStep1Desc.
  ///
  /// In en, this message translates to:
  /// **'Start by creating a new language package or import an existing one from a file.'**
  String get tourStep1Desc;

  /// No description provided for @tourStep2Title.
  ///
  /// In en, this message translates to:
  /// **'Add Vocabulary Items'**
  String get tourStep2Title;

  /// No description provided for @tourStep2Desc.
  ///
  /// In en, this message translates to:
  /// **'Browse your packages and add words, phrases, or expressions with examples and categories.'**
  String get tourStep2Desc;

  /// No description provided for @tourStep3Title.
  ///
  /// In en, this message translates to:
  /// **'Configure Training'**
  String get tourStep3Title;

  /// No description provided for @tourStep3Desc.
  ///
  /// In en, this message translates to:
  /// **'Choose which items to practice, set difficulty levels, and customize your learning experience.'**
  String get tourStep3Desc;

  /// No description provided for @tourStep4Title.
  ///
  /// In en, this message translates to:
  /// **'Start Learning'**
  String get tourStep4Title;

  /// No description provided for @tourStep4Desc.
  ///
  /// In en, this message translates to:
  /// **'Begin your training session and mark items as known or unknown to track your progress.'**
  String get tourStep4Desc;

  /// No description provided for @tourStep5Title.
  ///
  /// In en, this message translates to:
  /// **'Review Statistics'**
  String get tourStep5Title;

  /// No description provided for @tourStep5Desc.
  ///
  /// In en, this message translates to:
  /// **'Check your learning progress with detailed statistics and achievement badges.'**
  String get tourStep5Desc;

  /// No description provided for @gotIt.
  ///
  /// In en, this message translates to:
  /// **'Got it!'**
  String get gotIt;

  /// No description provided for @appTourTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Language Rally'**
  String get appTourTitle;

  /// No description provided for @appTourSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your smart, playful, and fully personalized language learning companion.'**
  String get appTourSubtitle;

  /// No description provided for @tourPage1Title.
  ///
  /// In en, this message translates to:
  /// **'Learn and Practice What You Want and What You Need'**
  String get tourPage1Title;

  /// No description provided for @tourPage1Desc.
  ///
  /// In en, this message translates to:
  /// **'Our adaptive learning system ensures you review items at the perfect moment — maximizing retention and minimizing effort.\n\nLearn with the help of the built-in automation.\nStop wasting time on words you already know.\n\nPractice only the vocabulary and expressions that interest you. Create and train your own items — fully tailored to your goals and level.'**
  String get tourPage1Desc;

  /// No description provided for @tourPage2Title.
  ///
  /// In en, this message translates to:
  /// **'Create Your Own Language Package'**
  String get tourPage2Title;

  /// No description provided for @tourPage2Desc.
  ///
  /// In en, this message translates to:
  /// **'Build personalized vocabulary collections that match your interests and learning goals.\n\nOrganize words and expressions by topic, difficulty, or context.\n\nComplete control over what you learn and when.'**
  String get tourPage2Desc;

  /// No description provided for @tourPage3Title.
  ///
  /// In en, this message translates to:
  /// **'AI-Powered Items Creation'**
  String get tourPage3Title;

  /// No description provided for @tourPage3Desc.
  ///
  /// In en, this message translates to:
  /// **'Build your own learning packages in the blink of an eye:\n\n• Paste any text and let AI extract relevant vocabulary automatically\n• Identify words and expressions perfectly suited to your level\n• Let the AI do the translation for you\n• Let the AI search real-time examples\n• Create packages ready for training quickly'**
  String get tourPage3Desc;

  /// No description provided for @tourPage4Title.
  ///
  /// In en, this message translates to:
  /// **'AI-Powered Real-World Examples & Premium Translation'**
  String get tourPage4Title;

  /// No description provided for @tourPage4Desc.
  ///
  /// In en, this message translates to:
  /// **'• Instantly search for authentic usage examples\n• Translate words, expressions, and full sentences with high-quality DeepL integration\n• Get accurate, context-aware results'**
  String get tourPage4Desc;

  /// No description provided for @tourPage5Title.
  ///
  /// In en, this message translates to:
  /// **'Smart Package Organization'**
  String get tourPage5Title;

  /// No description provided for @tourPage5Desc.
  ///
  /// In en, this message translates to:
  /// **'• Organize vocabulary into custom categories\n• Filter and focus on specific topics\n• Import & export packages across devices\n• Share packages easily with others'**
  String get tourPage5Desc;

  /// No description provided for @tourPage6Title.
  ///
  /// In en, this message translates to:
  /// **'Training Your Pronunciation'**
  String get tourPage6Title;

  /// No description provided for @tourPage6Desc.
  ///
  /// In en, this message translates to:
  /// **'Test and improve your pronunciation with interactive practice tools.\n\nBuild confidence in speaking — not just reading.'**
  String get tourPage6Desc;

  /// No description provided for @tourPage7Title.
  ///
  /// In en, this message translates to:
  /// **'For Teachers'**
  String get tourPage7Title;

  /// No description provided for @tourPage7Desc.
  ///
  /// In en, this message translates to:
  /// **'Create ready-to-use vocabulary packages for your students in just a few clicks.\n\nExport them, send them to your class — and once imported, they\'re instantly ready for practice on each student\'s device.\n\nSimple. Fast. Effective.'**
  String get tourPage7Desc;

  /// No description provided for @tourPage8Title.
  ///
  /// In en, this message translates to:
  /// **'Unlock High-Quality AI Support'**
  String get tourPage8Title;

  /// No description provided for @tourPage8Desc.
  ///
  /// In en, this message translates to:
  /// **'For premium translations and advanced AI features, simply:\n 1. Create your own DeepL API key\n 2. Create your own OpenAI API key\n 3. Paste both keys into the Settings section\n\nThis requires only a small budget (a few dollars), but gives you access to powerful, professional-grade language tools.\nNote: We recommend using paid API access for best results. It costs only a few dollars.\n\n🔑 DeepL API Key: https://www.deepl.com/pro-api\n\n🔑 OpenAI API Key: https://platform.openai.com/api-keys'**
  String get tourPage8Desc;

  /// No description provided for @previousPage.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previousPage;

  /// No description provided for @nextPage.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get nextPage;

  /// No description provided for @endTour.
  ///
  /// In en, this message translates to:
  /// **'End Tour'**
  String get endTour;

  /// No description provided for @pageIndicator.
  ///
  /// In en, this message translates to:
  /// **'Page {current} of {total}'**
  String pageIndicator(int current, int total);

  /// No description provided for @practicePronunciation.
  ///
  /// In en, this message translates to:
  /// **'Practice Pronunciation'**
  String get practicePronunciation;

  /// No description provided for @pronunciationPractice.
  ///
  /// In en, this message translates to:
  /// **'Pronunciation Practice'**
  String get pronunciationPractice;

  /// No description provided for @startPractice.
  ///
  /// In en, this message translates to:
  /// **'Start Practice'**
  String get startPractice;

  /// No description provided for @listenToPronunciation.
  ///
  /// In en, this message translates to:
  /// **'Listen to pronunciation'**
  String get listenToPronunciation;

  /// No description provided for @tapToRecord.
  ///
  /// In en, this message translates to:
  /// **'Tap to record'**
  String get tapToRecord;

  /// No description provided for @recording.
  ///
  /// In en, this message translates to:
  /// **'Recording...'**
  String get recording;

  /// No description provided for @recorded.
  ///
  /// In en, this message translates to:
  /// **'Recorded'**
  String get recorded;

  /// No description provided for @speakNow.
  ///
  /// In en, this message translates to:
  /// **'Speak now - speak clearly and close to the microphone'**
  String get speakNow;

  /// No description provided for @noSpeechDetected.
  ///
  /// In en, this message translates to:
  /// **'No speech detected. Please try again.'**
  String get noSpeechDetected;

  /// No description provided for @noTextRecognized.
  ///
  /// In en, this message translates to:
  /// **'No speech was recognized in the recording. Please make sure your microphone is working and try again.'**
  String get noTextRecognized;

  /// No description provided for @processingAudio.
  ///
  /// In en, this message translates to:
  /// **'Processing audio with AI...'**
  String get processingAudio;

  /// No description provided for @playbackRecording.
  ///
  /// In en, this message translates to:
  /// **'Play back my recording'**
  String get playbackRecording;

  /// No description provided for @playbackRecordingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Hear your recording while AI processes it'**
  String get playbackRecordingSubtitle;

  /// No description provided for @recordingTooShort.
  ///
  /// In en, this message translates to:
  /// **'Recording too short. Please speak for at least 1 second.'**
  String get recordingTooShort;

  /// No description provided for @microphonePermissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Microphone permission is required for pronunciation practice'**
  String get microphonePermissionRequired;

  /// No description provided for @speechRecognitionNotSupported.
  ///
  /// In en, this message translates to:
  /// **'Speech recognition is not supported on this platform. Please use the mobile app (Android/iOS) for pronunciation practice.'**
  String get speechRecognitionNotSupported;

  /// No description provided for @speechRecognitionUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Speech recognition is not available on this device.'**
  String get speechRecognitionUnavailable;

  /// No description provided for @pronunciationAccuracy.
  ///
  /// In en, this message translates to:
  /// **'Pronunciation\nAccuracy'**
  String get pronunciationAccuracy;

  /// No description provided for @excellent.
  ///
  /// In en, this message translates to:
  /// **'Excellent!'**
  String get excellent;

  /// No description provided for @good.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get good;

  /// No description provided for @fair.
  ///
  /// In en, this message translates to:
  /// **'Fair'**
  String get fair;

  /// No description provided for @needsImprovement.
  ///
  /// In en, this message translates to:
  /// **'Needs Improvement'**
  String get needsImprovement;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @nextItem.
  ///
  /// In en, this message translates to:
  /// **'Next Item'**
  String get nextItem;

  /// No description provided for @endPractice.
  ///
  /// In en, this message translates to:
  /// **'End Practice'**
  String get endPractice;

  /// No description provided for @practiced.
  ///
  /// In en, this message translates to:
  /// **'Practiced'**
  String get practiced;

  /// No description provided for @windowsAudioTestPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Windows Audio Test (RTAudio)'**
  String get windowsAudioTestPageTitle;

  /// No description provided for @configureWindowsAudio.
  ///
  /// In en, this message translates to:
  /// **'Test and configure audio input on Windows'**
  String get configureWindowsAudio;

  /// No description provided for @configureWindowsAudioDescription.
  ///
  /// In en, this message translates to:
  /// **'Record, play back and transcribe audio using the native Windows RTAudio driver'**
  String get configureWindowsAudioDescription;

  /// No description provided for @audioTestTitle.
  ///
  /// In en, this message translates to:
  /// **'Windows Audio Recording Test'**
  String get audioTestTitle;

  /// No description provided for @audioTestSubtitle.
  ///
  /// In en, this message translates to:
  /// **'RTAudio — Native Windows audio recording'**
  String get audioTestSubtitle;

  /// No description provided for @audioInputDevice.
  ///
  /// In en, this message translates to:
  /// **'Audio Input Device'**
  String get audioInputDevice;

  /// No description provided for @selectMicrophone.
  ///
  /// In en, this message translates to:
  /// **'Select Microphone'**
  String get selectMicrophone;

  /// No description provided for @refreshDevices.
  ///
  /// In en, this message translates to:
  /// **'Refresh Devices'**
  String get refreshDevices;

  /// No description provided for @noAudioDevicesFound.
  ///
  /// In en, this message translates to:
  /// **'No audio input devices found'**
  String get noAudioDevicesFound;

  /// No description provided for @loadingAudioDevices.
  ///
  /// In en, this message translates to:
  /// **'Loading audio devices...'**
  String get loadingAudioDevices;

  /// No description provided for @recordingSettings.
  ///
  /// In en, this message translates to:
  /// **'Recording Settings'**
  String get recordingSettings;

  /// No description provided for @stereoRecording.
  ///
  /// In en, this message translates to:
  /// **'Stereo Recording'**
  String get stereoRecording;

  /// No description provided for @stereoChannels.
  ///
  /// In en, this message translates to:
  /// **'2 channels (stereo)'**
  String get stereoChannels;

  /// No description provided for @monoChannel.
  ///
  /// In en, this message translates to:
  /// **'1 channel (mono)'**
  String get monoChannel;

  /// No description provided for @sampleRateLabel.
  ///
  /// In en, this message translates to:
  /// **'Sample Rate'**
  String get sampleRateLabel;

  /// No description provided for @nativeRateBadge.
  ///
  /// In en, this message translates to:
  /// **'native'**
  String get nativeRateBadge;

  /// No description provided for @microphoneGainLabel.
  ///
  /// In en, this message translates to:
  /// **'Microphone Gain'**
  String get microphoneGainLabel;

  /// No description provided for @gainHint.
  ///
  /// In en, this message translates to:
  /// **'1x = no boost  •  3x ≈ +9.5 dB  •  10x ≈ +20 dB'**
  String get gainHint;

  /// No description provided for @tapToStartRec.
  ///
  /// In en, this message translates to:
  /// **'Tap to Start Recording'**
  String get tapToStartRec;

  /// No description provided for @tapToStopRec.
  ///
  /// In en, this message translates to:
  /// **'Tap to Stop Recording'**
  String get tapToStopRec;

  /// No description provided for @recordingCompleteLabel.
  ///
  /// In en, this message translates to:
  /// **'Recording Complete'**
  String get recordingCompleteLabel;

  /// No description provided for @tapMicToStop.
  ///
  /// In en, this message translates to:
  /// **'Tap microphone to stop'**
  String get tapMicToStop;

  /// No description provided for @playRecordingLabel.
  ///
  /// In en, this message translates to:
  /// **'Play Recording'**
  String get playRecordingLabel;

  /// No description provided for @stopPlaybackLabel.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get stopPlaybackLabel;

  /// No description provided for @whisperSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'OpenAI Whisper Transcription'**
  String get whisperSectionTitle;

  /// No description provided for @whisperWavNote.
  ///
  /// In en, this message translates to:
  /// **'WAV (16-bit PCM) is natively supported by Whisper — no conversion needed.'**
  String get whisperWavNote;

  /// No description provided for @sendToWhisperLabel.
  ///
  /// In en, this message translates to:
  /// **'Send to Whisper'**
  String get sendToWhisperLabel;

  /// No description provided for @transcribingLabel.
  ///
  /// In en, this message translates to:
  /// **'Transcribing...'**
  String get transcribingLabel;

  /// No description provided for @transcriptionResultLabel.
  ///
  /// In en, this message translates to:
  /// **'Transcription Result'**
  String get transcriptionResultLabel;

  /// No description provided for @transcriptionFailedLabel.
  ///
  /// In en, this message translates to:
  /// **'Transcription Failed'**
  String get transcriptionFailedLabel;

  /// No description provided for @debugInformationLabel.
  ///
  /// In en, this message translates to:
  /// **'Information'**
  String get debugInformationLabel;

  /// No description provided for @debugConsoleHint.
  ///
  /// In en, this message translates to:
  /// **'Check the console for detailed logs'**
  String get debugConsoleHint;

  /// No description provided for @debugDevicesFound.
  ///
  /// In en, this message translates to:
  /// **'Devices Found'**
  String get debugDevicesFound;

  /// No description provided for @debugSelectedDevice.
  ///
  /// In en, this message translates to:
  /// **'Selected Device'**
  String get debugSelectedDevice;

  /// No description provided for @debugDeviceRateNative.
  ///
  /// In en, this message translates to:
  /// **'Device Rate (native)'**
  String get debugDeviceRateNative;

  /// No description provided for @debugRequestedRate.
  ///
  /// In en, this message translates to:
  /// **'Requested Rate'**
  String get debugRequestedRate;

  /// No description provided for @debugActualRate.
  ///
  /// In en, this message translates to:
  /// **'Actual Rate Used'**
  String get debugActualRate;

  /// No description provided for @debugActualRateForced.
  ///
  /// In en, this message translates to:
  /// **'⚠ forced'**
  String get debugActualRateForced;

  /// No description provided for @debugActualRateOk.
  ///
  /// In en, this message translates to:
  /// **'✓'**
  String get debugActualRateOk;

  /// No description provided for @debugRecordingMode.
  ///
  /// In en, this message translates to:
  /// **'Recording Mode'**
  String get debugRecordingMode;

  /// No description provided for @debugLastRecording.
  ///
  /// In en, this message translates to:
  /// **'Last Recording'**
  String get debugLastRecording;

  /// No description provided for @debugFileSize.
  ///
  /// In en, this message translates to:
  /// **'File Size'**
  String get debugFileSize;

  /// No description provided for @debugStereo.
  ///
  /// In en, this message translates to:
  /// **'Stereo'**
  String get debugStereo;

  /// No description provided for @debugMono.
  ///
  /// In en, this message translates to:
  /// **'Mono'**
  String get debugMono;

  /// No description provided for @recordingSavedSnack.
  ///
  /// In en, this message translates to:
  /// **'Recording saved'**
  String get recordingSavedSnack;

  /// No description provided for @recordingTooShortSnack.
  ///
  /// In en, this message translates to:
  /// **'Recording is too short. Please record for at least 1 second.'**
  String get recordingTooShortSnack;

  /// No description provided for @recordingSmallSnack.
  ///
  /// In en, this message translates to:
  /// **'Recording file is very small. Recording may have failed.'**
  String get recordingSmallSnack;

  /// No description provided for @noAudioDataSnack.
  ///
  /// In en, this message translates to:
  /// **'No audio data recorded'**
  String get noAudioDataSnack;

  /// No description provided for @noDeviceSelectedSnack.
  ///
  /// In en, this message translates to:
  /// **'Please select an audio device'**
  String get noDeviceSelectedSnack;

  /// No description provided for @failedToInitRtAudio.
  ///
  /// In en, this message translates to:
  /// **'Failed to initialize RTAudio'**
  String get failedToInitRtAudio;

  /// No description provided for @envelopeScoreLabel.
  ///
  /// In en, this message translates to:
  /// **'Envelope'**
  String get envelopeScoreLabel;

  /// No description provided for @rhythmScoreLabel.
  ///
  /// In en, this message translates to:
  /// **'Rhythm'**
  String get rhythmScoreLabel;

  /// No description provided for @textScoreLabel.
  ///
  /// In en, this message translates to:
  /// **'Text'**
  String get textScoreLabel;

  /// No description provided for @help.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get help;

  /// No description provided for @trainingHelpTitle.
  ///
  /// In en, this message translates to:
  /// **'Training Tips'**
  String get trainingHelpTitle;

  /// No description provided for @trainingHelpText.
  ///
  /// In en, this message translates to:
  /// **'To make your training as effective as possible, follow these steps:\n1. Click the \'Clear counters\' button so that all items in this package are marked as known.'**
  String get trainingHelpText;
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
