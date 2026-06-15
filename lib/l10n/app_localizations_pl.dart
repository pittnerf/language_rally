// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get helloWorld => 'Witaj świecie!';

  @override
  String get welcome => 'Zapraszamy na Rajd Językowy';

  @override
  String get appTitle => 'Rajd Językowy';

  @override
  String get createPackage => 'Utwórz pakiet';

  @override
  String get editPackage => 'Edytuj pakiet';

  @override
  String get packageDetails => 'Szczegóły pakietu';

  @override
  String get packageName => 'Nazwa pakietu';

  @override
  String get packageNameHint =>
      'np. podstawy języka hiszpańskiego, podstawy języka niemieckiego';

  @override
  String get languageCode1 => 'Kod języka źródłowego';

  @override
  String get languageName1 => 'Nazwa języka źródłowego';

  @override
  String get languageCode2 => 'Kod języka docelowego';

  @override
  String get languageName2 => 'Nazwa języka docelowego';

  @override
  String get description => 'Opis';

  @override
  String get descriptionHint => 'Krótki opis tego pakietu językowego';

  @override
  String get authorName => 'Imię autora';

  @override
  String get authorEmail => 'Adres e-mail autora';

  @override
  String get authorWebpage => 'Strona internetowa autora';

  @override
  String get version => 'Wersja';

  @override
  String get items => 'rzeczy';

  @override
  String get packageIcon => 'Ikona pakietu';

  @override
  String get packageGroup => 'Grupa Pakietów';

  @override
  String get selectIcon => 'Wybierz ikonę';

  @override
  String get defaultIcon => 'Domyślna ikona';

  @override
  String get customIcon => 'Ikona niestandardowa';

  @override
  String get upload => 'Prześlij ikonę';

  @override
  String get uploadCustomIcon =>
      'Prześlij niestandardową ikonę (maks. 512 x 512, 1 MB)';

  @override
  String get customIconUploaded =>
      'Niestandardowa ikona została przesłana pomyślnie';

  @override
  String get save => 'Ratować';

  @override
  String get edit => 'Redagować';

  @override
  String get cancel => 'Anulować';

  @override
  String get delete => 'Usuwać';

  @override
  String get confirmDelete => 'Czy na pewno chcesz usunąć ten pakiet?';

  @override
  String get packageSaved => 'Pakiet został zapisany pomyślnie';

  @override
  String get packageDeleted => 'Pakiet został pomyślnie usunięty';

  @override
  String get errorSavingPackage => 'Błąd podczas zapisywania pakietu';

  @override
  String get errorDeletingPackage => 'Błąd podczas usuwania pakietu';

  @override
  String get fieldRequired => 'To pole jest wymagane';

  @override
  String get invalidEmail => 'Nieprawidłowy adres e-mail';

  @override
  String get readOnlyPackage =>
      'Ten pakiet jest tylko do odczytu i nie można go edytować';

  @override
  String get purchasedPackage => 'Zakupionych pakietów nie można edytować';

  @override
  String get badges => 'Odznaki';

  @override
  String get noBadges => 'Nie zdobyto jeszcze żadnych odznak';

  @override
  String get selectLanguageCode => 'Wybierz Kod języka';

  @override
  String get typeToSearchLanguages => 'Wpisz, aby wyszukać języki...';

  @override
  String get search => 'Szukaj...';

  @override
  String get clearCounters => 'Wyczyść liczniki';

  @override
  String get confirmClearCounters =>
      'Czy na pewno chcesz wyczyścić wszystkie liczniki szkoleniowe dla tego pakietu? Spowoduje to zresetowanie liczników „nie wiem” i statystyk dotyczących szkoleń.';

  @override
  String get clear => 'Jasne';

  @override
  String get countersCleared => 'Liczniki zostały pomyślnie wyczyszczone';

  @override
  String get errorClearingCounters => 'Błąd podczas czyszczenia liczników';

  @override
  String get deleteAll => 'Usuń pakiet';

  @override
  String get confirmDeleteAllData =>
      'Czy na pewno chcesz usunąć ten pakiet ze WSZYSTKIMI jego danymi? Spowoduje to trwałe usunięcie wszystkich kategorii, przedmiotów i statystyk treningowych. Tej akcji nie można cofnąć!';

  @override
  String get allDataDeleted =>
      'Pakiet i wszystkie dane zostały pomyślnie usunięte';

  @override
  String get exportPackage => 'Pakiet eksportowy';

  @override
  String get selectExportLocation => 'Wybierz opcję Eksportuj lokalizację';

  @override
  String get packageExported => 'Pakiet wyeksportowany pomyślnie';

  @override
  String get errorExportingPackage => 'Błąd podczas eksportowania pakietu';

  @override
  String get importItems => 'Importuj elementy (JSON)';

  @override
  String get importItemsDialogTitle => 'Importuj elementy (JSON)';

  @override
  String get importItemsFromLocalJson => 'Importuj z lokalnego pliku JSON';

  @override
  String get enterItemsUrl => 'Adres URL JSON elementów (https://…)';

  @override
  String get downloadingItems => 'Pobieram elementy…';

  @override
  String get selectImportFile => 'Wybierz opcję Importuj plik';

  @override
  String get importFormat => 'Format importu';

  @override
  String get importFormatDescription =>
      'Importuj elementy z pliku tekstowego. Każda linia powinna zawierać element w następującym formacie:';

  @override
  String get importResults => 'Importuj wyniki';

  @override
  String get successfullyImported => 'Pomyślnie zaimportowano';

  @override
  String get failedToImport => 'Nie udało się zaimportować';

  @override
  String get error => 'Błąd';

  @override
  String get ok => 'OK';

  @override
  String get importPackage => 'Pakiet importowy';

  @override
  String get importPackageTooltip =>
      'Zaimportuj pakiet z pliku ZIP lub adresu URL';

  @override
  String get importPackageDialogTitle => 'Importuj pakiet językowy';

  @override
  String get importFromLocalFile => 'Importuj z pliku lokalnego';

  @override
  String get importFromUrl => 'Importuj z adresu URL';

  @override
  String get enterPackageUrl => 'Adres URL pakietu (https://…)';

  @override
  String get downloadingPackage => 'Pobieram pakiet…';

  @override
  String get downloadFailed =>
      'Pobieranie nie powiodło się. Sprawdź adres URL i swoje połączenie internetowe.';

  @override
  String get invalidUrl =>
      'Wprowadź prawidłowy adres URL http:// lub https://.';

  @override
  String get orLabel => 'Lub';

  @override
  String get selectPackageZipFile => 'Wybierz opcję Spakuj plik ZIP';

  @override
  String get couldNotAccessFile =>
      'Nie można uzyskać dostępu do wybranego pliku.';

  @override
  String get importingPackage => 'Importowanie pakietu...';

  @override
  String get packageImportedSuccessfully => 'Pakiet zaimportowany pomyślnie!';

  @override
  String packageImportedWithItems(Object count) {
    return 'Pakiet zaimportowany pomyślnie! ($count elementy)';
  }

  @override
  String packageImportedWithGroup(Object count, Object groupName) {
    return 'Pakiet zaimportowany do grupy \"$groupName\"! ($count pozycji)';
  }

  @override
  String get importError => 'Błąd importu';

  @override
  String get failedToImportPackage => 'Nie udało się zaimportować pakietu';

  @override
  String get packageAlreadyExists => 'Pakiet już istnieje';

  @override
  String packageExistsMessage(Object groupName) {
    return 'Pakiet z tą samą parą językową, opisem, informacjami o autorze i wersją już istnieje w grupie „$groupName”. Czy mimo to chcesz go zaimportować jako nowy pakiet?';
  }

  @override
  String get importAsNew => 'Importuj mimo to';

  @override
  String get zipFileNotFound => 'Nie znaleziono pliku ZIP';

  @override
  String get invalidPackageZip =>
      'Nieprawidłowy pakiet ZIP: brak pliku package_data.json';

  @override
  String get invalidPackageFormat => 'Nieprawidłowy format pliku pakietu';

  @override
  String get languagePackages => 'Pakiety językowe';

  @override
  String get loadingPackages => 'Ładowanie pakietów...';

  @override
  String get tapAndHoldToReorder =>
      'Dotknij i przytrzymaj, aby zmienić kolejność kart';

  @override
  String get tapAndHoldToReorderList =>
      'Dotknij i przytrzymaj ≡, aby zmienić kolejność. • Dotknij ⋮, aby przełączyć widok kompaktowy';

  @override
  String get noPackagesYet => 'Nie ma jeszcze żadnych pakietów';

  @override
  String get createFirstPackage => 'Stwórz swój pierwszy pakiet językowy';

  @override
  String get versionLabel => 'Wersja';

  @override
  String get purchased => 'Kupiony';

  @override
  String get compactView => 'kompaktowy';

  @override
  String get expand => 'Zwiększać';

  @override
  String get allCategories => 'Wszystkie kategorie';

  @override
  String get categoriesInPackage => 'Kategorie w tym pakiecie';

  @override
  String get categories => 'Kategorie';

  @override
  String get testInterFonts => 'Przetestuj czcionki Inter';

  @override
  String get viewPackages => 'Zobacz pakiety';

  @override
  String get simplifiedPackageView => 'Lista pakietów';

  @override
  String get createNewPackage => 'Utwórz nowy pakiet';

  @override
  String get generateTestData => 'Wygeneruj dane testowe';

  @override
  String get designSystemShowcase => 'Prezentacja systemu projektowania';

  @override
  String get badgeEarned => 'Odznaka zdobyta!';

  @override
  String get achievement => 'Osiągnięcie';

  @override
  String get awesome => 'Wspaniały!';

  @override
  String get importFormatNotes => 'Uwagi:';

  @override
  String get importFormatLine1 => '• Każda linia reprezentuje jeden element';

  @override
  String get importFormatLine2 => '• Pola oddzielone są znakiem |';

  @override
  String get importFormatLine3 => '• Kategorie są oddzielone ;';

  @override
  String get importFormatLine4 => '• Ostatni | jest opcjonalne';

  @override
  String get importFormatLine5 => '• Puste linie są ignorowane';

  @override
  String get importFormatLine6 => '• Duplikaty są pomijane';

  @override
  String get importFormatNewDescription =>
      'Importuj elementy z pliku tekstowego. Każda linia powinna zawierać pozycję z polami oddzielonymi ---';

  @override
  String get importFormatNewLine1 => '• Główny ogranicznik: ---';

  @override
  String get importFormatNewLine2 =>
      '• L1=<tekst> - Tekst główny w języku 1 (wymagany w przypadku braku L2)';

  @override
  String get importFormatNewLine3 =>
      '• L2=<tekst> - Tekst główny w języku 2 (wymagany w przypadku braku L1)';

  @override
  String get importFormatNewLine4 =>
      '• L1pre=<tekst> - Prefiks języka 1 (opcjonalnie)';

  @override
  String get importFormatNewLine5 =>
      '• L1post=<tekst> - przyrostek języka 1 (opcjonalnie)';

  @override
  String get importFormatNewLine6 =>
      '• L2pre=<tekst> - Prefiks języka 2 (opcjonalnie)';

  @override
  String get importFormatNewLine7 =>
      '• L2post=<tekst> — przyrostek języka 2 (opcjonalnie)';

  @override
  String get importFormatNewLine8 =>
      '• EX=<L1 tekst>:::<L2 tekst> - Przykład (opcjonalny, może być wielokrotny)';

  @override
  String get importFormatNewLine9 =>
      '• CAT=<cat1>:::<cat2>:::<cat3> - Kategorie (opcjonalnie)';

  @override
  String get importFormatNewLine10 =>
      '• Przynajmniej jeden z L1= lub L2= musi być obecny';

  @override
  String get importFormatNewLine11 => '• Puste linie są ignorowane';

  @override
  String get importFormatNewLine12 => '• Duplikaty są pomijane';

  @override
  String get invalidImportLine => 'Nieprawidłowa linia';

  @override
  String get missingRequiredFields => 'Brakuje wagi „L1=” „L2=”';

  @override
  String get unknownField => 'Nieznany prefiks pola';

  @override
  String andMore(Object count) {
    return '... i $count więcej';
  }

  @override
  String get browseItems => 'Przeglądaj przedmioty';

  @override
  String get itemDetails => 'Bliższe dane';

  @override
  String get filterItems => 'Filtruj elementy';

  @override
  String searchLanguage1(Object language) {
    return 'Szukaj w $language';
  }

  @override
  String searchLanguage2(Object language) {
    return 'Szukaj w $language';
  }

  @override
  String get caseSensitive => 'Wielkość liter ma znaczenie';

  @override
  String get knownStatus => 'Znany stan';

  @override
  String get filterStatusAll => 'Wszystko';

  @override
  String get filterStatusKnown => 'znany';

  @override
  String get filterStatusUnknown => 'nieznany';

  @override
  String get allItems => 'Wszystkie przedmioty';

  @override
  String get itemsIKnew => 'Przedmioty, które znałem';

  @override
  String get itemsIDidNotKnow => 'Przedmioty, których nie znałem';

  @override
  String get known => 'Znany';

  @override
  String get unknown => 'Nieznany';

  @override
  String get important => 'Ważny';

  @override
  String get favourite => 'Ulubiony';

  @override
  String get badge => 'Odznaka';

  @override
  String get position => 'Pozycja';

  @override
  String get stepsUntilLearned => 'Kroki, aż się nauczysz';

  @override
  String get examples => 'Przykłady';

  @override
  String get noExamples => 'Brak dostępnych przykładów';

  @override
  String get pronounce => 'Wymawiać';

  @override
  String get ttsError => 'Zamiana tekstu na mowę nie jest dostępna';

  @override
  String get noItemsFound => 'Nie znaleziono żadnych elementów';

  @override
  String get noItemsInPackage =>
      'Nie ma jeszcze żadnych elementów w tym pakiecie';

  @override
  String get addItem => 'Dodaj element';

  @override
  String get emptyPackageHint =>
      'Dodaj elementy ręcznie lub użyj sztucznej inteligencji, aby szybko zaimportować elementy';

  @override
  String get noItemsToTrain =>
      'Brak dostępnych elementów do ćwiczeń przy bieżących ustawieniach';

  @override
  String get clearFilters => 'Jasne';

  @override
  String itemCount(Object count) {
    return '$count elementy';
  }

  @override
  String filteredItemCount(Object filtered, Object total) {
    return '$filtered z $total elementów';
  }

  @override
  String get trainingRally => 'Rajd Szkoleniowy';

  @override
  String get startTraining => 'Rozpocznij trening';

  @override
  String get trainingComingSoon => 'Rajd Szkoleniowy - już wkrótce!';

  @override
  String get aiServiceNotConfigured =>
      'Usługa AI nie została skonfigurowana. Dodaj klucz API OpenAI.';

  @override
  String pleaseEnterTextInLanguageFirst(Object language) {
    return 'Najpierw wpisz tekst w $language';
  }

  @override
  String translationCompletedSuccessfully(Object service) {
    return 'Tłumaczenie zostało zakończone pomyślnie przy użyciu $service!';
  }

  @override
  String get translationFailed => 'Tłumaczenie nie powiodło się';

  @override
  String addedExamplesSuccessfully(Object count) {
    return 'Pomyślnie dodano $count przykłady!';
  }

  @override
  String get failedToGenerateExamples => 'Nie udało się wygenerować przykładów';

  @override
  String get selectExamplesToAdd => 'Wybierz przykłady do dodania';

  @override
  String get selectWhichExamples =>
      'Wybierz przykłady, które chcesz dodać do tego elementu:';

  @override
  String get addSelected => 'Dodaj wybrane';

  @override
  String get pleaseSelectAtLeastOne =>
      'Proszę wybrać przynajmniej jeden przykład';

  @override
  String get addNewItem => 'Dodaj nowy element';

  @override
  String get editItem => 'Edytuj element';

  @override
  String get deleteItem => 'Usuń element';

  @override
  String get confirmDeleteItem => 'Czy na pewno chcesz usunąć ten element?';

  @override
  String get thisActionCannotBeUndone => 'Tej akcji nie można cofnąć.';

  @override
  String get itemDeleted => 'Element usunięty';

  @override
  String get errorDeletingItem => 'Błąd podczas usuwania elementu';

  @override
  String get errorSavingItem => 'Błąd podczas zapisywania elementu';

  @override
  String get itemSaved => 'Pozycja została pomyślnie zaktualizowana';

  @override
  String get itemCreated => 'Element został utworzony pomyślnie';

  @override
  String get preTextOptional => 'Tekst wstępny (opcjonalnie)';

  @override
  String get mainText => 'Tekst główny';

  @override
  String get postTextOptional => 'Tekst posta (opcjonalnie)';

  @override
  String get forExampleToForVerbs => 'np. „do” w przypadku czasowników';

  @override
  String get additionalContext => 'Dodatkowy kontekst';

  @override
  String get translate => 'Tłumaczyć';

  @override
  String translateFromTo(Object from, Object to) {
    return 'Przetłumacz $from → $to';
  }

  @override
  String get aiExampleGeneration => 'Generowanie przykładów AI';

  @override
  String get aiExampleSearch => 'Wyszukiwanie przykładów AI';

  @override
  String searchExamplesOnInternet(Object text) {
    return 'Wyszukaj przykładowe zdania w Internecie za pomocą sztucznej inteligencji dla „$text”';
  }

  @override
  String generateExampleSentences(Object language) {
    return 'Generuj przykładowe zdania na podstawie tekstu głównego w $language';
  }

  @override
  String get voiceInput => 'Wprowadzanie głosowe';

  @override
  String get settings => 'Ustawienia';

  @override
  String get uiLanguage => 'Język interfejsu';

  @override
  String get uiLanguageDescription => 'Język interfejsu aplikacji';

  @override
  String get uiLanguageHelper => 'Wybierz język menu, przycisków i etykiet';

  @override
  String get userLanguage => 'Język użytkownika';

  @override
  String get userLanguageDescription =>
      'Twój preferowany język ojczysty do tworzenia nowych pakietów językowych';

  @override
  String get apiKeys => 'Klucze API';

  @override
  String get deeplApiKey => 'Klucz API DeepL';

  @override
  String get deeplApiKeyDescription =>
      'Dla najwyższej jakości tłumaczenia podczas edycji elementów językowych. Zobacz https://www.deepl.com/pro-api';

  @override
  String get openaiApiKey => 'Klucz API OpenAI';

  @override
  String get openaiApiKeyDescription =>
      'Na przykład generowanie za pomocą AI podczas edycji elementów językowych. Zobacz https://platform.openai.com/api-keys';

  @override
  String get enterApiKey => 'Wprowadź klucz API';

  @override
  String get optional => 'fakultatywny';

  @override
  String get required => 'wymagany';

  @override
  String get settingsSaved => 'Ustawienia zostały zapisane pomyślnie';

  @override
  String get errorSavingSettings => 'Błąd podczas zapisywania ustawień';

  @override
  String get usingGoogleTranslate =>
      'Korzystanie z bezpłatnego Tłumacza Google';

  @override
  String get usingDeepL => 'Korzystanie z DeepL (premium)';

  @override
  String get noTranslationReceivedFromGoogle =>
      'Nie otrzymano żadnego tłumaczenia od Google';

  @override
  String get googleTranslationFailed => 'Tłumaczenie Google nie powiodło się';

  @override
  String get googleTranslationError => 'Błąd tłumaczenia Google';

  @override
  String get noTranslationReceivedFromDeepL =>
      'Nie otrzymano żadnego tłumaczenia od DeepL';

  @override
  String get invalidDeepLApiKey => 'Nieprawidłowy klucz API DeepL';

  @override
  String get deeplTranslationQuotaExceeded =>
      'Przekroczono limit tłumaczeń DeepL';

  @override
  String get deeplTranslationFailed => 'Tłumaczenie DeepL nie powiodło się';

  @override
  String get deeplTranslationError => 'Błąd w tłumaczeniu DeepL';

  @override
  String get invalidApiKeyConfigureOpenAI =>
      'Nieprawidłowy klucz API. Skonfiguruj klucz API OpenAI.';

  @override
  String get apiRateLimitExceeded =>
      'Przekroczono limit szybkości interfejsu API. Spróbuj ponownie później.';

  @override
  String get aiRequestFailed => 'Żądanie AI nie powiodło się';

  @override
  String get failedToParseAiResponse =>
      'Nie udało się przeanalizować odpowiedzi AI. Spróbuj ponownie.';

  @override
  String get aiGenerationError => 'Błąd generowania AI';

  @override
  String get voiceInputPlaceholder =>
      'Wprowadzanie głosowe zostanie zaimplementowane przy użyciu pakietu Speech_to_text';

  @override
  String get improveQualityWithApiKeys =>
      '💡 Wskazówka: Jakość tłumaczeń i wyszukiwania przykładów można znacznie poprawić, dodając klucze API DeepL i OpenAI w ustawieniach aplikacji.';

  @override
  String get noApiKeyFallbackMessage =>
      'Bez kluczy API dostępne jest podstawowe tłumaczenie i ograniczona liczba przykładów. Aby uzyskać najlepsze wyniki, skonfiguruj klucze API w Ustawieniach.';

  @override
  String get listeningForSpeech => 'Słucham... Mów teraz';

  @override
  String get speechRecognitionNotAvailable =>
      'Rozpoznawanie mowy nie jest dostępne na tym urządzeniu';

  @override
  String get speechRecognitionPermissionDenied =>
      'Odmówiono pozwolenia na rozpoznawanie mowy';

  @override
  String get speechRecognitionError => 'Błąd rozpoznawania mowy';

  @override
  String get tapToSpeak => 'Kliknij mikrofon, aby mówić';

  @override
  String get tapToStop => 'Kliknij, aby zatrzymać nagrywanie';

  @override
  String get speechNotRecognized =>
      'Nie rozpoznano żadnej mowy. Spróbuj ponownie.';

  @override
  String get usingWhisperApiSlower =>
      'Używanie sztucznej inteligencji w chmurze do rozpoznawania mowy (może działać wolniej)';

  @override
  String languageNotSupportedAddApiKey(String languageCode) {
    return 'Język $languageCode nie jest obsługiwany natywnie. Dodaj klucz API OpenAI w Ustawieniach, aby rozpoznawać mowę w oparciu o sztuczną inteligencję.';
  }

  @override
  String get recordingTapToStop =>
      'Nagrywanie... Stuknij ponownie, aby zatrzymać';

  @override
  String get speakClearlyKeepRecording =>
      'Mów wyraźnie. Nagraj co najmniej 1 sekundę.';

  @override
  String get pleaseRecordLonger =>
      'Proszę mówić przez co najmniej 1 sekundę i kliknąć stop.';

  @override
  String get errorStartingRecording => 'Błąd podczas rozpoczynania nagrywania';

  @override
  String get noAudioRecorded => 'Nie nagrano żadnego dźwięku';

  @override
  String get errorTranscribing => 'Błąd podczas transkrypcji dźwięku';

  @override
  String get trainingSettings => 'Ustawienia treningu';

  @override
  String get trainingPresetTitle => 'Szybka konfiguracja';

  @override
  String get trainingPresetHint =>
      'Wybierz ustawienie wstępne, a poniższe ustawienia zostaną skonfigurowane automatycznie.';

  @override
  String get trainingPresetComboLabel => 'Wstępnie ustawione';

  @override
  String get trainingPresetAllExamplesForeignLanguage =>
      'Wszystkie przykłady, język obcy';

  @override
  String get trainingPresetAllExamplesRandomLanguage =>
      'Wszystkie przykłady, losowy język';

  @override
  String get trainingPresetFavouriteItemsForeignLanguage =>
      'Ulubione przedmioty, język obcy';

  @override
  String get trainingPresetFavouriteItemsRandomLanguage =>
      'Ulubione przedmioty, losowy język';

  @override
  String get trainingPresetImportantItemsForeignLanguage =>
      'Ważne przedmioty, język obcy';

  @override
  String get trainingPresetImportantItemsRandomLanguage =>
      'Ważne przedmioty, losowy język';

  @override
  String get trainingPresetRandomItemsRandomLanguage =>
      'Losowe przedmioty, losowy język';

  @override
  String get trainingPresetUnknownItemsForeignLanguage =>
      'Przedmioty nieznane, język obcy';

  @override
  String get trainingPresetUnknownItemsRandomLanguage =>
      'Nieznane elementy, losowy język';

  @override
  String trainingPresetAppliedTapStart(String actionLabel) {
    return 'Zastosowano ustawienie wstępne. Aby rozpocząć, kliknij „$actionLabel”.';
  }

  @override
  String get trainingPresetSelectPackageFirst => 'Najpierw wybierz pakiet.';

  @override
  String get itemScope => 'Zakres przedmiotu';

  @override
  String get lastNItems => 'Ostatnie N pozycji';

  @override
  String get onlyUnknown => 'Tylko nieznane pozycje';

  @override
  String get onlyImportant => 'Tylko ważne rzeczy';

  @override
  String get onlyFavourite => 'Tylko ulubione przedmioty';

  @override
  String get numberOfItems => 'Liczba elementów';

  @override
  String get itemOrder => 'Zamówienie przedmiotu';

  @override
  String get randomOrder => 'Losowa kolejność';

  @override
  String get sequentialOrder => 'Kolejność sekwencyjna';

  @override
  String get itemType => 'Typ przedmiotu';

  @override
  String get dictionaryItems => 'Elementy słownika';

  @override
  String get examplesType => 'Przykłady';

  @override
  String get displayLanguage => 'Język wyświetlacza';

  @override
  String get motherTongue => 'Język ojczysty';

  @override
  String get targetLanguage => 'Język docelowy';

  @override
  String get randomLanguage => 'Losowy';

  @override
  String get categoryFilter => 'Filtr kategorii';

  @override
  String get categoryFilterHint =>
      'Wybierz kategorie, które chcesz uwzględnić (puste = wszystkie kategorie)';

  @override
  String get noCategories => 'Brak dostępnych kategorii';

  @override
  String get dontKnowThreshold => 'Nie znam progu';

  @override
  String get dontKnowThresholdHint =>
      'Ile razy element wymaga oznaczenia „nie wiem” przed specjalnym postępowaniem';

  @override
  String get startTrainingRally => 'Rozpocznij rajd szkoleniowy';

  @override
  String get clearTrainingSettings => 'Wyczyść ustawienia';

  @override
  String get confirmClearTrainingSettings =>
      'Czy na pewno chcesz zresetować wszystkie ustawienia treningowe do wartości domyślnych?';

  @override
  String get trainingSettingsCleared => 'Ustawienia treningu zostały usunięte';

  @override
  String get startingTraining => 'Rozpoczęcie treningu...';

  @override
  String get noMoreItemsToDisplay =>
      'Brak elementów do wyświetlenia na podstawie ustawień filtra.';

  @override
  String get noItems => 'Brak przedmiotów';

  @override
  String get trainingComplete => 'Szkolenie zakończone';

  @override
  String get allItemsCompleted =>
      'Gratulacje! Ukończyłeś wszystkie elementy tej sesji szkoleniowej.';

  @override
  String get closeTraining => 'Zamknij szkolenie';

  @override
  String get confirmCloseTraining =>
      'Czy na pewno chcesz zamknąć szkolenie? Twoje postępy zostały zapisane.';

  @override
  String get question => 'Pytanie';

  @override
  String get answer => 'Odpowiedź';

  @override
  String get iKnow => 'Ja wiem';

  @override
  String get iDontKnow => 'Nie wiem';

  @override
  String get previousItem => 'Poprzedni element';

  @override
  String get iDidNotKnowEither => 'W końcu tego nie wiedziałem';

  @override
  String get exportBeforeDelete => 'Eksportować przed usunięciem?';

  @override
  String get aiTextAnalysis =>
      'Wyodrębnij elementy z tekstu/listy za pomocą sztucznej inteligencji';

  @override
  String get aiTextAnalysisImport =>
      'Wyodrębnij elementy z tekstu lub listy za pomocą narzędzia AI Text Analysis Tool';

  @override
  String get knowledgeLevel => 'Poziom wiedzy';

  @override
  String get a1Beginner => 'A1 – Początkujący';

  @override
  String get a2Elementary => 'A2 - Podstawowy';

  @override
  String get b1Intermediate => 'B1 – średniozaawansowany';

  @override
  String get b2UpperIntermediate => 'B2 - Wyższy średniozaawansowany';

  @override
  String get c1Advanced => 'C1 – Zaawansowane';

  @override
  String get c2Proficient => 'C2 – Biegły';

  @override
  String get pasteTextHere => 'Wklej tutaj swój tekst...';

  @override
  String get extractWords => 'Wyodrębnij słowa';

  @override
  String get extractExpressions => 'Wyodrębnij wyrażenia';

  @override
  String get maxItems => 'Maksymalna liczba nowych przedmiotów';

  @override
  String get maxItemsHint => 'Pozostaw puste bez ograniczeń';

  @override
  String get generateExamples => 'Generuj przykłady';

  @override
  String get categoryName => 'Nazwa kategorii';

  @override
  String get categoryNameHint => 'Nazwa kategorii importowanych elementów';

  @override
  String get analyzeText => 'Analizuj tekst';

  @override
  String get configureAnalysis => 'Skonfiguruj elementy do wyodrębnienia';

  @override
  String get openaiModel => 'Model AI';

  @override
  String get openaiModelDescription => 'Wybierz model ChatGPT';

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
      'Najnowsza flagowa równowaga jakości i szybkości do ogólnego użytku';

  @override
  String get modelGpt55ProDesc =>
      'Najwyższej klasy wariant GPT-5.5 zapewniający najsilniejsze rozumowanie i jakość';

  @override
  String get modelGpt54Desc =>
      'Mocny model generacji GPT-5 ogólnego przeznaczenia';

  @override
  String get modelGpt54ProDesc =>
      'Wariant GPT-5.4 o większej wydajności do wymagających zadań';

  @override
  String get modelGpt54MiniDesc =>
      'Mniejszy, szybszy wariant GPT-5.4 do tańszych codziennych zadań';

  @override
  String get modelGpt5MiniDesc =>
      'Kompaktowy model z rodziny GPT-5 zoptymalizowany pod kątem szybkości i kosztów';

  @override
  String get modelGpt41Desc =>
      'Niezawodna opcja GPT-4.1 zapewniająca kompatybilność i solidną jakość';

  @override
  String get modelGpt4o => 'GPT-4o';

  @override
  String get modelGpt35Turbo => 'GPT-3.5 Turbo (starsza wersja, budżet)';

  @override
  String get modelGpt35Turbo16k => 'GPT-3.5 Turbo 16K';

  @override
  String get modelGpt4 => 'GPT-4';

  @override
  String get modelGpt4Turbo => 'GPT-4 Turbo (starsza wersja)';

  @override
  String get modelGpt4oDesc =>
      'Najlepszy wybór ogólnego przeznaczenia; szybka, multimodalna i wysoka jakość';

  @override
  String get modelGpt35TurboDesc =>
      'Starsza, tania opcja; przydatne do prostszych zadań i zastosowań wrażliwych na koszty';

  @override
  String get modelGpt35Turbo16kDesc =>
      'To samo co GPT-3.5, ale okno kontekstowe tokena 16 KB';

  @override
  String get modelGpt4Desc =>
      'Wysoka jakość rozumowania; zazwyczaj wolniejsze i droższe';

  @override
  String get modelGpt4TurboDesc =>
      'Opcja starszej rodziny GPT-4; nadal przydatny, gdy potrzebujesz starszej, tańszej alternatywy';

  @override
  String get analyzing => 'Analizuję...';

  @override
  String get languageDetected => 'Wykryto język';

  @override
  String get itemsFound => 'Znaleziono przedmioty';

  @override
  String get selectItemsToImport => 'Wybierz elementy do zaimportowania';

  @override
  String get selectAll => 'Wybierz wszystko';

  @override
  String get deselectAll => 'Odznacz wszystko';

  @override
  String get importSelected => 'Importuj wybrane';

  @override
  String get importing => 'Importowanie...';

  @override
  String get itemsImported => 'Elementy zaimportowane pomyślnie';

  @override
  String get noItemsSelected => 'Nie wybrano żadnych elementów';

  @override
  String get textCannotBeEmpty => 'Tekst nie może być pusty';

  @override
  String get selectAtLeastOneType =>
      'Wybierz co najmniej jeden typ (słowa lub wyrażenia)';

  @override
  String get languageNotMatching =>
      'Wykryty język nie pasuje do żadnego języka w pakiecie';

  @override
  String get openaiKeyRequired =>
      'Do tej funkcji wymagany jest klucz OpenAI API';

  @override
  String analyzingProgress(Object current, Object total) {
    return 'Analizowanie: $current / $total';
  }

  @override
  String translatingProgress(Object current, Object total) {
    return 'Tłumaczenie: $current / $total';
  }

  @override
  String get duplicate => 'Duplikat';

  @override
  String importProgress(Object current, Object total) {
    return 'Importowanie $current z $total';
  }

  @override
  String get detectingLanguage => 'Wykrywanie języka...';

  @override
  String get extractingItems => 'Wyodrębnianie elementów...';

  @override
  String get checkingDuplicates => 'Sprawdzanie duplikatów...';

  @override
  String get translating => 'Tłumaczenie...';

  @override
  String get generatingExamples => 'Generowanie przykładów...';

  @override
  String get errorAnalyzingText => 'Błąd podczas analizy tekstu';

  @override
  String get errorImportingItems => 'Błąd podczas importowania elementów';

  @override
  String get warning => 'Ostrzeżenie';

  @override
  String get textIsVeryLarge => 'Tekst jest bardzo duży';

  @override
  String get words => 'słowa';

  @override
  String get continueAnalysis =>
      'Przetwarzanie może potrwać dłużej i będzie analizowane fragmentarycznie. Czy chcesz kontynuować?';

  @override
  String get continueLabel => 'Kontynuować';

  @override
  String get exportBeforeDeleteMessage =>
      'Czy chcesz wyeksportować ten pakiet przed jego usunięciem? Spowoduje to zapisanie wszystkich danych w pliku ZIP.';

  @override
  String get deleteWithoutExport => 'Usuń bez eksportu';

  @override
  String get exportAndDelete => 'Eksportuj i usuń';

  @override
  String get exportingPackage => 'Eksportuję pakiet...';

  @override
  String packageExportedToPath(Object path) {
    return 'Pakiet wyeksportowany do: $path';
  }

  @override
  String errorLoadingItems(Object error) {
    return 'Błąd ładowania elementów: $error';
  }

  @override
  String badgeEarnedWithName(Object badgeName) {
    return 'Zdobyta odznaka: $badgeName!';
  }

  @override
  String badgeLostWithName(Object badgeName) {
    return 'Utracono odznakę: $badgeName';
  }

  @override
  String get trainingSessionProgress => 'Statystyki sesji treningowych';

  @override
  String get total => 'Całkowity';

  @override
  String lastNValue(Object value) {
    return 'N = $value';
  }

  @override
  String errorLoadingSettings(Object error) {
    return 'Błąd podczas ładowania ustawień: $error';
  }

  @override
  String get selectPackage => 'Wybierz opcję Pakiet';

  @override
  String get noPackagesAvailable => 'Brak dostępnych pakietów';

  @override
  String get possibleSolutions => 'Możliwe rozwiązania';

  @override
  String get technicalDetails => 'Szczegóły techniczne';

  @override
  String get close => 'Zamknąć';

  @override
  String get checkApiKey => 'Sprawdź klucz API OpenAI';

  @override
  String get ensureValidOpenAIKey =>
      'Upewnij się, że klucz API jest ważny i aktywny';

  @override
  String get verifyKeyInSettings => 'Sprawdź klucz w Ustawieniach';

  @override
  String get rateLimitExceeded => 'Przekroczono limit szybkości interfejsu API';

  @override
  String get waitAndRetry => 'Poczekaj kilka minut i spróbuj ponownie';

  @override
  String get checkAccountQuota => 'Sprawdź limit swojego konta OpenAI';

  @override
  String get invalidRequest => 'Nieprawidłowy format żądania';

  @override
  String get tryReducingTextLength => 'Spróbuj zmniejszyć długość tekstu';

  @override
  String get checkTextFormat => 'Sprawdź, czy format tekstu jest prawidłowy';

  @override
  String get checkInternetConnection => 'Sprawdź swoje połączenie internetowe';

  @override
  String get retryInMoment => 'Spróbuj ponownie za chwilę';

  @override
  String get checkFirewall => 'Sprawdź ustawienia zapory sieciowej';

  @override
  String get textMayBeTooShort => 'Tekst może być za krótki';

  @override
  String get tryDifferentKnowledgeLevel => 'Wypróbuj inny poziom wiedzy';

  @override
  String get ensureTextInCorrectLanguage =>
      'Upewnij się, że tekst jest w odpowiednim języku';

  @override
  String get requestTimedOut => 'Upłynął limit czasu żądania';

  @override
  String get textMayBeTooLong => 'Tekst może być za długi';

  @override
  String get tryAgainOrReduceSize =>
      'Spróbuj ponownie lub zmniejsz rozmiar tekstu';

  @override
  String get unexpectedError => 'Wystąpił nieoczekiwany błąd';

  @override
  String get checkErrorDetails => 'Sprawdź szczegóły błędu poniżej';

  @override
  String get tryAgainLater => 'Spróbuj ponownie później';

  @override
  String get translationServiceFailed => 'Usługa tłumaczenia nie powiodła się';

  @override
  String get checkApiKeys => 'Sprawdź swoje klucze API (DeepL, OpenAI)';

  @override
  String get retryImport => 'Ponów próbę importu';

  @override
  String get exampleGenerationFailed =>
      'Wygenerowanie przykładu nie powiodło się';

  @override
  String get itemsStillImported => 'Przedmioty nadal były importowane';

  @override
  String get canAddExamplesManually => 'Możesz później dodać przykłady ręcznie';

  @override
  String get databaseError => 'Wystąpił błąd bazy danych';

  @override
  String get checkStorageSpace => 'Sprawdź dostępną przestrzeń dyskową';

  @override
  String get restartApp => 'Spróbuj ponownie uruchomić aplikację';

  @override
  String get groupLabel => 'Grupa:';

  @override
  String get amendGroups => 'Poprawiać';

  @override
  String get exportItemsJson => 'Eksportuj elementy (JSON)';

  @override
  String get exportItemsJsonTooltip =>
      'Eksportuj wszystkie elementy jako plik JSON';

  @override
  String get noCategoriesInPackage => 'Nie znaleziono kategorii w tym pakiecie';

  @override
  String get noItemsToExport => 'Nie znaleziono elementów do wyeksportowania';

  @override
  String itemsExportedSuccessfully(int count, String path) {
    return 'Pomyślnie wyeksportowano $count elementy do:\n$path';
  }

  @override
  String get errorExportingItems => 'Błąd podczas eksportowania elementów';

  @override
  String get languageMismatch => 'Niedopasowanie językowe';

  @override
  String get languageMismatchDescription =>
      'Języki w pliku JSON nie odpowiadają językom pakietu:';

  @override
  String packageLanguages(String lang1, String lang2) {
    return 'Opakowanie: $lang1 → $lang2';
  }

  @override
  String jsonFileLanguages(String lang1, String lang2) {
    return 'Plik JSON: $lang1 → $lang2';
  }

  @override
  String get continueImportQuestion =>
      'Czy mimo to chcesz kontynuować importowanie?';

  @override
  String get continueImport => 'Kontynuuj importowanie';

  @override
  String get pleaseSelectPackageGroup => 'Proszę wybrać grupę pakietów';

  @override
  String get customIconLabel => 'Zwyczaj';

  @override
  String get defaultIconLabel => 'Domyślny';

  @override
  String get icon2Label => 'Otwórz książkę';

  @override
  String get icon3Label => 'Kolorowa Książka';

  @override
  String get icon4Label => 'Rozmowa';

  @override
  String get icon5Label => 'Podziałka';

  @override
  String get icon6Label => 'Mózg';

  @override
  String get icon7Label => 'Stos książek';

  @override
  String get icon8Label => 'Karta obrazkowa';

  @override
  String get icon9Label => 'Glob';

  @override
  String get icon10Label => 'Ołówek';

  @override
  String get icon11Label => 'Trofeum';

  @override
  String get icon12Label => 'Szukaj';

  @override
  String get customIconFile => 'Ikona niestandardowa';

  @override
  String get importedIconFile => 'Importowana ikona';

  @override
  String get unableToReadImageFile =>
      'Nie można odczytać pliku obrazu. Wybierz prawidłowy obraz.';

  @override
  String iconDimensionsTooLarge(int width, int height) {
    return 'Wymiary ikony są za duże (${width}x$height). Maksymalna dozwolona wielkość to 512 x 512 pikseli.';
  }

  @override
  String get iconFileTooLarge =>
      'Plik ikony jest za duży. Maksymalny rozmiar to 1 MB.';

  @override
  String failedToUploadIcon(String error) {
    return 'Nie udało się przesłać ikony: $error';
  }

  @override
  String get pleaseSelectValidLanguage =>
      'Proszę wybrać prawidłowy język z listy';

  @override
  String get status => 'Status';

  @override
  String get addExample => 'Dodaj przykład';

  @override
  String get noExamplesYet =>
      'Nie ma jeszcze przykładów. Kliknij +, aby dodać.';

  @override
  String get speakText => 'Powiedz tekst';

  @override
  String get removeCategory => 'Usuń kategorię';

  @override
  String removeCategoryConfirm(String categoryName) {
    return 'Usunąć kategorię „$categoryName” z tego produktu?';
  }

  @override
  String get remove => 'Usunąć';

  @override
  String get extractFullItems => 'Wyodrębnij pełne elementy';

  @override
  String get pasteFromClipboard => 'Wklej ze schowka';

  @override
  String get noItemsFoundOrAllDuplicates =>
      'W tekście nie znaleziono żadnych pozycji lub wszystkie pozycje już istnieją w paczce';

  @override
  String get aboutLanguageRally => 'O Rajdzie Językowym';

  @override
  String get welcomeTitle => '🚀 Zapraszamy na Rajd Językowy';

  @override
  String get welcomeSubtitle =>
      'Odblokuj niesamowitą moc nauki języków dzięki około 4000 słów, 4000 wyrażeń i takiej samej liczbie przykładowych zdań – starannie dobranych dla każdego poziomu biegłości! Użyj sztucznej inteligencji, aby importować elementy z własnych tekstów lub rozmawiaj z sztuczną inteligencją na dowolny temat, aby wygenerować dokładnie te słowa, wyrażenia i przykłady, których chcesz się nauczyć.\nPodnieś poziom swoich umiejętności językowych — w inteligentny i zabawny sposób!';

  @override
  String get welcomeIntro =>
      'Skutecznie ucz się słownictwa i wyrażeń, ćwicząc to, na czym Ci naprawdę zależy. Żadnych nudnych list. Bez straty czasu.';

  @override
  String get sectionPlayYourGame => '🎮 Zagraj we własną grę';

  @override
  String get sectionPlayYourGameDesc =>
      'Twórz własne pakiety słownictwa. Trenuj tylko te słowa i wyrażenia, które chcesz opanować. Już to wiesz? Zostanie on oznaczony i pominięty!';

  @override
  String get sectionAITeammate => '🤖 AI jako Twój członek drużyny';

  @override
  String get sectionAITeammateDesc =>
      'Wklej dowolny tekst i pozwól AI:\n• Wyodrębnij przydatne słownictwo\n• Wybierz wyrażenia pasujące do Twojego poziomu\n• Twórz gotowe do szkolenia pakiety w ciągu kilku sekund\n\nPorozmawiaj z AI:\n• Pozwól mu sugerować słowa i wyrażenia związane z Twoim tematem\n• Kliknij, aby wygenerować przykłady i zapisać je we WŁASNYM pakiecie';

  @override
  String get sectionTrainSmart => '🔁 Trenuj mądrze';

  @override
  String get sectionTrainSmartDesc =>
      'Nasz dopracowany system powtórek pokazuje elementy dokładnie wtedy, gdy Twój mózg ich potrzebuje, aby skutecznie je zapamiętać. Maksymalny postęp. Minimalny wysiłek.';

  @override
  String get sectionRealExamples =>
      '🌍 Prawdziwe przykłady. Świetne Tłumaczenia.';

  @override
  String get sectionRealExamplesDesc =>
      'Uzyskaj przykłady użycia z rzeczywistego świata. Tłumacz z najwyższą jakością za pośrednictwem DeepL. Ćwicz wymowę i brzmij pewnie.';

  @override
  String get sectionTeachersWelcome => '👩‍🏫 Nauczyciele Witamy';

  @override
  String get sectionTeachersWelcomeDesc =>
      'Utwórz paczkę → Skopiuj i wklej elementy lub wyodrębnij, przetłumacz, dodaj przykłady za pomocą AI → Eksportuj → Prześlij/wyślij → Gotowe. Twoi uczniowie importują go i natychmiast zaczynają ćwiczyć.';

  @override
  String get sectionUnlockAI => '🔑 Odblokuj pełną moc AI';

  @override
  String get sectionUnlockAIDesc =>
      'Aby uzyskać wysokiej jakości tłumaczenia i funkcje AI, po prostu:\n\n1. Utwórz klucz API DeepL\n   https://www.deepl.com/pro-api\n2. Utwórz klucz API OpenAI\n   https://platform.openai.com/api-keys\n3. Wklej oba klucze do Ustawień\n\nNiewielka inwestycja odblokowuje potężne, profesjonalne narzędzia językowe. Dlaczego miałbyś tego przegapić?\n(W celu uzyskania najlepszych wyników zalecamy korzystanie z płatnego dostępu API.)';

  @override
  String get readyToStart => 'Gotowy do rozpoczęcia rajdu? 🏁';

  @override
  String get welcomeDescription =>
      'Language Rally to kompleksowy towarzysz nauki języków. Twórz niestandardowe pakiety słownictwa, organizuj elementy według kategorii i trenuj, korzystając z inteligentnego systemu powtórek rozmieszczonych w odstępach.';

  @override
  String get browseStore => 'Przeglądaj sklep';

  @override
  String get featureInteractiveTraining => 'Szkolenie interaktywne';

  @override
  String get featureInteractiveTrainingDesc =>
      'Ćwicz z adaptacyjnymi algorytmami uczenia się';

  @override
  String get featureSmartOrganization => 'Inteligentna organizacja';

  @override
  String get featureSmartOrganizationDesc =>
      'Kategoryzuj i filtruj swoje słownictwo';

  @override
  String get featureTrackProgress => 'Śledź postęp';

  @override
  String get featureTrackProgressDesc =>
      'Monitoruj swoją naukę dzięki szczegółowym statystykom';

  @override
  String get featureImportExport => 'Importuj i eksportuj';

  @override
  String get featureImportExportDesc =>
      'Udostępniaj pakiety i synchronizuj je na różnych urządzeniach';

  @override
  String get startAppTour => 'Rozpocznij prezentację aplikacji';

  @override
  String get quickStartGuide => 'Szybki przewodnik';

  @override
  String get tourStep1Title => 'Twórz lub importuj pakiety';

  @override
  String get tourStep1Desc =>
      'Zacznij od utworzenia nowego pakietu językowego lub zaimportuj istniejący z pliku.';

  @override
  String get tourStep2Title => 'Dodaj elementy słownictwa';

  @override
  String get tourStep2Desc =>
      'Przeglądaj swoje pakiety i dodawaj słowa, frazy lub wyrażenia wraz z przykładami i kategoriami.';

  @override
  String get tourStep3Title => 'Skonfiguruj trening';

  @override
  String get tourStep3Desc =>
      'Wybierz elementy do ćwiczenia, ustaw poziomy trudności i dostosuj sposób uczenia się.';

  @override
  String get tourStep4Title => 'Zacznij się uczyć';

  @override
  String get tourStep4Desc =>
      'Rozpocznij sesję treningową i oznacz elementy jako znane lub nieznane, aby śledzić swoje postępy.';

  @override
  String get tourStep5Title => 'Przejrzyj statystyki';

  @override
  String get tourStep5Desc =>
      'Sprawdź swoje postępy w nauce dzięki szczegółowym statystykom i odznakom za osiągnięcia.';

  @override
  String get gotIt => 'Rozumiem!';

  @override
  String get appTourTitle => 'Zapraszamy na Rajd Językowy';

  @override
  String get appTourSubtitle =>
      'Twój inteligentny, zabawny i w pełni spersonalizowany towarzysz nauki języków.';

  @override
  String get tourPage1Title =>
      'Ucz się i ćwicz to, czego chcesz i czego potrzebujesz';

  @override
  String get tourPage1Desc =>
      'Nasz adaptacyjny system uczenia się gwarantuje, że przeglądasz elementy w idealnym momencie — maksymalizując ich przechowywanie i minimalizując wysiłek.\n\nUcz się za pomocą wbudowanej automatyzacji.\nPrzestań marnować czas na słowa, które już znasz.\n\nĆwicz tylko to słownictwo i wyrażenia, które Cię interesują. Twórz i trenuj własne przedmioty — w pełni dostosowane do Twoich celów i poziomu.';

  @override
  String get tourPage2Title => 'Stwórz swój własny pakiet językowy';

  @override
  String get tourPage2Desc =>
      'Twórz spersonalizowane kolekcje słownictwa, które odpowiadają Twoim zainteresowaniom i celom uczenia się.\n\nOrganizuj słowa i wyrażenia według tematu, trudności lub kontekstu.\n\nPełna kontrola nad tym, czego się uczysz i kiedy.';

  @override
  String get tourPage3Title =>
      'Tworzenie przedmiotów wykorzystujących sztuczną inteligencję';

  @override
  String get tourPage3Desc =>
      'Twórz własne pakiety edukacyjne w mgnieniu oka:\n\n• Wklej dowolny tekst i pozwól AI automatycznie wyodrębnić odpowiednie słownictwo\n• Identyfikuj słowa i wyrażenia idealnie dopasowane do Twojego poziomu\n• Pozwól AI wykonać tłumaczenie za Ciebie\n• Pozwól AI wyszukiwać przykłady w czasie rzeczywistym\n\nPorozmawiaj z AI:\n• Pozwól mu sugerować słowa i wyrażenia związane z Twoim tematem\n• Kliknij, aby wygenerować przykłady i zapisać je we WŁASNYM pakiecie\n• Szybkie tworzenie pakietów gotowych do szkolenia';

  @override
  String get tourPage4Title =>
      'Przykłady z prawdziwego świata i tłumaczenia premium oparte na sztucznej inteligencji';

  @override
  String get tourPage4Desc =>
      '• Natychmiastowe wyszukiwanie autentycznych przykładów użycia\n• Tłumacz słowa, wyrażenia i pełne zdania dzięki wysokiej jakości integracji z DeepL\n• Uzyskaj dokładne, uwzględniające kontekst wyniki';

  @override
  String get tourPage5Title => 'Inteligentna organizacja pakietów';

  @override
  String get tourPage5Desc =>
      '• Organizuj słownictwo w niestandardowe kategorie\n• Filtruj i skupiaj się na konkretnych tematach\n• Importuj i eksportuj pakiety na różnych urządzeniach\n• Łatwe udostępnianie pakietów innym osobom';

  @override
  String get tourPage6Title => 'Trening wymowy';

  @override
  String get tourPage6Desc =>
      'Testuj i doskonal swoją wymowę za pomocą interaktywnych narzędzi do ćwiczeń.\n\nBuduj pewność siebie w mówieniu – nie tylko w czytaniu.';

  @override
  String get tourPage7Title => 'Dla nauczycieli';

  @override
  String get tourPage7Desc =>
      'Twórz gotowe do użycia pakiety słownictwa dla swoich uczniów za pomocą kilku kliknięć.\n\nWyeksportuj je, wyślij na zajęcia — a po zaimportowaniu będą od razu gotowe do ćwiczeń na urządzeniu każdego ucznia.\n\nProsty. Szybko. Skuteczny.';

  @override
  String get tourPage8Title => 'Odblokuj wysokiej jakości wsparcie AI';

  @override
  String get tourPage8Desc =>
      'Aby uzyskać tłumaczenia premium i zaawansowane funkcje AI, po prostu:\n 1. Utwórz własny klucz API DeepL\n 2. Utwórz własny klucz API OpenAI\n 3. Wklej oba klucze do sekcji Ustawienia\n\nWymaga to jedynie niewielkiego budżetu (kilka dolarów), ale daje dostęp do potężnych, profesjonalnych narzędzi językowych.\nUwaga: w celu uzyskania najlepszych wyników zalecamy korzystanie z płatnego dostępu API. Kosztuje zaledwie kilka dolarów.\n\n🔑 Klucz API DeepL: https://www.deepl.com/pro-api\n\n🔑 Klucz API OpenAI: https://platform.openai.com/api-keys';

  @override
  String get previousPage => 'Poprzedni';

  @override
  String get nextPage => 'Następny';

  @override
  String get endTour => 'Zakończ wycieczkę';

  @override
  String pageIndicator(int current, int total) {
    return 'Strona $current z $total';
  }

  @override
  String get practicePronunciation => 'Ćwicz wymowę';

  @override
  String get pronunciationPractice => 'Praktyka wymowy';

  @override
  String get startPractice => 'Rozpocznij praktykę';

  @override
  String get listenToPronunciation => 'Posłuchaj wymowy';

  @override
  String get tapToRecord => 'Kliknij, aby nagrać';

  @override
  String get recording => 'Nagranie...';

  @override
  String get recorded => 'Nagrany';

  @override
  String get speakNow => 'Mów teraz – mów wyraźnie i blisko mikrofonu';

  @override
  String get noSpeechDetected => 'Nie wykryto mowy. Spróbuj ponownie.';

  @override
  String get noTextRecognized =>
      'Na nagraniu nie rozpoznano żadnej mowy. Upewnij się, że mikrofon działa i spróbuj ponownie.';

  @override
  String get processingAudio =>
      'Przetwarzanie dźwięku za pomocą sztucznej inteligencji...';

  @override
  String get playbackRecording => 'Odtwórz moje nagranie';

  @override
  String get playbackRecordingSubtitle =>
      'Usłysz swoje nagranie, podczas gdy sztuczna inteligencja je przetwarza';

  @override
  String get recordingTooShort =>
      'Nagranie jest za krótkie. Proszę mówić przynajmniej przez 1 sekundę.';

  @override
  String get microphonePermissionRequired =>
      'Do ćwiczeń wymowy wymagana jest zgoda na korzystanie z mikrofonu';

  @override
  String get speechRecognitionNotSupported =>
      'Rozpoznawanie mowy nie jest obsługiwane na tej platformie. Aby ćwiczyć wymowę, użyj aplikacji mobilnej (Android/iOS).';

  @override
  String get speechRecognitionUnavailable =>
      'Rozpoznawanie mowy nie jest dostępne na tym urządzeniu.';

  @override
  String get pronunciationAccuracy => 'Wymowa\nDokładność';

  @override
  String get excellent => 'Doskonały!';

  @override
  String get good => 'Dobry';

  @override
  String get fair => 'Sprawiedliwy';

  @override
  String get needsImprovement => 'Wymaga poprawy';

  @override
  String get tryAgain => 'Spróbuj ponownie';

  @override
  String get nextItem => 'Następny element';

  @override
  String get endPractice => 'Koniec z praktyką';

  @override
  String get practiced => 'Doświadczony';

  @override
  String get windowsAudioTestPageTitle =>
      'Test dźwięku systemu Windows (RTAudio)';

  @override
  String get configureWindowsAudio =>
      'Przetestuj i skonfiguruj dźwięk\nwejście w systemie Windows';

  @override
  String get configureWindowsAudioDescription =>
      'Nagrywaj, odtwarzaj i transkrybuj dźwięk za pomocą natywnego sterownika Windows RTAudio';

  @override
  String get audioTestTitle => 'Test nagrywania dźwięku w systemie Windows';

  @override
  String get audioTestSubtitle =>
      'RTAudio — natywne nagrywanie dźwięku w systemie Windows';

  @override
  String get audioInputDevice => 'Urządzenie wejściowe audio';

  @override
  String get selectMicrophone => 'Wybierz Mikrofon';

  @override
  String get refreshDevices => 'Odśwież urządzenia';

  @override
  String get noAudioDevicesFound => 'Nie znaleziono urządzeń wejściowych audio';

  @override
  String get loadingAudioDevices => 'Ładowanie urządzeń audio...';

  @override
  String get recordingSettings => 'Ustawienia nagrywania';

  @override
  String get stereoRecording => 'Nagrywanie stereofoniczne';

  @override
  String get stereoChannels => '2 kanały (stereo)';

  @override
  String get monoChannel => '1 kanał (mono)';

  @override
  String get sampleRateLabel => 'Częstotliwość próbkowania';

  @override
  String get nativeRateBadge => 'rodzinny';

  @override
  String get microphoneGainLabel => 'Wzmocnienie mikrofonu';

  @override
  String get gainHint => '1x = brak wzmocnienia • 3x ≈ +9,5 dB • 10x ≈ +20 dB';

  @override
  String get tapToStartRec => 'Stuknij, aby rozpocząć nagrywanie';

  @override
  String get tapToStopRec => 'Stuknij, aby zatrzymać nagrywanie';

  @override
  String get recordingCompleteLabel => 'Nagrywanie zakończone';

  @override
  String get tapMicToStop => 'Kliknij mikrofon, aby zatrzymać';

  @override
  String get playRecordingLabel => 'Odtwórz nagranie';

  @override
  String get stopPlaybackLabel => 'Zatrzymywać się';

  @override
  String get whisperSectionTitle => 'Transkrypcja szeptów OpenAI';

  @override
  String get whisperWavNote =>
      'WAV (16-bitowy PCM) jest natywnie obsługiwany przez Whisper — nie jest wymagana żadna konwersja.';

  @override
  String get sendToWhisperLabel => 'Wyślij do Szeptu';

  @override
  String get transcribingLabel => 'Transkrypcja...';

  @override
  String get transcriptionResultLabel => 'Wynik transkrypcji';

  @override
  String get transcriptionFailedLabel => 'Transkrypcja nie powiodła się';

  @override
  String get debugInformationLabel => 'Informacja';

  @override
  String get debugConsoleHint => 'Sprawdź w konsoli szczegółowe dzienniki';

  @override
  String get debugDevicesFound => 'Znaleziono urządzenia';

  @override
  String get debugSelectedDevice => 'Wybrane urządzenie';

  @override
  String get debugDeviceRateNative => 'Szybkość urządzenia (natywna)';

  @override
  String get debugRequestedRate => 'Żądana stawka';

  @override
  String get debugActualRate => 'Zastosowana rzeczywista stawka';

  @override
  String get debugActualRateForced => '⚠ zmuszony';

  @override
  String get debugActualRateOk => '✓';

  @override
  String get debugRecordingMode => 'Tryb nagrywania';

  @override
  String get debugLastRecording => 'Ostatnie nagranie';

  @override
  String get debugFileSize => 'Rozmiar pliku';

  @override
  String get debugStereo => 'Stereofoniczny';

  @override
  String get debugMono => 'Mononukleoza';

  @override
  String get recordingSavedSnack => 'Nagranie zapisane';

  @override
  String get recordingTooShortSnack =>
      'Nagranie jest za krótkie. Nagrywaj co najmniej 1 sekundę.';

  @override
  String get recordingSmallSnack =>
      'Plik nagrania jest bardzo mały. Nagrywanie mogło się nie udać.';

  @override
  String get noAudioDataSnack => 'Brak zarejestrowanych danych dźwiękowych';

  @override
  String get noDeviceSelectedSnack => 'Wybierz urządzenie audio';

  @override
  String get failedToInitRtAudio => 'Nie udało się zainicjować RTAudio';

  @override
  String get envelopeScoreLabel => 'Koperta';

  @override
  String get rhythmScoreLabel => 'Rytm';

  @override
  String get textScoreLabel => 'Tekst';

  @override
  String get help => 'Pomoc';

  @override
  String get trainingHelpTitle => 'Wskazówki szkoleniowe';

  @override
  String get trainingHelpText =>
      'Aby Twój trening był jak najbardziej efektywny, postępuj zgodnie z poniższymi krokami:\n1. Kliknij przycisk „Wyczyść liczniki”, aby wszystkie pozycje w tej paczce zostały oznaczone jako znane.\n2. Ustaw „Zakres elementu” na „Wszystkie elementy”\n3. Ustaw „Kolejność przedmiotów” na „Losowa”\n4. Wybierz swój język ojczysty w sekcji „Język wyświetlania”\n5. Rozpocznij szkolenie i kontynuuj, aż zidentyfikujesz około 20–30 elementów, których nie znasz.\n6. Wróć do ustawień treningu i zmień „Zakres przedmiotu” na „Tylko nieznane przedmioty”\n7. Wznów szkolenie i kontynuuj, aż nauczysz się wszystkich nieznanych wcześniej elementów.';

  @override
  String get trainingProTip =>
      'Wskazówka dla profesjonalistów: zacznij od wszystkich przedmiotów; później skup się tylko na niewiadomych.';

  @override
  String get onboardingWelcomeTitle => 'Zapraszamy na Rajd Językowy!';

  @override
  String get onboardingSetupSubtitle => 'Skonfigurujemy aplikację za Ciebie.';

  @override
  String get onboardingSelectUiLanguage => 'Język interfejsu';

  @override
  String get onboardingUiLanguageNote =>
      'Możesz to zmienić później w Ustawieniach → Język interfejsu użytkownika.';

  @override
  String get onboardingNext => 'Następny';

  @override
  String get onboardingBack => 'Z powrotem';

  @override
  String get onboardingSelectPackagesTitle => 'Wybierz pakiety językowe';

  @override
  String get onboardingSelectPackagesSubtitle =>
      'Wybierz, które pakiety słownictwa chcesz zaimportować. Zawsze możesz dodać więcej później z menu głównego (Wyświetl pakiety).';

  @override
  String get onboardingAnalyzingPackages => 'Analizowanie dostępnych pakietów…';

  @override
  String onboardingScanningPackagesProgress(
    int scanned,
    int total,
    int alreadyInDb,
  ) {
    return 'Zeskanowano $scanned/$total • już w bazie danych $alreadyInDb';
  }

  @override
  String get onboardingImportSelected => 'Importuj wybrane';

  @override
  String get onboardingSkipImport => 'Pominąć';

  @override
  String get onboardingSelectAll => 'Wybierz wszystko';

  @override
  String get onboardingDeselectAll => 'Odznacz wszystko';

  @override
  String onboardingNPackages(int count) {
    return '$count pakiety';
  }

  @override
  String get onboardingGetStarted => 'Rozpocznij';

  @override
  String get onboardingImportCompleteTitle => 'Import zakończony!';

  @override
  String get importBuiltInPkg => 'Darmowe pakiety';

  @override
  String get importBuiltInPkgTooltip => 'Importuj bezpłatne pakiety językowe';

  @override
  String get globalSearch => 'Wyszukiwanie globalne';

  @override
  String get globalSearchTitle => 'Przeszukaj wszystkie pakiety';

  @override
  String get globalSearchSelectLanguage => 'Wybierz Kod języka';

  @override
  String get globalSearchEnterWord => 'Słowo(a) do wyszukania';

  @override
  String get globalSearchEnterWordHint =>
      'np. „der”, „order” — znajduje częściowe dopasowania';

  @override
  String get globalSearchButton => 'Szukaj';

  @override
  String get globalSearchResults => 'Wyniki';

  @override
  String globalSearchNoResults(String query) {
    return 'Nie znaleziono wyników dla „$query”';
  }

  @override
  String globalSearchResultsCount(int count) {
    return 'Znaleziono wyniki $count';
  }

  @override
  String get globalSearchSearching => 'Badawczy…';

  @override
  String get globalSearchSelectLanguageFirst => 'Najpierw wybierz kod języka';

  @override
  String get globalSearchEnterTermFirst => 'Proszę wpisać wyszukiwane hasło';

  @override
  String get globalSearchMatchInExamples => 'Znaleziono w przykładach';

  @override
  String get globalSearchViewItem => 'Pogląd';

  @override
  String get globalSearchGoToPackage => 'Przejdź do pakietu';

  @override
  String get globalSearchLoadingPackages => 'Ładowanie pakietów…';

  @override
  String get globalSearchNoPackages =>
      'Nie zainstalowano jeszcze żadnych pakietów językowych';

  @override
  String get globalSearchCancelSearch => 'Anuluj wyszukiwanie';

  @override
  String globalSearchProgressOf(int current, int total) {
    return 'Wyszukiwanie pakietu $current z $total…';
  }

  @override
  String globalSearchCancelledMessage(int count) {
    return 'Wyszukiwanie anulowane — dotychczas znaleziono $count wyników';
  }

  @override
  String get storeTitle => 'Sklep z pakietami językowymi';

  @override
  String get storeRestorePurchases => 'Przywróć zakupy';

  @override
  String get storeRefresh => 'Odświeżać';

  @override
  String get storeSearchHint => 'Wyszukaj pakiety…';

  @override
  String get storeNoPackagesMatchSearch =>
      'Żaden pakiet nie pasuje do Twojego wyszukiwania.';

  @override
  String get storeNoPackagesAvailable => 'Brak dostępnych pakietów.';

  @override
  String storeInstalledCount(int installed, int total) {
    return '$installed / $total zainstalowany';
  }

  @override
  String get storeLoadErrorTitle => 'Nie udało się załadować sklepu.';

  @override
  String get storeIapNotAvailableMessage =>
      'Zakupy w aplikacji nie są dostępne na tej platformie. Odwiedź naszą stronę internetową i kup pakiety.';

  @override
  String get storeOpenWebsite => 'Otwórz stronę internetową';

  @override
  String storePurchaseSuccess(String title) {
    return '$title został pomyślnie zainstalowany!';
  }

  @override
  String get storePurchaseCancelled => 'Zakup anulowany.';

  @override
  String storePurchaseAlreadyOwned(String title) {
    return '$title jest już zainstalowany.';
  }

  @override
  String get storePurchaseError => 'Coś poszło nie tak. Spróbuj ponownie.';

  @override
  String get storePurchasesRestored => 'Zakupy przywrócone';

  @override
  String get storeAllLevels => 'Wszystkie poziomy';

  @override
  String get storeAllGroups => 'Wszystkie języki';

  @override
  String get storeFilterLevel => 'Poziom';

  @override
  String get storeFilterLanguage => 'Język';

  @override
  String get storeDownload => 'Pobierać';

  @override
  String get storeBuy => 'Kupić';

  @override
  String get storeInstalledLabel => 'Zainstalowany';

  @override
  String get storeDownloading => 'Ściąganie…';

  @override
  String get storeRetry => 'Spróbować ponownie';

  @override
  String get storeIapAndroidOnly =>
      'Zakupy dostępne wyłącznie na urządzeniach z Androidem i iOS.';

  @override
  String get storeDismiss => 'Odrzucać';

  @override
  String get storeAddToCart => 'Dodaj do koszyka';

  @override
  String get storeRemoveFromCart => 'Usunąć';

  @override
  String get storeCartTitle => 'Koszyk';

  @override
  String get storeCartEmpty => 'Twój koszyk jest pusty';

  @override
  String get storeCartClearAll => 'Wyczyść wszystko';

  @override
  String get storeCartCheckout => 'Wymeldować się';

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
  String get storePackageDuplicateTitle => 'Pakiet już istnieje';

  @override
  String storePackageDuplicateMessage(String packageName, String groupName) {
    return 'Pakiet „$packageName” już istnieje w grupie „$groupName”. Czy chcesz go zastąpić? Istniejący pakiet i cały postęp jego szkolenia zostaną trwale usunięte.';
  }

  @override
  String get storePackageDuplicateOverwrite => 'Przepisać';

  @override
  String get storePackageDuplicateKeep => 'Kontynuuj istnienie';

  @override
  String splashSettingUpPackages(int current, int total) {
    return 'Konfigurowanie pakietów: $current / $total';
  }

  @override
  String get splashThisHappensOnce => 'To zdarza się tylko raz.';

  @override
  String get splashLoading => 'Załadunek…';

  @override
  String get aiItemCreator => 'Guru czatu AI';

  @override
  String get aiItemCreatorAppBarHint =>
      'Zbieraj i zapisuj słowa i wyrażenia, rozmawiając z sztuczną inteligencją';

  @override
  String get chatWithAI => 'Czatuj z AI';

  @override
  String get enterYourPrompt => 'Wpisz monit...';

  @override
  String get aiItemCreatorPromptHint =>
      'Opisz temat, a trener AI zada pytania, zasugeruje przydatne słownictwo i sprawdzi Twoją wiedzę. Na przykład: pomóż mi zebrać i przećwiczyć zagrożenia związane z podróżowaniem na poziomie wiedzy B2';

  @override
  String get send => 'Wysłać';

  @override
  String get sending => 'Przesyłka...';

  @override
  String get aiResponse => 'Odpowiedź AI';

  @override
  String get itemInputs => 'Dane wejściowe pozycji';

  @override
  String get aiItemCreatorBothItemsRequired =>
      'Przed zapisaniem wypełnij oba pola językowe.';

  @override
  String get aiItemCreatorDuplicateItemMessage =>
      'Element z tą samą parą tekstów już istnieje w tym pakiecie.';

  @override
  String get language1 => 'Język 1';

  @override
  String get language2 => 'Język 2';

  @override
  String get translateLang1ToLang2 => 'Przetłumacz na język 2';

  @override
  String get translateLang2ToLang1 => 'Przetłumacz na język 1';

  @override
  String translateToLanguageCode(String languageCode) {
    return 'Przetłumacz na $languageCode';
  }

  @override
  String get example => 'Przykład';

  @override
  String get generating => 'Generowanie...';

  @override
  String get flags => 'Flagi';

  @override
  String get favorite => 'Ulubiony';

  @override
  String get saveItems => 'Ratować';

  @override
  String get saving => 'Oszczędność...';

  @override
  String get clearItems => 'Wyczyść tylko elementy';

  @override
  String get clearAll => 'Wyczyść wszystkie pola';

  @override
  String get itemSavedSuccessfully => 'Pozycja została pomyślnie zapisana';

  @override
  String get promptCannotBeEmpty => 'Podpowiedź nie może być pusta';

  @override
  String get enterAtLeastOneItem =>
      'Proszę wprowadzić przynajmniej jeden element';

  @override
  String get selectPackageFirst => 'Najpierw wybierz pakiet';

  @override
  String get deeplKeyRequired => 'Do tłumaczenia wymagany jest klucz API DeepL';

  @override
  String get noNonPurchasedPackagesAvailable =>
      'Brak dostępnych niezakupionych pakietów';

  @override
  String get packageSelectionRemembered => 'Wybór pakietu został zapisany';

  @override
  String get aiItemCreatorOpenAiKeyNotConfiguredDetailed =>
      'Klucz API OpenAI nie jest skonfigurowany. Dodaj swój klucz API w Ustawieniach.';

  @override
  String get aiItemCreatorOpenAiKeyNotConfigured =>
      'Klucz API OpenAI nie jest skonfigurowany.';

  @override
  String get aiItemCreatorProcessingComplete => 'Przetwarzanie zakończone';

  @override
  String get aiItemCreatorTranslationComingSoon =>
      'Funkcja tłumaczenia już wkrótce';

  @override
  String get aiItemCreatorDefaultCategoryName =>
      'Stworzono sztuczną inteligencję';

  @override
  String get aiItemCreatorStartNewConversation => 'Rozpocznij nową rozmowę';

  @override
  String get aiItemCreatorChatHint =>
      'Opisz temat, a trener AI zada pytania, zasugeruje przydatne słownictwo i sprawdzi Twoją wiedzę.';

  @override
  String get aiItemCreatorConversation => 'Rozmowa';

  @override
  String get aiItemCreatorYou => 'Ty';

  @override
  String get aiItemCreatorCoach => 'Trener AI';

  @override
  String get aiItemCreatorAiSuggestions => 'Sugestie AI';

  @override
  String get aiItemCreatorTapChipToFill =>
      'Kliknij element, aby wypełnić pole elementu i dokonać automatycznego tłumaczenia.';

  @override
  String get aiItemCreatorNoSuggestedItems =>
      'Nie ma jeszcze słów ani wyrażeń.';

  @override
  String get aiItemCreatorNextSteps => 'Jak kontynuować';

  @override
  String get aiItemCreatorNoNextSteps =>
      'Nie ma jeszcze propozycji kontynuacji.';

  @override
  String get aiItemCreatorModelCostTip =>
      'Wskazówka dla profesjonalistów: nowsze modele są droższe, natomiast modele starsze i modele z turbodoładowaniem są tańsze i mogą być znacznie szybsze.';

  @override
  String get aiItemCreatorSelectPackageDialogTitle => 'Wybierz pakiet językowy';

  @override
  String get aiItemCreatorSelectPackageDialogMessage =>
      'Wybierz pakiet językowy, który ma być używany w tej sesji. Twój ostatni wybór jest wstępnie wybrany.';

  @override
  String aiItemCreatorMissingApiKeysWarning(String keys) {
    return 'Brakujące klucze API: $keys. Możesz kontynuować, ale funkcje AI i tłumaczenia premium mogą być ograniczone.';
  }

  @override
  String get about => 'O';

  @override
  String get aboutWebsite => 'Strona internetowa';

  @override
  String get aboutSummaryVideo => 'Film podsumowujacy';

  @override
  String get aboutSupportEmail => 'Pomocniczy adres e-mail';

  @override
  String get aboutWebsiteUrl => 'https://sites.google.com/view/language-rally';

  @override
  String get aboutSummaryVideoUrl =>
      'https://www.youtube.com/watch?v=64Pl9iNF88c';

  @override
  String get aboutSupportEmailAddress => 'językrally.support@gmail.com';

  @override
  String aboutVersionWithValue(String version) {
    return 'Wersja: $version';
  }

  @override
  String aboutCouldNotOpen(String uri) {
    return 'Nie można otworzyć: $uri';
  }

  @override
  String get aboutWelcomeSplashNotFound =>
      'Nie znaleziono obrazu powitalnego powitalnego';

  @override
  String get chooseTheme => 'Wybierz Motyw';

  @override
  String get darkMode => 'Tryb ciemny';

  @override
  String get toggleBetweenLightAndDark =>
      'Przełączaj pomiędzy jasnym i ciemnym';

  @override
  String get colorTheme => 'Motyw kolorystyczny:';

  @override
  String get toggleBrightness => 'Przełącz jasność';

  @override
  String get changeTheme => 'Zmień motyw';

  @override
  String get managePackageGroups => 'Zarządzaj grupami pakietów';

  @override
  String get noPackageGroups => 'Brak grup pakietów';

  @override
  String get createFirstPackageGroup => 'Utwórz swoją pierwszą grupę pakietów';

  @override
  String get addGroup => 'Dodaj grupę';

  @override
  String get addPackageGroup => 'Dodaj grupę pakietów';

  @override
  String get editPackageGroup => 'Edytuj grupę pakietów';

  @override
  String get groupName => 'Nazwa grupy';

  @override
  String get enterGroupName => 'Wprowadź nazwę grupy';

  @override
  String get groupNameRequired => 'Nazwa grupy jest wymagana';

  @override
  String get duplicateGroupName => 'Zduplikowana nazwa';

  @override
  String groupNameAlreadyExists(String name) {
    return 'Grupa o nazwie „$name” już istnieje.';
  }

  @override
  String groupCreatedSuccessfully(String name) {
    return 'Grupa „$name” została utworzona pomyślnie';
  }

  @override
  String failedToCreateGroup(String error) {
    return 'Nie udało się utworzyć grupy: $error';
  }

  @override
  String groupRenamedTo(String name) {
    return 'Nazwa grupy zmieniona na „$name”';
  }

  @override
  String failedToUpdateGroup(String error) {
    return 'Nie udało się zaktualizować grupy: $error';
  }

  @override
  String get deleteGroup => 'Usuń grupę';

  @override
  String deleteGroupConfirm(String name) {
    return 'Czy na pewno chcesz usunąć grupę „$name”?\n\nTej akcji nie można cofnąć.';
  }

  @override
  String get cannotDeleteGroup => 'Nie można usunąć';

  @override
  String groupHasPackages(int count) {
    return 'Ta grupa nadal ma pakiety $count. Najpierw je przenieś lub usuń.';
  }

  @override
  String groupDeleted(String name) {
    return 'Grupa „$name” została usunięta';
  }

  @override
  String failedToDeleteGroup(String error) {
    return 'Nie udało się usunąć grupy: $error';
  }

  @override
  String get cannotDeleteHasPackagesTooltip => 'Nie można usunąć (ma pakiety)';

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
  String get manageGroups => 'Zarządzaj grupami';

  @override
  String get featureLangPower => 'Siła języka';

  @override
  String get featureAiIntegration => 'Integracja sztucznej inteligencji';

  @override
  String get featureAdaptivePractice => 'Praktyka adaptacyjna';

  @override
  String get featureMasterAccent => 'Mistrzowski akcent';

  @override
  String get allBadgesEarned =>
      '🎉 Wszystkie odznaki zdobyte! Jesteś mistrzem!';

  @override
  String nextBadgeLabel(String name) {
    return 'Dalej: $name';
  }

  @override
  String pointsToGo(String percent) {
    return '$percent%, aby przejść';
  }

  @override
  String progressPercent(String percent) {
    return '$percent% postępu';
  }

  @override
  String errorTogglingFavourite(String error) {
    return 'Błąd podczas przełączania ulubionych: $error';
  }

  @override
  String errorTogglingImportant(String error) {
    return 'Błąd podczas przełączania, ważne: $error';
  }

  @override
  String categoryAdded(String name) {
    return 'Dodano kategorię „$name”.';
  }

  @override
  String errorAddingCategory(String error) {
    return 'Błąd podczas dodawania kategorii: $error';
  }

  @override
  String categoryRemoved(String name) {
    return 'Kategoria „$name” została usunięta';
  }

  @override
  String errorRemovingCategory(String error) {
    return 'Błąd podczas usuwania kategorii: $error';
  }

  @override
  String couldNotOpenUrl(String url) {
    return 'Nie można otworzyć adresu URL: $url';
  }

  @override
  String errorOpeningUrl(String error) {
    return 'Błąd podczas otwierania adresu URL: $error';
  }

  @override
  String get pleaseSelectLanguage => 'Proszę wybrać język';

  @override
  String get add => 'Dodać';

  @override
  String get speak => 'Mówić';

  @override
  String get recordingFailedToStart =>
      'Nie udało się rozpocząć nagrywania!\n\nSprawdź:\n1. Mikrofon jest podłączony\n2. Mikrofon jest ustawiony jako urządzenie domyślne\n3. Żadna inna aplikacja nie korzysta z mikrofonu';

  @override
  String get recordingFailedNoAudioFile =>
      'Nagrywanie nie powiodło się - nie utworzono pliku audio!\n\nMożliwe przyczyny:\n1. Mikrofon nie jest podłączony\n2. Nie wykryto wejścia audio\n3. Problem z ustawieniami audio systemu Windows';

  @override
  String errorStartingRecordingDetails(String error) {
    return 'Błąd podczas rozpoczynania nagrywania: $error';
  }

  @override
  String get openaiEmptyResponse => 'Wybrany model AI zwrócił pustą odpowiedź';

  @override
  String get tryDifferentModel =>
      'Spróbuj wybrać inny model z selektora modeli';

  @override
  String get modelMayNotBeSupported =>
      'Ten model może nie być obsługiwany lub dostępny dla Twojego konta';

  @override
  String get reduceTextOrRetry =>
      'Zmniejsz długość tekstu lub spróbuj ponownie';

  @override
  String get openaiNullContent => 'Wybrany model AI nie zwrócił żadnej treści';

  @override
  String get modelUnsupportedParameter =>
      'Wybrany model nie obsługuje wymaganego parametru API';
}
