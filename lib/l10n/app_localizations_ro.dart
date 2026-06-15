// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Romanian Moldavian Moldovan (`ro`).
class AppLocalizationsRo extends AppLocalizations {
  AppLocalizationsRo([String locale = 'ro']) : super(locale);

  @override
  String get helloWorld => 'Salut Lume!';

  @override
  String get welcome => 'Bun venit la Language Rally';

  @override
  String get appTitle => 'Mitingul limbilor';

  @override
  String get createPackage => 'Creați pachet';

  @override
  String get editPackage => 'Editați pachetul';

  @override
  String get packageDetails => 'Detalii pachet';

  @override
  String get packageName => 'Numele pachetului';

  @override
  String get packageNameHint =>
      'de exemplu, noțiuni de bază în spaniolă, noțiuni de bază în germană';

  @override
  String get languageCode1 => 'Codul limbii sursă';

  @override
  String get languageName1 => 'Nume limba sursă';

  @override
  String get languageCode2 => 'Codul limbii țintă';

  @override
  String get languageName2 => 'Numele limbii țintă';

  @override
  String get description => 'Descriere';

  @override
  String get descriptionHint => 'Scurtă descriere a acestui pachet lingvistic';

  @override
  String get authorName => 'Numele autorului';

  @override
  String get authorEmail => 'E-mailul autorului';

  @override
  String get authorWebpage => 'Pagina web a autorului';

  @override
  String get version => 'Versiune';

  @override
  String get items => 'articole';

  @override
  String get packageIcon => 'Pictograma pachet';

  @override
  String get packageGroup => 'Grup de pachete';

  @override
  String get selectIcon => 'Selectați pictograma';

  @override
  String get defaultIcon => 'Pictogramă implicită';

  @override
  String get customIcon => 'Pictogramă personalizată';

  @override
  String get upload => 'Pictograma de încărcare';

  @override
  String get uploadCustomIcon =>
      'Încărcați pictograma personalizată (maximum 512x512, 1MB)';

  @override
  String get customIconUploaded =>
      'Pictograma personalizată a fost încărcată cu succes';

  @override
  String get save => 'Salva';

  @override
  String get edit => 'Edita';

  @override
  String get cancel => 'Anula';

  @override
  String get delete => 'Şterge';

  @override
  String get confirmDelete => 'Sigur doriți să ștergeți acest pachet?';

  @override
  String get packageSaved => 'Pachetul a fost salvat cu succes';

  @override
  String get packageDeleted => 'Pachetul a fost șters cu succes';

  @override
  String get errorSavingPackage => 'Eroare la salvarea pachetului';

  @override
  String get errorDeletingPackage => 'Eroare la ștergerea pachetului';

  @override
  String get fieldRequired => 'Acest câmp este obligatoriu';

  @override
  String get invalidEmail => 'Adresă de e-mail nevalidă';

  @override
  String get readOnlyPackage =>
      'Acest pachet este doar pentru citire și nu poate fi editat';

  @override
  String get purchasedPackage => 'Pachetele achiziționate nu pot fi editate';

  @override
  String get badges => 'Ecusoane';

  @override
  String get noBadges => 'Nu s-a câștigat încă insigne';

  @override
  String get selectLanguageCode => 'Selectați codul de limbă';

  @override
  String get typeToSearchLanguages => 'Tastați pentru a căuta limbi...';

  @override
  String get search => 'Căutare...';

  @override
  String get clearCounters => 'Șterge contoarele';

  @override
  String get confirmClearCounters =>
      'Sigur doriți să ștergeți toate contoarele de antrenament pentru acest pachet? Acest lucru va reseta contoarele „nu știu” și statisticile de antrenament.';

  @override
  String get clear => 'Clar';

  @override
  String get countersCleared => 'Contoarele au fost șterse cu succes';

  @override
  String get errorClearingCounters => 'Eroare la ștergerea contoarelor';

  @override
  String get deleteAll => 'Șterge pachetul';

  @override
  String get confirmDeleteAllData =>
      'Sigur doriți să ștergeți acest pachet cu TOATE datele sale? Aceasta va șterge definitiv toate categoriile, articolele și statisticile de antrenament. Această acțiune nu poate fi anulată!';

  @override
  String get allDataDeleted =>
      'Pachetul și toate datele au fost șterse cu succes';

  @override
  String get exportPackage => 'Pachetul de export';

  @override
  String get selectExportLocation => 'Selectați Export Location';

  @override
  String get packageExported => 'Pachetul a fost exportat cu succes';

  @override
  String get errorExportingPackage => 'Eroare la exportarea pachetului';

  @override
  String get importItems => 'Importați articole (JSON)';

  @override
  String get importItemsDialogTitle => 'Importați articole (JSON)';

  @override
  String get importItemsFromLocalJson => 'Importați din fișierul JSON local';

  @override
  String get enterItemsUrl => 'Adresa URL JSON articole (https://…)';

  @override
  String get downloadingItems => 'Se descarcă articole...';

  @override
  String get selectImportFile => 'Selectați Import File';

  @override
  String get importFormat => 'Format de import';

  @override
  String get importFormatDescription =>
      'Importați elemente dintr-un fișier text. Fiecare rând trebuie să conțină un articol în următorul format:';

  @override
  String get importResults => 'Importați rezultate';

  @override
  String get successfullyImported => 'Importat cu succes';

  @override
  String get failedToImport => 'Nu s-a putut importa';

  @override
  String get error => 'Eroare';

  @override
  String get ok => 'Bine';

  @override
  String get importPackage => 'Import pachet';

  @override
  String get importPackageTooltip =>
      'Importați pachetul din fișierul ZIP sau URL';

  @override
  String get importPackageDialogTitle => 'Import pachet de limbă';

  @override
  String get importFromLocalFile => 'Importă din fișierul local';

  @override
  String get importFromUrl => 'Import de la URL';

  @override
  String get enterPackageUrl => 'Adresa URL a pachetului (https://…)';

  @override
  String get downloadingPackage => 'Se descarcă pachetul...';

  @override
  String get downloadFailed =>
      'Descărcarea a eșuat. Vă rugăm să verificați adresa URL și conexiunea dvs. la internet.';

  @override
  String get invalidUrl =>
      'Vă rugăm să introduceți o adresă URL validă http:// sau https://.';

  @override
  String get orLabel => 'sau';

  @override
  String get selectPackageZipFile => 'Selectați pachetul fișier ZIP';

  @override
  String get couldNotAccessFile => 'Nu s-a putut accesa fișierul selectat.';

  @override
  String get importingPackage => 'Se importă pachetul...';

  @override
  String get packageImportedSuccessfully =>
      'Pachetul a fost importat cu succes!';

  @override
  String packageImportedWithItems(Object count) {
    return 'Pachetul a fost importat cu succes! ($count articole)';
  }

  @override
  String packageImportedWithGroup(Object count, Object groupName) {
    return 'Pachetul a fost importat în grupul „$groupName”! ($count articole)';
  }

  @override
  String get importError => 'Eroare de import';

  @override
  String get failedToImportPackage => 'Nu s-a putut importa pachetul';

  @override
  String get packageAlreadyExists => 'Pachetul există deja';

  @override
  String packageExistsMessage(Object groupName) {
    return 'Un pachet cu aceeași pereche de limbi, descriere, informații despre autor și versiune există deja în grupul „$groupName”. Oricum, doriți să-l importați ca pachet nou?';
  }

  @override
  String get importAsNew => 'Import oricum';

  @override
  String get zipFileNotFound => 'Fișierul ZIP nu a fost găsit';

  @override
  String get invalidPackageZip =>
      'ZIP pachet nevalid: lipsește package_data.json';

  @override
  String get invalidPackageFormat => 'Format de fișier pachet nevalid';

  @override
  String get languagePackages => 'Pachete lingvistice';

  @override
  String get loadingPackages => 'Se încarcă pachetele...';

  @override
  String get tapAndHoldToReorder => 'Atingeți lung pentru a reordona cardurile';

  @override
  String get tapAndHoldToReorderList =>
      'Atingeți și mențineți apăsat ≡ pentru a reordona • Atingeți ⋮ pentru a comuta vizualizarea compactă';

  @override
  String get noPackagesYet => 'Nu există încă pachete';

  @override
  String get createFirstPackage => 'Creați pachetul pentru prima limbă';

  @override
  String get versionLabel => 'Versiune';

  @override
  String get purchased => 'Achizitionat';

  @override
  String get compactView => 'compact';

  @override
  String get expand => 'Extinde';

  @override
  String get allCategories => 'Toate categoriile';

  @override
  String get categoriesInPackage => 'Categoriile din acest pachet';

  @override
  String get categories => 'Categorii';

  @override
  String get testInterFonts => 'Testați fonturile Inter';

  @override
  String get viewPackages => 'Vezi pachete';

  @override
  String get simplifiedPackageView => 'Lista pachetelor';

  @override
  String get createNewPackage => 'Creați un pachet nou';

  @override
  String get generateTestData => 'Generați date de testare';

  @override
  String get designSystemShowcase => 'Vitrina sistemului de proiectare';

  @override
  String get badgeEarned => 'Insigna câștigată!';

  @override
  String get achievement => 'Realizare';

  @override
  String get awesome => 'Minunat!';

  @override
  String get importFormatNotes => 'Note:';

  @override
  String get importFormatLine1 => '• Fiecare linie reprezintă un articol';

  @override
  String get importFormatLine2 => '• Câmpurile sunt separate prin |';

  @override
  String get importFormatLine3 => '• Categoriile sunt separate prin ;';

  @override
  String get importFormatLine4 => '• Ultimul | este opțională';

  @override
  String get importFormatLine5 => '• Liniile goale sunt ignorate';

  @override
  String get importFormatLine6 => '• Duplicatele sunt ignorate';

  @override
  String get importFormatNewDescription =>
      'Importați elemente dintr-un fișier text. Fiecare rând trebuie să conțină un articol cu ​​câmpuri separate prin ---';

  @override
  String get importFormatNewLine1 => '• Delimitator principal: ---';

  @override
  String get importFormatNewLine2 =>
      '• L1=<text> - Limba 1 text principal (obligatoriu dacă lipsește L2)';

  @override
  String get importFormatNewLine3 =>
      '• L2=<text> - textul principal în limba 2 (obligatoriu dacă lipsește L1)';

  @override
  String get importFormatNewLine4 =>
      '• L1pre=<text> - Prefix de limbă 1 (opțional)';

  @override
  String get importFormatNewLine5 =>
      '• L1post=<text> - Limba 1 sufix (opțional)';

  @override
  String get importFormatNewLine6 =>
      '• L2pre=<text> - Prefix de limbă 2 (opțional)';

  @override
  String get importFormatNewLine7 =>
      '• L2post=<text> - Limba 2 sufix (opțional)';

  @override
  String get importFormatNewLine8 =>
      '• EX=<L1 text>:::<L2 text> - Exemplu (opțional, poate fi multiplu)';

  @override
  String get importFormatNewLine9 =>
      '• CAT=<cat1>:::<cat2>:::<cat3> - Categorii (opțional)';

  @override
  String get importFormatNewLine10 =>
      '• Cel puțin unul dintre L1= sau L2= trebuie să fie prezent';

  @override
  String get importFormatNewLine11 => '• Liniile goale sunt ignorate';

  @override
  String get importFormatNewLine12 => '• Duplicatele sunt ignorate';

  @override
  String get invalidImportLine => 'Linie nevalidă';

  @override
  String get missingRequiredFields => 'Lipsește „L1=” vagy „L2=”';

  @override
  String get unknownField => 'Prefix de câmp necunoscut';

  @override
  String andMore(Object count) {
    return '... și încă $count';
  }

  @override
  String get browseItems => 'Răsfoiți articole';

  @override
  String get itemDetails => 'Detalii';

  @override
  String get filterItems => 'Filtrați articole';

  @override
  String searchLanguage1(Object language) {
    return 'Căutați în $language';
  }

  @override
  String searchLanguage2(Object language) {
    return 'Căutați în $language';
  }

  @override
  String get caseSensitive => 'Caz sensibil';

  @override
  String get knownStatus => 'Stare cunoscută';

  @override
  String get filterStatusAll => 'toate';

  @override
  String get filterStatusKnown => 'cunoscut';

  @override
  String get filterStatusUnknown => 'necunoscut';

  @override
  String get allItems => 'Toate articolele';

  @override
  String get itemsIKnew => 'Articole pe care le știam';

  @override
  String get itemsIDidNotKnow => 'Articole pe care nu le știam';

  @override
  String get known => 'Cunoscut';

  @override
  String get unknown => 'Necunoscut';

  @override
  String get important => 'Important';

  @override
  String get favourite => 'Favorit';

  @override
  String get badge => 'Insigna';

  @override
  String get position => 'Poziţie';

  @override
  String get stepsUntilLearned => 'Pași până la învățare';

  @override
  String get examples => 'Exemple';

  @override
  String get noExamples => 'Nu există exemple disponibile';

  @override
  String get pronounce => 'Pronunță';

  @override
  String get ttsError =>
      'Transformarea textului în vorbire nu este disponibilă';

  @override
  String get noItemsFound => 'Nu s-au găsit articole';

  @override
  String get noItemsInPackage => 'Nu există încă articole în acest pachet';

  @override
  String get addItem => 'Adăugați articol';

  @override
  String get emptyPackageHint =>
      'Adăugați articole manual sau utilizați AI pentru a importa articole rapid';

  @override
  String get noItemsToTrain =>
      'Nu există elemente disponibile pentru exersare cu setările curente';

  @override
  String get clearFilters => 'Clar';

  @override
  String itemCount(Object count) {
    return '$count articole';
  }

  @override
  String filteredItemCount(Object filtered, Object total) {
    return '$filtered din $total articole';
  }

  @override
  String get trainingRally => 'Raliu de antrenament';

  @override
  String get startTraining => 'Începeți antrenamentul';

  @override
  String get trainingComingSoon => 'Raliu de antrenament - În curând!';

  @override
  String get aiServiceNotConfigured =>
      'Serviciul AI nu este configurat. Vă rugăm să adăugați cheia dvs. API OpenAI.';

  @override
  String pleaseEnterTextInLanguageFirst(Object language) {
    return 'Introduceți mai întâi text în $language';
  }

  @override
  String translationCompletedSuccessfully(Object service) {
    return 'Traducerea a fost finalizată cu succes folosind $service!';
  }

  @override
  String get translationFailed => 'Traducerea a eșuat';

  @override
  String addedExamplesSuccessfully(Object count) {
    return 'Au fost adăugate $count exemple(e) cu succes!';
  }

  @override
  String get failedToGenerateExamples => 'Nu s-au generat exemple';

  @override
  String get selectExamplesToAdd => 'Selectați Exemple de adăugat';

  @override
  String get selectWhichExamples =>
      'Selectați ce exemple doriți să adăugați la acest articol:';

  @override
  String get addSelected => 'Adăugați selectat';

  @override
  String get pleaseSelectAtLeastOne =>
      'Vă rugăm să selectați cel puțin un exemplu';

  @override
  String get addNewItem => 'Adăugați un articol nou';

  @override
  String get editItem => 'Editați elementul';

  @override
  String get deleteItem => 'Ștergeți elementul';

  @override
  String get confirmDeleteItem => 'Sigur doriți să ștergeți acest articol?';

  @override
  String get thisActionCannotBeUndone => 'Această acțiune nu poate fi anulată.';

  @override
  String get itemDeleted => 'Element șters';

  @override
  String get errorDeletingItem => 'Eroare la ștergerea articolului';

  @override
  String get errorSavingItem => 'Eroare la salvarea articolului';

  @override
  String get itemSaved => 'Elementul a fost actualizat cu succes';

  @override
  String get itemCreated => 'Element creat cu succes';

  @override
  String get preTextOptional => 'Pretext (opțional)';

  @override
  String get mainText => 'Textul principal';

  @override
  String get postTextOptional => 'Post-text (opțional)';

  @override
  String get forExampleToForVerbs => 'de exemplu, „la” pentru verbe';

  @override
  String get additionalContext => 'Context suplimentar';

  @override
  String get translate => 'Traduce';

  @override
  String translateFromTo(Object from, Object to) {
    return 'Traduceți $from → $to';
  }

  @override
  String get aiExampleGeneration => 'Generare de exemple AI';

  @override
  String get aiExampleSearch => 'Exemplu de căutare AI';

  @override
  String searchExamplesOnInternet(Object text) {
    return 'Căutați exemple de propoziții pe internet folosind AI pentru „$text”';
  }

  @override
  String generateExampleSentences(Object language) {
    return 'Generați exemple de propoziții pe baza textului principal din $language';
  }

  @override
  String get voiceInput => 'Intrare vocală';

  @override
  String get settings => 'Setări';

  @override
  String get uiLanguage => 'Limba UI';

  @override
  String get uiLanguageDescription => 'Limbajul interfeței aplicației';

  @override
  String get uiLanguageHelper =>
      'Selectați limba pentru meniuri, butoane și etichete';

  @override
  String get userLanguage => 'Limba utilizatorului';

  @override
  String get userLanguageDescription =>
      'Limba dumneavoastră maternă preferată pentru crearea de noi pachete lingvistice';

  @override
  String get apiKeys => 'Chei API';

  @override
  String get deeplApiKey => 'Cheia API DeepL';

  @override
  String get deeplApiKeyDescription =>
      'Pentru o calitate premium a traducerii atunci când editați articole în limbă. Consultați https://www.deepl.com/pro-api';

  @override
  String get openaiApiKey => 'Cheia API OpenAI';

  @override
  String get openaiApiKeyDescription =>
      'De exemplu, generarea cu AI la editarea elementelor de limbă. Consultați https://platform.openai.com/api-keys';

  @override
  String get enterApiKey => 'Introduceți cheia API';

  @override
  String get optional => 'opțional';

  @override
  String get required => 'necesar';

  @override
  String get settingsSaved => 'Setările au fost salvate cu succes';

  @override
  String get errorSavingSettings => 'Eroare la salvarea setărilor';

  @override
  String get usingGoogleTranslate => 'Folosind Google Translate gratuit';

  @override
  String get usingDeepL => 'Utilizarea DeepL (premium)';

  @override
  String get noTranslationReceivedFromGoogle =>
      'Nu a primit nicio traducere de la Google';

  @override
  String get googleTranslationFailed => 'Traducerea Google a eșuat';

  @override
  String get googleTranslationError => 'Eroare de traducere Google';

  @override
  String get noTranslationReceivedFromDeepL =>
      'Nu a primit nicio traducere de la DeepL';

  @override
  String get invalidDeepLApiKey => 'Cheie API DeepL nevalidă';

  @override
  String get deeplTranslationQuotaExceeded =>
      'Cota de traducere DeepL a fost depășită';

  @override
  String get deeplTranslationFailed => 'Traducerea DeepL a eșuat';

  @override
  String get deeplTranslationError => 'Eroare de traducere DeepL';

  @override
  String get invalidApiKeyConfigureOpenAI =>
      'Cheie API nevalidă. Vă rugăm să configurați cheia API OpenAI.';

  @override
  String get apiRateLimitExceeded =>
      'Limita ratei API a fost depășită. Vă rugăm să încercați din nou mai târziu.';

  @override
  String get aiRequestFailed => 'Solicitarea AI a eșuat';

  @override
  String get failedToParseAiResponse =>
      'Nu s-a putut analiza răspunsul AI. Vă rugăm să încercați din nou.';

  @override
  String get aiGenerationError => 'Eroare de generare a AI';

  @override
  String get voiceInputPlaceholder =>
      'Intrarea vocală va fi implementată folosind pachetul speech_to_text';

  @override
  String get improveQualityWithApiKeys =>
      '💡 Sfat: calitatea traducerilor și a căutărilor de exemplu poate fi îmbunătățită semnificativ prin adăugarea cheilor API DeepL și OpenAI în setările aplicației.';

  @override
  String get noApiKeyFallbackMessage =>
      'Fără chei API, sunt oferite traduceri de bază și exemple limitate. Pentru cele mai bune rezultate, configurați cheile API în Setări.';

  @override
  String get listeningForSpeech => 'Ascult... Vorbește acum';

  @override
  String get speechRecognitionNotAvailable =>
      'Recunoașterea vorbirii nu este disponibilă pe acest dispozitiv';

  @override
  String get speechRecognitionPermissionDenied =>
      'Permisiunea de recunoaștere a vorbirii a fost refuzată';

  @override
  String get speechRecognitionError => 'Eroare de recunoaștere a vorbirii';

  @override
  String get tapToSpeak => 'Atinge microfon pentru a vorbi';

  @override
  String get tapToStop => 'Atingeți pentru a opri înregistrarea';

  @override
  String get speechNotRecognized =>
      'Niciun discurs nu a fost recunoscut. Vă rugăm să încercați din nou.';

  @override
  String get usingWhisperApiSlower =>
      'Utilizarea cloud AI pentru recunoașterea vorbirii (poate fi mai lentă)';

  @override
  String languageNotSupportedAddApiKey(String languageCode) {
    return 'Limba $languageCode nu este acceptată nativ. Adăugați cheia API OpenAI în Setări pentru recunoașterea vorbirii bazată pe inteligență artificială.';
  }

  @override
  String get recordingTapToStop =>
      'Înregistrare... Atingeți din nou pentru a opri';

  @override
  String get speakClearlyKeepRecording =>
      'Vorbește clar. Înregistrați cel puțin 1 secundă.';

  @override
  String get pleaseRecordLonger =>
      'Vă rugăm să vorbiți timp de cel puțin 1 secundă și atingeți oprire.';

  @override
  String get errorStartingRecording => 'Eroare la începerea înregistrării';

  @override
  String get noAudioRecorded => 'Nu a fost înregistrat niciun sunet';

  @override
  String get errorTranscribing => 'Eroare la transcrierea sunetului';

  @override
  String get trainingSettings => 'Setări de antrenament';

  @override
  String get trainingPresetTitle => 'Configurare rapidă';

  @override
  String get trainingPresetHint =>
      'Alegeți o presetare și setările de mai jos vor fi configurate automat.';

  @override
  String get trainingPresetComboLabel => 'Presetat';

  @override
  String get trainingPresetAllExamplesForeignLanguage =>
      'Toate exemplele, limbi străine';

  @override
  String get trainingPresetAllExamplesRandomLanguage =>
      'Toate exemplele, limbaj aleatoriu';

  @override
  String get trainingPresetFavouriteItemsForeignLanguage =>
      'Articole preferate, limbă străină';

  @override
  String get trainingPresetFavouriteItemsRandomLanguage =>
      'Elemente preferate, limbă aleatorie';

  @override
  String get trainingPresetImportantItemsForeignLanguage =>
      'Elemente importante, limbă străină';

  @override
  String get trainingPresetImportantItemsRandomLanguage =>
      'Elemente importante, limbaj aleatoriu';

  @override
  String get trainingPresetRandomItemsRandomLanguage =>
      'Elemente aleatorii, limbaj aleatoriu';

  @override
  String get trainingPresetUnknownItemsForeignLanguage =>
      'Elemente necunoscute, limbă străină';

  @override
  String get trainingPresetUnknownItemsRandomLanguage =>
      'Elemente necunoscute, limbaj aleatoriu';

  @override
  String trainingPresetAppliedTapStart(String actionLabel) {
    return 'Presetarea aplicată. Atinge „$actionLabel” pentru a începe.';
  }

  @override
  String get trainingPresetSelectPackageFirst =>
      'Vă rugăm să selectați mai întâi un pachet.';

  @override
  String get itemScope => 'Domeniul articolului';

  @override
  String get lastNItems => 'Ultimele N articole';

  @override
  String get onlyUnknown => 'Doar articole necunoscute';

  @override
  String get onlyImportant => 'Doar articole importante';

  @override
  String get onlyFavourite => 'Doar articolele preferate';

  @override
  String get numberOfItems => 'Numărul de articole';

  @override
  String get itemOrder => 'Comanda articol';

  @override
  String get randomOrder => 'Ordine aleatorie';

  @override
  String get sequentialOrder => 'Ordine secvenţială';

  @override
  String get itemType => 'Tip de articol';

  @override
  String get dictionaryItems => 'Dicţionar items';

  @override
  String get examplesType => 'Exemple';

  @override
  String get displayLanguage => 'Limba de afișare';

  @override
  String get motherTongue => 'Limbă maternă';

  @override
  String get targetLanguage => 'Limba țintă';

  @override
  String get randomLanguage => 'Aleatoriu';

  @override
  String get categoryFilter => 'Filtru de categorie';

  @override
  String get categoryFilterHint =>
      'Selectați categoriile de inclus (gol = toate categoriile)';

  @override
  String get noCategories => 'Nu există categorii disponibile';

  @override
  String get dontKnowThreshold => 'Nu știu pragul';

  @override
  String get dontKnowThresholdHint =>
      'De câte ori un articol trebuie să fie marcat ca „nu știu” înainte de manipulare specială';

  @override
  String get startTrainingRally => 'Începeți mitingul de antrenament';

  @override
  String get clearTrainingSettings => 'Ștergeți setările';

  @override
  String get confirmClearTrainingSettings =>
      'Sigur doriți să resetați toate setările de antrenament la valorile implicite?';

  @override
  String get trainingSettingsCleared =>
      'Setările de antrenament au fost șterse';

  @override
  String get startingTraining => 'Începe antrenamentul...';

  @override
  String get noMoreItemsToDisplay =>
      'Nu există elemente de afișat pe baza setărilor dvs. de filtru.';

  @override
  String get noItems => 'Fără articole';

  @override
  String get trainingComplete => 'Antrenament finalizat';

  @override
  String get allItemsCompleted =>
      'Felicitări! Ați completat toate elementele din această sesiune de instruire.';

  @override
  String get closeTraining => 'Antrenament aproape';

  @override
  String get confirmCloseTraining =>
      'Sigur vrei să închizi antrenamentul? Progresul dvs. a fost salvat.';

  @override
  String get question => 'Întrebare';

  @override
  String get answer => 'Răspuns';

  @override
  String get iKnow => 'Știu';

  @override
  String get iDontKnow => 'Nu știu';

  @override
  String get previousItem => 'Articolul precedent';

  @override
  String get iDidNotKnowEither => 'La urma urmei nu știam';

  @override
  String get exportBeforeDelete => 'Exportați înainte de ștergere?';

  @override
  String get aiTextAnalysis => 'Extrage articole dintr-un text/listă cu AI';

  @override
  String get aiTextAnalysisImport =>
      'Extrageți articole dintr-un text sau dintr-o listă cu Instrumentul de analiză a textului AI';

  @override
  String get knowledgeLevel => 'Nivelul de cunoștințe';

  @override
  String get a1Beginner => 'A1 - Începător';

  @override
  String get a2Elementary => 'A2 - Elementar';

  @override
  String get b1Intermediate => 'B1 - Intermediar';

  @override
  String get b2UpperIntermediate => 'B2 - Intermediar superior';

  @override
  String get c1Advanced => 'C1 - Avansat';

  @override
  String get c2Proficient => 'C2 - Competente';

  @override
  String get pasteTextHere => 'Lipiți aici textul...';

  @override
  String get extractWords => 'Extrage cuvinte';

  @override
  String get extractExpressions => 'Extrage expresii';

  @override
  String get maxItems => 'Numărul maxim de articole noi';

  @override
  String get maxItemsHint => 'Lăsați gol fără limită';

  @override
  String get generateExamples => 'Generați exemple';

  @override
  String get categoryName => 'Nume categorie';

  @override
  String get categoryNameHint => 'Numele categoriei de articole importate';

  @override
  String get analyzeText => 'Analizați textul';

  @override
  String get configureAnalysis => 'Configurați elementele de extras';

  @override
  String get openaiModel => 'Model AI';

  @override
  String get openaiModelDescription => 'Selectați modelul ChatGPT';

  @override
  String get modelGpt55 => 'GPT-5.5';

  @override
  String get modelGpt55Pro => 'GPT-5.5 Pro';

  @override
  String get modelGpt54 => 'GPT-5.4';

  @override
  String get modelGpt54Pro => 'GPT-5.4 Pro';

  @override
  String get modelGpt54Mini => 'GPT-5.4 Mini';

  @override
  String get modelGpt5Mini => 'GPT-5 Mini';

  @override
  String get modelGpt41 => 'GPT-4.1';

  @override
  String get modelGpt55Desc =>
      'Cel mai nou echilibru emblematic de calitate și viteză pentru uz general';

  @override
  String get modelGpt55ProDesc =>
      'Varianta GPT-5.5 de ultimă generație pentru cel mai puternic raționament și calitate';

  @override
  String get modelGpt54Desc =>
      'Model puternic de utilizare generală GPT-5 generație';

  @override
  String get modelGpt54ProDesc =>
      'Varianta GPT-5.4 cu capacitate mai mare pentru sarcini solicitante';

  @override
  String get modelGpt54MiniDesc =>
      'Varianta GPT-5.4 mai mică și mai rapidă pentru sarcini de zi cu zi cu costuri reduse';

  @override
  String get modelGpt5MiniDesc =>
      'Model compact de familie GPT-5 optimizat pentru viteză și cost';

  @override
  String get modelGpt41Desc =>
      'Opțiune fiabilă GPT-4.1 pentru compatibilitate și calitate solidă';

  @override
  String get modelGpt4o => 'GPT-4o';

  @override
  String get modelGpt35Turbo => 'GPT-3.5 Turbo (moștenire, buget)';

  @override
  String get modelGpt35Turbo16k => 'GPT-3.5 Turbo 16K';

  @override
  String get modelGpt4 => 'GPT-4';

  @override
  String get modelGpt4Turbo => 'GPT-4 Turbo (moștenire)';

  @override
  String get modelGpt4oDesc =>
      'Cea mai bună alegere de uz general; rapid, multimodal și de calitate puternică';

  @override
  String get modelGpt35TurboDesc =>
      'Opțiune moștenită cu costuri reduse; util pentru sarcini mai simple și utilizare sensibilă la costuri';

  @override
  String get modelGpt35Turbo16kDesc =>
      'La fel ca GPT-3.5, dar fereastra de context de 16K token';

  @override
  String get modelGpt4Desc =>
      'Calitate ridicată a raționamentului; de obicei mai lent și mai scump';

  @override
  String get modelGpt4TurboDesc =>
      'Opțiune de familie GPT-4 moștenită; încă util atunci când doriți o alternativă mai veche și mai ieftină';

  @override
  String get analyzing => 'Se analizează...';

  @override
  String get languageDetected => 'Limbă detectată';

  @override
  String get itemsFound => 'Articole găsite';

  @override
  String get selectItemsToImport => 'Selectați Elemente de importat';

  @override
  String get selectAll => 'Selectați Toate';

  @override
  String get deselectAll => 'Deselectați Toate';

  @override
  String get importSelected => 'Import Selectate';

  @override
  String get importing => 'Se importă...';

  @override
  String get itemsImported => 'Articole importate cu succes';

  @override
  String get noItemsSelected => 'Niciun element selectat';

  @override
  String get textCannotBeEmpty => 'Textul nu poate fi gol';

  @override
  String get selectAtLeastOneType =>
      'Selectați cel puțin un tip (cuvinte sau expresii)';

  @override
  String get languageNotMatching =>
      'Limba detectată nu se potrivește cu nicio limbă din pachet';

  @override
  String get openaiKeyRequired =>
      'Cheia API OpenAI este necesară pentru această funcție';

  @override
  String analyzingProgress(Object current, Object total) {
    return 'Se analizează: $current / $total';
  }

  @override
  String translatingProgress(Object current, Object total) {
    return 'Traducere: $current / $total';
  }

  @override
  String get duplicate => 'Duplicat';

  @override
  String importProgress(Object current, Object total) {
    return 'Se importă $current din $total';
  }

  @override
  String get detectingLanguage => 'Se detectează limba...';

  @override
  String get extractingItems => 'Se extrag elemente...';

  @override
  String get checkingDuplicates => 'Se verifică dubluri...';

  @override
  String get translating => 'Se traduce...';

  @override
  String get generatingExamples => 'Generarea de exemple...';

  @override
  String get errorAnalyzingText => 'Eroare la analizarea textului';

  @override
  String get errorImportingItems => 'Eroare la importarea articolelor';

  @override
  String get warning => 'Avertizare';

  @override
  String get textIsVeryLarge => 'Textul este foarte mare';

  @override
  String get words => 'cuvinte';

  @override
  String get continueAnalysis =>
      'Procesarea poate dura mai mult și va fi analizată în bucăți. Doriți să continuați';

  @override
  String get continueLabel => 'Continua';

  @override
  String get exportBeforeDeleteMessage =>
      'Doriți să exportați acest pachet înainte de a-l șterge? Acest lucru va salva toate datele într-un fișier ZIP.';

  @override
  String get deleteWithoutExport => 'Ștergeți fără export';

  @override
  String get exportAndDelete => 'Exportați și ștergeți';

  @override
  String get exportingPackage => 'Se exportă pachetul...';

  @override
  String packageExportedToPath(Object path) {
    return 'Pachetul exportat în: $path';
  }

  @override
  String errorLoadingItems(Object error) {
    return 'Eroare la încărcarea articolelor: $error';
  }

  @override
  String badgeEarnedWithName(Object badgeName) {
    return 'Insigna obținută: $badgeName!';
  }

  @override
  String badgeLostWithName(Object badgeName) {
    return 'Insigna pierdută: $badgeName';
  }

  @override
  String get trainingSessionProgress => 'Statisticile sesiunii de antrenament';

  @override
  String get total => 'Total';

  @override
  String lastNValue(Object value) {
    return 'N = $value';
  }

  @override
  String errorLoadingSettings(Object error) {
    return 'Eroare la încărcarea setărilor: $error';
  }

  @override
  String get selectPackage => 'Selectați Pachet';

  @override
  String get noPackagesAvailable => 'Nu există pachete disponibile';

  @override
  String get possibleSolutions => 'Soluții posibile';

  @override
  String get technicalDetails => 'Detalii tehnice';

  @override
  String get close => 'Aproape';

  @override
  String get checkApiKey => 'Verificați cheia API OpenAI';

  @override
  String get ensureValidOpenAIKey =>
      'Asigurați-vă că cheia API este validă și activă';

  @override
  String get verifyKeyInSettings => 'Verificați cheia în Setări';

  @override
  String get rateLimitExceeded => 'Limita ratei API a fost depășită';

  @override
  String get waitAndRetry => 'Așteptați câteva minute și încercați din nou';

  @override
  String get checkAccountQuota => 'Verificați cota de cont OpenAI';

  @override
  String get invalidRequest => 'Format de solicitare nevalid';

  @override
  String get tryReducingTextLength => 'Încercați să reduceți lungimea textului';

  @override
  String get checkTextFormat => 'Verificați dacă formatul textului este corect';

  @override
  String get checkInternetConnection => 'Verificați-vă conexiunea la internet';

  @override
  String get retryInMoment => 'Reîncercați peste un moment';

  @override
  String get checkFirewall => 'Verificați setările paravanului de protecție';

  @override
  String get textMayBeTooShort => 'Textul poate fi prea scurt';

  @override
  String get tryDifferentKnowledgeLevel =>
      'Încercați un alt nivel de cunoștințe';

  @override
  String get ensureTextInCorrectLanguage =>
      'Asigurați-vă că textul este în limba corectă';

  @override
  String get requestTimedOut => 'Solicitarea a expirat';

  @override
  String get textMayBeTooLong => 'Textul poate fi prea lung';

  @override
  String get tryAgainOrReduceSize =>
      'Încercați din nou sau reduceți dimensiunea textului';

  @override
  String get unexpectedError => 'A apărut o eroare neașteptată';

  @override
  String get checkErrorDetails => 'Verificați detaliile erorii de mai jos';

  @override
  String get tryAgainLater => 'Încercați din nou mai târziu';

  @override
  String get translationServiceFailed => 'Serviciul de traducere a eșuat';

  @override
  String get checkApiKeys => 'Verificați cheile API (DeepL, OpenAI)';

  @override
  String get retryImport => 'Reîncercați importul';

  @override
  String get exampleGenerationFailed => 'Generarea exemplelor a eșuat';

  @override
  String get itemsStillImported => 'Articolele erau încă importate';

  @override
  String get canAddExamplesManually =>
      'Puteți adăuga exemple manual mai târziu';

  @override
  String get databaseError => 'A apărut o eroare la baza de date';

  @override
  String get checkStorageSpace => 'Verificați spațiul de stocare disponibil';

  @override
  String get restartApp => 'Încercați să reporniți aplicația';

  @override
  String get groupLabel => 'Grup:';

  @override
  String get amendGroups => 'Amenda';

  @override
  String get exportItemsJson => 'Exportați articole (JSON)';

  @override
  String get exportItemsJsonTooltip =>
      'Exportați toate elementele ca fișier JSON';

  @override
  String get noCategoriesInPackage => 'Nu s-au găsit categorii în acest pachet';

  @override
  String get noItemsToExport => 'Nu s-au găsit articole de exportat';

  @override
  String itemsExportedSuccessfully(int count, String path) {
    return 'S-au exportat cu succes $count articole către:\n$path';
  }

  @override
  String get errorExportingItems => 'Eroare la exportul articolelor';

  @override
  String get languageMismatch => 'Nepotrivirea limbii';

  @override
  String get languageMismatchDescription =>
      'Limbile din fișierul JSON nu se potrivesc cu limbile pachetului:';

  @override
  String packageLanguages(String lang1, String lang2) {
    return 'Pachet: $lang1 → $lang2';
  }

  @override
  String jsonFileLanguages(String lang1, String lang2) {
    return 'Fișier JSON: $lang1 → $lang2';
  }

  @override
  String get continueImportQuestion =>
      'Doriți să continuați oricum importarea?';

  @override
  String get continueImport => 'Continuați importul';

  @override
  String get pleaseSelectPackageGroup =>
      'Vă rugăm să selectați un grup de pachete';

  @override
  String get customIconLabel => 'Personalizat';

  @override
  String get defaultIconLabel => 'Implicit';

  @override
  String get icon2Label => 'Carte deschisă';

  @override
  String get icon3Label => 'Carte colorată';

  @override
  String get icon4Label => 'Conversaţie';

  @override
  String get icon5Label => 'Absolvire';

  @override
  String get icon6Label => 'Creier';

  @override
  String get icon7Label => 'Stiva de cărți';

  @override
  String get icon8Label => 'Flashcard';

  @override
  String get icon9Label => 'Glob';

  @override
  String get icon10Label => 'Creion';

  @override
  String get icon11Label => 'Trofeu';

  @override
  String get icon12Label => 'Căutare';

  @override
  String get customIconFile => 'Pictogramă personalizată';

  @override
  String get importedIconFile => 'Pictogramă importată';

  @override
  String get unableToReadImageFile =>
      'Nu se poate citi fișierul imagine. Vă rugăm să selectați o imagine validă.';

  @override
  String iconDimensionsTooLarge(int width, int height) {
    return 'Dimensiunile pictogramei sunt prea mari (${width}x$height). Maximul permis este de 512x512 pixeli.';
  }

  @override
  String get iconFileTooLarge =>
      'Fișierul pictogramă este prea mare. Dimensiunea maximă este de 1 MB.';

  @override
  String failedToUploadIcon(String error) {
    return 'Pictograma nu s-a încărcat: $error';
  }

  @override
  String get pleaseSelectValidLanguage =>
      'Vă rugăm să selectați o limbă validă din listă';

  @override
  String get status => 'Stare';

  @override
  String get addExample => 'Adăugați un exemplu';

  @override
  String get noExamplesYet =>
      'Încă nu există exemple. Faceți clic pe + pentru a adăuga.';

  @override
  String get speakText => 'Rostiți textul';

  @override
  String get removeCategory => 'Eliminați categoria';

  @override
  String removeCategoryConfirm(String categoryName) {
    return 'Eliminați categoria „$categoryName” din acest articol?';
  }

  @override
  String get remove => 'Elimina';

  @override
  String get extractFullItems => 'Extrage articole complete';

  @override
  String get pasteFromClipboard => 'Lipiți din clipboard';

  @override
  String get noItemsFoundOrAllDuplicates =>
      'Nu s-au găsit articole în text sau toate articolele există deja în pachet';

  @override
  String get aboutLanguageRally => 'Despre Language Rally';

  @override
  String get welcomeTitle => '🚀 Bun venit la Language Rally';

  @override
  String get welcomeSubtitle =>
      'Deblocați puterea incredibilă a învățării limbilor străine cu aproximativ 4.000 de cuvinte, 4.000 de expresii și la fel de multe exemple de propoziții - atent pregătite pentru fiecare nivel de competență! Utilizați AI pentru a importa elemente din propriile texte sau discutați cu AI pe orice subiect pentru a genera cuvintele, expresiile și exemplele exacte pe care doriți să le învățați.\nCrește-ți abilitățile lingvistice – într-un mod inteligent și jucăuș!';

  @override
  String get welcomeIntro =>
      'Învață vocabularul și expresiile în mod eficient exersând ceea ce îți pasă de fapt. Fără liste plictisitoare. Fără timp pierdut.';

  @override
  String get sectionPlayYourGame => '🎮 Joacă-ți propriul joc';

  @override
  String get sectionPlayYourGameDesc =>
      'Creează-ți propriile pachete de vocabular. Antrenează doar cuvintele și expresiile pe care vrei să le stăpânești. O știi deja? Va fi marcat și omis!';

  @override
  String get sectionAITeammate => '🤖 AI ca colegul tău de echipă';

  @override
  String get sectionAITeammateDesc =>
      'Lipiți orice text și lăsați AI:\n• Extrageți vocabular util\n• Alegeți expresii care se potrivesc cu nivelul dvs\n• Construiți pachete gata de antrenat în câteva secunde\n\nChat cu AI:\n• Lasă-l să sugereze cuvinte și expresii pentru subiectul tău\n• Faceți clic pentru a genera exemple și a le salva în PROPRIUL pachet';

  @override
  String get sectionTrainSmart => '🔁 Antrenează-te inteligent';

  @override
  String get sectionTrainSmartDesc =>
      'Sistemul nostru de repetiție reglat fin arată elementele exact atunci când creierul tău are nevoie de ele pentru a le memora eficient. Progres maxim. Efort minim.';

  @override
  String get sectionRealExamples => '🌍 Exemple reale. Traduceri grozave.';

  @override
  String get sectionRealExamplesDesc =>
      'Obțineți exemple de utilizare în lumea reală. Traduceți cu calitate premium prin DeepL. Exersați pronunția și sunetul încrezător.';

  @override
  String get sectionTeachersWelcome => '👩‍🏫 Profesori Bine ați venit';

  @override
  String get sectionTeachersWelcomeDesc =>
      'Creați un pachet → Copiați și lipiți elemente sau extrageți, traduceți, adăugați exemple cu AI → Export → Încărcare/Trimite → Terminat. Elevii dvs. îl importă și încep să exerseze instantaneu.';

  @override
  String get sectionUnlockAI => '🔑 Deblocați puterea AI completă';

  @override
  String get sectionUnlockAIDesc =>
      'Pentru traducere de înaltă calitate și funcții AI, pur și simplu:\n\n1. Creați-vă cheia API DeepL\n   https://www.deepl.com/pro-api\n2. Creați-vă cheia API OpenAI\n   https://platform.openai.com/api-keys\n3. Lipiți ambele taste în Setări\n\nO investiție mică deblochează instrumente lingvistice puternice, de calitate profesională. De ce l-ați rata?\n(Recomandăm utilizarea accesului API plătit pentru cele mai bune rezultate.)';

  @override
  String get readyToStart => 'Sunteți gata să vă începeți mitingul? 🏁';

  @override
  String get welcomeDescription =>
      'Language Rally este partenerul dumneavoastră cuprinzător de învățare a limbilor străine. Creați pachete de vocabular personalizate, organizați articolele pe categorii și antrenați-vă cu un sistem inteligent de repetiție distanțată.';

  @override
  String get browseStore => 'Răsfoiți magazinul';

  @override
  String get featureInteractiveTraining => 'Antrenament interactiv';

  @override
  String get featureInteractiveTrainingDesc =>
      'Exersați cu algoritmi de învățare adaptivă';

  @override
  String get featureSmartOrganization => 'Organizare inteligentă';

  @override
  String get featureSmartOrganizationDesc =>
      'Clasifică-ți și filtrează-ți vocabularul';

  @override
  String get featureTrackProgress => 'Urmăriți progresul';

  @override
  String get featureTrackProgressDesc =>
      'Monitorizați-vă învățarea cu statistici detaliate';

  @override
  String get featureImportExport => 'Import & Export';

  @override
  String get featureImportExportDesc =>
      'Partajați pachete și sincronizați pe dispozitive';

  @override
  String get startAppTour => 'Începeți Turul aplicației';

  @override
  String get quickStartGuide => 'Ghid de pornire rapidă';

  @override
  String get tourStep1Title => 'Creați sau importați pachete';

  @override
  String get tourStep1Desc =>
      'Începeți prin a crea un nou pachet de limbă sau importați unul existent dintr-un fișier.';

  @override
  String get tourStep2Title => 'Adăugați elemente de vocabular';

  @override
  String get tourStep2Desc =>
      'Răsfoiți pachetele dvs. și adăugați cuvinte, expresii sau expresii cu exemple și categorii.';

  @override
  String get tourStep3Title => 'Configurați Training';

  @override
  String get tourStep3Desc =>
      'Alegeți ce elemente să exersați, setați niveluri de dificultate și personalizați-vă experiența de învățare.';

  @override
  String get tourStep4Title => 'Începeți să învățați';

  @override
  String get tourStep4Desc =>
      'Începeți sesiunea de antrenament și marcați elementele ca cunoscute sau necunoscute pentru a vă urmări progresul.';

  @override
  String get tourStep5Title => 'Consultați statisticile';

  @override
  String get tourStep5Desc =>
      'Verificați-vă progresul de învățare cu statistici detaliate și insigne de realizare.';

  @override
  String get gotIt => 'Am înţeles!';

  @override
  String get appTourTitle => 'Bun venit la Language Rally';

  @override
  String get appTourSubtitle =>
      'Partenerul tău inteligent, jucăuș și complet personalizat pentru învățarea limbilor străine.';

  @override
  String get tourPage1Title =>
      'Învață și practică ceea ce vrei și ceea ce ai nevoie';

  @override
  String get tourPage1Desc =>
      'Sistemul nostru de învățare adaptiv vă asigură că revizuiți articolele la momentul perfect - maximizând reținerea și minimizând efortul.\n\nÎnvață cu ajutorul automatizării încorporate.\nNu mai pierde timpul cu cuvintele pe care le cunoști deja.\n\nExersează doar vocabularul și expresiile care te interesează. Creați și antrenați-vă propriile articole – complet adaptate obiectivelor și nivelului dvs.';

  @override
  String get tourPage2Title => 'Creați-vă propriul pachet de limbi';

  @override
  String get tourPage2Desc =>
      'Creați colecții de vocabular personalizate care se potrivesc cu interesele și obiectivele dvs. de învățare.\n\nOrganizați cuvintele și expresiile după subiect, dificultate sau context.\n\nControl complet asupra a ceea ce înveți și când.';

  @override
  String get tourPage3Title => 'Crearea de obiecte cu AI';

  @override
  String get tourPage3Desc =>
      'Construiește-ți propriile pachete de învățare într-o clipă:\n\n• Lipiți orice text și lăsați AI să extragă vocabularul relevant în mod automat\n• Identificați cuvinte și expresii perfect potrivite nivelului dvs\n• Lasă AI să facă traducerea pentru tine\n• Lăsați AI să caute exemple în timp real\n\nChat cu AI:\n• Lasă-l să sugereze cuvinte și expresii pentru subiectul tău\n• Faceți clic pentru a genera exemple și a le salva în PROPRIUL pachet\n• Creați rapid pachete pregătite pentru antrenament';

  @override
  String get tourPage4Title =>
      'Exemple din lumea reală bazate pe inteligență artificială și traducere premium';

  @override
  String get tourPage4Desc =>
      '• Căutați instantaneu exemple de utilizare autentice\n• Traduceți cuvinte, expresii și propoziții complete cu integrare DeepL de înaltă calitate\n• Obțineți rezultate precise, conștiente de context';

  @override
  String get tourPage5Title => 'Organizare inteligentă a pachetelor';

  @override
  String get tourPage5Desc =>
      '• Organizați vocabularul în categorii personalizate\n• Filtrați și concentrați-vă pe subiecte specifice\n• Importați și exportați pachete pe dispozitive\n• Partajați pachete cu ușurință cu alții';

  @override
  String get tourPage6Title => 'Antrenează-ți pronunția';

  @override
  String get tourPage6Desc =>
      'Testați și îmbunătățiți-vă pronunția cu instrumente interactive de practică.\n\nConstruiți încrederea în vorbire, nu doar în citire.';

  @override
  String get tourPage7Title => 'Pentru Profesori';

  @override
  String get tourPage7Desc =>
      'Creați pachete de vocabular gata de utilizat pentru studenții dvs. în doar câteva clicuri.\n\nExportați-le, trimiteți-le la clasa dvs. și, odată importate, sunt gata instantaneu pentru exersare pe dispozitivul fiecărui student.\n\nSimplu. Rapid. Eficient.';

  @override
  String get tourPage8Title => 'Deblocați suportul AI de înaltă calitate';

  @override
  String get tourPage8Desc =>
      'Pentru traduceri premium și funcții avansate AI, pur și simplu:\n 1. Creați-vă propria cheie API DeepL\n 2. Creați-vă propria cheie API OpenAI\n 3. Lipiți ambele taste în secțiunea Setări\n\nAcest lucru necesită doar un buget mic (câțiva dolari), dar vă oferă acces la instrumente lingvistice puternice, de calitate profesională.\nNotă: Vă recomandăm să utilizați accesul API plătit pentru cele mai bune rezultate. Costă doar câțiva dolari.\n\n🔑 Cheia API DeepL: https://www.deepl.com/pro-api\n\n🔑 Cheia API OpenAI: https://platform.openai.com/api-keys';

  @override
  String get previousPage => 'Anterior';

  @override
  String get nextPage => 'Următorul';

  @override
  String get endTour => 'Încheierea turului';

  @override
  String pageIndicator(int current, int total) {
    return 'Pagina $current din $total';
  }

  @override
  String get practicePronunciation => 'Practică pronunția';

  @override
  String get pronunciationPractice => 'Practică de pronunție';

  @override
  String get startPractice => 'Începeți antrenamentul';

  @override
  String get listenToPronunciation => 'Ascultă pronunția';

  @override
  String get tapToRecord => 'Atingeți pentru a înregistra';

  @override
  String get recording => 'Înregistrare...';

  @override
  String get recorded => 'Înregistrat';

  @override
  String get speakNow => 'Vorbește acum - vorbește clar și aproape de microfon';

  @override
  String get noSpeechDetected =>
      'Nu a fost detectată nicio vorbire. Vă rugăm să încercați din nou.';

  @override
  String get noTextRecognized =>
      'Nu a fost recunoscut niciun discurs în înregistrare. Asigurați-vă că microfonul funcționează și încercați din nou.';

  @override
  String get processingAudio => 'Se procesează audio cu AI...';

  @override
  String get playbackRecording => 'Redă înregistrarea mea';

  @override
  String get playbackRecordingSubtitle =>
      'Ascultă-ți înregistrarea în timp ce AI o procesează';

  @override
  String get recordingTooShort =>
      'Înregistrare prea scurtă. Vă rugăm să vorbiți cel puțin 1 secundă.';

  @override
  String get microphonePermissionRequired =>
      'Este necesară permisiunea microfonului pentru practicarea pronunției';

  @override
  String get speechRecognitionNotSupported =>
      'Recunoașterea vorbirii nu este acceptată pe această platformă. Vă rugăm să utilizați aplicația mobilă (Android/iOS) pentru practicarea pronunției.';

  @override
  String get speechRecognitionUnavailable =>
      'Recunoașterea vorbirii nu este disponibilă pe acest dispozitiv.';

  @override
  String get pronunciationAccuracy => 'Pronunţie\nPrecizie';

  @override
  String get excellent => 'Excelent!';

  @override
  String get good => 'Bun';

  @override
  String get fair => 'Corect';

  @override
  String get needsImprovement => 'Necesită îmbunătățire';

  @override
  String get tryAgain => 'Încearcă din nou';

  @override
  String get nextItem => 'Următorul articol';

  @override
  String get endPractice => 'Încheiați practica';

  @override
  String get practiced => 'Practicat';

  @override
  String get windowsAudioTestPageTitle => 'Test audio Windows (RTAudio)';

  @override
  String get configureWindowsAudio =>
      'Testați și configurați sunetul\nintrare pe Windows';

  @override
  String get configureWindowsAudioDescription =>
      'Înregistrați, redați și transcrieți audio folosind driverul Windows RTAudio nativ';

  @override
  String get audioTestTitle => 'Test de înregistrare audio Windows';

  @override
  String get audioTestSubtitle => 'RTAudio — Înregistrare audio nativă Windows';

  @override
  String get audioInputDevice => 'Dispozitiv de intrare audio';

  @override
  String get selectMicrophone => 'Selectați Microfon';

  @override
  String get refreshDevices => 'Actualizează dispozitivele';

  @override
  String get noAudioDevicesFound =>
      'Nu s-au găsit dispozitive de intrare audio';

  @override
  String get loadingAudioDevices => 'Se încarcă dispozitivele audio...';

  @override
  String get recordingSettings => 'Setări de înregistrare';

  @override
  String get stereoRecording => 'Înregistrare stereo';

  @override
  String get stereoChannels => '2 canale (stereo)';

  @override
  String get monoChannel => '1 canal (mono)';

  @override
  String get sampleRateLabel => 'Rata de eșantionare';

  @override
  String get nativeRateBadge => 'nativ';

  @override
  String get microphoneGainLabel => 'Câștig microfon';

  @override
  String get gainHint => '1x = fără amplificare • 3x ≈ +9,5 dB • 10x ≈ +20 dB';

  @override
  String get tapToStartRec => 'Atingeți pentru a începe înregistrarea';

  @override
  String get tapToStopRec => 'Atingeți pentru a opri înregistrarea';

  @override
  String get recordingCompleteLabel => 'Înregistrare finalizată';

  @override
  String get tapMicToStop => 'Atingeți microfonul pentru a opri';

  @override
  String get playRecordingLabel => 'Redați înregistrarea';

  @override
  String get stopPlaybackLabel => 'Stop';

  @override
  String get whisperSectionTitle => 'OpenAI Whisper Transcription';

  @override
  String get whisperWavNote =>
      'WAV (PCM pe 16 biți) este suportat nativ de Whisper - nu este necesară conversia.';

  @override
  String get sendToWhisperLabel => 'Trimite la Whisper';

  @override
  String get transcribingLabel => 'Se transcrie...';

  @override
  String get transcriptionResultLabel => 'Rezultatul transcripției';

  @override
  String get transcriptionFailedLabel => 'Transcrierea eșuată';

  @override
  String get debugInformationLabel => 'Informaţii';

  @override
  String get debugConsoleHint =>
      'Verificați consola pentru jurnalele detaliate';

  @override
  String get debugDevicesFound => 'Dispozitive găsite';

  @override
  String get debugSelectedDevice => 'Dispozitiv selectat';

  @override
  String get debugDeviceRateNative => 'Rata dispozitiv (nativ)';

  @override
  String get debugRequestedRate => 'Tarif solicitat';

  @override
  String get debugActualRate => 'Rata reală utilizată';

  @override
  String get debugActualRateForced => '⚠ forțat';

  @override
  String get debugActualRateOk => '✓';

  @override
  String get debugRecordingMode => 'Modul de înregistrare';

  @override
  String get debugLastRecording => 'Ultima înregistrare';

  @override
  String get debugFileSize => 'Dimensiunea fișierului';

  @override
  String get debugStereo => 'Stereo';

  @override
  String get debugMono => 'Mono';

  @override
  String get recordingSavedSnack => 'Înregistrare salvată';

  @override
  String get recordingTooShortSnack =>
      'Înregistrarea este prea scurtă. Vă rugăm să înregistrați cel puțin 1 secundă.';

  @override
  String get recordingSmallSnack =>
      'Fișierul de înregistrare este foarte mic. Este posibil ca înregistrarea să fi eșuat.';

  @override
  String get noAudioDataSnack => 'Nu au fost înregistrate date audio';

  @override
  String get noDeviceSelectedSnack =>
      'Vă rugăm să selectați un dispozitiv audio';

  @override
  String get failedToInitRtAudio => 'Nu s-a inițializat RTAudio';

  @override
  String get envelopeScoreLabel => 'Plic';

  @override
  String get rhythmScoreLabel => 'Ritm';

  @override
  String get textScoreLabel => 'Text';

  @override
  String get help => 'Ajutor';

  @override
  String get trainingHelpTitle => 'Sfaturi de antrenament';

  @override
  String get trainingHelpText =>
      'Pentru ca antrenamentul să fie cât mai eficient posibil, urmați acești pași:\n1. Faceți clic pe butonul „Șterge contoarele”, astfel încât toate articolele din acest pachet să fie marcate ca cunoscute.\n2. Setați „Scopul articolului” la „Toate articolele”\n3. Setați „Comanda articolelor” la „Aleatoriu”\n4. Alegeți limba maternă din „Limba de afișare”\n5. Începeți antrenamentul și continuați până când identificați aproximativ 20–30 de elemente pe care nu le cunoașteți.\n6. Reveniți la setările de antrenament și schimbați „Scopul articolului” la „Numai articole necunoscute”\n7. Reluați antrenamentul și continuați până când ați învățat toate elementele necunoscute anterior.';

  @override
  String get trainingProTip =>
      'Sfat pro: Începeți cu toate articolele; mai târziu, concentrează-te doar pe necunoscute.';

  @override
  String get onboardingWelcomeTitle => 'Bun venit la Language Rally!';

  @override
  String get onboardingSetupSubtitle =>
      'Hai să configuram aplicația pentru tine.';

  @override
  String get onboardingSelectUiLanguage => 'Limbajul interfeței';

  @override
  String get onboardingUiLanguageNote =>
      'Puteți modifica acest lucru mai târziu în Setări → Limba interfeței.';

  @override
  String get onboardingNext => 'Următorul';

  @override
  String get onboardingBack => 'Spate';

  @override
  String get onboardingSelectPackagesTitle => 'Alegeți pachete lingvistice';

  @override
  String get onboardingSelectPackagesSubtitle =>
      'Selectați ce pachete de vocabular să importați. Puteți adăuga oricând mai multe mai târziu din meniul principal (Vedeți pachete).';

  @override
  String get onboardingAnalyzingPackages =>
      'Se analizează pachetele disponibile...';

  @override
  String onboardingScanningPackagesProgress(
    int scanned,
    int total,
    int alreadyInDb,
  ) {
    return 'Scanat $scanned/$total • deja în DB $alreadyInDb';
  }

  @override
  String get onboardingImportSelected => 'Import Selectate';

  @override
  String get onboardingSkipImport => 'Sari peste';

  @override
  String get onboardingSelectAll => 'Selectați Toate';

  @override
  String get onboardingDeselectAll => 'Deselectați Toate';

  @override
  String onboardingNPackages(int count) {
    return '$count pachete';
  }

  @override
  String get onboardingGetStarted => 'Începeți';

  @override
  String get onboardingImportCompleteTitle => 'Import finalizat!';

  @override
  String get importBuiltInPkg => 'Pachete gratuite';

  @override
  String get importBuiltInPkgTooltip =>
      'Importați pachete gratuite de limbi incluse';

  @override
  String get globalSearch => 'Căutare globală';

  @override
  String get globalSearchTitle => 'Căutați în toate pachetele';

  @override
  String get globalSearchSelectLanguage => 'Selectați codul de limbă';

  @override
  String get globalSearchEnterWord => 'Cuvânt(e) de căutat';

  @override
  String get globalSearchEnterWordHint =>
      'de ex. „der”, „order” — găsește potriviri parțiale';

  @override
  String get globalSearchButton => 'Căutare';

  @override
  String get globalSearchResults => 'Rezultate';

  @override
  String globalSearchNoResults(String query) {
    return 'Nu s-au găsit rezultate pentru „$query”';
  }

  @override
  String globalSearchResultsCount(int count) {
    return '$count rezultat(e) găsit(e).';
  }

  @override
  String get globalSearchSearching => 'Se caută…';

  @override
  String get globalSearchSelectLanguageFirst =>
      'Vă rugăm să selectați mai întâi un cod de limbă';

  @override
  String get globalSearchEnterTermFirst =>
      'Vă rugăm să introduceți un termen de căutare';

  @override
  String get globalSearchMatchInExamples => 'Găsit în exemple';

  @override
  String get globalSearchViewItem => 'Vedere';

  @override
  String get globalSearchGoToPackage => 'Accesați Pachetul';

  @override
  String get globalSearchLoadingPackages => 'Se încarcă pachetele...';

  @override
  String get globalSearchNoPackages => 'Niciun pachet de limbă instalat încă';

  @override
  String get globalSearchCancelSearch => 'Anulează căutarea';

  @override
  String globalSearchProgressOf(int current, int total) {
    return 'Se caută pachetul $current din $total…';
  }

  @override
  String globalSearchCancelledMessage(int count) {
    return 'Căutare anulată — $count rezultat(e) găsit(e) până acum';
  }

  @override
  String get storeTitle => 'Magazin de pachete lingvistice';

  @override
  String get storeRestorePurchases => 'Restabiliți achizițiile';

  @override
  String get storeRefresh => 'Reîmprospăta';

  @override
  String get storeSearchHint => 'Cauta pachete...';

  @override
  String get storeNoPackagesMatchSearch =>
      'Niciun pachet nu corespunde căutării dvs.';

  @override
  String get storeNoPackagesAvailable => 'Nu există pachete disponibile.';

  @override
  String storeInstalledCount(int installed, int total) {
    return '$installed / $total instalat';
  }

  @override
  String get storeLoadErrorTitle => 'Nu s-a putut încărca magazinul.';

  @override
  String get storeIapNotAvailableMessage =>
      'Achizițiile în aplicație nu sunt disponibile pe această platformă. Vizitați site-ul nostru pentru a cumpăra pachete.';

  @override
  String get storeOpenWebsite => 'Deschide site-ul web';

  @override
  String storePurchaseSuccess(String title) {
    return '$title instalat cu succes!';
  }

  @override
  String get storePurchaseCancelled => 'Achiziție anulată.';

  @override
  String storePurchaseAlreadyOwned(String title) {
    return '$title este deja instalat.';
  }

  @override
  String get storePurchaseError =>
      'Ceva a mers prost. Vă rugăm să încercați din nou.';

  @override
  String get storePurchasesRestored => 'Achiziții restaurate';

  @override
  String get storeAllLevels => 'Toate Nivelurile';

  @override
  String get storeAllGroups => 'Toate Limbile';

  @override
  String get storeFilterLevel => 'Nivel';

  @override
  String get storeFilterLanguage => 'Limbă';

  @override
  String get storeDownload => 'Descărcați';

  @override
  String get storeBuy => 'Cumpăra';

  @override
  String get storeInstalledLabel => 'Instalat';

  @override
  String get storeDownloading => 'Se descarcă...';

  @override
  String get storeRetry => 'Reîncercați';

  @override
  String get storeIapAndroidOnly =>
      'Achiziții disponibile numai pe Android și iOS.';

  @override
  String get storeDismiss => 'Respingeți';

  @override
  String get storeAddToCart => 'Adaugă in coş';

  @override
  String get storeRemoveFromCart => 'Elimina';

  @override
  String get storeCartTitle => 'Cărucior de cumpărături';

  @override
  String get storeCartEmpty => 'Coșul tău este gol';

  @override
  String get storeCartClearAll => 'Ștergeți tot';

  @override
  String get storeCartCheckout => 'Verifică';

  @override
  String storeCartItemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
    );
    return '$_temp0';
  }

  @override
  String get storePackageDuplicateTitle => 'Pachetul există deja';

  @override
  String storePackageDuplicateMessage(String packageName, String groupName) {
    return 'Pachetul „$packageName” există deja în grupul „$groupName”. Doriți să o suprascrieți? Pachetul existent și tot progresul său de instruire vor fi șterse definitiv.';
  }

  @override
  String get storePackageDuplicateOverwrite => 'Suprascrie';

  @override
  String get storePackageDuplicateKeep => 'Păstrați existența';

  @override
  String splashSettingUpPackages(int current, int total) {
    return 'Configurarea pachetelor: $current / $total';
  }

  @override
  String get splashThisHappensOnce => 'Acest lucru se întâmplă o singură dată.';

  @override
  String get splashLoading => 'Încărcare…';

  @override
  String get aiItemCreator => 'AI Chat Guru';

  @override
  String get aiItemCreatorAppBarHint =>
      'Colectați și salvați cuvinte și expresii prin chat cu AI';

  @override
  String get chatWithAI => 'Chat cu AI';

  @override
  String get enterYourPrompt => 'Introduceți solicitarea dvs....';

  @override
  String get aiItemCreatorPromptHint =>
      'Descrieți un subiect și antrenorul AI vă va pune întrebări, vă va sugera vocabular util și vă va testa cunoștințele. De exemplu: ajutați-mă să adun și să exersez pericolele legate de călătorii la nivelul de cunoștințe B2';

  @override
  String get send => 'Trimite';

  @override
  String get sending => 'Se trimite...';

  @override
  String get aiResponse => 'Răspuns AI';

  @override
  String get itemInputs => 'Intrări pentru articole';

  @override
  String get aiItemCreatorBothItemsRequired =>
      'Vă rugăm să completați ambele câmpuri de limbă înainte de a salva.';

  @override
  String get aiItemCreatorDuplicateItemMessage =>
      'Un articol cu ​​aceeași pereche de text există deja în acest pachet.';

  @override
  String get language1 => 'Limba 1';

  @override
  String get language2 => 'Limba 2';

  @override
  String get translateLang1ToLang2 => 'Traduceți în limba 2';

  @override
  String get translateLang2ToLang1 => 'Traduceți în limba 1';

  @override
  String translateToLanguageCode(String languageCode) {
    return 'Traduceți în $languageCode';
  }

  @override
  String get example => 'Exemplu';

  @override
  String get generating => 'Se generează...';

  @override
  String get flags => 'Steaguri';

  @override
  String get favorite => 'Favorit';

  @override
  String get saveItems => 'Salva';

  @override
  String get saving => 'Economisire...';

  @override
  String get clearItems => 'Ștergeți numai articole';

  @override
  String get clearAll => 'Ștergeți toate câmpurile';

  @override
  String get itemSavedSuccessfully => 'Elementul a fost salvat cu succes';

  @override
  String get promptCannotBeEmpty => 'Solicitarea nu poate fi goală';

  @override
  String get enterAtLeastOneItem =>
      'Vă rugăm să introduceți cel puțin un articol';

  @override
  String get selectPackageFirst => 'Vă rugăm să selectați mai întâi un pachet';

  @override
  String get deeplKeyRequired =>
      'Cheia API DeepL este necesară pentru traducere';

  @override
  String get noNonPurchasedPackagesAvailable =>
      'Nu sunt disponibile pachete neachizitionate';

  @override
  String get packageSelectionRemembered => 'Selecția pachetului a fost salvată';

  @override
  String get aiItemCreatorOpenAiKeyNotConfiguredDetailed =>
      'Cheia API OpenAI nu este configurată. Vă rugăm să adăugați cheia dvs. API în Setări.';

  @override
  String get aiItemCreatorOpenAiKeyNotConfigured =>
      'Cheia API OpenAI nu este configurată.';

  @override
  String get aiItemCreatorProcessingComplete => 'Procesare finalizată';

  @override
  String get aiItemCreatorTranslationComingSoon =>
      'Funcția de traducere va veni în curând';

  @override
  String get aiItemCreatorDefaultCategoryName => 'AI creat';

  @override
  String get aiItemCreatorStartNewConversation => 'Începeți o nouă conversație';

  @override
  String get aiItemCreatorChatHint =>
      'Descrieți un subiect și antrenorul AI vă va pune întrebări, vă va sugera vocabular util și vă va testa cunoștințele.';

  @override
  String get aiItemCreatorConversation => 'Conversaţie';

  @override
  String get aiItemCreatorYou => 'Tu';

  @override
  String get aiItemCreatorCoach => 'Antrenor AI';

  @override
  String get aiItemCreatorAiSuggestions => 'Sugestii AI';

  @override
  String get aiItemCreatorTapChipToFill =>
      'Atingeți un cip pentru a completa un câmp de articol și a traduce automat.';

  @override
  String get aiItemCreatorNoSuggestedItems =>
      'Încă nu există cuvinte sau expresii.';

  @override
  String get aiItemCreatorNextSteps => 'Cum să continui';

  @override
  String get aiItemCreatorNoNextSteps => 'Nicio sugestie de continuare încă.';

  @override
  String get aiItemCreatorModelCostTip =>
      'Sfat pro: modelele mai noi sunt mai scumpe, în timp ce modelele mai vechi și turbo sunt mai ieftine și pot fi semnificativ mai rapide.';

  @override
  String get aiItemCreatorSelectPackageDialogTitle =>
      'Alegeți pachetul de limbă';

  @override
  String get aiItemCreatorSelectPackageDialogMessage =>
      'Selectați pachetul de limbă de utilizat pentru această sesiune. Ultima ta alegere este preselectată.';

  @override
  String aiItemCreatorMissingApiKeysWarning(String keys) {
    return 'Chei API lipsă: $keys. Puteți continua, dar funcțiile AI și de traducere premium pot fi limitate.';
  }

  @override
  String get about => 'Despre';

  @override
  String get aboutWebsite => 'Site-ul web';

  @override
  String get aboutSummaryVideo => 'Video despre app';

  @override
  String get aboutSupportEmail => 'Adresă de e-mail de asistență';

  @override
  String get aboutWebsiteUrl => 'https://sites.google.com/view/language-rally';

  @override
  String get aboutSummaryVideoUrl =>
      'https://www.youtube.com/watch?v=64Pl9iNF88c';

  @override
  String get aboutSupportEmailAddress => 'languagerally.support@gmail.com';

  @override
  String aboutVersionWithValue(String version) {
    return 'Versiune: $version';
  }

  @override
  String aboutCouldNotOpen(String uri) {
    return 'Nu s-a putut deschide: $uri';
  }

  @override
  String get aboutWelcomeSplashNotFound =>
      'Imaginea de bun venit nu a fost găsită';

  @override
  String get chooseTheme => 'Alegeți Tema';

  @override
  String get darkMode => 'Modul întunecat';

  @override
  String get toggleBetweenLightAndDark => 'Comutați între lumină și întuneric';

  @override
  String get colorTheme => 'Tema de culoare:';

  @override
  String get toggleBrightness => 'Comutați luminozitatea';

  @override
  String get changeTheme => 'Schimbați tema';

  @override
  String get managePackageGroups => 'Gestionați grupurile de pachete';

  @override
  String get noPackageGroups => 'Fără grupuri de pachete';

  @override
  String get createFirstPackageGroup => 'Creați primul grup de pachete';

  @override
  String get addGroup => 'Adăugați grup';

  @override
  String get addPackageGroup => 'Adăugați un grup de pachete';

  @override
  String get editPackageGroup => 'Editați grupul de pachete';

  @override
  String get groupName => 'Numele grupului';

  @override
  String get enterGroupName => 'Introduceți numele grupului';

  @override
  String get groupNameRequired => 'Numele grupului este obligatoriu';

  @override
  String get duplicateGroupName => 'Nume duplicat';

  @override
  String groupNameAlreadyExists(String name) {
    return 'Un grup cu numele „$name” există deja.';
  }

  @override
  String groupCreatedSuccessfully(String name) {
    return 'Grupul „$name” a fost creat cu succes';
  }

  @override
  String failedToCreateGroup(String error) {
    return 'Nu s-a putut crea grupul: $error';
  }

  @override
  String groupRenamedTo(String name) {
    return 'Grup redenumit în „$name”';
  }

  @override
  String failedToUpdateGroup(String error) {
    return 'Nu s-a putut actualiza grupul: $error';
  }

  @override
  String get deleteGroup => 'Șterge grupul';

  @override
  String deleteGroupConfirm(String name) {
    return 'Sigur doriți să ștergeți grupul „$name”?\n\nAceastă acțiune nu poate fi anulată.';
  }

  @override
  String get cannotDeleteGroup => 'Nu se poate șterge';

  @override
  String groupHasPackages(int count) {
    return 'Acest grup are încă $count pachet(e). Vă rugăm să le mutați sau să le ștergeți mai întâi.';
  }

  @override
  String groupDeleted(String name) {
    return 'Grupul „$name” a fost șters';
  }

  @override
  String failedToDeleteGroup(String error) {
    return 'Nu s-a șters grupul: $error';
  }

  @override
  String get cannotDeleteHasPackagesTooltip =>
      'Nu se poate șterge (are pachete)';

  @override
  String nPackages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count packages',
      one: '1 package',
    );
    return '$_temp0';
  }

  @override
  String get manageGroups => 'Gestionați grupuri';

  @override
  String get featureLangPower => 'Puterea limbajului';

  @override
  String get featureAiIntegration => 'Integrarea AI';

  @override
  String get featureAdaptivePractice => 'Practică adaptativă';

  @override
  String get featureMasterAccent => 'Accent maestru';

  @override
  String get allBadgesEarned =>
      '🎉 Toate insignele câștigate! Ești un Maestru!';

  @override
  String nextBadgeLabel(String name) {
    return 'Următorul: $name';
  }

  @override
  String pointsToGo(String percent) {
    return '$percent% mai sunt';
  }

  @override
  String progressPercent(String percent) {
    return '$percent% progres';
  }

  @override
  String errorTogglingFavourite(String error) {
    return 'Eroare la comutarea preferată: $error';
  }

  @override
  String errorTogglingImportant(String error) {
    return 'Eroare la comutarea importantă: $error';
  }

  @override
  String categoryAdded(String name) {
    return 'S-a adăugat categoria „$name”.';
  }

  @override
  String errorAddingCategory(String error) {
    return 'Eroare la adăugarea categoriei: $error';
  }

  @override
  String categoryRemoved(String name) {
    return 'Categoria „$name” a fost eliminată';
  }

  @override
  String errorRemovingCategory(String error) {
    return 'Eroare la eliminarea categoriei: $error';
  }

  @override
  String couldNotOpenUrl(String url) {
    return 'Adresa URL nu a putut fi deschisă: $url';
  }

  @override
  String errorOpeningUrl(String error) {
    return 'Eroare la deschiderea adresei URL: $error';
  }

  @override
  String get pleaseSelectLanguage => 'Vă rugăm să selectați o limbă';

  @override
  String get add => 'Adăuga';

  @override
  String get speak => 'Vorbi';

  @override
  String get recordingFailedToStart =>
      'Înregistrarea nu a putut începe!\n\nVerificați:\n1. Microfonul este conectat\n2. Microfonul este setat ca dispozitiv implicit\n3. Nicio altă aplicație nu folosește microfonul';

  @override
  String get recordingFailedNoAudioFile =>
      'Înregistrarea a eșuat - nu a fost creat niciun fișier audio!\n\nCauze posibile:\n1. Microfonul nu este conectat\n2. Nu a fost detectată nicio intrare audio\n3. Problemă cu setările audio Windows';

  @override
  String errorStartingRecordingDetails(String error) {
    return 'Eroare la începerea înregistrării: $error';
  }

  @override
  String get openaiEmptyResponse =>
      'Modelul AI selectat a returnat un răspuns gol';

  @override
  String get tryDifferentModel =>
      'Încercați să selectați un alt model din selectorul de modele';

  @override
  String get modelMayNotBeSupported =>
      'Este posibil ca acest model să nu fie acceptat sau disponibil pentru contul dvs';

  @override
  String get reduceTextOrRetry =>
      'Reduceți lungimea textului sau încercați din nou';

  @override
  String get openaiNullContent =>
      'Modelul AI selectat nu a returnat niciun conținut';

  @override
  String get modelUnsupportedParameter =>
      'Modelul selectat nu acceptă un parametru API obligatoriu';
}
