// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get helloWorld => '你好世界！';

  @override
  String get welcome => '欢迎参加语言拉力赛';

  @override
  String get appTitle => '语言拉力赛';

  @override
  String get createPackage => '创建包';

  @override
  String get editPackage => '编辑包';

  @override
  String get packageDetails => '套餐详情';

  @override
  String get packageName => '封装名称';

  @override
  String get packageNameHint => '例如，西班牙语基础知识、德语基础知识';

  @override
  String get languageCode1 => '源语言代码';

  @override
  String get languageName1 => '源语言名称';

  @override
  String get languageCode2 => '目标语言代码';

  @override
  String get languageName2 => '目标语言名称';

  @override
  String get description => '描述';

  @override
  String get descriptionHint => '该语言包的简要说明';

  @override
  String get authorName => '作者姓名';

  @override
  String get authorEmail => '作者电子邮件';

  @override
  String get authorWebpage => '作者网页';

  @override
  String get version => '版本';

  @override
  String get items => '项目';

  @override
  String get packageIcon => '包图标';

  @override
  String get packageGroup => '套餐组';

  @override
  String get selectIcon => '选择图标';

  @override
  String get defaultIcon => '默认图标';

  @override
  String get customIcon => '自定义图标';

  @override
  String get upload => '上传图标';

  @override
  String get uploadCustomIcon => '上传自定义图标（最大 512x512，1MB）';

  @override
  String get customIconUploaded => '自定义图标上传成功';

  @override
  String get save => '节省';

  @override
  String get edit => '编辑';

  @override
  String get cancel => '取消';

  @override
  String get delete => '删除';

  @override
  String get confirmDelete => '您确定要删除这个包吗？';

  @override
  String get packageSaved => '包保存成功';

  @override
  String get packageDeleted => '包删除成功';

  @override
  String get errorSavingPackage => '保存包时出错';

  @override
  String get errorDeletingPackage => '删除包时出错';

  @override
  String get fieldRequired => '此字段是必需的';

  @override
  String get invalidEmail => '电子邮件地址无效';

  @override
  String get readOnlyPackage => '该包是只读的，无法编辑';

  @override
  String get purchasedPackage => '已购买的套餐无法编辑';

  @override
  String get badges => '徽章';

  @override
  String get noBadges => '尚未获得徽章';

  @override
  String get selectLanguageCode => '选择语言代码';

  @override
  String get typeToSearchLanguages => '输入搜索语言...';

  @override
  String get search => '搜索...';

  @override
  String get clearCounters => '清除计数器';

  @override
  String get confirmClearCounters => '您确定要清除此包的所有培训计数器吗？这将重置“不知道”计数器和训练统计数据。';

  @override
  String get clear => '清除';

  @override
  String get countersCleared => '计数器清零成功';

  @override
  String get errorClearingCounters => '清除计数器时出错';

  @override
  String get deleteAll => '删除包';

  @override
  String get confirmDeleteAllData =>
      '您确定要删除此包及其所有数据吗？这将永久删除所有类别、项目和培训统计数据。此操作无法撤消！';

  @override
  String get allDataDeleted => '包和所有数据已成功删除';

  @override
  String get exportPackage => '出口包装';

  @override
  String get selectExportLocation => '选择导出位置';

  @override
  String get packageExported => '包导出成功';

  @override
  String get errorExportingPackage => '导出包时出错';

  @override
  String get importItems => '导入项目 (JSON)';

  @override
  String get importItemsDialogTitle => '导入项目 (JSON)';

  @override
  String get importItemsFromLocalJson => '从本地 JSON 文件导入';

  @override
  String get enterItemsUrl => '项目 JSON URL (https://...)';

  @override
  String get downloadingItems => '正在下载项目...';

  @override
  String get selectImportFile => '选择导入文件';

  @override
  String get importFormat => '导入格式';

  @override
  String get importFormatDescription => '从文本文件导入项目。每行应包含以下格式的项目：';

  @override
  String get importResults => '导入结果';

  @override
  String get successfullyImported => '导入成功';

  @override
  String get failedToImport => '导入失败';

  @override
  String get error => '错误';

  @override
  String get ok => '好的';

  @override
  String get importPackage => '导入包';

  @override
  String get importPackageTooltip => '从 ZIP 文件或 URL 导入包';

  @override
  String get importPackageDialogTitle => '导入语言包';

  @override
  String get importFromLocalFile => '从本地文件导入';

  @override
  String get importFromUrl => '从 URL 导入';

  @override
  String get enterPackageUrl => '包 URL (https://...)';

  @override
  String get downloadingPackage => '正在下载包...';

  @override
  String get downloadFailed => '下载失败。请检查 URL 和您的互联网连接。';

  @override
  String get invalidUrl => '请输入有效的 http:// 或 https:// URL。';

  @override
  String get orLabel => '或者';

  @override
  String get selectPackageZipFile => '选择包 ZIP 文件';

  @override
  String get couldNotAccessFile => '无法访问所选文件。';

  @override
  String get importingPackage => '正在导入包...';

  @override
  String get packageImportedSuccessfully => '包导入成功！';

  @override
  String packageImportedWithItems(Object count) {
    return '包导入成功！ （$count 项）';
  }

  @override
  String packageImportedWithGroup(Object count, Object groupName) {
    return '包导入到“$groupName”组！ （$count 项）';
  }

  @override
  String get importError => '导入错误';

  @override
  String get failedToImportPackage => '导入包失败';

  @override
  String get packageAlreadyExists => '包已存在';

  @override
  String packageExistsMessage(Object groupName) {
    return '“$groupName”组中已存在具有相同语言对、描述、作者信息和版本的包。您仍然想将其作为新包导入吗？';
  }

  @override
  String get importAsNew => '无论如何导入';

  @override
  String get zipFileNotFound => '未找到 ZIP 文件';

  @override
  String get invalidPackageZip => '包 ZIP 无效：缺少 package_data.json';

  @override
  String get invalidPackageFormat => '包文件格式无效';

  @override
  String get languagePackages => '语言包';

  @override
  String get loadingPackages => '正在加载包...';

  @override
  String get tapAndHoldToReorder => '点击并按住可重新排序卡片';

  @override
  String get tapAndHoldToReorderList => '点击并按住 ≡ 重新排序 • 点击 ⋮ 切换紧凑视图';

  @override
  String get noPackagesYet => '还没有包裹';

  @override
  String get createFirstPackage => '创建您的第一个语言包';

  @override
  String get versionLabel => '版本';

  @override
  String get purchased => '已购买';

  @override
  String get compactView => '袖珍的';

  @override
  String get expand => '扩张';

  @override
  String get allCategories => '所有类别';

  @override
  String get categoriesInPackage => '此包中的类别';

  @override
  String get categories => '类别';

  @override
  String get testInterFonts => '测试 Inter 字体';

  @override
  String get viewPackages => '查看套餐';

  @override
  String get simplifiedPackageView => '包装清单';

  @override
  String get createNewPackage => '创建新包';

  @override
  String get generateTestData => '生成测试数据';

  @override
  String get designSystemShowcase => '设计系统展示';

  @override
  String get badgeEarned => '徽章已获得！';

  @override
  String get achievement => '成就';

  @override
  String get awesome => '惊人的！';

  @override
  String get importFormatNotes => '笔记：';

  @override
  String get importFormatLine1 => '• 每行代表一项';

  @override
  String get importFormatLine2 => '• 字段由| 分隔。';

  @override
  String get importFormatLine3 => '• 类别由; 分隔。';

  @override
  String get importFormatLine4 => '• 最后|是可选的';

  @override
  String get importFormatLine5 => '• 空行被忽略';

  @override
  String get importFormatLine6 => '• 跳过重复项';

  @override
  String get importFormatNewDescription => '从文本文件导入项目。每行应包含一个项目，其字段由 --- 分隔';

  @override
  String get importFormatNewLine1 => '• 主分隔符：---';

  @override
  String get importFormatNewLine2 => '• L1=<text> - 语言 1 主要文本（如果缺少 L2，则需要）';

  @override
  String get importFormatNewLine3 => '• L2=<text> - 语言 2 主要文本（如果缺少 L1，则需要）';

  @override
  String get importFormatNewLine4 => '• L1pre=<文本> - 语言 1 前缀（可选）';

  @override
  String get importFormatNewLine5 => '• L1post=<文本> - 语言 1 后缀（可选）';

  @override
  String get importFormatNewLine6 => '• L2pre=<文本> - 语言 2 前缀（可选）';

  @override
  String get importFormatNewLine7 => '• L2post=<文本> - 语言 2 后缀（可选）';

  @override
  String get importFormatNewLine8 => '• EX=<L1 文本>:::<L2 文本> - 示例（可选，可以是多个）';

  @override
  String get importFormatNewLine9 => '• CAT=<cat1>:::<cat2>:::<cat3> - 类别（可选）';

  @override
  String get importFormatNewLine10 => '• 必须至少存在L1= 或L2= 之一';

  @override
  String get importFormatNewLine11 => '• 空行被忽略';

  @override
  String get importFormatNewLine12 => '• 跳过重复项';

  @override
  String get invalidImportLine => '无效行';

  @override
  String get missingRequiredFields => '缺少“L1=”和迷幻的“L2=”';

  @override
  String get unknownField => '未知字段前缀';

  @override
  String andMore(Object count) {
    return '...以及 $count 更多';
  }

  @override
  String get browseItems => '浏览商品';

  @override
  String get itemDetails => '细节';

  @override
  String get filterItems => '过滤项目';

  @override
  String searchLanguage1(Object language) {
    return '在 $language 中搜索';
  }

  @override
  String searchLanguage2(Object language) {
    return '在 $language 中搜索';
  }

  @override
  String get caseSensitive => '区分大小写';

  @override
  String get knownStatus => '已知状态';

  @override
  String get filterStatusAll => '全部';

  @override
  String get filterStatusKnown => '已知的';

  @override
  String get filterStatusUnknown => '未知';

  @override
  String get allItems => '所有项目';

  @override
  String get itemsIKnew => '我所知道的项目';

  @override
  String get itemsIDidNotKnow => '我不知道的项目';

  @override
  String get known => '已知';

  @override
  String get unknown => '未知';

  @override
  String get important => '重要的';

  @override
  String get favourite => '最喜欢的';

  @override
  String get badge => '徽章';

  @override
  String get position => '位置';

  @override
  String get stepsUntilLearned => '直到学会为止的步骤';

  @override
  String get examples => '示例';

  @override
  String get noExamples => '没有可用的示例';

  @override
  String get pronounce => '发音';

  @override
  String get ttsError => '文本转语音不可用';

  @override
  String get noItemsFound => '没有找到物品';

  @override
  String get noItemsInPackage => '该包裹中还没有物品';

  @override
  String get addItem => '添加项目';

  @override
  String get emptyPackageHint => '手动添加物品或使用AI快速导入物品';

  @override
  String get noItemsToTrain => '当前设置没有可用于练习的项目';

  @override
  String get clearFilters => '清除';

  @override
  String itemCount(Object count) {
    return '$count 项目';
  }

  @override
  String filteredItemCount(Object filtered, Object total) {
    return '$filtered 项（共 $total 项）';
  }

  @override
  String get trainingRally => '训练拉力赛';

  @override
  String get startTraining => '开始训练';

  @override
  String get trainingComingSoon => '训练集会 - 即将推出！';

  @override
  String get aiServiceNotConfigured => 'AI服务未配置。请添加您的 OpenAI API 密钥。';

  @override
  String pleaseEnterTextInLanguageFirst(Object language) {
    return '请先在 $language 中输入文字';
  }

  @override
  String translationCompletedSuccessfully(Object service) {
    return '使用 $service 成功完成翻译！';
  }

  @override
  String get translationFailed => '翻译失败';

  @override
  String addedExamplesSuccessfully(Object count) {
    return '已成功添加 $count 示例！';
  }

  @override
  String get failedToGenerateExamples => '无法生成示例';

  @override
  String get selectExamplesToAdd => '选择要添加的示例';

  @override
  String get selectWhichExamples => '选择要添加到此项目的示例：';

  @override
  String get addSelected => '添加所选内容';

  @override
  String get pleaseSelectAtLeastOne => '请至少选择一个示例';

  @override
  String get addNewItem => '添加新项目';

  @override
  String get editItem => '编辑项目';

  @override
  String get deleteItem => '删除项目';

  @override
  String get confirmDeleteItem => '您确定要删除该项目吗？';

  @override
  String get thisActionCannotBeUndone => '此操作无法撤消。';

  @override
  String get itemDeleted => '项目已删除';

  @override
  String get errorDeletingItem => '删除项目时出错';

  @override
  String get errorSavingItem => '保存项目时出错';

  @override
  String get itemSaved => '项目更新成功';

  @override
  String get itemCreated => '项目创建成功';

  @override
  String get preTextOptional => '前置文本（可选）';

  @override
  String get mainText => '正文';

  @override
  String get postTextOptional => '后文（可选）';

  @override
  String get forExampleToForVerbs => '例如，动词“to”';

  @override
  String get additionalContext => '额外的背景信息';

  @override
  String get translate => '翻译';

  @override
  String translateFromTo(Object from, Object to) {
    return '翻译 $from → $to';
  }

  @override
  String get aiExampleGeneration => '人工智能示例生成';

  @override
  String get aiExampleSearch => '人工智能示例搜索';

  @override
  String searchExamplesOnInternet(Object text) {
    return '使用 AI 在互联网上搜索“$text”的例句';
  }

  @override
  String generateExampleSentences(Object language) {
    return '根据$language中的正文生成例句';
  }

  @override
  String get voiceInput => '语音输入';

  @override
  String get settings => '设置';

  @override
  String get uiLanguage => '用户界面语言';

  @override
  String get uiLanguageDescription => '应用程序界面语言';

  @override
  String get uiLanguageHelper => '选择菜单、按钮和标签的语言';

  @override
  String get userLanguage => '用户语言';

  @override
  String get userLanguageDescription => '您创建新语言包的首选母语';

  @override
  String get apiKeys => 'API 密钥';

  @override
  String get deeplApiKey => 'DeepL API 密钥';

  @override
  String get deeplApiKeyDescription =>
      '编辑语言项目时获得优质翻译质量。请参阅 https://www.deepl.com/pro-api';

  @override
  String get openaiApiKey => 'OpenAI API 密钥';

  @override
  String get openaiApiKeyDescription =>
      '例如，编辑语言项目时使用 AI 生成。请参阅 https://platform.openai.com/api-keys';

  @override
  String get enterApiKey => '输入 API 密钥';

  @override
  String get optional => '选修的';

  @override
  String get required => '必需的';

  @override
  String get settingsSaved => '设置保存成功';

  @override
  String get errorSavingSettings => '保存设置时出错';

  @override
  String get usingGoogleTranslate => '使用免费的谷歌翻译';

  @override
  String get usingDeepL => '使用 DeepL（高级）';

  @override
  String get noTranslationReceivedFromGoogle => '没有收到来自 Google 的翻译';

  @override
  String get googleTranslationFailed => '谷歌翻译失败';

  @override
  String get googleTranslationError => '谷歌翻译错误';

  @override
  String get noTranslationReceivedFromDeepL => '未收到 DeepL 的翻译';

  @override
  String get invalidDeepLApiKey => 'DeepL API 密钥无效';

  @override
  String get deeplTranslationQuotaExceeded => 'DeepL 翻译配额超出';

  @override
  String get deeplTranslationFailed => 'DeepL 翻译失败';

  @override
  String get deeplTranslationError => 'DeepL 翻译错误';

  @override
  String get invalidApiKeyConfigureOpenAI => 'API 密钥无效。请配置您的 OpenAI API 密钥。';

  @override
  String get apiRateLimitExceeded => '超出 API 速率限制。请稍后重试。';

  @override
  String get aiRequestFailed => 'AI请求失败';

  @override
  String get failedToParseAiResponse => '无法解析 AI 响应。请再试一次。';

  @override
  String get aiGenerationError => 'AI生成错误';

  @override
  String get voiceInputPlaceholder => '语音输入将使用speech_to_text包来实现';

  @override
  String get improveQualityWithApiKeys =>
      '💡 提示：通过在应用程序设置中添加 DeepL 和 OpenAI API 密钥，可以显着提高翻译和示例搜索的质量。';

  @override
  String get noApiKeyFallbackMessage =>
      '如果没有 API 密钥，则提供基本翻译和有限示例。为了获得最佳结果，请在“设置”中配置您的 API 密钥。';

  @override
  String get listeningForSpeech => '正在听……现在说话';

  @override
  String get speechRecognitionNotAvailable => '此设备不支持语音识别';

  @override
  String get speechRecognitionPermissionDenied => '语音识别权限被拒绝';

  @override
  String get speechRecognitionError => '语音识别错误';

  @override
  String get tapToSpeak => '点击麦克风即可说话';

  @override
  String get tapToStop => '点击停止录音';

  @override
  String get speechNotRecognized => '没有语音被识别。请再试一次。';

  @override
  String get usingWhisperApiSlower => '使用云AI进行语音识别（可能会慢一些）';

  @override
  String languageNotSupportedAddApiKey(String languageCode) {
    return '本机不支持语言 $languageCode。在“设置”中添加 OpenAI API 密钥，以实现 AI 驱动的语音识别。';
  }

  @override
  String get recordingTapToStop => '正在录音...再次点击即可停止';

  @override
  String get speakClearlyKeepRecording => '说清楚。记录至少 1 秒。';

  @override
  String get pleaseRecordLonger => '请讲话至少 1 秒，然后点击停止。';

  @override
  String get errorStartingRecording => '开始录制时出错';

  @override
  String get noAudioRecorded => '没有录制任何音频';

  @override
  String get errorTranscribing => '转录音频时出错';

  @override
  String get trainingSettings => '训练设置';

  @override
  String get trainingPresetTitle => '快速设置';

  @override
  String get trainingPresetHint => '选择一个预设，下面的设置将自动配置。';

  @override
  String get trainingPresetComboLabel => '预设';

  @override
  String get trainingPresetAllExamplesForeignLanguage => '所有示例，外语';

  @override
  String get trainingPresetAllExamplesRandomLanguage => '所有示例，随机语言';

  @override
  String get trainingPresetFavouriteItemsForeignLanguage => '最喜欢的物品，外语';

  @override
  String get trainingPresetFavouriteItemsRandomLanguage => '最喜欢的项目，随机语言';

  @override
  String get trainingPresetImportantItemsForeignLanguage => '重要事项，外语';

  @override
  String get trainingPresetImportantItemsRandomLanguage => '重要事项、随机语言';

  @override
  String get trainingPresetRandomItemsRandomLanguage => '随机物品，随机语言';

  @override
  String get trainingPresetUnknownItemsForeignLanguage => '未知项目，外语';

  @override
  String get trainingPresetUnknownItemsRandomLanguage => '未知项目、随机语言';

  @override
  String trainingPresetAppliedTapStart(String actionLabel) {
    return '应用预设。点击“$actionLabel”开始。';
  }

  @override
  String get trainingPresetSelectPackageFirst => '请先选择套餐。';

  @override
  String get itemScope => '项目范围';

  @override
  String get lastNItems => '最后 N 项';

  @override
  String get onlyUnknown => '只有未知的物品';

  @override
  String get onlyImportant => '仅重要项目';

  @override
  String get onlyFavourite => '只收藏最喜欢的物品';

  @override
  String get numberOfItems => '商品数量';

  @override
  String get itemOrder => '商品订单';

  @override
  String get randomOrder => '随机顺序';

  @override
  String get sequentialOrder => '顺序';

  @override
  String get itemType => '项目类型';

  @override
  String get dictionaryItems => '词典项目';

  @override
  String get examplesType => '示例';

  @override
  String get displayLanguage => '显示语言';

  @override
  String get motherTongue => '母语';

  @override
  String get targetLanguage => '目标语言';

  @override
  String get randomLanguage => '随机的';

  @override
  String get categoryFilter => '类别过滤器';

  @override
  String get categoryFilterHint => '选择要包含的类别（空=所有类别）';

  @override
  String get noCategories => '没有可用的类别';

  @override
  String get dontKnowThreshold => '不知道门槛';

  @override
  String get dontKnowThresholdHint => '在特殊处理之前需要将项目标记为“不知道”的次数';

  @override
  String get startTrainingRally => '开始训练拉力赛';

  @override
  String get clearTrainingSettings => '清除设置';

  @override
  String get confirmClearTrainingSettings => '您确定要将所有训练设置重置为默认值吗？';

  @override
  String get trainingSettingsCleared => '训练设置已被清除';

  @override
  String get startingTraining => '开始训练...';

  @override
  String get noMoreItemsToDisplay => '根据您的过滤器设置，没有可显示的项目。';

  @override
  String get noItems => '没有商品';

  @override
  String get trainingComplete => '培训完成';

  @override
  String get allItemsCompleted => '恭喜！您已完成本次培训课程中的所有项目。';

  @override
  String get closeTraining => '近距离训练';

  @override
  String get confirmCloseTraining => '您确定要结束培训吗？您的进度已保存。';

  @override
  String get question => '问题';

  @override
  String get answer => '回答';

  @override
  String get iKnow => '我知道';

  @override
  String get iDontKnow => '我不知道';

  @override
  String get previousItem => '上一个项目';

  @override
  String get iDidNotKnowEither => '我毕竟不知道';

  @override
  String get exportBeforeDelete => '先导出再删除？';

  @override
  String get aiTextAnalysis => '使用 AI 从文本/列表中提取项目';

  @override
  String get aiTextAnalysisImport => '使用 AI 文本分析工具从文本或列表中提取项目';

  @override
  String get knowledgeLevel => '知识水平';

  @override
  String get a1Beginner => 'A1 - 初级';

  @override
  String get a2Elementary => 'A2 - 初级';

  @override
  String get b1Intermediate => 'B1 - 中级';

  @override
  String get b2UpperIntermediate => 'B2 - 中高级';

  @override
  String get c1Advanced => 'C1 - 高级';

  @override
  String get c2Proficient => 'C2 - 精通';

  @override
  String get pasteTextHere => '将您的文字粘贴到此处...';

  @override
  String get extractWords => '提取单词';

  @override
  String get extractExpressions => '提取表达式';

  @override
  String get maxItems => '最大新商品数';

  @override
  String get maxItemsHint => '留空则无限制';

  @override
  String get generateExamples => '生成示例';

  @override
  String get categoryName => '类别名称';

  @override
  String get categoryNameHint => '进口商品类别名称';

  @override
  String get analyzeText => '分析文本';

  @override
  String get configureAnalysis => '配置要提取的项目';

  @override
  String get openaiModel => '人工智能模型';

  @override
  String get openaiModelDescription => '选择ChatGPT型号';

  @override
  String get modelGpt55 => 'GPT-5.5';

  @override
  String get modelGpt55Pro => 'GPT-5.5专业版';

  @override
  String get modelGpt54 => 'GPT-5.4';

  @override
  String get modelGpt54Pro => 'GPT-5.4 专业版';

  @override
  String get modelGpt54Mini => 'GPT-5.4迷你型';

  @override
  String get modelGpt5Mini => 'GPT-5迷你型';

  @override
  String get modelGpt41 => 'GPT-4.1';

  @override
  String get modelGpt55Desc => '质量与速度平衡的最新旗舰产品，适合一般用途';

  @override
  String get modelGpt55ProDesc => '最高端的 GPT-5.5 变体，具有最强的推理能力和质量';

  @override
  String get modelGpt54Desc => '强通用型GPT-5代型号';

  @override
  String get modelGpt54ProDesc => '适用于高要求任务的高性能 GPT-5.4 变体';

  @override
  String get modelGpt54MiniDesc => '更小、更快的 GPT-5.4 变体，适用于成本更低的日常任务';

  @override
  String get modelGpt5MiniDesc => '紧凑型 GPT-5 系列型号针对速度和成本进行了优化';

  @override
  String get modelGpt41Desc => '可靠的 GPT-4.1 选项，具有兼容性和稳定的质量';

  @override
  String get modelGpt4o => 'GPT-4o';

  @override
  String get modelGpt35Turbo => 'GPT-3.5 Turbo（传统型，预算型）';

  @override
  String get modelGpt35Turbo16k => 'GPT-3.5涡轮16K';

  @override
  String get modelGpt4 => 'GPT-4';

  @override
  String get modelGpt4Turbo => 'GPT-4 Turbo（旧版）';

  @override
  String get modelGpt4oDesc => '最佳通用选择；快速、多式联运、质量过硬';

  @override
  String get modelGpt35TurboDesc => '传统的低成本选项；对于更简单的任务和成本敏感的使用很有用';

  @override
  String get modelGpt35Turbo16kDesc => '与 GPT-3.5 相同，但 16K 令牌上下文窗口';

  @override
  String get modelGpt4Desc => '推理质量高；通常更慢且更昂贵';

  @override
  String get modelGpt4TurboDesc => '旧版 GPT-4 系列选项；当您想要更旧的更便宜的替代品时仍然有用';

  @override
  String get analyzing => '正在分析...';

  @override
  String get languageDetected => '检测到语言';

  @override
  String get itemsFound => '找到的物品';

  @override
  String get selectItemsToImport => '选择要导入的项目';

  @override
  String get selectAll => '选择全部';

  @override
  String get deselectAll => '取消全选';

  @override
  String get importSelected => '导入所选内容';

  @override
  String get importing => '输入...';

  @override
  String get itemsImported => '项目导入成功';

  @override
  String get noItemsSelected => '没有选择任何项目';

  @override
  String get textCannotBeEmpty => '文字不能为空';

  @override
  String get selectAtLeastOneType => '选择至少一种类型（单词或表达方式）';

  @override
  String get languageNotMatching => '检测到的语言与包中的任何语言都不匹配';

  @override
  String get openaiKeyRequired => '此功能需要 OpenAI API 密钥';

  @override
  String analyzingProgress(Object current, Object total) {
    return '分析：$current / $total';
  }

  @override
  String translatingProgress(Object current, Object total) {
    return '翻译：$current / $total';
  }

  @override
  String get duplicate => '复制';

  @override
  String importProgress(Object current, Object total) {
    return '导入 $total 的 $current';
  }

  @override
  String get detectingLanguage => '检测语言...';

  @override
  String get extractingItems => '正在提取项目...';

  @override
  String get checkingDuplicates => '检查重复项...';

  @override
  String get translating => '翻译...';

  @override
  String get generatingExamples => '生成示例...';

  @override
  String get errorAnalyzingText => '分析文本时出错';

  @override
  String get errorImportingItems => '导入项目时出错';

  @override
  String get warning => '警告';

  @override
  String get textIsVeryLarge => '文字很大';

  @override
  String get words => '字';

  @override
  String get continueAnalysis => '这可能需要更长的时间来处理，并且将分块进行分析。你想继续吗';

  @override
  String get continueLabel => '继续';

  @override
  String get exportBeforeDeleteMessage => '您想在删除此包之前导出它吗？这会将您的所有数据保存到 ZIP 文件中。';

  @override
  String get deleteWithoutExport => '删除而不导出';

  @override
  String get exportAndDelete => '导出和删除';

  @override
  String get exportingPackage => '正在导出包...';

  @override
  String packageExportedToPath(Object path) {
    return '包导出到：$path';
  }

  @override
  String errorLoadingItems(Object error) {
    return '加载项目时出错：$error';
  }

  @override
  String badgeEarnedWithName(Object badgeName) {
    return '获得徽章：$badgeName！';
  }

  @override
  String badgeLostWithName(Object badgeName) {
    return '徽章丢失：$badgeName';
  }

  @override
  String get trainingSessionProgress => '培训课程统计';

  @override
  String get total => '全部的';

  @override
  String lastNValue(Object value) {
    return 'N = $value';
  }

  @override
  String errorLoadingSettings(Object error) {
    return '加载设置时出错：$error';
  }

  @override
  String get selectPackage => '选择套餐';

  @override
  String get noPackagesAvailable => '没有可用的套餐';

  @override
  String get possibleSolutions => '可能的解决方案';

  @override
  String get technicalDetails => '技术细节';

  @override
  String get close => '关闭';

  @override
  String get checkApiKey => '检查您的 OpenAI API 密钥';

  @override
  String get ensureValidOpenAIKey => '确保 API 密钥有效且处于活动状态';

  @override
  String get verifyKeyInSettings => '验证设置中的密钥';

  @override
  String get rateLimitExceeded => '超出 API 速率限制';

  @override
  String get waitAndRetry => '等待几分钟，然后重试';

  @override
  String get checkAccountQuota => '检查您的 OpenAI 账户配额';

  @override
  String get invalidRequest => '请求格式无效';

  @override
  String get tryReducingTextLength => '尝试减少文本长度';

  @override
  String get checkTextFormat => '检查文本格式是否正确';

  @override
  String get checkInternetConnection => '检查您的互联网连接';

  @override
  String get retryInMoment => '稍后重试';

  @override
  String get checkFirewall => '检查防火墙设置';

  @override
  String get textMayBeTooShort => '文字可能太短';

  @override
  String get tryDifferentKnowledgeLevel => '尝试不同的知识水平';

  @override
  String get ensureTextInCorrectLanguage => '确保文本使用正确的语言';

  @override
  String get requestTimedOut => '请求超时';

  @override
  String get textMayBeTooLong => '文字可能太长';

  @override
  String get tryAgainOrReduceSize => '再试一次或减小文字大小';

  @override
  String get unexpectedError => '发生意外错误';

  @override
  String get checkErrorDetails => '检查下面的错误详细信息';

  @override
  String get tryAgainLater => '稍后再试';

  @override
  String get translationServiceFailed => '翻译服务失败';

  @override
  String get checkApiKeys => '检查您的 API 密钥（DeepL、OpenAI）';

  @override
  String get retryImport => '重试导入';

  @override
  String get exampleGenerationFailed => '示例生成失败';

  @override
  String get itemsStillImported => '物品仍然进口';

  @override
  String get canAddExamplesManually => '您可以稍后手动添加示例';

  @override
  String get databaseError => '数据库发生错误';

  @override
  String get checkStorageSpace => '检查可用存储空间';

  @override
  String get restartApp => '尝试重新启动应用程序';

  @override
  String get groupLabel => '团体：';

  @override
  String get amendGroups => '修正';

  @override
  String get exportItemsJson => '导出项目 (JSON)';

  @override
  String get exportItemsJsonTooltip => '将所有项目导出为 JSON 文件';

  @override
  String get noCategoriesInPackage => '在此包中找不到类别';

  @override
  String get noItemsToExport => '未找到可导出的项目';

  @override
  String itemsExportedSuccessfully(int count, String path) {
    return '已成功将 $count 项目导出到：\n$path';
  }

  @override
  String get errorExportingItems => '导出项目时出错';

  @override
  String get languageMismatch => '语言不匹配';

  @override
  String get languageMismatchDescription => 'JSON 文件中的语言与包语言不匹配：';

  @override
  String packageLanguages(String lang1, String lang2) {
    return '封装：$lang1 → $lang2';
  }

  @override
  String jsonFileLanguages(String lang1, String lang2) {
    return 'JSON 文件：$lang1 → $lang2';
  }

  @override
  String get continueImportQuestion => '您还想继续导入吗？';

  @override
  String get continueImport => '继续导入';

  @override
  String get pleaseSelectPackageGroup => '请选择套餐组';

  @override
  String get customIconLabel => '风俗';

  @override
  String get defaultIconLabel => '默认';

  @override
  String get icon2Label => '打开书本';

  @override
  String get icon3Label => '彩色书';

  @override
  String get icon4Label => '对话';

  @override
  String get icon5Label => '毕业';

  @override
  String get icon6Label => '脑';

  @override
  String get icon7Label => '书架';

  @override
  String get icon8Label => '抽认卡';

  @override
  String get icon9Label => '地球';

  @override
  String get icon10Label => '铅笔';

  @override
  String get icon11Label => '杯';

  @override
  String get icon12Label => '搜索';

  @override
  String get customIconFile => '自定义图标';

  @override
  String get importedIconFile => '导入的图标';

  @override
  String get unableToReadImageFile => '无法读取图像文件。请选择有效的图像。';

  @override
  String iconDimensionsTooLarge(int width, int height) {
    return '图标尺寸太大 (${width}x$height)。允许的最大尺寸为 512x512 像素。';
  }

  @override
  String get iconFileTooLarge => '图标文件太大。最大大小为 1MB。';

  @override
  String failedToUploadIcon(String error) {
    return '上传图标失败：$error';
  }

  @override
  String get pleaseSelectValidLanguage => '请从列表中选择有效的语言';

  @override
  String get status => '地位';

  @override
  String get addExample => '添加示例';

  @override
  String get noExamplesYet => '还没有例子。单击+进行添加。';

  @override
  String get speakText => '讲文字';

  @override
  String get removeCategory => '删除类别';

  @override
  String removeCategoryConfirm(String categoryName) {
    return '从此项目中删除类别“$categoryName”吗？';
  }

  @override
  String get remove => '消除';

  @override
  String get extractFullItems => '提取完整项目';

  @override
  String get pasteFromClipboard => '从剪贴板粘贴';

  @override
  String get noItemsFoundOrAllDuplicates => '文本中未找到任何项目，或包中已存在所有项目';

  @override
  String get aboutLanguageRally => '关于语言拉力赛';

  @override
  String get welcomeTitle => '🚀 欢迎参加语言拉力赛';

  @override
  String get welcomeSubtitle =>
      '通过大约 4,000 个单词、4,000 个表达方式和同样多的例句来释放语言学习的不可思议的力量——针对每个熟练程度精心策划！使用 AI 从您自己的文本中导入项目，或与 AI 就任何主题进行聊天，以生成您想要学习的确切单词、表达方式和示例。\n提高您的语言技能——以聪明而有趣的方式！';

  @override
  String get welcomeIntro => '通过练习您真正关心的内容来有效地学习词汇和表达。没有无聊的清单。没有浪费时间。';

  @override
  String get sectionPlayYourGame => '🎮 玩你自己的游戏';

  @override
  String get sectionPlayYourGameDesc =>
      '创建您自己的词汇包。只训练您想要掌握的单词和表达方式。已经知道了吗？它将被标记并跳过！';

  @override
  String get sectionAITeammate => '🤖 AI 作为你的队友';

  @override
  String get sectionAITeammateDesc =>
      '粘贴任意文本并让 AI：\n• 提取有用的词汇\n• 选择符合您水平的表达方式\n• 在几秒钟内构建可立即训练的包\n\n与AI聊天：\n• 让它为您的主题建议单词和表达方式\n• 单击生成示例并将其保存到您自己的包中';

  @override
  String get sectionTrainSmart => '🔁 智能训练';

  @override
  String get sectionTrainSmartDesc =>
      '我们经过微调的重复系统会在您的大脑需要时准确地显示项目，以便有效地记住它们。最大进度。最小的努力。';

  @override
  String get sectionRealExamples => '🌍真实例子。很棒的翻译。';

  @override
  String get sectionRealExamplesDesc =>
      '获取真实世界的使用示例。通过 DeepL 进行优质翻译。练习发音并听起来自信。';

  @override
  String get sectionTeachersWelcome => '👩‍🏫欢迎老师们';

  @override
  String get sectionTeachersWelcomeDesc =>
      '创建包 → 复制和粘贴项目或使用 AI 提取、翻译、添加示例 → 导出 → 上传/发送 → 完成。您的学生导入它并立即开始练习。';

  @override
  String get sectionUnlockAI => '🔑 释放全部人工智能力量';

  @override
  String get sectionUnlockAIDesc =>
      '要获得高质量翻译和 AI 功能，只需：\n\n1. 创建您的 DeepL API 密钥\n   https://www.deepl.com/pro-api\n2. 创建您的 OpenAI API 密钥\n   https://platform.openai.com/api-keys\n3. 将两个密钥粘贴到“设置”中\n\n少量投资即可解锁强大的专业级语言工具。您为什么会错过呢？\n（我们建议使用付费 API 访问以获得最佳结果。）';

  @override
  String get readyToStart => '准备好开始你的集会了吗？ 🏁';

  @override
  String get welcomeDescription =>
      'Language Rally 是您全面的语言学习伴侣。创建自定义词汇包，按类别组织项目，并使用智能间隔重复系统进行训练。';

  @override
  String get browseStore => '浏览商店';

  @override
  String get featureInteractiveTraining => '互动培训';

  @override
  String get featureInteractiveTrainingDesc => '练习自适应学习算法';

  @override
  String get featureSmartOrganization => '智能组织';

  @override
  String get featureSmartOrganizationDesc => '对词汇进行分类和过滤';

  @override
  String get featureTrackProgress => '追踪进度';

  @override
  String get featureTrackProgressDesc => '通过详细的统计数据监控您的学习情况';

  @override
  String get featureImportExport => '进出口';

  @override
  String get featureImportExportDesc => '共享包并跨设备同步';

  @override
  String get startAppTour => '开始应用之旅';

  @override
  String get quickStartGuide => '快速入门指南';

  @override
  String get tourStep1Title => '创建或导入包';

  @override
  String get tourStep1Desc => '首先创建一个新的语言包或从文件导入现有语言包。';

  @override
  String get tourStep2Title => '添加词汇项';

  @override
  String get tourStep2Desc => '浏览您的包并添加带有示例和类别的单词、短语或表达式。';

  @override
  String get tourStep3Title => '配置训练';

  @override
  String get tourStep3Desc => '选择要练习的项目、设置难度级别并定制您的学习体验。';

  @override
  String get tourStep4Title => '开始学习';

  @override
  String get tourStep4Desc => '开始训练并将项目标记为已知或未知以跟踪您的进度。';

  @override
  String get tourStep5Title => '回顾统计数据';

  @override
  String get tourStep5Desc => '通过详细的统计数据和成就徽章检查您的学习进度。';

  @override
  String get gotIt => '知道了！';

  @override
  String get appTourTitle => '欢迎参加语言拉力赛';

  @override
  String get appTourSubtitle => '您聪明、有趣且完全个性化的语言学习伴侣。';

  @override
  String get tourPage1Title => '学习和实践您想要和需要的内容';

  @override
  String get tourPage1Desc =>
      '我们的自适应学习系统可确保您在完美的时刻复习项目 - 最大限度地提高记忆力并最大限度地减少工作量。\n\n在内置自动化的帮助下学习。\n不要把时间浪费在你已经知道的单词上。\n\n只练习您感兴趣的词汇和表达方式。创建和训练您自己的项目 - 完全根据您的目标和水平量身定制。';

  @override
  String get tourPage2Title => '创建您自己的语言包';

  @override
  String get tourPage2Desc =>
      '构建符合您的兴趣和学习目标的个性化词汇库。\n\n按主题、难度或上下文组织单词和表达。\n\n完全控制您学习的内容和时间。';

  @override
  String get tourPage3Title => '人工智能支持的物品创建';

  @override
  String get tourPage3Desc =>
      '瞬间构建您自己的学习包：\n\n• 粘贴任意文本，让 AI 自动提取相关词汇\n• 找出最适合您水平的单词和表达方式\n• 让人工智能为您翻译\n• 让人工智能搜索实时示例\n\n与AI聊天：\n• 让它为您的主题建议单词和表达方式\n• 单击生成示例并将其保存到您自己的包中\n• 快速创建准备培训的包';

  @override
  String get tourPage4Title => '人工智能驱动的真实示例和优质翻译';

  @override
  String get tourPage4Desc =>
      '• 即时搜索真实的使用示例\n• 通过高质量 DeepL 集成翻译单词、表达方式和完整句子\n• 获得准确、情境感知的结果';

  @override
  String get tourPage5Title => '智能包装组织';

  @override
  String get tourPage5Desc =>
      '• 将词汇组织成自定义类别\n• 过滤并关注特定主题\n• 跨设备导入和导出包\n• 与他人轻松共享包';

  @override
  String get tourPage6Title => '训练你的发音';

  @override
  String get tourPage6Desc => '使用交互式练习工具测试和提高您的发音。\n\n建立口语的信心——而不仅仅是阅读。';

  @override
  String get tourPage7Title => '对于教师';

  @override
  String get tourPage7Desc =>
      '只需点击几下即可为您的学生创建即用型词汇包。\n\n将它们导出，发送到您的班级 - 一旦导入，它们就可以立即在每个学生的设备上进行练习。\n\n简单的。快速地。有效的。';

  @override
  String get tourPage8Title => '解锁高质量的人工智能支持';

  @override
  String get tourPage8Desc =>
      '要获得优质翻译和高级 AI 功能，只需：\n 1. 创建您自己的 DeepL API 密钥\n 2. 创建您自己的 OpenAI API 密钥\n 3. 将两个密钥粘贴到“设置”部分\n\n这仅需要很少的预算（几美元），但可以让您获得强大的、专业级的语言工具。\n注意：我们建议使用付费 API 访问以获得最佳结果。只需几美元。\n\n🔑 DeepL API 密钥：https://www.deepl.com/pro-api\n\n🔑 OpenAI API 密钥：https://platform.openai.com/api-keys';

  @override
  String get previousPage => '以前的';

  @override
  String get nextPage => '下一个';

  @override
  String get endTour => '结束游览';

  @override
  String pageIndicator(int current, int total) {
    return '第 $current 页（共 $total）';
  }

  @override
  String get practicePronunciation => '练习发音';

  @override
  String get pronunciationPractice => '发音练习';

  @override
  String get startPractice => '开始练习';

  @override
  String get listenToPronunciation => '听发音';

  @override
  String get tapToRecord => '点击即可录音';

  @override
  String get recording => '记录...';

  @override
  String get recorded => '已录制';

  @override
  String get speakNow => '现在说话 - 靠近麦克风清晰说话';

  @override
  String get noSpeechDetected => '未检测到语音。请再试一次。';

  @override
  String get noTextRecognized => '录音中没有识别出任何语音。请确保您的麦克风正常工作，然后重试。';

  @override
  String get processingAudio => '使用 AI 处理音频...';

  @override
  String get playbackRecording => '播放我的录音';

  @override
  String get playbackRecordingSubtitle => '在人工智能处理录音的同时聆听您的录音';

  @override
  String get recordingTooShort => '录音太短。请发言至少 1 秒钟。';

  @override
  String get microphonePermissionRequired => '发音练习需要麦克风许可';

  @override
  String get speechRecognitionNotSupported =>
      '该平台不支持语音识别。请使用移动应用程序（Android/iOS）进行发音练习。';

  @override
  String get speechRecognitionUnavailable => '此设备不支持语音识别。';

  @override
  String get pronunciationAccuracy => '发音\n准确度';

  @override
  String get excellent => '出色的！';

  @override
  String get good => '好的';

  @override
  String get fair => '公平的';

  @override
  String get needsImprovement => '需要改进';

  @override
  String get tryAgain => '再试一次';

  @override
  String get nextItem => '下一个项目';

  @override
  String get endPractice => '结束练习';

  @override
  String get practiced => '练习过';

  @override
  String get windowsAudioTestPageTitle => 'Windows 音频测试 (RTAudio)';

  @override
  String get configureWindowsAudio => '测试和配置音频\n在 Windows 上输入';

  @override
  String get configureWindowsAudioDescription =>
      '使用本机 Windows RTAudio 驱动程序录制、播放和转录音频';

  @override
  String get audioTestTitle => 'Windows 录音测试';

  @override
  String get audioTestSubtitle => 'RTAudio — 本机 Windows 音频录制';

  @override
  String get audioInputDevice => '音频输入设备';

  @override
  String get selectMicrophone => '选择麦克风';

  @override
  String get refreshDevices => '刷新设备';

  @override
  String get noAudioDevicesFound => '未找到音频输入设备';

  @override
  String get loadingAudioDevices => '正在加载音频设备...';

  @override
  String get recordingSettings => '录音设置';

  @override
  String get stereoRecording => '立体声录音';

  @override
  String get stereoChannels => '2 通道（立体声）';

  @override
  String get monoChannel => '1 通道（单声道）';

  @override
  String get sampleRateLabel => '采样率';

  @override
  String get nativeRateBadge => '本国的';

  @override
  String get microphoneGainLabel => '麦克风增益';

  @override
  String get gainHint => '1x = 无增强 • 3x ≈ +9.5 dB • 10x ≈ +20 dB';

  @override
  String get tapToStartRec => '点击开始录音';

  @override
  String get tapToStopRec => '点击停止录音';

  @override
  String get recordingCompleteLabel => '录音完成';

  @override
  String get tapMicToStop => '点击麦克风即可停止';

  @override
  String get playRecordingLabel => '播放录音';

  @override
  String get stopPlaybackLabel => '停止';

  @override
  String get whisperSectionTitle => 'OpenAI 耳语转录';

  @override
  String get whisperWavNote => 'Whisper 原生支持 WAV（16 位 PCM）——无需转换。';

  @override
  String get sendToWhisperLabel => '发送至 耳语';

  @override
  String get transcribingLabel => '正在抄写...';

  @override
  String get transcriptionResultLabel => '转录结果';

  @override
  String get transcriptionFailedLabel => '转录失败';

  @override
  String get debugInformationLabel => '信息';

  @override
  String get debugConsoleHint => '检查控制台的详细日志';

  @override
  String get debugDevicesFound => '找到设备';

  @override
  String get debugSelectedDevice => '选定的设备';

  @override
  String get debugDeviceRateNative => '设备速率（本机）';

  @override
  String get debugRequestedRate => '要求的价格';

  @override
  String get debugActualRate => '实际使用率';

  @override
  String get debugActualRateForced => '⚠ 被迫';

  @override
  String get debugActualRateOk => '✓';

  @override
  String get debugRecordingMode => '录音模式';

  @override
  String get debugLastRecording => '最后录音';

  @override
  String get debugFileSize => '文件大小';

  @override
  String get debugStereo => '立体声';

  @override
  String get debugMono => '单核细胞增多症';

  @override
  String get recordingSavedSnack => '录音已保存';

  @override
  String get recordingTooShortSnack => '录音时间太短。请录制至少 1 秒。';

  @override
  String get recordingSmallSnack => '录音文件很小。录音可能失败。';

  @override
  String get noAudioDataSnack => '没有记录音频数据';

  @override
  String get noDeviceSelectedSnack => '请选择音频设备';

  @override
  String get failedToInitRtAudio => '初始化 RTAudio 失败';

  @override
  String get envelopeScoreLabel => '信封';

  @override
  String get rhythmScoreLabel => '韵律';

  @override
  String get textScoreLabel => '文本';

  @override
  String get help => '帮助';

  @override
  String get trainingHelpTitle => '培训技巧';

  @override
  String get trainingHelpText =>
      '为了使您的培训尽可能有效，请按照下列步骤操作：\n1. 单击“清除计数器”按钮，以便该包中的所有项目都标记为已知。\n2. 将“项目范围”设置为“所有项目”\n3. 将“项目顺序”设置为“随机”\n4. 在“显示语言”下选择您的母语\n5. 开始训练并继续，直到您识别出大约 20-30 个您不知道的项目。\n6.返回训练设置并将“项目范围”更改为“仅未知项目”\n7. 恢复训练并继续，直到您学会了所有以前未知的项目。';

  @override
  String get trainingProTip => '专业提示：从所有项目开始；之后，只关注未知数。';

  @override
  String get onboardingWelcomeTitle => '欢迎来到语言拉力赛！';

  @override
  String get onboardingSetupSubtitle => '让我们为您设置该应用程序。';

  @override
  String get onboardingSelectUiLanguage => '界面语言';

  @override
  String get onboardingUiLanguageNote => '您可以稍后在“设置”→“用户界面语言”中更改此设置。';

  @override
  String get onboardingNext => '下一个';

  @override
  String get onboardingBack => '后退';

  @override
  String get onboardingSelectPackagesTitle => '选择语言包';

  @override
  String get onboardingSelectPackagesSubtitle =>
      '选择要导入的词汇包。您以后随时可以从主菜单（查看包）添加更多内容。';

  @override
  String get onboardingAnalyzingPackages => '正在分析可用的包...';

  @override
  String onboardingScanningPackagesProgress(
    int scanned,
    int total,
    int alreadyInDb,
  ) {
    return '已扫描 $scanned/$total • 已在数据库 $alreadyInDb 中';
  }

  @override
  String get onboardingImportSelected => '导入所选内容';

  @override
  String get onboardingSkipImport => '跳过';

  @override
  String get onboardingSelectAll => '选择全部';

  @override
  String get onboardingDeselectAll => '取消全选';

  @override
  String onboardingNPackages(int count) {
    return '$count 包';
  }

  @override
  String get onboardingGetStarted => '开始使用';

  @override
  String get onboardingImportCompleteTitle => '导入完成！';

  @override
  String get importBuiltInPkg => '免费套餐';

  @override
  String get importBuiltInPkgTooltip => '导入免费捆绑语言包';

  @override
  String get globalSearch => '全球搜索';

  @override
  String get globalSearchTitle => '搜索所有包';

  @override
  String get globalSearchSelectLanguage => '选择语言代码';

  @override
  String get globalSearchEnterWord => '要搜索的单词';

  @override
  String get globalSearchEnterWordHint => '例如\"der\", \"order\" — 查找部分匹配';

  @override
  String get globalSearchButton => '搜索';

  @override
  String get globalSearchResults => '结果';

  @override
  String globalSearchNoResults(String query) {
    return '未找到“$query”的结果';
  }

  @override
  String globalSearchResultsCount(int count) {
    return '找到 $count 结果';
  }

  @override
  String get globalSearchSearching => '正在寻找...';

  @override
  String get globalSearchSelectLanguageFirst => '请先选择语言代码';

  @override
  String get globalSearchEnterTermFirst => '请输入搜索词';

  @override
  String get globalSearchMatchInExamples => '在示例中找到';

  @override
  String get globalSearchViewItem => '看法';

  @override
  String get globalSearchGoToPackage => '前往套餐';

  @override
  String get globalSearchLoadingPackages => '正在加载包...';

  @override
  String get globalSearchNoPackages => '尚未安装语言包';

  @override
  String get globalSearchCancelSearch => '取消搜索';

  @override
  String globalSearchProgressOf(int current, int total) {
    return '正在搜索 $total 的包 $current...';
  }

  @override
  String globalSearchCancelledMessage(int count) {
    return '搜索已取消 — 目前已找到 $count 个结果';
  }

  @override
  String get storeTitle => '语言包商店';

  @override
  String get storeRestorePurchases => '恢复购买';

  @override
  String get storeRefresh => '刷新';

  @override
  String get storeSearchHint => '搜索包...';

  @override
  String get storeNoPackagesMatchSearch => '没有与您的搜索匹配的软件包。';

  @override
  String get storeNoPackagesAvailable => '没有可用的包。';

  @override
  String storeInstalledCount(int installed, int total) {
    return '已安装 $installed / $total';
  }

  @override
  String get storeLoadErrorTitle => '无法加载商店。';

  @override
  String get storeIapNotAvailableMessage => '此平台不支持应用内购买。请访问我们的网站购买套餐。';

  @override
  String get storeOpenWebsite => '打开网站';

  @override
  String storePurchaseSuccess(String title) {
    return '$title 安装成功！';
  }

  @override
  String get storePurchaseCancelled => '购买已取消。';

  @override
  String storePurchaseAlreadyOwned(String title) {
    return '$title 已安装。';
  }

  @override
  String get storePurchaseError => '出了点问题。请再试一次。';

  @override
  String get storePurchasesRestored => '恢复购买';

  @override
  String get storeAllLevels => '所有级别';

  @override
  String get storeAllGroups => '所有语言';

  @override
  String get storeFilterLevel => '等级';

  @override
  String get storeFilterLanguage => '语言';

  @override
  String get storeDownload => '下载';

  @override
  String get storeBuy => '买';

  @override
  String get storeInstalledLabel => '已安装';

  @override
  String get storeDownloading => '正在下载...';

  @override
  String get storeRetry => '重试';

  @override
  String get storeIapAndroidOnly => '购买仅适用于 Android 和 iOS。';

  @override
  String get storeDismiss => '解雇';

  @override
  String get storeAddToCart => '添加到购物车';

  @override
  String get storeRemoveFromCart => '消除';

  @override
  String get storeCartTitle => '购物车';

  @override
  String get storeCartEmpty => '您的购物车是空的';

  @override
  String get storeCartClearAll => '全部清除';

  @override
  String get storeCartCheckout => '查看';

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
  String get storePackageDuplicateTitle => '包已存在';

  @override
  String storePackageDuplicateMessage(String packageName, String groupName) {
    return '包“$packageName”已存在于组“$groupName”中。您想覆盖它吗？现有包及其所有训练进度将被永久删除。';
  }

  @override
  String get storePackageDuplicateOverwrite => '覆盖';

  @override
  String get storePackageDuplicateKeep => '保持现有';

  @override
  String splashSettingUpPackages(int current, int total) {
    return '设置包：$current / $total';
  }

  @override
  String get splashThisHappensOnce => '这只会发生一次。';

  @override
  String get splashLoading => '加载中…';

  @override
  String get aiItemCreator => '人工智能聊天大师';

  @override
  String get aiItemCreatorAppBarHint => '通过与人工智能聊天收集并保存单词和表达方式';

  @override
  String get chatWithAI => '与人工智能聊天';

  @override
  String get enterYourPrompt => '输入您的提示...';

  @override
  String get aiItemCreatorPromptHint =>
      '描述一个主题，人工智能教练会提出问题，建议有用的词汇，并测试您的知识。例如：帮助我收集和练习B2级知识中旅行的危险';

  @override
  String get send => '发送';

  @override
  String get sending => '正在发送...';

  @override
  String get aiResponse => '人工智能响应';

  @override
  String get itemInputs => '项目输入';

  @override
  String get aiItemCreatorBothItemsRequired => '请在保存前填写两种语言字段。';

  @override
  String get aiItemCreatorDuplicateItemMessage => '此包中已存在具有相同文本对的项目。';

  @override
  String get language1 => '语言1';

  @override
  String get language2 => '语言2';

  @override
  String get translateLang1ToLang2 => '翻译成语言2';

  @override
  String get translateLang2ToLang1 => '翻译为语言 1';

  @override
  String translateToLanguageCode(String languageCode) {
    return '翻译为 $languageCode';
  }

  @override
  String get example => '例子';

  @override
  String get generating => '生成...';

  @override
  String get flags => '旗帜';

  @override
  String get favorite => '最喜欢的';

  @override
  String get saveItems => '节省';

  @override
  String get saving => '保存...';

  @override
  String get clearItems => '仅清除物品';

  @override
  String get clearAll => '清除所有字段';

  @override
  String get itemSavedSuccessfully => '项目保存成功';

  @override
  String get promptCannotBeEmpty => '提示不能为空';

  @override
  String get enterAtLeastOneItem => '请输入至少一项';

  @override
  String get selectPackageFirst => '请先选择套餐';

  @override
  String get deeplKeyRequired => '翻译需要 DeepL API 密钥';

  @override
  String get noNonPurchasedPackagesAvailable => '没有可用的非购买套餐';

  @override
  String get packageSelectionRemembered => '已保存套餐选择';

  @override
  String get aiItemCreatorOpenAiKeyNotConfiguredDetailed =>
      '未配置 OpenAI API 密钥。请在“设置”中添加您的 API 密钥。';

  @override
  String get aiItemCreatorOpenAiKeyNotConfigured => '未配置 OpenAI API 密钥。';

  @override
  String get aiItemCreatorProcessingComplete => '加工完成';

  @override
  String get aiItemCreatorTranslationComingSoon => '翻译功能即将推出';

  @override
  String get aiItemCreatorDefaultCategoryName => '人工智能创造';

  @override
  String get aiItemCreatorStartNewConversation => '开始新的对话';

  @override
  String get aiItemCreatorChatHint => '描述一个主题，人工智能教练会提出问题，建议有用的词汇，并测试您的知识。';

  @override
  String get aiItemCreatorConversation => '对话';

  @override
  String get aiItemCreatorYou => '你';

  @override
  String get aiItemCreatorCoach => '人工智能教练';

  @override
  String get aiItemCreatorAiSuggestions => '人工智能建议';

  @override
  String get aiItemCreatorTapChipToFill => '点击一个芯片即可填充项目字段并自动翻译。';

  @override
  String get aiItemCreatorNoSuggestedItems => '还没有任何言语或表达。';

  @override
  String get aiItemCreatorNextSteps => '如何继续';

  @override
  String get aiItemCreatorNoNextSteps => '尚无继续建议。';

  @override
  String get aiItemCreatorModelCostTip =>
      '专业提示：较新的型号更昂贵，而较旧的型号和涡轮增压型号则更便宜，并且速度明显更快。';

  @override
  String get aiItemCreatorSelectPackageDialogTitle => '选择语言包';

  @override
  String get aiItemCreatorSelectPackageDialogMessage =>
      '选择用于此会话的语言包。您的最后选择是预先选择的。';

  @override
  String aiItemCreatorMissingApiKeysWarning(String keys) {
    return '缺少 API 密钥：$keys。您可以继续，但人工智能和高级翻译功能可能会受到限制。';
  }

  @override
  String get about => '关于';

  @override
  String get aboutWebsite => '网站';

  @override
  String get aboutSummaryVideo => '摘要视频';

  @override
  String get aboutSupportEmail => '支持电子邮件地址';

  @override
  String get aboutWebsiteUrl => 'https://sites.google.com/view/language-rally';

  @override
  String get aboutSummaryVideoUrl =>
      'https://www.youtube.com/watch?v=64Pl9iNF88c';

  @override
  String get aboutSupportEmailAddress => 'languagerally.support@gmail.com';

  @override
  String aboutVersionWithValue(String version) {
    return '版本：$version';
  }

  @override
  String aboutCouldNotOpen(String uri) {
    return '无法打开：$uri';
  }

  @override
  String get aboutWelcomeSplashNotFound => '未找到欢迎启动画面';

  @override
  String get chooseTheme => '选择主题';

  @override
  String get darkMode => '深色模式';

  @override
  String get toggleBetweenLightAndDark => '在浅色和深色之间切换';

  @override
  String get colorTheme => '颜色主题：';

  @override
  String get toggleBrightness => '切换亮度';

  @override
  String get changeTheme => '更改主题';

  @override
  String get managePackageGroups => '管理包组';

  @override
  String get noPackageGroups => '没有包组';

  @override
  String get createFirstPackageGroup => '创建您的第一个包组';

  @override
  String get addGroup => '添加组';

  @override
  String get addPackageGroup => '添加套餐组';

  @override
  String get editPackageGroup => '编辑套餐组';

  @override
  String get groupName => '群组名称';

  @override
  String get enterGroupName => '输入群组名称';

  @override
  String get groupNameRequired => '群组名称为必填项';

  @override
  String get duplicateGroupName => '重复名称';

  @override
  String groupNameAlreadyExists(String name) {
    return '名称为“$name”的组已存在。';
  }

  @override
  String groupCreatedSuccessfully(String name) {
    return '组“$name”创建成功';
  }

  @override
  String failedToCreateGroup(String error) {
    return '创建组失败：$error';
  }

  @override
  String groupRenamedTo(String name) {
    return '组重命名为“$name”';
  }

  @override
  String failedToUpdateGroup(String error) {
    return '无法更新组：$error';
  }

  @override
  String get deleteGroup => '删除组';

  @override
  String deleteGroupConfirm(String name) {
    return '您确定要删除组“$name”吗？\n\n此操作无法撤消。';
  }

  @override
  String get cannotDeleteGroup => '无法删除';

  @override
  String groupHasPackages(int count) {
    return '该组仍然有 $count 包。请先移动或删除它们。';
  }

  @override
  String groupDeleted(String name) {
    return '组“$name”已删除';
  }

  @override
  String failedToDeleteGroup(String error) {
    return '删除组失败：$error';
  }

  @override
  String get cannotDeleteHasPackagesTooltip => '无法删除（有包）';

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
  String get manageGroups => '管理群组';

  @override
  String get featureLangPower => '语言力量';

  @override
  String get featureAiIntegration => '人工智能整合';

  @override
  String get featureAdaptivePractice => '适应性练习';

  @override
  String get featureMasterAccent => '大师口音';

  @override
  String get allBadgesEarned => '🎉 所有徽章均已获得！你是大师！';

  @override
  String nextBadgeLabel(String name) {
    return '下一页： $name';
  }

  @override
  String pointsToGo(String percent) {
    return '$percent% 还剩 $percent%';
  }

  @override
  String progressPercent(String percent) {
    return '$percent% 进度';
  }

  @override
  String errorTogglingFavourite(String error) {
    return '切换收藏夹时出错：$error';
  }

  @override
  String errorTogglingImportant(String error) {
    return '切换重要错误：$error';
  }

  @override
  String categoryAdded(String name) {
    return '添加了类别“$name”';
  }

  @override
  String errorAddingCategory(String error) {
    return '添加类别时出错：$error';
  }

  @override
  String categoryRemoved(String name) {
    return '类别“$name”已删除';
  }

  @override
  String errorRemovingCategory(String error) {
    return '删除类别时出错：$error';
  }

  @override
  String couldNotOpenUrl(String url) {
    return '无法打开网址：$url';
  }

  @override
  String errorOpeningUrl(String error) {
    return '打开 URL 时出错：$error';
  }

  @override
  String get pleaseSelectLanguage => '请选择语言';

  @override
  String get add => '添加';

  @override
  String get speak => '说话';

  @override
  String get recordingFailedToStart =>
      '录音开始失败！\n\n检查：\n1. 麦克风已连接\n2.麦克风设置为默认设备\n3.没有其他应用程序正在使用麦克风';

  @override
  String get recordingFailedNoAudioFile =>
      '录音失败 - 未创建音频文件！\n\n可能的原因：\n1. 麦克风未连接\n2. 未检测到音频输入\n3.Windows音频设置问题';

  @override
  String errorStartingRecordingDetails(String error) {
    return '开始录制时出错：$error';
  }

  @override
  String get openaiEmptyResponse => '所选的 AI 模型返回空响应';

  @override
  String get tryDifferentModel => '尝试从模型选择器中选择不同的模型';

  @override
  String get modelMayNotBeSupported => '您的帐户可能不支持或不支持此型号';

  @override
  String get reduceTextOrRetry => '缩短文本长度或重试';

  @override
  String get openaiNullContent => '所选的AI模型没有返回内容';

  @override
  String get modelUnsupportedParameter => '所选型号不支持所需的 API 参数';
}
