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
  /// **'Upload'**
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
  /// **'Delete All Data'**
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
  /// **'A package with the same language pair, description, author information, and version already exists. Would you like to import it as a new package anyway?'**
  String get packageExistsMessage;

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
