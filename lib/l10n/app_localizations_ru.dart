// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get helloWorld => 'Привет, мир!';

  @override
  String get welcome => 'Добро пожаловать на языковой митинг';

  @override
  String get appTitle => 'Языковой митинг';

  @override
  String get createPackage => 'Создать пакет';

  @override
  String get editPackage => 'Редактировать пакет';

  @override
  String get packageDetails => 'Детали пакета';

  @override
  String get packageName => 'Имя пакета';

  @override
  String get packageNameHint =>
      'например, Основы испанского языка, Основы немецкого языка';

  @override
  String get languageCode1 => 'Код исходного языка';

  @override
  String get languageName1 => 'Название исходного языка';

  @override
  String get languageCode2 => 'Код целевого языка';

  @override
  String get languageName2 => 'Название целевого языка';

  @override
  String get description => 'Описание';

  @override
  String get descriptionHint => 'Краткое описание этого языкового пакета';

  @override
  String get authorName => 'Имя автора';

  @override
  String get authorEmail => 'Электронная почта автора';

  @override
  String get authorWebpage => 'Веб-страница автора';

  @override
  String get version => 'Версия';

  @override
  String get items => 'предметы';

  @override
  String get packageIcon => 'Значок пакета';

  @override
  String get packageGroup => 'Группа пакетов';

  @override
  String get selectIcon => 'Выберите значок';

  @override
  String get defaultIcon => 'Значок по умолчанию';

  @override
  String get customIcon => 'Пользовательский значок';

  @override
  String get upload => 'Значок загрузки';

  @override
  String get uploadCustomIcon =>
      'Загрузить собственный значок (макс. 512 x 512, 1 МБ)';

  @override
  String get customIconUploaded => 'Пользовательский значок успешно загружен.';

  @override
  String get save => 'Сохранять';

  @override
  String get edit => 'Редактировать';

  @override
  String get cancel => 'Отмена';

  @override
  String get delete => 'Удалить';

  @override
  String get confirmDelete => 'Вы уверены, что хотите удалить этот пакет?';

  @override
  String get packageSaved => 'Пакет успешно сохранен';

  @override
  String get packageDeleted => 'Пакет успешно удален';

  @override
  String get errorSavingPackage => 'Ошибка сохранения пакета.';

  @override
  String get errorDeletingPackage => 'Ошибка удаления пакета';

  @override
  String get fieldRequired => 'Это поле обязательно к заполнению';

  @override
  String get invalidEmail => 'Неверный адрес электронной почты';

  @override
  String get readOnlyPackage =>
      'Этот пакет доступен только для чтения и не может быть изменен.';

  @override
  String get purchasedPackage => 'Купленные пакеты нельзя редактировать.';

  @override
  String get badges => 'Значки';

  @override
  String get noBadges => 'Ни одного значка еще не получено';

  @override
  String get selectLanguageCode => 'Выберите код языка';

  @override
  String get typeToSearchLanguages => 'Введите для поиска языков...';

  @override
  String get search => 'Поиск...';

  @override
  String get clearCounters => 'Очистить счетчики';

  @override
  String get confirmClearCounters =>
      'Вы уверены, что хотите очистить все счетчики обучения для этого пакета? Это приведет к сбросу счетчиков «не знаю» и статистики тренировок.';

  @override
  String get clear => 'Прозрачный';

  @override
  String get countersCleared => 'Счетчики успешно очищены';

  @override
  String get errorClearingCounters => 'Ошибка сброса счетчиков';

  @override
  String get deleteAll => 'Удалить пакет';

  @override
  String get confirmDeleteAllData =>
      'Вы уверены, что хотите удалить этот пакет со ВСЕМИ его данными? Это приведет к безвозвратному удалению всех категорий, элементов и статистики тренировок. Это действие невозможно отменить!';

  @override
  String get allDataDeleted => 'Пакет и все данные успешно удалены.';

  @override
  String get exportPackage => 'Экспортный пакет';

  @override
  String get selectExportLocation => 'Выберите место экспорта';

  @override
  String get packageExported => 'Пакет успешно экспортирован';

  @override
  String get errorExportingPackage => 'Ошибка экспорта пакета.';

  @override
  String get importItems => 'Импортировать элементы (JSON)';

  @override
  String get importItemsDialogTitle => 'Импортировать элементы (JSON)';

  @override
  String get importItemsFromLocalJson => 'Импорт из локального файла JSON';

  @override
  String get enterItemsUrl => 'URL-адрес объекта в формате JSON (https://…)';

  @override
  String get downloadingItems => 'Загрузка объектов…';

  @override
  String get selectImportFile => 'Выберите файл импорта';

  @override
  String get importFormat => 'Формат импорта';

  @override
  String get importFormatDescription =>
      'Импортируйте элементы из текстового файла. Каждая строка должна содержать элемент следующего формата:';

  @override
  String get importResults => 'Импортировать результаты';

  @override
  String get successfullyImported => 'Успешно импортировано';

  @override
  String get failedToImport => 'Не удалось импортировать';

  @override
  String get error => 'Ошибка';

  @override
  String get ok => 'ХОРОШО';

  @override
  String get importPackage => 'Импортировать пакет';

  @override
  String get importPackageTooltip =>
      'Импортировать пакет из ZIP-файла или URL-адреса.';

  @override
  String get importPackageDialogTitle => 'Импортировать языковой пакет';

  @override
  String get importFromLocalFile => 'Импорт из локального файла';

  @override
  String get importFromUrl => 'Импортировать с URL-адреса';

  @override
  String get enterPackageUrl => 'URL-адрес пакета (https://…)';

  @override
  String get downloadingPackage => 'Загрузка пакета…';

  @override
  String get downloadFailed =>
      'Загрузка не удалась. Пожалуйста, проверьте URL-адрес и подключение к Интернету.';

  @override
  String get invalidUrl =>
      'Введите действительный URL-адрес http:// или https://.';

  @override
  String get orLabel => 'или';

  @override
  String get selectPackageZipFile => 'Выберите ZIP-файл пакета';

  @override
  String get couldNotAccessFile =>
      'Не удалось получить доступ к выбранному файлу.';

  @override
  String get importingPackage => 'Импорт пакета...';

  @override
  String get packageImportedSuccessfully => 'Пакет успешно импортирован!';

  @override
  String packageImportedWithItems(Object count) {
    return 'Пакет успешно импортирован! ($count элементов)';
  }

  @override
  String packageImportedWithGroup(Object count, Object groupName) {
    return 'Пакет импортирован в группу «$groupName»! ($count элементов)';
  }

  @override
  String get importError => 'Ошибка импорта';

  @override
  String get failedToImportPackage => 'Не удалось импортировать пакет.';

  @override
  String get packageAlreadyExists => 'Пакет уже существует';

  @override
  String packageExistsMessage(Object groupName) {
    return 'Пакет с такой же языковой парой, описанием, информацией об авторе и версией уже существует в группе «$groupName». Хотите ли вы импортировать его как новый пакет?';
  }

  @override
  String get importAsNew => 'Импортировать в любом случае';

  @override
  String get zipFileNotFound => 'ZIP-файл не найден';

  @override
  String get invalidPackageZip =>
      'Неверный ZIP-архив пакета: отсутствует package_data.json.';

  @override
  String get invalidPackageFormat => 'Неверный формат файла пакета';

  @override
  String get languagePackages => 'Языковые пакеты';

  @override
  String get loadingPackages => 'Загрузка пакетов...';

  @override
  String get tapAndHoldToReorder =>
      'Нажмите и удерживайте, чтобы изменить порядок карточек.';

  @override
  String get tapAndHoldToReorderList =>
      'Нажмите и удерживайте ≡, чтобы изменить порядок. • Нажмите ⋮, чтобы переключить компактный вид.';

  @override
  String get noPackagesYet => 'Пакетов пока нет';

  @override
  String get createFirstPackage => 'Создайте свой первый языковой пакет';

  @override
  String get versionLabel => 'Версия';

  @override
  String get purchased => 'Куплено';

  @override
  String get compactView => 'компактный';

  @override
  String get expand => 'Расширять';

  @override
  String get allCategories => 'Все категории';

  @override
  String get categoriesInPackage => 'Категории в этом пакете';

  @override
  String get categories => 'Категории';

  @override
  String get testInterFonts => 'Тестовые интершрифты';

  @override
  String get viewPackages => 'Посмотреть пакеты';

  @override
  String get simplifiedPackageView => 'Список пакетов';

  @override
  String get createNewPackage => 'Создать новый пакет';

  @override
  String get generateTestData => 'Сгенерируйте тестовые данные';

  @override
  String get designSystemShowcase => 'Демонстрация системы проектирования';

  @override
  String get badgeEarned => 'Значок заработан!';

  @override
  String get achievement => 'Достижение';

  @override
  String get awesome => 'Потрясающий!';

  @override
  String get importFormatNotes => 'Примечания:';

  @override
  String get importFormatLine1 => '• Каждая строка представляет один элемент.';

  @override
  String get importFormatLine2 => '• Поля разделены |';

  @override
  String get importFormatLine3 => '• Категории разделяются ;';

  @override
  String get importFormatLine4 => '• Последний | является необязательным';

  @override
  String get importFormatLine5 => '• Пустые строки игнорируются.';

  @override
  String get importFormatLine6 => '• Дубликаты пропускаются.';

  @override
  String get importFormatNewDescription =>
      'Импортируйте элементы из текстового файла. Каждая строка должна содержать элемент с полями, разделенными ---.';

  @override
  String get importFormatNewLine1 => '• Основной разделитель: ---.';

  @override
  String get importFormatNewLine2 =>
      '• L1=<текст> — основной текст языка 1 (требуется, если L2 отсутствует)';

  @override
  String get importFormatNewLine3 =>
      '• L2=<текст> — основной текст языка 2 (требуется, если L1 отсутствует)';

  @override
  String get importFormatNewLine4 =>
      '• L1pre=<текст> — префикс языка 1 (необязательно).';

  @override
  String get importFormatNewLine5 =>
      '• L1post=<текст> — суффикс языка 1 (необязательно).';

  @override
  String get importFormatNewLine6 =>
      '• L2pre=<текст> — префикс языка 2 (необязательно).';

  @override
  String get importFormatNewLine7 =>
      '• L2post=<текст> — суффикс языка 2 (необязательно).';

  @override
  String get importFormatNewLine8 =>
      '• EX=<текст L1>:::<текст L2> — пример (необязательно, их может быть несколько)';

  @override
  String get importFormatNewLine9 =>
      '• CAT=<cat1>:::<cat2>:::<cat3> — Категории (необязательно).';

  @override
  String get importFormatNewLine10 =>
      '• Должен присутствовать хотя бы один из L1= или L2=.';

  @override
  String get importFormatNewLine11 => '• Пустые строки игнорируются.';

  @override
  String get importFormatNewLine12 => '• Дубликаты пропускаются.';

  @override
  String get invalidImportLine => 'Неверная строка';

  @override
  String get missingRequiredFields => 'Отсутствует \'L1=\', вагия \'L2=\'';

  @override
  String get unknownField => 'Неизвестный префикс поля';

  @override
  String andMore(Object count) {
    return '... и еще $count';
  }

  @override
  String get browseItems => 'Просмотр элементов';

  @override
  String get itemDetails => 'Подробности';

  @override
  String get filterItems => 'Фильтровать элементы';

  @override
  String searchLanguage1(Object language) {
    return 'Искать в $language';
  }

  @override
  String searchLanguage2(Object language) {
    return 'Искать в $language';
  }

  @override
  String get caseSensitive => 'С учетом регистра';

  @override
  String get knownStatus => 'Известный статус';

  @override
  String get filterStatusAll => 'все';

  @override
  String get filterStatusKnown => 'известный';

  @override
  String get filterStatusUnknown => 'неизвестный';

  @override
  String get allItems => 'Все предметы';

  @override
  String get itemsIKnew => 'Предметы, которые я знал';

  @override
  String get itemsIDidNotKnow => 'Предметы, которые я не знал';

  @override
  String get known => 'Известный';

  @override
  String get unknown => 'Неизвестный';

  @override
  String get important => 'Важный';

  @override
  String get favourite => 'Любимый';

  @override
  String get badge => 'Значок';

  @override
  String get position => 'Позиция';

  @override
  String get stepsUntilLearned => 'Шаги, пока не научишься';

  @override
  String get examples => 'Примеры';

  @override
  String get noExamples => 'Нет доступных примеров';

  @override
  String get pronounce => 'Произнести';

  @override
  String get ttsError => 'Преобразование текста в речь недоступно.';

  @override
  String get noItemsFound => 'Элементы не найдены';

  @override
  String get noItemsInPackage => 'В этом пакете пока нет товаров';

  @override
  String get addItem => 'Добавить элемент';

  @override
  String get emptyPackageHint =>
      'Добавляйте элементы вручную или используйте ИИ для быстрого импорта элементов.';

  @override
  String get noItemsToTrain =>
      'Нет доступных элементов для практики с текущими настройками.';

  @override
  String get clearFilters => 'Прозрачный';

  @override
  String itemCount(Object count) {
    return '$count элементов';
  }

  @override
  String filteredItemCount(Object filtered, Object total) {
    return '$filtered из $total элементов';
  }

  @override
  String get trainingRally => 'Тренировочное ралли';

  @override
  String get startTraining => 'Начать обучение';

  @override
  String get trainingComingSoon => 'Тренировочный ралли – скоро!';

  @override
  String get aiServiceNotConfigured =>
      'Служба AI не настроена. Пожалуйста, добавьте свой ключ API OpenAI.';

  @override
  String pleaseEnterTextInLanguageFirst(Object language) {
    return 'Пожалуйста, сначала введите текст в $language';
  }

  @override
  String translationCompletedSuccessfully(Object service) {
    return 'Перевод успешно завершен с использованием $service!';
  }

  @override
  String get translationFailed => 'Перевод не выполнен';

  @override
  String addedExamplesSuccessfully(Object count) {
    return '$count примеров успешно добавлено!';
  }

  @override
  String get failedToGenerateExamples => 'Не удалось создать примеры.';

  @override
  String get selectExamplesToAdd => 'Выберите примеры для добавления';

  @override
  String get selectWhichExamples =>
      'Выберите, какие примеры вы хотите добавить к этому элементу:';

  @override
  String get addSelected => 'Добавить выбранное';

  @override
  String get pleaseSelectAtLeastOne =>
      'Пожалуйста, выберите хотя бы один пример';

  @override
  String get addNewItem => 'Добавить новый элемент';

  @override
  String get editItem => 'Редактировать элемент';

  @override
  String get deleteItem => 'Удалить элемент';

  @override
  String get confirmDeleteItem =>
      'Вы уверены, что хотите удалить этот элемент?';

  @override
  String get thisActionCannotBeUndone => 'Это действие невозможно отменить.';

  @override
  String get itemDeleted => 'Объект удален.';

  @override
  String get errorDeletingItem => 'Ошибка удаления элемента';

  @override
  String get errorSavingItem => 'Ошибка при сохранении объекта.';

  @override
  String get itemSaved => 'Элемент успешно обновлен';

  @override
  String get itemCreated => 'Объект успешно создан';

  @override
  String get preTextOptional => 'Предварительный текст (необязательно)';

  @override
  String get mainText => 'Основной текст';

  @override
  String get postTextOptional => 'Текст сообщения (необязательно)';

  @override
  String get forExampleToForVerbs => 'например, «to» для глаголов';

  @override
  String get additionalContext => 'Дополнительный контекст';

  @override
  String get translate => 'Переводить';

  @override
  String translateFromTo(Object from, Object to) {
    return 'Перевести $from → $to';
  }

  @override
  String get aiExampleGeneration => 'Генерация примера ИИ';

  @override
  String get aiExampleSearch => 'Пример поиска с помощью ИИ';

  @override
  String searchExamplesOnInternet(Object text) {
    return 'Найдите в Интернете примеры предложений с использованием искусственного интеллекта для «$text».';
  }

  @override
  String generateExampleSentences(Object language) {
    return 'Создавайте примеры предложений на основе основного текста в $language.';
  }

  @override
  String get voiceInput => 'Голосовой ввод';

  @override
  String get settings => 'Настройки';

  @override
  String get uiLanguage => 'Язык пользовательского интерфейса';

  @override
  String get uiLanguageDescription => 'Язык интерфейса приложения';

  @override
  String get uiLanguageHelper => 'Выбор языка меню, кнопок и надписей';

  @override
  String get userLanguage => 'Язык пользователя';

  @override
  String get userLanguageDescription =>
      'Предпочитаемый вами родной язык для создания новых языковых пакетов.';

  @override
  String get apiKeys => 'API-ключи';

  @override
  String get deeplApiKey => 'API-ключ DeepL';

  @override
  String get deeplApiKeyDescription =>
      'Для превосходного качества перевода при редактировании языковых элементов. См. https://www.deepl.com/pro-api.';

  @override
  String get openaiApiKey => 'API-ключ OpenAI';

  @override
  String get openaiApiKeyDescription =>
      'Например, генерация с помощью ИИ при редактировании языковых элементов. См. https://platform.openai.com/api-keys.';

  @override
  String get enterApiKey => 'Введите ключ API';

  @override
  String get optional => 'необязательный';

  @override
  String get required => 'необходимый';

  @override
  String get settingsSaved => 'Настройки успешно сохранены';

  @override
  String get errorSavingSettings => 'Ошибка сохранения настроек.';

  @override
  String get usingGoogleTranslate =>
      'Использование бесплатного Google Translate';

  @override
  String get usingDeepL => 'Использование DeepL (премиум)';

  @override
  String get noTranslationReceivedFromGoogle => 'Перевод от Google не получен.';

  @override
  String get googleTranslationFailed => 'Гугл перевод не удался';

  @override
  String get googleTranslationError => 'Ошибка перевода Google';

  @override
  String get noTranslationReceivedFromDeepL => 'Перевод от DeepL не получен.';

  @override
  String get invalidDeepLApiKey => 'Неверный ключ API DeepL.';

  @override
  String get deeplTranslationQuotaExceeded => 'Превышена квота перевода DeepL';

  @override
  String get deeplTranslationFailed => 'Не удалось перевести DeepL';

  @override
  String get deeplTranslationError => 'Ошибка перевода DeepL';

  @override
  String get invalidApiKeyConfigureOpenAI =>
      'Неверный ключ API. Пожалуйста, настройте свой ключ API OpenAI.';

  @override
  String get apiRateLimitExceeded =>
      'Превышен лимит скорости API. Пожалуйста, повторите попытку позже.';

  @override
  String get aiRequestFailed => 'Запрос ИИ не выполнен';

  @override
  String get failedToParseAiResponse =>
      'Не удалось проанализировать ответ AI. Пожалуйста, попробуйте еще раз.';

  @override
  String get aiGenerationError => 'Ошибка генерации ИИ';

  @override
  String get voiceInputPlaceholder =>
      'Голосовой ввод будет реализован с использованием пакета voice_to_text.';

  @override
  String get improveQualityWithApiKeys =>
      '💡Совет: качество переводов и поиска примеров можно значительно улучшить, добавив в настройки приложения свои API-ключи DeepL и OpenAI.';

  @override
  String get noApiKeyFallbackMessage =>
      'Без ключей API предоставляется базовый перевод и ограниченное количество примеров. Для достижения наилучших результатов настройте ключи API в настройках.';

  @override
  String get listeningForSpeech => 'Слушаю... Говори сейчас';

  @override
  String get speechRecognitionNotAvailable =>
      'Распознавание речи недоступно на этом устройстве.';

  @override
  String get speechRecognitionPermissionDenied =>
      'В разрешении на распознавание речи было отказано';

  @override
  String get speechRecognitionError => 'Ошибка распознавания речи';

  @override
  String get tapToSpeak => 'Нажмите на микрофон, чтобы говорить';

  @override
  String get tapToStop => 'Нажмите, чтобы остановить запись';

  @override
  String get speechNotRecognized =>
      'Ни одна речь не была распознана. Пожалуйста, попробуйте еще раз.';

  @override
  String get usingWhisperApiSlower =>
      'Использование облачного ИИ для распознавания речи (может быть медленнее)';

  @override
  String languageNotSupportedAddApiKey(String languageCode) {
    return 'Язык $languageCode изначально не поддерживается. Добавьте ключ OpenAI API в настройки для распознавания речи с помощью искусственного интеллекта.';
  }

  @override
  String get recordingTapToStop =>
      'Запись... Нажмите еще раз, чтобы остановить';

  @override
  String get speakClearlyKeepRecording =>
      'Говорите ясно. Запишите не менее 1 секунды.';

  @override
  String get pleaseRecordLonger =>
      'Пожалуйста, говорите не менее 1 секунды и нажмите «Стоп».';

  @override
  String get errorStartingRecording => 'Ошибка начала записи';

  @override
  String get noAudioRecorded => 'Звук не был записан';

  @override
  String get errorTranscribing => 'Ошибка расшифровки аудио';

  @override
  String get trainingSettings => 'Настройки обучения';

  @override
  String get trainingPresetTitle => 'Быстрая настройка';

  @override
  String get trainingPresetHint =>
      'Выберите предустановку, и приведенные ниже настройки будут настроены автоматически.';

  @override
  String get trainingPresetComboLabel => 'Предустановка';

  @override
  String get trainingPresetAllExamplesForeignLanguage =>
      'Все примеры, иностранный язык';

  @override
  String get trainingPresetAllExamplesRandomLanguage =>
      'Все примеры, произвольный язык';

  @override
  String get trainingPresetFavouriteItemsForeignLanguage =>
      'Любимые предметы, иностранный язык';

  @override
  String get trainingPresetFavouriteItemsRandomLanguage =>
      'Любимые предметы, случайный язык';

  @override
  String get trainingPresetImportantItemsForeignLanguage =>
      'Важные предметы, иностранный язык';

  @override
  String get trainingPresetImportantItemsRandomLanguage =>
      'Важные предметы, случайный язык';

  @override
  String get trainingPresetRandomItemsRandomLanguage =>
      'Случайные предметы, случайный язык';

  @override
  String get trainingPresetUnknownItemsForeignLanguage =>
      'Неизвестные предметы, иностранный язык';

  @override
  String get trainingPresetUnknownItemsRandomLanguage =>
      'Неизвестные предметы, случайный язык';

  @override
  String trainingPresetAppliedTapStart(String actionLabel) {
    return 'Предустановка применена. Нажмите «$actionLabel», чтобы начать.';
  }

  @override
  String get trainingPresetSelectPackageFirst =>
      'Пожалуйста, сначала выберите пакет.';

  @override
  String get itemScope => 'Область применения элемента';

  @override
  String get lastNItems => 'Последние N элементов';

  @override
  String get onlyUnknown => 'Только неизвестные предметы';

  @override
  String get onlyImportant => 'Только важные предметы';

  @override
  String get onlyFavourite => 'Только любимые предметы';

  @override
  String get numberOfItems => 'Количество предметов';

  @override
  String get itemOrder => 'Заказ товара';

  @override
  String get randomOrder => 'Случайный порядок';

  @override
  String get sequentialOrder => 'Последовательный порядок';

  @override
  String get itemType => 'Тип элемента';

  @override
  String get dictionaryItems => 'Словарные статьи';

  @override
  String get examplesType => 'Примеры';

  @override
  String get displayLanguage => 'Язык дисплея';

  @override
  String get motherTongue => 'Родной язык';

  @override
  String get targetLanguage => 'Целевой язык';

  @override
  String get randomLanguage => 'Случайный';

  @override
  String get categoryFilter => 'Фильтр категории';

  @override
  String get categoryFilterHint =>
      'Выберите категории для включения (пусто = все категории)';

  @override
  String get noCategories => 'Нет доступных категорий';

  @override
  String get dontKnowThreshold => 'Не знаю порога';

  @override
  String get dontKnowThresholdHint =>
      'Сколько раз предмет должен быть помечен как «не знаю» перед специальной обработкой';

  @override
  String get startTrainingRally => 'Начать тренировочный ралли';

  @override
  String get clearTrainingSettings => 'Очистить настройки';

  @override
  String get confirmClearTrainingSettings =>
      'Вы уверены, что хотите сбросить все настройки обучения к значениям по умолчанию?';

  @override
  String get trainingSettingsCleared => 'Настройки обучения удалены.';

  @override
  String get startingTraining => 'Начинаю обучение...';

  @override
  String get noMoreItemsToDisplay =>
      'Нет элементов для отображения в соответствии с настройками фильтра.';

  @override
  String get noItems => 'Нет товаров';

  @override
  String get trainingComplete => 'Обучение завершено';

  @override
  String get allItemsCompleted =>
      'Поздравляем! Вы выполнили все пункты этого сеанса обучения.';

  @override
  String get closeTraining => 'Закрытое обучение';

  @override
  String get confirmCloseTraining =>
      'Вы уверены, что хотите закрыть обучение? Ваш прогресс сохранен.';

  @override
  String get question => 'Вопрос';

  @override
  String get answer => 'Отвечать';

  @override
  String get iKnow => 'Я знаю';

  @override
  String get iDontKnow => 'Я не знаю';

  @override
  String get previousItem => 'Предыдущий элемент';

  @override
  String get iDidNotKnowEither => 'Я не знал этого в конце концов';

  @override
  String get exportBeforeDelete => 'Экспортировать перед удалением?';

  @override
  String get aiTextAnalysis =>
      'Извлечение элементов из текста/списка с помощью ИИ';

  @override
  String get aiTextAnalysisImport =>
      'Извлекайте элементы из текста или списка с помощью инструмента анализа текста AI';

  @override
  String get knowledgeLevel => 'Уровень знаний';

  @override
  String get a1Beginner => 'А1 — Новичок';

  @override
  String get a2Elementary => 'А2 – элементарный';

  @override
  String get b1Intermediate => 'B1 – Средний уровень';

  @override
  String get b2UpperIntermediate => 'B2 – уровень выше среднего';

  @override
  String get c1Advanced => 'C1 — Продвинутый';

  @override
  String get c2Proficient => 'C2 – Опытный';

  @override
  String get pasteTextHere => 'Вставьте сюда свой текст...';

  @override
  String get extractWords => 'Извлекать слова';

  @override
  String get extractExpressions => 'Извлечение выражений';

  @override
  String get maxItems => 'Максимум новых предметов';

  @override
  String get maxItemsHint => 'Оставьте пустым, чтобы не было ограничений';

  @override
  String get generateExamples => 'Создание примеров';

  @override
  String get categoryName => 'Название категории';

  @override
  String get categoryNameHint => 'Название категории импортированных товаров';

  @override
  String get analyzeText => 'Анализировать текст';

  @override
  String get configureAnalysis => 'Настройте элементы для извлечения';

  @override
  String get openaiModel => 'Модель ИИ';

  @override
  String get openaiModelDescription => 'Выберите модель ChatGPT';

  @override
  String get modelGpt55 => 'ГПТ-5,5';

  @override
  String get modelGpt55Pro => 'ГПТ-5.5 Про';

  @override
  String get modelGpt54 => 'ГПТ-5.4';

  @override
  String get modelGpt54Pro => 'ГПТ-5.4 Про';

  @override
  String get modelGpt54Mini => 'ГПТ-5.4 Мини';

  @override
  String get modelGpt5Mini => 'ГПТ-5 Мини';

  @override
  String get modelGpt41 => 'ГПТ-4.1';

  @override
  String get modelGpt55Desc =>
      'Новейший флагманский баланс качества и скорости для общего использования.';

  @override
  String get modelGpt55ProDesc =>
      'Самый лучший вариант GPT-5.5 для максимальной аргументации и качества.';

  @override
  String get modelGpt54Desc => 'Сильная универсальная модель поколения GPT-5.';

  @override
  String get modelGpt54ProDesc =>
      'Вариант GPT-5.4 с более высокими возможностями для требовательных задач';

  @override
  String get modelGpt54MiniDesc =>
      'Меньший и более быстрый вариант GPT-5.4 для недорогих повседневных задач.';

  @override
  String get modelGpt5MiniDesc =>
      'Компактная модель семейства GPT-5, оптимизированная по скорости и стоимости.';

  @override
  String get modelGpt41Desc =>
      'Надежный вариант GPT-4.1 для совместимости и высокого качества.';

  @override
  String get modelGpt4o => 'ГПТ-4о';

  @override
  String get modelGpt35Turbo => 'GPT-3.5 Turbo (устаревший, бюджетный)';

  @override
  String get modelGpt35Turbo16k => 'ГПТ-3.5 Турбо 16К';

  @override
  String get modelGpt4 => 'ГПТ-4';

  @override
  String get modelGpt4Turbo => 'GPT-4 Турбо (Устаревший)';

  @override
  String get modelGpt4oDesc =>
      'Лучший универсальный выбор; быстро, мультимодально и качественно';

  @override
  String get modelGpt35TurboDesc =>
      'Устаревший недорогой вариант; полезен для более простых задач и экономичного использования';

  @override
  String get modelGpt35Turbo16kDesc =>
      'То же, что GPT-3.5, но контекстное окно токена 16 КБ.';

  @override
  String get modelGpt4Desc =>
      'Высокое качество рассуждения; обычно медленнее и дороже';

  @override
  String get modelGpt4TurboDesc =>
      'Устаревший вариант семейства GPT-4; все еще полезно, если вам нужна более старая и дешевая альтернатива';

  @override
  String get analyzing => 'Анализ...';

  @override
  String get languageDetected => 'Язык обнаружен';

  @override
  String get itemsFound => 'Найдены предметы';

  @override
  String get selectItemsToImport => 'Выберите элементы для импорта';

  @override
  String get selectAll => 'Выбрать все';

  @override
  String get deselectAll => 'Отменить выбор всех';

  @override
  String get importSelected => 'Импортировать выбранное';

  @override
  String get importing => 'Импорт...';

  @override
  String get itemsImported => 'Товары успешно импортированы';

  @override
  String get noItemsSelected => 'Элементы не выбраны';

  @override
  String get textCannotBeEmpty => 'Текст не может быть пустым';

  @override
  String get selectAtLeastOneType =>
      'Выберите хотя бы один тип (слова или выражения)';

  @override
  String get languageNotMatching =>
      'Обнаруженный язык не соответствует ни одному языку в пакете.';

  @override
  String get openaiKeyRequired => 'Для этой функции требуется ключ API OpenAI.';

  @override
  String analyzingProgress(Object current, Object total) {
    return 'Анализ: $current / $total';
  }

  @override
  String translatingProgress(Object current, Object total) {
    return 'Перевод: $current / $total';
  }

  @override
  String get duplicate => 'Дублировать';

  @override
  String importProgress(Object current, Object total) {
    return 'Импорт $current из $total';
  }

  @override
  String get detectingLanguage => 'Обнаружение языка...';

  @override
  String get extractingItems => 'Извлечение предметов...';

  @override
  String get checkingDuplicates => 'Проверка дубликатов...';

  @override
  String get translating => 'Перевод...';

  @override
  String get generatingExamples => 'Создание примеров...';

  @override
  String get errorAnalyzingText => 'Ошибка анализа текста';

  @override
  String get errorImportingItems => 'Ошибка импорта элементов';

  @override
  String get warning => 'Предупреждение';

  @override
  String get textIsVeryLarge => 'Текст очень большой';

  @override
  String get words => 'слова';

  @override
  String get continueAnalysis =>
      'Обработка может занять больше времени и будет анализироваться частями. Вы хотите продолжить?';

  @override
  String get continueLabel => 'Продолжать';

  @override
  String get exportBeforeDeleteMessage =>
      'Хотите экспортировать этот пакет перед его удалением? Это сохранит все ваши данные в ZIP-файл.';

  @override
  String get deleteWithoutExport => 'Удалить без экспорта';

  @override
  String get exportAndDelete => 'Экспорт и удаление';

  @override
  String get exportingPackage => 'Экспорт пакета...';

  @override
  String packageExportedToPath(Object path) {
    return 'Пакет экспортирован в: $path';
  }

  @override
  String errorLoadingItems(Object error) {
    return 'Ошибка загрузки элементов: $error.';
  }

  @override
  String badgeEarnedWithName(Object badgeName) {
    return 'Получен значок: $badgeName!';
  }

  @override
  String badgeLostWithName(Object badgeName) {
    return 'Значок утерян: $badgeName';
  }

  @override
  String get trainingSessionProgress => 'Статистика сеанса обучения';

  @override
  String get total => 'Общий';

  @override
  String lastNValue(Object value) {
    return 'Н = $value';
  }

  @override
  String errorLoadingSettings(Object error) {
    return 'Ошибка загрузки настроек: $error.';
  }

  @override
  String get selectPackage => 'Выберите пакет';

  @override
  String get noPackagesAvailable => 'Нет доступных пакетов';

  @override
  String get possibleSolutions => 'Возможные решения';

  @override
  String get technicalDetails => 'Технические детали';

  @override
  String get close => 'Закрывать';

  @override
  String get checkApiKey => 'Проверьте свой ключ API OpenAI';

  @override
  String get ensureValidOpenAIKey =>
      'Убедитесь, что ключ API действителен и активен.';

  @override
  String get verifyKeyInSettings => 'Проверьте ключ в настройках';

  @override
  String get rateLimitExceeded => 'Превышен лимит скорости API';

  @override
  String get waitAndRetry => 'Подождите несколько минут и повторите попытку';

  @override
  String get checkAccountQuota => 'Проверьте квоту своей учетной записи OpenAI';

  @override
  String get invalidRequest => 'Неверный формат запроса';

  @override
  String get tryReducingTextLength => 'Попробуйте уменьшить длину текста';

  @override
  String get checkTextFormat => 'Проверьте правильность формата текста';

  @override
  String get checkInternetConnection => 'Проверьте подключение к Интернету';

  @override
  String get retryInMoment => 'Повторите попытку через минуту';

  @override
  String get checkFirewall => 'Проверьте настройки брандмауэра';

  @override
  String get textMayBeTooShort => 'Текст может быть слишком коротким';

  @override
  String get tryDifferentKnowledgeLevel => 'Попробуйте другой уровень знаний';

  @override
  String get ensureTextInCorrectLanguage =>
      'Убедитесь, что текст написан на правильном языке';

  @override
  String get requestTimedOut => 'Время запроса истекло';

  @override
  String get textMayBeTooLong => 'Текст может быть слишком длинным';

  @override
  String get tryAgainOrReduceSize =>
      'Попробуйте еще раз или уменьшите размер текста.';

  @override
  String get unexpectedError => 'Произошла непредвиденная ошибка';

  @override
  String get checkErrorDetails => 'Подробности об ошибке см. ниже.';

  @override
  String get tryAgainLater => 'Повторите попытку позже';

  @override
  String get translationServiceFailed => 'Служба перевода не удалась';

  @override
  String get checkApiKeys => 'Проверьте свои ключи API (DeepL, OpenAI)';

  @override
  String get retryImport => 'Повторите импорт';

  @override
  String get exampleGenerationFailed => 'Генерация примера не удалась';

  @override
  String get itemsStillImported => 'Товары все еще были импортированы';

  @override
  String get canAddExamplesManually =>
      'Вы можете добавить примеры вручную позже.';

  @override
  String get databaseError => 'Произошла ошибка базы данных';

  @override
  String get checkStorageSpace => 'Проверьте доступное место для хранения';

  @override
  String get restartApp => 'Попробуйте перезапустить приложение';

  @override
  String get groupLabel => 'Группа:';

  @override
  String get amendGroups => 'Исправлять';

  @override
  String get exportItemsJson => 'Экспортировать элементы (JSON)';

  @override
  String get exportItemsJsonTooltip =>
      'Экспортируйте все элементы в файл JSON.';

  @override
  String get noCategoriesInPackage => 'В этом пакете категорий не найдено';

  @override
  String get noItemsToExport => 'Не найдено товаров для экспорта';

  @override
  String itemsExportedSuccessfully(int count, String path) {
    return 'Элементы $count успешно экспортированы в:\n$path';
  }

  @override
  String get errorExportingItems => 'Ошибка при экспорте элементов';

  @override
  String get languageMismatch => 'Языковое несоответствие';

  @override
  String get languageMismatchDescription =>
      'Языки в файле JSON не соответствуют языкам пакета:';

  @override
  String packageLanguages(String lang1, String lang2) {
    return 'Пакет: $lang1 → $lang2';
  }

  @override
  String jsonFileLanguages(String lang1, String lang2) {
    return 'Файл JSON: $lang1 → $lang2.';
  }

  @override
  String get continueImportQuestion => 'Вы все равно хотите продолжить импорт?';

  @override
  String get continueImport => 'Продолжить импорт';

  @override
  String get pleaseSelectPackageGroup => 'Пожалуйста, выберите группу пакетов';

  @override
  String get customIconLabel => 'Обычай';

  @override
  String get defaultIconLabel => 'По умолчанию';

  @override
  String get icon2Label => 'Открытая книга';

  @override
  String get icon3Label => 'Цветная книга';

  @override
  String get icon4Label => 'Беседа';

  @override
  String get icon5Label => 'выпускной';

  @override
  String get icon6Label => 'Мозг';

  @override
  String get icon7Label => 'Книга Стопка';

  @override
  String get icon8Label => 'Карточка';

  @override
  String get icon9Label => 'Глобус';

  @override
  String get icon10Label => 'Карандаш';

  @override
  String get icon11Label => 'Трофей';

  @override
  String get icon12Label => 'Поиск';

  @override
  String get customIconFile => 'Пользовательский значок';

  @override
  String get importedIconFile => 'Импортированный значок';

  @override
  String get unableToReadImageFile =>
      'Невозможно прочитать файл изображения. Пожалуйста, выберите допустимое изображение.';

  @override
  String iconDimensionsTooLarge(int width, int height) {
    return 'Размеры значков слишком велики (${width}x$height). Максимально допустимый размер — 512x512 пикселей.';
  }

  @override
  String get iconFileTooLarge =>
      'Файл значка слишком велик. Максимальный размер — 1 МБ.';

  @override
  String failedToUploadIcon(String error) {
    return 'Не удалось загрузить значок: $error.';
  }

  @override
  String get pleaseSelectValidLanguage =>
      'Пожалуйста, выберите действительный язык из списка';

  @override
  String get status => 'Статус';

  @override
  String get addExample => 'Добавить пример';

  @override
  String get noExamplesYet => 'Примеров пока нет. Нажмите +, чтобы добавить.';

  @override
  String get speakText => 'Произнести текст';

  @override
  String get removeCategory => 'Удалить категорию';

  @override
  String removeCategoryConfirm(String categoryName) {
    return 'Удалить категорию «$categoryName» из этого товара?';
  }

  @override
  String get remove => 'Удалять';

  @override
  String get extractFullItems => 'Извлечь полные элементы';

  @override
  String get pasteFromClipboard => 'Вставить из буфера обмена';

  @override
  String get noItemsFoundOrAllDuplicates =>
      'В тексте не найдено ни одного элемента или все элементы уже существуют в пакете.';

  @override
  String get aboutLanguageRally => 'О языковом ралли';

  @override
  String get welcomeTitle => '🚀 Добро пожаловать на Language Rally';

  @override
  String get welcomeSubtitle =>
      'Раскройте невероятную мощь изучения языка с помощью примерно 4000 слов, 4000 выражений и такого же количества примеров предложений, тщательно подобранных для каждого уровня владения языком! Используйте ИИ для импорта элементов из ваших собственных текстов или общайтесь с ИИ на любую тему, чтобы генерировать именно те слова, выражения и примеры, которые вы хотите выучить.\nПовышайте свои языковые навыки — умным и игровым способом!';

  @override
  String get welcomeIntro =>
      'Эффективно изучайте словарный запас и выражения, практикуя то, что вам действительно важно. Никаких скучных списков. Никакого потерянного времени.';

  @override
  String get sectionPlayYourGame => '🎮 Играйте в свою игру';

  @override
  String get sectionPlayYourGameDesc =>
      'Создайте свои собственные словарные пакеты. Тренируйте только те слова и выражения, которые хотите освоить. Уже знаете это? Оно будет отмечено и пропущено!';

  @override
  String get sectionAITeammate => '🤖 ИИ в качестве вашего товарища по команде';

  @override
  String get sectionAITeammateDesc =>
      'Вставьте любой текст и позвольте AI:\n• Извлекайте полезную лексику\n• Выбирайте выражения, соответствующие вашему уровню.\n• Создавайте готовые к обучению пакеты за считанные секунды.\n\nЧат с ИИ:\n• Пусть он подскажет слова и выражения по вашей теме.\n• Нажмите, чтобы создать примеры и сохранить их в своем СОБСТВЕННОМ пакете.';

  @override
  String get sectionTrainSmart => '🔁 Тренируйтесь с умом';

  @override
  String get sectionTrainSmartDesc =>
      'Наша точно настроенная система повторения показывает элементы именно тогда, когда они нужны вашему мозгу, чтобы эффективно их запомнить. Максимальный прогресс. Минимум усилий.';

  @override
  String get sectionRealExamples => '🌍Реальные примеры. Отличные переводы.';

  @override
  String get sectionRealExamplesDesc =>
      'Получите реальные примеры использования. Переводите с премиальным качеством через DeepL. Тренируйте произношение и говорите уверенно.';

  @override
  String get sectionTeachersWelcome => '👩‍🏫 Приглашаем учителей';

  @override
  String get sectionTeachersWelcomeDesc =>
      'Создайте пакет → Копируйте и вставьте элементы или извлекайте, переводите и добавляйте примеры с помощью AI → Экспорт → Загрузить/Отправить → Готово. Ваши ученики импортируют его и сразу же начинают практиковаться.';

  @override
  String get sectionUnlockAI => '🔑 Разблокируйте всю мощь ИИ';

  @override
  String get sectionUnlockAIDesc =>
      'Чтобы получить высококачественный перевод и функции искусственного интеллекта, просто:\n\n1. Создайте свой ключ API DeepL.\n   https://www.deepl.com/pro-api\n2. Создайте свой ключ API OpenAI.\n   https://platform.openai.com/api-keys\n3. Вставьте оба ключа в настройки.\n\nНебольшие инвестиции открывают доступ к мощным языковым инструментам профессионального уровня. Почему бы вам их пропустить?\n(Для достижения наилучших результатов мы рекомендуем использовать платный доступ к API.)';

  @override
  String get readyToStart => 'Готовы начать митинг? 🏁';

  @override
  String get welcomeDescription =>
      'Language Rally — ваш комплексный помощник в изучении языка. Создавайте собственные словарные пакеты, систематизируйте элементы по категориям и тренируйтесь с помощью интеллектуальной системы интервальных повторений.';

  @override
  String get browseStore => 'Обзор магазина';

  @override
  String get featureInteractiveTraining => 'Интерактивное обучение';

  @override
  String get featureInteractiveTrainingDesc =>
      'Практика с алгоритмами адаптивного обучения';

  @override
  String get featureSmartOrganization => 'Умная организация';

  @override
  String get featureSmartOrganizationDesc =>
      'Классифицируйте и фильтруйте свой словарный запас';

  @override
  String get featureTrackProgress => 'Отслеживать прогресс';

  @override
  String get featureTrackProgressDesc =>
      'Контролируйте свое обучение с помощью подробной статистики';

  @override
  String get featureImportExport => 'Импорт и экспорт';

  @override
  String get featureImportExportDesc =>
      'Делитесь пакетами и синхронизируйте их между устройствами';

  @override
  String get startAppTour => 'Начать тур по приложению';

  @override
  String get quickStartGuide => 'Краткое руководство';

  @override
  String get tourStep1Title => 'Создание или импорт пакетов';

  @override
  String get tourStep1Desc =>
      'Начните с создания нового языкового пакета или импортируйте существующий из файла.';

  @override
  String get tourStep2Title => 'Добавьте словарные элементы';

  @override
  String get tourStep2Desc =>
      'Просмотрите свои пакеты и добавьте слова, фразы или выражения с примерами и категориями.';

  @override
  String get tourStep3Title => 'Настроить обучение';

  @override
  String get tourStep3Desc =>
      'Выбирайте предметы для тренировки, устанавливайте уровни сложности и настраивайте свой процесс обучения.';

  @override
  String get tourStep4Title => 'Начать обучение';

  @override
  String get tourStep4Desc =>
      'Начните тренировку и отмечайте элементы как известные или неизвестные, чтобы отслеживать свой прогресс.';

  @override
  String get tourStep5Title => 'Посмотреть статистику';

  @override
  String get tourStep5Desc =>
      'Проверяйте свой прогресс в обучении с помощью подробной статистики и значков достижений.';

  @override
  String get gotIt => 'Понятно!';

  @override
  String get appTourTitle => 'Добро пожаловать на языковой митинг';

  @override
  String get appTourSubtitle =>
      'Ваш умный, игривый и полностью персонализированный помощник в изучении языка.';

  @override
  String get tourPage1Title =>
      'Изучайте и практикуйте то, что вы хотите и что вам нужно';

  @override
  String get tourPage1Desc =>
      'Наша адаптивная система обучения гарантирует, что вы просматриваете элементы в нужный момент — максимально сохраняя информацию и минимизируя усилия.\n\nУчитесь с помощью встроенной автоматизации.\nХватит тратить время на слова, которые вы уже знаете.\n\nПрактикуйте только тот словарный запас и выражения, которые вас интересуют. Создавайте и тренируйте свои собственные предметы — полностью соответствующие вашим целям и уровню.';

  @override
  String get tourPage2Title => 'Создайте свой собственный языковой пакет';

  @override
  String get tourPage2Desc =>
      'Создавайте персонализированные коллекции словаря, соответствующие вашим интересам и целям обучения.\n\nОрганизуйте слова и выражения по теме, сложности или контексту.\n\nПолный контроль над тем, что и когда вы изучаете.';

  @override
  String get tourPage3Title =>
      'Создание предметов с помощью искусственного интеллекта';

  @override
  String get tourPage3Desc =>
      'Создайте свои собственные пакеты обучения в мгновение ока:\n\n• Вставьте любой текст и позвольте ИИ автоматически извлекать соответствующий словарный запас.\n• Определите слова и выражения, идеально подходящие для вашего уровня.\n• Позвольте искусственному интеллекту сделать перевод за вас.\n• Позвольте ИИ искать примеры в реальном времени.\n\nЧат с ИИ:\n• Пусть он подскажет слова и выражения по вашей теме.\n• Нажмите, чтобы создать примеры и сохранить их в своем СОБСТВЕННОМ пакете.\n• Быстро создавайте пакеты, готовые к обучению.';

  @override
  String get tourPage4Title =>
      'Примеры из реальной жизни на основе искусственного интеллекта и перевод премиум-класса';

  @override
  String get tourPage4Desc =>
      '• Мгновенный поиск подлинных примеров использования.\n• Переводите слова, выражения и полные предложения с помощью высококачественной интеграции DeepL.\n• Получайте точные результаты с учетом контекста.';

  @override
  String get tourPage5Title => 'Умная организация пакетов';

  @override
  String get tourPage5Desc =>
      '• Организуйте словарный запас по пользовательским категориям.\n• Фильтруйте и фокусируйтесь на конкретных темах.\n• Импорт и экспорт пакетов на разные устройства.\n• Легко делитесь пакетами с другими';

  @override
  String get tourPage6Title => 'Тренируйте свое произношение';

  @override
  String get tourPage6Desc =>
      'Проверьте и улучшите свое произношение с помощью интерактивных инструментов для практики.\n\nРазвивайте уверенность в разговоре, а не только при чтении.';

  @override
  String get tourPage7Title => 'Для учителей';

  @override
  String get tourPage7Desc =>
      'Создавайте готовые к использованию словарные пакеты для своих учеников всего за несколько кликов.\n\nЭкспортируйте их, отправьте в свой класс — и после импорта они мгновенно будут готовы к практике на устройстве каждого учащегося.\n\nПростой. Быстрый. Эффективно.';

  @override
  String get tourPage8Title =>
      'Разблокируйте высококачественную поддержку искусственного интеллекта';

  @override
  String get tourPage8Desc =>
      'Чтобы получить переводы премиум-класса и расширенные функции искусственного интеллекта, просто:\n 1. Создайте свой собственный ключ API DeepL.\n 2. Создайте свой собственный ключ API OpenAI.\n 3. Вставьте оба ключа в раздел «Настройки».\n\nЭто требует лишь небольшого бюджета (несколько долларов), но дает вам доступ к мощным языковым инструментам профессионального уровня.\nПримечание. Для достижения наилучших результатов мы рекомендуем использовать платный доступ к API. Это стоит всего несколько долларов.\n\n🔑 Ключ API DeepL: https://www.deepl.com/pro-api\n\n🔑 Ключ API OpenAI: https://platform.openai.com/api-keys';

  @override
  String get previousPage => 'Предыдущий';

  @override
  String get nextPage => 'Следующий';

  @override
  String get endTour => 'Конец тура';

  @override
  String pageIndicator(int current, int total) {
    return 'Страница $current из $total';
  }

  @override
  String get practicePronunciation => 'Практикуйте произношение';

  @override
  String get pronunciationPractice => 'Практика произношения';

  @override
  String get startPractice => 'Начать практику';

  @override
  String get listenToPronunciation => 'Слушайте произношение';

  @override
  String get tapToRecord => 'Нажмите, чтобы записать';

  @override
  String get recording => 'Запись...';

  @override
  String get recorded => 'Записано';

  @override
  String get speakNow => 'Говори сейчас — говори четко и близко к микрофону.';

  @override
  String get noSpeechDetected =>
      'Речь не обнаружена. Пожалуйста, попробуйте еще раз.';

  @override
  String get noTextRecognized =>
      'Ни одна речь в записи не была распознана. Убедитесь, что ваш микрофон работает, и повторите попытку.';

  @override
  String get processingAudio => 'Обработка звука с помощью ИИ...';

  @override
  String get playbackRecording => 'Воспроизвести мою запись';

  @override
  String get playbackRecordingSubtitle =>
      'Слушайте свою запись, пока ИИ ее обрабатывает';

  @override
  String get recordingTooShort =>
      'Запись слишком короткая. Пожалуйста, говорите хотя бы 1 секунду.';

  @override
  String get microphonePermissionRequired =>
      'Для практики произношения требуется разрешение микрофона.';

  @override
  String get speechRecognitionNotSupported =>
      'Распознавание речи не поддерживается на этой платформе. Используйте мобильное приложение (Android/iOS) для практики произношения.';

  @override
  String get speechRecognitionUnavailable =>
      'Распознавание речи недоступно на этом устройстве.';

  @override
  String get pronunciationAccuracy => 'Произношение\nТочность';

  @override
  String get excellent => 'Отличный!';

  @override
  String get good => 'Хороший';

  @override
  String get fair => 'Справедливый';

  @override
  String get needsImprovement => 'Требует улучшения';

  @override
  String get tryAgain => 'Попробуйте еще раз';

  @override
  String get nextItem => 'Следующий элемент';

  @override
  String get endPractice => 'Завершить практику';

  @override
  String get practiced => 'Практикующийся';

  @override
  String get windowsAudioTestPageTitle => 'Аудиотест Windows (RTAudio)';

  @override
  String get configureWindowsAudio =>
      'Тестирование и настройка звука\nввод в Windows';

  @override
  String get configureWindowsAudioDescription =>
      'Записывайте, воспроизводите и расшифровывайте звук с помощью встроенного драйвера Windows RTAudio.';

  @override
  String get audioTestTitle => 'Тест записи звука Windows';

  @override
  String get audioTestSubtitle => 'RTAudio — запись звука в Windows.';

  @override
  String get audioInputDevice => 'Устройство аудиовхода';

  @override
  String get selectMicrophone => 'Выберите микрофон';

  @override
  String get refreshDevices => 'Обновить устройства';

  @override
  String get noAudioDevicesFound => 'Устройства аудиовхода не найдены';

  @override
  String get loadingAudioDevices => 'Загрузка аудиоустройств...';

  @override
  String get recordingSettings => 'Настройки записи';

  @override
  String get stereoRecording => 'Стерео запись';

  @override
  String get stereoChannels => '2 канала (стерео)';

  @override
  String get monoChannel => '1 канал (моно)';

  @override
  String get sampleRateLabel => 'Частота дискретизации';

  @override
  String get nativeRateBadge => 'родной';

  @override
  String get microphoneGainLabel => 'Усиление микрофона';

  @override
  String get gainHint => '1x = без усиления • 3x ≈ +9,5 дБ • 10x ≈ +20 дБ';

  @override
  String get tapToStartRec => 'Нажмите, чтобы начать запись';

  @override
  String get tapToStopRec => 'Нажмите, чтобы остановить запись';

  @override
  String get recordingCompleteLabel => 'Запись завершена';

  @override
  String get tapMicToStop => 'Нажмите на микрофон, чтобы остановить';

  @override
  String get playRecordingLabel => 'Воспроизвести запись';

  @override
  String get stopPlaybackLabel => 'Останавливаться';

  @override
  String get whisperSectionTitle => 'Транскрипция шепота OpenAI';

  @override
  String get whisperWavNote =>
      'WAV (16-битный PCM) изначально поддерживается Whisper — преобразование не требуется.';

  @override
  String get sendToWhisperLabel => 'Отправить в Whisper';

  @override
  String get transcribingLabel => 'Расшифровка...';

  @override
  String get transcriptionResultLabel => 'Результат транскрипции';

  @override
  String get transcriptionFailedLabel => 'Транскрипция не удалась';

  @override
  String get debugInformationLabel => 'Информация';

  @override
  String get debugConsoleHint =>
      'Проверьте консоль для получения подробных журналов';

  @override
  String get debugDevicesFound => 'Устройства найдены';

  @override
  String get debugSelectedDevice => 'Выбранное устройство';

  @override
  String get debugDeviceRateNative => 'Скорость устройства (исходная)';

  @override
  String get debugRequestedRate => 'Запрошенная ставка';

  @override
  String get debugActualRate => 'Фактическая использованная ставка';

  @override
  String get debugActualRateForced => '⚠ вынужденный';

  @override
  String get debugActualRateOk => '✓';

  @override
  String get debugRecordingMode => 'Режим записи';

  @override
  String get debugLastRecording => 'Последняя запись';

  @override
  String get debugFileSize => 'Размер файла';

  @override
  String get debugStereo => 'Стерео';

  @override
  String get debugMono => 'Мононуклеоз';

  @override
  String get recordingSavedSnack => 'Запись сохранена.';

  @override
  String get recordingTooShortSnack =>
      'Запись слишком короткая. Пожалуйста, записывайте хотя бы 1 секунду.';

  @override
  String get recordingSmallSnack =>
      'Файл записи очень мал. Возможно, запись не удалась.';

  @override
  String get noAudioDataSnack => 'Аудиоданные не записаны';

  @override
  String get noDeviceSelectedSnack => 'Пожалуйста, выберите аудиоустройство';

  @override
  String get failedToInitRtAudio => 'Не удалось инициализировать RTAudio.';

  @override
  String get envelopeScoreLabel => 'Конверт';

  @override
  String get rhythmScoreLabel => 'Ритм';

  @override
  String get textScoreLabel => 'Текст';

  @override
  String get help => 'Помощь';

  @override
  String get trainingHelpTitle => 'Советы по обучению';

  @override
  String get trainingHelpText =>
      'Чтобы обучение было максимально эффективным, выполните следующие действия:\n1. Нажмите кнопку «Очистить счетчики», чтобы все товары в этом пакете были помечены как известные.\n2. Установите для параметра «Область элемента» значение «Все элементы».\n3. Установите для параметра «Порядок предметов» значение «Случайный».\n4. Выберите свой родной язык в разделе «Язык дисплея».\n5. Начните обучение и продолжайте, пока не определите примерно 20–30 вопросов, которые вам неизвестны.\n6. Вернитесь к настройкам обучения и измените «Объем элемента» на «Только неизвестные элементы».\n7. Возобновите обучение и продолжайте, пока не выучите все ранее неизвестные предметы.';

  @override
  String get trainingProTip =>
      'Совет для профессионалов: начните со всех предметов; позже сосредоточьтесь только на неизвестном.';

  @override
  String get onboardingWelcomeTitle => 'Добро пожаловать на Языковой Ралли!';

  @override
  String get onboardingSetupSubtitle => 'Давайте настроим вам приложение.';

  @override
  String get onboardingSelectUiLanguage => 'Язык интерфейса';

  @override
  String get onboardingUiLanguageNote =>
      'Вы можете изменить это позже в «Настройки» → «Язык пользовательского интерфейса».';

  @override
  String get onboardingNext => 'Следующий';

  @override
  String get onboardingBack => 'Назад';

  @override
  String get onboardingSelectPackagesTitle => 'Выберите языковые пакеты';

  @override
  String get onboardingSelectPackagesSubtitle =>
      'Выберите, какие пакеты словаря нужно импортировать. Вы всегда можете добавить больше позже из главного меню (Просмотр пакетов).';

  @override
  String get onboardingAnalyzingPackages => 'Анализ доступных пакетов…';

  @override
  String onboardingScanningPackagesProgress(
    int scanned,
    int total,
    int alreadyInDb,
  ) {
    return 'Отсканировано $scanned/$total • уже в БД $alreadyInDb.';
  }

  @override
  String get onboardingImportSelected => 'Импортировать выбранное';

  @override
  String get onboardingSkipImport => 'Пропускать';

  @override
  String get onboardingSelectAll => 'Выбрать все';

  @override
  String get onboardingDeselectAll => 'Отменить выбор всех';

  @override
  String onboardingNPackages(int count) {
    return '$count пакеты';
  }

  @override
  String get onboardingGetStarted => 'Начать';

  @override
  String get onboardingImportCompleteTitle => 'Импорт завершен!';

  @override
  String get importBuiltInPkg => 'Бесплатные пакеты';

  @override
  String get importBuiltInPkgTooltip =>
      'Импортируйте бесплатные встроенные языковые пакеты.';

  @override
  String get globalSearch => 'Глобальный поиск';

  @override
  String get globalSearchTitle => 'Поиск по всем пакетам';

  @override
  String get globalSearchSelectLanguage => 'Выберите код языка';

  @override
  String get globalSearchEnterWord => 'Слово(а) для поиска';

  @override
  String get globalSearchEnterWordHint =>
      'например «der», «order» — находит частичные совпадения';

  @override
  String get globalSearchButton => 'Поиск';

  @override
  String get globalSearchResults => 'Результаты';

  @override
  String globalSearchNoResults(String query) {
    return 'По запросу \"$query\" результатов не найдено.';
  }

  @override
  String globalSearchResultsCount(int count) {
    return '$count найдено результатов';
  }

  @override
  String get globalSearchSearching => 'Идет поиск…';

  @override
  String get globalSearchSelectLanguageFirst =>
      'Пожалуйста, сначала выберите код языка';

  @override
  String get globalSearchEnterTermFirst =>
      'Пожалуйста, введите поисковый запрос';

  @override
  String get globalSearchMatchInExamples => 'Встречается в примерах';

  @override
  String get globalSearchViewItem => 'Вид';

  @override
  String get globalSearchGoToPackage => 'Перейти к пакету';

  @override
  String get globalSearchLoadingPackages => 'Загрузка пакетов…';

  @override
  String get globalSearchNoPackages => 'Языковые пакеты еще не установлены';

  @override
  String get globalSearchCancelSearch => 'Отменить поиск';

  @override
  String globalSearchProgressOf(int current, int total) {
    return 'Поиск пакета $current из $total…';
  }

  @override
  String globalSearchCancelledMessage(int count) {
    return 'Поиск отменен — на данный момент найдено $count результатов';
  }

  @override
  String get storeTitle => 'Магазин языковых пакетов';

  @override
  String get storeRestorePurchases => 'Восстановление покупок';

  @override
  String get storeRefresh => 'Обновить';

  @override
  String get storeSearchHint => 'Поиск пакетов…';

  @override
  String get storeNoPackagesMatchSearch =>
      'Нет пакетов, соответствующих вашему запросу.';

  @override
  String get storeNoPackagesAvailable => 'Нет доступных пакетов.';

  @override
  String storeInstalledCount(int installed, int total) {
    return '$installed / $total установлен';
  }

  @override
  String get storeLoadErrorTitle => 'Не удалось загрузить магазин.';

  @override
  String get storeIapNotAvailableMessage =>
      'Покупки в приложении недоступны на этой платформе. Посетите наш сайт, чтобы приобрести пакеты.';

  @override
  String get storeOpenWebsite => 'Открыть сайт';

  @override
  String storePurchaseSuccess(String title) {
    return '$title успешно установлен!';
  }

  @override
  String get storePurchaseCancelled => 'Покупка отменена.';

  @override
  String storePurchaseAlreadyOwned(String title) {
    return '$title уже установлен.';
  }

  @override
  String get storePurchaseError =>
      'Что-то пошло не так. Пожалуйста, попробуйте еще раз.';

  @override
  String get storePurchasesRestored => 'Покупки восстановлены';

  @override
  String get storeAllLevels => 'Все уровни';

  @override
  String get storeAllGroups => 'Все языки';

  @override
  String get storeFilterLevel => 'Уровень';

  @override
  String get storeFilterLanguage => 'Язык';

  @override
  String get storeDownload => 'Скачать';

  @override
  String get storeBuy => 'Купить';

  @override
  String get storeInstalledLabel => 'Установлено';

  @override
  String get storeDownloading => 'Загрузка…';

  @override
  String get storeRetry => 'Повторить попытку';

  @override
  String get storeIapAndroidOnly => 'Покупки доступны только на Android и iOS.';

  @override
  String get storeDismiss => 'Увольнять';

  @override
  String get storeAddToCart => 'добавить в корзину';

  @override
  String get storeRemoveFromCart => 'Удалять';

  @override
  String get storeCartTitle => 'Корзина';

  @override
  String get storeCartEmpty => 'Ваша корзина пуста';

  @override
  String get storeCartClearAll => 'Очистить все';

  @override
  String get storeCartCheckout => 'Проверить';

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
  String get storePackageDuplicateTitle => 'Пакет уже существует';

  @override
  String storePackageDuplicateMessage(String packageName, String groupName) {
    return 'Пакет «$packageName» уже существует в группе «$groupName». Вы хотите перезаписать его? Существующий пакет и весь прогресс его обучения будут удалены без возможности восстановления.';
  }

  @override
  String get storePackageDuplicateOverwrite => 'Перезаписать';

  @override
  String get storePackageDuplicateKeep => 'Сохранить существующий';

  @override
  String splashSettingUpPackages(int current, int total) {
    return 'Настройка пакетов: $current/$total';
  }

  @override
  String get splashThisHappensOnce => 'Это происходит только один раз.';

  @override
  String get splashLoading => 'Загрузка…';

  @override
  String get aiItemCreator => 'Гуру AI-чата';

  @override
  String get aiItemCreatorAppBarHint =>
      'Собирайте и сохраняйте слова и выражения, общаясь с ИИ.';

  @override
  String get chatWithAI => 'Чат с ИИ';

  @override
  String get enterYourPrompt => 'Введите подсказку...';

  @override
  String get aiItemCreatorPromptHint =>
      'Опишите тему, и тренер по искусственному интеллекту задаст вопросы, предложит полезную лексику и проверит ваши знания. Например: помогите мне собрать и отработать опасности, связанные с путешествием, на уровне знаний B2.';

  @override
  String get send => 'Отправлять';

  @override
  String get sending => 'Отправка...';

  @override
  String get aiResponse => 'Ответ ИИ';

  @override
  String get itemInputs => 'Вводы предметов';

  @override
  String get aiItemCreatorBothItemsRequired =>
      'Перед сохранением заполните оба языковых поля.';

  @override
  String get aiItemCreatorDuplicateItemMessage =>
      'Элемент с такой текстовой парой уже существует в этом пакете.';

  @override
  String get language1 => 'Язык 1';

  @override
  String get language2 => 'Язык 2';

  @override
  String get translateLang1ToLang2 => 'Перевести на язык 2';

  @override
  String get translateLang2ToLang1 => 'Перевести на язык 1';

  @override
  String translateToLanguageCode(String languageCode) {
    return 'Перевести на $languageCode';
  }

  @override
  String get example => 'Пример';

  @override
  String get generating => 'Создание...';

  @override
  String get flags => 'Флаги';

  @override
  String get favorite => 'Любимый';

  @override
  String get saveItems => 'Сохранять';

  @override
  String get saving => 'Сохранение...';

  @override
  String get clearItems => 'Очистить только элементы';

  @override
  String get clearAll => 'Очистить все поля';

  @override
  String get itemSavedSuccessfully => 'Объект успешно сохранен';

  @override
  String get promptCannotBeEmpty => 'Запрос не может быть пустым';

  @override
  String get enterAtLeastOneItem => 'Пожалуйста, введите хотя бы один элемент';

  @override
  String get selectPackageFirst => 'Пожалуйста, сначала выберите пакет';

  @override
  String get deeplKeyRequired => 'Для перевода необходим ключ API DeepL.';

  @override
  String get noNonPurchasedPackagesAvailable =>
      'Нет доступных некупленных пакетов';

  @override
  String get packageSelectionRemembered => 'Выбор пакета сохранен.';

  @override
  String get aiItemCreatorOpenAiKeyNotConfiguredDetailed =>
      'Ключ API OpenAI не настроен. Пожалуйста, добавьте свой ключ API в настройках.';

  @override
  String get aiItemCreatorOpenAiKeyNotConfigured =>
      'Ключ API OpenAI не настроен.';

  @override
  String get aiItemCreatorProcessingComplete => 'Обработка завершена';

  @override
  String get aiItemCreatorTranslationComingSoon =>
      'Функция перевода скоро появится';

  @override
  String get aiItemCreatorDefaultCategoryName => 'ИИ создан';

  @override
  String get aiItemCreatorStartNewConversation => 'Начать новый разговор';

  @override
  String get aiItemCreatorChatHint =>
      'Опишите тему, и тренер по искусственному интеллекту задаст вопросы, предложит полезную лексику и проверит ваши знания.';

  @override
  String get aiItemCreatorConversation => 'Беседа';

  @override
  String get aiItemCreatorYou => 'Ты';

  @override
  String get aiItemCreatorCoach => 'ИИ-тренер';

  @override
  String get aiItemCreatorAiSuggestions => 'Предложения ИИ';

  @override
  String get aiItemCreatorTapChipToFill =>
      'Коснитесь фишки, чтобы заполнить поле элемента и выполнить автоматический перевод.';

  @override
  String get aiItemCreatorNoSuggestedItems => 'Пока нет слов и выражений.';

  @override
  String get aiItemCreatorNextSteps => 'Как продолжить';

  @override
  String get aiItemCreatorNoNextSteps => 'Предложений по продолжению пока нет.';

  @override
  String get aiItemCreatorModelCostTip =>
      'Совет для профессионалов: новые модели стоят дороже, а старые модели с турбонаддувом дешевле и могут работать значительно быстрее.';

  @override
  String get aiItemCreatorSelectPackageDialogTitle => 'Выбрать языковой пакет';

  @override
  String get aiItemCreatorSelectPackageDialogMessage =>
      'Выберите языковой пакет, который будет использоваться для этого сеанса. Ваш последний выбор выбран заранее.';

  @override
  String aiItemCreatorMissingApiKeysWarning(String keys) {
    return 'Отсутствуют ключи API: $keys. Вы можете продолжить, но функции искусственного интеллекта и премиум-перевода могут быть ограничены.';
  }

  @override
  String get about => 'О';

  @override
  String get aboutWebsite => 'Веб-сайт';

  @override
  String get aboutSummaryVideo => 'Видео-обзор';

  @override
  String get aboutSupportEmail => 'Адрес электронной почты поддержки';

  @override
  String get aboutWebsiteUrl => 'https://sites.google.com/view/language-rally';

  @override
  String get aboutSummaryVideoUrl =>
      'https://www.youtube.com/watch?v=64Pl9iNF88c';

  @override
  String get aboutSupportEmailAddress => 'Languagerally.support@gmail.com';

  @override
  String aboutVersionWithValue(String version) {
    return 'Версия: $version';
  }

  @override
  String aboutCouldNotOpen(String uri) {
    return 'Не удалось открыть: $uri';
  }

  @override
  String get aboutWelcomeSplashNotFound => 'Изображение приветствия не найдено';

  @override
  String get chooseTheme => 'Выбрать тему';

  @override
  String get darkMode => 'Темный режим';

  @override
  String get toggleBetweenLightAndDark => 'Переключение между светлым и темным';

  @override
  String get colorTheme => 'Цветовая тема:';

  @override
  String get toggleBrightness => 'Переключить яркость';

  @override
  String get changeTheme => 'Изменить тему';

  @override
  String get managePackageGroups => 'Управление группами пакетов';

  @override
  String get noPackageGroups => 'Нет групп пакетов';

  @override
  String get createFirstPackageGroup => 'Создайте свою первую группу пакетов';

  @override
  String get addGroup => 'Добавить группу';

  @override
  String get addPackageGroup => 'Добавить группу пакетов';

  @override
  String get editPackageGroup => 'Редактировать группу пакетов';

  @override
  String get groupName => 'Имя группы';

  @override
  String get enterGroupName => 'Введите название группы';

  @override
  String get groupNameRequired => 'Укажите название группы.';

  @override
  String get duplicateGroupName => 'Повторяющееся имя';

  @override
  String groupNameAlreadyExists(String name) {
    return 'Группа с названием «$name» уже существует.';
  }

  @override
  String groupCreatedSuccessfully(String name) {
    return 'Группа «$name» успешно создана.';
  }

  @override
  String failedToCreateGroup(String error) {
    return 'Не удалось создать группу: $error.';
  }

  @override
  String groupRenamedTo(String name) {
    return 'Группа переименована в «$name».';
  }

  @override
  String failedToUpdateGroup(String error) {
    return 'Не удалось обновить группу: $error.';
  }

  @override
  String get deleteGroup => 'Удалить группу';

  @override
  String deleteGroupConfirm(String name) {
    return 'Вы уверены, что хотите удалить группу «$name»?\n\nЭто действие невозможно отменить.';
  }

  @override
  String get cannotDeleteGroup => 'Невозможно удалить';

  @override
  String groupHasPackages(int count) {
    return 'В этой группе все еще есть пакеты $count. Пожалуйста, сначала переместите или удалите их.';
  }

  @override
  String groupDeleted(String name) {
    return 'Группа \"$name\" удалена.';
  }

  @override
  String failedToDeleteGroup(String error) {
    return 'Не удалось удалить группу: $error.';
  }

  @override
  String get cannotDeleteHasPackagesTooltip =>
      'Невозможно удалить (есть пакеты)';

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
  String get manageGroups => 'Управление группами';

  @override
  String get featureLangPower => 'Языковая сила';

  @override
  String get featureAiIntegration => 'Интеграция ИИ';

  @override
  String get featureAdaptivePractice => 'Адаптивная практика';

  @override
  String get featureMasterAccent => 'Мастер акцент';

  @override
  String get allBadgesEarned => '🎉 Все значки заработаны! Вы Мастер!';

  @override
  String nextBadgeLabel(String name) {
    return 'Далее: $name';
  }

  @override
  String pointsToGo(String percent) {
    return 'Осталось $percent%';
  }

  @override
  String progressPercent(String percent) {
    return '$percent% прогресса';
  }

  @override
  String errorTogglingFavourite(String error) {
    return 'Ошибка переключения избранного: $error.';
  }

  @override
  String errorTogglingImportant(String error) {
    return 'Ошибка переключения важно: $error';
  }

  @override
  String categoryAdded(String name) {
    return 'Добавлена ​​категория \"$name\"';
  }

  @override
  String errorAddingCategory(String error) {
    return 'Ошибка при добавлении категории: $error.';
  }

  @override
  String categoryRemoved(String name) {
    return 'Категория \"$name\" удалена.';
  }

  @override
  String errorRemovingCategory(String error) {
    return 'Ошибка удаления категории: $error.';
  }

  @override
  String couldNotOpenUrl(String url) {
    return 'Не удалось открыть URL: $url.';
  }

  @override
  String errorOpeningUrl(String error) {
    return 'Ошибка открытия URL: $error.';
  }

  @override
  String get pleaseSelectLanguage => 'Пожалуйста, выберите язык';

  @override
  String get add => 'Добавлять';

  @override
  String get speak => 'Говорить';

  @override
  String get recordingFailedToStart =>
      'Не удалось начать запись!\n\nПроверьте:\n1. Микрофон подключен.\n2. Микрофон установлен как устройство по умолчанию.\n3. Ни одно другое приложение не использует микрофон.';

  @override
  String get recordingFailedNoAudioFile =>
      'Запись не удалась – аудиофайл не создан!\n\nВозможные причины:\n1. Микрофон не подключен\n2. Аудиовход не обнаружен.\n3. Проблема с настройками звука Windows.';

  @override
  String errorStartingRecordingDetails(String error) {
    return 'Ошибка начала записи: $error.';
  }

  @override
  String get openaiEmptyResponse => 'Выбранная модель ИИ вернула пустой ответ.';

  @override
  String get tryDifferentModel =>
      'Попробуйте выбрать другую модель в селекторе моделей.';

  @override
  String get modelMayNotBeSupported =>
      'Эта модель может не поддерживаться или недоступна для вашей учетной записи.';

  @override
  String get reduceTextOrRetry =>
      'Уменьшите длину текста или повторите попытку.';

  @override
  String get openaiNullContent => 'Выбранная модель ИИ не вернула контента.';

  @override
  String get modelUnsupportedParameter =>
      'Выбранная модель не поддерживает необходимый параметр API.';
}
