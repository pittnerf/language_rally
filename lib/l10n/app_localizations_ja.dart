// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get helloWorld => '「こんにちは世界」';

  @override
  String get welcome => 'ランゲージラリーへようこそ';

  @override
  String get appTitle => 'ランゲージラリー';

  @override
  String get createPackage => 'パッケージの作成';

  @override
  String get editPackage => 'パッケージの編集';

  @override
  String get packageDetails => 'パッケージの詳細';

  @override
  String get packageName => 'パッケージ名';

  @override
  String get packageNameHint => '例: スペイン語の基礎、ドイツ語の基礎';

  @override
  String get languageCode1 => 'ソース言語コード';

  @override
  String get languageName1 => 'ソース言語名';

  @override
  String get languageCode2 => 'ターゲット言語コード';

  @override
  String get languageName2 => 'ターゲット言語名';

  @override
  String get description => '説明';

  @override
  String get descriptionHint => 'この言語パッケージの簡単な説明';

  @override
  String get authorName => '著者名';

  @override
  String get authorEmail => '著者のメールアドレス';

  @override
  String get authorWebpage => '著者のウェブページ';

  @override
  String get version => 'バージョン';

  @override
  String get items => 'アイテム';

  @override
  String get packageIcon => 'パッケージアイコン';

  @override
  String get packageGroup => 'パッケージグループ';

  @override
  String get selectIcon => 'アイコンを選択';

  @override
  String get defaultIcon => 'デフォルトのアイコン';

  @override
  String get customIcon => 'カスタムアイコン';

  @override
  String get upload => 'アップロードアイコン';

  @override
  String get uploadCustomIcon => 'カスタム アイコンのアップロード (最大 512x512、1MB)';

  @override
  String get customIconUploaded => 'カスタムアイコンが正常にアップロードされました';

  @override
  String get save => '保存';

  @override
  String get edit => '編集';

  @override
  String get cancel => 'キャンセル';

  @override
  String get delete => '消去';

  @override
  String get confirmDelete => 'このパッケージを削除してもよろしいですか?';

  @override
  String get packageSaved => 'パッケージは正常に保存されました';

  @override
  String get packageDeleted => 'パッケージは正常に削除されました';

  @override
  String get errorSavingPackage => 'パッケージの保存中にエラーが発生しました';

  @override
  String get errorDeletingPackage => 'パッケージ削除エラー';

  @override
  String get fieldRequired => 'この項目は必須です';

  @override
  String get invalidEmail => '無効なメールアドレス';

  @override
  String get readOnlyPackage => 'このパッケージは読み取り専用で編集できません';

  @override
  String get purchasedPackage => '購入したパッケージは編集できません';

  @override
  String get badges => 'バッジ';

  @override
  String get noBadges => 'まだバッジを獲得していません';

  @override
  String get selectLanguageCode => '言語コードの選択';

  @override
  String get typeToSearchLanguages => '言語を検索するには入力してください...';

  @override
  String get search => '検索...';

  @override
  String get clearCounters => 'カウンターをクリアする';

  @override
  String get confirmClearCounters =>
      'このパッケージのトレーニング カウンタをすべてクリアしてもよろしいですか?これにより、「不明」カウンターとトレーニング統計がリセットされます。';

  @override
  String get clear => 'クリア';

  @override
  String get countersCleared => 'カウンターは正常にクリアされました';

  @override
  String get errorClearingCounters => 'カウンタのクリア中にエラーが発生しました';

  @override
  String get deleteAll => 'パッケージの削除';

  @override
  String get confirmDeleteAllData =>
      'このパッケージをすべてのデータとともに削除してもよろしいですか?これにより、すべてのカテゴリ、項目、トレーニング統計が完全に削除されます。この操作は元に戻すことはできません。';

  @override
  String get allDataDeleted => 'パッケージとすべてのデータが正常に削除されました';

  @override
  String get exportPackage => 'エクスポートパッケージ';

  @override
  String get selectExportLocation => 'エクスポート先の選択';

  @override
  String get packageExported => 'パッケージは正常にエクスポートされました';

  @override
  String get errorExportingPackage => 'パッケージのエクスポート中にエラーが発生しました';

  @override
  String get importItems => 'アイテムのインポート(JSON)';

  @override
  String get importItemsDialogTitle => 'アイテムのインポート(JSON)';

  @override
  String get importItemsFromLocalJson => 'ローカルのJSONファイルからインポート';

  @override
  String get enterItemsUrl => 'アイテムの JSON URL (https://…)';

  @override
  String get downloadingItems => 'アイテムをダウンロード中…';

  @override
  String get selectImportFile => 'インポートファイルを選択';

  @override
  String get importFormat => 'インポート形式';

  @override
  String get importFormatDescription =>
      'テキスト ファイルからアイテムをインポートします。各行には、次の形式の項目が含まれている必要があります。';

  @override
  String get importResults => 'インポート結果';

  @override
  String get successfullyImported => '正常にインポートされました';

  @override
  String get failedToImport => 'インポートに失敗しました';

  @override
  String get error => 'エラー';

  @override
  String get ok => 'わかりました';

  @override
  String get importPackage => 'パッケージのインポート';

  @override
  String get importPackageTooltip => 'ZIP ファイルまたは URL からパッケージをインポート';

  @override
  String get importPackageDialogTitle => '言語パッケージのインポート';

  @override
  String get importFromLocalFile => 'ローカルファイルからインポート';

  @override
  String get importFromUrl => 'URLからインポート';

  @override
  String get enterPackageUrl => 'パッケージURL (https://…)';

  @override
  String get downloadingPackage => 'パッケージをダウンロード中…';

  @override
  String get downloadFailed => 'ダウンロードに失敗しました。 URL とインターネット接続を確認してください。';

  @override
  String get invalidUrl => '有効な http:// または https:// URL を入力してください。';

  @override
  String get orLabel => 'または';

  @override
  String get selectPackageZipFile => 'パッケージZIPファイルを選択';

  @override
  String get couldNotAccessFile => '選択したファイルにアクセスできませんでした。';

  @override
  String get importingPackage => 'パッケージをインポートしています...';

  @override
  String get packageImportedSuccessfully => 'パッケージは正常にインポートされました。';

  @override
  String packageImportedWithItems(Object count) {
    return 'パッケージは正常にインポートされました。 ($count アイテム)';
  }

  @override
  String packageImportedWithGroup(Object count, Object groupName) {
    return 'パッケージが「$groupName」グループにインポートされました! ($count アイテム)';
  }

  @override
  String get importError => 'インポートエラー';

  @override
  String get failedToImportPackage => 'パッケージのインポートに失敗しました';

  @override
  String get packageAlreadyExists => 'パッケージはすでに存在します';

  @override
  String packageExistsMessage(Object groupName) {
    return '同じ言語ペア、説明、作成者情報、バージョンを持つパッケージが「$groupName」グループにすでに存在します。とにかく新しいパッケージとしてインポートしますか?';
  }

  @override
  String get importAsNew => 'とにかくインポート';

  @override
  String get zipFileNotFound => 'ZIPファイルが見つかりません';

  @override
  String get invalidPackageZip => '無効なパッケージ ZIP: package_data.json がありません';

  @override
  String get invalidPackageFormat => '無効なパッケージ ファイル形式です';

  @override
  String get languagePackages => '言語パッケージ';

  @override
  String get loadingPackages => 'パッケージをロード中...';

  @override
  String get tapAndHoldToReorder => 'タップアンドホールドしてカードを並べ替えます';

  @override
  String get tapAndHoldToReorderList =>
      '≡ をタップして押し続けると並べ替えられます。 • ⋮ をタップしてコンパクト表示に切り替えます。';

  @override
  String get noPackagesYet => 'まだパッケージがありません';

  @override
  String get createFirstPackage => '最初の言語パッケージを作成する';

  @override
  String get versionLabel => 'バージョン';

  @override
  String get purchased => '購入済み';

  @override
  String get compactView => 'コンパクト';

  @override
  String get expand => '拡大する';

  @override
  String get allCategories => 'すべてのカテゴリ';

  @override
  String get categoriesInPackage => 'このパッケージのカテゴリ';

  @override
  String get categories => 'カテゴリー';

  @override
  String get testInterFonts => 'インターフォントのテスト';

  @override
  String get viewPackages => 'パッケージを見る';

  @override
  String get simplifiedPackageView => 'パッケージリスト';

  @override
  String get createNewPackage => '新しいパッケージの作成';

  @override
  String get generateTestData => 'テストデータの生成';

  @override
  String get designSystemShowcase => 'デザインシステムのショーケース';

  @override
  String get badgeEarned => 'バッジを獲得しました！';

  @override
  String get achievement => '成果';

  @override
  String get awesome => '素晴らしい！';

  @override
  String get importFormatNotes => '注:';

  @override
  String get importFormatLine1 => '• 各行は 1 つの項目を表します';

  @override
  String get importFormatLine2 => '• フィールドは | で区切られます。';

  @override
  String get importFormatLine3 => '• カテゴリは ; で区切られます。';

  @override
  String get importFormatLine4 => '• 最後の |はオプションです';

  @override
  String get importFormatLine5 => '• 空行は無視されます。';

  @override
  String get importFormatLine6 => '• 重複はスキップされます';

  @override
  String get importFormatNewDescription =>
      'テキスト ファイルからアイテムをインポートします。各行には、--- で区切られたフィールドを持つ項目が含まれている必要があります。';

  @override
  String get importFormatNewLine1 => '• メインデリミタ: ---';

  @override
  String get importFormatNewLine2 =>
      '• L1=<text> - 言語 1 のメインテキスト (L2 が欠落している場合に必要)';

  @override
  String get importFormatNewLine3 =>
      '• L2=<text> - 言語 2 のメイン テキスト (L1 が欠落している場合に必要)';

  @override
  String get importFormatNewLine4 => '• L1pre=<text> - 言語 1 プレフィックス (オプション)';

  @override
  String get importFormatNewLine5 => '• L1post=<text> - 言語 1 のサフィックス (オプション)';

  @override
  String get importFormatNewLine6 => '• L2pre=<text> - 言語 2 プレフィックス (オプション)';

  @override
  String get importFormatNewLine7 => '• L2post=<text> - 言語 2 のサフィックス (オプション)';

  @override
  String get importFormatNewLine8 =>
      '• EX=<L1 テキスト>:::<L2 テキスト> - 例 (オプション、複数可)';

  @override
  String get importFormatNewLine9 =>
      '• CAT=<cat1>:::<cat2>:::<cat3> - カテゴリ (オプション)';

  @override
  String get importFormatNewLine10 => '• L1= または L2= の少なくとも 1 つが存在する必要があります';

  @override
  String get importFormatNewLine11 => '• 空行は無視されます。';

  @override
  String get importFormatNewLine12 => '• 重複はスキップされます';

  @override
  String get invalidImportLine => '無効な行です';

  @override
  String get missingRequiredFields => '\'L1=\' がありません、曖昧な \'L2=\'';

  @override
  String get unknownField => '不明なフィールドの接頭辞';

  @override
  String andMore(Object count) {
    return '...そして $count 詳細';
  }

  @override
  String get browseItems => 'アイテムを参照する';

  @override
  String get itemDetails => '詳細';

  @override
  String get filterItems => 'アイテムのフィルタリング';

  @override
  String searchLanguage1(Object language) {
    return '$language で検索';
  }

  @override
  String searchLanguage2(Object language) {
    return '$language で検索';
  }

  @override
  String get caseSensitive => '大文字と小文字を区別';

  @override
  String get knownStatus => '既知のステータス';

  @override
  String get filterStatusAll => '全て';

  @override
  String get filterStatusKnown => '知られている';

  @override
  String get filterStatusUnknown => '未知';

  @override
  String get allItems => 'すべてのアイテム';

  @override
  String get itemsIKnew => '知っていたアイテム';

  @override
  String get itemsIDidNotKnow => '知らなかった項目';

  @override
  String get known => '既知の';

  @override
  String get unknown => '未知';

  @override
  String get important => '重要';

  @override
  String get favourite => 'お気に入り';

  @override
  String get badge => 'バッジ';

  @override
  String get position => '位置';

  @override
  String get stepsUntilLearned => '習得までの手順';

  @override
  String get examples => '例';

  @override
  String get noExamples => '利用可能な例はありません';

  @override
  String get pronounce => '発音する';

  @override
  String get ttsError => 'テキスト読み上げは利用できません';

  @override
  String get noItemsFound => '項目が見つかりませんでした';

  @override
  String get noItemsInPackage => 'このパッケージにはまだアイテムがありません';

  @override
  String get addItem => 'アイテムの追加';

  @override
  String get emptyPackageHint => 'アイテムを手動で追加するか、AI を使用してアイテムをすばやくインポートします';

  @override
  String get noItemsToTrain => '現在の設定では練習に使用できる項目はありません';

  @override
  String get clearFilters => 'クリア';

  @override
  String itemCount(Object count) {
    return '$count アイテム';
  }

  @override
  String filteredItemCount(Object filtered, Object total) {
    return '$filtered/$total 個のアイテム';
  }

  @override
  String get trainingRally => 'トレーニングラリー';

  @override
  String get startTraining => 'トレーニングを開始する';

  @override
  String get trainingComingSoon => 'トレーニングラリー - 近日開催予定！';

  @override
  String get aiServiceNotConfigured =>
      'AI サービスが構成されていません。 OpenAI API キーを追加してください。';

  @override
  String pleaseEnterTextInLanguageFirst(Object language) {
    return '最初に$languageにテキストを入力してください';
  }

  @override
  String translationCompletedSuccessfully(Object service) {
    return '$service を使用して翻訳が正常に完了しました。';
  }

  @override
  String get translationFailed => '翻訳に失敗しました';

  @override
  String addedExamplesSuccessfully(Object count) {
    return '$count 例が正常に追加されました。';
  }

  @override
  String get failedToGenerateExamples => '例の生成に失敗しました';

  @override
  String get selectExamplesToAdd => '追加する例を選択してください';

  @override
  String get selectWhichExamples => 'この項目に追加する例を選択してください:';

  @override
  String get addSelected => '選択したものを追加';

  @override
  String get pleaseSelectAtLeastOne => '少なくとも 1 つの例を選択してください';

  @override
  String get addNewItem => '新しいアイテムを追加';

  @override
  String get editItem => '項目の編集';

  @override
  String get deleteItem => '項目の削除';

  @override
  String get confirmDeleteItem => 'この項目を削除してもよろしいですか?';

  @override
  String get thisActionCannotBeUndone => 'この操作は元に戻すことができません。';

  @override
  String get itemDeleted => 'アイテムが削除されました';

  @override
  String get errorDeletingItem => 'アイテムの削除中にエラーが発生しました';

  @override
  String get errorSavingItem => 'アイテムの保存中にエラーが発生しました';

  @override
  String get itemSaved => 'アイテムは正常に更新されました';

  @override
  String get itemCreated => 'アイテムが正常に作成されました';

  @override
  String get preTextOptional => 'プレテキスト (オプション)';

  @override
  String get mainText => '本文';

  @override
  String get postTextOptional => 'ポストテキスト (オプション)';

  @override
  String get forExampleToForVerbs => '例: 動詞の「to」';

  @override
  String get additionalContext => '追加のコンテキスト';

  @override
  String get translate => '翻訳する';

  @override
  String translateFromTo(Object from, Object to) {
    return '$from → $to を翻訳';
  }

  @override
  String get aiExampleGeneration => 'AI サンプルの生成';

  @override
  String get aiExampleSearch => 'AI事例検索';

  @override
  String searchExamplesOnInternet(Object text) {
    return 'AI を使用してインターネット上の例文を「$text」で検索';
  }

  @override
  String generateExampleSentences(Object language) {
    return '$languageの本文に基づいて例文を生成';
  }

  @override
  String get voiceInput => '音声入力';

  @override
  String get settings => '設定';

  @override
  String get uiLanguage => 'UI言語';

  @override
  String get uiLanguageDescription => 'アプリケーションインターフェース言語';

  @override
  String get uiLanguageHelper => 'メニュー、ボタン、ラベルの言語を選択します';

  @override
  String get userLanguage => 'ユーザー言語';

  @override
  String get userLanguageDescription => '新しい言語パッケージを作成するための優先母語';

  @override
  String get apiKeys => 'APIキー';

  @override
  String get deeplApiKey => 'DeepL APIキー';

  @override
  String get deeplApiKeyDescription =>
      '言語項目を編集する際の優れた翻訳品質を実現します。 https://www.deepl.com/pro-api を参照してください。';

  @override
  String get openaiApiKey => 'OpenAI APIキー';

  @override
  String get openaiApiKeyDescription =>
      'たとえば、言語項目を編集するときに AI を使用して生成します。 https://platform.openai.com/api-keys を参照してください。';

  @override
  String get enterApiKey => 'APIキーを入力してください';

  @override
  String get optional => 'オプション';

  @override
  String get required => '必須';

  @override
  String get settingsSaved => '設定が正常に保存されました';

  @override
  String get errorSavingSettings => '設定の保存中にエラーが発生しました';

  @override
  String get usingGoogleTranslate => '無料のGoogle翻訳を使用する';

  @override
  String get usingDeepL => 'DeepL（プレミアム）の使用';

  @override
  String get noTranslationReceivedFromGoogle => 'Google から翻訳を受け取りませんでした';

  @override
  String get googleTranslationFailed => 'Google翻訳が失敗しました';

  @override
  String get googleTranslationError => 'Google翻訳エラー';

  @override
  String get noTranslationReceivedFromDeepL => 'DeepL から翻訳を受け取りませんでした';

  @override
  String get invalidDeepLApiKey => '無効な DeepL API キー';

  @override
  String get deeplTranslationQuotaExceeded => 'DeepL 翻訳の割り当てを超過しました';

  @override
  String get deeplTranslationFailed => 'DeepL 翻訳に失敗しました';

  @override
  String get deeplTranslationError => 'DeepL翻訳エラー';

  @override
  String get invalidApiKeyConfigureOpenAI =>
      'API キーが無効です。 OpenAI API キーを設定してください。';

  @override
  String get apiRateLimitExceeded => 'API レート制限を超えました。後でもう一度試してください。';

  @override
  String get aiRequestFailed => 'AI リクエストが失敗しました';

  @override
  String get failedToParseAiResponse => 'AI 応答の解析に失敗しました。もう一度試してください。';

  @override
  String get aiGenerationError => 'AI生成エラー';

  @override
  String get voiceInputPlaceholder => '音声入力は speech_to_text パッケージを使用して実装されます';

  @override
  String get improveQualityWithApiKeys =>
      '💡 ヒント: アプリケーション設定に DeepL および OpenAI API キーを追加すると、翻訳とサンプル検索の品質が大幅に向上します。';

  @override
  String get noApiKeyFallbackMessage =>
      'API キーがない場合、基本的な翻訳と限定的な例が提供されます。最良の結果を得るには、[設定] で API キーを構成してください。';

  @override
  String get listeningForSpeech => '聞いています...今話してください';

  @override
  String get speechRecognitionNotAvailable => 'このデバイスでは音声認識は利用できません';

  @override
  String get speechRecognitionPermissionDenied => '音声認識の許可が拒否されました';

  @override
  String get speechRecognitionError => '音声認識エラー';

  @override
  String get tapToSpeak => 'マイクをタップして話す';

  @override
  String get tapToStop => 'タップして録音を停止します';

  @override
  String get speechNotRecognized => '音声は認識されませんでした。もう一度試してください。';

  @override
  String get usingWhisperApiSlower => '音声認識にクラウド AI を使用する (速度が遅くなる可能性があります)';

  @override
  String languageNotSupportedAddApiKey(String languageCode) {
    return '言語 $languageCode はネイティブにサポートされていません。 AI を利用した音声認識の設定に OpenAI API キーを追加します。';
  }

  @override
  String get recordingTapToStop => '録音...もう一度タップすると停止します';

  @override
  String get speakClearlyKeepRecording => 'はっきりと話してください。少なくとも 1 秒を記録します。';

  @override
  String get pleaseRecordLonger => '1 秒以上話し、停止をタップしてください。';

  @override
  String get errorStartingRecording => '録音開始エラー';

  @override
  String get noAudioRecorded => '音声は録音されませんでした';

  @override
  String get errorTranscribing => '音声の転写中にエラーが発生しました';

  @override
  String get trainingSettings => 'トレーニング設定';

  @override
  String get trainingPresetTitle => 'クイックセットアップ';

  @override
  String get trainingPresetHint => 'プリセットを選択すると、以下の設定が自動的に構成されます。';

  @override
  String get trainingPresetComboLabel => 'プリセット';

  @override
  String get trainingPresetAllExamplesForeignLanguage => 'すべての例、外国語';

  @override
  String get trainingPresetAllExamplesRandomLanguage => 'すべての例、ランダムな言語';

  @override
  String get trainingPresetFavouriteItemsForeignLanguage => '好きなもの、外国語';

  @override
  String get trainingPresetFavouriteItemsRandomLanguage => 'お気に入りのアイテム、ランダムな言語';

  @override
  String get trainingPresetImportantItemsForeignLanguage => '重要事項・外国語';

  @override
  String get trainingPresetImportantItemsRandomLanguage => '重要事項、ランダムな言葉遣い';

  @override
  String get trainingPresetRandomItemsRandomLanguage => 'ランダムなアイテム、ランダムな言語';

  @override
  String get trainingPresetUnknownItemsForeignLanguage => '知らないもの、外国語';

  @override
  String get trainingPresetUnknownItemsRandomLanguage => '未知のアイテム、ランダムな言語';

  @override
  String trainingPresetAppliedTapStart(String actionLabel) {
    return 'プリセットが適用されました。 「$actionLabel」をタップして開始します。';
  }

  @override
  String get trainingPresetSelectPackageFirst => '最初にパッケージを選択してください。';

  @override
  String get itemScope => '項目の範囲';

  @override
  String get lastNItems => '最近の N 個のアイテム';

  @override
  String get onlyUnknown => '不明な項目のみ';

  @override
  String get onlyImportant => '重要な項目のみ';

  @override
  String get onlyFavourite => 'お気に入りのアイテムばかり';

  @override
  String get numberOfItems => 'アイテム数';

  @override
  String get itemOrder => 'アイテムの注文';

  @override
  String get randomOrder => 'ランダムな順序';

  @override
  String get sequentialOrder => '順次注文';

  @override
  String get itemType => 'アイテムの種類';

  @override
  String get dictionaryItems => '辞書項目';

  @override
  String get examplesType => '例';

  @override
  String get displayLanguage => '表示言語';

  @override
  String get motherTongue => '母国語';

  @override
  String get targetLanguage => '対象言語';

  @override
  String get randomLanguage => 'ランダム';

  @override
  String get categoryFilter => 'カテゴリフィルター';

  @override
  String get categoryFilterHint => '含めるカテゴリを選択してください (空 = すべてのカテゴリ)';

  @override
  String get noCategories => '利用可能なカテゴリがありません';

  @override
  String get dontKnowThreshold => '閾値がわからない';

  @override
  String get dontKnowThresholdHint => '特別な処理が行われる前に項目を「不明」としてマークする必要がある回数';

  @override
  String get startTrainingRally => 'トレーニングラリーを開始';

  @override
  String get clearTrainingSettings => '設定をクリアする';

  @override
  String get confirmClearTrainingSettings =>
      'すべてのトレーニング設定をデフォルト値にリセットしてもよろしいですか?';

  @override
  String get trainingSettingsCleared => 'トレーニング設定がクリアされました';

  @override
  String get startingTraining => 'トレーニングを開始しています...';

  @override
  String get noMoreItemsToDisplay => 'フィルター設定に基づいて表示する項目はありません。';

  @override
  String get noItems => 'アイテムがありません';

  @override
  String get trainingComplete => 'トレーニング完了';

  @override
  String get allItemsCompleted => 'おめでとう！このトレーニング セッションのすべての項目を完了しました。';

  @override
  String get closeTraining => 'トレーニングを閉じる';

  @override
  String get confirmCloseTraining => 'トレーニングを終了してもよろしいですか?進行状況が保存されました。';

  @override
  String get question => '質問';

  @override
  String get answer => '答え';

  @override
  String get iKnow => '知っている';

  @override
  String get iDontKnow => 'わからない';

  @override
  String get previousItem => '前の項目';

  @override
  String get iDidNotKnowEither => '結局知らなかった';

  @override
  String get exportBeforeDelete => '削除する前にエクスポートしますか?';

  @override
  String get aiTextAnalysis => 'AIでテキスト/リストから項目を抽出';

  @override
  String get aiTextAnalysisImport => 'AIテキスト分析ツールを使用してテキストまたはリストから項目を抽出する';

  @override
  String get knowledgeLevel => '知識レベル';

  @override
  String get a1Beginner => 'A1 - 初心者';

  @override
  String get a2Elementary => 'A2 - 初級';

  @override
  String get b1Intermediate => 'B1 - 中級';

  @override
  String get b2UpperIntermediate => 'B2 - 中上級';

  @override
  String get c1Advanced => 'C1 - 上級';

  @override
  String get c2Proficient => 'C2 - 熟練した';

  @override
  String get pasteTextHere => 'ここにテキストを貼り付けます...';

  @override
  String get extractWords => '単語を抽出する';

  @override
  String get extractExpressions => '式の抽出';

  @override
  String get maxItems => '新しいアイテムの最大数';

  @override
  String get maxItemsHint => '制限を設けない場合は空のままにします';

  @override
  String get generateExamples => '例を生成する';

  @override
  String get categoryName => 'カテゴリ名';

  @override
  String get categoryNameHint => '輸入品目カテゴリ名';

  @override
  String get analyzeText => 'テキストを分析する';

  @override
  String get configureAnalysis => '抽出する項目を構成する';

  @override
  String get openaiModel => 'AIモデル';

  @override
  String get openaiModelDescription => 'ChatGPT モデルの選択';

  @override
  String get modelGpt55 => 'GPT-5.5';

  @override
  String get modelGpt55Pro => 'GPT-5.5プロ';

  @override
  String get modelGpt54 => 'GPT-5.4';

  @override
  String get modelGpt54Pro => 'GPT-5.4プロ';

  @override
  String get modelGpt54Mini => 'GPT-5.4ミニ';

  @override
  String get modelGpt5Mini => 'GPT-5ミニ';

  @override
  String get modelGpt41 => 'GPT-4.1';

  @override
  String get modelGpt55Desc => '一般用途向けの品質とスピードをバランスさせた最新のフラッグシップモデル';

  @override
  String get modelGpt55ProDesc => '最強の推論と品質を実現する最上位の GPT-5.5 バリアント';

  @override
  String get modelGpt54Desc => '強力な汎用GPT-5世代モデル';

  @override
  String get modelGpt54ProDesc => '要求の厳しいタスク向けの高機能 GPT-5.4 バリアント';

  @override
  String get modelGpt54MiniDesc => '日常業務を低コストで行うための、小型で高速な GPT-5.4 バリアント';

  @override
  String get modelGpt5MiniDesc => 'スピードとコストを最適化したコンパクトな GPT-5 ファミリー モデル';

  @override
  String get modelGpt41Desc => '互換性と確かな品質を実現する信頼性の高い GPT-4.1 オプション';

  @override
  String get modelGpt4o => 'GPT-4o';

  @override
  String get modelGpt35Turbo => 'GPT-3.5 ターボ (レガシー、バジェット)';

  @override
  String get modelGpt35Turbo16k => 'GPT-3.5ターボ16K';

  @override
  String get modelGpt4 => 'GPT-4';

  @override
  String get modelGpt4Turbo => 'GPT-4 ターボ (レガシー)';

  @override
  String get modelGpt4oDesc => '汎用に最適な選択肢。高速、マルチモーダル、強力な品質';

  @override
  String get modelGpt35TurboDesc => '従来の低コスト オプション。単純なタスクやコスト重視の使用に便利です';

  @override
  String get modelGpt35Turbo16kDesc => 'GPT-3.5 と同じですが、16K トークンのコンテキスト ウィンドウ';

  @override
  String get modelGpt4Desc => '高い推論品質。通常は遅くて高価です';

  @override
  String get modelGpt4TurboDesc =>
      'レガシー GPT-4 ファミリ オプション。古い安価な代替品が必要な場合には依然として役立ちます';

  @override
  String get analyzing => '分析中...';

  @override
  String get languageDetected => '言語が検出されました';

  @override
  String get itemsFound => '見つかったアイテム';

  @override
  String get selectItemsToImport => 'インポートする項目を選択してください';

  @override
  String get selectAll => 'すべて選択';

  @override
  String get deselectAll => 'すべての選択を解除';

  @override
  String get importSelected => '選択したものをインポート';

  @override
  String get importing => 'インポート中...';

  @override
  String get itemsImported => 'アイテムは正常にインポートされました';

  @override
  String get noItemsSelected => '項目が選択されていません';

  @override
  String get textCannotBeEmpty => 'テキストを空にすることはできません';

  @override
  String get selectAtLeastOneType => '少なくとも 1 つのタイプ (単語または表現) を選択してください';

  @override
  String get languageNotMatching => '検出された言語はパッケージ内のどの言語とも一致しません';

  @override
  String get openaiKeyRequired => 'この機能には OpenAI API キーが必要です';

  @override
  String analyzingProgress(Object current, Object total) {
    return '分析中: $current / $total';
  }

  @override
  String translatingProgress(Object current, Object total) {
    return '翻訳中: $current / $total';
  }

  @override
  String get duplicate => '重複';

  @override
  String importProgress(Object current, Object total) {
    return '$total の $current をインポートしています';
  }

  @override
  String get detectingLanguage => '言語を検出中...';

  @override
  String get extractingItems => 'アイテムを抽出中...';

  @override
  String get checkingDuplicates => '重複をチェックしています...';

  @override
  String get translating => '翻訳中...';

  @override
  String get generatingExamples => '例を生成しています...';

  @override
  String get errorAnalyzingText => 'テキストの分析中にエラーが発生しました';

  @override
  String get errorImportingItems => 'アイテムのインポート中にエラーが発生しました';

  @override
  String get warning => '警告';

  @override
  String get textIsVeryLarge => 'テキストが非常に大きい';

  @override
  String get words => '言葉';

  @override
  String get continueAnalysis => 'これは処理に時間がかかる可能性があり、分割して分析されます。続けますか?';

  @override
  String get continueLabel => '続く';

  @override
  String get exportBeforeDeleteMessage =>
      'このパッケージを削除する前にエクスポートしますか?これにより、すべてのデータが ZIP ファイルに保存されます。';

  @override
  String get deleteWithoutExport => 'エクスポートせずに削除';

  @override
  String get exportAndDelete => 'エクスポートと削除';

  @override
  String get exportingPackage => 'パッケージをエクスポートしています...';

  @override
  String packageExportedToPath(Object path) {
    return 'パッケージのエクスポート先: $path';
  }

  @override
  String errorLoadingItems(Object error) {
    return 'アイテムのロード中にエラーが発生しました: $error';
  }

  @override
  String badgeEarnedWithName(Object badgeName) {
    return '獲得したバッジ: $badgeName!';
  }

  @override
  String badgeLostWithName(Object badgeName) {
    return 'バッジの紛失: $badgeName';
  }

  @override
  String get trainingSessionProgress => 'トレーニングセッションの統計';

  @override
  String get total => '合計';

  @override
  String lastNValue(Object value) {
    return 'N = $value';
  }

  @override
  String errorLoadingSettings(Object error) {
    return '設定の読み込みエラー: $error';
  }

  @override
  String get selectPackage => 'パッケージの選択';

  @override
  String get noPackagesAvailable => '利用可能なパッケージはありません';

  @override
  String get possibleSolutions => '考えられる解決策';

  @override
  String get technicalDetails => '技術的な詳細';

  @override
  String get close => '近い';

  @override
  String get checkApiKey => 'OpenAI APIキーを確認してください';

  @override
  String get ensureValidOpenAIKey => 'API キーが有効でアクティブであることを確認してください';

  @override
  String get verifyKeyInSettings => '設定でキーを確認する';

  @override
  String get rateLimitExceeded => 'API レート制限を超えました';

  @override
  String get waitAndRetry => '数分待ってからもう一度試してください';

  @override
  String get checkAccountQuota => 'OpenAI アカウントの割り当てを確認する';

  @override
  String get invalidRequest => '無効なリクエスト形式です';

  @override
  String get tryReducingTextLength => 'テキストの長さを短くしてみてください';

  @override
  String get checkTextFormat => 'テキスト形式が正しいことを確認してください';

  @override
  String get checkInternetConnection => 'インターネット接続を確認してください';

  @override
  String get retryInMoment => 'しばらくしてから再試行してください';

  @override
  String get checkFirewall => 'ファイアウォール設定を確認する';

  @override
  String get textMayBeTooShort => 'テキストが短すぎる可能性があります';

  @override
  String get tryDifferentKnowledgeLevel => '別の知識レベルを試す';

  @override
  String get ensureTextInCorrectLanguage => 'テキストが正しい言語であることを確認してください';

  @override
  String get requestTimedOut => 'リクエストがタイムアウトしました';

  @override
  String get textMayBeTooLong => 'テキストが長すぎる可能性があります';

  @override
  String get tryAgainOrReduceSize => 'もう一度試すか、テキストサイズを小さくしてください';

  @override
  String get unexpectedError => '予期しないエラーが発生しました';

  @override
  String get checkErrorDetails => '以下のエラーの詳細を確認してください';

  @override
  String get tryAgainLater => '後でもう一度試してください';

  @override
  String get translationServiceFailed => '翻訳サービスが失敗しました';

  @override
  String get checkApiKeys => 'API キーを確認する (DeepL、OpenAI)';

  @override
  String get retryImport => 'インポートを再試行します';

  @override
  String get exampleGenerationFailed => 'サンプルの生成に失敗しました';

  @override
  String get itemsStillImported => 'アイテムはまだインポートされていました';

  @override
  String get canAddExamplesManually => '後で手動で例を追加できます';

  @override
  String get databaseError => 'データベースエラーが発生しました';

  @override
  String get checkStorageSpace => '利用可能なストレージ容量を確認する';

  @override
  String get restartApp => 'アプリを再起動してみてください';

  @override
  String get groupLabel => 'グループ：';

  @override
  String get amendGroups => '修正する';

  @override
  String get exportItemsJson => 'アイテムのエクスポート (JSON)';

  @override
  String get exportItemsJsonTooltip => 'すべてのアイテムを JSON ファイルとしてエクスポート';

  @override
  String get noCategoriesInPackage => 'このパッケージにはカテゴリが見つかりません';

  @override
  String get noItemsToExport => 'エクスポートする項目が見つかりませんでした';

  @override
  String itemsExportedSuccessfully(int count, String path) {
    return '$count アイテムを次の場所に正常にエクスポートしました:\n$path';
  }

  @override
  String get errorExportingItems => 'アイテムのエクスポート中にエラーが発生しました';

  @override
  String get languageMismatch => '言語の不一致';

  @override
  String get languageMismatchDescription => 'JSON ファイル内の言語がパッケージの言語と一致しません。';

  @override
  String packageLanguages(String lang1, String lang2) {
    return 'パッケージ: $lang1 → $lang2';
  }

  @override
  String jsonFileLanguages(String lang1, String lang2) {
    return 'JSON ファイル: $lang1 → $lang2';
  }

  @override
  String get continueImportQuestion => 'それでもインポートを続行しますか?';

  @override
  String get continueImport => 'インポートを続行する';

  @override
  String get pleaseSelectPackageGroup => 'パッケージグループを選択してください';

  @override
  String get customIconLabel => 'カスタム';

  @override
  String get defaultIconLabel => 'デフォルト';

  @override
  String get icon2Label => '開いた本';

  @override
  String get icon3Label => 'カラーブック';

  @override
  String get icon4Label => '会話';

  @override
  String get icon5Label => '卒業';

  @override
  String get icon6Label => '脳';

  @override
  String get icon7Label => '本の山';

  @override
  String get icon8Label => 'フラッシュカード';

  @override
  String get icon9Label => 'グローブ';

  @override
  String get icon10Label => '鉛筆';

  @override
  String get icon11Label => 'トロフィー';

  @override
  String get icon12Label => '検索';

  @override
  String get customIconFile => 'カスタムアイコン';

  @override
  String get importedIconFile => 'インポートされたアイコン';

  @override
  String get unableToReadImageFile => '画像ファイルを読み取れません。有効な画像を選択してください。';

  @override
  String iconDimensionsTooLarge(int width, int height) {
    return 'アイコンの寸法が大きすぎます (${width}x$height)。許容される最大値は 512x512 ピクセルです。';
  }

  @override
  String get iconFileTooLarge => 'アイコンファイルが大きすぎます。最大サイズは1MBです。';

  @override
  String failedToUploadIcon(String error) {
    return 'アイコンのアップロードに失敗しました: $error';
  }

  @override
  String get pleaseSelectValidLanguage => 'リストから有効な言語を選択してください';

  @override
  String get status => '状態';

  @override
  String get addExample => '例を追加';

  @override
  String get noExamplesYet => 'まだ例はありません。 +をクリックして追加します。';

  @override
  String get speakText => 'テキストを読み上げる';

  @override
  String get removeCategory => 'カテゴリの削除';

  @override
  String removeCategoryConfirm(String categoryName) {
    return 'カテゴリ「$categoryName」をこのアイテムから削除しますか?';
  }

  @override
  String get remove => '取り除く';

  @override
  String get extractFullItems => '完全なアイテムを抽出';

  @override
  String get pasteFromClipboard => 'クリップボードから貼り付け';

  @override
  String get noItemsFoundOrAllDuplicates =>
      'テキスト内にアイテムが見つからないか、すべてのアイテムがパッケージ内にすでに存在します';

  @override
  String get aboutLanguageRally => 'ランゲージラリーについて';

  @override
  String get welcomeTitle => '🚀 ランゲージラリーへようこそ';

  @override
  String get welcomeSubtitle =>
      'あらゆる熟練度レベルに合わせて厳選された、約 4,000 の単語、4,000 の表現、そして同数の例文を使って、言語学習の驚異的な力を解き放ちましょう。 AI を使用して自分のテキストから項目をインポートしたり、任意のトピックについて AI とチャットして、学習したい正確な単語、表現、例を生成したりできます。\n賢くて遊び心のある方法で語学スキルをレベルアップしましょう!';

  @override
  String get welcomeIntro =>
      '実際に気になる部分を練習することで、効率的に語彙や表現を学びましょう。退屈なリストはありません。無駄な時間はありません。';

  @override
  String get sectionPlayYourGame => '🎮 自分のゲームをプレイする';

  @override
  String get sectionPlayYourGameDesc =>
      '独自の語彙パッケージを作成します。マスターしたい単語や表現だけをトレーニングしてください。もうご存知ですか？マークされてスキップされます。';

  @override
  String get sectionAITeammate => '🤖 AI をチームメイトとして';

  @override
  String get sectionAITeammateDesc =>
      '任意のテキストを貼り付けて、AI に次のことを実行させます。\n• 役立つ語彙を抽出する\n• 自分のレベルに合った表現を選ぶ\n• すぐにトレーニングできるパッケージを数秒で構築\n\nAI とチャット:\n• あなたのトピックに合わせて単語や表現を提案してもらいましょう\n• クリックしてサンプルを生成し、独自のパッケージに保存します。';

  @override
  String get sectionTrainSmart => '🔁 スマートにトレーニング';

  @override
  String get sectionTrainSmartDesc =>
      '当社の微調整された繰り返しシステムは、効果的に記憶するために脳が必要とするときに正確に項目を表示します。最大限の進歩。最小限の努力。';

  @override
  String get sectionRealExamples => '🌍 実際の例。素晴らしい翻訳。';

  @override
  String get sectionRealExamplesDesc =>
      '実際の使用例をご覧ください。 DeepL を介して高品質で翻訳します。発音を練習して自信を持って発音しましょう。';

  @override
  String get sectionTeachersWelcome => '👩‍🏫 先生方、ようこそ';

  @override
  String get sectionTeachersWelcomeDesc =>
      'パッケージを作成 → アイテムをコピー＆ペーストするか、AI を使用してサンプルを抽出、翻訳、追加 → エクスポート → アップロード/送信 → 完了。生徒はそれをインポートして、すぐに練習を始めます。';

  @override
  String get sectionUnlockAI => '🔑 AI パワーを最大限に活用';

  @override
  String get sectionUnlockAIDesc =>
      '高品質の翻訳と AI 機能を利用するには、次の手順を実行します。\n\n1. DeepL API キーを作成します\n   https://www.deepl.com/pro-api\n2. OpenAI API キーを作成します\n   https://platform.openai.com/api-keys\n3. 両方のキーを設定に貼り付けます\n\n少額の投資で、強力なプロ仕様の言語ツールが利用できるようになります。なぜそれを逃すのでしょうか?\n(最良の結果を得るには、有料 API アクセスを使用することをお勧めします。)';

  @override
  String get readyToStart => 'ラリーを始める準備はできていますか? 🏁';

  @override
  String get welcomeDescription =>
      'Language Rally は、総合的な言語学習のパートナーです。カスタム語彙パッケージを作成し、項目をカテゴリ別に整理し、インテリジェントな間隔をあけた反復システムでトレーニングします。';

  @override
  String get browseStore => 'ストアを参照';

  @override
  String get featureInteractiveTraining => 'インタラクティブなトレーニング';

  @override
  String get featureInteractiveTrainingDesc => '適応学習アルゴリズムを使って練習する';

  @override
  String get featureSmartOrganization => 'スマートな組織';

  @override
  String get featureSmartOrganizationDesc => '語彙を分類してフィルタリングする';

  @override
  String get featureTrackProgress => '進捗状況を追跡する';

  @override
  String get featureTrackProgressDesc => '詳細な統計で学習を監視する';

  @override
  String get featureImportExport => 'インポートとエクスポート';

  @override
  String get featureImportExportDesc => 'パッケージを共有し、デバイス間で同期する';

  @override
  String get startAppTour => 'アプリツアーを開始する';

  @override
  String get quickStartGuide => 'クイックスタートガイド';

  @override
  String get tourStep1Title => 'パッケージの作成またはインポート';

  @override
  String get tourStep1Desc =>
      '新しい言語パッケージを作成することから始めるか、ファイルから既存の言語パッケージをインポートします。';

  @override
  String get tourStep2Title => '語彙項目を追加する';

  @override
  String get tourStep2Desc => 'パッケージを参照し、例やカテゴリを含む単語、フレーズ、または表現を追加します。';

  @override
  String get tourStep3Title => 'トレーニングの構成';

  @override
  String get tourStep3Desc => '練習する項目を選択し、難易度を設定して、学習体験をカスタマイズします。';

  @override
  String get tourStep4Title => '学習を始める';

  @override
  String get tourStep4Desc => 'トレーニング セッションを開始し、項目を既知または不明としてマークして、進捗状況を追跡します。';

  @override
  String get tourStep5Title => '統計を確認する';

  @override
  String get tourStep5Desc => '詳細な統計と達成バッジで学習の進捗状況を確認します。';

  @override
  String get gotIt => 'わかった！';

  @override
  String get appTourTitle => 'ランゲージラリーへようこそ';

  @override
  String get appTourSubtitle => '賢く、遊び心があり、完全にパーソナライズされた言語学習のパートナーです。';

  @override
  String get tourPage1Title => '自分が望むものと必要なものを学び、実践する';

  @override
  String get tourPage1Desc =>
      '当社の適応学習システムにより、完璧なタイミングで項目を復習できるようになり、記憶力を最大化し、労力を最小限に抑えることができます。\n\n組み込みの自動化機能を利用して学習します。\nすでに知っている単語に時間を無駄にするのはやめましょう。\n\n興味のある語彙や表現だけを練習してください。あなたの目標とレベルに合わせて完全にカスタマイズされた独自のアイテムを作成してトレーニングします。';

  @override
  String get tourPage2Title => '独自の言語パッケージを作成する';

  @override
  String get tourPage2Desc =>
      '自分の興味や学習目標に合った、パーソナライズされた語彙コレクションを作成します。\n\nトピック、難易度、またはコンテキストごとに単語や表現を整理します。\n\n何をいつ学習するかを完全にコントロールできます。';

  @override
  String get tourPage3Title => 'AIを活用したアイテムの作成';

  @override
  String get tourPage3Desc =>
      '瞬く間に独自の学習パッケージを構築します。\n\n• 任意のテキストを貼り付けると、AI が関連する語彙を自動的に抽出します\n• 自分のレベルにぴったりの単語や表現を特定する\n• AI に翻訳してもらいましょう\n• AI にリアルタイムの例を検索させます\n\nAI とチャット:\n• あなたのトピックに合わせて単語や表現を提案してもらいましょう\n• クリックしてサンプルを生成し、独自のパッケージに保存します。\n• トレーニングの準備が整ったパッケージを迅速に作成する';

  @override
  String get tourPage4Title => 'AI を活用した現実世界の例とプレミアムな翻訳';

  @override
  String get tourPage4Desc =>
      '• 本物の使用例を即座に検索\n• 高品質の DeepL 統合により、単語、表現、全文を翻訳\n• 正確でコンテキストを認識した結果を取得する';

  @override
  String get tourPage5Title => 'スマートなパッケージ構成';

  @override
  String get tourPage5Desc =>
      '• 語彙をカスタム カテゴリに整理する\n• フィルタリングして特定のトピックに焦点を当てる\n• デバイス間でパッケージをインポートおよびエクスポートする\n• パッケージを他の人と簡単に共有';

  @override
  String get tourPage6Title => '発音をトレーニングする';

  @override
  String get tourPage6Desc =>
      'インタラクティブな練習ツールを使用して発音をテストし、改善します。\n\n読むだけでなく話すことにも自信を持ちましょう。';

  @override
  String get tourPage7Title => '教師向け';

  @override
  String get tourPage7Desc =>
      '数回クリックするだけで、生徒向けにすぐに使える語彙パッケージを作成できます。\n\nそれらをエクスポートしてクラスに送信し、インポートすると、すぐに各生徒のデバイスで練習できるようになります。\n\n単純。速い。効果的。';

  @override
  String get tourPage8Title => '高品質の AI サポートを利用可能';

  @override
  String get tourPage8Desc =>
      'プレミアムな翻訳と高度な AI 機能を利用するには、次の手順を実行します。\n 1. 独自の DeepL API キーを作成する\n 2. 独自の OpenAI API キーを作成する\n 3. 両方のキーを設定セクションに貼り付けます。\n\nこれに必要な予算はわずか (数ドル) ですが、強力なプロ仕様の言語ツールにアクセスできます。\n注: 最良の結果を得るには、有料 API アクセスを使用することをお勧めします。費用はわずか数ドルです。\n\n🔑 DeepL API キー: https://www.deepl.com/pro-api\n\n🔑 OpenAI API キー: https://platform.openai.com/api-keys';

  @override
  String get previousPage => '前の';

  @override
  String get nextPage => '次';

  @override
  String get endTour => 'ツアー終了';

  @override
  String pageIndicator(int current, int total) {
    return 'ページ $current / $total';
  }

  @override
  String get practicePronunciation => '発音の練習';

  @override
  String get pronunciationPractice => '発音の練習';

  @override
  String get startPractice => '練習を始める';

  @override
  String get listenToPronunciation => '発音を聞く';

  @override
  String get tapToRecord => 'タップして録音する';

  @override
  String get recording => '録音中...';

  @override
  String get recorded => '録音済み';

  @override
  String get speakNow => '今すぐ話してください - マイクに近づいてはっきりと話してください';

  @override
  String get noSpeechDetected => '音声が検出されませんでした。もう一度試してください。';

  @override
  String get noTextRecognized =>
      '録音では音声は認識されませんでした。マイクが機能していることを確認して、もう一度お試しください。';

  @override
  String get processingAudio => 'AIで音声を処理中...';

  @override
  String get playbackRecording => '録音を再生する';

  @override
  String get playbackRecordingSubtitle => 'AI が処理している間に録音を聞く';

  @override
  String get recordingTooShort => '録音が短すぎます。少なくとも 1 秒間話してください。';

  @override
  String get microphonePermissionRequired => '発音練習にはマイクの許可が必要です';

  @override
  String get speechRecognitionNotSupported =>
      'このプラットフォームでは音声認識はサポートされていません。発音練習にはモバイルアプリ（Android/iOS）をご利用ください。';

  @override
  String get speechRecognitionUnavailable => 'このデバイスでは音声認識は利用できません。';

  @override
  String get pronunciationAccuracy => '発音\n精度';

  @override
  String get excellent => '素晴らしい！';

  @override
  String get good => '良い';

  @override
  String get fair => '公平';

  @override
  String get needsImprovement => '改善が必要';

  @override
  String get tryAgain => 'もう一度やり直してください';

  @override
  String get nextItem => '次の項目';

  @override
  String get endPractice => '練習終了';

  @override
  String get practiced => '練習した';

  @override
  String get windowsAudioTestPageTitle => 'Windows オーディオ テスト (RTAudio)';

  @override
  String get configureWindowsAudio => 'オーディオのテストと構成\nWindows での入力';

  @override
  String get configureWindowsAudioDescription =>
      'ネイティブ Windows RTAudio ドライバーを使用してオーディオを録音、再生、転写する';

  @override
  String get audioTestTitle => 'Windows オーディオ録音テスト';

  @override
  String get audioTestSubtitle => 'RTAudio — ネイティブ Windows オーディオ録音';

  @override
  String get audioInputDevice => 'オーディオ入力デバイス';

  @override
  String get selectMicrophone => 'マイクの選択';

  @override
  String get refreshDevices => 'デバイスをリフレッシュする';

  @override
  String get noAudioDevicesFound => 'オーディオ入力デバイスが見つかりません';

  @override
  String get loadingAudioDevices => 'オーディオデバイスを読み込んでいます...';

  @override
  String get recordingSettings => '録音設定';

  @override
  String get stereoRecording => 'ステレオ録音';

  @override
  String get stereoChannels => '2チャンネル（ステレオ）';

  @override
  String get monoChannel => '1チャンネル（モノラル）';

  @override
  String get sampleRateLabel => 'サンプルレート';

  @override
  String get nativeRateBadge => 'ネイティブ';

  @override
  String get microphoneGainLabel => 'マイクゲイン';

  @override
  String get gainHint => '1x = ブーストなし • 3x ≈ +9.5 dB • 10x ≈ +20 dB';

  @override
  String get tapToStartRec => 'タップして録音を開始';

  @override
  String get tapToStopRec => 'タップして録音を停止します';

  @override
  String get recordingCompleteLabel => '録音完了';

  @override
  String get tapMicToStop => 'マイクをタップして停止します';

  @override
  String get playRecordingLabel => '再生録音';

  @override
  String get stopPlaybackLabel => '停止';

  @override
  String get whisperSectionTitle => 'OpenAI ウィスパー文字起こし';

  @override
  String get whisperWavNote =>
      'WAV (16 ビット PCM) は Whisper によってネイティブにサポートされており、変換は必要ありません。';

  @override
  String get sendToWhisperLabel => 'ウィスパーに送信';

  @override
  String get transcribingLabel => '転記中...';

  @override
  String get transcriptionResultLabel => '文字起こし結果';

  @override
  String get transcriptionFailedLabel => '転写に失敗しました';

  @override
  String get debugInformationLabel => '情報';

  @override
  String get debugConsoleHint => 'コンソールで詳細なログを確認してください';

  @override
  String get debugDevicesFound => '見つかったデバイス';

  @override
  String get debugSelectedDevice => '選択したデバイス';

  @override
  String get debugDeviceRateNative => 'デバイスレート (ネイティブ)';

  @override
  String get debugRequestedRate => '要求レート';

  @override
  String get debugActualRate => '実際に使用されたレート';

  @override
  String get debugActualRateForced => '⚠強制';

  @override
  String get debugActualRateOk => '✓';

  @override
  String get debugRecordingMode => '録音モード';

  @override
  String get debugLastRecording => '最後の録音';

  @override
  String get debugFileSize => 'ファイルサイズ';

  @override
  String get debugStereo => 'ステレオ';

  @override
  String get debugMono => '単核症';

  @override
  String get recordingSavedSnack => '録音が保存されました';

  @override
  String get recordingTooShortSnack => '録音時間が短すぎます。少なくとも1秒以上録音してください。';

  @override
  String get recordingSmallSnack => '録音ファイルは非常に小さいです。録音に失敗している可能性があります。';

  @override
  String get noAudioDataSnack => '音声データが記録されていない';

  @override
  String get noDeviceSelectedSnack => 'オーディオデバイスを選択してください';

  @override
  String get failedToInitRtAudio => 'RTAudioの初期化に失敗しました';

  @override
  String get envelopeScoreLabel => '封筒';

  @override
  String get rhythmScoreLabel => 'リズム';

  @override
  String get textScoreLabel => '文章';

  @override
  String get help => 'ヘルプ';

  @override
  String get trainingHelpTitle => 'トレーニングのヒント';

  @override
  String get trainingHelpText =>
      'トレーニングをできるだけ効果的にするには、次の手順に従ってください。\n1. [カウンターをクリア] ボタンをクリックすると、このパッケージ内のすべてのアイテムが既知としてマークされます。\n2.「項目範囲」を「すべての項目」に設定します。\n3.「アイテムの順序」を「ランダム」に設定します。\n4. [表示言語] で母国語を選択します。\n5. トレーニングを開始し、不明な項目が約 20 ～ 30 個特定されるまで続けます。\n6. トレーニング設定に戻り、「項目の範囲」を「不明な項目のみ」に変更します。\n7. トレーニングを再開し、これまでに知らなかった項目をすべて学習するまで続けます。';

  @override
  String get trainingProTip => 'プロのヒント: すべてのアイテムから始めます。後で、未知の部分のみに焦点を当てます。';

  @override
  String get onboardingWelcomeTitle => 'ランゲージラリーへようこそ！';

  @override
  String get onboardingSetupSubtitle => 'アプリをセットアップしましょう。';

  @override
  String get onboardingSelectUiLanguage => 'インターフェース言語';

  @override
  String get onboardingUiLanguageNote => 'これは後で「設定」→「UI 言語」で変更できます。';

  @override
  String get onboardingNext => '次';

  @override
  String get onboardingBack => '戻る';

  @override
  String get onboardingSelectPackagesTitle => '言語パッケージの選択';

  @override
  String get onboardingSelectPackagesSubtitle =>
      'インポートする語彙パッケージを選択します。後でメイン メニュー ([パッケージの表示]) からいつでも追加できます。';

  @override
  String get onboardingAnalyzingPackages => '利用可能なパッケージを分析しています…';

  @override
  String onboardingScanningPackagesProgress(
    int scanned,
    int total,
    int alreadyInDb,
  ) {
    return 'スキャン済み $scanned/$total • すでに DB $alreadyInDb にあります';
  }

  @override
  String get onboardingImportSelected => '選択したものをインポート';

  @override
  String get onboardingSkipImport => 'スキップ';

  @override
  String get onboardingSelectAll => 'すべて選択';

  @override
  String get onboardingDeselectAll => 'すべての選択を解除';

  @override
  String onboardingNPackages(int count) {
    return '$count パッケージ';
  }

  @override
  String get onboardingGetStarted => '始めましょう';

  @override
  String get onboardingImportCompleteTitle => 'インポート完了！';

  @override
  String get importBuiltInPkg => '無料パッケージ';

  @override
  String get importBuiltInPkgTooltip => '無料のバンドル言語パッケージをインポートする';

  @override
  String get globalSearch => 'グローバル検索';

  @override
  String get globalSearchTitle => 'すべてのパッケージを検索';

  @override
  String get globalSearchSelectLanguage => '言語コードの選択';

  @override
  String get globalSearchEnterWord => '検索する単語';

  @override
  String get globalSearchEnterWordHint => '例えば\"der\"、\"order\" — 部分一致を検索します';

  @override
  String get globalSearchButton => '検索';

  @override
  String get globalSearchResults => '結果';

  @override
  String globalSearchNoResults(String query) {
    return '「$query」に一致する結果はありませんでした';
  }

  @override
  String globalSearchResultsCount(int count) {
    return '$count 件の結果が見つかりました';
  }

  @override
  String get globalSearchSearching => '検索中…';

  @override
  String get globalSearchSelectLanguageFirst => '最初に言語コードを選択してください';

  @override
  String get globalSearchEnterTermFirst => '検索語を入力してください';

  @override
  String get globalSearchMatchInExamples => '例で見つかった';

  @override
  String get globalSearchViewItem => 'ビュー';

  @override
  String get globalSearchGoToPackage => 'パッケージに移動';

  @override
  String get globalSearchLoadingPackages => 'パッケージをロード中…';

  @override
  String get globalSearchNoPackages => '言語パッケージがまだインストールされていません';

  @override
  String get globalSearchCancelSearch => '検索のキャンセル';

  @override
  String globalSearchProgressOf(int current, int total) {
    return '$total のパッケージ $current を検索しています…';
  }

  @override
  String globalSearchCancelledMessage(int count) {
    return '検索がキャンセルされました — これまでに $count 件の結果が見つかりました';
  }

  @override
  String get storeTitle => '言語パッケージストア';

  @override
  String get storeRestorePurchases => '購入したものを復元する';

  @override
  String get storeRefresh => 'リフレッシュ';

  @override
  String get storeSearchHint => 'パッケージを検索…';

  @override
  String get storeNoPackagesMatchSearch => '検索に一致するパッケージはありません。';

  @override
  String get storeNoPackagesAvailable => '利用可能なパッケージはありません。';

  @override
  String storeInstalledCount(int installed, int total) {
    return '$installed / $total がインストールされています';
  }

  @override
  String get storeLoadErrorTitle => 'ストアを読み込めませんでした。';

  @override
  String get storeIapNotAvailableMessage =>
      'このプラットフォームではアプリ内購入は利用できません。パッケージを購入するには、当社の Web サイトにアクセスしてください。';

  @override
  String get storeOpenWebsite => 'ウェブサイトを開く';

  @override
  String storePurchaseSuccess(String title) {
    return '$title は正常にインストールされました。';
  }

  @override
  String get storePurchaseCancelled => '購入はキャンセルされました。';

  @override
  String storePurchaseAlreadyOwned(String title) {
    return '$title はすでにインストールされています。';
  }

  @override
  String get storePurchaseError => '何か問題が発生しました。もう一度試してください。';

  @override
  String get storePurchasesRestored => '購入が復元されました';

  @override
  String get storeAllLevels => 'すべてのレベル';

  @override
  String get storeAllGroups => 'すべての言語';

  @override
  String get storeFilterLevel => 'レベル';

  @override
  String get storeFilterLanguage => '言語';

  @override
  String get storeDownload => 'ダウンロード';

  @override
  String get storeBuy => '買う';

  @override
  String get storeInstalledLabel => 'インストール済み';

  @override
  String get storeDownloading => 'ダウンロード中…';

  @override
  String get storeRetry => 'リトライ';

  @override
  String get storeIapAndroidOnly => 'Android と iOS でのみ購入できます。';

  @override
  String get storeDismiss => '却下する';

  @override
  String get storeAddToCart => 'カートに追加';

  @override
  String get storeRemoveFromCart => '取り除く';

  @override
  String get storeCartTitle => 'ショッピングカート';

  @override
  String get storeCartEmpty => 'カートは空です';

  @override
  String get storeCartClearAll => 'すべてクリア';

  @override
  String get storeCartCheckout => 'チェックアウト';

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
  String get storePackageDuplicateTitle => 'パッケージはすでに存在します';

  @override
  String storePackageDuplicateMessage(String packageName, String groupName) {
    return 'パッケージ「$packageName」はグループ「$groupName」にすでに存在します。上書きしますか?既存のパッケージとそのすべてのトレーニングの進行状況は完全に削除されます。';
  }

  @override
  String get storePackageDuplicateOverwrite => '上書き';

  @override
  String get storePackageDuplicateKeep => '存在し続ける';

  @override
  String splashSettingUpPackages(int current, int total) {
    return 'パッケージのセットアップ: $current / $total';
  }

  @override
  String get splashThisHappensOnce => 'これは一度だけ起こります。';

  @override
  String get splashLoading => '読み込み中…';

  @override
  String get aiItemCreator => 'AIチャットの達人';

  @override
  String get aiItemCreatorAppBarHint => 'AIとのチャットにより単語や表現を収集・保存';

  @override
  String get chatWithAI => 'AIとチャットする';

  @override
  String get enterYourPrompt => 'プロンプトを入力してください...';

  @override
  String get aiItemCreatorPromptHint =>
      'トピックについて説明すると、AI コーチが質問し、役立つ語彙を提案し、あなたの知識をテストします。例: 知識レベル B2 の旅行に関する危険を収集し、実践するのを手伝ってください。';

  @override
  String get send => '送信';

  @override
  String get sending => '送信中...';

  @override
  String get aiResponse => 'AIの対応';

  @override
  String get itemInputs => '項目入力';

  @override
  String get aiItemCreatorBothItemsRequired => '保存する前に両方の言語フィールドに入力してください。';

  @override
  String get aiItemCreatorDuplicateItemMessage =>
      '同じテキストのペアを持つアイテムがこのパッケージ内にすでに存在します。';

  @override
  String get language1 => '言語 1';

  @override
  String get language2 => '言語 2';

  @override
  String get translateLang1ToLang2 => 'ラング 2 への翻訳';

  @override
  String get translateLang2ToLang1 => 'ラング 1 への翻訳';

  @override
  String translateToLanguageCode(String languageCode) {
    return '$languageCode に翻訳';
  }

  @override
  String get example => '例';

  @override
  String get generating => '生成中...';

  @override
  String get flags => 'フラグ';

  @override
  String get favorite => 'お気に入り';

  @override
  String get saveItems => '保存';

  @override
  String get saving => '保存中...';

  @override
  String get clearItems => 'クリアアイテムのみ';

  @override
  String get clearAll => 'すべてのフィールドをクリア';

  @override
  String get itemSavedSuccessfully => 'アイテムは正常に保存されました';

  @override
  String get promptCannotBeEmpty => 'プロンプトを空にすることはできません';

  @override
  String get enterAtLeastOneItem => '少なくとも 1 つの項目を入力してください';

  @override
  String get selectPackageFirst => '最初にパッケージを選択してください';

  @override
  String get deeplKeyRequired => '翻訳にはDeepL APIキーが必要です';

  @override
  String get noNonPurchasedPackagesAvailable => '未購入のパッケージは利用できません';

  @override
  String get packageSelectionRemembered => 'パッケージの選択が保存されました';

  @override
  String get aiItemCreatorOpenAiKeyNotConfiguredDetailed =>
      'OpenAI API キーが設定されていません。 API キーを設定に追加してください。';

  @override
  String get aiItemCreatorOpenAiKeyNotConfigured => 'OpenAI API キーが設定されていません。';

  @override
  String get aiItemCreatorProcessingComplete => '処理が完了しました';

  @override
  String get aiItemCreatorTranslationComingSoon => '翻訳機能も近日公開予定';

  @override
  String get aiItemCreatorDefaultCategoryName => 'AI が作成';

  @override
  String get aiItemCreatorStartNewConversation => '新しい会話を開始する';

  @override
  String get aiItemCreatorChatHint =>
      'トピックについて説明すると、AI コーチが質問し、役立つ語彙を提案し、あなたの知識をテストします。';

  @override
  String get aiItemCreatorConversation => '会話';

  @override
  String get aiItemCreatorYou => 'あなた';

  @override
  String get aiItemCreatorCoach => 'AIコーチ';

  @override
  String get aiItemCreatorAiSuggestions => 'AIによる提案';

  @override
  String get aiItemCreatorTapChipToFill => 'チップをタップしてアイテムフィールドを埋め、自動翻訳します。';

  @override
  String get aiItemCreatorNoSuggestedItems => 'まだ言葉も表現もありません。';

  @override
  String get aiItemCreatorNextSteps => '継続方法';

  @override
  String get aiItemCreatorNoNextSteps => '継続の提案はまだありません。';

  @override
  String get aiItemCreatorModelCostTip =>
      'プロのヒント: 新しいモデルは高価ですが、古いモデルやターボ モデルは安価で、大幅に高速になります。';

  @override
  String get aiItemCreatorSelectPackageDialogTitle => '言語パッケージを選択してください';

  @override
  String get aiItemCreatorSelectPackageDialogMessage =>
      'このセッションに使用する言語パッケージを選択します。最後の選択は事前に選択されています。';

  @override
  String aiItemCreatorMissingApiKeysWarning(String keys) {
    return 'API キーがありません: $keys。続行できますが、AI およびプレミアム翻訳機能が制限される場合があります。';
  }

  @override
  String get about => 'について';

  @override
  String get aboutWebsite => 'Webサイト';

  @override
  String get aboutSummaryVideo => '概要動画';

  @override
  String get aboutSupportEmail => 'サポートメールアドレス';

  @override
  String get aboutWebsiteUrl => 'https://sites.google.com/view/ language-rally';

  @override
  String get aboutSummaryVideoUrl =>
      'https://www.youtube.com/watch?v=64Pl9iNF88c';

  @override
  String get aboutSupportEmailAddress => 'languagerally.support@gmail.com';

  @override
  String aboutVersionWithValue(String version) {
    return 'バージョン: $version';
  }

  @override
  String aboutCouldNotOpen(String uri) {
    return '開けませんでした: $uri';
  }

  @override
  String get aboutWelcomeSplashNotFound => 'ウェルカム スプラッシュ画像が見つかりません';

  @override
  String get chooseTheme => 'テーマの選択';

  @override
  String get darkMode => 'ダークモード';

  @override
  String get toggleBetweenLightAndDark => '明暗を切り替えます';

  @override
  String get colorTheme => 'カラーテーマ:';

  @override
  String get toggleBrightness => '明るさを切り替えます';

  @override
  String get changeTheme => 'テーマの変更';

  @override
  String get managePackageGroups => 'パッケージグループの管理';

  @override
  String get noPackageGroups => 'パッケージグループがありません';

  @override
  String get createFirstPackageGroup => '最初のパッケージ グループを作成する';

  @override
  String get addGroup => 'グループの追加';

  @override
  String get addPackageGroup => 'パッケージグループの追加';

  @override
  String get editPackageGroup => 'パッケージグループの編集';

  @override
  String get groupName => 'グループ名';

  @override
  String get enterGroupName => 'グループ名を入力してください';

  @override
  String get groupNameRequired => 'グループ名は必​​須です';

  @override
  String get duplicateGroupName => '重複した名前';

  @override
  String groupNameAlreadyExists(String name) {
    return '「$name」という名前のグループはすでに存在します。';
  }

  @override
  String groupCreatedSuccessfully(String name) {
    return 'グループ「$name」が正常に作成されました';
  }

  @override
  String failedToCreateGroup(String error) {
    return 'グループの作成に失敗しました: $error';
  }

  @override
  String groupRenamedTo(String name) {
    return 'グループ名が「$name」に変更されました';
  }

  @override
  String failedToUpdateGroup(String error) {
    return 'グループを更新できませんでした: $error';
  }

  @override
  String get deleteGroup => 'グループの削除';

  @override
  String deleteGroupConfirm(String name) {
    return 'グループ「$name」を削除してもよろしいですか?\n\nこの操作は元に戻すことができません。';
  }

  @override
  String get cannotDeleteGroup => '削除できません';

  @override
  String groupHasPackages(int count) {
    return 'このグループにはまだ $count パッケージがあります。まず移動または削除してください。';
  }

  @override
  String groupDeleted(String name) {
    return 'グループ「$name」が削除されました';
  }

  @override
  String failedToDeleteGroup(String error) {
    return 'グループの削除に失敗しました: $error';
  }

  @override
  String get cannotDeleteHasPackagesTooltip => '削除できません（パッケージあり）';

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
  String get manageGroups => 'グループの管理';

  @override
  String get featureLangPower => '言語力';

  @override
  String get featureAiIntegration => 'AIの統合';

  @override
  String get featureAdaptivePractice => '適応的な練習';

  @override
  String get featureMasterAccent => 'マスターアクセント';

  @override
  String get allBadgesEarned => '🎉 バッジをすべて獲得しました!あなたはマスターです!';

  @override
  String nextBadgeLabel(String name) {
    return '次へ: $name';
  }

  @override
  String pointsToGo(String percent) {
    return 'あと$percent%';
  }

  @override
  String progressPercent(String percent) {
    return '$percent% の進捗状況';
  }

  @override
  String errorTogglingFavourite(String error) {
    return 'お気に入りの切り替えエラー: $error';
  }

  @override
  String errorTogglingImportant(String error) {
    return '重要な切り替えエラー: $error';
  }

  @override
  String categoryAdded(String name) {
    return 'カテゴリ「$name」を追加しました';
  }

  @override
  String errorAddingCategory(String error) {
    return 'カテゴリ追加エラー: $error';
  }

  @override
  String categoryRemoved(String name) {
    return 'カテゴリ「$name」が削除されました';
  }

  @override
  String errorRemovingCategory(String error) {
    return 'カテゴリの削除中にエラーが発生しました: $error';
  }

  @override
  String couldNotOpenUrl(String url) {
    return 'URLを開けませんでした: $url';
  }

  @override
  String errorOpeningUrl(String error) {
    return 'URL を開くときにエラーが発生しました: $error';
  }

  @override
  String get pleaseSelectLanguage => '言語を選択してください';

  @override
  String get add => '追加';

  @override
  String get speak => '話す';

  @override
  String get recordingFailedToStart =>
      '録音を開始できませんでした!\n\n確認してください:\n1.マイクが接続されています\n2. マイクがデフォルトのデバイスとして設定されています\n3. 他のアプリがマイクを使用していない';

  @override
  String get recordingFailedNoAudioFile =>
      '録音に失敗しました - 音声ファイルは作成されませんでした。\n\n考えられる原因:\n1.マイクが接続されていません\n2. 音声入力が検出されませんでした\n3. Windows オーディオ設定の問題';

  @override
  String errorStartingRecordingDetails(String error) {
    return '記録開始エラー: $error';
  }

  @override
  String get openaiEmptyResponse => '選択した AI モデルは空の応答を返しました';

  @override
  String get tryDifferentModel => 'モデルセレクターから別のモデルを選択してみてください';

  @override
  String get modelMayNotBeSupported =>
      'このモデルはサポートされていない、またはお使いのアカウントでは利用できない可能性があります';

  @override
  String get reduceTextOrRetry => 'テキストの長さを減らすか、もう一度試してください';

  @override
  String get openaiNullContent => '選択した AI モデルはコンテンツを返しませんでした';

  @override
  String get modelUnsupportedParameter => '選択したモデルは必要な API パラメータをサポートしていません';
}
