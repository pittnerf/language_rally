// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get helloWorld => 'Hallo Welt!';

  @override
  String get welcome => 'Willkommen bei der Sprachrallye';

  @override
  String get appTitle => 'Sprachrallye';

  @override
  String get createPackage => 'Paket erstellen';

  @override
  String get editPackage => 'Paket bearbeiten';

  @override
  String get packageDetails => 'Paketdetails';

  @override
  String get packageName => 'Paketname';

  @override
  String get packageNameHint =>
      'z. B. Spanisch-Grundkenntnisse, Deutsch-Grundkenntnisse';

  @override
  String get languageCode1 => 'Quellsprachcode';

  @override
  String get languageName1 => 'Name der Quellsprache';

  @override
  String get languageCode2 => 'Zielsprachencode';

  @override
  String get languageName2 => 'Name der Zielsprache';

  @override
  String get description => 'Beschreibung';

  @override
  String get descriptionHint => 'Kurze Beschreibung dieses Sprachpakets';

  @override
  String get authorName => 'Name des Autors';

  @override
  String get authorEmail => 'E-Mail des Autors';

  @override
  String get authorWebpage => 'Autoren-Webseite';

  @override
  String get version => 'Version';

  @override
  String get items => 'Artikel';

  @override
  String get packageIcon => 'Paketsymbol';

  @override
  String get packageGroup => 'Paketgruppe';

  @override
  String get selectIcon => 'Wählen Sie Symbol';

  @override
  String get defaultIcon => 'Standardsymbol';

  @override
  String get customIcon => 'Benutzerdefiniertes Symbol';

  @override
  String get upload => 'Hochladen-Symbol';

  @override
  String get uploadCustomIcon =>
      'Benutzerdefiniertes Symbol hochladen (max. 512 x 512, 1 MB)';

  @override
  String get customIconUploaded =>
      'Benutzerdefiniertes Symbol erfolgreich hochgeladen';

  @override
  String get save => 'Speichern';

  @override
  String get edit => 'Bearbeiten';

  @override
  String get cancel => 'Stornieren';

  @override
  String get delete => 'Löschen';

  @override
  String get confirmDelete =>
      'Sind Sie sicher, dass Sie dieses Paket löschen möchten?';

  @override
  String get packageSaved => 'Paket erfolgreich gespeichert';

  @override
  String get packageDeleted => 'Paket erfolgreich gelöscht';

  @override
  String get errorSavingPackage => 'Fehler beim Speichern des Pakets';

  @override
  String get errorDeletingPackage => 'Fehler beim Löschen des Pakets';

  @override
  String get fieldRequired => 'Dieses Feld ist erforderlich';

  @override
  String get invalidEmail => 'Ungültige E-Mail-Adresse';

  @override
  String get readOnlyPackage =>
      'Dieses Paket ist schreibgeschützt und kann nicht bearbeitet werden';

  @override
  String get purchasedPackage =>
      'Gekaufte Pakete können nicht bearbeitet werden';

  @override
  String get badges => 'Abzeichen';

  @override
  String get noBadges => 'Noch keine Abzeichen verdient';

  @override
  String get selectLanguageCode => 'Wählen Sie Sprachcode aus';

  @override
  String get typeToSearchLanguages =>
      'Geben Sie ein, um nach Sprachen zu suchen...';

  @override
  String get search => 'Suchen...';

  @override
  String get clearCounters => 'Zähler löschen';

  @override
  String get confirmClearCounters =>
      'Sind Sie sicher, dass Sie alle Trainingszähler für dieses Paket löschen möchten? Dadurch werden die „Weiß nicht“-Zähler und Trainingsstatistiken zurückgesetzt.';

  @override
  String get clear => 'Klar';

  @override
  String get countersCleared => 'Zähler erfolgreich gelöscht';

  @override
  String get errorClearingCounters => 'Fehler beim Löschen der Zähler';

  @override
  String get deleteAll => 'Paket löschen';

  @override
  String get confirmDeleteAllData =>
      'Sind Sie sicher, dass Sie dieses Paket mit ALLEN Daten löschen möchten? Dadurch werden alle Kategorien, Elemente und Trainingsstatistiken dauerhaft gelöscht. Diese Aktion kann nicht rückgängig gemacht werden!';

  @override
  String get allDataDeleted => 'Paket und alle Daten erfolgreich gelöscht';

  @override
  String get exportPackage => 'Paket exportieren';

  @override
  String get selectExportLocation => 'Wählen Sie Exportort aus';

  @override
  String get packageExported => 'Paket erfolgreich exportiert';

  @override
  String get errorExportingPackage => 'Fehler beim Exportieren des Pakets';

  @override
  String get importItems => 'Elemente importieren (JSON)';

  @override
  String get importItemsDialogTitle => 'Elemente importieren (JSON)';

  @override
  String get importItemsFromLocalJson => 'Import aus lokaler JSON-Datei';

  @override
  String get enterItemsUrl => 'JSON-URL der Elemente (https://…)';

  @override
  String get downloadingItems => 'Artikel werden heruntergeladen…';

  @override
  String get selectImportFile => 'Wählen Sie Datei importieren';

  @override
  String get importFormat => 'Format importieren';

  @override
  String get importFormatDescription =>
      'Importieren Sie Elemente aus einer Textdatei. Jede Zeile sollte ein Element im folgenden Format enthalten:';

  @override
  String get importResults => 'Ergebnisse importieren';

  @override
  String get successfullyImported => 'Erfolgreich importiert';

  @override
  String get failedToImport => 'Import fehlgeschlagen';

  @override
  String get error => 'Fehler';

  @override
  String get ok => 'OK';

  @override
  String get importPackage => 'Paket importieren';

  @override
  String get importPackageTooltip => 'Paket aus ZIP-Datei oder URL importieren';

  @override
  String get importPackageDialogTitle => 'Sprachpaket importieren';

  @override
  String get importFromLocalFile => 'Aus lokaler Datei importieren';

  @override
  String get importFromUrl => 'Von URL importieren';

  @override
  String get enterPackageUrl => 'Paket-URL (https://…)';

  @override
  String get downloadingPackage => 'Paket wird heruntergeladen…';

  @override
  String get downloadFailed =>
      'Der Download ist fehlgeschlagen. Bitte überprüfen Sie die URL und Ihre Internetverbindung.';

  @override
  String get invalidUrl =>
      'Bitte geben Sie eine gültige http://- oder https://-URL ein.';

  @override
  String get orLabel => 'oder';

  @override
  String get selectPackageZipFile => 'Wählen Sie „ZIP-Datei paketieren“.';

  @override
  String get couldNotAccessFile =>
      'Auf die ausgewählte Datei konnte nicht zugegriffen werden.';

  @override
  String get importingPackage => 'Paket wird importiert...';

  @override
  String get packageImportedSuccessfully => 'Paket erfolgreich importiert!';

  @override
  String packageImportedWithItems(Object count) {
    return 'Paket erfolgreich importiert! ($count Artikel)';
  }

  @override
  String packageImportedWithGroup(Object count, Object groupName) {
    return 'Paket in die Gruppe „$groupName“ importiert! ($count Artikel)';
  }

  @override
  String get importError => 'Importfehler';

  @override
  String get failedToImportPackage => 'Paket konnte nicht importiert werden';

  @override
  String get packageAlreadyExists => 'Paket existiert bereits';

  @override
  String packageExistsMessage(Object groupName) {
    return 'In der Gruppe „$groupName“ ist bereits ein Paket mit demselben Sprachpaar, derselben Beschreibung, denselben Autoreninformationen und derselben Version vorhanden. Möchten Sie es trotzdem als neues Paket importieren?';
  }

  @override
  String get importAsNew => 'Trotzdem importieren';

  @override
  String get zipFileNotFound => 'ZIP-Datei nicht gefunden';

  @override
  String get invalidPackageZip =>
      'Ungültige Paket-ZIP: package_data.json fehlt';

  @override
  String get invalidPackageFormat => 'Ungültiges Paketdateiformat';

  @override
  String get languagePackages => 'Sprachpakete';

  @override
  String get loadingPackages => 'Pakete werden geladen...';

  @override
  String get tapAndHoldToReorder =>
      'Tippen und halten Sie, um die Karten neu anzuordnen';

  @override
  String get tapAndHoldToReorderList =>
      'Tippen und halten Sie ≡, um die Reihenfolge neu anzuordnen. • Tippen Sie auf ⋮, um die Kompaktansicht umzuschalten';

  @override
  String get noPackagesYet => 'Noch keine Pakete';

  @override
  String get createFirstPackage => 'Erstellen Sie Ihr erstes Sprachpaket';

  @override
  String get versionLabel => 'Version';

  @override
  String get purchased => 'Gekauft';

  @override
  String get compactView => 'kompakt';

  @override
  String get expand => 'Expandieren';

  @override
  String get allCategories => 'Alle Kategorien';

  @override
  String get categoriesInPackage => 'Kategorien in diesem Paket';

  @override
  String get categories => 'Kategorien';

  @override
  String get testInterFonts => 'Testen Sie Inter-Schriftarten';

  @override
  String get viewPackages => 'Pakete anzeigen';

  @override
  String get simplifiedPackageView => 'Paketliste';

  @override
  String get createNewPackage => 'Neues Paket erstellen';

  @override
  String get generateTestData => 'Testdaten generieren';

  @override
  String get designSystemShowcase => 'Design-System-Showcase';

  @override
  String get badgeEarned => 'Abzeichen verdient!';

  @override
  String get achievement => 'Leistung';

  @override
  String get awesome => 'Eindrucksvoll!';

  @override
  String get importFormatNotes => 'Hinweise:';

  @override
  String get importFormatLine1 => '• Jede Zeile repräsentiert ein Element';

  @override
  String get importFormatLine2 => '• Felder werden durch | getrennt';

  @override
  String get importFormatLine3 => '• Kategorien werden durch ; getrennt.';

  @override
  String get importFormatLine4 => '• Das letzte | ist optional';

  @override
  String get importFormatLine5 => '• Leerzeilen werden ignoriert';

  @override
  String get importFormatLine6 => '• Duplikate werden übersprungen';

  @override
  String get importFormatNewDescription =>
      'Importieren Sie Elemente aus einer Textdatei. Jede Zeile sollte ein Element mit durch --- getrennten Feldern enthalten.';

  @override
  String get importFormatNewLine1 => '• Haupttrennzeichen: ---';

  @override
  String get importFormatNewLine2 =>
      '• L1=<text> – Haupttext der Sprache 1 (erforderlich, wenn L2 fehlt)';

  @override
  String get importFormatNewLine3 =>
      '• L2=<text> – Haupttext der Sprache 2 (erforderlich, wenn L1 fehlt)';

  @override
  String get importFormatNewLine4 =>
      '• L1pre=<text> – Präfix für Sprache 1 (optional)';

  @override
  String get importFormatNewLine5 =>
      '• L1post=<text> – Suffix für Sprache 1 (optional)';

  @override
  String get importFormatNewLine6 =>
      '• L2pre=<text> – Präfix für Sprache 2 (optional)';

  @override
  String get importFormatNewLine7 =>
      '• L2post=<text> – Suffix für Sprache 2 (optional)';

  @override
  String get importFormatNewLine8 =>
      '• EX=<L1-Text>:::<L2-Text> – Beispiel (optional, kann mehrere sein)';

  @override
  String get importFormatNewLine9 =>
      '• CAT=<cat1>:::<cat2>:::<cat3> – Kategorien (optional)';

  @override
  String get importFormatNewLine10 =>
      '• Mindestens einer von L1= oder L2= muss vorhanden sein';

  @override
  String get importFormatNewLine11 => '• Leerzeilen werden ignoriert';

  @override
  String get importFormatNewLine12 => '• Duplikate werden übersprungen';

  @override
  String get invalidImportLine => 'Ungültige Zeile';

  @override
  String get missingRequiredFields => '„L1=“ fehlt vagy „L2=“';

  @override
  String get unknownField => 'Unbekanntes Feldpräfix';

  @override
  String andMore(Object count) {
    return '... und $count mehr';
  }

  @override
  String get browseItems => 'Durchsuchen Sie Elemente';

  @override
  String get itemDetails => 'Einzelheiten';

  @override
  String get filterItems => 'Elemente filtern';

  @override
  String searchLanguage1(Object language) {
    return 'Suche in $language';
  }

  @override
  String searchLanguage2(Object language) {
    return 'Suche in $language';
  }

  @override
  String get caseSensitive => 'Groß- und Kleinschreibung beachten';

  @override
  String get knownStatus => 'Bekannter Status';

  @override
  String get filterStatusAll => 'alle';

  @override
  String get filterStatusKnown => 'bekannt';

  @override
  String get filterStatusUnknown => 'unbekannt';

  @override
  String get allItems => 'Alle Artikel';

  @override
  String get itemsIKnew => 'Gegenstände, die ich kannte';

  @override
  String get itemsIDidNotKnow => 'Artikel, die ich nicht kannte';

  @override
  String get known => 'Bekannt';

  @override
  String get unknown => 'Unbekannt';

  @override
  String get important => 'Wichtig';

  @override
  String get favourite => 'Favorit';

  @override
  String get badge => 'Abzeichen';

  @override
  String get position => 'Position';

  @override
  String get stepsUntilLearned => 'Schritte bis gelernt';

  @override
  String get examples => 'Beispiele';

  @override
  String get noExamples => 'Keine Beispiele verfügbar';

  @override
  String get pronounce => 'Aussprechen';

  @override
  String get ttsError => 'Text-to-Speech nicht verfügbar';

  @override
  String get noItemsFound => 'Keine Artikel gefunden';

  @override
  String get noItemsInPackage =>
      'In diesem Paket sind noch keine Artikel enthalten';

  @override
  String get addItem => 'Artikel hinzufügen';

  @override
  String get emptyPackageHint =>
      'Fügen Sie Artikel manuell hinzu oder verwenden Sie KI, um Artikel schnell zu importieren';

  @override
  String get noItemsToTrain =>
      'Mit den aktuellen Einstellungen sind keine Elemente zum Üben verfügbar';

  @override
  String get clearFilters => 'Klar';

  @override
  String itemCount(Object count) {
    return '$count Artikel';
  }

  @override
  String filteredItemCount(Object filtered, Object total) {
    return '$filtered von $total Artikeln';
  }

  @override
  String get trainingRally => 'Trainingsrallye';

  @override
  String get startTraining => 'Beginnen Sie mit dem Training';

  @override
  String get trainingComingSoon => 'Trainingsrallye – bald verfügbar!';

  @override
  String get aiServiceNotConfigured =>
      'AI-Dienst nicht konfiguriert. Bitte fügen Sie Ihren OpenAI-API-Schlüssel hinzu.';

  @override
  String pleaseEnterTextInLanguageFirst(Object language) {
    return 'Bitte geben Sie zuerst Text in $language ein';
  }

  @override
  String translationCompletedSuccessfully(Object service) {
    return 'Übersetzung mit $service erfolgreich abgeschlossen!';
  }

  @override
  String get translationFailed => 'Die Übersetzung ist fehlgeschlagen';

  @override
  String addedExamplesSuccessfully(Object count) {
    return '$count Beispiele erfolgreich hinzugefügt!';
  }

  @override
  String get failedToGenerateExamples =>
      'Beispiele konnten nicht generiert werden';

  @override
  String get selectExamplesToAdd => 'Wählen Sie Beispiele zum Hinzufügen aus';

  @override
  String get selectWhichExamples =>
      'Wählen Sie aus, welche Beispiele Sie diesem Artikel hinzufügen möchten:';

  @override
  String get addSelected => 'Ausgewählte hinzufügen';

  @override
  String get pleaseSelectAtLeastOne =>
      'Bitte wählen Sie mindestens ein Beispiel aus';

  @override
  String get addNewItem => 'Neues Element hinzufügen';

  @override
  String get editItem => 'Element bearbeiten';

  @override
  String get deleteItem => 'Artikel löschen';

  @override
  String get confirmDeleteItem =>
      'Sind Sie sicher, dass Sie dieses Element löschen möchten?';

  @override
  String get thisActionCannotBeUndone =>
      'Diese Aktion kann nicht rückgängig gemacht werden.';

  @override
  String get itemDeleted => 'Artikel gelöscht';

  @override
  String get errorDeletingItem => 'Fehler beim Löschen des Elements';

  @override
  String get errorSavingItem => 'Fehler beim Speichern des Artikels';

  @override
  String get itemSaved => 'Artikel erfolgreich aktualisiert';

  @override
  String get itemCreated => 'Artikel erfolgreich erstellt';

  @override
  String get preTextOptional => 'Vortext (optional)';

  @override
  String get mainText => 'Haupttext';

  @override
  String get postTextOptional => 'Posttext (optional)';

  @override
  String get forExampleToForVerbs => 'z. B. „to“ für Verben';

  @override
  String get additionalContext => 'Zusätzlicher Kontext';

  @override
  String get translate => 'Übersetzen';

  @override
  String translateFromTo(Object from, Object to) {
    return 'Übersetze $from → $to';
  }

  @override
  String get aiExampleGeneration => 'Generierung von KI-Beispielen';

  @override
  String get aiExampleSearch => 'KI-Beispielsuche';

  @override
  String searchExamplesOnInternet(Object text) {
    return 'Suchen Sie im Internet mithilfe von KI nach Beispielsätzen für „$text“.';
  }

  @override
  String generateExampleSentences(Object language) {
    return 'Generieren Sie Beispielsätze basierend auf dem Haupttext in $language';
  }

  @override
  String get voiceInput => 'Spracheingabe';

  @override
  String get settings => 'Einstellungen';

  @override
  String get uiLanguage => 'UI-Sprache';

  @override
  String get uiLanguageDescription => 'Sprache der Anwendungsoberfläche';

  @override
  String get uiLanguageHelper =>
      'Wählen Sie die Sprache für Menüs, Schaltflächen und Beschriftungen aus';

  @override
  String get userLanguage => 'Benutzersprache';

  @override
  String get userLanguageDescription =>
      'Ihre bevorzugte Muttersprache für die Erstellung neuer Sprachpakete';

  @override
  String get apiKeys => 'API-Schlüssel';

  @override
  String get deeplApiKey => 'DeepL-API-Schlüssel';

  @override
  String get deeplApiKeyDescription =>
      'Für erstklassige Übersetzungsqualität beim Bearbeiten von Sprachelementen. Siehe https://www.deepl.com/pro-api';

  @override
  String get openaiApiKey => 'OpenAI-API-Schlüssel';

  @override
  String get openaiApiKeyDescription =>
      'Zum Beispiel die Generierung mit KI beim Bearbeiten von Sprachelementen. Siehe https://platform.openai.com/api-keys';

  @override
  String get enterApiKey => 'Geben Sie den API-Schlüssel ein';

  @override
  String get optional => 'optional';

  @override
  String get required => 'erforderlich';

  @override
  String get settingsSaved => 'Einstellungen erfolgreich gespeichert';

  @override
  String get errorSavingSettings => 'Fehler beim Speichern der Einstellungen';

  @override
  String get usingGoogleTranslate => 'Mit dem kostenlosen Google Translate';

  @override
  String get usingDeepL => 'Verwendung von DeepL (Premium)';

  @override
  String get noTranslationReceivedFromGoogle =>
      'Keine Übersetzung von Google erhalten';

  @override
  String get googleTranslationFailed =>
      'Die Google-Übersetzung ist fehlgeschlagen';

  @override
  String get googleTranslationError => 'Google-Übersetzungsfehler';

  @override
  String get noTranslationReceivedFromDeepL =>
      'Keine Übersetzung von DeepL erhalten';

  @override
  String get invalidDeepLApiKey => 'Ungültiger DeepL-API-Schlüssel';

  @override
  String get deeplTranslationQuotaExceeded =>
      'DeepL-Übersetzungskontingent überschritten';

  @override
  String get deeplTranslationFailed =>
      'Die DeepL-Übersetzung ist fehlgeschlagen';

  @override
  String get deeplTranslationError => 'DeepL-Übersetzungsfehler';

  @override
  String get invalidApiKeyConfigureOpenAI =>
      'Ungültiger API-Schlüssel. Bitte konfigurieren Sie Ihren OpenAI-API-Schlüssel.';

  @override
  String get apiRateLimitExceeded =>
      'API-Ratenlimit überschritten. Bitte versuchen Sie es später noch einmal.';

  @override
  String get aiRequestFailed => 'AI-Anfrage ist fehlgeschlagen';

  @override
  String get failedToParseAiResponse =>
      'Die KI-Antwort konnte nicht analysiert werden. Bitte versuchen Sie es erneut.';

  @override
  String get aiGenerationError => 'Fehler bei der KI-Generierung';

  @override
  String get voiceInputPlaceholder =>
      'Die Spracheingabe wird mit dem Speech_to_text-Paket implementiert';

  @override
  String get improveQualityWithApiKeys =>
      '💡 Tipp: Die Qualität von Übersetzungen und Beispielsuchen kann deutlich verbessert werden, indem Sie Ihre DeepL- und OpenAI-API-Schlüssel in den Anwendungseinstellungen hinzufügen.';

  @override
  String get noApiKeyFallbackMessage =>
      'Ohne API-Schlüssel werden eine grundlegende Übersetzung und begrenzte Beispiele bereitgestellt. Um optimale Ergebnisse zu erzielen, konfigurieren Sie Ihre API-Schlüssel in den Einstellungen.';

  @override
  String get listeningForSpeech => 'Zuhören... Sprechen Sie jetzt';

  @override
  String get speechRecognitionNotAvailable =>
      'Die Spracherkennung ist auf diesem Gerät nicht verfügbar';

  @override
  String get speechRecognitionPermissionDenied =>
      'Die Erlaubnis zur Spracherkennung wurde verweigert';

  @override
  String get speechRecognitionError => 'Spracherkennungsfehler';

  @override
  String get tapToSpeak => 'Tippen Sie zum Sprechen auf das Mikrofon';

  @override
  String get tapToStop => 'Tippen Sie, um die Aufnahme zu beenden';

  @override
  String get speechNotRecognized =>
      'Es wurde keine Rede erkannt. Bitte versuchen Sie es erneut.';

  @override
  String get usingWhisperApiSlower =>
      'Verwendung von Cloud-KI zur Spracherkennung (möglicherweise langsamer)';

  @override
  String languageNotSupportedAddApiKey(String languageCode) {
    return 'Sprache $languageCode wird nativ nicht unterstützt. Fügen Sie den OpenAI-API-Schlüssel in den Einstellungen für die KI-gestützte Spracherkennung hinzu.';
  }

  @override
  String get recordingTapToStop =>
      'Aufnahme... Tippen Sie erneut, um zu stoppen';

  @override
  String get speakClearlyKeepRecording =>
      'Sprechen Sie deutlich. Nehmen Sie mindestens 1 Sekunde auf.';

  @override
  String get pleaseRecordLonger =>
      'Bitte sprechen Sie mindestens 1 Sekunde lang und tippen Sie dann auf Stopp.';

  @override
  String get errorStartingRecording => 'Fehler beim Starten der Aufnahme';

  @override
  String get noAudioRecorded => 'Es wurde kein Ton aufgenommen';

  @override
  String get errorTranscribing => 'Fehler beim Transkribieren des Audios';

  @override
  String get trainingSettings => 'Trainingseinstellungen';

  @override
  String get trainingPresetTitle => 'Schnelle Einrichtung';

  @override
  String get trainingPresetHint =>
      'Wählen Sie eine Voreinstellung und die folgenden Einstellungen werden automatisch konfiguriert.';

  @override
  String get trainingPresetComboLabel => 'Voreingestellt';

  @override
  String get trainingPresetAllExamplesForeignLanguage =>
      'Alle Beispiele, Fremdsprache';

  @override
  String get trainingPresetAllExamplesRandomLanguage =>
      'Alle Beispiele, zufällige Sprache';

  @override
  String get trainingPresetFavouriteItemsForeignLanguage =>
      'Lieblingsartikel, Fremdsprache';

  @override
  String get trainingPresetFavouriteItemsRandomLanguage =>
      'Lieblingsartikel, zufällige Sprache';

  @override
  String get trainingPresetImportantItemsForeignLanguage =>
      'Wichtige Gegenstände, Fremdsprache';

  @override
  String get trainingPresetImportantItemsRandomLanguage =>
      'Wichtige Elemente, zufällige Sprache';

  @override
  String get trainingPresetRandomItemsRandomLanguage =>
      'Zufällige Elemente, zufällige Sprache';

  @override
  String get trainingPresetUnknownItemsForeignLanguage =>
      'Unbekannte Artikel, Fremdsprache';

  @override
  String get trainingPresetUnknownItemsRandomLanguage =>
      'Unbekannte Elemente, zufällige Sprache';

  @override
  String trainingPresetAppliedTapStart(String actionLabel) {
    return 'Voreinstellung angewendet. Tippen Sie zum Starten auf „$actionLabel“.';
  }

  @override
  String get trainingPresetSelectPackageFirst =>
      'Bitte wählen Sie zunächst ein Paket aus.';

  @override
  String get itemScope => 'Artikelumfang';

  @override
  String get lastNItems => 'Letzte N Artikel';

  @override
  String get onlyUnknown => 'Nur unbekannte Artikel';

  @override
  String get onlyImportant => 'Nur wichtige Artikel';

  @override
  String get onlyFavourite => 'Nur Lieblingsartikel';

  @override
  String get numberOfItems => 'Anzahl der Artikel';

  @override
  String get itemOrder => 'Artikelbestellung';

  @override
  String get randomOrder => 'Zufällige Reihenfolge';

  @override
  String get sequentialOrder => 'Reihenfolge';

  @override
  String get itemType => 'Artikeltyp';

  @override
  String get dictionaryItems => 'Wörterbuchelemente';

  @override
  String get examplesType => 'Beispiele';

  @override
  String get displayLanguage => 'Anzeigesprache';

  @override
  String get motherTongue => 'Muttersprache';

  @override
  String get targetLanguage => 'Zielsprache';

  @override
  String get randomLanguage => 'Zufällig';

  @override
  String get categoryFilter => 'Kategoriefilter';

  @override
  String get categoryFilterHint =>
      'Wählen Sie die einzuschließenden Kategorien aus (leer = alle Kategorien).';

  @override
  String get noCategories => 'Keine Kategorien verfügbar';

  @override
  String get dontKnowThreshold => 'Schwellenwert nicht bekannt';

  @override
  String get dontKnowThresholdHint =>
      'Häufigkeit, mit der ein Artikel vor einer Sonderbehandlung als „Weiß nicht“ markiert werden muss';

  @override
  String get startTrainingRally => 'Starten Sie die Trainingsrallye';

  @override
  String get clearTrainingSettings => 'Einstellungen löschen';

  @override
  String get confirmClearTrainingSettings =>
      'Sind Sie sicher, dass Sie alle Trainingseinstellungen auf die Standardwerte zurücksetzen möchten?';

  @override
  String get trainingSettingsCleared =>
      'Die Trainingseinstellungen wurden gelöscht';

  @override
  String get startingTraining => 'Trainingsbeginn...';

  @override
  String get noMoreItemsToDisplay =>
      'Aufgrund Ihrer Filtereinstellungen können keine Elemente angezeigt werden.';

  @override
  String get noItems => 'Keine Artikel';

  @override
  String get trainingComplete => 'Schulung abgeschlossen';

  @override
  String get allItemsCompleted =>
      'Glückwunsch! Sie haben alle Punkte dieser Schulungssitzung abgeschlossen.';

  @override
  String get closeTraining => 'Enges Training';

  @override
  String get confirmCloseTraining =>
      'Möchten Sie die Schulung wirklich schließen? Ihr Fortschritt wurde gespeichert.';

  @override
  String get question => 'Frage';

  @override
  String get answer => 'Antwort';

  @override
  String get iKnow => 'Ich weiß';

  @override
  String get iDontKnow => 'Ich weiß nicht';

  @override
  String get previousItem => 'Vorheriger Artikel';

  @override
  String get iDidNotKnowEither => 'Ich wusste es doch nicht';

  @override
  String get exportBeforeDelete => 'Vor dem Löschen exportieren?';

  @override
  String get aiTextAnalysis =>
      'Extrahieren Sie Elemente aus einem Text/einer Liste mit KI';

  @override
  String get aiTextAnalysisImport =>
      'Extrahieren Sie Elemente aus einem Text oder einer Liste mit dem AI Text Analysis Tool';

  @override
  String get knowledgeLevel => 'Wissensstand';

  @override
  String get a1Beginner => 'A1 – Anfänger';

  @override
  String get a2Elementary => 'A2 – Grundstufe';

  @override
  String get b1Intermediate => 'B1 – Mittelstufe';

  @override
  String get b2UpperIntermediate => 'B2 – Obere Mittelstufe';

  @override
  String get c1Advanced => 'C1 – Fortgeschritten';

  @override
  String get c2Proficient => 'C2 – Kompetent';

  @override
  String get pasteTextHere => 'Fügen Sie hier Ihren Text ein...';

  @override
  String get extractWords => 'Wörter extrahieren';

  @override
  String get extractExpressions => 'Ausdrücke extrahieren';

  @override
  String get maxItems => 'Maximale Anzahl neuer Artikel';

  @override
  String get maxItemsHint => 'Für keine Begrenzung leer lassen';

  @override
  String get generateExamples => 'Beispiele generieren';

  @override
  String get categoryName => 'Kategoriename';

  @override
  String get categoryNameHint =>
      'Name für die Kategorie der importierten Elemente';

  @override
  String get analyzeText => 'Text analysieren';

  @override
  String get configureAnalysis =>
      'Konfigurieren Sie die zu extrahierenden Elemente';

  @override
  String get openaiModel => 'KI-Modell';

  @override
  String get openaiModelDescription => 'Wählen Sie das ChatGPT-Modell aus';

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
      'Neuestes Flaggschiff mit ausgewogener Qualität und Geschwindigkeit für den allgemeinen Gebrauch';

  @override
  String get modelGpt55ProDesc =>
      'Hochwertige GPT-5.5-Variante für die stärkste Argumentation und Qualität';

  @override
  String get modelGpt54Desc => 'Starkes Allzweckmodell der GPT-5-Generation';

  @override
  String get modelGpt54ProDesc =>
      'Leistungsstärkere GPT-5.4-Variante für anspruchsvolle Aufgaben';

  @override
  String get modelGpt54MiniDesc =>
      'Kleinere, schnellere GPT-5.4-Variante für kostengünstigere Alltagsaufgaben';

  @override
  String get modelGpt5MiniDesc =>
      'Kompaktes Modell der GPT-5-Familie, optimiert für Geschwindigkeit und Kosten';

  @override
  String get modelGpt41Desc =>
      'Zuverlässige GPT-4.1-Option für Kompatibilität und solide Qualität';

  @override
  String get modelGpt4o => 'GPT-4o';

  @override
  String get modelGpt35Turbo => 'GPT-3.5 Turbo (Legacy, Budget)';

  @override
  String get modelGpt35Turbo16k => 'GPT-3.5 Turbo 16K';

  @override
  String get modelGpt4 => 'GPT-4';

  @override
  String get modelGpt4Turbo => 'GPT-4 Turbo (Legacy)';

  @override
  String get modelGpt4oDesc =>
      'Beste Allzweckwahl; schnell, multimodal und qualitätsstark';

  @override
  String get modelGpt35TurboDesc =>
      'Legacy-Low-Cost-Option; nützlich für einfachere Aufgaben und kostensensible Nutzung';

  @override
  String get modelGpt35Turbo16kDesc =>
      'Wie GPT-3.5, aber 16 KB großes Token-Kontextfenster';

  @override
  String get modelGpt4Desc =>
      'Hohe Argumentationsqualität; normalerweise langsamer und teurer';

  @override
  String get modelGpt4TurboDesc =>
      'Option der älteren GPT-4-Familie; immer noch nützlich, wenn Sie eine ältere, günstigere Alternative suchen';

  @override
  String get analyzing => 'Analysieren...';

  @override
  String get languageDetected => 'Sprache erkannt';

  @override
  String get itemsFound => 'Gefundene Artikel';

  @override
  String get selectItemsToImport => 'Wählen Sie Elemente zum Importieren aus';

  @override
  String get selectAll => 'Wählen Sie „Alle“ aus';

  @override
  String get deselectAll => 'Alle abwählen';

  @override
  String get importSelected => 'Ausgewählte importieren';

  @override
  String get importing => 'Importieren...';

  @override
  String get itemsImported => 'Artikel erfolgreich importiert';

  @override
  String get noItemsSelected => 'Keine Elemente ausgewählt';

  @override
  String get textCannotBeEmpty => 'Der Text darf nicht leer sein';

  @override
  String get selectAtLeastOneType =>
      'Wählen Sie mindestens einen Typ (Wörter oder Ausdrücke) aus.';

  @override
  String get languageNotMatching =>
      'Die erkannte Sprache stimmt mit keiner Sprache im Paket überein';

  @override
  String get openaiKeyRequired =>
      'Für diese Funktion ist ein OpenAI-API-Schlüssel erforderlich';

  @override
  String analyzingProgress(Object current, Object total) {
    return 'Analysieren: $current / $total';
  }

  @override
  String translatingProgress(Object current, Object total) {
    return 'Übersetzen: $current / $total';
  }

  @override
  String get duplicate => 'Duplikat';

  @override
  String importProgress(Object current, Object total) {
    return 'Importieren von $current von $total';
  }

  @override
  String get detectingLanguage => 'Sprache erkennen...';

  @override
  String get extractingItems => 'Elemente extrahieren...';

  @override
  String get checkingDuplicates => 'Suche nach Duplikaten...';

  @override
  String get translating => 'Übersetzen...';

  @override
  String get generatingExamples => 'Beispiele generieren...';

  @override
  String get errorAnalyzingText => 'Fehler bei der Textanalyse';

  @override
  String get errorImportingItems => 'Fehler beim Importieren von Artikeln';

  @override
  String get warning => 'Warnung';

  @override
  String get textIsVeryLarge => 'Der Text ist sehr groß';

  @override
  String get words => 'Worte';

  @override
  String get continueAnalysis =>
      'Die Verarbeitung kann länger dauern und wird in Blöcken analysiert. Möchten Sie fortfahren?';

  @override
  String get continueLabel => 'Weitermachen';

  @override
  String get exportBeforeDeleteMessage =>
      'Möchten Sie dieses Paket exportieren, bevor Sie es löschen? Dadurch werden alle Ihre Daten in einer ZIP-Datei gespeichert.';

  @override
  String get deleteWithoutExport => 'Ohne Export löschen';

  @override
  String get exportAndDelete => 'Exportieren und löschen';

  @override
  String get exportingPackage => 'Paket exportieren...';

  @override
  String packageExportedToPath(Object path) {
    return 'Paket exportiert nach: $path';
  }

  @override
  String errorLoadingItems(Object error) {
    return 'Fehler beim Laden der Elemente: $error';
  }

  @override
  String badgeEarnedWithName(Object badgeName) {
    return 'Verdientes Abzeichen: $badgeName!';
  }

  @override
  String badgeLostWithName(Object badgeName) {
    return 'Abzeichen verloren: $badgeName';
  }

  @override
  String get trainingSessionProgress => 'Trainingsstatistiken';

  @override
  String get total => 'Gesamt';

  @override
  String lastNValue(Object value) {
    return 'N = $value';
  }

  @override
  String errorLoadingSettings(Object error) {
    return 'Fehler beim Laden der Einstellungen: $error';
  }

  @override
  String get selectPackage => 'Wählen Sie Paket aus';

  @override
  String get noPackagesAvailable => 'Keine Pakete verfügbar';

  @override
  String get possibleSolutions => 'Mögliche Lösungen';

  @override
  String get technicalDetails => 'Technische Details';

  @override
  String get close => 'Schließen';

  @override
  String get checkApiKey => 'Überprüfen Sie Ihren OpenAI-API-Schlüssel';

  @override
  String get ensureValidOpenAIKey =>
      'Stellen Sie sicher, dass der API-Schlüssel gültig und aktiv ist';

  @override
  String get verifyKeyInSettings =>
      'Überprüfen Sie den Schlüssel in den Einstellungen';

  @override
  String get rateLimitExceeded => 'API-Ratenlimit überschritten';

  @override
  String get waitAndRetry =>
      'Warten Sie ein paar Minuten und versuchen Sie es erneut';

  @override
  String get checkAccountQuota => 'Überprüfen Sie Ihr OpenAI-Kontokontingent';

  @override
  String get invalidRequest => 'Ungültiges Anfrageformat';

  @override
  String get tryReducingTextLength =>
      'Versuchen Sie, die Textlänge zu reduzieren';

  @override
  String get checkTextFormat => 'Überprüfen Sie, ob das Textformat korrekt ist';

  @override
  String get checkInternetConnection =>
      'Überprüfen Sie Ihre Internetverbindung';

  @override
  String get retryInMoment => 'Versuchen Sie es gleich noch einmal';

  @override
  String get checkFirewall => 'Überprüfen Sie die Firewall-Einstellungen';

  @override
  String get textMayBeTooShort => 'Der Text ist möglicherweise zu kurz';

  @override
  String get tryDifferentKnowledgeLevel =>
      'Versuchen Sie es mit einem anderen Wissensstand';

  @override
  String get ensureTextInCorrectLanguage =>
      'Stellen Sie sicher, dass der Text in der richtigen Sprache verfasst ist';

  @override
  String get requestTimedOut => 'Zeitüberschreitung bei der Anfrage';

  @override
  String get textMayBeTooLong => 'Der Text ist möglicherweise zu lang';

  @override
  String get tryAgainOrReduceSize =>
      'Versuchen Sie es erneut oder reduzieren Sie die Textgröße';

  @override
  String get unexpectedError => 'Es ist ein unerwarteter Fehler aufgetreten';

  @override
  String get checkErrorDetails => 'Überprüfen Sie die Fehlerdetails unten';

  @override
  String get tryAgainLater => 'Versuchen Sie es später noch einmal';

  @override
  String get translationServiceFailed =>
      'Der Übersetzungsdienst ist fehlgeschlagen';

  @override
  String get checkApiKeys =>
      'Überprüfen Sie Ihre API-Schlüssel (DeepL, OpenAI)';

  @override
  String get retryImport => 'Versuchen Sie den Import erneut';

  @override
  String get exampleGenerationFailed => 'Beispielgenerierung fehlgeschlagen';

  @override
  String get itemsStillImported => 'Es wurden weiterhin Artikel importiert';

  @override
  String get canAddExamplesManually =>
      'Sie können Beispiele später manuell hinzufügen';

  @override
  String get databaseError => 'Es ist ein Datenbankfehler aufgetreten';

  @override
  String get checkStorageSpace =>
      'Überprüfen Sie den verfügbaren Speicherplatz';

  @override
  String get restartApp => 'Versuchen Sie, die App neu zu starten';

  @override
  String get groupLabel => 'Gruppe:';

  @override
  String get amendGroups => 'Ändern';

  @override
  String get exportItemsJson => 'Elemente exportieren (JSON)';

  @override
  String get exportItemsJsonTooltip =>
      'Exportieren Sie alle Elemente als JSON-Datei';

  @override
  String get noCategoriesInPackage =>
      'In diesem Paket wurden keine Kategorien gefunden';

  @override
  String get noItemsToExport =>
      'Es wurden keine Elemente zum Exportieren gefunden';

  @override
  String itemsExportedSuccessfully(int count, String path) {
    return '$count-Elemente wurden erfolgreich exportiert nach:\n$path';
  }

  @override
  String get errorExportingItems => 'Fehler beim Exportieren von Elementen';

  @override
  String get languageMismatch => 'Sprachkonflikt';

  @override
  String get languageMismatchDescription =>
      'Die Sprachen in der JSON-Datei stimmen nicht mit den Paketsprachen überein:';

  @override
  String packageLanguages(String lang1, String lang2) {
    return 'Paket: $lang1 → $lang2';
  }

  @override
  String jsonFileLanguages(String lang1, String lang2) {
    return 'JSON-Datei: $lang1 → $lang2';
  }

  @override
  String get continueImportQuestion =>
      'Möchten Sie trotzdem mit dem Import fortfahren?';

  @override
  String get continueImport => 'Fahren Sie mit dem Import fort';

  @override
  String get pleaseSelectPackageGroup =>
      'Bitte wählen Sie eine Paketgruppe aus';

  @override
  String get customIconLabel => 'Brauch';

  @override
  String get defaultIconLabel => 'Standard';

  @override
  String get icon2Label => 'Offenes Buch';

  @override
  String get icon3Label => 'Farbiges Buch';

  @override
  String get icon4Label => 'Gespräch';

  @override
  String get icon5Label => 'Abschluss';

  @override
  String get icon6Label => 'Gehirn';

  @override
  String get icon7Label => 'Buchstapel';

  @override
  String get icon8Label => 'Karteikarte';

  @override
  String get icon9Label => 'Globus';

  @override
  String get icon10Label => 'Bleistift';

  @override
  String get icon11Label => 'Trophäe';

  @override
  String get icon12Label => 'Suchen';

  @override
  String get customIconFile => 'Benutzerdefiniertes Symbol';

  @override
  String get importedIconFile => 'Importiertes Symbol';

  @override
  String get unableToReadImageFile =>
      'Bilddatei kann nicht gelesen werden. Bitte wählen Sie ein gültiges Bild aus.';

  @override
  String iconDimensionsTooLarge(int width, int height) {
    return 'Die Symbolabmessungen sind zu groß (${width}x$height). Der maximal zulässige Wert beträgt 512 x 512 Pixel.';
  }

  @override
  String get iconFileTooLarge =>
      'Die Symboldatei ist zu groß. Die maximale Größe beträgt 1 MB.';

  @override
  String failedToUploadIcon(String error) {
    return 'Hochladen des Symbols fehlgeschlagen: $error';
  }

  @override
  String get pleaseSelectValidLanguage =>
      'Bitte wählen Sie eine gültige Sprache aus der Liste aus';

  @override
  String get status => 'Status';

  @override
  String get addExample => 'Beispiel hinzufügen';

  @override
  String get noExamplesYet =>
      'Noch keine Beispiele. Klicken Sie zum Hinzufügen auf +.';

  @override
  String get speakText => 'Text sprechen';

  @override
  String get removeCategory => 'Kategorie entfernen';

  @override
  String removeCategoryConfirm(String categoryName) {
    return 'Kategorie „$categoryName“ aus diesem Artikel entfernen?';
  }

  @override
  String get remove => 'Entfernen';

  @override
  String get extractFullItems => 'Vollständige Artikel extrahieren';

  @override
  String get pasteFromClipboard => 'Aus der Zwischenablage einfügen';

  @override
  String get noItemsFoundOrAllDuplicates =>
      'Im Text wurden keine Elemente gefunden oder alle Elemente sind bereits im Paket vorhanden';

  @override
  String get aboutLanguageRally => 'Über Sprachrallye';

  @override
  String get welcomeTitle => '🚀 Willkommen bei der Language Rally';

  @override
  String get welcomeSubtitle =>
      'Nutzen Sie die unglaubliche Kraft des Sprachenlernens mit rund 4.000 Wörtern, 4.000 Ausdrücken und ebenso vielen Beispielsätzen – sorgfältig zusammengestellt für jedes Sprachniveau! Verwenden Sie KI, um Elemente aus Ihren eigenen Texten zu importieren, oder chatten Sie mit der KI zu einem beliebigen Thema, um genau die Wörter, Ausdrücke und Beispiele zu generieren, die Sie lernen möchten.\nVerbessern Sie Ihre Sprachkenntnisse – auf intelligente und spielerische Weise!';

  @override
  String get welcomeIntro =>
      'Lernen Sie Vokabeln und Ausdrücke effizient, indem Sie üben, was Ihnen wirklich am Herzen liegt. Keine langweiligen Listen. Keine verschwendete Zeit.';

  @override
  String get sectionPlayYourGame => '🎮 Spielen Sie Ihr eigenes Spiel';

  @override
  String get sectionPlayYourGameDesc =>
      'Erstellen Sie Ihre eigenen Vokabelpakete. Trainieren Sie nur die Wörter und Ausdrücke, die Sie beherrschen möchten. Kennst du es schon? Es wird markiert und übersprungen!';

  @override
  String get sectionAITeammate => '🤖 KI als Ihr Teamkollege';

  @override
  String get sectionAITeammateDesc =>
      'Fügen Sie einen beliebigen Text ein und lassen Sie AI:\n• Extrahieren Sie nützliches Vokabular\n• Wählen Sie Ausdrücke aus, die Ihrem Niveau entsprechen\n• Erstellen Sie in Sekundenschnelle schulungsbereite Pakete\n\nChatten Sie mit der KI:\n• Lassen Sie sich Wörter und Ausdrücke für Ihr Thema vorschlagen\n• Klicken Sie, um Beispiele zu generieren und diese in Ihrem EIGENEN Paket zu speichern';

  @override
  String get sectionTrainSmart => '🔁 Trainiere intelligent';

  @override
  String get sectionTrainSmartDesc =>
      'Unser fein abgestimmtes Wiederholungssystem zeigt Elemente genau dann an, wenn Ihr Gehirn sie benötigt, um sie effektiv auswendig zu lernen. Maximaler Fortschritt. Minimaler Aufwand.';

  @override
  String get sectionRealExamples => '🌍 Echte Beispiele. Tolle Übersetzungen.';

  @override
  String get sectionRealExamplesDesc =>
      'Erhalten Sie Anwendungsbeispiele aus der Praxis. Übersetzen Sie mit DeepL in Premiumqualität. Üben Sie die Aussprache und klingen Sie sicher.';

  @override
  String get sectionTeachersWelcome => '👩‍🏫 Lehrer willkommen';

  @override
  String get sectionTeachersWelcomeDesc =>
      'Erstellen Sie ein Paket → Elemente kopieren und einfügen oder extrahieren, übersetzen, Beispiele hinzufügen mit der KI → Exportieren → Hochladen/Senden → Fertig. Ihre Schüler importieren es und beginnen sofort mit dem Üben.';

  @override
  String get sectionUnlockAI => '🔑 Schalte die volle KI-Leistung frei';

  @override
  String get sectionUnlockAIDesc =>
      'Für hochwertige Übersetzungen und KI-Funktionen gehen Sie einfach wie folgt vor:\n\n1. Erstellen Sie Ihren DeepL-API-Schlüssel\n   https://www.deepl.com/pro-api\n2. Erstellen Sie Ihren OpenAI-API-Schlüssel\n   https://platform.openai.com/api-keys\n3. Fügen Sie beide Schlüssel in die Einstellungen ein\n\nMit einer kleinen Investition erhalten Sie leistungsstarke, professionelle Sprachtools. Warum sollten Sie sich das entgehen lassen?\n(Für optimale Ergebnisse empfehlen wir die Verwendung eines kostenpflichtigen API-Zugriffs.)';

  @override
  String get readyToStart => 'Sind Sie bereit, Ihre Rallye zu starten? 🏁';

  @override
  String get welcomeDescription =>
      'Language Rally ist Ihr umfassender Begleiter zum Sprachenlernen. Erstellen Sie benutzerdefinierte Vokabelpakete, organisieren Sie Elemente nach Kategorien und trainieren Sie mit einem intelligenten Wiederholungssystem.';

  @override
  String get browseStore => 'Shop durchsuchen';

  @override
  String get featureInteractiveTraining => 'Interaktives Training';

  @override
  String get featureInteractiveTrainingDesc =>
      'Üben Sie mit adaptiven Lernalgorithmen';

  @override
  String get featureSmartOrganization => 'Intelligente Organisation';

  @override
  String get featureSmartOrganizationDesc =>
      'Kategorisieren und filtern Sie Ihren Wortschatz';

  @override
  String get featureTrackProgress => 'Verfolgen Sie den Fortschritt';

  @override
  String get featureTrackProgressDesc =>
      'Überwachen Sie Ihr Lernen mit detaillierten Statistiken';

  @override
  String get featureImportExport => 'Importieren und Exportieren';

  @override
  String get featureImportExportDesc =>
      'Teilen Sie Pakete und synchronisieren Sie sie geräteübergreifend';

  @override
  String get startAppTour => 'Starten Sie die App-Tour';

  @override
  String get quickStartGuide => 'Kurzanleitung';

  @override
  String get tourStep1Title => 'Pakete erstellen oder importieren';

  @override
  String get tourStep1Desc =>
      'Erstellen Sie zunächst ein neues Sprachpaket oder importieren Sie ein vorhandenes aus einer Datei.';

  @override
  String get tourStep2Title => 'Vokabelelemente hinzufügen';

  @override
  String get tourStep2Desc =>
      'Durchsuchen Sie Ihre Pakete und fügen Sie Wörter, Phrasen oder Ausdrücke mit Beispielen und Kategorien hinzu.';

  @override
  String get tourStep3Title => 'Schulung konfigurieren';

  @override
  String get tourStep3Desc =>
      'Wählen Sie aus, welche Elemente Sie üben möchten, legen Sie Schwierigkeitsgrade fest und passen Sie Ihr Lernerlebnis individuell an.';

  @override
  String get tourStep4Title => 'Beginnen Sie mit dem Lernen';

  @override
  String get tourStep4Desc =>
      'Beginnen Sie Ihre Trainingseinheit und markieren Sie Elemente als bekannt oder unbekannt, um Ihren Fortschritt zu verfolgen.';

  @override
  String get tourStep5Title => 'Überprüfen Sie die Statistiken';

  @override
  String get tourStep5Desc =>
      'Überprüfen Sie Ihren Lernfortschritt mit detaillierten Statistiken und Leistungsabzeichen.';

  @override
  String get gotIt => 'Habe es!';

  @override
  String get appTourTitle => 'Willkommen bei der Sprachrallye';

  @override
  String get appTourSubtitle =>
      'Ihr intelligenter, verspielter und vollständig personalisierter Sprachlernbegleiter.';

  @override
  String get tourPage1Title =>
      'Lernen und üben Sie, was Sie wollen und was Sie brauchen';

  @override
  String get tourPage1Desc =>
      'Unser adaptives Lernsystem stellt sicher, dass Sie Elemente im perfekten Moment überprüfen – was die Erinnerung maximiert und den Aufwand minimiert.\n\nLernen Sie mit Hilfe der integrierten Automatisierung.\nVerschwenden Sie keine Zeit mehr mit Wörtern, die Sie bereits kennen.\n\nÜben Sie nur die Vokabeln und Ausdrücke, die Sie interessieren. Erstellen und trainieren Sie Ihre eigenen Gegenstände – ganz auf Ihre Ziele und Ihr Niveau zugeschnitten.';

  @override
  String get tourPage2Title => 'Erstellen Sie Ihr eigenes Sprachpaket';

  @override
  String get tourPage2Desc =>
      'Erstellen Sie personalisierte Vokabelsammlungen, die Ihren Interessen und Lernzielen entsprechen.\n\nOrdnen Sie Wörter und Ausdrücke nach Thema, Schwierigkeit oder Kontext.\n\nVollständige Kontrolle darüber, was Sie wann lernen.';

  @override
  String get tourPage3Title => 'KI-gestützte Artikelerstellung';

  @override
  String get tourPage3Desc =>
      'Erstellen Sie im Handumdrehen Ihre eigenen Lernpakete:\n\n• Fügen Sie beliebigen Text ein und lassen Sie die KI relevante Vokabeln automatisch extrahieren\n• Identifizieren Sie Wörter und Ausdrücke, die perfekt zu Ihrem Niveau passen\n• Lassen Sie die KI die Übersetzung für Sie erledigen\n• Lassen Sie die KI nach Beispielen in Echtzeit suchen\n\nChatten Sie mit der KI:\n• Lassen Sie sich Wörter und Ausdrücke für Ihr Thema vorschlagen\n• Klicken Sie, um Beispiele zu generieren und diese in Ihrem EIGENEN Paket zu speichern\n• Erstellen Sie schnell schulungsbereite Pakete';

  @override
  String get tourPage4Title =>
      'KI-gestützte Beispiele aus der Praxis und Premium-Übersetzung';

  @override
  String get tourPage4Desc =>
      '• Suchen Sie sofort nach authentischen Anwendungsbeispielen\n• Übersetzen Sie Wörter, Ausdrücke und ganze Sätze mit hochwertiger DeepL-Integration\n• Erhalten Sie genaue, kontextbezogene Ergebnisse';

  @override
  String get tourPage5Title => 'Intelligente Paketorganisation';

  @override
  String get tourPage5Desc =>
      '• Organisieren Sie Vokabeln in benutzerdefinierten Kategorien\n• Filtern und konzentrieren Sie sich auf bestimmte Themen\n• Pakete geräteübergreifend importieren und exportieren\n• Teilen Sie Pakete einfach mit anderen';

  @override
  String get tourPage6Title => 'Trainieren Sie Ihre Aussprache';

  @override
  String get tourPage6Desc =>
      'Testen und verbessern Sie Ihre Aussprache mit interaktiven Übungstools.\n\nBauen Sie Selbstvertrauen beim Sprechen auf – nicht nur beim Lesen.';

  @override
  String get tourPage7Title => 'Für Lehrer';

  @override
  String get tourPage7Desc =>
      'Erstellen Sie mit nur wenigen Klicks gebrauchsfertige Vokabelpakete für Ihre Schüler.\n\nExportieren Sie sie, senden Sie sie an Ihre Klasse – und sobald sie importiert sind, sind sie sofort zum Üben auf dem Gerät jedes Schülers bereit.\n\nEinfach. Schnell. Wirksam.';

  @override
  String get tourPage8Title => 'Schalten Sie hochwertige KI-Unterstützung frei';

  @override
  String get tourPage8Desc =>
      'Für Premium-Übersetzungen und erweiterte KI-Funktionen gehen Sie einfach wie folgt vor:\n 1. Erstellen Sie Ihren eigenen DeepL-API-Schlüssel\n 2. Erstellen Sie Ihren eigenen OpenAI-API-Schlüssel\n 3. Fügen Sie beide Schlüssel in den Abschnitt „Einstellungen“ ein\n\nDies erfordert nur ein kleines Budget (einige Dollar), verschafft Ihnen aber Zugriff auf leistungsstarke, professionelle Sprachtools.\nHinweis: Für optimale Ergebnisse empfehlen wir die Verwendung eines kostenpflichtigen API-Zugriffs. Es kostet nur ein paar Dollar.\n\n🔑 DeepL-API-Schlüssel: https://www.deepl.com/pro-api\n\n🔑 OpenAI-API-Schlüssel: https://platform.openai.com/api-keys';

  @override
  String get previousPage => 'Vorherige';

  @override
  String get nextPage => 'Nächste';

  @override
  String get endTour => 'Ende der Tour';

  @override
  String pageIndicator(int current, int total) {
    return 'Seite $current von $total';
  }

  @override
  String get practicePronunciation => 'Üben Sie die Aussprache';

  @override
  String get pronunciationPractice => 'Ausspracheübungen';

  @override
  String get startPractice => 'Beginnen Sie mit dem Üben';

  @override
  String get listenToPronunciation => 'Hören Sie sich die Aussprache an';

  @override
  String get tapToRecord => 'Zum Aufnehmen tippen';

  @override
  String get recording => 'Aufnahme...';

  @override
  String get recorded => 'Aufgezeichnet';

  @override
  String get speakNow =>
      'Sprechen Sie jetzt – sprechen Sie deutlich und nah am Mikrofon';

  @override
  String get noSpeechDetected =>
      'Keine Sprache erkannt. Bitte versuchen Sie es erneut.';

  @override
  String get noTextRecognized =>
      'In der Aufnahme wurde keine Sprache erkannt. Bitte stellen Sie sicher, dass Ihr Mikrofon funktioniert, und versuchen Sie es erneut.';

  @override
  String get processingAudio => 'Audio mit KI verarbeiten...';

  @override
  String get playbackRecording => 'Spielen Sie meine Aufnahme ab';

  @override
  String get playbackRecordingSubtitle =>
      'Hören Sie Ihre Aufnahme, während die KI sie verarbeitet';

  @override
  String get recordingTooShort =>
      'Aufnahme zu kurz. Bitte sprechen Sie mindestens 1 Sekunde lang.';

  @override
  String get microphonePermissionRequired =>
      'Für die Ausspracheübungen ist eine Mikrofonerlaubnis erforderlich';

  @override
  String get speechRecognitionNotSupported =>
      'Die Spracherkennung wird auf dieser Plattform nicht unterstützt. Bitte nutzen Sie zum Üben der Aussprache die mobile App (Android/iOS).';

  @override
  String get speechRecognitionUnavailable =>
      'Die Spracherkennung ist auf diesem Gerät nicht verfügbar.';

  @override
  String get pronunciationAccuracy => 'Aussprache\nGenauigkeit';

  @override
  String get excellent => 'Exzellent!';

  @override
  String get good => 'Gut';

  @override
  String get fair => 'Gerecht';

  @override
  String get needsImprovement => 'Verbesserungsbedarf';

  @override
  String get tryAgain => 'Versuchen Sie es erneut';

  @override
  String get nextItem => 'Nächster Artikel';

  @override
  String get endPractice => 'Beenden Sie das Training';

  @override
  String get practiced => 'Geübt';

  @override
  String get windowsAudioTestPageTitle => 'Windows-Audiotest (RTAudio)';

  @override
  String get configureWindowsAudio =>
      'Audio testen und konfigurieren\nEingabe unter Windows';

  @override
  String get configureWindowsAudioDescription =>
      'Nehmen Sie Audio mit dem nativen Windows RTAudio-Treiber auf, geben Sie ihn wieder und transkribieren Sie ihn';

  @override
  String get audioTestTitle => 'Windows-Audioaufzeichnungstest';

  @override
  String get audioTestSubtitle => 'RTAudio – Native Windows-Audioaufzeichnung';

  @override
  String get audioInputDevice => 'Audio-Eingabegerät';

  @override
  String get selectMicrophone => 'Wählen Sie Mikrofon';

  @override
  String get refreshDevices => 'Geräte aktualisieren';

  @override
  String get noAudioDevicesFound => 'Keine Audioeingabegeräte gefunden';

  @override
  String get loadingAudioDevices => 'Audiogeräte werden geladen...';

  @override
  String get recordingSettings => 'Aufnahmeeinstellungen';

  @override
  String get stereoRecording => 'Stereoaufnahme';

  @override
  String get stereoChannels => '2 Kanäle (Stereo)';

  @override
  String get monoChannel => '1 Kanal (Mono)';

  @override
  String get sampleRateLabel => 'Abtastrate';

  @override
  String get nativeRateBadge => 'einheimisch';

  @override
  String get microphoneGainLabel => 'Mikrofonverstärkung';

  @override
  String get gainHint => '1x = keine Anhebung • 3x ≈ +9,5 dB • 10x ≈ +20 dB';

  @override
  String get tapToStartRec => 'Tippen Sie, um die Aufnahme zu starten';

  @override
  String get tapToStopRec => 'Tippen Sie auf , um die Aufnahme zu beenden';

  @override
  String get recordingCompleteLabel => 'Aufnahme abgeschlossen';

  @override
  String get tapMicToStop => 'Tippen Sie zum Stoppen auf das Mikrofon';

  @override
  String get playRecordingLabel => 'Aufnahme abspielen';

  @override
  String get stopPlaybackLabel => 'Stoppen';

  @override
  String get whisperSectionTitle => 'OpenAI Whisper Transkription';

  @override
  String get whisperWavNote =>
      'WAV (16-Bit-PCM) wird von Whisper nativ unterstützt – keine Konvertierung erforderlich.';

  @override
  String get sendToWhisperLabel => 'An Whisper senden';

  @override
  String get transcribingLabel => 'Transkribieren...';

  @override
  String get transcriptionResultLabel => 'Transkriptionsergebnis';

  @override
  String get transcriptionFailedLabel => 'Transkription fehlgeschlagen';

  @override
  String get debugInformationLabel => 'Information';

  @override
  String get debugConsoleHint =>
      'Überprüfen Sie die Konsole auf detaillierte Protokolle';

  @override
  String get debugDevicesFound => 'Geräte gefunden';

  @override
  String get debugSelectedDevice => 'Ausgewähltes Gerät';

  @override
  String get debugDeviceRateNative => 'Geräterate (nativ)';

  @override
  String get debugRequestedRate => 'Angeforderter Preis';

  @override
  String get debugActualRate => 'Tatsächlich verwendete Rate';

  @override
  String get debugActualRateForced => '⚠ gezwungen';

  @override
  String get debugActualRateOk => '✓';

  @override
  String get debugRecordingMode => 'Aufnahmemodus';

  @override
  String get debugLastRecording => 'Letzte Aufnahme';

  @override
  String get debugFileSize => 'Dateigröße';

  @override
  String get debugStereo => 'Stereo';

  @override
  String get debugMono => 'Mono';

  @override
  String get recordingSavedSnack => 'Aufnahme gespeichert';

  @override
  String get recordingTooShortSnack =>
      'Die Aufnahme ist zu kurz. Bitte nehmen Sie mindestens 1 Sekunde lang auf.';

  @override
  String get recordingSmallSnack =>
      'Die Aufnahmedatei ist sehr klein. Die Aufnahme ist möglicherweise fehlgeschlagen.';

  @override
  String get noAudioDataSnack => 'Keine Audiodaten aufgezeichnet';

  @override
  String get noDeviceSelectedSnack => 'Bitte wählen Sie ein Audiogerät aus';

  @override
  String get failedToInitRtAudio => 'RTAudio konnte nicht initialisiert werden';

  @override
  String get envelopeScoreLabel => 'Umschlag';

  @override
  String get rhythmScoreLabel => 'Rhythmus';

  @override
  String get textScoreLabel => 'Text';

  @override
  String get help => 'Helfen';

  @override
  String get trainingHelpTitle => 'Trainingstipps';

  @override
  String get trainingHelpText =>
      'Um Ihr Training so effektiv wie möglich zu gestalten, befolgen Sie diese Schritte:\n1. Klicken Sie auf die Schaltfläche „Zähler löschen“, damit alle Artikel in diesem Paket als bekannt markiert werden.\n2. Stellen Sie „Artikelumfang“ auf „Alle Artikel“ ein.\n3. Stellen Sie „Artikelreihenfolge“ auf „Zufällig“ ein.\n4. Wählen Sie unter „Anzeigesprache“ Ihre Muttersprache aus.\n5. Beginnen Sie mit dem Training und fahren Sie fort, bis Sie etwa 20–30 Dinge identifiziert haben, die Sie nicht kennen.\n6. Kehren Sie zu den Trainingseinstellungen zurück und ändern Sie „Elementumfang“ in „Nur unbekannte Elemente“.\n7. Setzen Sie das Training fort und fahren Sie fort, bis Sie alle bisher unbekannten Dinge gelernt haben.';

  @override
  String get trainingProTip =>
      'Profi-Tipp: Beginnen Sie mit allen Artikeln; Konzentrieren Sie sich später nur auf das Unbekannte.';

  @override
  String get onboardingWelcomeTitle => 'Willkommen bei der Sprachrallye!';

  @override
  String get onboardingSetupSubtitle =>
      'Lassen Sie uns die App für Sie einrichten.';

  @override
  String get onboardingSelectUiLanguage => 'Schnittstellensprache';

  @override
  String get onboardingUiLanguageNote =>
      'Sie können dies später unter Einstellungen → UI-Sprache ändern.';

  @override
  String get onboardingNext => 'Nächste';

  @override
  String get onboardingBack => 'Zurück';

  @override
  String get onboardingSelectPackagesTitle => 'Wählen Sie Sprachpakete';

  @override
  String get onboardingSelectPackagesSubtitle =>
      'Wählen Sie aus, welche Vokabelpakete importiert werden sollen. Sie können später jederzeit über das Hauptmenü (Pakete anzeigen) weitere hinzufügen.';

  @override
  String get onboardingAnalyzingPackages =>
      'Verfügbare Pakete werden analysiert…';

  @override
  String onboardingScanningPackagesProgress(
    int scanned,
    int total,
    int alreadyInDb,
  ) {
    return 'Gescannt $scanned/$total • bereits in DB $alreadyInDb';
  }

  @override
  String get onboardingImportSelected => 'Ausgewählte importieren';

  @override
  String get onboardingSkipImport => 'Überspringen';

  @override
  String get onboardingSelectAll => 'Wählen Sie „Alle“ aus';

  @override
  String get onboardingDeselectAll => 'Alle abwählen';

  @override
  String onboardingNPackages(int count) {
    return '$count Pakete';
  }

  @override
  String get onboardingGetStarted => 'Legen Sie los';

  @override
  String get onboardingImportCompleteTitle => 'Import abgeschlossen!';

  @override
  String get importBuiltInPkg => 'Kostenlose Pakete';

  @override
  String get importBuiltInPkgTooltip =>
      'Importieren Sie kostenlose gebündelte Sprachpakete';

  @override
  String get globalSearch => 'Globale Suche';

  @override
  String get globalSearchTitle => 'Durchsuchen Sie alle Pakete';

  @override
  String get globalSearchSelectLanguage => 'Wählen Sie Sprachcode aus';

  @override
  String get globalSearchEnterWord => 'Zu suchende Wörter';

  @override
  String get globalSearchEnterWordHint =>
      'z.B. „der“, „order“ – findet teilweise Übereinstimmungen';

  @override
  String get globalSearchButton => 'Suchen';

  @override
  String get globalSearchResults => 'Ergebnisse';

  @override
  String globalSearchNoResults(String query) {
    return 'Keine Ergebnisse für „$query“ gefunden';
  }

  @override
  String globalSearchResultsCount(int count) {
    return '$count Ergebnis(se) gefunden';
  }

  @override
  String get globalSearchSearching => 'Suche...';

  @override
  String get globalSearchSelectLanguageFirst =>
      'Bitte wählen Sie zunächst einen Sprachcode aus';

  @override
  String get globalSearchEnterTermFirst =>
      'Bitte geben Sie einen Suchbegriff ein';

  @override
  String get globalSearchMatchInExamples => 'In Beispielen zu finden';

  @override
  String get globalSearchViewItem => 'Sicht';

  @override
  String get globalSearchGoToPackage => 'Gehen Sie zu Paket';

  @override
  String get globalSearchLoadingPackages => 'Pakete werden geladen…';

  @override
  String get globalSearchNoPackages =>
      'Es sind noch keine Sprachpakete installiert';

  @override
  String get globalSearchCancelSearch => 'Suche abbrechen';

  @override
  String globalSearchProgressOf(int current, int total) {
    return 'Suche nach Paket $current von $total…';
  }

  @override
  String globalSearchCancelledMessage(int count) {
    return 'Suche abgebrochen – bisher $count Ergebnis(se) gefunden';
  }

  @override
  String get storeTitle => 'Sprachpaketspeicher';

  @override
  String get storeRestorePurchases => 'Einkäufe wiederherstellen';

  @override
  String get storeRefresh => 'Aktualisieren';

  @override
  String get storeSearchHint => 'Pakete suchen…';

  @override
  String get storeNoPackagesMatchSearch =>
      'Keine Pakete entsprechen Ihrer Suche.';

  @override
  String get storeNoPackagesAvailable => 'Keine Pakete verfügbar.';

  @override
  String storeInstalledCount(int installed, int total) {
    return '$installed / $total installiert';
  }

  @override
  String get storeLoadErrorTitle => 'Der Store konnte nicht geladen werden.';

  @override
  String get storeIapNotAvailableMessage =>
      'In-App-Käufe sind auf dieser Plattform nicht verfügbar. Besuchen Sie unsere Website, um Pakete zu kaufen.';

  @override
  String get storeOpenWebsite => 'Website öffnen';

  @override
  String storePurchaseSuccess(String title) {
    return '$title erfolgreich installiert!';
  }

  @override
  String get storePurchaseCancelled => 'Kauf storniert.';

  @override
  String storePurchaseAlreadyOwned(String title) {
    return '$title ist bereits installiert.';
  }

  @override
  String get storePurchaseError =>
      'Etwas ist schief gelaufen. Bitte versuchen Sie es erneut.';

  @override
  String get storePurchasesRestored => 'Einkäufe wiederhergestellt';

  @override
  String get storeAllLevels => 'Alle Ebenen';

  @override
  String get storeAllGroups => 'Alle Sprachen';

  @override
  String get storeFilterLevel => 'Ebene';

  @override
  String get storeFilterLanguage => 'Sprache';

  @override
  String get storeDownload => 'Herunterladen';

  @override
  String get storeBuy => 'Kaufen';

  @override
  String get storeInstalledLabel => 'Installiert';

  @override
  String get storeDownloading => 'Herunterladen…';

  @override
  String get storeRetry => 'Wiederholen';

  @override
  String get storeIapAndroidOnly =>
      'Käufe sind nur für Android und iOS verfügbar.';

  @override
  String get storeDismiss => 'Zurückweisen';

  @override
  String get storeAddToCart => 'in den Warenkorb legen';

  @override
  String get storeRemoveFromCart => 'Entfernen';

  @override
  String get storeCartTitle => 'Warenkorb';

  @override
  String get storeCartEmpty => 'Ihr Warenkorb ist leer';

  @override
  String get storeCartClearAll => 'Alles löschen';

  @override
  String get storeCartCheckout => 'Kasse';

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
  String get storePackageDuplicateTitle => 'Paket existiert bereits';

  @override
  String storePackageDuplicateMessage(String packageName, String groupName) {
    return 'Das Paket „$packageName“ existiert bereits in der Gruppe „$groupName“. Möchten Sie es überschreiben? Das bestehende Paket und sein gesamter Trainingsfortschritt werden dauerhaft gelöscht.';
  }

  @override
  String get storePackageDuplicateOverwrite => 'Überschreiben';

  @override
  String get storePackageDuplicateKeep => 'Bleiben Sie bestehen';

  @override
  String splashSettingUpPackages(int current, int total) {
    return 'Pakete einrichten: $current / $total';
  }

  @override
  String get splashThisHappensOnce => 'Dies geschieht nur einmal.';

  @override
  String get splashLoading => 'Laden…';

  @override
  String get aiItemCreator => 'KI-Chat-Guru';

  @override
  String get aiItemCreatorAppBarHint =>
      'Sammeln und speichern Sie Wörter und Ausdrücke, indem Sie mit der KI chatten';

  @override
  String get chatWithAI => 'Chatten Sie mit KI';

  @override
  String get enterYourPrompt => 'Geben Sie Ihre Eingabeaufforderung ein...';

  @override
  String get aiItemCreatorPromptHint =>
      'Beschreiben Sie ein Thema und der KI-Coach stellt Fragen, schlägt nützliche Vokabeln vor und testet Ihr Wissen. Zum Beispiel: Helfen Sie mir, Gefahren beim Reisen auf dem Wissensniveau B2 zu sammeln und zu üben';

  @override
  String get send => 'Schicken';

  @override
  String get sending => 'Senden...';

  @override
  String get aiResponse => 'KI-Reaktion';

  @override
  String get itemInputs => 'Artikeleingaben';

  @override
  String get aiItemCreatorBothItemsRequired =>
      'Bitte füllen Sie vor dem Speichern beide Sprachfelder aus.';

  @override
  String get aiItemCreatorDuplicateItemMessage =>
      'In diesem Paket ist bereits ein Artikel mit demselben Textpaar vorhanden.';

  @override
  String get language1 => 'Sprache 1';

  @override
  String get language2 => 'Sprache 2';

  @override
  String get translateLang1ToLang2 => 'Auf Lang 2 übersetzen';

  @override
  String get translateLang2ToLang1 => 'In Sprache 1 übersetzen';

  @override
  String translateToLanguageCode(String languageCode) {
    return 'Übersetzen in $languageCode';
  }

  @override
  String get example => 'Beispiel';

  @override
  String get generating => 'Generieren...';

  @override
  String get flags => 'Flaggen';

  @override
  String get favorite => 'Favorit';

  @override
  String get saveItems => 'Speichern';

  @override
  String get saving => 'Sparen...';

  @override
  String get clearItems => 'Nur Artikel löschen';

  @override
  String get clearAll => 'Alle Felder löschen';

  @override
  String get itemSavedSuccessfully => 'Artikel erfolgreich gespeichert';

  @override
  String get promptCannotBeEmpty =>
      'Die Eingabeaufforderung darf nicht leer sein';

  @override
  String get enterAtLeastOneItem =>
      'Bitte geben Sie mindestens einen Artikel ein';

  @override
  String get selectPackageFirst => 'Bitte wählen Sie zunächst ein Paket aus';

  @override
  String get deeplKeyRequired =>
      'Für die Übersetzung ist ein DeepL-API-Schlüssel erforderlich';

  @override
  String get noNonPurchasedPackagesAvailable =>
      'Keine nicht gekauften Pakete verfügbar';

  @override
  String get packageSelectionRemembered => 'Paketauswahl gespeichert';

  @override
  String get aiItemCreatorOpenAiKeyNotConfiguredDetailed =>
      'Der OpenAI-API-Schlüssel ist nicht konfiguriert. Bitte fügen Sie Ihren API-Schlüssel in den Einstellungen hinzu.';

  @override
  String get aiItemCreatorOpenAiKeyNotConfigured =>
      'Der OpenAI-API-Schlüssel ist nicht konfiguriert.';

  @override
  String get aiItemCreatorProcessingComplete => 'Verarbeitung abgeschlossen';

  @override
  String get aiItemCreatorTranslationComingSoon =>
      'Die Übersetzungsfunktion ist bald verfügbar';

  @override
  String get aiItemCreatorDefaultCategoryName => 'KI erstellt';

  @override
  String get aiItemCreatorStartNewConversation =>
      'Beginnen Sie ein neues Gespräch';

  @override
  String get aiItemCreatorChatHint =>
      'Beschreiben Sie ein Thema und der KI-Coach stellt Fragen, schlägt nützliche Vokabeln vor und testet Ihr Wissen.';

  @override
  String get aiItemCreatorConversation => 'Gespräch';

  @override
  String get aiItemCreatorYou => 'Du';

  @override
  String get aiItemCreatorCoach => 'KI-Coach';

  @override
  String get aiItemCreatorAiSuggestions => 'KI-Vorschläge';

  @override
  String get aiItemCreatorTapChipToFill =>
      'Tippen Sie auf einen Chip, um ein Artikelfeld auszufüllen und automatisch zu übersetzen.';

  @override
  String get aiItemCreatorNoSuggestedItems =>
      'Noch keine Worte oder Ausdrücke.';

  @override
  String get aiItemCreatorNextSteps => 'So geht es weiter';

  @override
  String get aiItemCreatorNoNextSteps => 'Noch keine Fortsetzungsvorschläge.';

  @override
  String get aiItemCreatorModelCostTip =>
      'Profi-Tipp: Neuere Modelle sind teurer, während ältere und Turbo-Modelle günstiger sind und deutlich schneller sein können.';

  @override
  String get aiItemCreatorSelectPackageDialogTitle => 'Sprachpaket auswählen';

  @override
  String get aiItemCreatorSelectPackageDialogMessage =>
      'Wählen Sie das Sprachpaket aus, das für diese Sitzung verwendet werden soll. Ihre letzte Auswahl ist vorausgewählt.';

  @override
  String aiItemCreatorMissingApiKeysWarning(String keys) {
    return 'Fehlende API-Schlüssel: $keys. Sie können fortfahren, die KI- und Premium-Übersetzungsfunktionen sind jedoch möglicherweise eingeschränkt.';
  }

  @override
  String get about => 'Um';

  @override
  String get aboutWebsite => 'Webseite';

  @override
  String get aboutSummaryVideo => 'Zusammenfassungsvideo';

  @override
  String get aboutSupportEmail => 'Support-E-Mail-Adresse';

  @override
  String get aboutWebsiteUrl => 'https://sites.google.com/view/Language-Rally';

  @override
  String get aboutSummaryVideoUrl =>
      'https://www.youtube.com/watch?v=64Pl9iNF88c';

  @override
  String get aboutSupportEmailAddress => 'languagerally.support@gmail.com';

  @override
  String aboutVersionWithValue(String version) {
    return 'Version: $version';
  }

  @override
  String aboutCouldNotOpen(String uri) {
    return 'Konnte nicht geöffnet werden: $uri';
  }

  @override
  String get aboutWelcomeSplashNotFound => 'Begrüßungsbild nicht gefunden';

  @override
  String get chooseTheme => 'Wählen Sie Thema';

  @override
  String get darkMode => 'Dunkler Modus';

  @override
  String get toggleBetweenLightAndDark =>
      'Wechseln Sie zwischen hell und dunkel';

  @override
  String get colorTheme => 'Farbthema:';

  @override
  String get toggleBrightness => 'Helligkeit umschalten';

  @override
  String get changeTheme => 'Thema ändern';

  @override
  String get managePackageGroups => 'Paketgruppen verwalten';

  @override
  String get noPackageGroups => 'Keine Paketgruppen';

  @override
  String get createFirstPackageGroup => 'Erstellen Sie Ihre erste Paketgruppe';

  @override
  String get addGroup => 'Gruppe hinzufügen';

  @override
  String get addPackageGroup => 'Paketgruppe hinzufügen';

  @override
  String get editPackageGroup => 'Paketgruppe bearbeiten';

  @override
  String get groupName => 'Gruppenname';

  @override
  String get enterGroupName => 'Geben Sie den Gruppennamen ein';

  @override
  String get groupNameRequired => 'Gruppenname ist erforderlich';

  @override
  String get duplicateGroupName => 'Doppelter Name';

  @override
  String groupNameAlreadyExists(String name) {
    return 'Eine Gruppe mit dem Namen „$name“ existiert bereits.';
  }

  @override
  String groupCreatedSuccessfully(String name) {
    return 'Gruppe „$name“ erfolgreich erstellt';
  }

  @override
  String failedToCreateGroup(String error) {
    return 'Gruppe konnte nicht erstellt werden: $error';
  }

  @override
  String groupRenamedTo(String name) {
    return 'Gruppe umbenannt in „$name“';
  }

  @override
  String failedToUpdateGroup(String error) {
    return 'Gruppe konnte nicht aktualisiert werden: $error';
  }

  @override
  String get deleteGroup => 'Gruppe löschen';

  @override
  String deleteGroupConfirm(String name) {
    return 'Sind Sie sicher, dass Sie die Gruppe „$name“ löschen möchten?\n\nDiese Aktion kann nicht rückgängig gemacht werden.';
  }

  @override
  String get cannotDeleteGroup => 'Kann nicht gelöscht werden';

  @override
  String groupHasPackages(int count) {
    return 'Diese Gruppe verfügt noch über $count Paket(e). Bitte verschieben oder löschen Sie sie zuerst.';
  }

  @override
  String groupDeleted(String name) {
    return 'Gruppe „$name“ gelöscht';
  }

  @override
  String failedToDeleteGroup(String error) {
    return 'Gruppe konnte nicht gelöscht werden: $error';
  }

  @override
  String get cannotDeleteHasPackagesTooltip =>
      'Kann nicht gelöscht werden (enthält Pakete)';

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
  String get manageGroups => 'Gruppen verwalten';

  @override
  String get featureLangPower => 'Sprachmacht';

  @override
  String get featureAiIntegration => 'KI-Integration';

  @override
  String get featureAdaptivePractice => 'Adaptive Praxis';

  @override
  String get featureMasterAccent => 'Meisterakzent';

  @override
  String get allBadgesEarned =>
      '🎉 Alle Abzeichen verdient! Du bist ein Meister!';

  @override
  String nextBadgeLabel(String name) {
    return 'Weiter: $name';
  }

  @override
  String pointsToGo(String percent) {
    return 'Noch $percent%';
  }

  @override
  String progressPercent(String percent) {
    return '$percent% Fortschritt';
  }

  @override
  String errorTogglingFavourite(String error) {
    return 'Fehler beim Umschalten des Favoriten: $error';
  }

  @override
  String errorTogglingImportant(String error) {
    return 'Fehler beim Umschalten wichtig: $error';
  }

  @override
  String categoryAdded(String name) {
    return 'Kategorie „$name“ hinzugefügt';
  }

  @override
  String errorAddingCategory(String error) {
    return 'Fehler beim Hinzufügen der Kategorie: $error';
  }

  @override
  String categoryRemoved(String name) {
    return 'Kategorie „$name“ entfernt';
  }

  @override
  String errorRemovingCategory(String error) {
    return 'Fehler beim Entfernen der Kategorie: $error';
  }

  @override
  String couldNotOpenUrl(String url) {
    return 'URL konnte nicht geöffnet werden: $url';
  }

  @override
  String errorOpeningUrl(String error) {
    return 'Fehler beim Öffnen der URL: $error';
  }

  @override
  String get pleaseSelectLanguage => 'Bitte wählen Sie eine Sprache aus';

  @override
  String get add => 'Hinzufügen';

  @override
  String get speak => 'Sprechen';

  @override
  String get recordingFailedToStart =>
      'Die Aufnahme konnte nicht gestartet werden!\n\nÜberprüfen Sie:\n1. Mikrofon ist angeschlossen\n2. Das Mikrofon ist als Standardgerät eingestellt\n3. Keine andere App verwendet das Mikrofon';

  @override
  String get recordingFailedNoAudioFile =>
      'Aufnahme fehlgeschlagen – keine Audiodatei erstellt!\n\nMögliche Ursachen:\n1. Mikrofon nicht angeschlossen\n2. Kein Audioeingang erkannt\n3. Problem mit den Windows-Audioeinstellungen';

  @override
  String errorStartingRecordingDetails(String error) {
    return 'Fehler beim Starten der Aufzeichnung: $error';
  }

  @override
  String get openaiEmptyResponse =>
      'Das ausgewählte KI-Modell hat eine leere Antwort zurückgegeben';

  @override
  String get tryDifferentModel =>
      'Versuchen Sie, in der Modellauswahl ein anderes Modell auszuwählen';

  @override
  String get modelMayNotBeSupported =>
      'Dieses Modell wird möglicherweise für Ihr Konto nicht unterstützt oder ist nicht verfügbar';

  @override
  String get reduceTextOrRetry =>
      'Reduzieren Sie die Textlänge oder versuchen Sie es erneut';

  @override
  String get openaiNullContent =>
      'Das ausgewählte KI-Modell hat keinen Inhalt zurückgegeben';

  @override
  String get modelUnsupportedParameter =>
      'Das ausgewählte Modell unterstützt einen erforderlichen API-Parameter nicht';
}
