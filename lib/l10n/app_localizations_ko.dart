// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get helloWorld => '안녕하세요 월드!';

  @override
  String get welcome => '언어 집회에 오신 것을 환영합니다';

  @override
  String get appTitle => '언어 집회';

  @override
  String get createPackage => '패키지 생성';

  @override
  String get editPackage => '패키지 편집';

  @override
  String get packageDetails => '패키지 세부정보';

  @override
  String get packageName => '패키지 이름';

  @override
  String get packageNameHint => '예: 스페인어 필수, 독일어 기본';

  @override
  String get languageCode1 => '소스 언어 코드';

  @override
  String get languageName1 => '소스 언어 이름';

  @override
  String get languageCode2 => '대상 언어 코드';

  @override
  String get languageName2 => '대상 언어 이름';

  @override
  String get description => '설명';

  @override
  String get descriptionHint => '이 언어 패키지에 대한 간략한 설명';

  @override
  String get authorName => '작성자 이름';

  @override
  String get authorEmail => '작성자 이메일';

  @override
  String get authorWebpage => '작성자 웹페이지';

  @override
  String get version => '버전';

  @override
  String get items => '아이템';

  @override
  String get packageIcon => '패키지 아이콘';

  @override
  String get packageGroup => '패키지 그룹';

  @override
  String get selectIcon => '아이콘 선택';

  @override
  String get defaultIcon => '기본 아이콘';

  @override
  String get customIcon => '맞춤 아이콘';

  @override
  String get upload => '업로드 아이콘';

  @override
  String get uploadCustomIcon => '맞춤 아이콘 업로드(최대 512x512, 1MB)';

  @override
  String get customIconUploaded => '맞춤 아이콘이 성공적으로 업로드되었습니다.';

  @override
  String get save => '구하다';

  @override
  String get edit => '편집하다';

  @override
  String get cancel => '취소';

  @override
  String get delete => '삭제';

  @override
  String get confirmDelete => '이 패키지를 삭제하시겠습니까?';

  @override
  String get packageSaved => '패키지가 성공적으로 저장되었습니다.';

  @override
  String get packageDeleted => '패키지가 삭제되었습니다.';

  @override
  String get errorSavingPackage => '패키지를 저장하는 중에 오류가 발생했습니다.';

  @override
  String get errorDeletingPackage => '패키지 삭제 오류';

  @override
  String get fieldRequired => '이 필드는 필수입니다';

  @override
  String get invalidEmail => '잘못된 이메일 주소';

  @override
  String get readOnlyPackage => '이 패키지는 읽기 전용이므로 편집할 수 없습니다.';

  @override
  String get purchasedPackage => '구매한 패키지는 편집할 수 없습니다';

  @override
  String get badges => '배지';

  @override
  String get noBadges => '아직 획득한 배지가 없습니다.';

  @override
  String get selectLanguageCode => '언어 코드 선택';

  @override
  String get typeToSearchLanguages => '언어를 검색하려면 입력하세요...';

  @override
  String get search => '찾다...';

  @override
  String get clearCounters => '카운터 지우기';

  @override
  String get confirmClearCounters =>
      '이 패키지에 대한 모든 훈련 카운터를 지우시겠습니까? 이렇게 하면 \'모름\' 카운터와 훈련 통계가 재설정됩니다.';

  @override
  String get clear => '분명한';

  @override
  String get countersCleared => '카운터가 성공적으로 지워졌습니다.';

  @override
  String get errorClearingCounters => '카운터를 지우는 중 오류가 발생했습니다.';

  @override
  String get deleteAll => '패키지 삭제';

  @override
  String get confirmDeleteAllData =>
      '모든 데이터와 함께 이 패키지를 삭제하시겠습니까? 모든 카테고리, 항목, 훈련 통계가 영구적으로 삭제됩니다. 이 작업은 취소할 수 없습니다!';

  @override
  String get allDataDeleted => '패키지 및 모든 데이터가 성공적으로 삭제되었습니다.';

  @override
  String get exportPackage => '패키지 내보내기';

  @override
  String get selectExportLocation => '내보내기 위치 선택';

  @override
  String get packageExported => '패키지를 성공적으로 내보냈습니다.';

  @override
  String get errorExportingPackage => '패키지를 내보내는 중 오류가 발생했습니다.';

  @override
  String get importItems => '항목 가져오기(JSON)';

  @override
  String get importItemsDialogTitle => '항목 가져오기(JSON)';

  @override
  String get importItemsFromLocalJson => '로컬 JSON 파일에서 가져오기';

  @override
  String get enterItemsUrl => '항목 JSON URL(https://…)';

  @override
  String get downloadingItems => '항목 다운로드 중…';

  @override
  String get selectImportFile => '가져오기 파일 선택';

  @override
  String get importFormat => '가져오기 형식';

  @override
  String get importFormatDescription =>
      '텍스트 파일에서 항목을 가져옵니다. 각 줄에는 다음 형식의 항목이 포함되어야 합니다.';

  @override
  String get importResults => '결과 가져오기';

  @override
  String get successfullyImported => '성공적으로 가져왔습니다';

  @override
  String get failedToImport => '가져오지 못했습니다.';

  @override
  String get error => '오류';

  @override
  String get ok => '좋아요';

  @override
  String get importPackage => '패키지 가져오기';

  @override
  String get importPackageTooltip => 'ZIP 파일 또는 URL에서 패키지 가져오기';

  @override
  String get importPackageDialogTitle => '언어 패키지 가져오기';

  @override
  String get importFromLocalFile => '로컬 파일에서 가져오기';

  @override
  String get importFromUrl => 'URL에서 가져오기';

  @override
  String get enterPackageUrl => '패키지 URL(https://…)';

  @override
  String get downloadingPackage => '패키지 다운로드 중…';

  @override
  String get downloadFailed => '다운로드에 실패했습니다. URL과 인터넷 연결을 확인하세요.';

  @override
  String get invalidUrl => '유효한 http:// 또는 https:// URL을 입력하세요.';

  @override
  String get orLabel => '또는';

  @override
  String get selectPackageZipFile => '패키지 ZIP 파일 선택';

  @override
  String get couldNotAccessFile => '선택한 파일에 액세스할 수 없습니다.';

  @override
  String get importingPackage => '패키지 가져오는 중...';

  @override
  String get packageImportedSuccessfully => '패키지를 성공적으로 가져왔습니다!';

  @override
  String packageImportedWithItems(Object count) {
    return '패키지를 성공적으로 가져왔습니다! ($count 항목)';
  }

  @override
  String packageImportedWithGroup(Object count, Object groupName) {
    return '\"$groupName\" 그룹으로 패키지를 가져왔습니다! ($count 항목)';
  }

  @override
  String get importError => '가져오기 오류';

  @override
  String get failedToImportPackage => '패키지를 가져오지 못했습니다.';

  @override
  String get packageAlreadyExists => '패키지가 이미 존재합니다.';

  @override
  String packageExistsMessage(Object groupName) {
    return '동일한 언어 쌍, 설명, 작성자 정보 및 버전을 가진 패키지가 \"$groupName\" 그룹에 이미 존재합니다. 그래도 새 패키지로 가져오시겠습니까?';
  }

  @override
  String get importAsNew => '어쨌든 가져오기';

  @override
  String get zipFileNotFound => 'ZIP 파일을 찾을 수 없습니다';

  @override
  String get invalidPackageZip => '잘못된 패키지 ZIP: package_data.json이 누락되었습니다.';

  @override
  String get invalidPackageFormat => '잘못된 패키지 파일 형식';

  @override
  String get languagePackages => '언어 패키지';

  @override
  String get loadingPackages => '패키지 로드 중...';

  @override
  String get tapAndHoldToReorder => '카드를 재정렬하려면 길게 탭하세요.';

  @override
  String get tapAndHoldToReorderList =>
      '재정렬하려면 ⋮를 길게 탭하세요. • 컴팩트 보기로 전환하려면 ⋮를 탭하세요.';

  @override
  String get noPackagesYet => '아직 패키지가 없습니다.';

  @override
  String get createFirstPackage => '첫 번째 언어 패키지 만들기';

  @override
  String get versionLabel => '버전';

  @override
  String get purchased => '구매함';

  @override
  String get compactView => '콤팩트';

  @override
  String get expand => '확장하다';

  @override
  String get allCategories => '모든 카테고리';

  @override
  String get categoriesInPackage => '이 패키지의 카테고리';

  @override
  String get categories => '카테고리';

  @override
  String get testInterFonts => '인터 글꼴 테스트';

  @override
  String get viewPackages => '패키지 보기';

  @override
  String get simplifiedPackageView => '패키지 목록';

  @override
  String get createNewPackage => '새 패키지 만들기';

  @override
  String get generateTestData => '테스트 데이터 생성';

  @override
  String get designSystemShowcase => '디자인 시스템 쇼케이스';

  @override
  String get badgeEarned => '배지 획득!';

  @override
  String get achievement => '성취';

  @override
  String get awesome => '엄청난!';

  @override
  String get importFormatNotes => '참고:';

  @override
  String get importFormatLine1 => '• 각 줄은 하나의 항목을 나타냅니다.';

  @override
  String get importFormatLine2 => '• 필드는 |로 구분됩니다.';

  @override
  String get importFormatLine3 => '• 카테고리는 ;로 구분됩니다.';

  @override
  String get importFormatLine4 => '• 마지막 | 선택 사항입니다';

  @override
  String get importFormatLine5 => '• 빈 줄은 무시됩니다.';

  @override
  String get importFormatLine6 => '• 중복된 내용은 건너뜁니다.';

  @override
  String get importFormatNewDescription =>
      '텍스트 파일에서 항목을 가져옵니다. 각 줄에는 ---로 구분된 필드가 있는 항목이 포함되어야 합니다.';

  @override
  String get importFormatNewLine1 => '• 주요 구분 기호: ---';

  @override
  String get importFormatNewLine2 => '• L1=<text> - 언어 1 기본 텍스트(L2가 누락된 경우 필수)';

  @override
  String get importFormatNewLine3 => '• L2=<text> - 언어 2 기본 텍스트(L1이 누락된 경우 필수)';

  @override
  String get importFormatNewLine4 => '• L1pre=<text> - 언어 1 접두사(선택 사항)';

  @override
  String get importFormatNewLine5 => '• L1post=<text> - 언어 1 접미사(선택 사항)';

  @override
  String get importFormatNewLine6 => '• L2pre=<text> - 언어 2 접두사(선택 사항)';

  @override
  String get importFormatNewLine7 => '• L2post=<text> - 언어 2 접미사(선택 사항)';

  @override
  String get importFormatNewLine8 =>
      '• EX=<L1 텍스트>:::<L2 텍스트> - 예(선택 사항, 여러 개일 수 있음)';

  @override
  String get importFormatNewLine9 =>
      '• CAT=<cat1>:::<cat2>:::<cat3> - 카테고리(선택 사항)';

  @override
  String get importFormatNewLine10 => '• L1= 또는 L2= 중 하나 이상이 있어야 합니다.';

  @override
  String get importFormatNewLine11 => '• 빈 줄은 무시됩니다.';

  @override
  String get importFormatNewLine12 => '• 중복된 내용은 건너뜁니다.';

  @override
  String get invalidImportLine => '잘못된 줄';

  @override
  String get missingRequiredFields => '\'L1=\' 누락 \'L2=\'';

  @override
  String get unknownField => '알 수 없는 필드 접두사';

  @override
  String andMore(Object count) {
    return '... 그리고 $count 더보기';
  }

  @override
  String get browseItems => '항목 찾아보기';

  @override
  String get itemDetails => '세부';

  @override
  String get filterItems => '항목 필터링';

  @override
  String searchLanguage1(Object language) {
    return '$language에서 검색';
  }

  @override
  String searchLanguage2(Object language) {
    return '$language에서 검색';
  }

  @override
  String get caseSensitive => '대소문자 구분';

  @override
  String get knownStatus => '알려진 상태';

  @override
  String get filterStatusAll => '모두';

  @override
  String get filterStatusKnown => '알려진';

  @override
  String get filterStatusUnknown => '알려지지 않은';

  @override
  String get allItems => '모든 항목';

  @override
  String get itemsIKnew => '내가 알고 있던 항목';

  @override
  String get itemsIDidNotKnow => '내가 몰랐던 항목들';

  @override
  String get known => '알려진';

  @override
  String get unknown => '알려지지 않은';

  @override
  String get important => '중요한';

  @override
  String get favourite => '가장 좋아하는';

  @override
  String get badge => '배지';

  @override
  String get position => '위치';

  @override
  String get stepsUntilLearned => '학습까지의 단계';

  @override
  String get examples => '예';

  @override
  String get noExamples => '사용 가능한 예시가 없습니다.';

  @override
  String get pronounce => '발음하다';

  @override
  String get ttsError => '텍스트 음성 변환을 사용할 수 없습니다.';

  @override
  String get noItemsFound => '항목을 찾을 수 없습니다';

  @override
  String get noItemsInPackage => '이 패키지에는 아직 항목이 없습니다.';

  @override
  String get addItem => '항목 추가';

  @override
  String get emptyPackageHint => '항목을 수동으로 추가하거나 AI를 사용하여 항목을 빠르게 가져옵니다.';

  @override
  String get noItemsToTrain => '현재 설정으로 연습할 수 있는 항목이 없습니다.';

  @override
  String get clearFilters => '분명한';

  @override
  String itemCount(Object count) {
    return '$count 항목';
  }

  @override
  String filteredItemCount(Object filtered, Object total) {
    return '$total 항목 중 $filtered개';
  }

  @override
  String get trainingRally => '트레이닝 랠리';

  @override
  String get startTraining => '훈련 시작';

  @override
  String get trainingComingSoon => '트레이닝 랠리 - 곧 출시됩니다!';

  @override
  String get aiServiceNotConfigured =>
      'AI 서비스가 구성되지 않았습니다. OpenAI API 키를 추가하세요.';

  @override
  String pleaseEnterTextInLanguageFirst(Object language) {
    return '먼저 $language에 텍스트를 입력하세요.';
  }

  @override
  String translationCompletedSuccessfully(Object service) {
    return '$service을(를) 사용하여 번역이 성공적으로 완료되었습니다!';
  }

  @override
  String get translationFailed => '번역 실패';

  @override
  String addedExamplesSuccessfully(Object count) {
    return '$count 예시가 성공적으로 추가되었습니다!';
  }

  @override
  String get failedToGenerateExamples => '예시를 생성하지 못했습니다.';

  @override
  String get selectExamplesToAdd => '추가할 예시 선택';

  @override
  String get selectWhichExamples => '이 항목에 추가할 예시를 선택하세요.';

  @override
  String get addSelected => '선택 항목 추가';

  @override
  String get pleaseSelectAtLeastOne => '예를 하나 이상 선택하세요.';

  @override
  String get addNewItem => '새 항목 추가';

  @override
  String get editItem => '항목 편집';

  @override
  String get deleteItem => '항목 삭제';

  @override
  String get confirmDeleteItem => '이 항목을 삭제하시겠습니까?';

  @override
  String get thisActionCannotBeUndone => '이 작업은 취소할 수 없습니다.';

  @override
  String get itemDeleted => '항목이 삭제되었습니다.';

  @override
  String get errorDeletingItem => '항목을 삭제하는 중에 오류가 발생했습니다.';

  @override
  String get errorSavingItem => '항목을 저장하는 중에 오류가 발생했습니다.';

  @override
  String get itemSaved => '항목이 업데이트되었습니다.';

  @override
  String get itemCreated => '항목이 성공적으로 생성되었습니다.';

  @override
  String get preTextOptional => '사전 텍스트(선택사항)';

  @override
  String get mainText => '본문';

  @override
  String get postTextOptional => '포스트 텍스트(선택사항)';

  @override
  String get forExampleToForVerbs => '예를 들어 동사의 경우 \"to\"';

  @override
  String get additionalContext => '추가 컨텍스트';

  @override
  String get translate => '번역하다';

  @override
  String translateFromTo(Object from, Object to) {
    return '$from → $to 번역';
  }

  @override
  String get aiExampleGeneration => 'AI 예시 생성';

  @override
  String get aiExampleSearch => 'AI 예시 검색';

  @override
  String searchExamplesOnInternet(Object text) {
    return 'AI를 활용하여 \'$text\'에 대한 예문을 인터넷에서 검색하세요.';
  }

  @override
  String generateExampleSentences(Object language) {
    return '$language의 본문을 기반으로 예문을 생성합니다.';
  }

  @override
  String get voiceInput => '음성 입력';

  @override
  String get settings => '설정';

  @override
  String get uiLanguage => 'UI 언어';

  @override
  String get uiLanguageDescription => '애플리케이션 인터페이스 언어';

  @override
  String get uiLanguageHelper => '메뉴, 버튼, 라벨의 언어를 선택하세요.';

  @override
  String get userLanguage => '사용자 언어';

  @override
  String get userLanguageDescription => '새로운 언어 패키지를 만들기 위해 선호하는 모국어';

  @override
  String get apiKeys => 'API 키';

  @override
  String get deeplApiKey => 'DeepL API 키';

  @override
  String get deeplApiKeyDescription =>
      '언어 항목 편집 시 프리미엄 번역 품질을 제공합니다. https://www.deepl.com/pro-api를 참조하세요.';

  @override
  String get openaiApiKey => 'OpenAI API 키';

  @override
  String get openaiApiKeyDescription =>
      '예를 들어 언어 항목을 편집할 때 AI를 사용한 생성입니다. https://platform.openai.com/api-keys를 참조하세요.';

  @override
  String get enterApiKey => 'API 키를 입력하세요';

  @override
  String get optional => '선택 과목';

  @override
  String get required => '필수의';

  @override
  String get settingsSaved => '설정이 성공적으로 저장되었습니다.';

  @override
  String get errorSavingSettings => '설정을 저장하는 중에 오류가 발생했습니다.';

  @override
  String get usingGoogleTranslate => '무료 Google 번역 사용';

  @override
  String get usingDeepL => 'DeepL 사용(프리미엄)';

  @override
  String get noTranslationReceivedFromGoogle => 'Google로부터 번역을 받지 못했습니다.';

  @override
  String get googleTranslationFailed => 'Google 번역 실패';

  @override
  String get googleTranslationError => '구글 번역 오류';

  @override
  String get noTranslationReceivedFromDeepL => 'DeepL로부터 번역을 받지 못했습니다.';

  @override
  String get invalidDeepLApiKey => '잘못된 DeepL API 키';

  @override
  String get deeplTranslationQuotaExceeded => 'DeepL 번역 할당량을 초과했습니다.';

  @override
  String get deeplTranslationFailed => 'DeepL 번역 실패';

  @override
  String get deeplTranslationError => 'DeepL 번역 오류';

  @override
  String get invalidApiKeyConfigureOpenAI =>
      'API 키가 잘못되었습니다. OpenAI API 키를 구성하세요.';

  @override
  String get apiRateLimitExceeded => 'API 비율 제한을 초과했습니다. 나중에 다시 시도해 주세요.';

  @override
  String get aiRequestFailed => 'AI 요청 실패';

  @override
  String get failedToParseAiResponse => 'AI 응답을 구문 분석하지 못했습니다. 다시 시도해 주세요.';

  @override
  String get aiGenerationError => 'AI 생성 오류';

  @override
  String get voiceInputPlaceholder => '음성 입력은 speech_to_text 패키지를 사용하여 구현됩니다.';

  @override
  String get improveQualityWithApiKeys =>
      '💡 팁: 애플리케이션 설정에 DeepL 및 OpenAI API 키를 추가하면 번역 및 예제 검색의 품질을 크게 향상시킬 수 있습니다.';

  @override
  String get noApiKeyFallbackMessage =>
      'API 키가 없으면 기본 번역과 제한된 예시가 제공됩니다. 최상의 결과를 얻으려면 설정에서 API 키를 구성하세요.';

  @override
  String get listeningForSpeech => '듣고 있어요... 지금 말하세요';

  @override
  String get speechRecognitionNotAvailable => '이 기기에서는 음성 인식을 사용할 수 없습니다.';

  @override
  String get speechRecognitionPermissionDenied => '음성인식 권한이 거부되었습니다';

  @override
  String get speechRecognitionError => '음성 인식 오류';

  @override
  String get tapToSpeak => '말하려면 마이크를 탭하세요.';

  @override
  String get tapToStop => '녹화를 중지하려면 탭하세요.';

  @override
  String get speechNotRecognized => '음성이 인식되지 않았습니다. 다시 시도해 주세요.';

  @override
  String get usingWhisperApiSlower => '음성 인식에 클라우드 AI 사용(느릴 수 있음)';

  @override
  String languageNotSupportedAddApiKey(String languageCode) {
    return '언어 $languageCode은 기본적으로 지원되지 않습니다. AI 기반 음성 인식 설정에 OpenAI API 키를 추가하세요.';
  }

  @override
  String get recordingTapToStop => '녹음 중... 중지하려면 다시 탭하세요.';

  @override
  String get speakClearlyKeepRecording => '명확하게 말하세요. 최소 1초 이상 녹음하세요.';

  @override
  String get pleaseRecordLonger => '1초 이상 말씀하신 후 중지를 눌러주세요.';

  @override
  String get errorStartingRecording => '녹화 시작 오류';

  @override
  String get noAudioRecorded => '오디오가 녹음되지 않았습니다.';

  @override
  String get errorTranscribing => '오디오를 텍스트로 변환하는 중에 오류가 발생했습니다.';

  @override
  String get trainingSettings => '훈련 설정';

  @override
  String get trainingPresetTitle => '빠른 설정';

  @override
  String get trainingPresetHint => '사전 설정을 선택하면 아래 설정이 자동으로 구성됩니다.';

  @override
  String get trainingPresetComboLabel => '프리셋';

  @override
  String get trainingPresetAllExamplesForeignLanguage => '모든 예문, 외국어';

  @override
  String get trainingPresetAllExamplesRandomLanguage => '모든 예, 임의의 언어';

  @override
  String get trainingPresetFavouriteItemsForeignLanguage => '좋아하는 물건, 외국어';

  @override
  String get trainingPresetFavouriteItemsRandomLanguage => '좋아하는 항목, 임의의 언어';

  @override
  String get trainingPresetImportantItemsForeignLanguage => '중요사항, 외국어';

  @override
  String get trainingPresetImportantItemsRandomLanguage => '중요한 항목, 임의의 언어';

  @override
  String get trainingPresetRandomItemsRandomLanguage => '무작위 아이템, 무작위 언어';

  @override
  String get trainingPresetUnknownItemsForeignLanguage => '알려지지 않은 항목, 외국어';

  @override
  String get trainingPresetUnknownItemsRandomLanguage => '알 수 없는 항목, 임의의 언어';

  @override
  String trainingPresetAppliedTapStart(String actionLabel) {
    return '사전 설정이 적용되었습니다. 시작하려면 \'$actionLabel\'을 탭하세요.';
  }

  @override
  String get trainingPresetSelectPackageFirst => '먼저 패키지를 선택해주세요.';

  @override
  String get itemScope => '품목 범위';

  @override
  String get lastNItems => '마지막 N개 항목';

  @override
  String get onlyUnknown => '알 수 없는 항목만';

  @override
  String get onlyImportant => '중요한 항목만';

  @override
  String get onlyFavourite => '즐겨찾는 항목만';

  @override
  String get numberOfItems => '항목 수';

  @override
  String get itemOrder => '품목 주문';

  @override
  String get randomOrder => '무작위 순서';

  @override
  String get sequentialOrder => '순차적 순서';

  @override
  String get itemType => '품목 유형';

  @override
  String get dictionaryItems => '사전 항목';

  @override
  String get examplesType => '예';

  @override
  String get displayLanguage => '표시 언어';

  @override
  String get motherTongue => '모국어';

  @override
  String get targetLanguage => '대상 언어';

  @override
  String get randomLanguage => '무작위의';

  @override
  String get categoryFilter => '카테고리 필터';

  @override
  String get categoryFilterHint => '포함할 카테고리 선택(비어 있음 = 모든 카테고리)';

  @override
  String get noCategories => '사용 가능한 카테고리가 없습니다.';

  @override
  String get dontKnowThreshold => '임계값을 알 수 없음';

  @override
  String get dontKnowThresholdHint => '특별 취급 전에 품목을 \'모름\'으로 표시해야 하는 횟수';

  @override
  String get startTrainingRally => '훈련 집회 시작';

  @override
  String get clearTrainingSettings => '설정 지우기';

  @override
  String get confirmClearTrainingSettings => '모든 훈련 설정을 기본값으로 재설정하시겠습니까?';

  @override
  String get trainingSettingsCleared => '훈련 설정이 삭제되었습니다';

  @override
  String get startingTraining => '훈련 시작 중...';

  @override
  String get noMoreItemsToDisplay => '필터 설정에 따라 표시할 항목이 없습니다.';

  @override
  String get noItems => '항목 없음';

  @override
  String get trainingComplete => '훈련 완료';

  @override
  String get allItemsCompleted => '축하해요! 이 교육 세션의 모든 항목을 완료했습니다.';

  @override
  String get closeTraining => '긴밀한 훈련';

  @override
  String get confirmCloseTraining => '교육을 종료하시겠습니까? 진행 상황이 저장되었습니다.';

  @override
  String get question => '질문';

  @override
  String get answer => '답변';

  @override
  String get iKnow => '알아요';

  @override
  String get iDontKnow => '모르겠습니다';

  @override
  String get previousItem => '이전 항목';

  @override
  String get iDidNotKnowEither => '결국 나는 그것을 몰랐다';

  @override
  String get exportBeforeDelete => '삭제하기 전에 내보내시겠습니까?';

  @override
  String get aiTextAnalysis => 'AI를 사용하여 텍스트/목록에서 항목 추출';

  @override
  String get aiTextAnalysisImport => 'AI 텍스트 분석 도구를 사용하여 텍스트 또는 목록에서 항목 추출';

  @override
  String get knowledgeLevel => '지식 수준';

  @override
  String get a1Beginner => 'A1 - 초급';

  @override
  String get a2Elementary => 'A2 - 초등';

  @override
  String get b1Intermediate => 'B1 - 중급';

  @override
  String get b2UpperIntermediate => 'B2 – 중상급';

  @override
  String get c1Advanced => 'C1 - 고급';

  @override
  String get c2Proficient => 'C2 - 능숙함';

  @override
  String get pasteTextHere => '여기에 텍스트를 붙여넣으세요...';

  @override
  String get extractWords => '단어 추출';

  @override
  String get extractExpressions => '표현식 추출';

  @override
  String get maxItems => '최대 새 항목';

  @override
  String get maxItemsHint => '제한 없이 비워 두세요.';

  @override
  String get generateExamples => '예제 생성';

  @override
  String get categoryName => '카테고리 이름';

  @override
  String get categoryNameHint => '수입 품목 카테고리 이름';

  @override
  String get analyzeText => '텍스트 분석';

  @override
  String get configureAnalysis => '추출할 항목 구성';

  @override
  String get openaiModel => 'AI 모델';

  @override
  String get openaiModelDescription => 'ChatGPT 모델 선택';

  @override
  String get modelGpt55 => 'GPT-5.5';

  @override
  String get modelGpt55Pro => 'GPT-5.5 프로';

  @override
  String get modelGpt54 => 'GPT-5.4';

  @override
  String get modelGpt54Pro => 'GPT-5.4 프로';

  @override
  String get modelGpt54Mini => 'GPT-5.4 미니';

  @override
  String get modelGpt5Mini => 'GPT-5 미니';

  @override
  String get modelGpt41 => 'GPT-4.1';

  @override
  String get modelGpt55Desc => '일반 사용을 위한 품질과 속도의 균형을 이룬 최신 플래그십';

  @override
  String get modelGpt55ProDesc => '가장 강력한 추론과 품질을 위한 최고급 GPT-5.5 변형';

  @override
  String get modelGpt54Desc => '강력한 범용 GPT-5 세대 모델';

  @override
  String get modelGpt54ProDesc => '까다로운 작업을 위한 고성능 GPT-5.4 변형';

  @override
  String get modelGpt54MiniDesc => '더 저렴한 일상 작업을 위한 더 작고 빠른 GPT-5.4 변형';

  @override
  String get modelGpt5MiniDesc => '속도와 비용에 최적화된 컴팩트한 GPT-5 제품군 모델';

  @override
  String get modelGpt41Desc => '호환성과 견고한 품질을 위한 안정적인 GPT-4.1 옵션';

  @override
  String get modelGpt4o => 'GPT-4o';

  @override
  String get modelGpt35Turbo => 'GPT-3.5 Turbo(레거시, 예산)';

  @override
  String get modelGpt35Turbo16k => 'GPT-3.5 터보 16K';

  @override
  String get modelGpt4 => 'GPT-4';

  @override
  String get modelGpt4Turbo => 'GPT-4 터보(레거시)';

  @override
  String get modelGpt4oDesc => '최고의 범용 선택; 빠르고, 다중 모드이며, 강력한 품질';

  @override
  String get modelGpt35TurboDesc => '레거시 저비용 옵션; 더 간단한 작업과 비용에 민감한 사용에 유용합니다.';

  @override
  String get modelGpt35Turbo16kDesc => 'GPT-3.5와 동일하지만 16K 토큰 컨텍스트 창';

  @override
  String get modelGpt4Desc => '높은 추론 품질; 일반적으로 속도가 느리고 비용이 더 많이 듭니다.';

  @override
  String get modelGpt4TurboDesc =>
      '레거시 GPT-4 제품군 옵션; 더 오래되고 저렴한 대안을 원할 때 여전히 유용합니다.';

  @override
  String get analyzing => '분석 중...';

  @override
  String get languageDetected => '감지된 언어';

  @override
  String get itemsFound => '발견된 항목';

  @override
  String get selectItemsToImport => '가져올 항목 선택';

  @override
  String get selectAll => '모두 선택';

  @override
  String get deselectAll => '모두 선택 취소';

  @override
  String get importSelected => '선택 항목 가져오기';

  @override
  String get importing => '가져오는 중...';

  @override
  String get itemsImported => '항목을 성공적으로 가져왔습니다.';

  @override
  String get noItemsSelected => '선택한 항목이 없습니다.';

  @override
  String get textCannotBeEmpty => '텍스트는 비워둘 수 없습니다.';

  @override
  String get selectAtLeastOneType => '유형(단어 또는 표현)을 하나 이상 선택하세요.';

  @override
  String get languageNotMatching => '감지된 언어가 패키지의 언어와 일치하지 않습니다.';

  @override
  String get openaiKeyRequired => '이 기능에는 OpenAI API 키가 필요합니다';

  @override
  String analyzingProgress(Object current, Object total) {
    return '분석 중: $current / $total';
  }

  @override
  String translatingProgress(Object current, Object total) {
    return '번역: $current / $total';
  }

  @override
  String get duplicate => '복제하다';

  @override
  String importProgress(Object current, Object total) {
    return '$total 중 $current 가져오기';
  }

  @override
  String get detectingLanguage => '언어 감지 중...';

  @override
  String get extractingItems => '항목 추출 중...';

  @override
  String get checkingDuplicates => '중복 확인 중...';

  @override
  String get translating => '번역 중...';

  @override
  String get generatingExamples => '예제 생성 중...';

  @override
  String get errorAnalyzingText => '텍스트 분석 오류';

  @override
  String get errorImportingItems => '항목을 가져오는 중에 오류가 발생했습니다.';

  @override
  String get warning => '경고';

  @override
  String get textIsVeryLarge => '텍스트가 매우 큼';

  @override
  String get words => '단어';

  @override
  String get continueAnalysis =>
      '처리하는 데 시간이 더 오래 걸릴 수 있으며 청크로 분석됩니다. 계속하시겠습니까?';

  @override
  String get continueLabel => '계속하다';

  @override
  String get exportBeforeDeleteMessage =>
      '이 패키지를 삭제하기 전에 내보내시겠습니까? 이렇게 하면 모든 데이터가 ZIP 파일로 저장됩니다.';

  @override
  String get deleteWithoutExport => '내보내지 않고 삭제';

  @override
  String get exportAndDelete => '내보내기 및 삭제';

  @override
  String get exportingPackage => '패키지를 내보내는 중...';

  @override
  String packageExportedToPath(Object path) {
    return '다음으로 내보낸 패키지: $path';
  }

  @override
  String errorLoadingItems(Object error) {
    return '항목 로드 중 오류 발생: $error';
  }

  @override
  String badgeEarnedWithName(Object badgeName) {
    return '획득한 배지: $badgeName!';
  }

  @override
  String badgeLostWithName(Object badgeName) {
    return '배지 분실: $badgeName';
  }

  @override
  String get trainingSessionProgress => '교육 세션 통계';

  @override
  String get total => '총';

  @override
  String lastNValue(Object value) {
    return '아니요 = $value';
  }

  @override
  String errorLoadingSettings(Object error) {
    return '설정 로드 중 오류 발생: $error';
  }

  @override
  String get selectPackage => '패키지 선택';

  @override
  String get noPackagesAvailable => '사용 가능한 패키지가 없습니다.';

  @override
  String get possibleSolutions => '가능한 해결책';

  @override
  String get technicalDetails => '기술적인 세부사항';

  @override
  String get close => '닫다';

  @override
  String get checkApiKey => 'OpenAI API 키 확인';

  @override
  String get ensureValidOpenAIKey => 'API 키가 유효하고 활성 상태인지 확인하세요.';

  @override
  String get verifyKeyInSettings => '설정에서 키를 확인하세요';

  @override
  String get rateLimitExceeded => 'API 비율 제한을 초과했습니다.';

  @override
  String get waitAndRetry => '몇 분 정도 기다렸다가 다시 시도해 보세요.';

  @override
  String get checkAccountQuota => 'OpenAI 계정 할당량을 확인하세요';

  @override
  String get invalidRequest => '잘못된 요청 형식';

  @override
  String get tryReducingTextLength => '텍스트 길이를 줄여보세요';

  @override
  String get checkTextFormat => '텍스트 형식이 올바른지 확인하세요.';

  @override
  String get checkInternetConnection => '인터넷 연결을 확인하세요';

  @override
  String get retryInMoment => '잠시 후 다시 시도하세요';

  @override
  String get checkFirewall => '방화벽 설정 확인';

  @override
  String get textMayBeTooShort => '텍스트가 너무 짧을 수 있습니다.';

  @override
  String get tryDifferentKnowledgeLevel => '다른 지식 수준을 시도해 보세요';

  @override
  String get ensureTextInCorrectLanguage => '텍스트가 올바른 언어로 되어 있는지 확인하세요.';

  @override
  String get requestTimedOut => '요청 시간이 초과되었습니다.';

  @override
  String get textMayBeTooLong => '텍스트가 너무 길 수 있습니다.';

  @override
  String get tryAgainOrReduceSize => '다시 시도하거나 텍스트 크기를 줄이세요.';

  @override
  String get unexpectedError => '예상치 못한 오류가 발생했습니다.';

  @override
  String get checkErrorDetails => '아래에서 오류 내용을 확인하세요.';

  @override
  String get tryAgainLater => '나중에 다시 시도하세요';

  @override
  String get translationServiceFailed => '번역 서비스 실패';

  @override
  String get checkApiKeys => 'API 키 확인(DeepL, OpenAI)';

  @override
  String get retryImport => '가져오기를 다시 시도하세요.';

  @override
  String get exampleGenerationFailed => '예시 생성 실패';

  @override
  String get itemsStillImported => '항목이 여전히 수입되었습니다.';

  @override
  String get canAddExamplesManually => '나중에 수동으로 예시를 추가할 수 있습니다.';

  @override
  String get databaseError => '데이터베이스 오류가 발생했습니다.';

  @override
  String get checkStorageSpace => '사용 가능한 저장 공간 확인';

  @override
  String get restartApp => '앱을 다시 시작해 보세요';

  @override
  String get groupLabel => '그룹:';

  @override
  String get amendGroups => '개정하다';

  @override
  String get exportItemsJson => '항목 내보내기(JSON)';

  @override
  String get exportItemsJsonTooltip => '모든 항목을 JSON 파일로 내보내기';

  @override
  String get noCategoriesInPackage => '이 패키지에는 카테고리가 없습니다.';

  @override
  String get noItemsToExport => '내보낼 항목이 없습니다.';

  @override
  String itemsExportedSuccessfully(int count, String path) {
    return '$count 항목을 다음 위치로 성공적으로 내보냈습니다.\n$path';
  }

  @override
  String get errorExportingItems => '항목을 내보내는 중에 오류가 발생했습니다.';

  @override
  String get languageMismatch => '언어 불일치';

  @override
  String get languageMismatchDescription => 'JSON 파일의 언어가 패키지 언어와 일치하지 않습니다.';

  @override
  String packageLanguages(String lang1, String lang2) {
    return '패키지: $lang1 → $lang2';
  }

  @override
  String jsonFileLanguages(String lang1, String lang2) {
    return 'JSON 파일: $lang1 → $lang2';
  }

  @override
  String get continueImportQuestion => '그래도 계속 가져오시겠습니까?';

  @override
  String get continueImport => '계속 가져오기';

  @override
  String get pleaseSelectPackageGroup => '패키지 그룹을 선택하세요.';

  @override
  String get customIconLabel => '관습';

  @override
  String get defaultIconLabel => '기본';

  @override
  String get icon2Label => '오픈북';

  @override
  String get icon3Label => '컬러북';

  @override
  String get icon4Label => '대화';

  @override
  String get icon5Label => '눈금';

  @override
  String get icon6Label => '뇌';

  @override
  String get icon7Label => '책더미';

  @override
  String get icon8Label => '플래시카드';

  @override
  String get icon9Label => '지구';

  @override
  String get icon10Label => '연필';

  @override
  String get icon11Label => '트로피';

  @override
  String get icon12Label => '찾다';

  @override
  String get customIconFile => '맞춤 아이콘';

  @override
  String get importedIconFile => '가져온 아이콘';

  @override
  String get unableToReadImageFile => '이미지 파일을 읽을 수 없습니다. 유효한 이미지를 선택하세요.';

  @override
  String iconDimensionsTooLarge(int width, int height) {
    return '아이콘 크기가 너무 큽니다(${width}x$height). 허용되는 최대값은 512x512픽셀입니다.';
  }

  @override
  String get iconFileTooLarge => '아이콘 파일이 너무 큽니다. 최대 크기는 1MB입니다.';

  @override
  String failedToUploadIcon(String error) {
    return '아이콘 업로드 실패: $error';
  }

  @override
  String get pleaseSelectValidLanguage => '목록에서 유효한 언어를 선택하세요.';

  @override
  String get status => '상태';

  @override
  String get addExample => '예시 추가';

  @override
  String get noExamplesYet => '아직 예시가 없습니다. 추가하려면 +를 클릭하세요.';

  @override
  String get speakText => '텍스트 말하기';

  @override
  String get removeCategory => '카테고리 삭제';

  @override
  String removeCategoryConfirm(String categoryName) {
    return '이 항목에서 \'$categoryName\' 카테고리를 삭제하시겠습니까?';
  }

  @override
  String get remove => '제거하다';

  @override
  String get extractFullItems => '전체 항목 추출';

  @override
  String get pasteFromClipboard => '클립보드에서 붙여넣기';

  @override
  String get noItemsFoundOrAllDuplicates =>
      '텍스트에 항목이 없거나 패키지에 모든 항목이 이미 존재합니다.';

  @override
  String get aboutLanguageRally => '언어 랠리 소개';

  @override
  String get welcomeTitle => '🚀 언어 집회에 오신 것을 환영합니다';

  @override
  String get welcomeSubtitle =>
      '모든 숙련도 수준에 맞춰 세심하게 선별된 약 4,000개의 단어, 4,000개의 표현, 그리고 많은 예문을 통해 언어 학습의 놀라운 힘을 느껴보세요! AI를 사용하여 자신의 텍스트에서 항목을 가져오거나 어떤 주제에 대해서도 AI와 채팅하여 배우고 싶은 정확한 단어, 표현 및 예를 생성하세요.\n스마트하고 재미있는 방법으로 언어 능력을 레벨업하세요!';

  @override
  String get welcomeIntro =>
      '실제로 관심 있는 내용을 연습함으로써 효율적으로 어휘와 표현을 익힐 수 있습니다. 지루한 목록이 없습니다. 낭비되는 시간이 없습니다.';

  @override
  String get sectionPlayYourGame => '🎮 나만의 게임을 플레이하세요';

  @override
  String get sectionPlayYourGameDesc =>
      '나만의 어휘 패키지를 만들어 보세요. 마스터하고 싶은 단어와 표현만 훈련하세요. 이미 알고 계시나요? 표시되고 건너뛰게 됩니다!';

  @override
  String get sectionAITeammate => '🤖 AI를 팀원으로 활용';

  @override
  String get sectionAITeammateDesc =>
      '텍스트를 붙여넣고 AI가 다음을 수행하도록 하세요.\n• 유용한 어휘 추출\n• 자신의 수준에 맞는 표현을 선택하세요\n• 학습 준비가 완료된 패키지를 몇 초 만에 구축\n\nAI와 채팅:\n• 주제에 맞는 단어와 표현을 제안해 보세요.\n• 예제를 생성하고 이를 OWN 패키지에 저장하려면 클릭하세요.';

  @override
  String get sectionTrainSmart => '🔁 스마트하게 훈련하세요';

  @override
  String get sectionTrainSmartDesc =>
      '우리의 미세 조정된 반복 시스템은 항목을 효과적으로 기억하기 위해 두뇌가 필요할 때 정확하게 항목을 보여줍니다. 최대 진행. 최소한의 노력.';

  @override
  String get sectionRealExamples => '🌍 실제 사례. 훌륭한 번역.';

  @override
  String get sectionRealExamplesDesc =>
      '실제 사용 사례를 확인하세요. DeepL을 통해 프리미엄 품질로 번역하세요. 발음을 연습하고 자신감 있게 말해보세요.';

  @override
  String get sectionTeachersWelcome => '👩‍🏫 선생님 환영합니다';

  @override
  String get sectionTeachersWelcomeDesc =>
      '패키지 생성 → 항목 복사 및 붙여넣기 또는 AI → 내보내기 → 업로드/보내기 → 완료를 통해 예제 추출, 번역, 추가를 수행합니다. 학생들은 이를 가져와 즉시 연습을 시작합니다.';

  @override
  String get sectionUnlockAI => '🔑 전체 AI 성능 잠금 해제';

  @override
  String get sectionUnlockAIDesc =>
      '고품질 번역 및 AI 기능을 이용하려면 다음을 수행하세요.\n\n1. DeepL API 키 생성\n   https://www.deepl.com/pro-api\n2. OpenAI API 키 생성\n   https://platform.openai.com/api-keys\n3. 두 키를 모두 설정에 붙여넣습니다.\n\n적은 투자로 강력하고 전문가 수준의 언어 도구를 얻을 수 있습니다. 왜 놓치시겠습니까?\n(최상의 결과를 얻으려면 유료 API 액세스를 사용하는 것이 좋습니다.)';

  @override
  String get readyToStart => '집회를 시작할 준비가 되셨나요? 🏁';

  @override
  String get welcomeDescription =>
      'Language Rally는 포괄적인 언어 학습 동반자입니다. 맞춤형 어휘 패키지를 만들고, 항목을 카테고리별로 정리하고, 지능적인 간격 반복 시스템으로 훈련하세요.';

  @override
  String get browseStore => '매장 찾아보기';

  @override
  String get featureInteractiveTraining => '대화형 교육';

  @override
  String get featureInteractiveTrainingDesc => '적응형 학습 알고리즘 연습';

  @override
  String get featureSmartOrganization => '스마트한 조직';

  @override
  String get featureSmartOrganizationDesc => '어휘를 분류하고 필터링하세요';

  @override
  String get featureTrackProgress => '진행 상황 추적';

  @override
  String get featureTrackProgressDesc => '자세한 통계로 학습을 모니터링하세요';

  @override
  String get featureImportExport => '가져오기 및 내보내기';

  @override
  String get featureImportExportDesc => '패키지 공유 및 장치 간 동기화';

  @override
  String get startAppTour => '앱 둘러보기 시작';

  @override
  String get quickStartGuide => '빠른 시작 가이드';

  @override
  String get tourStep1Title => '패키지 생성 또는 가져오기';

  @override
  String get tourStep1Desc => '새 언어 패키지를 생성하여 시작하거나 파일에서 기존 언어 패키지를 가져옵니다.';

  @override
  String get tourStep2Title => '어휘 항목 추가';

  @override
  String get tourStep2Desc => '패키지를 탐색하고 예와 카테고리가 포함된 단어, 문구 또는 표현을 추가하세요.';

  @override
  String get tourStep3Title => '교육 구성';

  @override
  String get tourStep3Desc => '연습할 항목을 선택하고, 난이도를 설정하고, 학습 경험을 맞춤화하세요.';

  @override
  String get tourStep4Title => '학습 시작';

  @override
  String get tourStep4Desc =>
      '훈련 세션을 시작하고 항목을 알려짐 또는 알 수 없음으로 표시하여 진행 상황을 추적하세요.';

  @override
  String get tourStep5Title => '통계 검토';

  @override
  String get tourStep5Desc => '자세한 통계와 성취 배지를 통해 학습 진행 상황을 확인하세요.';

  @override
  String get gotIt => '알았어요!';

  @override
  String get appTourTitle => '언어 집회에 오신 것을 환영합니다';

  @override
  String get appTourSubtitle => '똑똑하고, 재미있고, 완전히 개인화된 언어 학습 동반자입니다.';

  @override
  String get tourPage1Title => '원하는 것과 필요한 것을 배우고 실천하십시오.';

  @override
  String get tourPage1Desc =>
      '당사의 적응형 학습 시스템은 완벽한 순간에 항목을 검토하여 유지율을 최대화하고 노력을 최소화하도록 보장합니다.\n\n내장된 자동화의 도움으로 배워보세요.\n이미 알고 있는 단어에 시간을 낭비하지 마세요.\n\n관심 있는 어휘와 표현만 연습하세요. 귀하의 목표와 레벨에 완벽하게 맞춰진 나만의 아이템을 만들고 훈련하세요.';

  @override
  String get tourPage2Title => '나만의 언어 패키지 만들기';

  @override
  String get tourPage2Desc =>
      '귀하의 관심사와 학습 목표에 맞는 맞춤형 어휘 컬렉션을 구축하세요.\n\n주제, 난이도, 문맥별로 단어와 표현을 정리하세요.\n\n학습 내용과 시기를 완벽하게 제어할 수 있습니다.';

  @override
  String get tourPage3Title => 'AI 기반 아이템 생성';

  @override
  String get tourPage3Desc =>
      '눈 깜짝할 사이에 나만의 학습 패키지를 구축하세요.\n\n• 텍스트를 붙여넣고 AI가 자동으로 관련 어휘를 추출하도록 합니다.\n• 자신의 수준에 딱 맞는 단어와 표현을 찾아보세요.\n• AI가 번역해 드립니다.\n• AI가 실시간 예시를 검색하도록 하세요.\n\nAI와 채팅:\n• 주제에 맞는 단어와 표현을 제안해 보세요.\n• 예제를 생성하고 이를 OWN 패키지에 저장하려면 클릭하세요.\n• 교육용 패키지를 신속하게 생성';

  @override
  String get tourPage4Title => 'AI 기반 실제 사례 및 프리미엄 번역';

  @override
  String get tourPage4Desc =>
      '• 실제 사용 사례를 즉시 검색\n• 고품질 DeepL 통합을 통해 단어, 표현 및 전체 문장을 번역합니다.\n• 정확한 상황 인식 결과 얻기';

  @override
  String get tourPage5Title => '스마트 패키지 구성';

  @override
  String get tourPage5Desc =>
      '• 어휘를 맞춤 카테고리로 구성\n• 특정 주제에 대한 필터링 및 집중\n• 여러 기기에서 패키지 가져오기 및 내보내기\n• 다른 사람들과 패키지를 쉽게 공유';

  @override
  String get tourPage6Title => '발음 훈련';

  @override
  String get tourPage6Desc =>
      '대화형 연습 도구를 사용하여 발음을 테스트하고 향상시키세요.\n\n읽기뿐만 아니라 말하기에도 자신감을 키워보세요.';

  @override
  String get tourPage7Title => '교사용';

  @override
  String get tourPage7Desc =>
      '단 몇 번의 클릭만으로 학생들을 위해 바로 사용할 수 있는 어휘 패키지를 만드세요.\n\n내보내고 수업에 보내세요. 가져온 후에는 각 학생의 기기에서 즉시 연습할 수 있습니다.\n\n단순한. 빠른. 효과적인.';

  @override
  String get tourPage8Title => '고품질 AI 지원 잠금 해제';

  @override
  String get tourPage8Desc =>
      '프리미엄 번역 및 고급 AI 기능을 이용하려면 다음을 수행하세요.\n 1. 나만의 DeepL API 키 만들기\n 2. 나만의 OpenAI API 키 만들기\n 3. 두 키를 모두 설정 섹션에 붙여넣습니다.\n\n이를 위해서는 적은 예산(몇 달러)만 필요하지만 강력하고 전문가 수준의 언어 도구에 액세스할 수 있습니다.\n참고: 최상의 결과를 얻으려면 유료 API 액세스를 사용하는 것이 좋습니다. 비용은 단지 몇 달러에 불과합니다.\n\n🔑 DeepL API 키: https://www.deepl.com/pro-api\n\n🔑 OpenAI API 키: https://platform.openai.com/api-keys';

  @override
  String get previousPage => '이전의';

  @override
  String get nextPage => '다음';

  @override
  String get endTour => '투어 종료';

  @override
  String pageIndicator(int current, int total) {
    return '$total 중 $current 페이지';
  }

  @override
  String get practicePronunciation => '발음 연습';

  @override
  String get pronunciationPractice => '발음연습';

  @override
  String get startPractice => '연습 시작';

  @override
  String get listenToPronunciation => '발음 듣기';

  @override
  String get tapToRecord => '녹음하려면 탭하세요.';

  @override
  String get recording => '녹음...';

  @override
  String get recorded => '녹음됨';

  @override
  String get speakNow => '지금 말하세요 - 마이크 가까이에서 명확하게 말하세요.';

  @override
  String get noSpeechDetected => '음성이 감지되지 않았습니다. 다시 시도해 주세요.';

  @override
  String get noTextRecognized =>
      '녹음에서 음성이 인식되지 않았습니다. 마이크가 작동하는지 확인한 후 다시 시도해 주세요.';

  @override
  String get processingAudio => 'AI로 오디오 처리…';

  @override
  String get playbackRecording => '내 녹음을 재생해 보세요';

  @override
  String get playbackRecordingSubtitle => 'AI가 처리하는 동안 녹음 내용 듣기';

  @override
  String get recordingTooShort => '녹화가 너무 짧습니다. 1초 이상 말씀해주세요.';

  @override
  String get microphonePermissionRequired => '발음 연습을 위해 마이크 권한이 필요합니다';

  @override
  String get speechRecognitionNotSupported =>
      '이 플랫폼에서는 음성 인식이 지원되지 않습니다. 발음 연습은 모바일 앱(Android/iOS)을 이용해 주세요.';

  @override
  String get speechRecognitionUnavailable => '이 장치에서는 음성 인식을 사용할 수 없습니다.';

  @override
  String get pronunciationAccuracy => '발음\n정확도';

  @override
  String get excellent => '훌륭한!';

  @override
  String get good => '좋은';

  @override
  String get fair => '공정한';

  @override
  String get needsImprovement => '개선이 필요함';

  @override
  String get tryAgain => '다시 시도';

  @override
  String get nextItem => '다음 항목';

  @override
  String get endPractice => '연습 종료';

  @override
  String get practiced => '연습함';

  @override
  String get windowsAudioTestPageTitle => 'Windows 오디오 테스트(RTAudio)';

  @override
  String get configureWindowsAudio => '오디오 테스트 및 구성\nWindows에서의 입력';

  @override
  String get configureWindowsAudioDescription =>
      '기본 Windows RTAudio 드라이버를 사용하여 오디오 녹음, 재생 및 전사';

  @override
  String get audioTestTitle => 'Windows 오디오 녹음 테스트';

  @override
  String get audioTestSubtitle => 'RTAudio — 기본 Windows 오디오 녹음';

  @override
  String get audioInputDevice => '오디오 입력 장치';

  @override
  String get selectMicrophone => '마이크 선택';

  @override
  String get refreshDevices => '장치 새로 고침';

  @override
  String get noAudioDevicesFound => '오디오 입력 장치를 찾을 수 없습니다.';

  @override
  String get loadingAudioDevices => '오디오 장치 로드 중...';

  @override
  String get recordingSettings => '녹화 설정';

  @override
  String get stereoRecording => '스테레오 녹음';

  @override
  String get stereoChannels => '2채널(스테레오)';

  @override
  String get monoChannel => '1채널(모노)';

  @override
  String get sampleRateLabel => '샘플링 속도';

  @override
  String get nativeRateBadge => '토종의';

  @override
  String get microphoneGainLabel => '마이크 게인';

  @override
  String get gainHint => '1x = 부스트 없음 • 3x ≒ +9.5dB • 10x ≒ +20dB';

  @override
  String get tapToStartRec => '녹화를 시작하려면 탭하세요.';

  @override
  String get tapToStopRec => '녹화를 중지하려면 탭하세요.';

  @override
  String get recordingCompleteLabel => '녹화 완료';

  @override
  String get tapMicToStop => '중지하려면 마이크를 탭하세요.';

  @override
  String get playRecordingLabel => '녹음 재생';

  @override
  String get stopPlaybackLabel => '멈추다';

  @override
  String get whisperSectionTitle => 'OpenAI 속삭임 전사';

  @override
  String get whisperWavNote =>
      'WAV(16비트 PCM)는 Whisper에서 기본적으로 지원되므로 변환이 필요하지 않습니다.';

  @override
  String get sendToWhisperLabel => '속삭임으로 보내기';

  @override
  String get transcribingLabel => '스크립트 작성 중...';

  @override
  String get transcriptionResultLabel => '전사 결과';

  @override
  String get transcriptionFailedLabel => '전사 실패';

  @override
  String get debugInformationLabel => '정보';

  @override
  String get debugConsoleHint => '자세한 로그는 콘솔을 확인하세요.';

  @override
  String get debugDevicesFound => '장치 발견';

  @override
  String get debugSelectedDevice => '선택한 장치';

  @override
  String get debugDeviceRateNative => '장치 속도(기본)';

  @override
  String get debugRequestedRate => '요청 요금';

  @override
  String get debugActualRate => '실제 사용된 환율';

  @override
  String get debugActualRateForced => '⚠ 강제';

  @override
  String get debugActualRateOk => '✓';

  @override
  String get debugRecordingMode => '녹화 모드';

  @override
  String get debugLastRecording => '마지막 녹음';

  @override
  String get debugFileSize => '파일 크기';

  @override
  String get debugStereo => '스테레오 재생';

  @override
  String get debugMono => '단핵증';

  @override
  String get recordingSavedSnack => '녹음이 저장되었습니다';

  @override
  String get recordingTooShortSnack => '녹음 시간이 너무 짧습니다. 1초 이상 녹음해주세요.';

  @override
  String get recordingSmallSnack => '녹음 파일이 매우 작습니다. 녹음에 실패했을 수 있습니다.';

  @override
  String get noAudioDataSnack => '녹음된 오디오 데이터가 없습니다.';

  @override
  String get noDeviceSelectedSnack => '오디오 장치를 선택해주세요';

  @override
  String get failedToInitRtAudio => 'RTAudio를 초기화하지 못했습니다.';

  @override
  String get envelopeScoreLabel => '봉투';

  @override
  String get rhythmScoreLabel => '율';

  @override
  String get textScoreLabel => '텍스트';

  @override
  String get help => '돕다';

  @override
  String get trainingHelpTitle => '훈련 팁';

  @override
  String get trainingHelpText =>
      '훈련을 최대한 효과적으로 진행하려면 다음 단계를 따르십시오.\n1. 이 패키지의 모든 항목이 알려진 항목으로 표시되도록 \'카운터 지우기\' 버튼을 클릭하세요.\n2. \'항목 범위\'를 \'모든 항목\'으로 설정하세요.\n3. \'아이템 순서\'를 \'랜덤\'으로 설정하세요.\n4. \'표시 언어\'에서 모국어를 선택하세요.\n5. 훈련을 시작하고 자신이 모르는 항목이 약 20~30개 정도 식별될 때까지 계속합니다.\n6. 훈련 설정으로 돌아가서 \'항목 범위\'를 \'알 수 없는 항목만\'으로 변경하세요.\n7. 훈련을 재개하고 이전에 알려지지 않은 항목을 모두 배울 때까지 계속하십시오.';

  @override
  String get trainingProTip => '전문가 팁: 모든 항목부터 시작하세요. 나중에는 알려지지 않은 부분에만 집중하세요.';

  @override
  String get onboardingWelcomeTitle => '언어 집회에 오신 것을 환영합니다!';

  @override
  String get onboardingSetupSubtitle => '당신을 위해 앱을 설정해 보겠습니다.';

  @override
  String get onboardingSelectUiLanguage => '인터페이스 언어';

  @override
  String get onboardingUiLanguageNote => '나중에 설정 → UI 언어에서 변경할 수 있습니다.';

  @override
  String get onboardingNext => '다음';

  @override
  String get onboardingBack => '뒤쪽에';

  @override
  String get onboardingSelectPackagesTitle => '언어 패키지 선택';

  @override
  String get onboardingSelectPackagesSubtitle =>
      '가져올 어휘 패키지를 선택하세요. 나중에 언제든지 메인 메뉴(패키지 보기)에서 더 추가할 수 있습니다.';

  @override
  String get onboardingAnalyzingPackages => '사용 가능한 패키지 분석 중…';

  @override
  String onboardingScanningPackagesProgress(
    int scanned,
    int total,
    int alreadyInDb,
  ) {
    return '스캔됨 $scanned/$total • 이미 DB $alreadyInDb에 있음';
  }

  @override
  String get onboardingImportSelected => '선택 항목 가져오기';

  @override
  String get onboardingSkipImport => '건너뛰다';

  @override
  String get onboardingSelectAll => '모두 선택';

  @override
  String get onboardingDeselectAll => '모두 선택 취소';

  @override
  String onboardingNPackages(int count) {
    return '$count 패키지';
  }

  @override
  String get onboardingGetStarted => '시작하기';

  @override
  String get onboardingImportCompleteTitle => '가져오기 완료!';

  @override
  String get importBuiltInPkg => '무료 패키지';

  @override
  String get importBuiltInPkgTooltip => '무료 번들 언어 패키지 가져오기';

  @override
  String get globalSearch => '글로벌 검색';

  @override
  String get globalSearchTitle => '모든 패키지 검색';

  @override
  String get globalSearchSelectLanguage => '언어 코드 선택';

  @override
  String get globalSearchEnterWord => '검색할 단어';

  @override
  String get globalSearchEnterWordHint =>
      '예를 들어 \"der\", \"order\" — 부분적으로 일치하는 항목을 찾습니다.';

  @override
  String get globalSearchButton => '찾다';

  @override
  String get globalSearchResults => '결과';

  @override
  String globalSearchNoResults(String query) {
    return '\"$query\"에 대한 검색 결과가 없습니다.';
  }

  @override
  String globalSearchResultsCount(int count) {
    return '$count 결과를 찾았습니다.';
  }

  @override
  String get globalSearchSearching => '수색…';

  @override
  String get globalSearchSelectLanguageFirst => '먼저 언어 코드를 선택하세요.';

  @override
  String get globalSearchEnterTermFirst => '검색어를 입력해주세요';

  @override
  String get globalSearchMatchInExamples => '예제에서 발견됨';

  @override
  String get globalSearchViewItem => '보다';

  @override
  String get globalSearchGoToPackage => '패키지로 이동';

  @override
  String get globalSearchLoadingPackages => '패키지 로드 중…';

  @override
  String get globalSearchNoPackages => '아직 설치된 언어 패키지가 없습니다.';

  @override
  String get globalSearchCancelSearch => '검색 취소';

  @override
  String globalSearchProgressOf(int current, int total) {
    return '$total 중 $current 패키지 검색 중…';
  }

  @override
  String globalSearchCancelledMessage(int count) {
    return '검색이 취소되었습니다 — 지금까지 $count개의 결과를 찾았습니다.';
  }

  @override
  String get storeTitle => '언어 패키지 저장소';

  @override
  String get storeRestorePurchases => '구매 복원';

  @override
  String get storeRefresh => '새로 고치다';

  @override
  String get storeSearchHint => '패키지 검색…';

  @override
  String get storeNoPackagesMatchSearch => '검색과 일치하는 패키지가 없습니다.';

  @override
  String get storeNoPackagesAvailable => '사용 가능한 패키지가 없습니다.';

  @override
  String storeInstalledCount(int installed, int total) {
    return '$installed / $total 설치됨';
  }

  @override
  String get storeLoadErrorTitle => '매장을 로드할 수 없습니다.';

  @override
  String get storeIapNotAvailableMessage =>
      '이 플랫폼에서는 인앱 구매를 사용할 수 없습니다. 패키지를 구매하려면 당사 웹사이트를 방문하세요.';

  @override
  String get storeOpenWebsite => '웹사이트 열기';

  @override
  String storePurchaseSuccess(String title) {
    return '$title이(가) 성공적으로 설치되었습니다!';
  }

  @override
  String get storePurchaseCancelled => '구매가 취소되었습니다.';

  @override
  String storePurchaseAlreadyOwned(String title) {
    return '$title은(는) 이미 설치되어 있습니다.';
  }

  @override
  String get storePurchaseError => '문제가 발생했습니다. 다시 시도해 주세요.';

  @override
  String get storePurchasesRestored => '구매가 복원되었습니다.';

  @override
  String get storeAllLevels => '모든 레벨';

  @override
  String get storeAllGroups => '모든 언어';

  @override
  String get storeFilterLevel => '수준';

  @override
  String get storeFilterLanguage => '언어';

  @override
  String get storeDownload => '다운로드';

  @override
  String get storeBuy => '구입하다';

  @override
  String get storeInstalledLabel => '설치됨';

  @override
  String get storeDownloading => '다운로드 중…';

  @override
  String get storeRetry => '다시 해 보다';

  @override
  String get storeIapAndroidOnly => '구매는 Android 및 iOS에서만 가능합니다.';

  @override
  String get storeDismiss => '해고하다';

  @override
  String get storeAddToCart => '장바구니에 추가';

  @override
  String get storeRemoveFromCart => '제거하다';

  @override
  String get storeCartTitle => '장바구니';

  @override
  String get storeCartEmpty => '장바구니가 비어 있습니다.';

  @override
  String get storeCartClearAll => '모두 지우기';

  @override
  String get storeCartCheckout => '점검';

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
  String get storePackageDuplicateTitle => '패키지가 이미 존재합니다.';

  @override
  String storePackageDuplicateMessage(String packageName, String groupName) {
    return '\"$packageName\" 패키지가 \"$groupName\" 그룹에 이미 존재합니다. 덮어쓰시겠습니까? 기존 패키지와 모든 학습 진행 상황이 영구적으로 삭제됩니다.';
  }

  @override
  String get storePackageDuplicateOverwrite => '덮어쓰기';

  @override
  String get storePackageDuplicateKeep => '기존 유지';

  @override
  String splashSettingUpPackages(int current, int total) {
    return '패키지 설정: $current / $total';
  }

  @override
  String get splashThisHappensOnce => '이것은 한 번만 발생합니다.';

  @override
  String get splashLoading => '로드 중…';

  @override
  String get aiItemCreator => 'AI 채팅 전문가';

  @override
  String get aiItemCreatorAppBarHint => 'AI와 채팅을 통해 단어와 표현을 수집하고 저장하세요';

  @override
  String get chatWithAI => 'AI와 채팅';

  @override
  String get enterYourPrompt => '프롬프트를 입력하세요...';

  @override
  String get aiItemCreatorPromptHint =>
      '주제를 설명하면 AI 코치가 질문하고 유용한 어휘를 제안하며 지식을 테스트합니다. 예: 지식 수준 B2에서 여행과 관련된 위험을 수집하고 연습하도록 도와주세요.';

  @override
  String get send => '보내다';

  @override
  String get sending => '배상...';

  @override
  String get aiResponse => 'AI 응답';

  @override
  String get itemInputs => '아이템 입력';

  @override
  String get aiItemCreatorBothItemsRequired => '저장하기 전에 두 언어 필드를 모두 입력하세요.';

  @override
  String get aiItemCreatorDuplicateItemMessage =>
      '동일한 텍스트 쌍을 가진 항목이 이 패키지에 이미 존재합니다.';

  @override
  String get language1 => '언어 1';

  @override
  String get language2 => '언어 2';

  @override
  String get translateLang1ToLang2 => '언어 2로 번역';

  @override
  String get translateLang2ToLang1 => '언어 1로 번역';

  @override
  String translateToLanguageCode(String languageCode) {
    return '$languageCode로 번역';
  }

  @override
  String get example => '예';

  @override
  String get generating => '생성 중...';

  @override
  String get flags => '플래그';

  @override
  String get favorite => '가장 좋아하는';

  @override
  String get saveItems => '구하다';

  @override
  String get saving => '절약...';

  @override
  String get clearItems => '항목만 지우기';

  @override
  String get clearAll => '모든 필드 지우기';

  @override
  String get itemSavedSuccessfully => '항목이 성공적으로 저장되었습니다.';

  @override
  String get promptCannotBeEmpty => '프롬프트는 비워둘 수 없습니다.';

  @override
  String get enterAtLeastOneItem => '항목을 하나 이상 입력하세요.';

  @override
  String get selectPackageFirst => '먼저 패키지를 선택해주세요';

  @override
  String get deeplKeyRequired => '번역을 위해서는 DeepL API 키가 필요합니다';

  @override
  String get noNonPurchasedPackagesAvailable => '구매하지 않은 패키지는 사용할 수 없습니다.';

  @override
  String get packageSelectionRemembered => '패키지 선택이 저장되었습니다.';

  @override
  String get aiItemCreatorOpenAiKeyNotConfiguredDetailed =>
      'OpenAI API 키가 구성되지 않았습니다. 설정에서 API 키를 추가하세요.';

  @override
  String get aiItemCreatorOpenAiKeyNotConfigured => 'OpenAI API 키가 구성되지 않았습니다.';

  @override
  String get aiItemCreatorProcessingComplete => '처리 완료';

  @override
  String get aiItemCreatorTranslationComingSoon => '번역 기능이 곧 제공될 예정입니다.';

  @override
  String get aiItemCreatorDefaultCategoryName => 'AI가 생성됨';

  @override
  String get aiItemCreatorStartNewConversation => '새로운 대화 시작';

  @override
  String get aiItemCreatorChatHint =>
      '주제를 설명하면 AI 코치가 질문하고 유용한 어휘를 제안하며 지식을 테스트합니다.';

  @override
  String get aiItemCreatorConversation => '대화';

  @override
  String get aiItemCreatorYou => '너';

  @override
  String get aiItemCreatorCoach => 'AI 코치';

  @override
  String get aiItemCreatorAiSuggestions => 'AI 제안';

  @override
  String get aiItemCreatorTapChipToFill => '칩을 탭하여 항목 필드를 채우고 자동 번역하세요.';

  @override
  String get aiItemCreatorNoSuggestedItems => '아직 단어나 표현이 없습니다.';

  @override
  String get aiItemCreatorNextSteps => '계속하는 방법';

  @override
  String get aiItemCreatorNoNextSteps => '아직 계속 추천사항이 없습니다.';

  @override
  String get aiItemCreatorModelCostTip =>
      '전문가 팁: 최신 모델은 더 비싸지만, 구형 및 터보 모델은 더 저렴하고 훨씬 더 빠를 수 있습니다.';

  @override
  String get aiItemCreatorSelectPackageDialogTitle => '언어 패키지 선택';

  @override
  String get aiItemCreatorSelectPackageDialogMessage =>
      '이 세션에 사용할 언어 패키지를 선택하세요. 마지막 선택이 미리 선택되어 있습니다.';

  @override
  String aiItemCreatorMissingApiKeysWarning(String keys) {
    return '누락된 API 키: $keys. 계속할 수 있지만 AI 및 프리미엄 번역 기능이 제한될 수 있습니다.';
  }

  @override
  String get about => '에 대한';

  @override
  String get aboutWebsite => '웹사이트';

  @override
  String get aboutSummaryVideo => '요약 동영상';

  @override
  String get aboutSupportEmail => '지원 이메일 주소';

  @override
  String get aboutWebsiteUrl => 'https://sites.google.com/view/언어-rally';

  @override
  String get aboutSummaryVideoUrl =>
      'https://www.youtube.com/watch?v=64Pl9iNF88c';

  @override
  String get aboutSupportEmailAddress => 'Languagerally.support@gmail.com';

  @override
  String aboutVersionWithValue(String version) {
    return '버전: $version';
  }

  @override
  String aboutCouldNotOpen(String uri) {
    return '열 수 없음: $uri';
  }

  @override
  String get aboutWelcomeSplashNotFound => '환영 스플래시 이미지를 찾을 수 없습니다.';

  @override
  String get chooseTheme => '테마 선택';

  @override
  String get darkMode => '다크 모드';

  @override
  String get toggleBetweenLightAndDark => '밝은 것과 어두운 것 사이를 전환하세요';

  @override
  String get colorTheme => '색상 테마:';

  @override
  String get toggleBrightness => '밝기 전환';

  @override
  String get changeTheme => '테마 변경';

  @override
  String get managePackageGroups => '패키지 그룹 관리';

  @override
  String get noPackageGroups => '패키지 그룹 없음';

  @override
  String get createFirstPackageGroup => '첫 번째 패키지 그룹 만들기';

  @override
  String get addGroup => '그룹 추가';

  @override
  String get addPackageGroup => '패키지 그룹 추가';

  @override
  String get editPackageGroup => '패키지 그룹 편집';

  @override
  String get groupName => '그룹 이름';

  @override
  String get enterGroupName => '그룹 이름을 입력하세요';

  @override
  String get groupNameRequired => '그룹 이름은 필수 항목입니다.';

  @override
  String get duplicateGroupName => '중복된 이름';

  @override
  String groupNameAlreadyExists(String name) {
    return '이름이 \"$name\"인 그룹이 이미 존재합니다.';
  }

  @override
  String groupCreatedSuccessfully(String name) {
    return '그룹 \"$name\"이(가) 성공적으로 생성되었습니다.';
  }

  @override
  String failedToCreateGroup(String error) {
    return '그룹 생성 실패: $error';
  }

  @override
  String groupRenamedTo(String name) {
    return '그룹 이름이 \"$name\"(으)로 변경되었습니다.';
  }

  @override
  String failedToUpdateGroup(String error) {
    return '그룹 업데이트 실패: $error';
  }

  @override
  String get deleteGroup => '그룹 삭제';

  @override
  String deleteGroupConfirm(String name) {
    return '\"$name\" 그룹을 삭제하시겠습니까?\n\n이 작업은 취소할 수 없습니다.';
  }

  @override
  String get cannotDeleteGroup => '삭제할 수 없습니다';

  @override
  String groupHasPackages(int count) {
    return '이 그룹에는 아직 $count 패키지가 있습니다. 먼저 이동하거나 삭제해 주세요.';
  }

  @override
  String groupDeleted(String name) {
    return '\'$name\' 그룹이 삭제되었습니다.';
  }

  @override
  String failedToDeleteGroup(String error) {
    return '그룹 삭제 실패: $error';
  }

  @override
  String get cannotDeleteHasPackagesTooltip => '삭제할 수 없습니다(패키지 있음).';

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
  String get manageGroups => '그룹 관리';

  @override
  String get featureLangPower => '언어력';

  @override
  String get featureAiIntegration => 'AI 통합';

  @override
  String get featureAdaptivePractice => '적응 연습';

  @override
  String get featureMasterAccent => '마스터 악센트';

  @override
  String get allBadgesEarned => '🎉 모든 배지를 획득했습니다! 당신은 마스터입니다!';

  @override
  String nextBadgeLabel(String name) {
    return '다음: $name';
  }

  @override
  String pointsToGo(String percent) {
    return '$percent% 남았습니다';
  }

  @override
  String progressPercent(String percent) {
    return '$percent% 진행';
  }

  @override
  String errorTogglingFavourite(String error) {
    return '즐겨찾기를 전환하는 중에 오류가 발생했습니다: $error';
  }

  @override
  String errorTogglingImportant(String error) {
    return '중요 전환 오류: $error';
  }

  @override
  String categoryAdded(String name) {
    return '카테고리 \"$name\"이(가) 추가되었습니다';
  }

  @override
  String errorAddingCategory(String error) {
    return '카테고리 추가 오류: $error';
  }

  @override
  String categoryRemoved(String name) {
    return '카테고리 \"$name\"이(가) 삭제되었습니다.';
  }

  @override
  String errorRemovingCategory(String error) {
    return '카테고리 삭제 오류: $error';
  }

  @override
  String couldNotOpenUrl(String url) {
    return 'URL을 열 수 없습니다: $url';
  }

  @override
  String errorOpeningUrl(String error) {
    return 'URL을 여는 중 오류 발생: $error';
  }

  @override
  String get pleaseSelectLanguage => '언어를 선택하세요';

  @override
  String get add => '추가하다';

  @override
  String get speak => '말하다';

  @override
  String get recordingFailedToStart =>
      '녹화를 시작하지 못했습니다.\n\n확인:\n1. 마이크가 연결되었습니다\n2. 마이크가 기본 장치로 설정되어 있습니다.\n3. 마이크를 사용하는 다른 앱이 없습니다.';

  @override
  String get recordingFailedNoAudioFile =>
      '녹음 실패 - 오디오 파일이 생성되지 않았습니다!\n\n가능한 원인:\n1. 마이크가 연결되지 않음\n2. 오디오 입력이 감지되지 않습니다.\n3. Windows 오디오 설정 문제';

  @override
  String errorStartingRecordingDetails(String error) {
    return '녹화 시작 오류: $error';
  }

  @override
  String get openaiEmptyResponse => '선택한 AI 모델이 빈 응답을 반환했습니다.';

  @override
  String get tryDifferentModel => '모델 선택기에서 다른 모델을 선택해 보세요.';

  @override
  String get modelMayNotBeSupported =>
      '이 모델은 귀하의 계정에서 지원되지 않거나 사용 가능하지 않을 수 있습니다.';

  @override
  String get reduceTextOrRetry => '텍스트 길이를 줄이거나 다시 시도하세요.';

  @override
  String get openaiNullContent => '선택한 AI 모델이 콘텐츠를 반환하지 않았습니다.';

  @override
  String get modelUnsupportedParameter => '선택한 모델은 필수 API 매개변수를 지원하지 않습니다.';
}
