// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hungarian (`hu`).
class AppLocalizationsHu extends AppLocalizations {
  AppLocalizationsHu([String locale = 'hu']) : super(locale);

  @override
  String get helloWorld => 'Helló Világ!';

  @override
  String get welcome => 'Isten hozott a Language Rally-ban';

  @override
  String get appTitle => 'Language Rally';

  @override
  String get createPackage => 'Csomag létrehozása';

  @override
  String get editPackage => 'Csomag szerkesztése';

  @override
  String get packageDetails => 'Csomag részletei';

  @override
  String get languageCode1 => 'Forrás nyelv kódja';

  @override
  String get languageName1 => 'Forrás nyelv neve';

  @override
  String get languageCode2 => 'Cél nyelv kódja';

  @override
  String get languageName2 => 'Cél nyelv neve';

  @override
  String get description => 'Leírás';

  @override
  String get descriptionHint => 'Rövid leírás a nyelvi csomagról';

  @override
  String get authorName => 'Szerző neve';

  @override
  String get authorEmail => 'Szerző e-mail címe';

  @override
  String get authorWebpage => 'Szerző weboldala';

  @override
  String get version => 'Verzió';

  @override
  String get items => 'elem';

  @override
  String get packageIcon => 'Csomag ikon';

  @override
  String get selectIcon => 'Ikon kiválasztása';

  @override
  String get defaultIcon => 'Alapértelmezett ikon';

  @override
  String get customIcon => 'Egyéni ikon';

  @override
  String get save => 'Mentés';

  @override
  String get cancel => 'Mégse';

  @override
  String get delete => 'Törlés';

  @override
  String get confirmDelete => 'Biztosan törölni szeretné ezt a csomagot?';

  @override
  String get packageSaved => 'Csomag sikeresen mentve';

  @override
  String get packageDeleted => 'Csomag sikeresen törölve';

  @override
  String get errorSavingPackage => 'Hiba a csomag mentése során';

  @override
  String get errorDeletingPackage => 'Hiba a csomag törlése során';

  @override
  String get fieldRequired => 'Ez a mező kötelező';

  @override
  String get invalidEmail => 'Érvénytelen e-mail cím';

  @override
  String get invalidUrl => 'Érvénytelen URL';

  @override
  String get readOnlyPackage =>
      'Ez a csomag csak olvasható és nem szerkeszthető';

  @override
  String get purchasedPackage => 'A megvásárolt csomagok nem szerkeszthetők';

  @override
  String get badges => 'Jelvények';

  @override
  String get noBadges => 'Még nincs megszerzett jelvény';

  @override
  String get selectLanguageCode => 'Nyelvkód kiválasztása';

  @override
  String get clearCounters => 'Számlálók törlése';

  @override
  String get confirmClearCounters =>
      'Biztosan törölni szeretné az összes edzési számlálót ebből a csomagból? Ez visszaállítja a \'nem tudom\' számlálókat és az edzési statisztikákat.';

  @override
  String get clear => 'Törlés';

  @override
  String get countersCleared => 'Számlálók sikeresen törölve';

  @override
  String get errorClearingCounters => 'Hiba a számlálók törlése során';

  @override
  String get deleteAll => 'Minden adat törlése';

  @override
  String get confirmDeleteAllData =>
      'Biztosan törölni szeretné ezt a csomagot az ÖSSZES adatával? Ez véglegesen törli az összes kategóriát, elemet és edzési statisztikát. Ez a művelet nem vonható vissza!';

  @override
  String get allDataDeleted => 'Csomag és minden adat sikeresen törölve';

  @override
  String get exportPackage => 'Csomag exportálása';

  @override
  String get selectExportLocation => 'Exportálási hely kiválasztása';

  @override
  String get packageExported => 'Csomag sikeresen exportálva';

  @override
  String get errorExportingPackage => 'Hiba a csomag exportálása során';

  @override
  String get importItems => 'Elemek importálása';

  @override
  String get selectImportFile => 'Importálandó fájl kiválasztása';

  @override
  String get importFormat => 'Importálási formátum';

  @override
  String get importFormatDescription =>
      'Elemek importálása szöveges fájlból. Minden sor egy elemet tartalmaz a következő formátumban:';

  @override
  String get importResults => 'Importálási eredmények';

  @override
  String get successfullyImported => 'Sikeresen importálva';

  @override
  String get failedToImport => 'Importálás sikertelen';

  @override
  String get errorImportingItems => 'Hiba az elemek importálása során';

  @override
  String get close => 'Bezárás';
}
