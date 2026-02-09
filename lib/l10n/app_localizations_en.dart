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
  String get packageIcon => 'Package Icon';

  @override
  String get selectIcon => 'Select Icon';

  @override
  String get defaultIcon => 'Default Icon';

  @override
  String get customIcon => 'Custom Icon';

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
  String get readOnlyPackage => 'This package is read-only and cannot be edited';

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
  String get confirmClearCounters => 'Are you sure you want to clear all training counters for this package? This will reset the \'don\'t know\' counters and training statistics.';

  @override
  String get clear => 'Clear';

  @override
  String get countersCleared => 'Counters cleared successfully';

  @override
  String get errorClearingCounters => 'Error clearing counters';

  @override
  String get deleteAll => 'Delete All Data';

  @override
  String get confirmDeleteAllData => 'Are you sure you want to delete this package with ALL its data? This will permanently delete all categories, items, and training statistics. This action cannot be undone!';

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
  String get importFormatDescription => 'Import items from a text file. Each line should contain an item in the following format:';

  @override
  String get importResults => 'Import Results';

  @override
  String get successfullyImported => 'Successfully imported';

  @override
  String get failedToImport => 'Failed to import';

  @override
  String get errorImportingItems => 'Error importing items';

  @override
  String get close => 'Close';
}
