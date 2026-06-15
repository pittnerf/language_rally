// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get helloWorld => 'Ciao mondo!';

  @override
  String get welcome => 'Benvenuti al Rally delle Lingue';

  @override
  String get appTitle => 'Raduno linguistico';

  @override
  String get createPackage => 'Crea pacchetto';

  @override
  String get editPackage => 'Modifica pacchetto';

  @override
  String get packageDetails => 'Dettagli del pacchetto';

  @override
  String get packageName => 'Nome del pacchetto';

  @override
  String get packageNameHint =>
      'ad esempio, elementi essenziali di spagnolo, elementi di base di tedesco';

  @override
  String get languageCode1 => 'Codice della lingua di origine';

  @override
  String get languageName1 => 'Nome della lingua di origine';

  @override
  String get languageCode2 => 'Codice della lingua di destinazione';

  @override
  String get languageName2 => 'Nome della lingua di destinazione';

  @override
  String get description => 'Descrizione';

  @override
  String get descriptionHint =>
      'Breve descrizione di questo pacchetto linguistico';

  @override
  String get authorName => 'Nome dell\'autore';

  @override
  String get authorEmail => 'E-mail dell\'autore';

  @override
  String get authorWebpage => 'Pagina web dell\'autore';

  @override
  String get version => 'Versione';

  @override
  String get items => 'elementi';

  @override
  String get packageIcon => 'Icona del pacchetto';

  @override
  String get packageGroup => 'Gruppo di pacchetti';

  @override
  String get selectIcon => 'Seleziona l\'icona';

  @override
  String get defaultIcon => 'Icona predefinita';

  @override
  String get customIcon => 'Icona personalizzata';

  @override
  String get upload => 'Icona Carica';

  @override
  String get uploadCustomIcon =>
      'Carica icona personalizzata (max 512x512, 1 MB)';

  @override
  String get customIconUploaded =>
      'Icona personalizzata caricata correttamente';

  @override
  String get save => 'Salva';

  @override
  String get edit => 'Modificare';

  @override
  String get cancel => 'Cancellare';

  @override
  String get delete => 'Eliminare';

  @override
  String get confirmDelete => 'Sei sicuro di voler eliminare questo pacchetto?';

  @override
  String get packageSaved => 'Pacchetto salvato con successo';

  @override
  String get packageDeleted => 'Pacchetto eliminato con successo';

  @override
  String get errorSavingPackage =>
      'Errore durante il salvataggio del pacchetto';

  @override
  String get errorDeletingPackage =>
      'Errore durante l\'eliminazione del pacchetto';

  @override
  String get fieldRequired => 'Questo campo è obbligatorio';

  @override
  String get invalidEmail => 'Indirizzo e-mail non valido';

  @override
  String get readOnlyPackage =>
      'Questo pacchetto è di sola lettura e non può essere modificato';

  @override
  String get purchasedPackage =>
      'I pacchetti acquistati non possono essere modificati';

  @override
  String get badges => 'Distintivi';

  @override
  String get noBadges => 'Nessun badge ancora guadagnato';

  @override
  String get selectLanguageCode => 'Seleziona il codice della lingua';

  @override
  String get typeToSearchLanguages => 'Digita per cercare le lingue...';

  @override
  String get search => 'Ricerca...';

  @override
  String get clearCounters => 'Cancella contatori';

  @override
  String get confirmClearCounters =>
      'Sei sicuro di voler cancellare tutti i contatori di formazione per questo pacchetto? Ciò azzererà i contatori \"non so\" e le statistiche di allenamento.';

  @override
  String get clear => 'Chiaro';

  @override
  String get countersCleared =>
      'I contatori sono stati cancellati con successo';

  @override
  String get errorClearingCounters =>
      'Errore durante la cancellazione dei contatori';

  @override
  String get deleteAll => 'Elimina pacchetto';

  @override
  String get confirmDeleteAllData =>
      'Sei sicuro di voler eliminare questo pacchetto con TUTTI i suoi dati? Ciò eliminerà permanentemente tutte le categorie, gli elementi e le statistiche di allenamento. Questa azione non può essere annullata!';

  @override
  String get allDataDeleted =>
      'Pacchetto e tutti i dati eliminati correttamente';

  @override
  String get exportPackage => 'Pacchetto di esportazione';

  @override
  String get selectExportLocation => 'Seleziona la posizione di esportazione';

  @override
  String get packageExported => 'Pacchetto esportato con successo';

  @override
  String get errorExportingPackage =>
      'Errore durante l\'esportazione del pacchetto';

  @override
  String get importItems => 'Importa elementi (JSON)';

  @override
  String get importItemsDialogTitle => 'Importa elementi (JSON)';

  @override
  String get importItemsFromLocalJson => 'Importa dal file JSON locale';

  @override
  String get enterItemsUrl => 'URL JSON degli elementi (https://…)';

  @override
  String get downloadingItems => 'Download degli elementi…';

  @override
  String get selectImportFile => 'Seleziona Importa file';

  @override
  String get importFormat => 'Formato di importazione';

  @override
  String get importFormatDescription =>
      'Importa elementi da un file di testo. Ogni riga deve contenere un elemento nel seguente formato:';

  @override
  String get importResults => 'Importa risultati';

  @override
  String get successfullyImported => 'Importazione riuscita';

  @override
  String get failedToImport => 'Impossibile importare';

  @override
  String get error => 'Errore';

  @override
  String get ok => 'OK';

  @override
  String get importPackage => 'Importa pacchetto';

  @override
  String get importPackageTooltip => 'Importa il pacchetto da file ZIP o URL';

  @override
  String get importPackageDialogTitle => 'Importa pacchetto lingue';

  @override
  String get importFromLocalFile => 'Importa da file locale';

  @override
  String get importFromUrl => 'Importa dall\'URL';

  @override
  String get enterPackageUrl => 'URL del pacchetto (https://…)';

  @override
  String get downloadingPackage => 'Download del pacchetto…';

  @override
  String get downloadFailed =>
      'Download non riuscito. Controlla l\'URL e la tua connessione Internet.';

  @override
  String get invalidUrl => 'Inserisci un URL http:// o https:// valido.';

  @override
  String get orLabel => 'O';

  @override
  String get selectPackageZipFile => 'Seleziona Pacchetto file ZIP';

  @override
  String get couldNotAccessFile => 'Impossibile accedere al file selezionato.';

  @override
  String get importingPackage => 'Importazione pacchetto...';

  @override
  String get packageImportedSuccessfully => 'Pacchetto importato con successo!';

  @override
  String packageImportedWithItems(Object count) {
    return 'Pacchetto importato con successo! ($count elementi)';
  }

  @override
  String packageImportedWithGroup(Object count, Object groupName) {
    return 'Pacchetto importato nel gruppo \"$groupName\"! ($count elementi)';
  }

  @override
  String get importError => 'Errore di importazione';

  @override
  String get failedToImportPackage => 'Impossibile importare il pacchetto';

  @override
  String get packageAlreadyExists => 'Il pacchetto esiste già';

  @override
  String packageExistsMessage(Object groupName) {
    return 'Nel gruppo \"$groupName\" esiste già un pacchetto con la stessa combinazione di lingue, descrizione, informazioni sull\'autore e versione. Desideri importarlo comunque come nuovo pacchetto?';
  }

  @override
  String get importAsNew => 'Importa comunque';

  @override
  String get zipFileNotFound => 'File ZIP non trovato';

  @override
  String get invalidPackageZip =>
      'ZIP del pacchetto non valido: pacchetto_data.json mancante';

  @override
  String get invalidPackageFormat => 'Formato file del pacchetto non valido';

  @override
  String get languagePackages => 'Pacchetti linguistici';

  @override
  String get loadingPackages => 'Caricamento pacchetti...';

  @override
  String get tapAndHoldToReorder =>
      'Tocca e tieni premuto per riordinare le carte';

  @override
  String get tapAndHoldToReorderList =>
      'Tocca e tieni premuto ≡ per riordinare • Tocca ⋮ per attivare/disattivare la visualizzazione compatta';

  @override
  String get noPackagesYet => 'Nessun pacchetto ancora';

  @override
  String get createFirstPackage => 'Crea il tuo primo pacchetto linguistico';

  @override
  String get versionLabel => 'Versione';

  @override
  String get purchased => 'Acquistato';

  @override
  String get compactView => 'compatto';

  @override
  String get expand => 'Espandere';

  @override
  String get allCategories => 'Tutte le categorie';

  @override
  String get categoriesInPackage => 'Categorie in questo pacchetto';

  @override
  String get categories => 'Categorie';

  @override
  String get testInterFonts => 'Prova i caratteri dell\'Inter';

  @override
  String get viewPackages => 'Visualizza pacchetti';

  @override
  String get simplifiedPackageView => 'Elenco dei pacchetti';

  @override
  String get createNewPackage => 'Crea nuovo pacchetto';

  @override
  String get generateTestData => 'Genera dati di prova';

  @override
  String get designSystemShowcase => 'Vetrina del sistema di progettazione';

  @override
  String get badgeEarned => 'Distintivo guadagnato!';

  @override
  String get achievement => 'Risultato';

  @override
  String get awesome => 'Eccezionale!';

  @override
  String get importFormatNotes => 'Note:';

  @override
  String get importFormatLine1 => '• Ogni riga rappresenta un articolo';

  @override
  String get importFormatLine2 => '• I campi sono separati da |';

  @override
  String get importFormatLine3 => '• Le categorie sono separate da ;';

  @override
  String get importFormatLine4 => '• L\'ultimo | è facoltativo';

  @override
  String get importFormatLine5 => '• Le righe vuote vengono ignorate';

  @override
  String get importFormatLine6 => '• I duplicati vengono saltati';

  @override
  String get importFormatNewDescription =>
      'Importa elementi da un file di testo. Ogni riga deve contenere un elemento con campi separati da ---';

  @override
  String get importFormatNewLine1 => '• Delimitatore principale: ---';

  @override
  String get importFormatNewLine2 =>
      '• L1=<testo> - Testo principale lingua 1 (richiesto se manca L2)';

  @override
  String get importFormatNewLine3 =>
      '• L2=<testo> - Testo principale lingua 2 (richiesto se manca L1)';

  @override
  String get importFormatNewLine4 =>
      '• L1pre=<testo> - Prefisso lingua 1 (opzionale)';

  @override
  String get importFormatNewLine5 =>
      '• L1post=<testo> - Suffisso lingua 1 (opzionale)';

  @override
  String get importFormatNewLine6 =>
      '• L2pre=<testo> - Prefisso lingua 2 (opzionale)';

  @override
  String get importFormatNewLine7 =>
      '• L2post=<testo> - Suffisso lingua 2 (opzionale)';

  @override
  String get importFormatNewLine8 =>
      '• EX=<testo L1>:::<testo L2> - Esempio (facoltativo, possono essere multipli)';

  @override
  String get importFormatNewLine9 =>
      '• CAT=<cat1>:::<cat2>:::<cat3> - Categorie (opzionale)';

  @override
  String get importFormatNewLine10 =>
      '• Deve essere presente almeno uno tra L1= o L2=';

  @override
  String get importFormatNewLine11 => '• Le righe vuote vengono ignorate';

  @override
  String get importFormatNewLine12 => '• I duplicati vengono saltati';

  @override
  String get invalidImportLine => 'Riga non valida';

  @override
  String get missingRequiredFields => 'Manca \'L1=\' vagy \'L2=\'';

  @override
  String get unknownField => 'Prefisso campo sconosciuto';

  @override
  String andMore(Object count) {
    return '... e $count altro';
  }

  @override
  String get browseItems => 'Sfoglia elementi';

  @override
  String get itemDetails => 'Dettagli';

  @override
  String get filterItems => 'Filtra elementi';

  @override
  String searchLanguage1(Object language) {
    return 'Cerca in $language';
  }

  @override
  String searchLanguage2(Object language) {
    return 'Cerca in $language';
  }

  @override
  String get caseSensitive => 'Maiuscole e minuscole';

  @override
  String get knownStatus => 'Stato noto';

  @override
  String get filterStatusAll => 'Tutto';

  @override
  String get filterStatusKnown => 'conosciuto';

  @override
  String get filterStatusUnknown => 'sconosciuto';

  @override
  String get allItems => 'Tutti gli articoli';

  @override
  String get itemsIKnew => 'Oggetti che conoscevo';

  @override
  String get itemsIDidNotKnow => 'Articoli che non conoscevo';

  @override
  String get known => 'Conosciuto';

  @override
  String get unknown => 'Sconosciuto';

  @override
  String get important => 'Importante';

  @override
  String get favourite => 'Preferito';

  @override
  String get badge => 'Distintivo';

  @override
  String get position => 'Posizione';

  @override
  String get stepsUntilLearned => 'Passi fino all\'apprendimento';

  @override
  String get examples => 'Esempi';

  @override
  String get noExamples => 'Nessun esempio disponibile';

  @override
  String get pronounce => 'Pronunciare';

  @override
  String get ttsError => 'Sintesi vocale non disponibile';

  @override
  String get noItemsFound => 'Nessun articolo trovato';

  @override
  String get noItemsInPackage => 'Nessun articolo in questo pacchetto ancora';

  @override
  String get addItem => 'Aggiungi elemento';

  @override
  String get emptyPackageHint =>
      'Aggiungi elementi manualmente o utilizza l\'intelligenza artificiale per importare rapidamente elementi';

  @override
  String get noItemsToTrain =>
      'Nessun elemento disponibile per esercitarsi con le impostazioni attuali';

  @override
  String get clearFilters => 'Chiaro';

  @override
  String itemCount(Object count) {
    return '$count elementi';
  }

  @override
  String filteredItemCount(Object filtered, Object total) {
    return '$filtered di $total elementi';
  }

  @override
  String get trainingRally => 'Raduno di allenamento';

  @override
  String get startTraining => 'Inizia la formazione';

  @override
  String get trainingComingSoon => 'Rally di allenamento - Prossimamente!';

  @override
  String get aiServiceNotConfigured =>
      'Servizio AI non configurato. Aggiungi la tua chiave API OpenAI.';

  @override
  String pleaseEnterTextInLanguageFirst(Object language) {
    return 'Inserisci prima il testo in $language';
  }

  @override
  String translationCompletedSuccessfully(Object service) {
    return 'Traduzione completata con successo utilizzando $service!';
  }

  @override
  String get translationFailed => 'Traduzione fallita';

  @override
  String addedExamplesSuccessfully(Object count) {
    return 'Aggiunti $count esempi con successo!';
  }

  @override
  String get failedToGenerateExamples => 'Impossibile generare esempi';

  @override
  String get selectExamplesToAdd => 'Seleziona Esempi da aggiungere';

  @override
  String get selectWhichExamples =>
      'Seleziona quali esempi vuoi aggiungere a questo articolo:';

  @override
  String get addSelected => 'Aggiungi selezionato';

  @override
  String get pleaseSelectAtLeastOne => 'Seleziona almeno un esempio';

  @override
  String get addNewItem => 'Aggiungi nuovo elemento';

  @override
  String get editItem => 'Modifica elemento';

  @override
  String get deleteItem => 'Elimina elemento';

  @override
  String get confirmDeleteItem =>
      'Sei sicuro di voler eliminare questo elemento?';

  @override
  String get thisActionCannotBeUndone =>
      'Questa azione non può essere annullata.';

  @override
  String get itemDeleted => 'Elemento eliminato';

  @override
  String get errorDeletingItem =>
      'Errore durante l\'eliminazione dell\'elemento';

  @override
  String get errorSavingItem => 'Errore durante il salvataggio dell\'articolo';

  @override
  String get itemSaved => 'Articolo aggiornato con successo';

  @override
  String get itemCreated => 'Articolo creato con successo';

  @override
  String get preTextOptional => 'Pre-testo (facoltativo)';

  @override
  String get mainText => 'Testo principale';

  @override
  String get postTextOptional => 'Post-testo (facoltativo)';

  @override
  String get forExampleToForVerbs => 'ad esempio, \"a\" per i verbi';

  @override
  String get additionalContext => 'Contesto aggiuntivo';

  @override
  String get translate => 'Tradurre';

  @override
  String translateFromTo(Object from, Object to) {
    return 'Traduci $from → $to';
  }

  @override
  String get aiExampleGeneration =>
      'Generazione di esempi di intelligenza artificiale';

  @override
  String get aiExampleSearch => 'Ricerca di esempi di intelligenza artificiale';

  @override
  String searchExamplesOnInternet(Object text) {
    return 'Cerca frasi di esempio su Internet utilizzando l\'intelligenza artificiale per \"$text\"';
  }

  @override
  String generateExampleSentences(Object language) {
    return 'Genera frasi di esempio basate sul testo principale in $language';
  }

  @override
  String get voiceInput => 'Ingresso vocale';

  @override
  String get settings => 'Impostazioni';

  @override
  String get uiLanguage => 'Lingua dell\'interfaccia utente';

  @override
  String get uiLanguageDescription =>
      'Lingua dell\'interfaccia dell\'applicazione';

  @override
  String get uiLanguageHelper =>
      'Seleziona la lingua per menu, pulsanti ed etichette';

  @override
  String get userLanguage => 'Lingua dell\'utente';

  @override
  String get userLanguageDescription =>
      'La tua lingua madre preferita per creare nuovi pacchetti linguistici';

  @override
  String get apiKeys => 'Chiavi API';

  @override
  String get deeplApiKey => 'Chiave API DeepL';

  @override
  String get deeplApiKeyDescription =>
      'Per una qualità di traduzione premium durante la modifica di elementi linguistici. Vedi https://www.deepl.com/pro-api';

  @override
  String get openaiApiKey => 'Chiave API OpenAI';

  @override
  String get openaiApiKeyDescription =>
      'Ad esempio la generazione con l\'intelligenza artificiale durante la modifica di elementi linguistici. Vedi https://platform.openai.com/api-keys';

  @override
  String get enterApiKey => 'Inserisci la chiave API';

  @override
  String get optional => 'opzionale';

  @override
  String get required => 'necessario';

  @override
  String get settingsSaved => 'Impostazioni salvate con successo';

  @override
  String get errorSavingSettings =>
      'Errore durante il salvataggio delle impostazioni';

  @override
  String get usingGoogleTranslate => 'Utilizzo di Google Traduttore gratuito';

  @override
  String get usingDeepL => 'Utilizzo di DeepL (premium)';

  @override
  String get noTranslationReceivedFromGoogle =>
      'Nessuna traduzione ricevuta da Google';

  @override
  String get googleTranslationFailed =>
      'La traduzione di Google non è riuscita';

  @override
  String get googleTranslationError => 'Errore di traduzione di Google';

  @override
  String get noTranslationReceivedFromDeepL =>
      'Nessuna traduzione ricevuta da DeepL';

  @override
  String get invalidDeepLApiKey => 'Chiave API DeepL non valida';

  @override
  String get deeplTranslationQuotaExceeded =>
      'Quota di traduzione DeepL superata';

  @override
  String get deeplTranslationFailed => 'La traduzione di DeepL non è riuscita';

  @override
  String get deeplTranslationError => 'Errore di traduzione di DeepL';

  @override
  String get invalidApiKeyConfigureOpenAI =>
      'Chiave API non valida. Configura la tua chiave API OpenAI.';

  @override
  String get apiRateLimitExceeded =>
      'Limite di velocità API superato. Per favore riprova più tardi.';

  @override
  String get aiRequestFailed => 'Richiesta AI non riuscita';

  @override
  String get failedToParseAiResponse =>
      'Impossibile analizzare la risposta dell\'IA. Per favore riprova.';

  @override
  String get aiGenerationError => 'Errore di generazione dell\'IA';

  @override
  String get voiceInputPlaceholder =>
      'L\'input vocale verrà implementato utilizzando il pacchetto spell_to_text';

  @override
  String get improveQualityWithApiKeys =>
      '💡 Suggerimento: la qualità delle traduzioni e delle ricerche di esempio può essere notevolmente migliorata aggiungendo le chiavi API DeepL e OpenAI nelle impostazioni dell\'applicazione.';

  @override
  String get noApiKeyFallbackMessage =>
      'Senza chiavi API, vengono forniti traduzione di base ed esempi limitati. Per ottenere i migliori risultati, configura le tue chiavi API in Impostazioni.';

  @override
  String get listeningForSpeech => 'Ascolto... Parla adesso';

  @override
  String get speechRecognitionNotAvailable =>
      'Il riconoscimento vocale non è disponibile su questo dispositivo';

  @override
  String get speechRecognitionPermissionDenied =>
      'L\'autorizzazione al riconoscimento vocale è stata negata';

  @override
  String get speechRecognitionError => 'Errore di riconoscimento vocale';

  @override
  String get tapToSpeak => 'Tocca il microfono per parlare';

  @override
  String get tapToStop => 'Tocca per interrompere la registrazione';

  @override
  String get speechNotRecognized =>
      'Nessun discorso è stato riconosciuto. Per favore riprova.';

  @override
  String get usingWhisperApiSlower =>
      'Utilizzo dell\'intelligenza artificiale cloud per il riconoscimento vocale (potrebbe essere più lento)';

  @override
  String languageNotSupportedAddApiKey(String languageCode) {
    return 'Lingua $languageCode non supportata in modo nativo. Aggiungi la chiave API OpenAI nelle Impostazioni per il riconoscimento vocale basato sull\'intelligenza artificiale.';
  }

  @override
  String get recordingTapToStop =>
      'Registrazione... Tocca di nuovo per interrompere';

  @override
  String get speakClearlyKeepRecording =>
      'Parla chiaramente. Registra almeno 1 secondo.';

  @override
  String get pleaseRecordLonger =>
      'Si prega di parlare per almeno 1 secondo e toccare Interrompi.';

  @override
  String get errorStartingRecording =>
      'Errore durante l\'avvio della registrazione';

  @override
  String get noAudioRecorded => 'Non è stato registrato alcun audio';

  @override
  String get errorTranscribing => 'Errore durante la trascrizione dell\'audio';

  @override
  String get trainingSettings => 'Impostazioni di allenamento';

  @override
  String get trainingPresetTitle => 'Configurazione rapida';

  @override
  String get trainingPresetHint =>
      'Scegli una preimpostazione e le impostazioni seguenti verranno configurate automaticamente.';

  @override
  String get trainingPresetComboLabel => 'Preimpostato';

  @override
  String get trainingPresetAllExamplesForeignLanguage =>
      'Tutti gli esempi, lingua straniera';

  @override
  String get trainingPresetAllExamplesRandomLanguage =>
      'Tutti gli esempi, linguaggio casuale';

  @override
  String get trainingPresetFavouriteItemsForeignLanguage =>
      'Articoli preferiti, lingua straniera';

  @override
  String get trainingPresetFavouriteItemsRandomLanguage =>
      'Articoli preferiti, lingua casuale';

  @override
  String get trainingPresetImportantItemsForeignLanguage =>
      'Articoli importanti, lingua straniera';

  @override
  String get trainingPresetImportantItemsRandomLanguage =>
      'Elementi importanti, linguaggio casuale';

  @override
  String get trainingPresetRandomItemsRandomLanguage =>
      'Oggetti casuali, linguaggio casuale';

  @override
  String get trainingPresetUnknownItemsForeignLanguage =>
      'Oggetti sconosciuti, lingua straniera';

  @override
  String get trainingPresetUnknownItemsRandomLanguage =>
      'Elementi sconosciuti, linguaggio casuale';

  @override
  String trainingPresetAppliedTapStart(String actionLabel) {
    return 'Preimpostazione applicata. Tocca \"$actionLabel\" per iniziare.';
  }

  @override
  String get trainingPresetSelectPackageFirst =>
      'Seleziona prima un pacchetto.';

  @override
  String get itemScope => 'Ambito dell\'articolo';

  @override
  String get lastNItems => 'Ultimi N articoli';

  @override
  String get onlyUnknown => 'Solo oggetti sconosciuti';

  @override
  String get onlyImportant => 'Solo oggetti importanti';

  @override
  String get onlyFavourite => 'Solo articoli preferiti';

  @override
  String get numberOfItems => 'Numero di articoli';

  @override
  String get itemOrder => 'Ordine dell\'articolo';

  @override
  String get randomOrder => 'Ordine casuale';

  @override
  String get sequentialOrder => 'Ordine sequenziale';

  @override
  String get itemType => 'Tipo di articolo';

  @override
  String get dictionaryItems => 'Voci del dizionario';

  @override
  String get examplesType => 'Esempi';

  @override
  String get displayLanguage => 'Lingua di visualizzazione';

  @override
  String get motherTongue => 'Madrelingua';

  @override
  String get targetLanguage => 'Lingua di destinazione';

  @override
  String get randomLanguage => 'Casuale';

  @override
  String get categoryFilter => 'Filtro categoria';

  @override
  String get categoryFilterHint =>
      'Seleziona le categorie da includere (vuoto = tutte le categorie)';

  @override
  String get noCategories => 'Nessuna categoria disponibile';

  @override
  String get dontKnowThreshold => 'Non conosco la soglia';

  @override
  String get dontKnowThresholdHint =>
      'Numero di volte in cui un articolo deve essere contrassegnato come \"non so\" prima di una gestione speciale';

  @override
  String get startTrainingRally => 'Inizia il rally di allenamento';

  @override
  String get clearTrainingSettings => 'Cancella impostazioni';

  @override
  String get confirmClearTrainingSettings =>
      'Sei sicuro di voler ripristinare tutte le impostazioni di allenamento sui valori predefiniti?';

  @override
  String get trainingSettingsCleared =>
      'Le impostazioni dell\'allenamento sono state cancellate';

  @override
  String get startingTraining => 'Inizio allenamento...';

  @override
  String get noMoreItemsToDisplay =>
      'Nessun elemento da visualizzare in base alle impostazioni del filtro.';

  @override
  String get noItems => 'Nessun articolo';

  @override
  String get trainingComplete => 'Formazione completata';

  @override
  String get allItemsCompleted =>
      'Congratulazioni! Hai completato tutti gli elementi di questa sessione di formazione.';

  @override
  String get closeTraining => 'Chiudi Formazione';

  @override
  String get confirmCloseTraining =>
      'Sei sicuro di voler chiudere la formazione? I tuoi progressi sono stati salvati.';

  @override
  String get question => 'Domanda';

  @override
  String get answer => 'Risposta';

  @override
  String get iKnow => 'Lo so';

  @override
  String get iDontKnow => 'Non lo so';

  @override
  String get previousItem => 'Articolo precedente';

  @override
  String get iDidNotKnowEither => 'Dopotutto non lo sapevo';

  @override
  String get exportBeforeDelete => 'Esportare prima di eliminare?';

  @override
  String get aiTextAnalysis =>
      'Estrai elementi da un testo/elenco con l\'intelligenza artificiale';

  @override
  String get aiTextAnalysisImport =>
      'Estrai elementi da un testo o da un elenco con lo strumento di analisi del testo AI';

  @override
  String get knowledgeLevel => 'Livello di conoscenza';

  @override
  String get a1Beginner => 'A1 – Principiante';

  @override
  String get a2Elementary => 'A2 - Elementare';

  @override
  String get b1Intermediate => 'B1 – Intermedio';

  @override
  String get b2UpperIntermediate => 'B2 - Intermedio superiore';

  @override
  String get c1Advanced => 'C1 - Avanzato';

  @override
  String get c2Proficient => 'C2 – Esperto';

  @override
  String get pasteTextHere => 'Incolla qui il tuo testo...';

  @override
  String get extractWords => 'Estrai parole';

  @override
  String get extractExpressions => 'Estrai espressioni';

  @override
  String get maxItems => 'Numero massimo di nuovi articoli';

  @override
  String get maxItemsHint => 'Lascia vuoto per nessun limite';

  @override
  String get generateExamples => 'Genera esempi';

  @override
  String get categoryName => 'Nome della categoria';

  @override
  String get categoryNameHint =>
      'Nome per la categoria degli articoli importati';

  @override
  String get analyzeText => 'Analizzare il testo';

  @override
  String get configureAnalysis => 'Configura gli elementi da estrarre';

  @override
  String get openaiModel => 'Modello di intelligenza artificiale';

  @override
  String get openaiModelDescription => 'Seleziona il modello ChatGPT';

  @override
  String get modelGpt55 => 'GPT-5.5';

  @override
  String get modelGpt55Pro => 'GPT-5.5 Pro';

  @override
  String get modelGpt54 => 'GPT-5.4';

  @override
  String get modelGpt54Pro => 'GPT-5.4Pro';

  @override
  String get modelGpt54Mini => 'GPT-5.4 Mini';

  @override
  String get modelGpt5Mini => 'GPT-5 Mini';

  @override
  String get modelGpt41 => 'GPT-4.1';

  @override
  String get modelGpt55Desc =>
      'Il nuovissimo equilibrio di punta tra qualità e velocità per uso generale';

  @override
  String get modelGpt55ProDesc =>
      'Variante GPT-5.5 di fascia alta per il ragionamento e la qualità più forti';

  @override
  String get modelGpt54Desc =>
      'Robusto modello di generazione GPT-5 per uso generale';

  @override
  String get modelGpt54ProDesc =>
      'Variante GPT-5.4 ad alta capacità per attività impegnative';

  @override
  String get modelGpt54MiniDesc =>
      'Variante GPT-5.4 più piccola e più veloce per attività quotidiane a basso costo';

  @override
  String get modelGpt5MiniDesc =>
      'Modello compatto della famiglia GPT-5 ottimizzato per velocità e costi';

  @override
  String get modelGpt41Desc =>
      'Opzione GPT-4.1 affidabile per compatibilità e qualità solida';

  @override
  String get modelGpt4o => 'GPT-4o';

  @override
  String get modelGpt35Turbo => 'GPT-3.5 Turbo (precedente, economico)';

  @override
  String get modelGpt35Turbo16k => 'GPT-3.5 Turbo 16K';

  @override
  String get modelGpt4 => 'GPT-4';

  @override
  String get modelGpt4Turbo => 'GPT-4 Turbo (precedente)';

  @override
  String get modelGpt4oDesc =>
      'La migliore scelta per scopi generali; qualità veloce, multimodale e forte';

  @override
  String get modelGpt35TurboDesc =>
      'Opzione legacy a basso costo; utile per attività più semplici e per un utilizzo sensibile ai costi';

  @override
  String get modelGpt35Turbo16kDesc =>
      'Come GPT-3.5, ma finestra di contesto del token da 16K';

  @override
  String get modelGpt4Desc =>
      'Elevata qualità del ragionamento; tipicamente più lento e più costoso';

  @override
  String get modelGpt4TurboDesc =>
      'Opzione famiglia GPT-4 legacy; ancora utile quando desideri un\'alternativa più vecchia e più economica';

  @override
  String get analyzing => 'Analizzando...';

  @override
  String get languageDetected => 'Lingua rilevata';

  @override
  String get itemsFound => 'Elementi trovati';

  @override
  String get selectItemsToImport => 'Seleziona Elementi da importare';

  @override
  String get selectAll => 'Seleziona tutto';

  @override
  String get deselectAll => 'Deseleziona tutto';

  @override
  String get importSelected => 'Importa selezionato';

  @override
  String get importing => 'Importazione...';

  @override
  String get itemsImported => 'Elementi importati correttamente';

  @override
  String get noItemsSelected => 'Nessun elemento selezionato';

  @override
  String get textCannotBeEmpty => 'Il testo non può essere vuoto';

  @override
  String get selectAtLeastOneType =>
      'Seleziona almeno un tipo (parole o espressioni)';

  @override
  String get languageNotMatching =>
      'La lingua rilevata non corrisponde ad alcuna lingua nel pacchetto';

  @override
  String get openaiKeyRequired =>
      'Per questa funzionalità è richiesta la chiave API OpenAI';

  @override
  String analyzingProgress(Object current, Object total) {
    return 'Analisi in corso: $current / $total';
  }

  @override
  String translatingProgress(Object current, Object total) {
    return 'Traduzione in corso: $current / $total';
  }

  @override
  String get duplicate => 'Duplicato';

  @override
  String importProgress(Object current, Object total) {
    return 'Importazione di $current di $total';
  }

  @override
  String get detectingLanguage => 'Rilevamento della lingua...';

  @override
  String get extractingItems => 'Estrazione elementi...';

  @override
  String get checkingDuplicates => 'Controllo dei duplicati...';

  @override
  String get translating => 'Traduzione...';

  @override
  String get generatingExamples => 'Generazione di esempi...';

  @override
  String get errorAnalyzingText => 'Errore nell\'analisi del testo';

  @override
  String get errorImportingItems =>
      'Errore durante l\'importazione degli articoli';

  @override
  String get warning => 'Avvertimento';

  @override
  String get textIsVeryLarge => 'Il testo è molto grande';

  @override
  String get words => 'parole';

  @override
  String get continueAnalysis =>
      'L\'elaborazione potrebbe richiedere più tempo e verrà analizzata in blocchi. Vuoi continuare?';

  @override
  String get continueLabel => 'Continuare';

  @override
  String get exportBeforeDeleteMessage =>
      'Vuoi esportare questo pacchetto prima di eliminarlo? Ciò salverà tutti i tuoi dati in un file ZIP.';

  @override
  String get deleteWithoutExport => 'Elimina senza esportare';

  @override
  String get exportAndDelete => 'Esporta ed elimina';

  @override
  String get exportingPackage => 'Esportazione pacchetto...';

  @override
  String packageExportedToPath(Object path) {
    return 'Pacchetto esportato in: $path';
  }

  @override
  String errorLoadingItems(Object error) {
    return 'Errore durante il caricamento degli articoli: $error';
  }

  @override
  String badgeEarnedWithName(Object badgeName) {
    return 'Distintivo ottenuto: $badgeName!';
  }

  @override
  String badgeLostWithName(Object badgeName) {
    return 'Badge smarrito: $badgeName';
  }

  @override
  String get trainingSessionProgress =>
      'Statistiche della sessione di allenamento';

  @override
  String get total => 'Totale';

  @override
  String lastNValue(Object value) {
    return 'N = $value';
  }

  @override
  String errorLoadingSettings(Object error) {
    return 'Errore durante il caricamento delle impostazioni: $error';
  }

  @override
  String get selectPackage => 'Seleziona Pacchetto';

  @override
  String get noPackagesAvailable => 'Nessun pacchetto disponibile';

  @override
  String get possibleSolutions => 'Possibili soluzioni';

  @override
  String get technicalDetails => 'Dettagli tecnici';

  @override
  String get close => 'Vicino';

  @override
  String get checkApiKey => 'Controlla la tua chiave API OpenAI';

  @override
  String get ensureValidOpenAIKey =>
      'Assicurati che la chiave API sia valida e attiva';

  @override
  String get verifyKeyInSettings => 'Verifica la chiave in Impostazioni';

  @override
  String get rateLimitExceeded => 'Limite di velocità API superato';

  @override
  String get waitAndRetry => 'Attendi qualche minuto e riprova';

  @override
  String get checkAccountQuota => 'Controlla la quota del tuo account OpenAI';

  @override
  String get invalidRequest => 'Formato della richiesta non valido';

  @override
  String get tryReducingTextLength => 'Prova a ridurre la lunghezza del testo';

  @override
  String get checkTextFormat =>
      'Controlla che il formato del testo sia corretto';

  @override
  String get checkInternetConnection => 'Controlla la tua connessione Internet';

  @override
  String get retryInMoment => 'Riprova tra un attimo';

  @override
  String get checkFirewall => 'Controlla le impostazioni del firewall';

  @override
  String get textMayBeTooShort => 'Il testo potrebbe essere troppo corto';

  @override
  String get tryDifferentKnowledgeLevel =>
      'Prova un livello di conoscenza diverso';

  @override
  String get ensureTextInCorrectLanguage =>
      'Assicurati che il testo sia nella lingua corretta';

  @override
  String get requestTimedOut => 'Richiesta scaduta';

  @override
  String get textMayBeTooLong => 'Il testo potrebbe essere troppo lungo';

  @override
  String get tryAgainOrReduceSize => 'Riprova o riduci la dimensione del testo';

  @override
  String get unexpectedError => 'Si è verificato un errore imprevisto';

  @override
  String get checkErrorDetails =>
      'Controlla i dettagli dell\'errore di seguito';

  @override
  String get tryAgainLater => 'Riprova più tardi';

  @override
  String get translationServiceFailed =>
      'Il servizio di traduzione non è riuscito';

  @override
  String get checkApiKeys => 'Controlla le tue chiavi API (DeepL, OpenAI)';

  @override
  String get retryImport => 'Riprovare l\'importazione';

  @override
  String get exampleGenerationFailed =>
      'La generazione dell\'esempio non è riuscita';

  @override
  String get itemsStillImported => 'Gli articoli venivano ancora importati';

  @override
  String get canAddExamplesManually =>
      'Puoi aggiungere esempi manualmente in seguito';

  @override
  String get databaseError => 'Si è verificato un errore nel database';

  @override
  String get checkStorageSpace =>
      'Controlla lo spazio di archiviazione disponibile';

  @override
  String get restartApp => 'Prova a riavviare l\'app';

  @override
  String get groupLabel => 'Gruppo:';

  @override
  String get amendGroups => 'Modificare';

  @override
  String get exportItemsJson => 'Esporta elementi (JSON)';

  @override
  String get exportItemsJsonTooltip =>
      'Esporta tutti gli elementi come file JSON';

  @override
  String get noCategoriesInPackage =>
      'Nessuna categoria trovata in questo pacchetto';

  @override
  String get noItemsToExport => 'Nessun articolo trovato da esportare';

  @override
  String itemsExportedSuccessfully(int count, String path) {
    return 'Elementi $count esportati correttamente in:\n$path';
  }

  @override
  String get errorExportingItems =>
      'Errore durante l\'esportazione degli elementi';

  @override
  String get languageMismatch => 'Mancata corrispondenza linguistica';

  @override
  String get languageMismatchDescription =>
      'Le lingue nel file JSON non corrispondono alle lingue del pacchetto:';

  @override
  String packageLanguages(String lang1, String lang2) {
    return 'Pacchetto: $lang1 → $lang2';
  }

  @override
  String jsonFileLanguages(String lang1, String lang2) {
    return 'File JSON: $lang1 → $lang2';
  }

  @override
  String get continueImportQuestion =>
      'Vuoi continuare comunque l\'importazione?';

  @override
  String get continueImport => 'Continua l\'importazione';

  @override
  String get pleaseSelectPackageGroup => 'Seleziona un gruppo di pacchetti';

  @override
  String get customIconLabel => 'Costume';

  @override
  String get defaultIconLabel => 'Predefinito';

  @override
  String get icon2Label => 'Libro aperto';

  @override
  String get icon3Label => 'Libro colorato';

  @override
  String get icon4Label => 'Conversazione';

  @override
  String get icon5Label => 'Laurea';

  @override
  String get icon6Label => 'Cervello';

  @override
  String get icon7Label => 'Pila di libri';

  @override
  String get icon8Label => 'Scheda flash';

  @override
  String get icon9Label => 'Globo';

  @override
  String get icon10Label => 'Matita';

  @override
  String get icon11Label => 'Trofeo';

  @override
  String get icon12Label => 'Ricerca';

  @override
  String get customIconFile => 'Icona personalizzata';

  @override
  String get importedIconFile => 'Icona importata';

  @override
  String get unableToReadImageFile =>
      'Impossibile leggere il file immagine. Seleziona un\'immagine valida.';

  @override
  String iconDimensionsTooLarge(int width, int height) {
    return 'Le dimensioni dell\'icona sono troppo grandi (${width}x$height). Il massimo consentito è 512x512 pixel.';
  }

  @override
  String get iconFileTooLarge =>
      'Il file dell\'icona è troppo grande. La dimensione massima è 1 MB.';

  @override
  String failedToUploadIcon(String error) {
    return 'Impossibile caricare l\'icona: $error';
  }

  @override
  String get pleaseSelectValidLanguage =>
      'Seleziona una lingua valida dall\'elenco';

  @override
  String get status => 'Stato';

  @override
  String get addExample => 'Aggiungi esempio';

  @override
  String get noExamplesYet =>
      'Nessun esempio ancora. Fare clic su + per aggiungere.';

  @override
  String get speakText => 'Pronuncia il testo';

  @override
  String get removeCategory => 'Rimuovi categoria';

  @override
  String removeCategoryConfirm(String categoryName) {
    return 'Rimuovere la categoria \"$categoryName\" da questo articolo?';
  }

  @override
  String get remove => 'Rimuovere';

  @override
  String get extractFullItems => 'Estrai elementi completi';

  @override
  String get pasteFromClipboard => 'Incolla dagli appunti';

  @override
  String get noItemsFoundOrAllDuplicates =>
      'Nessun articolo trovato nel testo oppure tutti gli articoli sono già presenti nel pacchetto';

  @override
  String get aboutLanguageRally => 'Informazioni sul raduno linguistico';

  @override
  String get welcomeTitle => '🚀 Benvenuti al Rally delle Lingue';

  @override
  String get welcomeSubtitle =>
      'Sblocca l\'incredibile potere dell\'apprendimento delle lingue con circa 4.000 parole, 4.000 espressioni e altrettante frasi di esempio, accuratamente selezionate per ogni livello di competenza! Usa l\'intelligenza artificiale per importare elementi dai tuoi testi o chatta con l\'intelligenza artificiale su qualsiasi argomento per generare le parole, le espressioni e gli esempi esatti che desideri imparare.\nMigliora le tue abilità linguistiche in modo intelligente e giocoso!';

  @override
  String get welcomeIntro =>
      'Impara il vocabolario e le espressioni in modo efficiente mettendo in pratica ciò che ti interessa veramente. Nessuna lista noiosa. Nessuna perdita di tempo.';

  @override
  String get sectionPlayYourGame => '🎮 Gioca al tuo gioco';

  @override
  String get sectionPlayYourGameDesc =>
      'Crea i tuoi pacchetti di vocaboli. Allena solo le parole e le espressioni che vuoi padroneggiare. Lo sai già? Verrà contrassegnato e saltato!';

  @override
  String get sectionAITeammate =>
      '🤖 L\'intelligenza artificiale come compagna di squadra';

  @override
  String get sectionAITeammateDesc =>
      'Incolla qualsiasi testo e lascia che AI:\n• Estrarre vocabolario utile\n• Scegli le espressioni che corrispondono al tuo livello\n• Realizza pacchetti pronti per la formazione in pochi secondi\n\nChatta con l\'IA:\n• Lascia che suggerisca parole ed espressioni per il tuo argomento\n• Fare clic per generare esempi e salvarli nel PROPRIO pacchetto';

  @override
  String get sectionTrainSmart => '🔁 Allenati in modo intelligente';

  @override
  String get sectionTrainSmartDesc =>
      'Il nostro sistema di ripetizione ottimizzato mostra gli elementi esattamente quando il tuo cervello ne ha bisogno per memorizzarli in modo efficace. Massimo progresso. Sforzo minimo.';

  @override
  String get sectionRealExamples => '🌍 Esempi reali. Grandi traduzioni.';

  @override
  String get sectionRealExamplesDesc =>
      'Ottieni esempi di utilizzo nel mondo reale. Traduci con qualità premium tramite DeepL. Esercitati nella pronuncia e sembra sicuro.';

  @override
  String get sectionTeachersWelcome => '👩‍🏫 Insegnanti Benvenuti';

  @override
  String get sectionTeachersWelcomeDesc =>
      'Crea un pacchetto → Copia e incolla elementi oppure estrai, traduci, aggiungi esempi con l\'intelligenza artificiale → Esporta → Carica/Invia → Fine. I tuoi studenti lo importano e iniziano a esercitarsi immediatamente.';

  @override
  String get sectionUnlockAI => '🔑 Sblocca la piena potenza dell\'IA';

  @override
  String get sectionUnlockAIDesc =>
      'Per traduzioni di alta qualità e funzionalità di intelligenza artificiale, è sufficiente:\n\n1. Crea la tua chiave API DeepL\n   https://www.deepl.com/pro-api\n2. Crea la tua chiave API OpenAI\n   https://platform.openai.com/api-keys\n3. Incolla entrambe le chiavi in Impostazioni\n\nUn piccolo investimento sblocca strumenti linguistici potenti e di livello professionale. Perché dovresti perdertelo?\n(Ti consigliamo di utilizzare l\'accesso API a pagamento per ottenere i migliori risultati.)';

  @override
  String get readyToStart => 'Pronto per iniziare il tuo rally? 🏁';

  @override
  String get welcomeDescription =>
      'Language Rally è il tuo compagno completo per l\'apprendimento delle lingue. Crea pacchetti di vocaboli personalizzati, organizza gli elementi per categorie e allenati con un sistema di ripetizione spaziata intelligente.';

  @override
  String get browseStore => 'Sfoglia il negozio';

  @override
  String get featureInteractiveTraining => 'Formazione interattiva';

  @override
  String get featureInteractiveTrainingDesc =>
      'Esercitati con algoritmi di apprendimento adattivo';

  @override
  String get featureSmartOrganization => 'Organizzazione intelligente';

  @override
  String get featureSmartOrganizationDesc =>
      'Categorizza e filtra il tuo vocabolario';

  @override
  String get featureTrackProgress => 'Tieni traccia dei progressi';

  @override
  String get featureTrackProgressDesc =>
      'Monitora il tuo apprendimento con statistiche dettagliate';

  @override
  String get featureImportExport => 'Importa ed esporta';

  @override
  String get featureImportExportDesc =>
      'Condividi pacchetti e sincronizza tra dispositivi';

  @override
  String get startAppTour => 'Avvia la presentazione dell\'app';

  @override
  String get quickStartGuide => 'Guida rapida';

  @override
  String get tourStep1Title => 'Crea o importa pacchetti';

  @override
  String get tourStep1Desc =>
      'Inizia creando un nuovo pacchetto di lingue o importane uno esistente da un file.';

  @override
  String get tourStep2Title => 'Aggiungi elementi di vocabolario';

  @override
  String get tourStep2Desc =>
      'Sfoglia i tuoi pacchetti e aggiungi parole, frasi o espressioni con esempi e categorie.';

  @override
  String get tourStep3Title => 'Configura la formazione';

  @override
  String get tourStep3Desc =>
      'Scegli con quali elementi esercitarti, imposta i livelli di difficoltà e personalizza la tua esperienza di apprendimento.';

  @override
  String get tourStep4Title => 'Inizia a imparare';

  @override
  String get tourStep4Desc =>
      'Inizia la sessione di allenamento e contrassegna gli elementi come noti o sconosciuti per monitorare i tuoi progressi.';

  @override
  String get tourStep5Title => 'Revisione delle statistiche';

  @override
  String get tourStep5Desc =>
      'Controlla i tuoi progressi nell\'apprendimento con statistiche dettagliate e badge sui risultati.';

  @override
  String get gotIt => 'Fatto!';

  @override
  String get appTourTitle => 'Benvenuti al Rally delle Lingue';

  @override
  String get appTourSubtitle =>
      'Il tuo compagno di apprendimento delle lingue intelligente, giocoso e completamente personalizzato.';

  @override
  String get tourPage1Title =>
      'Impara e pratica ciò che vuoi e ciò di cui hai bisogno';

  @override
  String get tourPage1Desc =>
      'Il nostro sistema di apprendimento adattivo ti garantisce di rivedere gli articoli al momento perfetto, massimizzando la fidelizzazione e riducendo al minimo lo sforzo.\n\nImpara con l\'aiuto dell\'automazione integrata.\nSmetti di perdere tempo con parole che già conosci.\n\nEsercitati solo con il vocabolario e le espressioni che ti interessano. Crea e allena i tuoi oggetti, completamente personalizzati in base ai tuoi obiettivi e al tuo livello.';

  @override
  String get tourPage2Title => 'Crea il tuo pacchetto linguistico';

  @override
  String get tourPage2Desc =>
      'Crea raccolte di vocaboli personalizzate che corrispondono ai tuoi interessi e ai tuoi obiettivi di apprendimento.\n\nOrganizza parole ed espressioni per argomento, difficoltà o contesto.\n\nControllo completo su cosa impari e quando.';

  @override
  String get tourPage3Title =>
      'Creazione di oggetti basati sull\'intelligenza artificiale';

  @override
  String get tourPage3Desc =>
      'Costruisci i tuoi pacchetti di apprendimento in un batter d\'occhio:\n\n• Incolla qualsiasi testo e lascia che l\'IA estragga automaticamente il vocabolario pertinente\n• Identificare parole ed espressioni perfettamente adatte al tuo livello\n• Lascia che l\'intelligenza artificiale faccia la traduzione per te\n• Lascia che sia l\'IA a cercare esempi in tempo reale\n\nChatta con l\'IA:\n• Lascia che suggerisca parole ed espressioni per il tuo argomento\n• Fare clic per generare esempi e salvarli nel PROPRIO pacchetto\n• Creare rapidamente pacchetti pronti per la formazione';

  @override
  String get tourPage4Title =>
      'Esempi dal mondo reale basati sull\'intelligenza artificiale e traduzione premium';

  @override
  String get tourPage4Desc =>
      '• Cerca istantaneamente esempi di utilizzo autentici\n• Traduci parole, espressioni e frasi complete con l\'integrazione DeepL di alta qualità\n• Ottieni risultati accurati e sensibili al contesto';

  @override
  String get tourPage5Title => 'Organizzazione intelligente dei pacchetti';

  @override
  String get tourPage5Desc =>
      '• Organizzare il vocabolario in categorie personalizzate\n• Filtra e concentrati su argomenti specifici\n• Importa ed esporta pacchetti su più dispositivi\n• Condividere facilmente i pacchetti con gli altri';

  @override
  String get tourPage6Title => 'Allenare la tua pronuncia';

  @override
  String get tourPage6Desc =>
      'Metti alla prova e migliora la tua pronuncia con strumenti di pratica interattivi.\n\nAcquisisci sicurezza nel parlare, non solo nel leggere.';

  @override
  String get tourPage7Title => 'Per gli insegnanti';

  @override
  String get tourPage7Desc =>
      'Crea pacchetti di vocaboli pronti all\'uso per i tuoi studenti in pochi clic.\n\nEsportali, inviali alla tua classe e, una volta importati, sono immediatamente pronti per la pratica sul dispositivo di ogni studente.\n\nSemplice. Veloce. Efficace.';

  @override
  String get tourPage8Title => 'Sblocca supporto AI di alta qualità';

  @override
  String get tourPage8Desc =>
      'Per traduzioni premium e funzionalità avanzate di intelligenza artificiale, semplicemente:\n 1. Crea la tua chiave API DeepL\n 2. Crea la tua chiave API OpenAI\n 3. Incolla entrambe le chiavi nella sezione Impostazioni\n\nCiò richiede solo un budget limitato (pochi dollari), ma ti dà accesso a strumenti linguistici potenti e di livello professionale.\nNota: ti consigliamo di utilizzare l\'accesso API a pagamento per ottenere i migliori risultati. Costa solo pochi dollari.\n\n🔑 Chiave API DeepL: https://www.deepl.com/pro-api\n\n🔑 Chiave API OpenAI: https://platform.openai.com/api-keys';

  @override
  String get previousPage => 'Precedente';

  @override
  String get nextPage => 'Prossimo';

  @override
  String get endTour => 'Fine Giro';

  @override
  String pageIndicator(int current, int total) {
    return 'Pagina $current di $total';
  }

  @override
  String get practicePronunciation => 'Pratica di pronuncia';

  @override
  String get pronunciationPractice => 'Pratica di pronuncia';

  @override
  String get startPractice => 'Inizia la pratica';

  @override
  String get listenToPronunciation => 'Ascolta la pronuncia';

  @override
  String get tapToRecord => 'Tocca per registrare';

  @override
  String get recording => 'Registrazione...';

  @override
  String get recorded => 'Registrato';

  @override
  String get speakNow => 'Parla ora: parla chiaramente e vicino al microfono';

  @override
  String get noSpeechDetected => 'Nessun parlato rilevato. Per favore riprova.';

  @override
  String get noTextRecognized =>
      'Nessun discorso è stato riconosciuto nella registrazione. Assicurati che il microfono funzioni e riprova.';

  @override
  String get processingAudio =>
      'Elaborazione dell\'audio con l\'intelligenza artificiale...';

  @override
  String get playbackRecording => 'Riproduci la mia registrazione';

  @override
  String get playbackRecordingSubtitle =>
      'Ascolta la tua registrazione mentre l\'intelligenza artificiale la elabora';

  @override
  String get recordingTooShort =>
      'Registrazione troppo breve. Si prega di parlare per almeno 1 secondo.';

  @override
  String get microphonePermissionRequired =>
      'Per esercitarsi nella pronuncia è necessaria l\'autorizzazione al microfono';

  @override
  String get speechRecognitionNotSupported =>
      'Il riconoscimento vocale non è supportato su questa piattaforma. Utilizza l\'app mobile (Android/iOS) per esercitarti sulla pronuncia.';

  @override
  String get speechRecognitionUnavailable =>
      'Il riconoscimento vocale non è disponibile su questo dispositivo.';

  @override
  String get pronunciationAccuracy => 'Pronuncia\nPrecisione';

  @override
  String get excellent => 'Eccellente!';

  @override
  String get good => 'Bene';

  @override
  String get fair => 'Giusto';

  @override
  String get needsImprovement => 'Ha bisogno di miglioramenti';

  @override
  String get tryAgain => 'Riprova';

  @override
  String get nextItem => 'Articolo successivo';

  @override
  String get endPractice => 'Fine della pratica';

  @override
  String get practiced => 'Praticato';

  @override
  String get windowsAudioTestPageTitle => 'Test audio di Windows (RTAudio)';

  @override
  String get configureWindowsAudio =>
      'Testare e configurare l\'audio\ningresso su Windows';

  @override
  String get configureWindowsAudioDescription =>
      'Registra, riproduci e trascrivi l\'audio utilizzando il driver nativo di Windows RTAudio';

  @override
  String get audioTestTitle => 'Prova di registrazione audio di Windows';

  @override
  String get audioTestSubtitle =>
      'RTAudio: registrazione audio nativa di Windows';

  @override
  String get audioInputDevice => 'Dispositivo di ingresso audio';

  @override
  String get selectMicrophone => 'Seleziona Microfono';

  @override
  String get refreshDevices => 'Aggiorna dispositivi';

  @override
  String get noAudioDevicesFound => 'Nessun dispositivo di input audio trovato';

  @override
  String get loadingAudioDevices => 'Caricamento dispositivi audio...';

  @override
  String get recordingSettings => 'Impostazioni di registrazione';

  @override
  String get stereoRecording => 'Registrazione stereo';

  @override
  String get stereoChannels => '2 canali (stereo)';

  @override
  String get monoChannel => '1 canale (mono)';

  @override
  String get sampleRateLabel => 'Frequenza di campionamento';

  @override
  String get nativeRateBadge => 'nativo';

  @override
  String get microphoneGainLabel => 'Guadagno del microfono';

  @override
  String get gainHint => '1x = nessun aumento • 3x ≈ +9,5 dB • 10x ≈ +20 dB';

  @override
  String get tapToStartRec => 'Tocca per avviare la registrazione';

  @override
  String get tapToStopRec => 'Tocca per interrompere la registrazione';

  @override
  String get recordingCompleteLabel => 'Registrazione completata';

  @override
  String get tapMicToStop => 'Tocca il microfono per interrompere';

  @override
  String get playRecordingLabel => 'Riproduci la registrazione';

  @override
  String get stopPlaybackLabel => 'Fermare';

  @override
  String get whisperSectionTitle => 'Trascrizione Whisper OpenAI';

  @override
  String get whisperWavNote =>
      'WAV (PCM a 16 bit) è supportato nativamente da Whisper: non è necessaria alcuna conversione.';

  @override
  String get sendToWhisperLabel => 'Invia a Sussurro';

  @override
  String get transcribingLabel => 'Trascrizione...';

  @override
  String get transcriptionResultLabel => 'Risultato della trascrizione';

  @override
  String get transcriptionFailedLabel => 'Trascrizione non riuscita';

  @override
  String get debugInformationLabel => 'Informazioni';

  @override
  String get debugConsoleHint =>
      'Controlla la console per i registri dettagliati';

  @override
  String get debugDevicesFound => 'Dispositivi trovati';

  @override
  String get debugSelectedDevice => 'Dispositivo selezionato';

  @override
  String get debugDeviceRateNative => 'Tariffa dispositivo (nativa)';

  @override
  String get debugRequestedRate => 'Tariffa richiesta';

  @override
  String get debugActualRate => 'Tasso effettivo utilizzato';

  @override
  String get debugActualRateForced => '⚠ forzato';

  @override
  String get debugActualRateOk => '✓';

  @override
  String get debugRecordingMode => 'Modalità di registrazione';

  @override
  String get debugLastRecording => 'Ultima registrazione';

  @override
  String get debugFileSize => 'Dimensioni del file';

  @override
  String get debugStereo => 'Stereo';

  @override
  String get debugMono => 'Mono';

  @override
  String get recordingSavedSnack => 'Registrazione salvata';

  @override
  String get recordingTooShortSnack =>
      'La registrazione è troppo breve. Si prega di registrare per almeno 1 secondo.';

  @override
  String get recordingSmallSnack =>
      'Il file di registrazione è molto piccolo. La registrazione potrebbe non essere riuscita.';

  @override
  String get noAudioDataSnack => 'Nessun dato audio registrato';

  @override
  String get noDeviceSelectedSnack => 'Seleziona un dispositivo audio';

  @override
  String get failedToInitRtAudio => 'Impossibile inizializzare RTAudio';

  @override
  String get envelopeScoreLabel => 'Busta';

  @override
  String get rhythmScoreLabel => 'Ritmo';

  @override
  String get textScoreLabel => 'Testo';

  @override
  String get help => 'Aiuto';

  @override
  String get trainingHelpTitle => 'Suggerimenti per la formazione';

  @override
  String get trainingHelpText =>
      'Per rendere la tua formazione il più efficace possibile, segui questi passaggi:\n1. Fare clic sul pulsante \"Cancella contatori\" in modo che tutti gli articoli in questo pacchetto siano contrassegnati come conosciuti.\n2. Imposta \"Ambito articolo\" su \"Tutti gli articoli\"\n3. Imposta \"Ordine articolo\" su \"Casuale\"\n4. Scegli la tua lingua madre in \"Lingua di visualizzazione\"\n5. Inizia la formazione e continua finché non identifichi circa 20-30 elementi che non conosci.\n6. Torna alle impostazioni di allenamento e modifica \"Ambito elemento\" in \"Solo elementi sconosciuti\"\n7. Riprendi l\'addestramento e continua fino a quando non avrai appreso tutti gli elementi precedentemente sconosciuti.';

  @override
  String get trainingProTip =>
      'Suggerimento professionale: inizia con tutti gli articoli; in seguito, concentrati solo sulle incognite.';

  @override
  String get onboardingWelcomeTitle => 'Benvenuti al Rally delle Lingue!';

  @override
  String get onboardingSetupSubtitle => 'Configuriamo l\'app per te.';

  @override
  String get onboardingSelectUiLanguage => 'Linguaggio dell\'interfaccia';

  @override
  String get onboardingUiLanguageNote =>
      'Puoi modificarlo in seguito in Impostazioni → Lingua interfaccia utente.';

  @override
  String get onboardingNext => 'Prossimo';

  @override
  String get onboardingBack => 'Indietro';

  @override
  String get onboardingSelectPackagesTitle => 'Scegli i pacchetti linguistici';

  @override
  String get onboardingSelectPackagesSubtitle =>
      'Seleziona quali pacchetti di vocaboli importare. Puoi sempre aggiungerne altri in seguito dal menu principale (Visualizza pacchetti).';

  @override
  String get onboardingAnalyzingPackages =>
      'Analisi dei pacchetti disponibili…';

  @override
  String onboardingScanningPackagesProgress(
    int scanned,
    int total,
    int alreadyInDb,
  ) {
    return 'Scansionato $scanned/$total • già nel DB $alreadyInDb';
  }

  @override
  String get onboardingImportSelected => 'Importa selezionato';

  @override
  String get onboardingSkipImport => 'Saltare';

  @override
  String get onboardingSelectAll => 'Seleziona tutto';

  @override
  String get onboardingDeselectAll => 'Deseleziona tutto';

  @override
  String onboardingNPackages(int count) {
    return '$count pacchetti';
  }

  @override
  String get onboardingGetStarted => 'Inizia';

  @override
  String get onboardingImportCompleteTitle => 'Importazione completata!';

  @override
  String get importBuiltInPkg => 'Pacchetti gratuiti';

  @override
  String get importBuiltInPkgTooltip =>
      'Importa pacchetti linguistici in bundle gratuiti';

  @override
  String get globalSearch => 'Ricerca globale';

  @override
  String get globalSearchTitle => 'Cerca in tutti i pacchetti';

  @override
  String get globalSearchSelectLanguage => 'Seleziona il codice della lingua';

  @override
  String get globalSearchEnterWord => 'Parole da cercare';

  @override
  String get globalSearchEnterWordHint =>
      'per esempio. \"der\", \"order\" — trova corrispondenze parziali';

  @override
  String get globalSearchButton => 'Ricerca';

  @override
  String get globalSearchResults => 'Risultati';

  @override
  String globalSearchNoResults(String query) {
    return 'Nessun risultato trovato per \"$query\"';
  }

  @override
  String globalSearchResultsCount(int count) {
    return '$count risultati trovati';
  }

  @override
  String get globalSearchSearching => 'Ricerca…';

  @override
  String get globalSearchSelectLanguageFirst =>
      'Selezionare prima un codice lingua';

  @override
  String get globalSearchEnterTermFirst => 'Inserisci un termine di ricerca';

  @override
  String get globalSearchMatchInExamples => 'Trovato negli esempi';

  @override
  String get globalSearchViewItem => 'Visualizzazione';

  @override
  String get globalSearchGoToPackage => 'Vai al pacchetto';

  @override
  String get globalSearchLoadingPackages => 'Caricamento pacchetti...';

  @override
  String get globalSearchNoPackages =>
      'Nessun pacchetto linguistico ancora installato';

  @override
  String get globalSearchCancelSearch => 'Annulla ricerca';

  @override
  String globalSearchProgressOf(int current, int total) {
    return 'Ricerca del pacchetto $current di $total…';
  }

  @override
  String globalSearchCancelledMessage(int count) {
    return 'Ricerca annullata: $count risultati trovati finora';
  }

  @override
  String get storeTitle => 'Negozio di pacchetti linguistici';

  @override
  String get storeRestorePurchases => 'Ripristina gli acquisti';

  @override
  String get storeRefresh => 'Aggiorna';

  @override
  String get storeSearchHint => 'Cerca pacchetti...';

  @override
  String get storeNoPackagesMatchSearch =>
      'Nessun pacchetto corrisponde alla tua ricerca.';

  @override
  String get storeNoPackagesAvailable => 'Nessun pacchetto disponibile.';

  @override
  String storeInstalledCount(int installed, int total) {
    return '$installed / $total installato';
  }

  @override
  String get storeLoadErrorTitle => 'Impossibile caricare il negozio.';

  @override
  String get storeIapNotAvailableMessage =>
      'Gli acquisti in-app non sono disponibili su questa piattaforma. Visita il nostro sito per acquistare i pacchetti.';

  @override
  String get storeOpenWebsite => 'Apri il sito web';

  @override
  String storePurchaseSuccess(String title) {
    return '$title installato con successo!';
  }

  @override
  String get storePurchaseCancelled => 'Acquisto annullato.';

  @override
  String storePurchaseAlreadyOwned(String title) {
    return '$title è già installato.';
  }

  @override
  String get storePurchaseError =>
      'Qualcosa è andato storto. Per favore riprova.';

  @override
  String get storePurchasesRestored => 'Acquisti ripristinati';

  @override
  String get storeAllLevels => 'Tutti i livelli';

  @override
  String get storeAllGroups => 'Tutte le lingue';

  @override
  String get storeFilterLevel => 'Livello';

  @override
  String get storeFilterLanguage => 'Lingua';

  @override
  String get storeDownload => 'Scaricamento';

  @override
  String get storeBuy => 'Acquistare';

  @override
  String get storeInstalledLabel => 'Installato';

  @override
  String get storeDownloading => 'Download in corso...';

  @override
  String get storeRetry => 'Riprova';

  @override
  String get storeIapAndroidOnly =>
      'Acquisti disponibili solo su Android e iOS.';

  @override
  String get storeDismiss => 'Congedare';

  @override
  String get storeAddToCart => 'Aggiungi al carrello';

  @override
  String get storeRemoveFromCart => 'Rimuovere';

  @override
  String get storeCartTitle => 'Carrello della spesa';

  @override
  String get storeCartEmpty => 'Il tuo carrello è vuoto';

  @override
  String get storeCartClearAll => 'Cancella tutto';

  @override
  String get storeCartCheckout => 'Guardare';

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
  String get storePackageDuplicateTitle => 'Il pacchetto esiste già';

  @override
  String storePackageDuplicateMessage(String packageName, String groupName) {
    return 'Il pacchetto \"$packageName\" esiste già nel gruppo \"$groupName\". Vuoi sovrascriverlo? Il pacchetto esistente e tutti i relativi progressi formativi verranno eliminati definitivamente.';
  }

  @override
  String get storePackageDuplicateOverwrite => 'Sovrascrivi';

  @override
  String get storePackageDuplicateKeep => 'Continua ad esistere';

  @override
  String splashSettingUpPackages(int current, int total) {
    return 'Configurazione dei pacchetti: $current / $total';
  }

  @override
  String get splashThisHappensOnce => 'Questo succede solo una volta.';

  @override
  String get splashLoading => 'Caricamento…';

  @override
  String get aiItemCreator => 'Guru della chat AI';

  @override
  String get aiItemCreatorAppBarHint =>
      'Raccogli e salva parole ed espressioni chattando con l\'intelligenza artificiale';

  @override
  String get chatWithAI => 'Chatta con l\'intelligenza artificiale';

  @override
  String get enterYourPrompt => 'Inserisci la tua richiesta...';

  @override
  String get aiItemCreatorPromptHint =>
      'Descrivi un argomento e l\'allenatore dell\'intelligenza artificiale farà domande, suggerirà vocabolario utile e metterà alla prova le tue conoscenze. Ad esempio: aiutami a raccogliere ed esercitarmi sui pericoli legati al viaggiare al livello di conoscenza B2';

  @override
  String get send => 'Inviare';

  @override
  String get sending => 'Invio...';

  @override
  String get aiResponse => 'Risposta dell\'IA';

  @override
  String get itemInputs => 'Ingressi oggetto';

  @override
  String get aiItemCreatorBothItemsRequired =>
      'Compila entrambi i campi della lingua prima di salvare.';

  @override
  String get aiItemCreatorDuplicateItemMessage =>
      'In questo pacchetto esiste già un elemento con la stessa coppia di testo.';

  @override
  String get language1 => 'Lingua 1';

  @override
  String get language2 => 'Lingua 2';

  @override
  String get translateLang1ToLang2 => 'Traduci in lingua 2';

  @override
  String get translateLang2ToLang1 => 'Traduci in lingua 1';

  @override
  String translateToLanguageCode(String languageCode) {
    return 'Traduci in $languageCode';
  }

  @override
  String get example => 'Esempio';

  @override
  String get generating => 'Generazione...';

  @override
  String get flags => 'Bandiere';

  @override
  String get favorite => 'Preferito';

  @override
  String get saveItems => 'Salva';

  @override
  String get saving => 'Risparmio...';

  @override
  String get clearItems => 'Cancella solo elementi';

  @override
  String get clearAll => 'Cancella tutti i campi';

  @override
  String get itemSavedSuccessfully => 'Articolo salvato con successo';

  @override
  String get promptCannotBeEmpty => 'Il prompt non può essere vuoto';

  @override
  String get enterAtLeastOneItem => 'Inserisci almeno un elemento';

  @override
  String get selectPackageFirst => 'Seleziona prima un pacchetto';

  @override
  String get deeplKeyRequired =>
      'Per la traduzione è necessaria la chiave API DeepL';

  @override
  String get noNonPurchasedPackagesAvailable =>
      'Nessun pacchetto non acquistato disponibile';

  @override
  String get packageSelectionRemembered => 'Selezione del pacchetto salvata';

  @override
  String get aiItemCreatorOpenAiKeyNotConfiguredDetailed =>
      'La chiave API OpenAI non è configurata. Aggiungi la tua chiave API nelle Impostazioni.';

  @override
  String get aiItemCreatorOpenAiKeyNotConfigured =>
      'La chiave API OpenAI non è configurata.';

  @override
  String get aiItemCreatorProcessingComplete => 'Elaborazione completata';

  @override
  String get aiItemCreatorTranslationComingSoon =>
      'Funzionalità di traduzione in arrivo';

  @override
  String get aiItemCreatorDefaultCategoryName =>
      'Creata l\'intelligenza artificiale';

  @override
  String get aiItemCreatorStartNewConversation =>
      'Inizia una nuova conversazione';

  @override
  String get aiItemCreatorChatHint =>
      'Descrivi un argomento e l\'allenatore dell\'intelligenza artificiale farà domande, suggerirà vocabolario utile e metterà alla prova le tue conoscenze.';

  @override
  String get aiItemCreatorConversation => 'Conversazione';

  @override
  String get aiItemCreatorYou => 'Voi';

  @override
  String get aiItemCreatorCoach => 'Allenatore dell\'IA';

  @override
  String get aiItemCreatorAiSuggestions =>
      'Suggerimenti dell\'intelligenza artificiale';

  @override
  String get aiItemCreatorTapChipToFill =>
      'Tocca un chip per riempire il campo di un articolo e tradurre automaticamente.';

  @override
  String get aiItemCreatorNoSuggestedItems =>
      'Ancora nessuna parola o espressione.';

  @override
  String get aiItemCreatorNextSteps => 'Come continuare';

  @override
  String get aiItemCreatorNoNextSteps =>
      'Nessun suggerimento per la continuazione ancora.';

  @override
  String get aiItemCreatorModelCostTip =>
      'Suggerimento da professionista: i modelli più recenti sono più costosi, mentre i modelli più vecchi e quelli turbo sono più economici e possono essere notevolmente più veloci.';

  @override
  String get aiItemCreatorSelectPackageDialogTitle =>
      'Scegli il pacchetto linguistico';

  @override
  String get aiItemCreatorSelectPackageDialogMessage =>
      'Seleziona il pacchetto lingue da utilizzare per questa sessione. La tua ultima scelta è preselezionata.';

  @override
  String aiItemCreatorMissingApiKeysWarning(String keys) {
    return 'Chiavi API mancanti: $keys. Puoi continuare, ma le funzionalità di intelligenza artificiale e di traduzione premium potrebbero essere limitate.';
  }

  @override
  String get about => 'Di';

  @override
  String get aboutWebsite => 'Sito web';

  @override
  String get aboutSummaryVideo => 'Video riassuntivo';

  @override
  String get aboutSupportEmail => 'Indirizzo e-mail di supporto';

  @override
  String get aboutWebsiteUrl => 'https://sites.google.com/view/lingual-rally';

  @override
  String get aboutSummaryVideoUrl =>
      'https://www.youtube.com/watch?v=64Pl9iNF88c';

  @override
  String get aboutSupportEmailAddress => 'Languagerally.support@gmail.com';

  @override
  String aboutVersionWithValue(String version) {
    return 'Versione: $version';
  }

  @override
  String aboutCouldNotOpen(String uri) {
    return 'Impossibile aprire: $uri';
  }

  @override
  String get aboutWelcomeSplashNotFound =>
      'Immagine splash di benvenuto non trovata';

  @override
  String get chooseTheme => 'Scegli Tema';

  @override
  String get darkMode => 'Modalità oscura';

  @override
  String get toggleBetweenLightAndDark => 'Alterna tra chiaro e scuro';

  @override
  String get colorTheme => 'Tema colore:';

  @override
  String get toggleBrightness => 'Attiva/disattiva la luminosità';

  @override
  String get changeTheme => 'Cambia tema';

  @override
  String get managePackageGroups => 'Gestisci gruppi di pacchetti';

  @override
  String get noPackageGroups => 'Nessun gruppo di pacchetti';

  @override
  String get createFirstPackageGroup => 'Crea il tuo primo gruppo di pacchetti';

  @override
  String get addGroup => 'Aggiungi gruppo';

  @override
  String get addPackageGroup => 'Aggiungi gruppo di pacchetti';

  @override
  String get editPackageGroup => 'Modifica gruppo di pacchetti';

  @override
  String get groupName => 'Nome del gruppo';

  @override
  String get enterGroupName => 'Inserisci il nome del gruppo';

  @override
  String get groupNameRequired => 'Il nome del gruppo è obbligatorio';

  @override
  String get duplicateGroupName => 'Nome duplicato';

  @override
  String groupNameAlreadyExists(String name) {
    return 'Esiste già un gruppo con il nome \"$name\".';
  }

  @override
  String groupCreatedSuccessfully(String name) {
    return 'Il gruppo \"$name\" è stato creato correttamente';
  }

  @override
  String failedToCreateGroup(String error) {
    return 'Impossibile creare il gruppo: $error';
  }

  @override
  String groupRenamedTo(String name) {
    return 'Gruppo rinominato in \"$name\"';
  }

  @override
  String failedToUpdateGroup(String error) {
    return 'Impossibile aggiornare il gruppo: $error';
  }

  @override
  String get deleteGroup => 'Elimina gruppo';

  @override
  String deleteGroupConfirm(String name) {
    return 'Sei sicuro di voler eliminare il gruppo \"$name\"?\n\nQuesta azione non può essere annullata.';
  }

  @override
  String get cannotDeleteGroup => 'Impossibile eliminare';

  @override
  String groupHasPackages(int count) {
    return 'Questo gruppo ha ancora pacchetti $count. Per favore spostali o eliminali prima.';
  }

  @override
  String groupDeleted(String name) {
    return 'Gruppo \"$name\" eliminato';
  }

  @override
  String failedToDeleteGroup(String error) {
    return 'Impossibile eliminare il gruppo: $error';
  }

  @override
  String get cannotDeleteHasPackagesTooltip =>
      'Impossibile eliminare (ha pacchetti)';

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
  String get manageGroups => 'Gestisci gruppi';

  @override
  String get featureLangPower => 'Potere del linguaggio';

  @override
  String get featureAiIntegration =>
      'Integrazione dell\'intelligenza artificiale';

  @override
  String get featureAdaptivePractice => 'Pratica adattiva';

  @override
  String get featureMasterAccent => 'Accento maestro';

  @override
  String get allBadgesEarned => '🎉 Tutti i badge guadagnati! Sei un Maestro!';

  @override
  String nextBadgeLabel(String name) {
    return 'Successivo: $name';
  }

  @override
  String pointsToGo(String percent) {
    return '$percent% rimanente';
  }

  @override
  String progressPercent(String percent) {
    return '$percent% di progresso';
  }

  @override
  String errorTogglingFavourite(String error) {
    return 'Errore durante l\'attivazione/disattivazione dei preferiti: $error';
  }

  @override
  String errorTogglingImportant(String error) {
    return 'Errore durante la commutazione tra importanti: $error';
  }

  @override
  String categoryAdded(String name) {
    return 'Aggiunta la categoria \"$name\".';
  }

  @override
  String errorAddingCategory(String error) {
    return 'Errore durante l\'aggiunta della categoria: $error';
  }

  @override
  String categoryRemoved(String name) {
    return 'Categoria \"$name\" rimossa';
  }

  @override
  String errorRemovingCategory(String error) {
    return 'Errore durante la rimozione della categoria: $error';
  }

  @override
  String couldNotOpenUrl(String url) {
    return 'Impossibile aprire l\'URL: $url';
  }

  @override
  String errorOpeningUrl(String error) {
    return 'Errore durante l\'apertura dell\'URL: $error';
  }

  @override
  String get pleaseSelectLanguage => 'Seleziona una lingua';

  @override
  String get add => 'Aggiungere';

  @override
  String get speak => 'Parlare';

  @override
  String get recordingFailedToStart =>
      'Impossibile avviare la registrazione!\n\nControlla:\n1. Il microfono è collegato\n2. Il microfono è impostato come dispositivo predefinito\n3. Nessun\'altra app utilizza il microfono';

  @override
  String get recordingFailedNoAudioFile =>
      'Registrazione fallita: nessun file audio creato!\n\nPossibili cause:\n1. Microfono non collegato\n2. Nessun ingresso audio rilevato\n3. Problema relativo alle impostazioni audio di Windows';

  @override
  String errorStartingRecordingDetails(String error) {
    return 'Errore durante l\'avvio della registrazione: $error';
  }

  @override
  String get openaiEmptyResponse =>
      'Il modello AI selezionato ha restituito una risposta vuota';

  @override
  String get tryDifferentModel =>
      'Prova a selezionare un modello diverso dal selettore del modello';

  @override
  String get modelMayNotBeSupported =>
      'Questo modello potrebbe non essere supportato o disponibile per il tuo account';

  @override
  String get reduceTextOrRetry => 'Riduci la lunghezza del testo o riprova';

  @override
  String get openaiNullContent =>
      'Il modello AI selezionato non ha restituito alcun contenuto';

  @override
  String get modelUnsupportedParameter =>
      'Il modello selezionato non supporta un parametro API richiesto';
}
