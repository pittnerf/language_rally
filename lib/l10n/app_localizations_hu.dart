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
  String get packageName => 'Csomag neve';

  @override
  String get packageNameHint => 'pl. Spanyol alapok, Német kezdőknek';

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
  String get uploadCustomIcon => 'Saját ikon feltöltése (max 512x512, 1MB)';

  @override
  String get customIconUploaded => 'Saját ikon sikeresen feltöltve';

  @override
  String get save => 'Mentés';

  @override
  String get edit => 'Szerkesztés';

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
  String get readOnlyPackage =>
      'Ez a csomag csak olvasható és nem szerkeszthető';

  @override
  String get purchasedPackage => 'A megvásárolt csomagok nem szerkeszthetők';

  @override
  String get badges => 'Medálok';

  @override
  String get noBadges => 'Még nincs megszerzett medál';

  @override
  String get selectLanguageCode => 'Nyelvkód kiválasztása';

  @override
  String get typeToSearchLanguages =>
      'Kezdj el gépelni a nyelvek kereséséhez...';

  @override
  String get search => 'Keresés...';

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
  String get importItems => 'Elemek importálása (JSON)';

  @override
  String get importItemsDialogTitle => 'Elemek importálása (JSON)';

  @override
  String get importItemsFromLocalJson => 'Importálás helyi JSON fájlból';

  @override
  String get enterItemsUrl => 'Elemek JSON URL-je (https://…)';

  @override
  String get downloadingItems => 'Elemek letöltése…';

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
  String get error => 'Hiba';

  @override
  String get ok => 'OK';

  @override
  String get importPackage => 'Csomag importálása';

  @override
  String get importPackageTooltip =>
      'Csomag importálása ZIP fájlból vagy URL-ről';

  @override
  String get importPackageDialogTitle => 'Nyelvi csomag importálása';

  @override
  String get importFromLocalFile => 'Importálás helyi fájlból';

  @override
  String get importFromUrl => 'Importálás URL-ről';

  @override
  String get enterPackageUrl => 'Csomag URL-je (https://…)';

  @override
  String get downloadingPackage => 'Csomag letöltése…';

  @override
  String get downloadFailed =>
      'Letöltés sikertelen. Ellenőrizze az URL-t és az internetkapcsolatot.';

  @override
  String get invalidUrl => 'Adjon meg érvényes http:// vagy https:// URL-t.';

  @override
  String get orLabel => 'vagy';

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
      'Érvénytelen csomag ZIP: hiányzik a package_data.json állomány';

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
  String get compactView => 'kompakt';

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
  String get designSystemShowcase => 'Design rendszer bemutató';

  @override
  String get badgeEarned => 'Medál megszerzése!';

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
  String get importFormatNewDescription =>
      'Elemek importálása szöveges fájlból. Minden sor egy elemet tartalmaz, a mezőket --- választja el';

  @override
  String get importFormatNewLine1 => '• Fő elválasztó: ---';

  @override
  String get importFormatNewLine2 =>
      '• L1=<szöveg> - 1. nyelv fő szövege (kötelező, ha L2 hiányzik)';

  @override
  String get importFormatNewLine3 =>
      '• L2=<szöveg> - 2. nyelv fő szövege (kötelező, ha L1 hiányzik)';

  @override
  String get importFormatNewLine4 =>
      '• L1pre=<szöveg> - 1. nyelv előtag (opcionális)';

  @override
  String get importFormatNewLine5 =>
      '• L1post=<szöveg> - 1. nyelv utótag (opcionális)';

  @override
  String get importFormatNewLine6 =>
      '• L2pre=<szöveg> - 2. nyelv előtag (opcionális)';

  @override
  String get importFormatNewLine7 =>
      '• L2post=<szöveg> - 2. nyelv utótag (opcionális)';

  @override
  String get importFormatNewLine8 =>
      '• EX=<L1 szöveg>:::<L2 szöveg> - Példa (opcionális, többször is szerepelhet)';

  @override
  String get importFormatNewLine9 =>
      '• CAT=<kat1>:::<kat2>:::<kat3> - Kategóriák (opcionális)';

  @override
  String get importFormatNewLine10 => '• Legalább az L1= vagy az L2= kötelező';

  @override
  String get importFormatNewLine11 =>
      '• Az üres sorok figyelmen kívül maradnak';

  @override
  String get importFormatNewLine12 => '• A duplikátumok kihagyásra kerülnek';

  @override
  String get invalidImportLine => 'Érvénytelen sor';

  @override
  String get missingRequiredFields => 'Hiányzik \'L1=\' vagy \'L2=\'';

  @override
  String get unknownField => 'Ismeretlen mező előtag';

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
  String get knownStatus => 'Tudás állapota';

  @override
  String get filterStatusAll => 'all';

  @override
  String get filterStatusKnown => 'known';

  @override
  String get filterStatusUnknown => 'unknown';

  @override
  String get allItems => 'Minden elem';

  @override
  String get itemsIKnew => 'Elemek, amiket tudtam';

  @override
  String get itemsIDidNotKnow => 'Elemek, amiket nem tudtam';

  @override
  String get known => 'Tudom';

  @override
  String get unknown => 'Tanulandó';

  @override
  String get important => 'Fontos';

  @override
  String get favourite => 'Kedvenc';

  @override
  String get badge => 'Medál';

  @override
  String get position => 'Pozíció';

  @override
  String get stepsUntilLearned => 'Lépés a megtanulásig';

  @override
  String get examples => 'Példamondatok';

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
  String get addItem => 'Elem hozzáadása';

  @override
  String get emptyPackageHint =>
      'Adjon hozzá elemeket manuálisan, vagy importáljon hatékonyan AI segítségével';

  @override
  String get noItemsToTrain => 'Nincs gyakorolható elem a szűrések alapján';

  @override
  String get clearFilters => 'Törlés';

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
      'AI szolgáltatás nincs konfigurálva. Kérlek, add meg az OpenAI API kulcsot a Beállításoknál.';

  @override
  String pleaseEnterTextInLanguageFirst(Object language) {
    return 'Kérlek, először adj meg egy szöveget $language nyelven';
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
  String get preTextOptional => 'Előtag (opcionális)';

  @override
  String get mainText => 'Fő szöveg';

  @override
  String get postTextOptional => 'Utótag (opcionális)';

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
  String get voiceInput => 'Hangbemenet';

  @override
  String get settings => 'Beállítások';

  @override
  String get uiLanguage => 'Megjelenítés nyelve';

  @override
  String get uiLanguageDescription => 'Az alkalmazás felületének nyelve';

  @override
  String get uiLanguageHelper => 'Válaszd ki a menük, gombok és címkék nyelvét';

  @override
  String get userLanguage => 'Felhasználói nyelv';

  @override
  String get userLanguageDescription =>
      'A nyelvi csomagok létrehozásánál preferált anyanyelv';

  @override
  String get apiKeys => 'API kulcsok';

  @override
  String get deeplApiKey => 'DeepL API kulcs';

  @override
  String get deeplApiKeyDescription =>
      'Prémium fordítási minőséghez a tételek szerkesztésénél. Látogasson el a https://www.deepl.com/pro-api linkre és hozzon létre API kulcsot.';

  @override
  String get openaiApiKey => 'OpenAI API kulcs';

  @override
  String get openaiApiKeyDescription =>
      'Jó minőségű példák generáláshoz AI segítségével. Látogasson el a https://platform.openai.com/api-keys linkre és hozzon létre API kulcsot.';

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
      'Érvénytelen API kulcs. Kérlek, konfiguráld az OpenAI API kulcsot a Beállításoknál.';

  @override
  String get apiRateLimitExceeded =>
      'API lekérdezési limit túllépve. Kérlek, próbáld újra később.';

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
      'API kulcsok nélkül alapszintű fordítás és korlátozott példák érhetők csak el. A legjobb eredményekhez állítsd be az API kulcsokat a Beállításokban.';

  @override
  String get listeningForSpeech => 'Figyelek... Most beszélj!';

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
  String get tapToStop => 'Koppints a leállításhoz';

  @override
  String get speechNotRecognized =>
      'Nem sikerült felismerni a beszédet. Kérlek, próbáld újra.';

  @override
  String get usingWhisperApiSlower =>
      'Felhő alapú AI beszédfelismerés használata (lassabb lehet)';

  @override
  String languageNotSupportedAddApiKey(String languageCode) {
    return 'A $languageCode nyelv natívan nem támogatott. Adj hozzá OpenAI API kulcsot a Beállításokban az AI-alapú beszédfelismeréshez.';
  }

  @override
  String get recordingTapToStop =>
      'Felvétel folyamatban... Koppints újra a leállításhoz';

  @override
  String get speakClearlyKeepRecording =>
      'Beszélj érthetően. Legalább 1 másodpercig rögzíts.';

  @override
  String get pleaseRecordLonger =>
      'Kérlek, beszélj legalább 1 másodpercig és koppints a leállításra.';

  @override
  String get errorStartingRecording => 'Hiba a felvétel indításakor';

  @override
  String get noAudioRecorded => 'Nem készült hangfelvétel';

  @override
  String get errorTranscribing => 'Hiba a hangátiratban';

  @override
  String get trainingSettings => 'Gyakorlási Beállítások';

  @override
  String get itemScope => 'Elemek Köre';

  @override
  String get lastNItems => 'Utolsó N elem';

  @override
  String get onlyUnknown => 'Csak ismeretlen elemek';

  @override
  String get onlyImportant => 'Csak fontos elemek';

  @override
  String get onlyFavourite => 'Csak kedvenc elemek';

  @override
  String get numberOfItems => 'Elemek Száma';

  @override
  String get itemOrder => 'Elemek Sorrendje';

  @override
  String get randomOrder => 'Véletlenszerű sorrend';

  @override
  String get sequentialOrder => 'Szekvenciális sorrend';

  @override
  String get itemType => 'Elem Típusa';

  @override
  String get dictionaryItems => 'Szótár elemek';

  @override
  String get examplesType => 'Példák';

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
  String get startTrainingRally => 'Gyakorlás Indítása (Rally)';

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
  String get previousItem => 'Előző elem';

  @override
  String get iDidNotKnowEither => 'Ezt Sem Tudtam';

  @override
  String get exportBeforeDelete => 'Exportálja törlés előtt?';

  @override
  String get aiTextAnalysis => 'Elemek AI-val';

  @override
  String get aiTextAnalysisImport => 'Import AI Szövegelemzéssel';

  @override
  String get knowledgeLevel => 'Tudásszint';

  @override
  String get a1Beginner => 'A1 - Kezdő';

  @override
  String get a2Elementary => 'A2 - Alapszint';

  @override
  String get b1Intermediate => 'B1 - Középhaladó';

  @override
  String get b2UpperIntermediate => 'B2 - Felső középhaladó';

  @override
  String get c1Advanced => 'C1 - Haladó';

  @override
  String get c2Proficient => 'C2 - Felsőfokú';

  @override
  String get pasteTextHere => 'Illessze be ide a szöveget...';

  @override
  String get extractWords => 'Szavak kinyerése';

  @override
  String get extractExpressions => 'Kifejezések kinyerése';

  @override
  String get maxItems => 'Max új elem';

  @override
  String get maxItemsHint => 'Hagyja üresen korlát nélkül';

  @override
  String get generateExamples => 'Példák generálása';

  @override
  String get categoryName => 'Kategória neve';

  @override
  String get categoryNameHint => 'Név az importált elemek kategóriájához';

  @override
  String get analyzeText => 'Szöveg elemzése';

  @override
  String get configureAnalysis => 'Kinyerendő Elemek Típusai';

  @override
  String get openaiModel => 'AI Modell';

  @override
  String get openaiModelDescription => 'ChatGPT modell kiválasztása';

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
      'Gyors és költséghatékony; általános használatra';

  @override
  String get modelGpt35Turbo16kDesc =>
      'Mint a GPT-3.5, de 16K token kontextusablakkal';

  @override
  String get modelGpt4Desc => 'Magasabb pontosság/érvelés; lassabb és drágább';

  @override
  String get modelGpt4TurboDesc =>
      'Gyorsabb, olcsóbb, magas pontosság; jobb kontextus';

  @override
  String get analyzing => 'Elemzés folyamatban...';

  @override
  String get languageDetected => 'Észlelt nyelv';

  @override
  String get itemsFound => 'Talált elemek';

  @override
  String get selectItemsToImport => 'Válassza ki az importálandó elemeket';

  @override
  String get selectAll => 'Összes kijelölése';

  @override
  String get deselectAll => 'Összes kijelölés törlése';

  @override
  String get importSelected => 'Kijelöltek importálása';

  @override
  String get importing => 'Importálás...';

  @override
  String get itemsImported => 'Elemek sikeresen importálva';

  @override
  String get noItemsSelected => 'Nincs elem kijelölve';

  @override
  String get textCannotBeEmpty => 'A szöveg nem lehet üres';

  @override
  String get selectAtLeastOneType =>
      'Válasszon ki legalább egy típust (szavak vagy kifejezések)';

  @override
  String get languageNotMatching =>
      'Az észlelt nyelv nem egyezik a csomag egyik nyelvével sem';

  @override
  String get openaiKeyRequired =>
      'OpenAI API kulcs szükséges ehhez a funkcióhoz';

  @override
  String analyzingProgress(Object current, Object total) {
    return 'Elemzés: $current / $total';
  }

  @override
  String translatingProgress(Object current, Object total) {
    return 'Fordítás: $current / $total';
  }

  @override
  String get duplicate => 'Duplikátum';

  @override
  String importProgress(Object current, Object total) {
    return '$current / $total importálása';
  }

  @override
  String get detectingLanguage => 'Nyelv felismerése...';

  @override
  String get extractingItems => 'Elemek kinyerése...';

  @override
  String get checkingDuplicates => 'Duplikátumok ellenőrzése...';

  @override
  String get translating => 'Fordítás...';

  @override
  String get generatingExamples => 'Példák generálása...';

  @override
  String get errorAnalyzingText => 'Hiba a szöveg elemzése során';

  @override
  String get errorImportingItems => 'Hiba az elemek importálása során';

  @override
  String get warning => 'Figyelmeztetés';

  @override
  String get textIsVeryLarge => 'A szöveg nagyon hosszú';

  @override
  String get words => 'szó';

  @override
  String get continueAnalysis =>
      'Az elemzés hosszabb időt vehet igénybe és részletekben lesz feldolgozva. Folytatja';

  @override
  String get continueLabel => 'Folytatás';

  @override
  String get exportBeforeDeleteMessage =>
      'Szeretnéd exportálni ezt a csomagot a törlés előtt? Ez minden adatot menteni fog egy ZIP fájlba.';

  @override
  String get deleteWithoutExport => 'Törlés Exportálás Nélkül';

  @override
  String get exportAndDelete => 'Exportálás és Törlés';

  @override
  String get exportingPackage => 'Csomag exportálása...';

  @override
  String packageExportedToPath(Object path) {
    return 'Csomag exportálva ide: $path';
  }

  @override
  String errorLoadingItems(Object error) {
    return 'Hiba az elemek betöltésekor: $error';
  }

  @override
  String badgeEarnedWithName(Object badgeName) {
    return 'Medál megszerzve: $badgeName!';
  }

  @override
  String badgeLostWithName(Object badgeName) {
    return 'Medál elveszítve: $badgeName';
  }

  @override
  String get trainingSessionProgress => 'Gyakorlási Statisztika';

  @override
  String get total => 'Összesen';

  @override
  String lastNValue(Object value) {
    return 'N = $value';
  }

  @override
  String errorLoadingSettings(Object error) {
    return 'Hiba a beállítások betöltésekor: $error';
  }

  @override
  String get selectPackage => 'Csomag Kiválasztása';

  @override
  String get noPackagesAvailable => 'Nincsenek elérhető csomagok';

  @override
  String get possibleSolutions => 'Lehetséges Megoldások';

  @override
  String get technicalDetails => 'Technikai Részletek';

  @override
  String get close => 'Bezárás';

  @override
  String get checkApiKey => 'Ellenőrizd az OpenAI API kulcsot';

  @override
  String get ensureValidOpenAIKey =>
      'Győződj meg róla, hogy az API kulcs érvényes és aktív';

  @override
  String get verifyKeyInSettings => 'Ellenőrizd a kulcsot a Beállításokban';

  @override
  String get rateLimitExceeded => 'API használati korlát túllépve';

  @override
  String get waitAndRetry => 'Várj néhány percet és próbáld újra';

  @override
  String get checkAccountQuota => 'Ellenőrizd az OpenAI fiók kvótáját';

  @override
  String get invalidRequest => 'Érvénytelen kérés formátum';

  @override
  String get tryReducingTextLength =>
      'Próbáld meg csökkenteni a szöveg hosszát';

  @override
  String get checkTextFormat => 'Ellenőrizd, hogy a szöveg formátuma helyes-e';

  @override
  String get checkInternetConnection => 'Ellenőrizd az internet kapcsolatot';

  @override
  String get retryInMoment => 'Próbáld újra egy pillanat múlva';

  @override
  String get checkFirewall => 'Ellenőrizd a tűzfal beállításokat';

  @override
  String get textMayBeTooShort => 'A szöveg túl rövid lehet';

  @override
  String get tryDifferentKnowledgeLevel => 'Próbálj ki egy másik tudásszintet';

  @override
  String get ensureTextInCorrectLanguage =>
      'Győződj meg róla, hogy a szöveg a megfelelő nyelven van';

  @override
  String get requestTimedOut => 'A kérés időtúllépés miatt megszakadt';

  @override
  String get textMayBeTooLong => 'A szöveg túl hosszú lehet';

  @override
  String get tryAgainOrReduceSize =>
      'Próbáld újra vagy csökkentsd a szöveg méretét';

  @override
  String get unexpectedError => 'Váratlan hiba történt';

  @override
  String get checkErrorDetails => 'Nézd meg a hiba részleteit alább';

  @override
  String get tryAgainLater => 'Próbáld újra később';

  @override
  String get translationServiceFailed =>
      'A fordítási szolgáltatás hibát jelzett';

  @override
  String get checkApiKeys => 'Ellenőrizd az API kulcsokat (DeepL, OpenAI)';

  @override
  String get retryImport => 'Próbáld újra az importálást';

  @override
  String get exampleGenerationFailed => 'A példamondatok generálása sikertelen';

  @override
  String get itemsStillImported =>
      'Az elemek ettől függetlenül importálva lettek';

  @override
  String get canAddExamplesManually =>
      'Később manuálisan is hozzáadhatsz példákat';

  @override
  String get databaseError => 'Adatbázis hiba történt';

  @override
  String get checkStorageSpace => 'Ellenőrizd a rendelkezésre álló tárhelyet';

  @override
  String get restartApp => 'Próbáld újraindítani az alkalmazást';

  @override
  String get groupLabel => 'Csoport:';

  @override
  String get amendGroups => 'Módosítás';

  @override
  String get exportItemsJson => 'Elemek exportálása (JSON)';

  @override
  String get exportItemsJsonTooltip => 'Összes elem exportálása JSON fájlba';

  @override
  String get noCategoriesInPackage =>
      'Nem található kategória ebben a csomagban';

  @override
  String get noItemsToExport => 'Nincs exportálható elem';

  @override
  String itemsExportedSuccessfully(int count, String path) {
    return 'Sikeresen exportálva $count elem ide:\n$path';
  }

  @override
  String get errorExportingItems => 'Hiba az elemek exportálása során';

  @override
  String get languageMismatch => 'Nyelvi eltérés';

  @override
  String get languageMismatchDescription =>
      'A JSON fájlban található nyelvek nem egyeznek a csomag nyelveivel:';

  @override
  String packageLanguages(String lang1, String lang2) {
    return 'Csomag: $lang1 → $lang2';
  }

  @override
  String jsonFileLanguages(String lang1, String lang2) {
    return 'JSON fájl: $lang1 → $lang2';
  }

  @override
  String get continueImportQuestion =>
      'Szeretnéd mindenképpen folytatni az importálást?';

  @override
  String get continueImport => 'Importálás folytatása';

  @override
  String get pleaseSelectPackageGroup => 'Kérjük válasszon csomag csoportot';

  @override
  String get customIconLabel => 'Egyéni';

  @override
  String get defaultIconLabel => 'Alapértelmezett';

  @override
  String get icon2Label => 'Nyitott könyv';

  @override
  String get icon3Label => 'Színes könyv';

  @override
  String get icon4Label => 'Párbeszéd';

  @override
  String get icon5Label => 'Diploma';

  @override
  String get icon6Label => 'Agy';

  @override
  String get icon7Label => 'Könyvhalom';

  @override
  String get icon8Label => 'Szókártya';

  @override
  String get icon9Label => 'Földgömb';

  @override
  String get icon10Label => 'Ceruza';

  @override
  String get icon11Label => 'Trófea';

  @override
  String get icon12Label => 'Keresés';

  @override
  String get customIconFile => 'Egyéni ikon';

  @override
  String get importedIconFile => 'Importált ikon';

  @override
  String get unableToReadImageFile =>
      'Nem sikerült beolvasni a képfájlt. Kérjük válasszon érvényes képet.';

  @override
  String iconDimensionsTooLarge(int width, int height) {
    return 'Az ikon mérete túl nagy (${width}x$height). Maximum megengedett: 512x512 pixel.';
  }

  @override
  String get iconFileTooLarge => 'Az ikon fájl túl nagy. Maximum méret: 1MB.';

  @override
  String failedToUploadIcon(String error) {
    return 'Nem sikerült feltölteni az ikont: $error';
  }

  @override
  String get pleaseSelectValidLanguage =>
      'Kérjük válasszon érvényes nyelvet a listából';

  @override
  String get status => 'Állapot';

  @override
  String get addExample => 'Példa hozzáadása';

  @override
  String get noExamplesYet =>
      'Még nincsenek példák. Kattintson a + gombra hozzáadáshoz.';

  @override
  String get speakText => 'Szöveg felolvasása';

  @override
  String get removeCategory => 'Kategória eltávolítása';

  @override
  String removeCategoryConfirm(String categoryName) {
    return 'Eltávolítja a(z) \"$categoryName\" kategóriát erről az elemről?';
  }

  @override
  String get remove => 'Eltávolítás';

  @override
  String get extractFullItems => 'Teljes elemek kinyerése';

  @override
  String get pasteFromClipboard => 'Beillesztés vágólapról';

  @override
  String get noItemsFoundOrAllDuplicates =>
      'Nem található elem a szövegben, vagy minden elem már létezik a csomagban';

  @override
  String get aboutLanguageRally => 'A Language Rally-ról';

  @override
  String get welcomeTitle => '🚀 Üdvözöljük a Language Rally-ban';

  @override
  String get welcomeSubtitle =>
      'Élvezze a szintenként a több mint 4000 szó, 4000 kifejezés és ugyanennyi példamondat által nyújtotta fantasztikus tudást!\n\nFejlessze nyelvi készségeit — okosan és játékosan.';

  @override
  String get welcomeIntro =>
      'Tanulja meg hatékonyan a szókincset és kifejezéseket azáltal, hogy azt gyakorolja, ami valóban fontos önnek. Nincsenek unalmas listák. Nincs pazarolt idő.';

  @override
  String get sectionPlayYourGame => '🎮 Tanuljon játszva';

  @override
  String get sectionPlayYourGameDesc =>
      'Hozzon létre saját szókészlet-csomagokat. Csak azokat a szavakat és kifejezéseket gyakorolja, amelyeket valóban el akar sajátítani. Már ismeri? Megjelölésre kerül és átugorja!';

  @override
  String get sectionAITeammate => '🤖 AI mint csapattárs';

  @override
  String get sectionAITeammateDesc =>
      'Illesszen be bármilyen szöveget és hagyja, hogy a mesterséges intelligencia:\n• Kivonatolja a hasznos szókincset\n• Válasszon olyan kifejezéseket, amelyek megfelelnek az ön szintjének\n• Másodpercek alatt építsen gyakorlásra kész nyelvi csomagokat';

  @override
  String get sectionTrainSmart => '🔁 Okos gyakorlás';

  @override
  String get sectionTrainSmartDesc =>
      'A szeméylre szabott ismétlési rendszerünk pontosan akkor mutatja meg az elemeket Önnek, amikor a memória hatékony építéséhez azokra Önnek a leginkább szüksége van. Maximális haladás. Minimális erőfeszítés.';

  @override
  String get sectionRealExamples => '🌍 Valós példák. Kiváló fordítások.';

  @override
  String get sectionRealExamplesDesc =>
      'Szerezzen valós használati példákat. Fordítson prémium minőségben a DeepL-lel. Gyakorolja a kiejtést és legyen magabiztos.';

  @override
  String get sectionTeachersWelcome => '👩‍🏫 Tanárok örömmel fogadtatnak';

  @override
  String get sectionTeachersWelcomeDesc =>
      'Csomag létrehozása → Exportálás → A tételek bemásolása vagy az AI-val való kinyerése, fordítása, példák keresése → Feltöltés/Küldés → Kész. A tanulók importálják és azonnal elkezdhetik a gyakorlást.';

  @override
  String get sectionUnlockAI =>
      '🔑 Engedje szabadjára a Mesterséges intelligencia teljes erejét';

  @override
  String get sectionUnlockAIDesc =>
      'Kiváló minőségű fordításhoz és AI funkciókhoz egyszerűen:\n\n1. Hozza létre DeepL API kulcsát\n   https://www.deepl.com/pro-api\n2. Hozza létre OpenAI API kulcsát\n   https://platform.openai.com/api-keys\n3. Illessze be mindkét kulcsot a Beállításokba\n\nEgy apró befektetés erőteljes professzionális szintű nyelvi eszközöket nyit meg az Ön számára. Miért hanyá ki?\n(Fizetős API hozzáférés használatát javasoljuk a legjobb eredményekhez.)';

  @override
  String get readyToStart => 'Készen áll, hogy elindítsa a rally-t? 🏁';

  @override
  String get welcomeDescription =>
      'A Language Rally az ön átfogó nyelvtanuló társa. Hozzon létre egyéni szókészlet-csomagokat, rendszerezze az elemeket kategóriák szerint, és tanuljon intelligens időközönkénti ismétlési rendszerrel.';

  @override
  String get browseStore => 'Áruház böngészése';

  @override
  String get featureInteractiveTraining => 'Interaktív gyakorlás';

  @override
  String get featureInteractiveTrainingDesc =>
      'Gyakoroljon adaptív tanulási algoritmusokkal';

  @override
  String get featureSmartOrganization => 'Intelligens rendszerezés';

  @override
  String get featureSmartOrganizationDesc =>
      'Kategorizálja és szűrje szókincsét';

  @override
  String get featureTrackProgress => 'Haladás követése';

  @override
  String get featureTrackProgressDesc =>
      'Kövesse nyomon tanulását részletes statisztikákkal';

  @override
  String get featureImportExport => 'Importálás és exportálás';

  @override
  String get featureImportExportDesc =>
      'Ossza meg csomagjait és szinkronizáljon eszközök között';

  @override
  String get startAppTour => 'Alkalmazás bemutatása';

  @override
  String get quickStartGuide => 'Gyors útmutató';

  @override
  String get tourStep1Title => 'Csomag létrehozása vagy importálása';

  @override
  String get tourStep1Desc =>
      'Kezdje egy új nyelvi csomag létrehozásával vagy egy meglévő importálásával fájlból.';

  @override
  String get tourStep2Title => 'Szókészlet elemek hozzáadása';

  @override
  String get tourStep2Desc =>
      'Böngésszen a csomagok között és adjon hozzá szavakat, kifejezéseket példákkal és kategóriákkal.';

  @override
  String get tourStep3Title => 'Gyakorlás konfigurálása';

  @override
  String get tourStep3Desc =>
      'Válassza ki a gyakorlandó elemeket, állítsa be a nehézségi szinteket és szabja testre a tanulási élményt.';

  @override
  String get tourStep4Title => 'Tanulás kezdése';

  @override
  String get tourStep4Desc =>
      'Kezdje el a gyakorlási munkamenetet és jelölje meg az elemeket ismertnek vagy ismeretlennek a haladás nyomon követéséhez.';

  @override
  String get tourStep5Title => 'Statisztikák áttekintése';

  @override
  String get tourStep5Desc =>
      'Ellenőrizze tanulási haladását részletes statisztikákkal és a megszerzett medálokkal.';

  @override
  String get gotIt => 'Értem!';

  @override
  String get appTourTitle => 'Üdvözöljük a Language Rally-ban';

  @override
  String get appTourSubtitle =>
      'Az ön okos, játékos és teljesen személyre szabott nyelvtanuló társa.';

  @override
  String get tourPage1Title =>
      'Tanulja és gyakorolja, amit akar és amire szüksége van';

  @override
  String get tourPage1Desc =>
      'Adaptív tanulási rendszerünk biztosítja, hogy az elemeket a tökéletes pillanatban ismételje át — maximalizálva a megjegyzést és minimalizálva az erőfeszítést.\n\nTanuljon a beépített automatizálás segítségével.\nNe pazarolja az időt olyan szavakra, amelyeket már ismer.\n\nGyakorolja csak azokat a szavakat és kifejezéseket, amelyek érdeklik. Hozzon létre és gyakoroljon saját elemeket — teljesen személyre szabva céljaihoz és szintjéhez.';

  @override
  String get tourPage2Title => 'Hozzon létre saját nyelvi csomagot';

  @override
  String get tourPage2Desc =>
      'Építsen személyre szabott szókészlet-gyűjteményeket, amelyek megfelelnek érdeklődésének és tanulási céljainak.\n\nRendszerezze a szavakat és kifejezéseket témák, nehézség vagy kontextus szerint.\n\nTeljes kontroll afelett, hogy mit tanul és mikor.';

  @override
  String get tourPage3Title => 'AI-vezérelt elemek létrehozása';

  @override
  String get tourPage3Desc =>
      'Építse fel saját tanulási csomagjait egy szempillantás alatt:\n\n• Illesszen be bármilyen szöveget, és hagyja, hogy az AI automatikusan kivonja a releváns szókincset\n• Azonosítson olyan szavakat és kifejezéseket, amelyek tökéletesen megfelelnek az ön szintjének\n• Hagyja, hogy az AI elvégezze a fordítást\n• Hagyja, hogy az AI valós idejű példákat keressen\n• Hozzon létre gyorsan gyakorlásra kész csomagokat';

  @override
  String get tourPage4Title => 'AI-vezérelt valós példák és prémium fordítás';

  @override
  String get tourPage4Desc =>
      '• Azonnal kereshet hiteles használati példákat\n• Fordítson szavakat, kifejezéseket és teljes mondatokat kiváló minőségű DeepL integrációval\n• Kapjon pontos, kontextustudatos eredményeket';

  @override
  String get tourPage5Title => 'Intelligens csomag szervezés';

  @override
  String get tourPage5Desc =>
      '• Rendszerezze a szókincset egyedi kategóriákba\n• Szűrjön és összpontosítson konkrét témákra\n• Importáljon és exportáljon csomagokat eszközök között\n• Osszon meg csomagokat könnyen másokkal';

  @override
  String get tourPage6Title => 'Kiejtés gyakorlása';

  @override
  String get tourPage6Desc =>
      'Tesztelje és javítsa kiejtését interaktív gyakorló eszközökkel.\n\nÉpítsen önbizalmat a beszédben — nemcsak az olvasásban.';

  @override
  String get tourPage7Title => 'Tanárok számára';

  @override
  String get tourPage7Desc =>
      'Hozzon létre azonnal használható szókészlet-csomagokat diákjai számára néhány kattintással.\n\nExportálja őket, küldje el az osztályának — és az importálás után azonnal gyakorlásra készen állnak minden diák eszközén.\n\nEgyszerű. Gyors. Hatékony.';

  @override
  String get tourPage8Title => 'Oldja fel a kiváló minőségű AI támogatást';

  @override
  String get tourPage8Desc =>
      'Prémium fordításokhoz és fejlett AI funkciókhoz egyszerűen:\n 1. Hozza létre saját DeepL API kulcsát\n 2. Hozza létre saját OpenAI API kulcsát\n 3. Illessze be mindkét kulcsot a Beállítások részbe\nEz csak egy kis költségvetést igényel (néhány dollár), de hozzáférést biztosít erőteljes, professzionális szintű nyelvi eszközökhöz.\nMegjegyzés: A legjobb eredményekhez fizetős API hozzáférés használatát javasoljuk.\n\n🔑 DeepL API kulcs: https://www.deepl.com/pro-api\n🔑 OpenAI API kulcs: https://platform.openai.com/api-keys';

  @override
  String get previousPage => 'Előző';

  @override
  String get nextPage => 'Következő';

  @override
  String get endTour => 'Túra befejezése';

  @override
  String pageIndicator(int current, int total) {
    return '$current. oldal a $total-ból';
  }

  @override
  String get practicePronunciation => 'Kiejtés gyakorlása';

  @override
  String get pronunciationPractice => 'Kiejtés gyakorlás';

  @override
  String get startPractice => 'Gyakorlás indítása';

  @override
  String get listenToPronunciation => 'Kiejtés meghallgatása';

  @override
  String get tapToRecord => 'Érintse meg a felvételhez';

  @override
  String get recording => 'Felvétel...';

  @override
  String get recorded => 'Felvéve';

  @override
  String get speakNow =>
      'Beszéljen most - beszéljen tisztán és közel a mikrofonhoz';

  @override
  String get noSpeechDetected => 'Nem észlelhető beszéd. Kérem próbálja újra.';

  @override
  String get noTextRecognized =>
      'Nem sikerült szöveget felismerni a felvételben. Kérem ellenőrizze, hogy a mikrofon megfelelően működik, és próbálja újra.';

  @override
  String get processingAudio => 'Hang feldolgozása AI-val...';

  @override
  String get playbackRecording => 'Felvétel visszajátszása';

  @override
  String get playbackRecordingSubtitle =>
      'Hallgassa meg a felvételét, miközben az AI feldolgozza';

  @override
  String get recordingTooShort =>
      'A felvétel túl rövid. Kérem beszéljen legalább 1 másodpercig.';

  @override
  String get microphonePermissionRequired =>
      'A kiejtés gyakorlásához mikrofon engedély szükséges';

  @override
  String get speechRecognitionNotSupported =>
      'A beszédfelismerés nem támogatott ezen a platformon. Kérem használja a mobil alkalmazást (Android/iOS) a kiejtés gyakorlásához.';

  @override
  String get speechRecognitionUnavailable =>
      'A beszédfelismerés nem elérhető ezen az eszközön.';

  @override
  String get pronunciationAccuracy => 'Kiejtés\npontossága';

  @override
  String get excellent => 'Kiváló!';

  @override
  String get good => 'Jó';

  @override
  String get fair => 'Megfelelő';

  @override
  String get needsImprovement => 'Fejlesztendő';

  @override
  String get tryAgain => 'Próbálja újra';

  @override
  String get nextItem => 'Következő elem';

  @override
  String get endPractice => 'Gyakorlás befejezése';

  @override
  String get practiced => 'Gyakorolt';

  @override
  String get windowsAudioTestPageTitle => 'Windows Hang Teszt (RTAudio)';

  @override
  String get configureWindowsAudio =>
      'Hangbemenet tesztelése és beállítása Windows-on';

  @override
  String get configureWindowsAudioDescription =>
      'Hangfelvétel, lejátszás és átírás tesztelése a natív Windows RTAudio meghajtóval';

  @override
  String get audioTestTitle => 'Windows hangfelvétel teszt';

  @override
  String get audioTestSubtitle => 'RTAudio — Natív Windows hangfelvétel';

  @override
  String get audioInputDevice => 'Bemeneti hangeszköz';

  @override
  String get selectMicrophone => 'Mikrofon kiválasztása';

  @override
  String get refreshDevices => 'Eszközök frissítése';

  @override
  String get noAudioDevicesFound => 'Nem találhatók hangbemeneti eszközök';

  @override
  String get loadingAudioDevices => 'Hangeszközök betöltése...';

  @override
  String get recordingSettings => 'Felvételi beállítások';

  @override
  String get stereoRecording => 'Sztereó felvétel';

  @override
  String get stereoChannels => '2 csatorna (sztereó)';

  @override
  String get monoChannel => '1 csatorna (mono)';

  @override
  String get sampleRateLabel => 'Mintavételi frekvencia';

  @override
  String get nativeRateBadge => 'natív';

  @override
  String get microphoneGainLabel => 'Mikrofon erősítés';

  @override
  String get gainHint =>
      '1x = nincs erősítés  •  3x ≈ +9,5 dB  •  10x ≈ +20 dB';

  @override
  String get tapToStartRec => 'Koppintson a felvétel indításához';

  @override
  String get tapToStopRec => 'Koppintson a felvétel leállításához';

  @override
  String get recordingCompleteLabel => 'Felvétel kész';

  @override
  String get tapMicToStop => 'Koppintson a mikrofonra a leállításhoz';

  @override
  String get playRecordingLabel => 'Felvétel lejátszása';

  @override
  String get stopPlaybackLabel => 'Leállítás';

  @override
  String get whisperSectionTitle => 'OpenAI Whisper átírás';

  @override
  String get whisperWavNote =>
      'A WAV (16 bites PCM) formátumot a Whisper natívan támogatja — nincs szükség konverzióra.';

  @override
  String get sendToWhisperLabel => 'Küldés Whispernek';

  @override
  String get transcribingLabel => 'Átírás folyamatban...';

  @override
  String get transcriptionResultLabel => 'Átírás eredménye';

  @override
  String get transcriptionFailedLabel => 'Átírás sikertelen';

  @override
  String get debugInformationLabel => 'Információk';

  @override
  String get debugConsoleHint => 'A részletes naplók a konzolon találhatók';

  @override
  String get debugDevicesFound => 'Talált eszközök';

  @override
  String get debugSelectedDevice => 'Kiválasztott eszköz';

  @override
  String get debugDeviceRateNative => 'Eszköz frekvencia (natív)';

  @override
  String get debugRequestedRate => 'Kért frekvencia';

  @override
  String get debugActualRate => 'Ténylegesen használt';

  @override
  String get debugActualRateForced => '⚠ felülírva';

  @override
  String get debugActualRateOk => '✓';

  @override
  String get debugRecordingMode => 'Felvételi mód';

  @override
  String get debugLastRecording => 'Utolsó felvétel';

  @override
  String get debugFileSize => 'Fájlméret';

  @override
  String get debugStereo => 'Sztereó';

  @override
  String get debugMono => 'Mono';

  @override
  String get recordingSavedSnack => 'Felvétel mentve';

  @override
  String get recordingTooShortSnack =>
      'A felvétel túl rövid. Kérem, vegyen fel legalább 1 másodpercet.';

  @override
  String get recordingSmallSnack =>
      'A felvétel fájl nagyon kicsi. Lehetséges, hogy a felvétel nem sikerült.';

  @override
  String get noAudioDataSnack => 'Nem lett hangadat rögzítve';

  @override
  String get noDeviceSelectedSnack => 'Kérjük, válasszon hangeszközt';

  @override
  String get failedToInitRtAudio => 'Az RTAudio inicializálása nem sikerült';

  @override
  String get envelopeScoreLabel => 'Burkoló';

  @override
  String get rhythmScoreLabel => 'Ritmus';

  @override
  String get textScoreLabel => 'Szöveg';

  @override
  String get help => 'Súgó';

  @override
  String get trainingHelpTitle => 'Tippek a hatékony tanuláshoz';

  @override
  String get trainingHelpText =>
      'Ahhoz, hogy a gyakorlás a lehető leghatékonyabb legyen, kövesd az alábbi lépéseket:\n1. Kattints a \'Számlálók törlése\' gombra, hogy a csomag minden eleme ismertként legyen megjelölve.\n2. Állítsd az \'Elemek köre\' opciót „Összes elem\' értékre.\n3. Állítsd az \'Elemek sorrendje\' opciót „Véletlenszerű\' értékre.\n4. Válaszd ki az anyanyelvedet a \'Megjelenítési nyelv\' beállításnál.\n5. Indítsd el a tanulást, és folytasd addig, amíg körülbelül 20–30 számodra ismeretlen elemet nem érsz el.\n6. Térj vissza a tanulási beállításokhoz, és állítsd az \'Elemek köre\' opciót \'Csak ismeretlen elemek\' értékre.\n7. Indítsd újra a tanulást, és folytasd addig, amíg az összes korábban ismeretlen elemet meg nem tanulod.';

  @override
  String get onboardingWelcomeTitle => 'Üdvözöllek a Language Rally-ban!';

  @override
  String get onboardingSetupSubtitle => 'Állítsuk be az alkalmazást számodra.';

  @override
  String get onboardingSelectUiLanguage => 'Felhasználói felület nyelve';

  @override
  String get onboardingUiLanguageNote =>
      'Ezt később a Beállítások → Megjelenítés nyelve menüpontban módosíthatod.';

  @override
  String get onboardingNext => 'Tovább';

  @override
  String get onboardingBack => 'Vissza';

  @override
  String get onboardingSelectPackagesTitle => 'Válassz nyelvi csomagokat';

  @override
  String get onboardingSelectPackagesSubtitle =>
      'Válaszd ki, melyik nyelvi csomagot importálod. Később a főmenüből bármikor importálhatsz többet is (Csomagok megtekintése).';

  @override
  String get onboardingAnalyzingPackages => 'Elérhető csomagok elemzése…';

  @override
  String get onboardingImportSelected => 'Kijelöltek importálása';

  @override
  String get onboardingSkipImport => 'Kihagyás';

  @override
  String get onboardingSelectAll => 'Összes kijelölése';

  @override
  String get onboardingDeselectAll => 'Kijelölés törlése';

  @override
  String onboardingNPackages(int count) {
    return '$count csomag';
  }

  @override
  String get onboardingGetStarted => 'Kezdjük!';

  @override
  String get onboardingImportCompleteTitle => 'Importálás kész!';

  @override
  String get importBuiltInPkg => 'Alapcsomag importálása';

  @override
  String get importBuiltInPkgTooltip => 'Beépített nyelvi csomagok importálása';

  @override
  String get globalSearch => 'Globális keresés';

  @override
  String get globalSearchTitle => 'Keresés az összes csomagban';

  @override
  String get globalSearchSelectLanguage => 'Válassz nyelvkódot';

  @override
  String get globalSearchEnterWord => 'Keresendő szó(k)';

  @override
  String get globalSearchEnterWordHint =>
      'pl. \"der\", \"tanul\" — részleges egyezést is megtalál';

  @override
  String get globalSearchButton => 'Keresés';

  @override
  String get globalSearchResults => 'Eredmények';

  @override
  String globalSearchNoResults(String query) {
    return 'Nincs találat a(z) \"$query\" keresésre';
  }

  @override
  String globalSearchResultsCount(int count) {
    return '$count találat';
  }

  @override
  String get globalSearchSearching => 'Keresés…';

  @override
  String get globalSearchSelectLanguageFirst => 'Kérlek, válassz nyelvkódot';

  @override
  String get globalSearchEnterTermFirst =>
      'Kérlek, adj meg keresési kifejezést';

  @override
  String get globalSearchMatchInExamples => 'Példamondatban található';

  @override
  String get globalSearchViewItem => 'Megtekintés';

  @override
  String get globalSearchGoToPackage => 'Ugrás a csomaghoz';

  @override
  String get globalSearchLoadingPackages => 'Csomagok betöltése…';

  @override
  String get globalSearchNoPackages => 'Még nincs telepített csomag';

  @override
  String get globalSearchCancelSearch => 'Keresés leállítása';

  @override
  String globalSearchProgressOf(int current, int total) {
    return '$current. csomag a(z) $total-ból…';
  }

  @override
  String globalSearchCancelledMessage(int count) {
    return 'Keresés megszakítva — $count találat eddig';
  }
}
