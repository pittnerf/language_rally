// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get helloWorld => 'مرحبا بالعالم!';

  @override
  String get welcome => 'مرحبا بكم في رالي اللغة';

  @override
  String get appTitle => 'تجمع اللغة';

  @override
  String get createPackage => 'إنشاء الحزمة';

  @override
  String get editPackage => 'تحرير الحزمة';

  @override
  String get packageDetails => 'تفاصيل الحزمة';

  @override
  String get packageName => 'اسم الحزمة';

  @override
  String get packageNameHint =>
      'على سبيل المثال، الأساسيات الإسبانية، والأساسيات الألمانية';

  @override
  String get languageCode1 => 'رمز لغة المصدر';

  @override
  String get languageName1 => 'اسم اللغة المصدر';

  @override
  String get languageCode2 => 'رمز اللغة المستهدفة';

  @override
  String get languageName2 => 'اسم اللغة المستهدفة';

  @override
  String get description => 'وصف';

  @override
  String get descriptionHint => 'وصف موجز لحزمة اللغة هذه';

  @override
  String get authorName => 'اسم المؤلف';

  @override
  String get authorEmail => 'البريد الإلكتروني للمؤلف';

  @override
  String get authorWebpage => 'صفحة ويب المؤلف';

  @override
  String get version => 'إصدار';

  @override
  String get items => 'أغراض';

  @override
  String get packageIcon => 'أيقونة الحزمة';

  @override
  String get packageGroup => 'مجموعة الحزمة';

  @override
  String get selectIcon => 'حدد الرمز';

  @override
  String get defaultIcon => 'الرمز الافتراضي';

  @override
  String get customIcon => 'أيقونة مخصصة';

  @override
  String get upload => 'رمز التحميل';

  @override
  String get uploadCustomIcon =>
      'تحميل أيقونة مخصصة (بحد أقصى 512 × 512، 1 ميجابايت)';

  @override
  String get customIconUploaded => 'تم تحميل الرمز المخصص بنجاح';

  @override
  String get save => 'يحفظ';

  @override
  String get edit => 'يحرر';

  @override
  String get cancel => 'يلغي';

  @override
  String get delete => 'يمسح';

  @override
  String get confirmDelete => 'هل أنت متأكد أنك تريد حذف هذه الحزمة؟';

  @override
  String get packageSaved => 'تم حفظ الحزمة بنجاح';

  @override
  String get packageDeleted => 'تم حذف الحزمة بنجاح';

  @override
  String get errorSavingPackage => 'حدث خطأ أثناء حفظ الحزمة';

  @override
  String get errorDeletingPackage => 'حدث خطأ أثناء حذف الحزمة';

  @override
  String get fieldRequired => 'هذه الخانة مطلوبه';

  @override
  String get invalidEmail => 'عنوان البريد الإلكتروني غير صالح';

  @override
  String get readOnlyPackage => 'هذه الحزمة للقراءة فقط ولا يمكن تحريرها';

  @override
  String get purchasedPackage => 'لا يمكن تحرير الحزم المشتراة';

  @override
  String get badges => 'شارات';

  @override
  String get noBadges => 'لم يتم الحصول على أي شارات حتى الآن';

  @override
  String get selectLanguageCode => 'حدد رمز اللغة';

  @override
  String get typeToSearchLanguages => 'اكتب للبحث في اللغات...';

  @override
  String get search => 'يبحث...';

  @override
  String get clearCounters => 'عدادات واضحة';

  @override
  String get confirmClearCounters =>
      'هل أنت متأكد أنك تريد مسح كافة عدادات التدريب لهذه الحزمة؟ سيؤدي هذا إلى إعادة تعيين عدادات \"لا أعرف\" وإحصائيات التدريب.';

  @override
  String get clear => 'واضح';

  @override
  String get countersCleared => 'تم مسح العدادات بنجاح';

  @override
  String get errorClearingCounters => 'خطأ في مسح العدادات';

  @override
  String get deleteAll => 'حذف الحزمة';

  @override
  String get confirmDeleteAllData =>
      'هل أنت متأكد أنك تريد حذف هذه الحزمة بكل بياناتها؟ سيؤدي هذا إلى حذف جميع الفئات والعناصر وإحصائيات التدريب نهائيًا. لا يمكن التراجع عن هذا الإجراء!';

  @override
  String get allDataDeleted => 'تم حذف الحزمة وجميع البيانات بنجاح';

  @override
  String get exportPackage => 'حزمة التصدير';

  @override
  String get selectExportLocation => 'حدد موقع التصدير';

  @override
  String get packageExported => 'تم تصدير الحزمة بنجاح';

  @override
  String get errorExportingPackage => 'حدث خطأ أثناء تصدير الحزمة';

  @override
  String get importItems => 'استيراد العناصر (JSON)';

  @override
  String get importItemsDialogTitle => 'استيراد العناصر (JSON)';

  @override
  String get importItemsFromLocalJson => 'استيراد من ملف JSON المحلي';

  @override
  String get enterItemsUrl => 'عنوان URL للعناصر بتنسيق JSON (https://...)';

  @override
  String get downloadingItems => 'جارٍ تنزيل العناصر…';

  @override
  String get selectImportFile => 'حدد استيراد ملف';

  @override
  String get importFormat => 'تنسيق الاستيراد';

  @override
  String get importFormatDescription =>
      'استيراد العناصر من ملف نصي. يجب أن يحتوي كل سطر على عنصر بالتنسيق التالي:';

  @override
  String get importResults => 'نتائج الاستيراد';

  @override
  String get successfullyImported => 'تم الاستيراد بنجاح';

  @override
  String get failedToImport => 'فشل الاستيراد';

  @override
  String get error => 'خطأ';

  @override
  String get ok => 'نعم';

  @override
  String get importPackage => 'حزمة الاستيراد';

  @override
  String get importPackageTooltip => 'استيراد الحزمة من ملف ZIP أو URL';

  @override
  String get importPackageDialogTitle => 'استيراد حزمة اللغة';

  @override
  String get importFromLocalFile => 'الاستيراد من الملف المحلي';

  @override
  String get importFromUrl => 'استيراد من URL';

  @override
  String get enterPackageUrl => 'عنوان URL للحزمة (https://…)';

  @override
  String get downloadingPackage => 'جارٍ تنزيل الحزمة…';

  @override
  String get downloadFailed =>
      'فشل التنزيل. يرجى التحقق من عنوان URL واتصالك بالإنترنت.';

  @override
  String get invalidUrl => 'الرجاء إدخال عنوان URL صالح http:// أو https://.';

  @override
  String get orLabel => 'أو';

  @override
  String get selectPackageZipFile => 'حدد ملف حزمة ZIP';

  @override
  String get couldNotAccessFile => 'تعذر الوصول إلى الملف المحدد.';

  @override
  String get importingPackage => 'جارٍ استيراد الحزمة...';

  @override
  String get packageImportedSuccessfully => 'تم استيراد الحزمة بنجاح!';

  @override
  String packageImportedWithItems(Object count) {
    return 'تم استيراد الحزمة بنجاح! ($count العناصر)';
  }

  @override
  String packageImportedWithGroup(Object count, Object groupName) {
    return 'تم استيراد الحزمة إلى مجموعة \"$groupName\"! ($count العناصر)';
  }

  @override
  String get importError => 'خطأ في الاستيراد';

  @override
  String get failedToImportPackage => 'فشل استيراد الحزمة';

  @override
  String get packageAlreadyExists => 'الحزمة موجودة بالفعل';

  @override
  String packageExistsMessage(Object groupName) {
    return 'توجد حزمة بنفس زوج اللغة والوصف ومعلومات المؤلف والإصدار بالفعل في المجموعة \"$groupName\". هل ترغب في استيرادها كحزمة جديدة على أية حال؟';
  }

  @override
  String get importAsNew => 'استيراد على أي حال';

  @override
  String get zipFileNotFound => 'لم يتم العثور على ملف مضغوط';

  @override
  String get invalidPackageZip => 'حزمة ZIP غير صالحة: package_data.json مفقود';

  @override
  String get invalidPackageFormat => 'تنسيق ملف الحزمة غير صالح';

  @override
  String get languagePackages => 'حزم اللغة';

  @override
  String get loadingPackages => 'جارٍ تحميل الحزم...';

  @override
  String get tapAndHoldToReorder => 'انقر مع الاستمرار لإعادة ترتيب البطاقات';

  @override
  String get tapAndHoldToReorderList =>
      'انقر مع الاستمرار على ≡ لإعادة الترتيب • انقر على ⋮ لتبديل العرض المضغوط';

  @override
  String get noPackagesYet => 'لا توجد حزم حتى الآن';

  @override
  String get createFirstPackage => 'قم بإنشاء حزمة اللغة الأولى الخاصة بك';

  @override
  String get versionLabel => 'إصدار';

  @override
  String get purchased => 'تم شراؤها';

  @override
  String get compactView => 'مدمج';

  @override
  String get expand => 'يوسع';

  @override
  String get allCategories => 'جميع الفئات';

  @override
  String get categoriesInPackage => 'الفئات في هذه الحزمة';

  @override
  String get categories => 'فئات';

  @override
  String get testInterFonts => 'اختبار الخطوط المشتركة';

  @override
  String get viewPackages => 'عرض الحزم';

  @override
  String get simplifiedPackageView => 'قائمة الحزمة';

  @override
  String get createNewPackage => 'إنشاء حزمة جديدة';

  @override
  String get generateTestData => 'توليد بيانات الاختبار';

  @override
  String get designSystemShowcase => 'معرض تصميم النظام';

  @override
  String get badgeEarned => 'تم الحصول على الشارة!';

  @override
  String get achievement => 'إنجاز';

  @override
  String get awesome => 'مذهل!';

  @override
  String get importFormatNotes => 'ملحوظات:';

  @override
  String get importFormatLine1 => '• يمثل كل سطر عنصرًا واحدًا';

  @override
  String get importFormatLine2 => '• الحقول مفصولة بـ |';

  @override
  String get importFormatLine3 => '• يتم فصل الفئات بواسطة ;';

  @override
  String get importFormatLine4 => '• الأخير | هو اختياري';

  @override
  String get importFormatLine5 => '• يتم تجاهل الأسطر الفارغة';

  @override
  String get importFormatLine6 => '• يتم تخطي التكرارات';

  @override
  String get importFormatNewDescription =>
      'استيراد العناصر من ملف نصي. يجب أن يحتوي كل سطر على عنصر به حقول مفصولة بـ ---';

  @override
  String get importFormatNewLine1 => '• المحدد الرئيسي: ---';

  @override
  String get importFormatNewLine2 =>
      '• L1=<text> - النص الرئيسي للغة 1 (مطلوب إذا كان L2 مفقودًا)';

  @override
  String get importFormatNewLine3 =>
      '• L2=<text> - النص الرئيسي للغة 2 (مطلوب إذا كان L1 مفقودًا)';

  @override
  String get importFormatNewLine4 => '• L1pre=<text> - بادئة اللغة 1 (اختياري)';

  @override
  String get importFormatNewLine5 =>
      '• L1post=<text> - لاحقة اللغة 1 (اختياري)';

  @override
  String get importFormatNewLine6 => '• L2pre=<text> - بادئة اللغة 2 (اختياري)';

  @override
  String get importFormatNewLine7 =>
      '• L2post=<text> - لاحقة اللغة 2 (اختياري)';

  @override
  String get importFormatNewLine8 =>
      '• EX=<نص L1>:::<نص L2> - مثال (اختياري، يمكن أن يكون متعددًا)';

  @override
  String get importFormatNewLine9 =>
      '• CAT=<cat1>:::<cat2>:::<cat3> - الفئات (اختياري)';

  @override
  String get importFormatNewLine10 => '• يجب حضور واحد على الأقل من L1= أو L2=';

  @override
  String get importFormatNewLine11 => '• يتم تجاهل الأسطر الفارغة';

  @override
  String get importFormatNewLine12 => '• يتم تخطي التكرارات';

  @override
  String get invalidImportLine => 'خط غير صالح';

  @override
  String get missingRequiredFields => 'مفقود \"L1=\" غامض \"L2=\"';

  @override
  String get unknownField => 'بادئة حقل غير معروفة';

  @override
  String andMore(Object count) {
    return '... و$count أكثر';
  }

  @override
  String get browseItems => 'تصفح العناصر';

  @override
  String get itemDetails => 'تفاصيل';

  @override
  String get filterItems => 'تصفية العناصر';

  @override
  String searchLanguage1(Object language) {
    return 'البحث في $language';
  }

  @override
  String searchLanguage2(Object language) {
    return 'البحث في $language';
  }

  @override
  String get caseSensitive => 'حساسية الموضوع';

  @override
  String get knownStatus => 'الوضع معروف';

  @override
  String get filterStatusAll => 'الجميع';

  @override
  String get filterStatusKnown => 'معروف';

  @override
  String get filterStatusUnknown => 'مجهول';

  @override
  String get allItems => 'جميع العناصر';

  @override
  String get itemsIKnew => 'العناصر التي عرفتها';

  @override
  String get itemsIDidNotKnow => 'عناصر لم أكن أعرفها';

  @override
  String get known => 'معروف';

  @override
  String get unknown => 'مجهول';

  @override
  String get important => 'مهم';

  @override
  String get favourite => 'مفضل';

  @override
  String get badge => 'شارة';

  @override
  String get position => 'موضع';

  @override
  String get stepsUntilLearned => 'خطوات حتى تعلمها';

  @override
  String get examples => 'أمثلة';

  @override
  String get noExamples => 'لا توجد أمثلة متاحة';

  @override
  String get pronounce => 'نطق';

  @override
  String get ttsError => 'تحويل النص إلى كلام غير متوفر';

  @override
  String get noItemsFound => 'لم يتم العثور على أي عناصر';

  @override
  String get noItemsInPackage => 'لا توجد عناصر في هذه الحزمة حتى الآن';

  @override
  String get addItem => 'إضافة عنصر';

  @override
  String get emptyPackageHint =>
      'أضف العناصر يدويًا أو استخدم الذكاء الاصطناعي لاستيراد العناصر بسرعة';

  @override
  String get noItemsToTrain =>
      'لا توجد عناصر متاحة للتدريب مع الإعدادات الحالية';

  @override
  String get clearFilters => 'واضح';

  @override
  String itemCount(Object count) {
    return '$count العناصر';
  }

  @override
  String filteredItemCount(Object filtered, Object total) {
    return '$filtered من $total العناصر';
  }

  @override
  String get trainingRally => 'تجمع التدريب';

  @override
  String get startTraining => 'ابدأ التدريب';

  @override
  String get trainingComingSoon => 'رالي التدريب - قريباً!';

  @override
  String get aiServiceNotConfigured =>
      'لم يتم تكوين خدمة الذكاء الاصطناعي. الرجاء إضافة مفتاح OpenAI API الخاص بك.';

  @override
  String pleaseEnterTextInLanguageFirst(Object language) {
    return 'الرجاء إدخال النص في $language أولاً';
  }

  @override
  String translationCompletedSuccessfully(Object service) {
    return 'تمت الترجمة بنجاح باستخدام $service!';
  }

  @override
  String get translationFailed => 'فشلت الترجمة';

  @override
  String addedExamplesSuccessfully(Object count) {
    return 'تمت إضافة $count من الأمثلة بنجاح!';
  }

  @override
  String get failedToGenerateExamples => 'فشل في توليد الأمثلة';

  @override
  String get selectExamplesToAdd => 'حدد أمثلة لإضافتها';

  @override
  String get selectWhichExamples =>
      'حدد الأمثلة التي تريد إضافتها إلى هذا العنصر:';

  @override
  String get addSelected => 'أضف المحدد';

  @override
  String get pleaseSelectAtLeastOne => 'الرجاء تحديد مثال واحد على الأقل';

  @override
  String get addNewItem => 'إضافة عنصر جديد';

  @override
  String get editItem => 'تحرير العنصر';

  @override
  String get deleteItem => 'حذف العنصر';

  @override
  String get confirmDeleteItem => 'هل أنت متأكد أنك تريد حذف هذا العنصر؟';

  @override
  String get thisActionCannotBeUndone => 'لا يمكن التراجع عن هذا الإجراء.';

  @override
  String get itemDeleted => 'تم حذف العنصر';

  @override
  String get errorDeletingItem => 'حدث خطأ أثناء حذف العنصر';

  @override
  String get errorSavingItem => 'حدث خطأ أثناء حفظ العنصر';

  @override
  String get itemSaved => 'تم تحديث العنصر بنجاح';

  @override
  String get itemCreated => 'تم إنشاء العنصر بنجاح';

  @override
  String get preTextOptional => 'نص مسبق (اختياري)';

  @override
  String get mainText => 'النص الرئيسي';

  @override
  String get postTextOptional => 'النص اللاحق (اختياري)';

  @override
  String get forExampleToForVerbs => 'على سبيل المثال، \"إلى\" للأفعال';

  @override
  String get additionalContext => 'سياق إضافي';

  @override
  String get translate => 'يترجم';

  @override
  String translateFromTo(Object from, Object to) {
    return 'ترجمة $from → $to';
  }

  @override
  String get aiExampleGeneration => 'الذكاء الاصطناعي مثال الجيل';

  @override
  String get aiExampleSearch => 'بحث عن أمثلة الذكاء الاصطناعي';

  @override
  String searchExamplesOnInternet(Object text) {
    return 'ابحث عن جمل سبيل المثال على الإنترنت باستخدام الذكاء الاصطناعي لـ \'$text\'';
  }

  @override
  String generateExampleSentences(Object language) {
    return 'قم بإنشاء جمل نموذجية بناءً على النص الرئيسي في $language';
  }

  @override
  String get voiceInput => 'الإدخال الصوتي';

  @override
  String get settings => 'إعدادات';

  @override
  String get uiLanguage => 'لغة واجهة المستخدم';

  @override
  String get uiLanguageDescription => 'لغة واجهة التطبيق';

  @override
  String get uiLanguageHelper => 'حدد لغة القوائم والأزرار والتسميات';

  @override
  String get userLanguage => 'لغة المستخدم';

  @override
  String get userLanguageDescription =>
      'لغتك الأم المفضلة لإنشاء حزم اللغات الجديدة';

  @override
  String get apiKeys => 'مفاتيح واجهة برمجة التطبيقات';

  @override
  String get deeplApiKey => 'مفتاح DeepL API';

  @override
  String get deeplApiKeyDescription =>
      'للحصول على جودة ترجمة متميزة عند تحرير عناصر اللغة. راجع https://www.deepl.com/pro-api';

  @override
  String get openaiApiKey => 'مفتاح واجهة برمجة تطبيقات OpenAI';

  @override
  String get openaiApiKeyDescription =>
      'على سبيل المثال، التوليد باستخدام الذكاء الاصطناعي عند تحرير عناصر اللغة. راجع https://platform.openai.com/api-keys';

  @override
  String get enterApiKey => 'أدخل مفتاح API';

  @override
  String get optional => 'خياري';

  @override
  String get required => 'مطلوب';

  @override
  String get settingsSaved => 'تم حفظ الإعدادات بنجاح';

  @override
  String get errorSavingSettings => 'خطأ في حفظ الإعدادات';

  @override
  String get usingGoogleTranslate => 'استخدام ترجمة جوجل المجانية';

  @override
  String get usingDeepL => 'باستخدام DeepL (قسط)';

  @override
  String get noTranslationReceivedFromGoogle => 'لم يتم تلقي أي ترجمة من جوجل';

  @override
  String get googleTranslationFailed => 'فشلت ترجمة جوجل';

  @override
  String get googleTranslationError => 'خطأ في ترجمة جوجل';

  @override
  String get noTranslationReceivedFromDeepL => 'لم يتم تلقي أي ترجمة من DeepL';

  @override
  String get invalidDeepLApiKey => 'مفتاح DeepL API غير صالح';

  @override
  String get deeplTranslationQuotaExceeded => 'تم تجاوز حصة ترجمة DeepL';

  @override
  String get deeplTranslationFailed => 'فشلت ترجمة DeepL';

  @override
  String get deeplTranslationError => 'خطأ في ترجمة DeepL';

  @override
  String get invalidApiKeyConfigureOpenAI =>
      'مفتاح API غير صالح. يرجى تكوين مفتاح OpenAI API الخاص بك.';

  @override
  String get apiRateLimitExceeded =>
      'تم تجاوز الحد الأقصى لمعدل واجهة برمجة التطبيقات. يرجى المحاولة مرة أخرى في وقت لاحق.';

  @override
  String get aiRequestFailed => 'فشل طلب الذكاء الاصطناعي';

  @override
  String get failedToParseAiResponse =>
      'فشل في تحليل استجابة الذكاء الاصطناعي. يرجى المحاولة مرة أخرى.';

  @override
  String get aiGenerationError => 'خطأ في إنشاء الذكاء الاصطناعي';

  @override
  String get voiceInputPlaceholder =>
      'سيتم تنفيذ الإدخال الصوتي باستخدام حزمة الكلام_إلى_نص';

  @override
  String get improveQualityWithApiKeys =>
      '💡 نصيحة: يمكن تحسين جودة الترجمات وأمثلة البحث بشكل كبير عن طريق إضافة مفاتيح DeepL وOpenAI API في إعدادات التطبيق.';

  @override
  String get noApiKeyFallbackMessage =>
      'بدون مفاتيح API، يتم توفير الترجمة الأساسية وأمثلة محدودة. للحصول على أفضل النتائج، قم بتكوين مفاتيح API الخاصة بك في الإعدادات.';

  @override
  String get listeningForSpeech => 'الاستماع... تحدث الآن';

  @override
  String get speechRecognitionNotAvailable =>
      'التعرف على الكلام غير متوفر على هذا الجهاز';

  @override
  String get speechRecognitionPermissionDenied =>
      'تم رفض إذن التعرف على الكلام';

  @override
  String get speechRecognitionError => 'خطأ في التعرف على الكلام';

  @override
  String get tapToSpeak => 'اضغط على الميكروفون للتحدث';

  @override
  String get tapToStop => 'انقر لإيقاف التسجيل';

  @override
  String get speechNotRecognized =>
      'لم يتم التعرف على أي خطاب. يرجى المحاولة مرة أخرى.';

  @override
  String get usingWhisperApiSlower =>
      'استخدام الذكاء الاصطناعي السحابي للتعرف على الكلام (قد يكون أبطأ)';

  @override
  String languageNotSupportedAddApiKey(String languageCode) {
    return 'اللغة $languageCode غير مدعومة أصلاً. أضف مفتاح OpenAI API في الإعدادات للتعرف على الكلام المدعوم بالذكاء الاصطناعي.';
  }

  @override
  String get recordingTapToStop => 'التسجيل... اضغط مرة أخرى للتوقف';

  @override
  String get speakClearlyKeepRecording =>
      'تحدث بوضوح. سجل ثانية واحدة على الأقل.';

  @override
  String get pleaseRecordLonger =>
      'من فضلك تحدث لمدة ثانية واحدة على الأقل ثم اضغط على إيقاف.';

  @override
  String get errorStartingRecording => 'خطأ في بدء التسجيل';

  @override
  String get noAudioRecorded => 'لم يتم تسجيل أي صوت';

  @override
  String get errorTranscribing => 'حدث خطأ أثناء نسخ الصوت';

  @override
  String get trainingSettings => 'إعدادات التدريب';

  @override
  String get trainingPresetTitle => 'الإعداد السريع';

  @override
  String get trainingPresetHint =>
      'اختر إعدادًا مسبقًا وسيتم تكوين الإعدادات أدناه تلقائيًا.';

  @override
  String get trainingPresetComboLabel => 'محددة مسبقا';

  @override
  String get trainingPresetAllExamplesForeignLanguage =>
      'جميع الأمثلة، لغة أجنبية';

  @override
  String get trainingPresetAllExamplesRandomLanguage =>
      'جميع الأمثلة، لغة عشوائية';

  @override
  String get trainingPresetFavouriteItemsForeignLanguage =>
      'العناصر المفضلة، لغة أجنبية';

  @override
  String get trainingPresetFavouriteItemsRandomLanguage =>
      'العناصر المفضلة، لغة عشوائية';

  @override
  String get trainingPresetImportantItemsForeignLanguage =>
      'بنود مهمة، لغة أجنبية';

  @override
  String get trainingPresetImportantItemsRandomLanguage =>
      'عناصر مهمة، لغة عشوائية';

  @override
  String get trainingPresetRandomItemsRandomLanguage =>
      'عناصر عشوائية، لغة عشوائية';

  @override
  String get trainingPresetUnknownItemsForeignLanguage =>
      'عناصر غير معروفة، لغة أجنبية';

  @override
  String get trainingPresetUnknownItemsRandomLanguage =>
      'عناصر غير معروفة، لغة عشوائية';

  @override
  String trainingPresetAppliedTapStart(String actionLabel) {
    return 'تم تطبيق الإعداد المسبق. اضغط على \"$actionLabel\" للبدء.';
  }

  @override
  String get trainingPresetSelectPackageFirst => 'الرجاء تحديد الحزمة أولاً.';

  @override
  String get itemScope => 'نطاق السلعة';

  @override
  String get lastNItems => 'آخر N من العناصر';

  @override
  String get onlyUnknown => 'العناصر غير المعروفة فقط';

  @override
  String get onlyImportant => 'العناصر المهمة فقط';

  @override
  String get onlyFavourite => 'العناصر المفضلة فقط';

  @override
  String get numberOfItems => 'عدد العناصر';

  @override
  String get itemOrder => 'ترتيب السلعة';

  @override
  String get randomOrder => 'ترتيب عشوائي';

  @override
  String get sequentialOrder => 'ترتيب تسلسلي';

  @override
  String get itemType => 'نوع العنصر';

  @override
  String get dictionaryItems => 'عناصر القاموس';

  @override
  String get examplesType => 'أمثلة';

  @override
  String get displayLanguage => 'لغة العرض';

  @override
  String get motherTongue => 'اللغة الأم';

  @override
  String get targetLanguage => 'اللغة المستهدفة';

  @override
  String get randomLanguage => 'عشوائي';

  @override
  String get categoryFilter => 'مرشح الفئة';

  @override
  String get categoryFilterHint =>
      'تحديد الفئات المراد تضمينها (فارغ = جميع الفئات)';

  @override
  String get noCategories => 'لا توجد فئات متاحة';

  @override
  String get dontKnowThreshold => 'لا أعرف عتبة';

  @override
  String get dontKnowThresholdHint =>
      'عدد المرات التي يجب فيها وضع علامة \"لا أعرف\" على العنصر قبل التعامل معه بشكل خاص';

  @override
  String get startTrainingRally => 'بدء تجمع التدريب';

  @override
  String get clearTrainingSettings => 'مسح الإعدادات';

  @override
  String get confirmClearTrainingSettings =>
      'هل أنت متأكد أنك تريد إعادة تعيين كافة إعدادات التدريب إلى القيم الافتراضية؟';

  @override
  String get trainingSettingsCleared => 'تم مسح إعدادات التدريب';

  @override
  String get startingTraining => 'البدء بالتدريب...';

  @override
  String get noMoreItemsToDisplay =>
      'لا توجد عناصر لعرضها بناءً على إعدادات الفلتر الخاصة بك.';

  @override
  String get noItems => 'لا توجد عناصر';

  @override
  String get trainingComplete => 'اكتمل التدريب';

  @override
  String get allItemsCompleted =>
      'تهانينا! لقد أكملت كافة العناصر الموجودة في هذه الدورة التدريبية.';

  @override
  String get closeTraining => 'إغلاق التدريب';

  @override
  String get confirmCloseTraining =>
      'هل أنت متأكد أنك تريد إغلاق التدريب؟ لقد تم حفظ تقدمك.';

  @override
  String get question => 'سؤال';

  @override
  String get answer => 'إجابة';

  @override
  String get iKnow => 'أنا أعرف';

  @override
  String get iDontKnow => 'لا أعرف';

  @override
  String get previousItem => 'العنصر السابق';

  @override
  String get iDidNotKnowEither => 'لم أكن أعرف ذلك بعد كل شيء';

  @override
  String get exportBeforeDelete => 'تصدير قبل الحذف؟';

  @override
  String get aiTextAnalysis =>
      'استخراج العناصر من نص/قائمة باستخدام الذكاء الاصطناعي';

  @override
  String get aiTextAnalysisImport =>
      'استخرج العناصر من نص أو قائمة باستخدام أداة تحليل النص AI';

  @override
  String get knowledgeLevel => 'مستوى المعرفة';

  @override
  String get a1Beginner => 'A1 - مبتدئ';

  @override
  String get a2Elementary => 'A2 - ابتدائي';

  @override
  String get b1Intermediate => 'ب1 - متوسط';

  @override
  String get b2UpperIntermediate => 'B2 - فوق المتوسط';

  @override
  String get c1Advanced => 'C1 - متقدم';

  @override
  String get c2Proficient => 'ج2 - متقن';

  @override
  String get pasteTextHere => 'الصق النص الخاص بك هنا...';

  @override
  String get extractWords => 'استخراج الكلمات';

  @override
  String get extractExpressions => 'استخراج التعبيرات';

  @override
  String get maxItems => 'الحد الأقصى للعناصر الجديدة';

  @override
  String get maxItemsHint => 'اتركها فارغة بلا حدود';

  @override
  String get generateExamples => 'توليد أمثلة';

  @override
  String get categoryName => 'اسم الفئة';

  @override
  String get categoryNameHint => 'اسم فئة العناصر المستوردة';

  @override
  String get analyzeText => 'تحليل النص';

  @override
  String get configureAnalysis => 'تكوين العناصر لاستخراجها';

  @override
  String get openaiModel => 'نموذج الذكاء الاصطناعي';

  @override
  String get openaiModelDescription => 'حدد نموذج ChatGPT';

  @override
  String get modelGpt55 => 'جي بي تي-5.5';

  @override
  String get modelGpt55Pro => 'جي بي تي-5.5 برو';

  @override
  String get modelGpt54 => 'جي بي تي-5.4';

  @override
  String get modelGpt54Pro => 'جي بي تي-5.4 برو';

  @override
  String get modelGpt54Mini => 'جي بي تي-5.4 ميني';

  @override
  String get modelGpt5Mini => 'جي بي تي-5 ميني';

  @override
  String get modelGpt41 => 'جي بي تي-4.1';

  @override
  String get modelGpt55Desc =>
      'أحدث توازن رائد بين الجودة والسرعة للاستخدام العام';

  @override
  String get modelGpt55ProDesc =>
      'الإصدار الأحدث من GPT-5.5 للحصول على أقوى الأسباب والجودة';

  @override
  String get modelGpt54Desc => 'نموذج جيل GPT-5 قوي للأغراض العامة';

  @override
  String get modelGpt54ProDesc => 'متغير GPT-5.4 ذو قدرة أعلى للمهام الصعبة';

  @override
  String get modelGpt54MiniDesc =>
      'متغير GPT-5.4 أصغر حجمًا وأسرع للمهام اليومية منخفضة التكلفة';

  @override
  String get modelGpt5MiniDesc =>
      'طراز عائلة GPT-5 صغير الحجم مُحسّن من حيث السرعة والتكلفة';

  @override
  String get modelGpt41Desc => 'خيار GPT-4.1 الموثوق به للتوافق والجودة القوية';

  @override
  String get modelGpt4o => 'جي بي تي-4o';

  @override
  String get modelGpt35Turbo => 'GPT-3.5 Turbo (القديم، الميزانية)';

  @override
  String get modelGpt35Turbo16k => 'جي بي تي-3.5 توربو 16 كيلو';

  @override
  String get modelGpt4 => 'جي بي تي-4';

  @override
  String get modelGpt4Turbo => 'جي بي تي-4 توربو (ليجاسي)';

  @override
  String get modelGpt4oDesc =>
      'أفضل خيار للأغراض العامة؛ جودة سريعة ومتعددة الوسائط وقوية';

  @override
  String get modelGpt35TurboDesc =>
      'خيار قديم منخفض التكلفة؛ مفيد للمهام الأبسط والاستخدام الحساس للتكلفة';

  @override
  String get modelGpt35Turbo16kDesc =>
      'مثل GPT-3.5، لكن نافذة سياق الرمز المميز تبلغ 16 كيلو بايت';

  @override
  String get modelGpt4Desc => 'جودة تفكير عالية؛ عادة ما تكون أبطأ وأكثر تكلفة';

  @override
  String get modelGpt4TurboDesc =>
      'خيار عائلة Legacy GPT-4؛ لا يزال مفيدًا عندما تريد بديلاً أقدم وأرخص';

  @override
  String get analyzing => 'جارٍ التحليل...';

  @override
  String get languageDetected => 'تم اكتشاف اللغة';

  @override
  String get itemsFound => 'العناصر التي تم العثور عليها';

  @override
  String get selectItemsToImport => 'حدد العناصر المراد استيرادها';

  @override
  String get selectAll => 'حدد الكل';

  @override
  String get deselectAll => 'قم بإلغاء تحديد الكل';

  @override
  String get importSelected => 'استيراد المحدد';

  @override
  String get importing => 'جارٍ الاستيراد...';

  @override
  String get itemsImported => 'تم استيراد العناصر بنجاح';

  @override
  String get noItemsSelected => 'لم يتم تحديد أي عناصر';

  @override
  String get textCannotBeEmpty => 'لا يمكن أن يكون النص فارغًا';

  @override
  String get selectAtLeastOneType =>
      'حدد نوع واحد على الأقل (كلمات أو تعبيرات)';

  @override
  String get languageNotMatching =>
      'اللغة المكتشفة لا تتطابق مع أي لغة في الحزمة';

  @override
  String get openaiKeyRequired => 'مطلوب مفتاح OpenAI API لهذه الميزة';

  @override
  String analyzingProgress(Object current, Object total) {
    return 'التحليل: $current / $total';
  }

  @override
  String translatingProgress(Object current, Object total) {
    return 'الترجمة: $current / $total';
  }

  @override
  String get duplicate => 'ينسخ';

  @override
  String importProgress(Object current, Object total) {
    return 'استيراد $current من $total';
  }

  @override
  String get detectingLanguage => 'كشف اللغة...';

  @override
  String get extractingItems => 'استخراج العناصر...';

  @override
  String get checkingDuplicates => 'جارٍ التحقق من التكرارات...';

  @override
  String get translating => 'ترجمة...';

  @override
  String get generatingExamples => 'توليد الأمثلة...';

  @override
  String get errorAnalyzingText => 'خطأ في تحليل النص';

  @override
  String get errorImportingItems => 'حدث خطأ أثناء استيراد العناصر';

  @override
  String get warning => 'تحذير';

  @override
  String get textIsVeryLarge => 'النص كبير جدًا';

  @override
  String get words => 'كلمات';

  @override
  String get continueAnalysis =>
      'قد يستغرق هذا وقتًا أطول للمعالجة وسيتم تحليله على أجزاء. هل تريد الاستمرار';

  @override
  String get continueLabel => 'يكمل';

  @override
  String get exportBeforeDeleteMessage =>
      'هل ترغب في تصدير هذه الحزمة قبل حذفها؟ سيؤدي هذا إلى حفظ جميع بياناتك في ملف ZIP.';

  @override
  String get deleteWithoutExport => 'حذف بدون تصدير';

  @override
  String get exportAndDelete => 'تصدير وحذف';

  @override
  String get exportingPackage => 'جارٍ تصدير الحزمة...';

  @override
  String packageExportedToPath(Object path) {
    return 'تم تصدير الحزمة إلى: $path';
  }

  @override
  String errorLoadingItems(Object error) {
    return 'خطأ في تحميل العناصر: $error';
  }

  @override
  String badgeEarnedWithName(Object badgeName) {
    return 'الشارة التي تم الحصول عليها: $badgeName!';
  }

  @override
  String badgeLostWithName(Object badgeName) {
    return 'الشارة المفقودة: $badgeName';
  }

  @override
  String get trainingSessionProgress => 'إحصائيات الدورة التدريبية';

  @override
  String get total => 'المجموع';

  @override
  String lastNValue(Object value) {
    return 'ن = $value';
  }

  @override
  String errorLoadingSettings(Object error) {
    return 'خطأ في تحميل الإعدادات: $error';
  }

  @override
  String get selectPackage => 'حدد الحزمة';

  @override
  String get noPackagesAvailable => 'لا توجد حزم متاحة';

  @override
  String get possibleSolutions => 'الحلول الممكنة';

  @override
  String get technicalDetails => 'التفاصيل الفنية';

  @override
  String get close => 'يغلق';

  @override
  String get checkApiKey => 'تحقق من مفتاح OpenAI API الخاص بك';

  @override
  String get ensureValidOpenAIKey => 'تأكد من أن مفتاح API صالح ونشط';

  @override
  String get verifyKeyInSettings => 'تحقق من المفتاح في الإعدادات';

  @override
  String get rateLimitExceeded =>
      'تم تجاوز الحد الأقصى لمعدل واجهة برمجة التطبيقات';

  @override
  String get waitAndRetry => 'انتظر بضع دقائق وحاول مرة أخرى';

  @override
  String get checkAccountQuota => 'تحقق من حصة حساب OpenAI الخاص بك';

  @override
  String get invalidRequest => 'تنسيق الطلب غير صالح';

  @override
  String get tryReducingTextLength => 'حاول تقليل طول النص';

  @override
  String get checkTextFormat => 'تأكد من صحة تنسيق النص';

  @override
  String get checkInternetConnection => 'تحقق من اتصالك بالإنترنت';

  @override
  String get retryInMoment => 'أعد المحاولة بعد قليل';

  @override
  String get checkFirewall => 'تحقق من إعدادات جدار الحماية';

  @override
  String get textMayBeTooShort => 'قد يكون النص قصيرًا جدًا';

  @override
  String get tryDifferentKnowledgeLevel => 'جرب مستوى معرفيًا مختلفًا';

  @override
  String get ensureTextInCorrectLanguage => 'تأكد من أن النص باللغة الصحيحة';

  @override
  String get requestTimedOut => 'انتهت مهلة الطلب';

  @override
  String get textMayBeTooLong => 'قد يكون النص طويلاً جدًا';

  @override
  String get tryAgainOrReduceSize => 'حاول مرة أخرى أو قم بتقليل حجم النص';

  @override
  String get unexpectedError => 'حدث خطأ غير متوقع';

  @override
  String get checkErrorDetails => 'تحقق من تفاصيل الخطأ أدناه';

  @override
  String get tryAgainLater => 'حاول مرة أخرى لاحقًا';

  @override
  String get translationServiceFailed => 'فشلت خدمة الترجمة';

  @override
  String get checkApiKeys => 'التحقق من مفاتيح API الخاصة بك (DeepL، OpenAI)';

  @override
  String get retryImport => 'أعد محاولة الاستيراد';

  @override
  String get exampleGenerationFailed => 'فشل إنشاء المثال';

  @override
  String get itemsStillImported => 'وكانت العناصر لا تزال مستوردة';

  @override
  String get canAddExamplesManually => 'يمكنك إضافة أمثلة يدويًا لاحقًا';

  @override
  String get databaseError => 'حدث خطأ في قاعدة البيانات';

  @override
  String get checkStorageSpace => 'تحقق من مساحة التخزين المتاحة';

  @override
  String get restartApp => 'حاول إعادة تشغيل التطبيق';

  @override
  String get groupLabel => 'مجموعة:';

  @override
  String get amendGroups => 'يعدل';

  @override
  String get exportItemsJson => 'تصدير العناصر (JSON)';

  @override
  String get exportItemsJsonTooltip => 'تصدير كافة العناصر كملف JSON';

  @override
  String get noCategoriesInPackage => 'لم يتم العثور على فئات في هذه الحزمة';

  @override
  String get noItemsToExport => 'لم يتم العثور على عناصر للتصدير';

  @override
  String itemsExportedSuccessfully(int count, String path) {
    return 'تم تصدير عناصر $count بنجاح إلى:\n$path';
  }

  @override
  String get errorExportingItems => 'حدث خطأ أثناء تصدير العناصر';

  @override
  String get languageMismatch => 'عدم تطابق اللغة';

  @override
  String get languageMismatchDescription =>
      'اللغات الموجودة في ملف JSON لا تتطابق مع لغات الحزمة:';

  @override
  String packageLanguages(String lang1, String lang2) {
    return 'الحزمة: $lang1 → $lang2';
  }

  @override
  String jsonFileLanguages(String lang1, String lang2) {
    return 'ملف JSON: $lang1 → $lang2';
  }

  @override
  String get continueImportQuestion => 'هل تريد متابعة الاستيراد على أية حال؟';

  @override
  String get continueImport => 'متابعة الاستيراد';

  @override
  String get pleaseSelectPackageGroup => 'الرجاء تحديد مجموعة الحزمة';

  @override
  String get customIconLabel => 'مخصص';

  @override
  String get defaultIconLabel => 'تقصير';

  @override
  String get icon2Label => 'كتاب مفتوح';

  @override
  String get icon3Label => 'كتاب ملون';

  @override
  String get icon4Label => 'محادثة';

  @override
  String get icon5Label => 'تخرُّج';

  @override
  String get icon6Label => 'مخ';

  @override
  String get icon7Label => 'كتاب المكدس';

  @override
  String get icon8Label => 'البطاقات التعليمية';

  @override
  String get icon9Label => 'الكرة الأرضية';

  @override
  String get icon10Label => 'قلم رصاص';

  @override
  String get icon11Label => 'غنيمة';

  @override
  String get icon12Label => 'يبحث';

  @override
  String get customIconFile => 'أيقونة مخصصة';

  @override
  String get importedIconFile => 'أيقونة مستوردة';

  @override
  String get unableToReadImageFile =>
      'غير قادر على قراءة ملف الصورة. الرجاء تحديد صورة صالحة.';

  @override
  String iconDimensionsTooLarge(int width, int height) {
    return 'أبعاد الرمز كبيرة جدًا (${width}x$height). الحد الأقصى المسموح به هو 512 × 512 بكسل.';
  }

  @override
  String get iconFileTooLarge =>
      'ملف الرمز كبير جدًا. الحد الأقصى للحجم هو 1 ميغابايت.';

  @override
  String failedToUploadIcon(String error) {
    return 'فشل تحميل الرمز: $error';
  }

  @override
  String get pleaseSelectValidLanguage => 'الرجاء تحديد لغة صالحة من القائمة';

  @override
  String get status => 'حالة';

  @override
  String get addExample => 'أضف مثالا';

  @override
  String get noExamplesYet => 'لا توجد أمثلة حتى الآن. انقر فوق + للإضافة.';

  @override
  String get speakText => 'تحدث النص';

  @override
  String get removeCategory => 'إزالة الفئة';

  @override
  String removeCategoryConfirm(String categoryName) {
    return 'هل تريد إزالة الفئة \"$categoryName\" من هذا العنصر؟';
  }

  @override
  String get remove => 'يزيل';

  @override
  String get extractFullItems => 'استخراج العناصر الكاملة';

  @override
  String get pasteFromClipboard => 'لصق من الحافظة';

  @override
  String get noItemsFoundOrAllDuplicates =>
      'لم يتم العثور على أي عناصر في النص، أو أن كافة العناصر موجودة بالفعل في الحزمة';

  @override
  String get aboutLanguageRally => 'حول رالي اللغة';

  @override
  String get welcomeTitle => '🚀 مرحبًا بك في رالي اللغات';

  @override
  String get welcomeSubtitle =>
      'أطلق العنان للقوة المذهلة لتعلم اللغة باستخدام ما يقرب من 4000 كلمة، و4000 تعبير، والعديد من أمثلة الجمل - المنسقة بعناية لكل مستوى من مستويات الكفاءة! استخدم الذكاء الاصطناعي لاستيراد عناصر من نصوصك الخاصة، أو قم بالدردشة مع الذكاء الاصطناعي حول أي موضوع لإنشاء الكلمات والتعبيرات والأمثلة الدقيقة التي تريد تعلمها.\nارفع مستوى مهاراتك اللغوية – بالطريقة الذكية والمرحة!';

  @override
  String get welcomeIntro =>
      'تعلم المفردات والتعبيرات بكفاءة من خلال ممارسة ما يهمك بالفعل. لا قوائم مملة. لا يوجد وقت ضائع.';

  @override
  String get sectionPlayYourGame => '🎮 العب لعبتك الخاصة';

  @override
  String get sectionPlayYourGameDesc =>
      'إنشاء حزم المفردات الخاصة بك. تدريب فقط على الكلمات والتعبيرات التي تريد إتقانها. هل تعرف ذلك بالفعل؟ سيتم وضع علامة عليه وتخطيه!';

  @override
  String get sectionAITeammate => '🤖 الذكاء الاصطناعي كزميلك في الفريق';

  @override
  String get sectionAITeammateDesc =>
      'الصق أي نص واترك الذكاء الاصطناعي:\n• استخراج المفردات المفيدة\n• اختر التعبيرات التي تتناسب مع مستواك\n• أنشئ حزمًا جاهزة للتدريب في ثوانٍ\n\nالدردشة مع الذكاء الاصطناعي:\n• السماح لها باقتراح الكلمات والتعبيرات لموضوعك\n• انقر لتوليد الأمثلة وحفظها في الحزمة الخاصة بك';

  @override
  String get sectionTrainSmart => '🔁 تدريب ذكي';

  @override
  String get sectionTrainSmartDesc =>
      'يُظهر نظام التكرار الدقيق لدينا العناصر بالضبط عندما يحتاجها عقلك من أجل حفظها بشكل فعال. أقصى قدر من التقدم. الحد الأدنى من الجهد.';

  @override
  String get sectionRealExamples => '🌍 أمثلة حقيقية. ترجمات عظيمة.';

  @override
  String get sectionRealExamplesDesc =>
      'احصل على أمثلة للاستخدام في العالم الحقيقي. ترجم بجودة متميزة عبر DeepL. ممارسة النطق والصوت واثق.';

  @override
  String get sectionTeachersWelcome => '👩‍🏫 مرحباً بالمعلمين';

  @override
  String get sectionTeachersWelcomeDesc =>
      'أنشئ حزمة ← انسخ العناصر والصقها أو استخرج الأمثلة وترجمها وأضفها باستخدام الذكاء الاصطناعي ← تصدير ← تحميل/إرسال ← تم. يقوم طلابك باستيراده والبدء في التدريب على الفور.';

  @override
  String get sectionUnlockAI => '🔑 فتح قوة الذكاء الاصطناعي الكاملة';

  @override
  String get sectionUnlockAIDesc =>
      'للحصول على ترجمة عالية الجودة وميزات الذكاء الاصطناعي، ما عليك سوى:\n\n1. قم بإنشاء مفتاح DeepL API الخاص بك\n   https://www.deepl.com/pro-api\n2. قم بإنشاء مفتاح OpenAI API الخاص بك\n   https://platform.openai.com/api-keys\n3. الصق كلا المفتاحين في الإعدادات\n\nيفتح الاستثمار الصغير أدوات لغوية قوية واحترافية. لماذا تفوتك هذه الفرصة؟\n(نوصي باستخدام الوصول المدفوع لواجهة برمجة التطبيقات للحصول على أفضل النتائج.)';

  @override
  String get readyToStart => 'على استعداد لبدء التجمع الخاص بك؟ 🏁';

  @override
  String get welcomeDescription =>
      'Language Rally هو رفيقك الشامل في تعلم اللغة. قم بإنشاء حزم مفردات مخصصة، وقم بتنظيم العناصر حسب الفئات، وتدرب باستخدام نظام تكرار ذكي متباعد.';

  @override
  String get browseStore => 'تصفح المتجر';

  @override
  String get featureInteractiveTraining => 'التدريب التفاعلي';

  @override
  String get featureInteractiveTrainingDesc =>
      'تدرب على خوارزميات التعلم التكيفية';

  @override
  String get featureSmartOrganization => 'منظمة ذكية';

  @override
  String get featureSmartOrganizationDesc => 'تصنيف وتصفية المفردات الخاصة بك';

  @override
  String get featureTrackProgress => 'تتبع التقدم';

  @override
  String get featureTrackProgressDesc =>
      'مراقبة التعلم الخاص بك مع إحصائيات مفصلة';

  @override
  String get featureImportExport => 'استيراد وتصدير';

  @override
  String get featureImportExportDesc => 'مشاركة الحزم والمزامنة عبر الأجهزة';

  @override
  String get startAppTour => 'ابدأ جولة التطبيق';

  @override
  String get quickStartGuide => 'دليل البدء السريع';

  @override
  String get tourStep1Title => 'إنشاء أو استيراد الحزم';

  @override
  String get tourStep1Desc =>
      'ابدأ بإنشاء حزمة لغة جديدة أو قم باستيراد حزمة موجودة من ملف.';

  @override
  String get tourStep2Title => 'إضافة عناصر المفردات';

  @override
  String get tourStep2Desc =>
      'تصفح حزمك وأضف كلمات أو عبارات أو تعبيرات مع الأمثلة والفئات.';

  @override
  String get tourStep3Title => 'تكوين التدريب';

  @override
  String get tourStep3Desc =>
      'اختر العناصر التي تريد ممارستها، وحدد مستويات الصعوبة، وقم بتخصيص تجربة التعلم الخاصة بك.';

  @override
  String get tourStep4Title => 'ابدأ التعلم';

  @override
  String get tourStep4Desc =>
      'ابدأ جلسة التدريب الخاصة بك وقم بوضع علامة على العناصر باعتبارها معروفة أو غير معروفة لتتبع تقدمك.';

  @override
  String get tourStep5Title => 'مراجعة الإحصائيات';

  @override
  String get tourStep5Desc =>
      'تحقق من تقدمك في التعلم من خلال الإحصائيات التفصيلية وشارات الإنجاز.';

  @override
  String get gotIt => 'فهمتها!';

  @override
  String get appTourTitle => 'مرحبا بكم في رالي اللغة';

  @override
  String get appTourSubtitle => 'رفيقك الذكي والمرح والمخصص لتعلم اللغة.';

  @override
  String get tourPage1Title => 'تعلَّم ومارس ما تريد وما تحتاجه';

  @override
  String get tourPage1Desc =>
      'يضمن لك نظام التعلم التكيفي الخاص بنا مراجعة العناصر في اللحظة المثالية - مما يزيد من معدل الاحتفاظ بالعناصر ويقلل الجهد المبذول.\n\nتعلم بمساعدة الأتمتة المضمنة.\nتوقف عن إضاعة الوقت في الكلمات التي تعرفها بالفعل.\n\nتدرب فقط على المفردات والتعبيرات التي تهمك. قم بإنشاء وتدريب العناصر الخاصة بك - مصممة بالكامل لتناسب أهدافك ومستواك.';

  @override
  String get tourPage2Title => 'قم بإنشاء حزمة اللغة الخاصة بك';

  @override
  String get tourPage2Desc =>
      'أنشئ مجموعات مفردات مخصصة تتوافق مع اهتماماتك وأهدافك التعليمية.\n\nتنظيم الكلمات والتعبيرات حسب الموضوع أو الصعوبة أو السياق.\n\nالسيطرة الكاملة على ما تتعلمه ومتى.';

  @override
  String get tourPage3Title => 'إنشاء العناصر المدعومة بالذكاء الاصطناعي';

  @override
  String get tourPage3Desc =>
      'قم ببناء حزم التعلم الخاصة بك في غمضة عين:\n\n• الصق أي نص ودع الذكاء الاصطناعي يستخرج المفردات ذات الصلة تلقائيًا\n• تحديد الكلمات والتعبيرات المناسبة تماما لمستواك\n• دع الذكاء الاصطناعي يقوم بالترجمة نيابةً عنك\n• السماح لمنظمة العفو الدولية بالبحث عن أمثلة في الوقت الحقيقي\n\nالدردشة مع الذكاء الاصطناعي:\n• السماح لها باقتراح الكلمات والتعبيرات لموضوعك\n• انقر لتوليد الأمثلة وحفظها في الحزمة الخاصة بك\n• إنشاء حزم جاهزة للتدريب بسرعة';

  @override
  String get tourPage4Title =>
      'أمثلة واقعية مدعومة بالذكاء الاصطناعي وترجمة متميزة';

  @override
  String get tourPage4Desc =>
      '• البحث على الفور عن أمثلة الاستخدام الحقيقية\n• ترجمة الكلمات والتعبيرات والجمل الكاملة باستخدام تكامل DeepL عالي الجودة\n• الحصول على نتائج دقيقة واعية بالسياق';

  @override
  String get tourPage5Title => 'منظمة الحزمة الذكية';

  @override
  String get tourPage5Desc =>
      '• تنظيم المفردات في فئات مخصصة\n• تصفية والتركيز على مواضيع محددة\n• حزم الاستيراد والتصدير عبر الأجهزة\n• مشاركة الحزم بسهولة مع الآخرين';

  @override
  String get tourPage6Title => 'تدريب النطق الخاص بك';

  @override
  String get tourPage6Desc =>
      'اختبر نطقك وحسّنه باستخدام أدوات التدريب التفاعلية.\n\nبناء الثقة في التحدث – وليس القراءة فقط.';

  @override
  String get tourPage7Title => 'للمعلمين';

  @override
  String get tourPage7Desc =>
      'قم بإنشاء حزم مفردات جاهزة للاستخدام لطلابك ببضع نقرات فقط.\n\nقم بتصديرها وإرسالها إلى الفصل الدراسي الخاص بك - وبمجرد استيرادها، تصبح جاهزة على الفور للتدريب على جهاز كل طالب.\n\nبسيط. سريع. فعال.';

  @override
  String get tourPage8Title => 'أطلق العنان لدعم الذكاء الاصطناعي عالي الجودة';

  @override
  String get tourPage8Desc =>
      'للحصول على ترجمات متميزة وميزات الذكاء الاصطناعي المتقدمة، ما عليك سوى:\n 1. قم بإنشاء مفتاح DeepL API الخاص بك\n 2. قم بإنشاء مفتاح OpenAI API الخاص بك\n 3. الصق كلا المفتاحين في قسم الإعدادات\n\nوهذا لا يتطلب سوى ميزانية صغيرة (بضعة دولارات)، ولكنه يتيح لك الوصول إلى أدوات لغوية قوية واحترافية.\nملاحظة: نوصي باستخدام الوصول المدفوع لواجهة برمجة التطبيقات (API) للحصول على أفضل النتائج. لا يكلف سوى بضعة دولارات.\n\n🔑 مفتاح DeepL API: https://www.deepl.com/pro-api\n\n🔑 مفتاح OpenAI API: https://platform.openai.com/api-keys';

  @override
  String get previousPage => 'سابق';

  @override
  String get nextPage => 'التالي';

  @override
  String get endTour => 'نهاية الجولة';

  @override
  String pageIndicator(int current, int total) {
    return 'الصفحة $current من $total';
  }

  @override
  String get practicePronunciation => 'ممارسة النطق';

  @override
  String get pronunciationPractice => 'ممارسة النطق';

  @override
  String get startPractice => 'ابدأ التدريب';

  @override
  String get listenToPronunciation => 'استمع إلى النطق';

  @override
  String get tapToRecord => 'انقر للتسجيل';

  @override
  String get recording => 'تسجيل...';

  @override
  String get recorded => 'مسجلة';

  @override
  String get speakNow => 'تحدث الآن - تحدث بوضوح وعلى مقربة من الميكروفون';

  @override
  String get noSpeechDetected =>
      'لم يتم اكتشاف أي كلام. يرجى المحاولة مرة أخرى.';

  @override
  String get noTextRecognized =>
      'لم يتم التعرف على أي كلام في التسجيل. يرجى التأكد من أن الميكروفون يعمل ثم حاول مرة أخرى.';

  @override
  String get processingAudio => 'معالجة الصوت بالذكاء الاصطناعي...';

  @override
  String get playbackRecording => 'تشغيل التسجيل الخاص بي';

  @override
  String get playbackRecordingSubtitle =>
      'استمع إلى تسجيلك بينما يقوم الذكاء الاصطناعي بمعالجته';

  @override
  String get recordingTooShort =>
      'التسجيل قصير جدًا. من فضلك تحدث لمدة ثانية واحدة على الأقل.';

  @override
  String get microphonePermissionRequired =>
      'مطلوب إذن الميكروفون لممارسة النطق';

  @override
  String get speechRecognitionNotSupported =>
      'التعرف على الكلام غير مدعوم على هذا النظام الأساسي. يرجى استخدام تطبيق الهاتف المحمول (Android/iOS) لممارسة النطق.';

  @override
  String get speechRecognitionUnavailable =>
      'التعرف على الكلام غير متوفر على هذا الجهاز.';

  @override
  String get pronunciationAccuracy => 'النطق\nالدقة';

  @override
  String get excellent => 'ممتاز!';

  @override
  String get good => 'جيد';

  @override
  String get fair => 'عدل';

  @override
  String get needsImprovement => 'يحتاج إلى تحسين';

  @override
  String get tryAgain => 'حاول ثانية';

  @override
  String get nextItem => 'العنصر التالي';

  @override
  String get endPractice => 'نهاية الممارسة';

  @override
  String get practiced => 'تمارس';

  @override
  String get windowsAudioTestPageTitle => 'اختبار صوت Windows (RTAudio)';

  @override
  String get configureWindowsAudio => 'اختبار وتكوين الصوت\nالإدخال على ويندوز';

  @override
  String get configureWindowsAudioDescription =>
      'قم بتسجيل الصوت وتشغيله ونسخه باستخدام برنامج تشغيل Windows RTAudio الأصلي';

  @override
  String get audioTestTitle => 'اختبار تسجيل الصوت في ويندوز';

  @override
  String get audioTestSubtitle => 'RTAudio - تسجيل صوتي أصلي لنظام Windows';

  @override
  String get audioInputDevice => 'جهاز إدخال الصوت';

  @override
  String get selectMicrophone => 'حدد الميكروفون';

  @override
  String get refreshDevices => 'تحديث الأجهزة';

  @override
  String get noAudioDevicesFound => 'لم يتم العثور على أجهزة إدخال الصوت';

  @override
  String get loadingAudioDevices => 'جارٍ تحميل أجهزة الصوت...';

  @override
  String get recordingSettings => 'إعدادات التسجيل';

  @override
  String get stereoRecording => 'تسجيل ستيريو';

  @override
  String get stereoChannels => '2 قنوات (ستيريو)';

  @override
  String get monoChannel => '1 قناة (أحادية)';

  @override
  String get sampleRateLabel => 'معدل العينة';

  @override
  String get nativeRateBadge => 'محلي';

  @override
  String get microphoneGainLabel => 'كسب الميكروفون';

  @override
  String get gainHint =>
      '1x = لا يوجد تعزيز • 3x ≈ +9.5 ديسيبل • 10x ≈ +20 ديسيبل';

  @override
  String get tapToStartRec => 'انقر لبدء التسجيل';

  @override
  String get tapToStopRec => 'انقر لإيقاف التسجيل';

  @override
  String get recordingCompleteLabel => 'اكتمل التسجيل';

  @override
  String get tapMicToStop => 'اضغط على الميكروفون للتوقف';

  @override
  String get playRecordingLabel => 'تشغيل التسجيل';

  @override
  String get stopPlaybackLabel => 'قف';

  @override
  String get whisperSectionTitle => 'OpenAI النسخ الهمس';

  @override
  String get whisperWavNote =>
      'WAV (16 بت PCM) مدعوم أصلاً بواسطة Whisper - لا حاجة للتحويل.';

  @override
  String get sendToWhisperLabel => 'أرسل إلى الهمس';

  @override
  String get transcribingLabel => 'جارٍ النسخ...';

  @override
  String get transcriptionResultLabel => 'نتيجة النسخ';

  @override
  String get transcriptionFailedLabel => 'فشل النسخ';

  @override
  String get debugInformationLabel => 'معلومة';

  @override
  String get debugConsoleHint => 'تحقق من وحدة التحكم للحصول على سجلات مفصلة';

  @override
  String get debugDevicesFound => 'تم العثور على الأجهزة';

  @override
  String get debugSelectedDevice => 'الجهاز المحدد';

  @override
  String get debugDeviceRateNative => 'معدل الجهاز (الأصلي)';

  @override
  String get debugRequestedRate => 'السعر المطلوب';

  @override
  String get debugActualRate => 'السعر الفعلي المستخدم';

  @override
  String get debugActualRateForced => '⚠ القسري';

  @override
  String get debugActualRateOk => '✓';

  @override
  String get debugRecordingMode => 'وضع التسجيل';

  @override
  String get debugLastRecording => 'التسجيل الأخير';

  @override
  String get debugFileSize => 'حجم الملف';

  @override
  String get debugStereo => 'ستيريو';

  @override
  String get debugMono => 'كثرة الوحيدات';

  @override
  String get recordingSavedSnack => 'تم حفظ التسجيل';

  @override
  String get recordingTooShortSnack =>
      'التسجيل قصير جدًا. يرجى التسجيل لمدة ثانية واحدة على الأقل.';

  @override
  String get recordingSmallSnack => 'ملف التسجيل صغير جداً ربما فشل التسجيل.';

  @override
  String get noAudioDataSnack => 'لم يتم تسجيل أي بيانات صوتية';

  @override
  String get noDeviceSelectedSnack => 'الرجاء تحديد جهاز صوتي';

  @override
  String get failedToInitRtAudio => 'فشل في تهيئة RTAudio';

  @override
  String get envelopeScoreLabel => 'ظرف';

  @override
  String get rhythmScoreLabel => 'إيقاع';

  @override
  String get textScoreLabel => 'نص';

  @override
  String get help => 'يساعد';

  @override
  String get trainingHelpTitle => 'نصائح التدريب';

  @override
  String get trainingHelpText =>
      'لجعل التدريب الخاص بك فعالا قدر الإمكان، اتبع الخطوات التالية:\n1. انقر فوق الزر \"مسح العدادات\" بحيث يتم تمييز كافة العناصر الموجودة في هذه الحزمة على أنها معروفة.\n2. اضبط \"نطاق العنصر\" على \"جميع العناصر\"\n3. اضبط \"ترتيب العناصر\" على \"عشوائي\"\n4. اختر لغتك الأم ضمن \"لغة العرض\"\n5. ابدأ التدريب واستمر حتى تحدد حوالي 20-30 عنصرًا لا تعرفه.\n6. ارجع إلى إعدادات التدريب وقم بتغيير \"نطاق العنصر\" إلى \"العناصر غير المعروفة فقط\"\n7. استأنف التدريب واستمر حتى تتعلم جميع العناصر غير المعروفة سابقًا.';

  @override
  String get trainingProTip =>
      'نصيحة احترافية: ابدأ بجميع العناصر؛ وفي وقت لاحق، ركز فقط على المجهول.';

  @override
  String get onboardingWelcomeTitle => 'مرحبا بكم في رالي اللغة!';

  @override
  String get onboardingSetupSubtitle => 'دعونا إعداد التطبيق بالنسبة لك.';

  @override
  String get onboardingSelectUiLanguage => 'لغة الواجهة';

  @override
  String get onboardingUiLanguageNote =>
      'يمكنك تغيير هذا لاحقًا في الإعدادات → لغة واجهة المستخدم.';

  @override
  String get onboardingNext => 'التالي';

  @override
  String get onboardingBack => 'خلف';

  @override
  String get onboardingSelectPackagesTitle => 'اختر حزم اللغة';

  @override
  String get onboardingSelectPackagesSubtitle =>
      'حدد حزم المفردات المراد استيرادها. يمكنك دائمًا إضافة المزيد لاحقًا من القائمة الرئيسية (عرض الحزم).';

  @override
  String get onboardingAnalyzingPackages => 'جارٍ تحليل الحزم المتاحة…';

  @override
  String onboardingScanningPackagesProgress(
    int scanned,
    int total,
    int alreadyInDb,
  ) {
    return 'تم مسحها ضوئيًا $scanned/$total • موجودة بالفعل في قاعدة البيانات $alreadyInDb';
  }

  @override
  String get onboardingImportSelected => 'استيراد المحدد';

  @override
  String get onboardingSkipImport => 'يتخطى';

  @override
  String get onboardingSelectAll => 'حدد الكل';

  @override
  String get onboardingDeselectAll => 'قم بإلغاء تحديد الكل';

  @override
  String onboardingNPackages(int count) {
    return '$count الحزم';
  }

  @override
  String get onboardingGetStarted => 'ابدأ';

  @override
  String get onboardingImportCompleteTitle => 'اكتمل الاستيراد!';

  @override
  String get importBuiltInPkg => 'حزم مجانية';

  @override
  String get importBuiltInPkgTooltip => 'استيراد حزم اللغات المجمعة المجانية';

  @override
  String get globalSearch => 'البحث العالمي';

  @override
  String get globalSearchTitle => 'البحث عبر جميع الحزم';

  @override
  String get globalSearchSelectLanguage => 'حدد رمز اللغة';

  @override
  String get globalSearchEnterWord => 'الكلمة (الكلمات) للبحث';

  @override
  String get globalSearchEnterWordHint =>
      'على سبيل المثال \"der\"، \"order\" - يجد تطابقات جزئية';

  @override
  String get globalSearchButton => 'يبحث';

  @override
  String get globalSearchResults => 'نتائج';

  @override
  String globalSearchNoResults(String query) {
    return 'لم يتم العثور على أي نتائج \"$query\"';
  }

  @override
  String globalSearchResultsCount(int count) {
    return '$count تم العثور على النتيجة (النتائج).';
  }

  @override
  String get globalSearchSearching => 'البحث…';

  @override
  String get globalSearchSelectLanguageFirst => 'الرجاء تحديد رمز اللغة أولاً';

  @override
  String get globalSearchEnterTermFirst => 'الرجاء إدخال مصطلح البحث';

  @override
  String get globalSearchMatchInExamples => 'وجدت في الأمثلة';

  @override
  String get globalSearchViewItem => 'منظر';

  @override
  String get globalSearchGoToPackage => 'اذهب إلى الحزمة';

  @override
  String get globalSearchLoadingPackages => 'جارٍ تحميل الحزم…';

  @override
  String get globalSearchNoPackages => 'لم يتم تثبيت أي حزم لغة حتى الآن';

  @override
  String get globalSearchCancelSearch => 'إلغاء البحث';

  @override
  String globalSearchProgressOf(int current, int total) {
    return 'البحث في الحزمة $current من $total...';
  }

  @override
  String globalSearchCancelledMessage(int count) {
    return 'تم إلغاء البحث — تم العثور على $count نتيجة (نتائج) حتى الآن';
  }

  @override
  String get storeTitle => 'متجر حزمة اللغة';

  @override
  String get storeRestorePurchases => 'استعادة المشتريات';

  @override
  String get storeRefresh => 'ينعش';

  @override
  String get storeSearchHint => 'بحث عن الحزم...';

  @override
  String get storeNoPackagesMatchSearch => 'لا توجد حزم تطابق بحثك.';

  @override
  String get storeNoPackagesAvailable => 'لا توجد حزم متاحة.';

  @override
  String storeInstalledCount(int installed, int total) {
    return 'تم تثبيت $installed / $total';
  }

  @override
  String get storeLoadErrorTitle => 'لا يمكن تحميل المتجر.';

  @override
  String get storeIapNotAvailableMessage =>
      'عمليات الشراء داخل التطبيق غير متوفرة على هذا النظام الأساسي. قم بزيارة موقعنا على الانترنت لشراء الحزم.';

  @override
  String get storeOpenWebsite => 'افتح الموقع';

  @override
  String storePurchaseSuccess(String title) {
    return 'تم تثبيت $title بنجاح!';
  }

  @override
  String get storePurchaseCancelled => 'تم إلغاء الشراء.';

  @override
  String storePurchaseAlreadyOwned(String title) {
    return '$title مثبت بالفعل.';
  }

  @override
  String get storePurchaseError => 'حدث خطأ ما. يرجى المحاولة مرة أخرى.';

  @override
  String get storePurchasesRestored => 'تمت استعادة المشتريات';

  @override
  String get storeAllLevels => 'جميع المستويات';

  @override
  String get storeAllGroups => 'جميع اللغات';

  @override
  String get storeFilterLevel => 'مستوى';

  @override
  String get storeFilterLanguage => 'لغة';

  @override
  String get storeDownload => 'تحميل';

  @override
  String get storeBuy => 'يشتري';

  @override
  String get storeInstalledLabel => 'تم التثبيت';

  @override
  String get storeDownloading => 'جارٍ التنزيل…';

  @override
  String get storeRetry => 'أعد المحاولة';

  @override
  String get storeIapAndroidOnly => 'المشتريات متاحة على Android وiOS فقط.';

  @override
  String get storeDismiss => 'رفض';

  @override
  String get storeAddToCart => 'أضف إلى السلة';

  @override
  String get storeRemoveFromCart => 'يزيل';

  @override
  String get storeCartTitle => 'سلة التسوق';

  @override
  String get storeCartEmpty => 'سلة التسوق الخاصة بك فارغة';

  @override
  String get storeCartClearAll => 'مسح الكل';

  @override
  String get storeCartCheckout => 'الدفع';

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
  String get storePackageDuplicateTitle => 'الحزمة موجودة بالفعل';

  @override
  String storePackageDuplicateMessage(String packageName, String groupName) {
    return 'الحزمة \"$packageName\" موجودة بالفعل في المجموعة \"$groupName\". هل تريد الكتابة فوقه؟ سيتم حذف الحزمة الحالية وكل تقدم التدريب الخاص بها نهائيًا.';
  }

  @override
  String get storePackageDuplicateOverwrite => 'الكتابة فوق';

  @override
  String get storePackageDuplicateKeep => 'حافظ على وجودك';

  @override
  String splashSettingUpPackages(int current, int total) {
    return 'إعداد الحزم: $current / $total';
  }

  @override
  String get splashThisHappensOnce => 'وهذا يحدث مرة واحدة فقط.';

  @override
  String get splashLoading => 'تحميل…';

  @override
  String get aiItemCreator => 'منظمة العفو الدولية دردشة المعلم';

  @override
  String get aiItemCreatorAppBarHint =>
      'اجمع الكلمات والتعبيرات واحفظها من خلال الدردشة مع الذكاء الاصطناعي';

  @override
  String get chatWithAI => 'الدردشة مع منظمة العفو الدولية';

  @override
  String get enterYourPrompt => 'أدخل مطالبتك...';

  @override
  String get aiItemCreatorPromptHint =>
      'قم بوصف موضوع وسيقوم مدرب الذكاء الاصطناعي بطرح الأسئلة واقتراح مفردات مفيدة واختبار معلوماتك. على سبيل المثال: ساعدني في جمع المخاطر المتعلقة بالسفر والتدرب عليها عند المستوى المعرفي B2';

  @override
  String get send => 'يرسل';

  @override
  String get sending => 'إرسال...';

  @override
  String get aiResponse => 'استجابة الذكاء الاصطناعي';

  @override
  String get itemInputs => 'مدخلات العنصر';

  @override
  String get aiItemCreatorBothItemsRequired => 'يرجى ملء حقلي اللغة قبل الحفظ.';

  @override
  String get aiItemCreatorDuplicateItemMessage =>
      'يوجد بالفعل عنصر بنفس زوج النص في هذه الحزمة.';

  @override
  String get language1 => 'اللغة 1';

  @override
  String get language2 => 'اللغة 2';

  @override
  String get translateLang1ToLang2 => 'ترجم إلى لانج 2';

  @override
  String get translateLang2ToLang1 => 'ترجم إلى لانج 1';

  @override
  String translateToLanguageCode(String languageCode) {
    return 'ترجمة إلى $languageCode';
  }

  @override
  String get example => 'مثال';

  @override
  String get generating => 'جارٍ الإنشاء...';

  @override
  String get flags => 'أعلام';

  @override
  String get favorite => 'مفضل';

  @override
  String get saveItems => 'يحفظ';

  @override
  String get saving => 'توفير...';

  @override
  String get clearItems => 'مسح العناصر فقط';

  @override
  String get clearAll => 'مسح كافة الحقول';

  @override
  String get itemSavedSuccessfully => 'تم حفظ العنصر بنجاح';

  @override
  String get promptCannotBeEmpty => 'لا يمكن أن يكون الموجه فارغًا';

  @override
  String get enterAtLeastOneItem => 'الرجاء إدخال عنصر واحد على الأقل';

  @override
  String get selectPackageFirst => 'الرجاء تحديد الحزمة أولاً';

  @override
  String get deeplKeyRequired => 'مطلوب مفتاح DeepL API للترجمة';

  @override
  String get noNonPurchasedPackagesAvailable => 'لا تتوفر أي حزم غير مشتراة';

  @override
  String get packageSelectionRemembered => 'تم حفظ اختيار الحزمة';

  @override
  String get aiItemCreatorOpenAiKeyNotConfiguredDetailed =>
      'لم يتم تكوين مفتاح OpenAI API. الرجاء إضافة مفتاح API الخاص بك في الإعدادات.';

  @override
  String get aiItemCreatorOpenAiKeyNotConfigured =>
      'لم يتم تكوين مفتاح OpenAI API.';

  @override
  String get aiItemCreatorProcessingComplete => 'اكتملت المعالجة';

  @override
  String get aiItemCreatorTranslationComingSoon => 'ميزة الترجمة قريبا';

  @override
  String get aiItemCreatorDefaultCategoryName => 'تم إنشاء الذكاء الاصطناعي';

  @override
  String get aiItemCreatorStartNewConversation => 'ابدأ محادثة جديدة';

  @override
  String get aiItemCreatorChatHint =>
      'قم بوصف موضوع وسيقوم مدرب الذكاء الاصطناعي بطرح الأسئلة واقتراح مفردات مفيدة واختبار معلوماتك.';

  @override
  String get aiItemCreatorConversation => 'محادثة';

  @override
  String get aiItemCreatorYou => 'أنت';

  @override
  String get aiItemCreatorCoach => 'مدرب الذكاء الاصطناعي';

  @override
  String get aiItemCreatorAiSuggestions => 'اقتراحات الذكاء الاصطناعي';

  @override
  String get aiItemCreatorTapChipToFill =>
      'اضغط على شريحة لملء حقل العنصر والترجمة التلقائية.';

  @override
  String get aiItemCreatorNoSuggestedItems => 'لا توجد كلمات أو تعبيرات بعد.';

  @override
  String get aiItemCreatorNextSteps => 'كيفية الاستمرار';

  @override
  String get aiItemCreatorNoNextSteps => 'لا توجد اقتراحات استمرار حتى الآن.';

  @override
  String get aiItemCreatorModelCostTip =>
      'نصيحة احترافية: الموديلات الأحدث أكثر تكلفة، في حين أن الموديلات الأقدم والتيربو أرخص ويمكن أن تكون أسرع بشكل ملحوظ.';

  @override
  String get aiItemCreatorSelectPackageDialogTitle => 'اختر حزمة اللغة';

  @override
  String get aiItemCreatorSelectPackageDialogMessage =>
      'حدد حزمة اللغة المراد استخدامها لهذه الجلسة. تم تحديد اختيارك الأخير مسبقًا.';

  @override
  String aiItemCreatorMissingApiKeysWarning(String keys) {
    return 'مفاتيح واجهة برمجة التطبيقات المفقودة: $keys. يمكنك المتابعة، ولكن قد تكون ميزات الذكاء الاصطناعي والترجمة المتميزة محدودة.';
  }

  @override
  String get about => 'عن';

  @override
  String get aboutWebsite => 'موقع إلكتروني';

  @override
  String get aboutSummaryVideo => 'فيديو ملخص';

  @override
  String get aboutSupportEmail => 'دعم عنوان البريد الإلكتروني';

  @override
  String get aboutWebsiteUrl => 'https://sites.google.com/view/language-rally';

  @override
  String get aboutSummaryVideoUrl =>
      'https://www.youtube.com/watch?v=64Pl9iNF88c';

  @override
  String get aboutSupportEmailAddress => 'languagerally.support@gmail.com';

  @override
  String aboutVersionWithValue(String version) {
    return 'الإصدار: $version';
  }

  @override
  String aboutCouldNotOpen(String uri) {
    return 'لا يمكن فتح: $uri';
  }

  @override
  String get aboutWelcomeSplashNotFound =>
      'لم يتم العثور على صورة البداية الترحيبية';

  @override
  String get chooseTheme => 'اختر الموضوع';

  @override
  String get darkMode => 'الوضع المظلم';

  @override
  String get toggleBetweenLightAndDark => 'التبديل بين الضوء والظلام';

  @override
  String get colorTheme => 'موضوع اللون:';

  @override
  String get toggleBrightness => 'تبديل السطوع';

  @override
  String get changeTheme => 'تغيير الموضوع';

  @override
  String get managePackageGroups => 'إدارة مجموعات الحزم';

  @override
  String get noPackageGroups => 'لا توجد مجموعات الحزمة';

  @override
  String get createFirstPackageGroup =>
      'قم بإنشاء مجموعة الحزم الأولى الخاصة بك';

  @override
  String get addGroup => 'أضف مجموعة';

  @override
  String get addPackageGroup => 'إضافة مجموعة الحزمة';

  @override
  String get editPackageGroup => 'تحرير مجموعة الحزمة';

  @override
  String get groupName => 'اسم المجموعة';

  @override
  String get enterGroupName => 'أدخل اسم المجموعة';

  @override
  String get groupNameRequired => 'اسم المجموعة مطلوب';

  @override
  String get duplicateGroupName => 'اسم مكرر';

  @override
  String groupNameAlreadyExists(String name) {
    return 'توجد مجموعة بالاسم \"$name\" بالفعل.';
  }

  @override
  String groupCreatedSuccessfully(String name) {
    return 'تم إنشاء المجموعة \"$name\" بنجاح';
  }

  @override
  String failedToCreateGroup(String error) {
    return 'فشل إنشاء المجموعة: $error';
  }

  @override
  String groupRenamedTo(String name) {
    return 'تمت إعادة تسمية المجموعة إلى \"$name\"';
  }

  @override
  String failedToUpdateGroup(String error) {
    return 'فشل تحديث المجموعة: $error';
  }

  @override
  String get deleteGroup => 'حذف المجموعة';

  @override
  String deleteGroupConfirm(String name) {
    return 'هل أنت متأكد أنك تريد حذف المجموعة \"$name\"؟\n\nلا يمكن التراجع عن هذا الإجراء.';
  }

  @override
  String get cannotDeleteGroup => 'لا يمكن الحذف';

  @override
  String groupHasPackages(int count) {
    return 'لا تزال هذه المجموعة تحتوي على حزمة (حزم) $count. يرجى نقلها أو حذفها أولاً.';
  }

  @override
  String groupDeleted(String name) {
    return 'تم حذف المجموعة \"$name\".';
  }

  @override
  String failedToDeleteGroup(String error) {
    return 'فشل حذف المجموعة: $error';
  }

  @override
  String get cannotDeleteHasPackagesTooltip => 'لا يمكن الحذف (يحتوي على حزم)';

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
  String get manageGroups => 'إدارة المجموعات';

  @override
  String get featureLangPower => 'قوة اللغة';

  @override
  String get featureAiIntegration => 'تكامل الذكاء الاصطناعي';

  @override
  String get featureAdaptivePractice => 'الممارسة التكيفية';

  @override
  String get featureMasterAccent => 'لهجة رئيسية';

  @override
  String get allBadgesEarned => '🎉 جميع الشارات المكتسبة! أنت سيد!';

  @override
  String nextBadgeLabel(String name) {
    return 'التالي: $name';
  }

  @override
  String pointsToGo(String percent) {
    return '$percent% للذهاب';
  }

  @override
  String progressPercent(String percent) {
    return '$percent% تقدم';
  }

  @override
  String errorTogglingFavourite(String error) {
    return 'خطأ في تبديل المفضلة: $error';
  }

  @override
  String errorTogglingImportant(String error) {
    return 'خطأ في التبديل مهم: $error';
  }

  @override
  String categoryAdded(String name) {
    return 'تمت إضافة الفئة \"$name\".';
  }

  @override
  String errorAddingCategory(String error) {
    return 'خطأ في إضافة الفئة: $error';
  }

  @override
  String categoryRemoved(String name) {
    return 'تمت إزالة الفئة \"$name\".';
  }

  @override
  String errorRemovingCategory(String error) {
    return 'حدث خطأ أثناء إزالة الفئة: $error';
  }

  @override
  String couldNotOpenUrl(String url) {
    return 'لا يمكن فتح عنوان URL: $url';
  }

  @override
  String errorOpeningUrl(String error) {
    return 'خطأ في فتح عنوان URL: $error';
  }

  @override
  String get pleaseSelectLanguage => 'الرجاء تحديد لغة';

  @override
  String get add => 'يضيف';

  @override
  String get speak => 'يتكلم';

  @override
  String get recordingFailedToStart =>
      'فشل التسجيل في البدء!\n\nتحقق:\n1. الميكروفون متصل\n2. تم ضبط الميكروفون كجهاز افتراضي\n3. لا يوجد تطبيق آخر يستخدم الميكروفون';

  @override
  String get recordingFailedNoAudioFile =>
      'فشل التسجيل - لم يتم إنشاء ملف صوتي!\n\nالأسباب المحتملة:\n1. الميكروفون غير متصل\n2. لم يتم اكتشاف أي إدخال صوتي\n3. مشكلة إعدادات الصوت في Windows';

  @override
  String errorStartingRecordingDetails(String error) {
    return 'خطأ في بدء التسجيل: $error';
  }

  @override
  String get openaiEmptyResponse =>
      'أعاد نموذج الذكاء الاصطناعي المحدد استجابة فارغة';

  @override
  String get tryDifferentModel => 'حاول تحديد نموذج مختلف من محدد النموذج';

  @override
  String get modelMayNotBeSupported =>
      'قد لا يكون هذا النموذج مدعومًا أو متاحًا لحسابك';

  @override
  String get reduceTextOrRetry => 'قم بتقليل طول النص أو حاول مرة أخرى';

  @override
  String get openaiNullContent =>
      'لم يُرجع نموذج الذكاء الاصطناعي المحدد أي محتوى';

  @override
  String get modelUnsupportedParameter =>
      'النموذج المحدد لا يدعم معلمة API المطلوبة';
}
