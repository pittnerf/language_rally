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
  String get packageGroup => 'Csoport';

  @override
  String get selectIcon => 'Ikon kiválasztása';

  @override
  String get defaultIcon => 'Alapértelmezett ikon';

  @override
  String get customIcon => 'Egyéni ikon';

  @override
  String get upload => 'Ikon feltöltése';

  @override
  String get uploadCustomIcon => 'Egyéni ikon feltöltése (max 512x512, 1MB)';

  @override
  String get customIconUploaded => 'Egyéni ikon sikeresen feltöltve';

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
      'Biztosan törölni szeretné az összes gyakorlásii számlálót ebből a csomagból? Ez visszaállítja a \'nem tudom\' számlálókat és a gyakorlási statisztikákat.';

  @override
  String get clear => 'Törlés';

  @override
  String get countersCleared => 'Számlálók sikeresen törölve';

  @override
  String get errorClearingCounters => 'Hiba a számlálók törlése során';

  @override
  String get deleteAll => 'Csomag törlése';

  @override
  String get confirmDeleteAllData =>
      'Biztosan törölni szeretné ezt a csomagot az ÖSSZES adatával? Ez véglegesen törli az összes kategóriát, elemet és gyakorlási statisztikát. Ez a művelet nem vonható vissza!';

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
  String get error => 'Hiba';

  @override
  String get ok => 'OK';

  @override
  String get close => 'Bezárás';

  @override
  String get importPackage => 'Csomag importálása';

  @override
  String get importPackageTooltip => 'Csomag importálása ZIP fájlból';

  @override
  String get selectPackageZipFile => 'Válasszon csomag ZIP fájlt';

  @override
  String get couldNotAccessFile => 'A kiválasztott fájl nem érhető el.';

  @override
  String get importingPackage => 'Csomag importálása...';

  @override
  String get packageImportedSuccessfully => 'Csomag sikeresen importálva!';

  @override
  String packageImportedWithItems(Object count) {
    return 'Csomag sikeresen importálva! ($count elem)';
  }

  @override
  String packageImportedWithGroup(Object count, Object groupName) {
    return 'Csomag importálva a \"$groupName\" csoportba! ($count elem)';
  }

  @override
  String get importError => 'Importálási hiba';

  @override
  String get failedToImportPackage => 'Nem sikerült a csomag importálása';

  @override
  String get packageAlreadyExists => 'A csomag már létezik';

  @override
  String packageExistsMessage(Object groupName) {
    return 'Már létezik egy csomag ugyanezzel a nyelvpárral, leírással, szerző információval és verzióval. Szeretné mindenképpen új csomagként importálni?';
  }

  @override
  String get importAsNew => 'Importálás mindenképpen';

  @override
  String get zipFileNotFound => 'ZIP fájl nem található';

  @override
  String get invalidPackageZip =>
      'Érvénytelen csomag ZIP: hiányzik a package_data.json';

  @override
  String get invalidPackageFormat => 'Érvénytelen csomag fájlformátum';

  @override
  String get languagePackages => 'Nyelvi csomagok';

  @override
  String get loadingPackages => 'Csomagok betöltése...';

  @override
  String get tapAndHoldToReorder =>
      'Érintse meg és tartsa lenyomva az átrendezéshez';

  @override
  String get tapAndHoldToReorderList =>
      'Érintse meg és tartsa ≡ az átrendezéshez • Érintse ⋮ a kompakt nézethez';

  @override
  String get noPackagesYet => 'Még nincs csomag';

  @override
  String get createFirstPackage => 'Hozza létre az első nyelvi csomagját';

  @override
  String get versionLabel => 'Verzió';

  @override
  String get purchased => 'Megvásárolt';

  @override
  String get compactView => 'Kompakt nézet';

  @override
  String get expand => 'Kibontás';

  @override
  String get allCategories => 'Összes kategória';

  @override
  String get categoriesInPackage => 'Kategóriák ebben a csomagban';

  @override
  String get categories => 'Kategóriák';

  @override
  String get testInterFonts => 'Inter betűtípusok tesztelése';

  @override
  String get viewPackages => 'Csomagok megtekintése';

  @override
  String get createNewPackage => 'Új csomag létrehozása';

  @override
  String get generateTestData => 'Teszt adatok generálása';

  @override
  String get designSystemShowcase => 'Designrendszer bemutató';

  @override
  String get badgeEarned => 'Jelvény megszerzése!';

  @override
  String get achievement => 'Teljesítmény';

  @override
  String get awesome => 'Remek!';

  @override
  String get importFormatNotes => 'Megjegyzések:';

  @override
  String get importFormatLine1 => '• Minden sor egy elemet képvisel';

  @override
  String get importFormatLine2 => '• A mezőket | karakter választja el';

  @override
  String get importFormatLine3 => '• A kategóriákat ; karakter választja el';

  @override
  String get importFormatLine4 => '• Az utolsó | opcionális';

  @override
  String get importFormatLine5 => '• Az üres sorok figyelmen kívül maradnak';

  @override
  String get importFormatLine6 => '• A duplikátumok kihagyásra kerülnek';

  @override
  String andMore(Object count) {
    return '... és még $count';
  }

  @override
  String get browseItems => 'Elemek böngészése';

  @override
  String get itemDetails => 'Részletek';

  @override
  String get filterItems => 'Elemek szűrése';

  @override
  String searchLanguage1(Object language) {
    return 'Keresés ebben: $language';
  }

  @override
  String searchLanguage2(Object language) {
    return 'Keresés ebben: $language';
  }

  @override
  String get caseSensitive => 'Kis- és nagybetű érzékeny';

  @override
  String get onlyImportant => 'Csak fontos elemek';

  @override
  String get onlyFavourite => 'Csak kedvenc elemek';

  @override
  String get knownStatus => 'Tudás állapota';

  @override
  String get allItems => 'Minden elem';

  @override
  String get itemsIKnew => 'Elemek, amiket tudtam';

  @override
  String get itemsIDidNotKnow => 'Elemek, amiket nem tudtam';

  @override
  String get known => 'Tudom';

  @override
  String get important => 'Fontos';

  @override
  String get favourite => 'Kedvenc';

  @override
  String get examples => 'Példamondatok';

  @override
  String get examplesHint =>
      'Írj be példamondatokat (soronként egyet, használj | jelet a nyelvek elválasztására)';

  @override
  String get noExamples => 'Nincsenek elérhető példamondatok';

  @override
  String get pronounce => 'Kiejtés';

  @override
  String get ttsError => 'Szövegfelolvasás nem elérhető';

  @override
  String get noItemsFound => 'Nem található elem';

  @override
  String get noItemsInPackage => 'Még nincs elem ebben a csomagban';

  @override
  String get clearFilters => 'Szűrők törlése';

  @override
  String itemCount(Object count) {
    return '$count elem';
  }

  @override
  String filteredItemCount(Object filtered, Object total) {
    return '$filtered / $total elem';
  }

  @override
  String get trainingRally => 'Gyakorlás';

  @override
  String get startTraining => 'Gyakorlás kezdése';

  @override
  String get trainingComingSoon => 'Gyakorlás - Hamarosan!';

  @override
  String get aiServiceNotConfigured =>
      'AI szolgáltatás nincs konfigurálva. Kérlek, add meg az OpenAI API kulcsot.';

  @override
  String pleaseEnterTextInLanguageFirst(Object language) {
    return 'Kérlek, először adj meg szöveget $language nyelven';
  }

  @override
  String translationCompletedSuccessfully(Object service) {
    return 'Fordítás sikeresen elkészült ($service)!';
  }

  @override
  String get translationFailed => 'Fordítás sikertelen';

  @override
  String addedExamplesSuccessfully(Object count) {
    return '$count példa sikeresen hozzáadva!';
  }

  @override
  String get failedToGenerateExamples => 'Példák generálása sikertelen';

  @override
  String get selectExamplesToAdd => 'Példák kiválasztása';

  @override
  String get selectWhichExamples =>
      'Válaszd ki, melyik példákat szeretnéd hozzáadni:';

  @override
  String get deselectAll => 'Összes kijelölésének törlése';

  @override
  String get selectAll => 'Összes kijelölése';

  @override
  String get addSelected => 'Kijelöltek hozzáadása';

  @override
  String get pleaseSelectAtLeastOne => 'Kérlek, válassz ki legalább egy példát';

  @override
  String get addNewItem => 'Új elem hozzáadása';

  @override
  String get editItem => 'Elem szerkesztése';

  @override
  String get deleteItem => 'Elem törlése';

  @override
  String get confirmDeleteItem => 'Biztosan törölni szeretnéd ezt az elemet?';

  @override
  String get thisActionCannotBeUndone => 'Ez a művelet nem vonható vissza.';

  @override
  String get itemDeleted => 'Elem törölve';

  @override
  String get errorDeletingItem => 'Hiba az elem törlésekor';

  @override
  String get errorSavingItem => 'Hiba az elem mentésekor';

  @override
  String get itemSaved => 'Elem sikeresen frissítve';

  @override
  String get itemCreated => 'Elem sikeresen létrehozva';

  @override
  String get preTextOptional => 'Elő-szöveg (opcionális)';

  @override
  String get mainText => 'Fő szöveg';

  @override
  String get postTextOptional => 'Utó-szöveg (opcionális)';

  @override
  String get forExampleToForVerbs => 'pl. \"to\" igéknél angolul';

  @override
  String get additionalContext => 'További kontextus';

  @override
  String get translate => 'Fordítás';

  @override
  String translateFromTo(Object from, Object to) {
    return 'Fordítás $from → $to';
  }

  @override
  String get aiExampleGeneration => 'AI példa generálás';

  @override
  String get aiExampleSearch => 'AI példa keresés';

  @override
  String searchExamplesOnInternet(Object text) {
    return 'Példamondatok keresése az interneten AI segítségével ehhez: \'$text\'';
  }

  @override
  String generateExampleSentences(Object language) {
    return 'Példamondatok generálása a fő szöveg alapján ($language)';
  }

  @override
  String get generateExamples => 'Példák generálása';

  @override
  String get voiceInput => 'Hangbemenet';

  @override
  String get settings => 'Beállítások';

  @override
  String get uiLanguage => 'Felület Nyelve';

  @override
  String get uiLanguageDescription => 'Az alkalmazás felületének nyelve';

  @override
  String get uiLanguageHelper => 'Válaszd ki a menük, gombok és címkék nyelvét';

  @override
  String get userLanguage => 'Felhasználói nyelv';

  @override
  String get userLanguageDescription =>
      'A nyilvi csomagok létrehozásánál preferált anyanyelv';

  @override
  String get apiKeys => 'API kulcsok';

  @override
  String get deeplApiKey => 'DeepL API kulcs';

  @override
  String get deeplApiKeyDescription =>
      'Prémium fordítási minőséghez a tételek szerkesztésénél (opcionális)';

  @override
  String get openaiApiKey => 'OpenAI API kulcs';

  @override
  String get openaiApiKeyDescription =>
      'Jó minőségű példák generáláshoz AI segítségével (opcionális)';

  @override
  String get enterApiKey => 'API kulcs megadása';

  @override
  String get optional => 'opcionális';

  @override
  String get required => 'kötelező';

  @override
  String get settingsSaved => 'Beállítások sikeresen mentve';

  @override
  String get errorSavingSettings => 'Hiba a beállítások mentésekor';

  @override
  String get usingGoogleTranslate => 'Ingyenes Google Fordító használata';

  @override
  String get usingDeepL => 'DeepL használata (prémium)';

  @override
  String get textCannotBeEmpty => 'A szöveg nem lehet üres';

  @override
  String get noTranslationReceivedFromGoogle =>
      'Nem érkezett fordítás a Google-től';

  @override
  String get googleTranslationFailed => 'Google fordítás sikertelen';

  @override
  String get googleTranslationError => 'Google fordítási hiba';

  @override
  String get noTranslationReceivedFromDeepL =>
      'Nem érkezett fordítás a DeepL-től';

  @override
  String get invalidDeepLApiKey => 'Érvénytelen DeepL API kulcs';

  @override
  String get deeplTranslationQuotaExceeded => 'DeepL fordítási kvóta túllépve';

  @override
  String get deeplTranslationFailed => 'DeepL fordítás sikertelen';

  @override
  String get deeplTranslationError => 'DeepL fordítási hiba';

  @override
  String get invalidApiKeyConfigureOpenAI =>
      'Érvénytelen API kulcs. Kérlek, konfiguráld az OpenAI API kulcsot.';

  @override
  String get apiRateLimitExceeded =>
      'API sebesség limit túllépve. Kérlek, próbáld újra később.';

  @override
  String get aiRequestFailed => 'AI kérés sikertelen';

  @override
  String get failedToParseAiResponse =>
      'AI válasz feldolgozása sikertelen. Kérlek, próbáld újra.';

  @override
  String get aiGenerationError => 'AI generálási hiba';

  @override
  String get voiceInputPlaceholder =>
      'Hangbemenet a speech_to_text csomag használatával lesz megvalósítva';

  @override
  String get improveQualityWithApiKeys =>
      '💡 Tipp: A fordítások és példakeresések minősége jelentősen javítható a DeepL és OpenAI API kulcsok megadásával az alkalmazás beállításokban.';

  @override
  String get noApiKeyFallbackMessage =>
      'API kulcsok nélkül alapszintű fordítás és korlátozott példák érhetők el. A legjobb eredményekhez állítsd be az API kulcsokat a Beállításokban.';

  @override
  String get listeningForSpeech => 'Figyelek... Beszélj most';

  @override
  String get speechRecognitionNotAvailable =>
      'Beszédfelismerés nem elérhető ezen az eszközön';

  @override
  String get speechRecognitionPermissionDenied =>
      'Beszédfelismerési engedély megtagadva';

  @override
  String get speechRecognitionError => 'Beszédfelismerési hiba';

  @override
  String get tapToSpeak => 'Koppints a mikrofonra a beszédhez';

  @override
  String get speechNotRecognized =>
      'Nem sikerült felismerni a beszédet. Kérlek, próbáld újra.';

  @override
  String get trainingSettings => 'Gyakorlási Beállítások';

  @override
  String get itemScope => 'Elemek Köre';

  @override
  String get lastNItems => 'Utolsó N elem';

  @override
  String get onlyUnknown => 'Csak ismeretlen elemek';

  @override
  String get numberOfItems => 'Elemek Száma';

  @override
  String get itemOrder => 'Elemek Sorrendje';

  @override
  String get randomOrder => 'Véletlenszerű sorrend';

  @override
  String get sequentialOrder => 'Szekvenciális sorrend';

  @override
  String get displayLanguage => 'Megjelenítési Nyelv';

  @override
  String get motherTongue => 'Anyanyelv';

  @override
  String get targetLanguage => 'Célnyelv';

  @override
  String get randomLanguage => 'Véletlenszerű';

  @override
  String get categoryFilter => 'Kategória Szűrő';

  @override
  String get categoryFilterHint =>
      'Válaszd ki a kategóriákat (üres = minden kategória)';

  @override
  String get noCategories => 'Nincsenek elérhető kategóriák';

  @override
  String get dontKnowThreshold => 'Nem Tudom Küszöb';

  @override
  String get dontKnowThresholdHint =>
      'Hányszor kell \'nem tudom\'-nak jelölni egy elemet a speciális kezeléshez';

  @override
  String get startTrainingRally => 'Gyakorlási Rally Indítása';

  @override
  String get clearTrainingSettings => 'Beállítások Törlése';

  @override
  String get confirmClearTrainingSettings =>
      'Biztosan visszaállítod az összes gyakorlási beállítást az alapértelmezett értékekre?';

  @override
  String get trainingSettingsCleared =>
      'A gyakorlási beállítások törölve lettek';

  @override
  String get startingTraining => 'Gyakorlás indítása...';

  @override
  String get noMoreItemsToDisplay =>
      'Nincs több megjelenítendő elem a szűrési beállítások alapján.';

  @override
  String get noItems => 'Nincs Elem';

  @override
  String get trainingComplete => 'Gyakorlás Befejezve';

  @override
  String get allItemsCompleted =>
      'Gratulálunk! Befejezted az összes elemet ebben a gyakorlásban.';

  @override
  String get closeTraining => 'Gyakorlás Bezárása';

  @override
  String get confirmCloseTraining =>
      'Biztosan bezárod a gyakorlást? A folyamatod mentve lett.';

  @override
  String get question => 'Kérdés';

  @override
  String get answer => 'Válasz';

  @override
  String get iKnow => 'Tudom';

  @override
  String get iDontKnow => 'Nem Tudom';

  @override
  String get nextItem => 'Következő Elem';

  @override
  String get iDidNotKnowEither => 'Ezt Sem Tudtam';
}
