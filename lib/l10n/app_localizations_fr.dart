// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get helloWorld => 'Bonjour le monde!';

  @override
  String get welcome => 'Bienvenue au Rallye des Langues';

  @override
  String get appTitle => 'Rallye des langues';

  @override
  String get createPackage => 'Créer un package';

  @override
  String get editPackage => 'Modifier le package';

  @override
  String get packageDetails => 'Détails du forfait';

  @override
  String get packageName => 'Nom du paquet';

  @override
  String get packageNameHint =>
      'par exemple, les bases de l\'espagnol, les bases de l\'allemand';

  @override
  String get languageCode1 => 'Code de langue source';

  @override
  String get languageName1 => 'Nom de la langue source';

  @override
  String get languageCode2 => 'Code de langue cible';

  @override
  String get languageName2 => 'Nom de la langue cible';

  @override
  String get description => 'Description';

  @override
  String get descriptionHint => 'Brève description de ce package linguistique';

  @override
  String get authorName => 'Nom de l\'auteur';

  @override
  String get authorEmail => 'E-mail de l\'auteur';

  @override
  String get authorWebpage => 'Page Web de l\'auteur';

  @override
  String get version => 'Version';

  @override
  String get items => 'articles';

  @override
  String get packageIcon => 'Icône de paquet';

  @override
  String get packageGroup => 'Groupe de packages';

  @override
  String get selectIcon => 'Sélectionnez l\'icône';

  @override
  String get defaultIcon => 'Icône par défaut';

  @override
  String get customIcon => 'Icône personnalisée';

  @override
  String get upload => 'Icône de téléchargement';

  @override
  String get uploadCustomIcon =>
      'Télécharger une icône personnalisée (max 512 x 512, 1 Mo)';

  @override
  String get customIconUploaded =>
      'Icône personnalisée téléchargée avec succès';

  @override
  String get save => 'Sauvegarder';

  @override
  String get edit => 'Modifier';

  @override
  String get cancel => 'Annuler';

  @override
  String get delete => 'Supprimer';

  @override
  String get confirmDelete => 'Êtes-vous sûr de vouloir supprimer ce package ?';

  @override
  String get packageSaved => 'Package enregistré avec succès';

  @override
  String get packageDeleted => 'Package supprimé avec succès';

  @override
  String get errorSavingPackage =>
      'Erreur lors de l\'enregistrement du package';

  @override
  String get errorDeletingPackage => 'Erreur lors de la suppression du package';

  @override
  String get fieldRequired => 'Ce champ est obligatoire';

  @override
  String get invalidEmail => 'Adresse e-mail invalide';

  @override
  String get readOnlyPackage =>
      'Ce package est en lecture seule et ne peut pas être modifié';

  @override
  String get purchasedPackage =>
      'Les packages achetés ne peuvent pas être modifiés';

  @override
  String get badges => 'Insignes';

  @override
  String get noBadges => 'Aucun badge gagné pour l\'instant';

  @override
  String get selectLanguageCode => 'Sélectionnez le code de langue';

  @override
  String get typeToSearchLanguages => 'Tapez pour rechercher des langues...';

  @override
  String get search => 'Recherche...';

  @override
  String get clearCounters => 'Effacer les compteurs';

  @override
  String get confirmClearCounters =>
      'Êtes-vous sûr de vouloir effacer tous les compteurs d\'entraînement pour ce package ? Cela réinitialisera les compteurs « Ne sait pas » et les statistiques d\'entraînement.';

  @override
  String get clear => 'Clair';

  @override
  String get countersCleared => 'Compteurs effacés avec succès';

  @override
  String get errorClearingCounters =>
      'Erreur lors de l\'effacement des compteurs';

  @override
  String get deleteAll => 'Supprimer le paquet';

  @override
  String get confirmDeleteAllData =>
      'Êtes-vous sûr de vouloir supprimer ce package avec TOUTES ses données ? Cela supprimera définitivement toutes les catégories, éléments et statistiques d’entraînement. Cette action est irréversible !';

  @override
  String get allDataDeleted =>
      'Package et toutes les données supprimés avec succès';

  @override
  String get exportPackage => 'Forfait d\'exportation';

  @override
  String get selectExportLocation =>
      'Sélectionnez l\'emplacement d\'exportation';

  @override
  String get packageExported => 'Package exporté avec succès';

  @override
  String get errorExportingPackage =>
      'Erreur lors de l\'exportation du package';

  @override
  String get importItems => 'Importer des éléments (JSON)';

  @override
  String get importItemsDialogTitle => 'Importer des éléments (JSON)';

  @override
  String get importItemsFromLocalJson =>
      'Importer à partir d\'un fichier JSON local';

  @override
  String get enterItemsUrl => 'URL JSON des éléments (https://…)';

  @override
  String get downloadingItems => 'Téléchargement d\'éléments…';

  @override
  String get selectImportFile => 'Sélectionnez Importer un fichier';

  @override
  String get importFormat => 'Format d\'importation';

  @override
  String get importFormatDescription =>
      'Importez des éléments à partir d’un fichier texte. Chaque ligne doit contenir un élément au format suivant :';

  @override
  String get importResults => 'Importer les résultats';

  @override
  String get successfullyImported => 'Importation réussie';

  @override
  String get failedToImport => 'Échec de l\'importation';

  @override
  String get error => 'Erreur';

  @override
  String get ok => 'D\'ACCORD';

  @override
  String get importPackage => 'Importer le package';

  @override
  String get importPackageTooltip =>
      'Importer un package à partir d\'un fichier ZIP ou d\'une URL';

  @override
  String get importPackageDialogTitle => 'Importer un package linguistique';

  @override
  String get importFromLocalFile => 'Importer à partir d\'un fichier local';

  @override
  String get importFromUrl => 'Importer depuis l\'URL';

  @override
  String get enterPackageUrl => 'URL du package (https://…)';

  @override
  String get downloadingPackage => 'Téléchargement du package…';

  @override
  String get downloadFailed =>
      'Le téléchargement a échoué. Veuillez vérifier l\'URL et votre connexion Internet.';

  @override
  String get invalidUrl =>
      'Veuillez saisir une URL http:// ou https:// valide.';

  @override
  String get orLabel => 'ou';

  @override
  String get selectPackageZipFile => 'Sélectionnez le fichier ZIP du package';

  @override
  String get couldNotAccessFile =>
      'Impossible d\'accéder au fichier sélectionné.';

  @override
  String get importingPackage => 'Importation du package...';

  @override
  String get packageImportedSuccessfully => 'Package importé avec succès !';

  @override
  String packageImportedWithItems(Object count) {
    return 'Package importé avec succès ! ($count articles)';
  }

  @override
  String packageImportedWithGroup(Object count, Object groupName) {
    return 'Package importé dans le groupe \"$groupName\" ! ($count articles)';
  }

  @override
  String get importError => 'Erreur d\'importation';

  @override
  String get failedToImportPackage => 'Échec de l\'importation du package';

  @override
  String get packageAlreadyExists => 'Le package existe déjà';

  @override
  String packageExistsMessage(Object groupName) {
    return 'Un package avec la même paire de langues, la même description, les mêmes informations sur l\'auteur et la même version existe déjà dans le groupe « $groupName ». Souhaitez-vous quand même l’importer en tant que nouveau package ?';
  }

  @override
  String get importAsNew => 'Importer quand même';

  @override
  String get zipFileNotFound => 'Fichier ZIP introuvable';

  @override
  String get invalidPackageZip =>
      'ZIP du package non valide : package_data.json manquant';

  @override
  String get invalidPackageFormat => 'Format de fichier de package invalide';

  @override
  String get languagePackages => 'Forfaits linguistiques';

  @override
  String get loadingPackages => 'Chargement des paquets...';

  @override
  String get tapAndHoldToReorder =>
      'Appuyez et maintenez pour réorganiser les cartes';

  @override
  String get tapAndHoldToReorderList =>
      'Appuyez et maintenez ≡ pour réorganiser • Appuyez sur ⋮ pour basculer en vue compacte';

  @override
  String get noPackagesYet => 'Pas encore de colis';

  @override
  String get createFirstPackage => 'Créez votre premier package linguistique';

  @override
  String get versionLabel => 'Version';

  @override
  String get purchased => 'Acheté';

  @override
  String get compactView => 'compact';

  @override
  String get expand => 'Développer';

  @override
  String get allCategories => 'Toutes les catégories';

  @override
  String get categoriesInPackage => 'Catégories de ce package';

  @override
  String get categories => 'Catégories';

  @override
  String get testInterFonts => 'Tester les polices Inter';

  @override
  String get viewPackages => 'Voir les forfaits';

  @override
  String get simplifiedPackageView => 'Liste des paquets';

  @override
  String get createNewPackage => 'Créer un nouveau package';

  @override
  String get generateTestData => 'Générer des données de test';

  @override
  String get designSystemShowcase => 'Vitrine du système de conception';

  @override
  String get badgeEarned => 'Insigne obtenu !';

  @override
  String get achievement => 'Réalisation';

  @override
  String get awesome => 'Génial!';

  @override
  String get importFormatNotes => 'Remarques :';

  @override
  String get importFormatLine1 => '• Chaque ligne représente un élément';

  @override
  String get importFormatLine2 => '• Les champs sont séparés par |';

  @override
  String get importFormatLine3 => '• Les catégories sont séparées par ;';

  @override
  String get importFormatLine4 => '• Le dernier | est facultatif';

  @override
  String get importFormatLine5 => '• Les lignes vides sont ignorées';

  @override
  String get importFormatLine6 => '• Les doublons sont ignorés';

  @override
  String get importFormatNewDescription =>
      'Importez des éléments à partir d’un fichier texte. Chaque ligne doit contenir un élément avec des champs séparés par ---';

  @override
  String get importFormatNewLine1 => '• Délimiteur principal : ---';

  @override
  String get importFormatNewLine2 =>
      '• L1=<text> - Texte principal de la langue 1 (obligatoire si la L2 est manquante)';

  @override
  String get importFormatNewLine3 =>
      '• L2=<text> - Texte principal de langue 2 (obligatoire si L1 est manquant)';

  @override
  String get importFormatNewLine4 =>
      '• L1pre=<text> - Préfixe de langue 1 (facultatif)';

  @override
  String get importFormatNewLine5 =>
      '• L1post=<text> - Suffixe de langue 1 (facultatif)';

  @override
  String get importFormatNewLine6 =>
      '• L2pre=<text> - Préfixe de langue 2 (facultatif)';

  @override
  String get importFormatNewLine7 =>
      '• L2post=<text> - Suffixe de langue 2 (facultatif)';

  @override
  String get importFormatNewLine8 =>
      '• EX=<texte L1>:::<texte L2> - Exemple (facultatif, peut être multiple)';

  @override
  String get importFormatNewLine9 =>
      '• CAT=<cat1>:::<cat2>:::<cat3> - Catégories (facultatif)';

  @override
  String get importFormatNewLine10 =>
      '• Au moins un des L1= ou L2= doit être présent.';

  @override
  String get importFormatNewLine11 => '• Les lignes vides sont ignorées';

  @override
  String get importFormatNewLine12 => '• Les doublons sont ignorés';

  @override
  String get invalidImportLine => 'Ligne invalide';

  @override
  String get missingRequiredFields => 'Il manque \'L1=\' et \'L2=\'';

  @override
  String get unknownField => 'Préfixe de champ inconnu';

  @override
  String andMore(Object count) {
    return '... et $count plus';
  }

  @override
  String get browseItems => 'Parcourir les articles';

  @override
  String get itemDetails => 'Détails';

  @override
  String get filterItems => 'Filtrer les éléments';

  @override
  String searchLanguage1(Object language) {
    return 'Rechercher dans $language';
  }

  @override
  String searchLanguage2(Object language) {
    return 'Rechercher dans $language';
  }

  @override
  String get caseSensitive => 'Sensible aux majuscules et minuscules';

  @override
  String get knownStatus => 'Statut connu';

  @override
  String get filterStatusAll => 'tous';

  @override
  String get filterStatusKnown => 'connu';

  @override
  String get filterStatusUnknown => 'inconnu';

  @override
  String get allItems => 'Tous les articles';

  @override
  String get itemsIKnew => 'Objets que je connaissais';

  @override
  String get itemsIDidNotKnow => 'Articles que je ne connaissais pas';

  @override
  String get known => 'Connu';

  @override
  String get unknown => 'Inconnu';

  @override
  String get important => 'Important';

  @override
  String get favourite => 'Préféré';

  @override
  String get badge => 'Badge';

  @override
  String get position => 'Position';

  @override
  String get stepsUntilLearned =>
      'Étapes jusqu\'à ce qu\'elles soient apprises';

  @override
  String get examples => 'Exemples';

  @override
  String get noExamples => 'Aucun exemple disponible';

  @override
  String get pronounce => 'Prononcer';

  @override
  String get ttsError => 'La synthèse vocale n\'est pas disponible';

  @override
  String get noItemsFound => 'Aucun article trouvé';

  @override
  String get noItemsInPackage =>
      'Aucun article dans ce package pour l\'instant';

  @override
  String get addItem => 'Ajouter un article';

  @override
  String get emptyPackageHint =>
      'Ajoutez des éléments manuellement ou utilisez l\'IA pour importer des éléments rapidement';

  @override
  String get noItemsToTrain =>
      'Aucun élément disponible pour la pratique avec les paramètres actuels';

  @override
  String get clearFilters => 'Clair';

  @override
  String itemCount(Object count) {
    return '$count articles';
  }

  @override
  String filteredItemCount(Object filtered, Object total) {
    return '$filtered sur $total articles';
  }

  @override
  String get trainingRally => 'Rallye d\'entraînement';

  @override
  String get startTraining => 'Commencer la formation';

  @override
  String get trainingComingSoon =>
      'Rallye d\'entraînement - Bientôt disponible !';

  @override
  String get aiServiceNotConfigured =>
      'Service IA non configuré. Veuillez ajouter votre clé API OpenAI.';

  @override
  String pleaseEnterTextInLanguageFirst(Object language) {
    return 'Veuillez d\'abord saisir le texte dans $language';
  }

  @override
  String translationCompletedSuccessfully(Object service) {
    return 'Traduction terminée avec succès avec $service !';
  }

  @override
  String get translationFailed => 'La traduction a échoué';

  @override
  String addedExamplesSuccessfully(Object count) {
    return 'Exemple(s) de $count ajouté(s) avec succès !';
  }

  @override
  String get failedToGenerateExamples => 'Échec de la génération d\'exemples';

  @override
  String get selectExamplesToAdd => 'Sélectionnez les exemples à ajouter';

  @override
  String get selectWhichExamples =>
      'Sélectionnez les exemples que vous souhaitez ajouter à cet élément :';

  @override
  String get addSelected => 'Ajouter la sélection';

  @override
  String get pleaseSelectAtLeastOne =>
      'Veuillez sélectionner au moins un exemple';

  @override
  String get addNewItem => 'Ajouter un nouvel article';

  @override
  String get editItem => 'Modifier l\'élément';

  @override
  String get deleteItem => 'Supprimer l\'élément';

  @override
  String get confirmDeleteItem =>
      'Êtes-vous sûr de vouloir supprimer cet élément ?';

  @override
  String get thisActionCannotBeUndone =>
      'Cette action ne peut pas être annulée.';

  @override
  String get itemDeleted => 'Élément supprimé';

  @override
  String get errorDeletingItem => 'Erreur lors de la suppression de l\'élément';

  @override
  String get errorSavingItem =>
      'Erreur lors de l\'enregistrement de l\'élément';

  @override
  String get itemSaved => 'Article mis à jour avec succès';

  @override
  String get itemCreated => 'Article créé avec succès';

  @override
  String get preTextOptional => 'Pré-texte (facultatif)';

  @override
  String get mainText => 'Texte principal';

  @override
  String get postTextOptional => 'Post-texte (facultatif)';

  @override
  String get forExampleToForVerbs => 'par exemple, \"to\" pour les verbes';

  @override
  String get additionalContext => 'Contexte supplémentaire';

  @override
  String get translate => 'Traduire';

  @override
  String translateFromTo(Object from, Object to) {
    return 'Traduire $from → $to';
  }

  @override
  String get aiExampleGeneration => 'Génération d\'exemples d\'IA';

  @override
  String get aiExampleSearch => 'Recherche d\'exemples d\'IA';

  @override
  String searchExamplesOnInternet(Object text) {
    return 'Recherchez des exemples de phrases sur Internet à l\'aide de l\'IA pour « $text »';
  }

  @override
  String generateExampleSentences(Object language) {
    return 'Générez des exemples de phrases basées sur le texte principal dans $language';
  }

  @override
  String get voiceInput => 'Saisie vocale';

  @override
  String get settings => 'Paramètres';

  @override
  String get uiLanguage => 'Langue de l\'interface utilisateur';

  @override
  String get uiLanguageDescription =>
      'Langue de l\'interface de l\'application';

  @override
  String get uiLanguageHelper =>
      'Sélectionnez la langue des menus, des boutons et des étiquettes';

  @override
  String get userLanguage => 'Langue de l\'utilisateur';

  @override
  String get userLanguageDescription =>
      'Votre langue maternelle préférée pour créer de nouveaux packages linguistiques';

  @override
  String get apiKeys => 'Clés API';

  @override
  String get deeplApiKey => 'Clé API DeepL';

  @override
  String get deeplApiKeyDescription =>
      'Pour une qualité de traduction supérieure lors de la modification d’éléments linguistiques. Voir https://www.deepl.com/pro-api';

  @override
  String get openaiApiKey => 'Clé API OpenAI';

  @override
  String get openaiApiKeyDescription =>
      'Par exemple la génération avec l\'IA lors de l\'édition d\'éléments de langue. Voir https://platform.openai.com/api-keys';

  @override
  String get enterApiKey => 'Saisissez la clé API';

  @override
  String get optional => 'facultatif';

  @override
  String get required => 'requis';

  @override
  String get settingsSaved => 'Paramètres enregistrés avec succès';

  @override
  String get errorSavingSettings =>
      'Erreur lors de l\'enregistrement des paramètres';

  @override
  String get usingGoogleTranslate => 'Utiliser Google Translate gratuit';

  @override
  String get usingDeepL => 'Utiliser DeepL (premium)';

  @override
  String get noTranslationReceivedFromGoogle =>
      'Aucune traduction reçue de Google';

  @override
  String get googleTranslationFailed => 'Échec de la traduction Google';

  @override
  String get googleTranslationError => 'Erreur de traduction Google';

  @override
  String get noTranslationReceivedFromDeepL =>
      'Aucune traduction reçue de DeepL';

  @override
  String get invalidDeepLApiKey => 'Clé API DeepL invalide';

  @override
  String get deeplTranslationQuotaExceeded =>
      'Quota de traduction DeepL dépassé';

  @override
  String get deeplTranslationFailed => 'La traduction DeepL a échoué';

  @override
  String get deeplTranslationError => 'Erreur de traduction DeepL';

  @override
  String get invalidApiKeyConfigureOpenAI =>
      'Clé API invalide. Veuillez configurer votre clé API OpenAI.';

  @override
  String get apiRateLimitExceeded =>
      'Limite de débit API dépassée. Veuillez réessayer plus tard.';

  @override
  String get aiRequestFailed => 'La requête IA a échoué';

  @override
  String get failedToParseAiResponse =>
      'Échec de l\'analyse de la réponse de l\'IA. Veuillez réessayer.';

  @override
  String get aiGenerationError => 'Erreur de génération d\'IA';

  @override
  String get voiceInputPlaceholder =>
      'La saisie vocale sera implémentée à l\'aide du package Speech_to_text';

  @override
  String get improveQualityWithApiKeys =>
      '💡 Astuce : La qualité des traductions et des recherches d\'exemples peut être considérablement améliorée en ajoutant vos clés API DeepL et OpenAI dans les paramètres de l\'application.';

  @override
  String get noApiKeyFallbackMessage =>
      'Sans clés API, une traduction de base et des exemples limités sont fournis. Pour de meilleurs résultats, configurez vos clés API dans Paramètres.';

  @override
  String get listeningForSpeech => 'J\'écoute... Parle maintenant';

  @override
  String get speechRecognitionNotAvailable =>
      'La reconnaissance vocale n\'est pas disponible sur cet appareil';

  @override
  String get speechRecognitionPermissionDenied =>
      'L\'autorisation de reconnaissance vocale a été refusée';

  @override
  String get speechRecognitionError => 'Erreur de reconnaissance vocale';

  @override
  String get tapToSpeak => 'Appuyez sur le microphone pour parler';

  @override
  String get tapToStop => 'Appuyez pour arrêter l\'enregistrement';

  @override
  String get speechNotRecognized =>
      'Aucun discours n\'a été reconnu. Veuillez réessayer.';

  @override
  String get usingWhisperApiSlower =>
      'Utiliser l\'IA cloud pour la reconnaissance vocale (peut être plus lent)';

  @override
  String languageNotSupportedAddApiKey(String languageCode) {
    return 'La langue $languageCode n\'est pas prise en charge nativement. Ajoutez la clé API OpenAI dans Paramètres pour la reconnaissance vocale basée sur l\'IA.';
  }

  @override
  String get recordingTapToStop =>
      'Enregistrement... Appuyez à nouveau pour arrêter';

  @override
  String get speakClearlyKeepRecording =>
      'Parlez clairement. Enregistrez au moins 1 seconde.';

  @override
  String get pleaseRecordLonger =>
      'Veuillez parler pendant au moins 1 seconde et appuyer sur Arrêter.';

  @override
  String get errorStartingRecording =>
      'Erreur lors du démarrage de l\'enregistrement';

  @override
  String get noAudioRecorded => 'Aucun son n\'a été enregistré';

  @override
  String get errorTranscribing => 'Erreur de transcription audio';

  @override
  String get trainingSettings => 'Paramètres de formation';

  @override
  String get trainingPresetTitle => 'Configuration rapide';

  @override
  String get trainingPresetHint =>
      'Choisissez un préréglage et les paramètres ci-dessous seront configurés automatiquement.';

  @override
  String get trainingPresetComboLabel => 'Préréglage';

  @override
  String get trainingPresetAllExamplesForeignLanguage =>
      'Tous les exemples, langue étrangère';

  @override
  String get trainingPresetAllExamplesRandomLanguage =>
      'Tous les exemples, langage aléatoire';

  @override
  String get trainingPresetFavouriteItemsForeignLanguage =>
      'Articles favoris, langue étrangère';

  @override
  String get trainingPresetFavouriteItemsRandomLanguage =>
      'Éléments favoris, langue aléatoire';

  @override
  String get trainingPresetImportantItemsForeignLanguage =>
      'Éléments importants, langue étrangère';

  @override
  String get trainingPresetImportantItemsRandomLanguage =>
      'Éléments importants, langue aléatoire';

  @override
  String get trainingPresetRandomItemsRandomLanguage =>
      'Objets aléatoires, langue aléatoire';

  @override
  String get trainingPresetUnknownItemsForeignLanguage =>
      'Éléments inconnus, langue étrangère';

  @override
  String get trainingPresetUnknownItemsRandomLanguage =>
      'Éléments inconnus, langue aléatoire';

  @override
  String trainingPresetAppliedTapStart(String actionLabel) {
    return 'Préréglage appliqué. Appuyez sur « $actionLabel » pour commencer.';
  }

  @override
  String get trainingPresetSelectPackageFirst =>
      'Veuillez d\'abord sélectionner un forfait.';

  @override
  String get itemScope => 'Portée de l\'article';

  @override
  String get lastNItems => 'N derniers éléments';

  @override
  String get onlyUnknown => 'Uniquement les éléments inconnus';

  @override
  String get onlyImportant => 'Uniquement les éléments importants';

  @override
  String get onlyFavourite => 'Uniquement les articles favoris';

  @override
  String get numberOfItems => 'Nombre d\'articles';

  @override
  String get itemOrder => 'Ordre des articles';

  @override
  String get randomOrder => 'Ordre aléatoire';

  @override
  String get sequentialOrder => 'Ordre séquentiel';

  @override
  String get itemType => 'Type d\'article';

  @override
  String get dictionaryItems => 'Éléments du dictionnaire';

  @override
  String get examplesType => 'Exemples';

  @override
  String get displayLanguage => 'Langue d\'affichage';

  @override
  String get motherTongue => 'Langue maternelle';

  @override
  String get targetLanguage => 'Langue cible';

  @override
  String get randomLanguage => 'Aléatoire';

  @override
  String get categoryFilter => 'Filtre de catégorie';

  @override
  String get categoryFilterHint =>
      'Sélectionnez les catégories à inclure (vide = toutes les catégories)';

  @override
  String get noCategories => 'Aucune catégorie disponible';

  @override
  String get dontKnowThreshold => 'Je ne connais pas le seuil';

  @override
  String get dontKnowThresholdHint =>
      'Nombre de fois qu\'un élément doit être marqué comme « ne sait pas » avant un traitement spécial';

  @override
  String get startTrainingRally => 'Commencer le rallye d’entraînement';

  @override
  String get clearTrainingSettings => 'Effacer les paramètres';

  @override
  String get confirmClearTrainingSettings =>
      'Êtes-vous sûr de vouloir réinitialiser tous les paramètres d\'entraînement aux valeurs par défaut ?';

  @override
  String get trainingSettingsCleared =>
      'Les paramètres d\'entraînement ont été effacés';

  @override
  String get startingTraining => 'Début de la formation...';

  @override
  String get noMoreItemsToDisplay =>
      'Aucun élément à afficher en fonction de vos paramètres de filtre.';

  @override
  String get noItems => 'Aucun article';

  @override
  String get trainingComplete => 'Formation terminée';

  @override
  String get allItemsCompleted =>
      'Félicitations! Vous avez complété tous les éléments de cette session de formation.';

  @override
  String get closeTraining => 'Fermer la formation';

  @override
  String get confirmCloseTraining =>
      'Etes-vous sûr de vouloir clôturer la formation ? Votre progression a été enregistrée.';

  @override
  String get question => 'Question';

  @override
  String get answer => 'Répondre';

  @override
  String get iKnow => 'Je sais';

  @override
  String get iDontKnow => 'Je ne sais pas';

  @override
  String get previousItem => 'Article précédent';

  @override
  String get iDidNotKnowEither => 'Je ne le savais pas après tout';

  @override
  String get exportBeforeDelete => 'Exporter avant de supprimer ?';

  @override
  String get aiTextAnalysis =>
      'Extraire des éléments d\'un texte/d\'une liste avec l\'IA';

  @override
  String get aiTextAnalysisImport =>
      'Extrayez des éléments d\'un texte ou d\'une liste avec l\'outil d\'analyse de texte AI';

  @override
  String get knowledgeLevel => 'Niveau de connaissance';

  @override
  String get a1Beginner => 'A1 - Débutant';

  @override
  String get a2Elementary => 'A2 - Élémentaire';

  @override
  String get b1Intermediate => 'B1 - Intermédiaire';

  @override
  String get b2UpperIntermediate => 'B2 - Intermédiaire supérieur';

  @override
  String get c1Advanced => 'C1 - Avancé';

  @override
  String get c2Proficient => 'C2 - Compétent';

  @override
  String get pasteTextHere => 'Collez votre texte ici...';

  @override
  String get extractWords => 'Extraire des mots';

  @override
  String get extractExpressions => 'Extraire des expressions';

  @override
  String get maxItems => 'Nombre maximum de nouveaux articles';

  @override
  String get maxItemsHint => 'Laisser vide sans limite';

  @override
  String get generateExamples => 'Générer des exemples';

  @override
  String get categoryName => 'Nom de la catégorie';

  @override
  String get categoryNameHint => 'Nom de la catégorie des éléments importés';

  @override
  String get analyzeText => 'Analyser le texte';

  @override
  String get configureAnalysis => 'Configurer les éléments à extraire';

  @override
  String get openaiModel => 'Modèle d\'IA';

  @override
  String get openaiModelDescription => 'Sélectionnez le modèle ChatGPT';

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
      'Le nouvel équilibre phare entre qualité et vitesse pour un usage général';

  @override
  String get modelGpt55ProDesc =>
      'Variante GPT-5.5 la plus haut de gamme pour un raisonnement et une qualité les plus solides';

  @override
  String get modelGpt54Desc =>
      'Modèle puissant de génération GPT-5 à usage général';

  @override
  String get modelGpt54ProDesc =>
      'Variante GPT-5.4 à plus grande capacité pour les tâches exigeantes';

  @override
  String get modelGpt54MiniDesc =>
      'Variante GPT-5.4 plus petite et plus rapide pour les tâches quotidiennes moins coûteuses';

  @override
  String get modelGpt5MiniDesc =>
      'Modèle compact de la famille GPT-5 optimisé pour la vitesse et le coût';

  @override
  String get modelGpt41Desc =>
      'Option GPT-4.1 fiable pour la compatibilité et une qualité solide';

  @override
  String get modelGpt4o => 'GPT-4o';

  @override
  String get modelGpt35Turbo => 'GPT-3.5 Turbo (héritage, budget)';

  @override
  String get modelGpt35Turbo16k => 'GPT-3.5 Turbo 16K';

  @override
  String get modelGpt4 => 'GPT-4';

  @override
  String get modelGpt4Turbo => 'GPT-4 Turbo (ancien)';

  @override
  String get modelGpt4oDesc =>
      'Meilleur choix à usage général ; qualité rapide, multimodale et forte';

  @override
  String get modelGpt35TurboDesc =>
      'Ancienne option à faible coût ; utile pour les tâches plus simples et les utilisations sensibles aux coûts';

  @override
  String get modelGpt35Turbo16kDesc =>
      'Identique à GPT-3.5, mais fenêtre contextuelle de jeton de 16 Ko';

  @override
  String get modelGpt4Desc =>
      'Haute qualité de raisonnement ; généralement plus lent et plus cher';

  @override
  String get modelGpt4TurboDesc =>
      'Option de la famille GPT-4 héritée ; toujours utile lorsque vous souhaitez une alternative plus ancienne et moins chère';

  @override
  String get analyzing => 'Analyser...';

  @override
  String get languageDetected => 'Langue détectée';

  @override
  String get itemsFound => 'Objets trouvés';

  @override
  String get selectItemsToImport => 'Sélectionnez les éléments à importer';

  @override
  String get selectAll => 'Sélectionner tout';

  @override
  String get deselectAll => 'Désélectionner tout';

  @override
  String get importSelected => 'Importer la sélection';

  @override
  String get importing => 'Importation...';

  @override
  String get itemsImported => 'Articles importés avec succès';

  @override
  String get noItemsSelected => 'Aucun élément sélectionné';

  @override
  String get textCannotBeEmpty => 'Le texte ne peut pas être vide';

  @override
  String get selectAtLeastOneType =>
      'Sélectionnez au moins un type (mots ou expressions)';

  @override
  String get languageNotMatching =>
      'La langue détectée ne correspond à aucune langue du package';

  @override
  String get openaiKeyRequired =>
      'La clé API OpenAI est requise pour cette fonctionnalité';

  @override
  String analyzingProgress(Object current, Object total) {
    return 'Analyse : $current / $total';
  }

  @override
  String translatingProgress(Object current, Object total) {
    return 'Traduction : $current / $total';
  }

  @override
  String get duplicate => 'Double';

  @override
  String importProgress(Object current, Object total) {
    return 'Importation de $current de $total';
  }

  @override
  String get detectingLanguage => 'Détection de la langue...';

  @override
  String get extractingItems => 'Extraction d\'éléments...';

  @override
  String get checkingDuplicates => 'Vérification des doublons...';

  @override
  String get translating => 'Traduire...';

  @override
  String get generatingExamples => 'Générer des exemples...';

  @override
  String get errorAnalyzingText => 'Erreur lors de l\'analyse du texte';

  @override
  String get errorImportingItems =>
      'Erreur lors de l\'importation des éléments';

  @override
  String get warning => 'Avertissement';

  @override
  String get textIsVeryLarge => 'Le texte est très grand';

  @override
  String get words => 'mots';

  @override
  String get continueAnalysis =>
      'Le traitement peut prendre plus de temps et sera analysé en morceaux. Voulez-vous continuer';

  @override
  String get continueLabel => 'Continuer';

  @override
  String get exportBeforeDeleteMessage =>
      'Souhaitez-vous exporter ce package avant de le supprimer ? Cela enregistrera toutes vos données dans un fichier ZIP.';

  @override
  String get deleteWithoutExport => 'Supprimer sans exporter';

  @override
  String get exportAndDelete => 'Exporter et supprimer';

  @override
  String get exportingPackage => 'Exportation du package...';

  @override
  String packageExportedToPath(Object path) {
    return 'Package exporté vers : $path';
  }

  @override
  String errorLoadingItems(Object error) {
    return 'Erreur lors du chargement des éléments : $error';
  }

  @override
  String badgeEarnedWithName(Object badgeName) {
    return 'Insigne obtenu : $badgeName !';
  }

  @override
  String badgeLostWithName(Object badgeName) {
    return 'Badge perdu : $badgeName';
  }

  @override
  String get trainingSessionProgress =>
      'Statistiques des sessions de formation';

  @override
  String get total => 'Total';

  @override
  String lastNValue(Object value) {
    return 'N = $value';
  }

  @override
  String errorLoadingSettings(Object error) {
    return 'Erreur de chargement des paramètres : $error';
  }

  @override
  String get selectPackage => 'Sélectionnez le forfait';

  @override
  String get noPackagesAvailable => 'Aucun forfait disponible';

  @override
  String get possibleSolutions => 'Solutions possibles';

  @override
  String get technicalDetails => 'Détails techniques';

  @override
  String get close => 'Fermer';

  @override
  String get checkApiKey => 'Vérifiez votre clé API OpenAI';

  @override
  String get ensureValidOpenAIKey =>
      'Assurez-vous que la clé API est valide et active';

  @override
  String get verifyKeyInSettings => 'Vérifiez la clé dans Paramètres';

  @override
  String get rateLimitExceeded => 'Limite de débit API dépassée';

  @override
  String get waitAndRetry => 'Attendez quelques minutes et réessayez';

  @override
  String get checkAccountQuota => 'Vérifiez le quota de votre compte OpenAI';

  @override
  String get invalidRequest => 'Format de demande invalide';

  @override
  String get tryReducingTextLength => 'Essayez de réduire la longueur du texte';

  @override
  String get checkTextFormat => 'Vérifiez que le format du texte est correct';

  @override
  String get checkInternetConnection => 'Vérifiez votre connexion Internet';

  @override
  String get retryInMoment => 'Réessayez dans un instant';

  @override
  String get checkFirewall => 'Vérifiez les paramètres du pare-feu';

  @override
  String get textMayBeTooShort => 'Le texte est peut-être trop court';

  @override
  String get tryDifferentKnowledgeLevel =>
      'Essayez un autre niveau de connaissances';

  @override
  String get ensureTextInCorrectLanguage =>
      'Assurez-vous que le texte est dans la bonne langue';

  @override
  String get requestTimedOut => 'La demande a expiré';

  @override
  String get textMayBeTooLong => 'Le texte est peut-être trop long';

  @override
  String get tryAgainOrReduceSize => 'Réessayez ou réduisez la taille du texte';

  @override
  String get unexpectedError => 'Une erreur inattendue s\'est produite';

  @override
  String get checkErrorDetails =>
      'Vérifiez les détails de l\'erreur ci-dessous';

  @override
  String get tryAgainLater => 'Réessayez plus tard';

  @override
  String get translationServiceFailed => 'Le service de traduction a échoué';

  @override
  String get checkApiKeys => 'Vérifiez vos clés API (DeepL, OpenAI)';

  @override
  String get retryImport => 'Réessayez l\'importation';

  @override
  String get exampleGenerationFailed => 'La génération de l\'exemple a échoué';

  @override
  String get itemsStillImported => 'Les articles étaient toujours importés';

  @override
  String get canAddExamplesManually =>
      'Vous pourrez ajouter des exemples manuellement plus tard';

  @override
  String get databaseError => 'Une erreur de base de données s\'est produite';

  @override
  String get checkStorageSpace => 'Vérifier l\'espace de stockage disponible';

  @override
  String get restartApp => 'Essayez de redémarrer l\'application';

  @override
  String get groupLabel => 'Groupe:';

  @override
  String get amendGroups => 'Modifier';

  @override
  String get exportItemsJson => 'Exporter des éléments (JSON)';

  @override
  String get exportItemsJsonTooltip =>
      'Exporter tous les éléments sous forme de fichier JSON';

  @override
  String get noCategoriesInPackage =>
      'Aucune catégorie trouvée dans ce package';

  @override
  String get noItemsToExport => 'Aucun article trouvé à exporter';

  @override
  String itemsExportedSuccessfully(int count, String path) {
    return 'Exportation réussie des éléments $count vers :\n$path';
  }

  @override
  String get errorExportingItems =>
      'Erreur lors de l\'exportation des éléments';

  @override
  String get languageMismatch => 'Inadéquation de la langue';

  @override
  String get languageMismatchDescription =>
      'Les langues du fichier JSON ne correspondent pas aux langues du package :';

  @override
  String packageLanguages(String lang1, String lang2) {
    return 'Forfait : $lang1 → $lang2';
  }

  @override
  String jsonFileLanguages(String lang1, String lang2) {
    return 'Fichier JSON : $lang1 → $lang2';
  }

  @override
  String get continueImportQuestion =>
      'Voulez-vous quand même continuer l’importation ?';

  @override
  String get continueImport => 'Continuer l\'importation';

  @override
  String get pleaseSelectPackageGroup =>
      'Veuillez sélectionner un groupe de forfaits';

  @override
  String get customIconLabel => 'Coutume';

  @override
  String get defaultIconLabel => 'Défaut';

  @override
  String get icon2Label => 'Livre ouvert';

  @override
  String get icon3Label => 'Livre coloré';

  @override
  String get icon4Label => 'Conversation';

  @override
  String get icon5Label => 'Graduation';

  @override
  String get icon6Label => 'Cerveau';

  @override
  String get icon7Label => 'Pile de livres';

  @override
  String get icon8Label => 'Flashcard';

  @override
  String get icon9Label => 'Globe';

  @override
  String get icon10Label => 'Crayon';

  @override
  String get icon11Label => 'Trophée';

  @override
  String get icon12Label => 'Recherche';

  @override
  String get customIconFile => 'Icône personnalisée';

  @override
  String get importedIconFile => 'Icône importée';

  @override
  String get unableToReadImageFile =>
      'Impossible de lire le fichier image. Veuillez sélectionner une image valide.';

  @override
  String iconDimensionsTooLarge(int width, int height) {
    return 'Les dimensions des icônes sont trop grandes (${width}x$height). La taille maximale autorisée est de 512 x 512 pixels.';
  }

  @override
  String get iconFileTooLarge =>
      'Le fichier d\'icône est trop volumineux. La taille maximale est de 1 Mo.';

  @override
  String failedToUploadIcon(String error) {
    return 'Échec du téléchargement de l\'icône : $error';
  }

  @override
  String get pleaseSelectValidLanguage =>
      'Veuillez sélectionner une langue valide dans la liste';

  @override
  String get status => 'Statut';

  @override
  String get addExample => 'Ajouter un exemple';

  @override
  String get noExamplesYet =>
      'Aucun exemple pour l\'instant. Cliquez sur + pour ajouter.';

  @override
  String get speakText => 'Parler du texte';

  @override
  String get removeCategory => 'Supprimer la catégorie';

  @override
  String removeCategoryConfirm(String categoryName) {
    return 'Supprimer la catégorie « $categoryName » de cet élément ?';
  }

  @override
  String get remove => 'Retirer';

  @override
  String get extractFullItems => 'Extraire les éléments complets';

  @override
  String get pasteFromClipboard => 'Coller depuis le presse-papiers';

  @override
  String get noItemsFoundOrAllDuplicates =>
      'Aucun élément trouvé dans le texte, ou tous les éléments existent déjà dans le package';

  @override
  String get aboutLanguageRally => 'À propos du Rallye des Langues';

  @override
  String get welcomeTitle => '🚀 Bienvenue au Rallye des Langues';

  @override
  String get welcomeSubtitle =>
      'Libérez l\'incroyable puissance de l\'apprentissage des langues avec environ 4 000 mots, 4 000 expressions et autant d\'exemples de phrases, soigneusement sélectionnés pour chaque niveau de compétence ! Utilisez l\'IA pour importer des éléments de vos propres textes ou discutez avec l\'IA sur n\'importe quel sujet pour générer les mots, expressions et exemples exacts que vous souhaitez apprendre.\nAméliorez vos compétences linguistiques, de manière intelligente et ludique !';

  @override
  String get welcomeIntro =>
      'Apprenez efficacement le vocabulaire et les expressions en pratiquant ce qui vous intéresse réellement. Pas de listes ennuyeuses. Pas de temps perdu.';

  @override
  String get sectionPlayYourGame => '🎮 Jouez à votre propre jeu';

  @override
  String get sectionPlayYourGameDesc =>
      'Créez vos propres packages de vocabulaire. Entraînez-vous uniquement les mots et expressions que vous souhaitez maîtriser. Vous le savez déjà ? Il sera marqué et ignoré !';

  @override
  String get sectionAITeammate => '🤖 L\'IA comme coéquipier';

  @override
  String get sectionAITeammateDesc =>
      'Collez n\'importe quel texte et laissez AI :\n• Extraire le vocabulaire utile\n• Choisissez des expressions qui correspondent à votre niveau\n• Créez des packages prêts à former en quelques secondes\n\nDiscutez avec l\'IA :\n• Laissez-le suggérer des mots et des expressions pour votre sujet\n• Cliquez pour générer des exemples et les enregistrer dans votre PROPRE package.';

  @override
  String get sectionTrainSmart => '🔁 Entraînez-vous intelligemment';

  @override
  String get sectionTrainSmartDesc =>
      'Notre système de répétition affiné affiche les éléments exactement au moment où votre cerveau en a besoin afin de les mémoriser efficacement. Progrès maximal. Effort minimal.';

  @override
  String get sectionRealExamples =>
      '🌍 Exemples réels. Excellentes traductions.';

  @override
  String get sectionRealExamplesDesc =>
      'Obtenez des exemples d\'utilisation concrets. Traduisez avec une qualité premium via DeepL. Entraînez-vous à prononcer et ayez l’air confiant.';

  @override
  String get sectionTeachersWelcome => '👩‍🏫 Bienvenue aux enseignants';

  @override
  String get sectionTeachersWelcomeDesc =>
      'Créez un package → Copiez et collez des éléments ou extrayez, traduisez, ajoutez des exemples avec l\'IA → Exporter → Télécharger/Envoyer → Terminé. Vos élèves l\'importent et commencent à s\'entraîner instantanément.';

  @override
  String get sectionUnlockAI => '🔑 Débloquez toute la puissance de l\'IA';

  @override
  String get sectionUnlockAIDesc =>
      'Pour une traduction de haute qualité et des fonctionnalités d’IA, il suffit :\n\n1. Créez votre clé API DeepL\n   https://www.deepl.com/pro-api\n2. Créez votre clé API OpenAI\n   https://platform.openai.com/api-keys\n3. Collez les deux clés dans Paramètres\n\nUn petit investissement débloque des outils linguistiques puissants et de qualité professionnelle. Pourquoi voudriez-vous le manquer ?\n(Nous vous recommandons d\'utiliser l\'accès API payant pour de meilleurs résultats.)';

  @override
  String get readyToStart => 'Prêt à démarrer votre rallye ? 🏁';

  @override
  String get welcomeDescription =>
      'Language Rally est votre compagnon complet d’apprentissage des langues. Créez des packages de vocabulaire personnalisés, organisez les éléments par catégories et entraînez-vous avec un système de répétition espacé intelligent.';

  @override
  String get browseStore => 'Parcourir la boutique';

  @override
  String get featureInteractiveTraining => 'Formation interactive';

  @override
  String get featureInteractiveTrainingDesc =>
      'Entraînez-vous avec des algorithmes d’apprentissage adaptatif';

  @override
  String get featureSmartOrganization => 'Organisation intelligente';

  @override
  String get featureSmartOrganizationDesc =>
      'Catégorisez et filtrez votre vocabulaire';

  @override
  String get featureTrackProgress => 'Suivre les progrès';

  @override
  String get featureTrackProgressDesc =>
      'Surveillez votre apprentissage avec des statistiques détaillées';

  @override
  String get featureImportExport => 'Importation et exportation';

  @override
  String get featureImportExportDesc =>
      'Partagez des packages et synchronisez-les sur tous les appareils';

  @override
  String get startAppTour => 'Démarrer la visite guidée de l\'application';

  @override
  String get quickStartGuide => 'Guide de démarrage rapide';

  @override
  String get tourStep1Title => 'Créer ou importer des packages';

  @override
  String get tourStep1Desc =>
      'Commencez par créer un nouveau package linguistique ou importez-en un existant à partir d’un fichier.';

  @override
  String get tourStep2Title => 'Ajouter des éléments de vocabulaire';

  @override
  String get tourStep2Desc =>
      'Parcourez vos packages et ajoutez des mots, des phrases ou des expressions avec des exemples et des catégories.';

  @override
  String get tourStep3Title => 'Configurer la formation';

  @override
  String get tourStep3Desc =>
      'Choisissez les éléments à pratiquer, définissez les niveaux de difficulté et personnalisez votre expérience d\'apprentissage.';

  @override
  String get tourStep4Title => 'Commencer à apprendre';

  @override
  String get tourStep4Desc =>
      'Commencez votre séance d’entraînement et marquez les éléments comme connus ou inconnus pour suivre vos progrès.';

  @override
  String get tourStep5Title => 'Examiner les statistiques';

  @override
  String get tourStep5Desc =>
      'Vérifiez vos progrès d\'apprentissage avec des statistiques détaillées et des badges de réussite.';

  @override
  String get gotIt => 'J\'ai compris!';

  @override
  String get appTourTitle => 'Bienvenue au Rallye des Langues';

  @override
  String get appTourSubtitle =>
      'Votre compagnon d\'apprentissage des langues intelligent, ludique et entièrement personnalisé.';

  @override
  String get tourPage1Title =>
      'Apprenez et pratiquez ce que vous voulez et ce dont vous avez besoin';

  @override
  String get tourPage1Desc =>
      'Notre système d\'apprentissage adaptatif garantit que vous révisez les éléments au moment idéal, maximisant ainsi la rétention et minimisant les efforts.\n\nApprenez à l’aide de l’automatisation intégrée.\nArrêtez de perdre du temps avec des mots que vous connaissez déjà.\n\nPratiquez uniquement le vocabulaire et les expressions qui vous intéressent. Créez et entraînez vos propres objets, entièrement adaptés à vos objectifs et à votre niveau.';

  @override
  String get tourPage2Title => 'Créez votre propre package linguistique';

  @override
  String get tourPage2Desc =>
      'Créez des collections de vocabulaire personnalisées qui correspondent à vos intérêts et à vos objectifs d\'apprentissage.\n\nOrganisez les mots et les expressions par sujet, difficulté ou contexte.\n\nContrôle total sur ce que vous apprenez et quand.';

  @override
  String get tourPage3Title => 'Création d\'objets alimentés par l\'IA';

  @override
  String get tourPage3Desc =>
      'Construisez vos propres packages d’apprentissage en un clin d’œil :\n\n• Collez n\'importe quel texte et laissez l\'IA extraire automatiquement le vocabulaire pertinent\n• Identifiez les mots et expressions parfaitement adaptés à votre niveau\n• Laissez l\'IA faire la traduction pour vous\n• Laissez l\'IA rechercher des exemples en temps réel\n\nDiscutez avec l\'IA :\n• Laissez-le suggérer des mots et des expressions pour votre sujet\n• Cliquez pour générer des exemples et les enregistrer dans votre PROPRE package.\n• Créez rapidement des packages prêts pour la formation';

  @override
  String get tourPage4Title =>
      'Exemples concrets basés sur l\'IA et traduction premium';

  @override
  String get tourPage4Desc =>
      '• Recherchez instantanément des exemples d\'utilisation authentiques\n• Traduisez des mots, des expressions et des phrases complètes avec une intégration DeepL de haute qualité\n• Obtenez des résultats précis et contextuels';

  @override
  String get tourPage5Title => 'Organisation intelligente des packages';

  @override
  String get tourPage5Desc =>
      '• Organisez le vocabulaire en catégories personnalisées\n• Filtrer et se concentrer sur des sujets spécifiques\n• Importer et exporter des packages sur tous les appareils\n• Partagez facilement des packages avec d\'autres';

  @override
  String get tourPage6Title => 'Entraîner votre prononciation';

  @override
  String get tourPage6Desc =>
      'Testez et améliorez votre prononciation avec des outils de pratique interactifs.\n\nDéveloppez la confiance en vous pour parler, pas seulement pour lire.';

  @override
  String get tourPage7Title => 'Pour les enseignants';

  @override
  String get tourPage7Desc =>
      'Créez des packages de vocabulaire prêts à l\'emploi pour vos élèves en quelques clics seulement.\n\nExportez-les, envoyez-les à votre classe et une fois importés, ils sont instantanément prêts à être utilisés sur l\'appareil de chaque élève.\n\nSimple. Rapide. Efficace.';

  @override
  String get tourPage8Title =>
      'Débloquez une prise en charge de l\'IA de haute qualité';

  @override
  String get tourPage8Desc =>
      'Pour des traductions premium et des fonctionnalités avancées d’IA, il suffit :\n 1. Créez votre propre clé API DeepL\n 2. Créez votre propre clé API OpenAI\n 3. Collez les deux clés dans la section Paramètres\n\nCela ne nécessite qu’un petit budget (quelques dollars), mais vous donne accès à des outils linguistiques puissants et de qualité professionnelle.\nRemarque : Nous vous recommandons d\'utiliser un accès API payant pour de meilleurs résultats. Cela ne coûte que quelques dollars.\n\n🔑 Clé API DeepL : https://www.deepl.com/pro-api\n\n🔑 Clé API OpenAI : https://platform.openai.com/api-keys';

  @override
  String get previousPage => 'Précédent';

  @override
  String get nextPage => 'Suivant';

  @override
  String get endTour => 'Fin de la visite';

  @override
  String pageIndicator(int current, int total) {
    return 'Page $current de $total';
  }

  @override
  String get practicePronunciation => 'Pratiquer la prononciation';

  @override
  String get pronunciationPractice => 'Pratique de la prononciation';

  @override
  String get startPractice => 'Commencer la pratique';

  @override
  String get listenToPronunciation => 'Écouter la prononciation';

  @override
  String get tapToRecord => 'Appuyez pour enregistrer';

  @override
  String get recording => 'Enregistrement...';

  @override
  String get recorded => 'Enregistré';

  @override
  String get speakNow =>
      'Parlez maintenant - parlez clairement et près du microphone';

  @override
  String get noSpeechDetected => 'Aucune parole détectée. Veuillez réessayer.';

  @override
  String get noTextRecognized =>
      'Aucun discours n\'a été reconnu dans l\'enregistrement. Veuillez vous assurer que votre microphone fonctionne et réessayez.';

  @override
  String get processingAudio => 'Traitement de l\'audio avec l\'IA...';

  @override
  String get playbackRecording => 'Lire mon enregistrement';

  @override
  String get playbackRecordingSubtitle =>
      'Écoutez votre enregistrement pendant que l\'IA le traite';

  @override
  String get recordingTooShort =>
      'Enregistrement trop court. Veuillez parler pendant au moins 1 seconde.';

  @override
  String get microphonePermissionRequired =>
      'L\'autorisation du microphone est requise pour la pratique de la prononciation';

  @override
  String get speechRecognitionNotSupported =>
      'La reconnaissance vocale n\'est pas prise en charge sur cette plateforme. Veuillez utiliser l\'application mobile (Android/iOS) pour vous entraîner à la prononciation.';

  @override
  String get speechRecognitionUnavailable =>
      'La reconnaissance vocale n\'est pas disponible sur cet appareil.';

  @override
  String get pronunciationAccuracy => 'Prononciation\nPrécision';

  @override
  String get excellent => 'Excellent!';

  @override
  String get good => 'Bien';

  @override
  String get fair => 'Équitable';

  @override
  String get needsImprovement => 'Besoin d\'amélioration';

  @override
  String get tryAgain => 'Essayer à nouveau';

  @override
  String get nextItem => 'Article suivant';

  @override
  String get endPractice => 'Fin de la pratique';

  @override
  String get practiced => 'Exercé';

  @override
  String get windowsAudioTestPageTitle => 'Test audio Windows (RTAudio)';

  @override
  String get configureWindowsAudio =>
      'Tester et configurer l\'audio\nsaisie sous Windows';

  @override
  String get configureWindowsAudioDescription =>
      'Enregistrez, lisez et transcrivez l\'audio à l\'aide du pilote natif Windows RTAudio';

  @override
  String get audioTestTitle => 'Test d\'enregistrement audio Windows';

  @override
  String get audioTestSubtitle =>
      'RTAudio — Enregistrement audio natif Windows';

  @override
  String get audioInputDevice => 'Périphérique d\'entrée audio';

  @override
  String get selectMicrophone => 'Sélectionnez le microphone';

  @override
  String get refreshDevices => 'Actualiser les appareils';

  @override
  String get noAudioDevicesFound => 'Aucun périphérique d\'entrée audio trouvé';

  @override
  String get loadingAudioDevices => 'Chargement des périphériques audio...';

  @override
  String get recordingSettings => 'Paramètres d\'enregistrement';

  @override
  String get stereoRecording => 'Enregistrement stéréo';

  @override
  String get stereoChannels => '2 canaux (stéréo)';

  @override
  String get monoChannel => '1 canal (mono)';

  @override
  String get sampleRateLabel => 'Taux d\'échantillonnage';

  @override
  String get nativeRateBadge => 'indigène';

  @override
  String get microphoneGainLabel => 'Gain du microphone';

  @override
  String get gainHint => '1x = pas de boost • 3x ≈ +9,5 dB • 10x ≈ +20 dB';

  @override
  String get tapToStartRec => 'Appuyez pour démarrer l\'enregistrement';

  @override
  String get tapToStopRec => 'Appuyez pour arrêter l\'enregistrement';

  @override
  String get recordingCompleteLabel => 'Enregistrement terminé';

  @override
  String get tapMicToStop => 'Appuyez sur le microphone pour arrêter';

  @override
  String get playRecordingLabel => 'Lire l\'enregistrement';

  @override
  String get stopPlaybackLabel => 'Arrêt';

  @override
  String get whisperSectionTitle => 'Transcription chuchotée d\'OpenAI';

  @override
  String get whisperWavNote =>
      'WAV (PCM 16 bits) est pris en charge nativement par Whisper — aucune conversion n\'est nécessaire.';

  @override
  String get sendToWhisperLabel => 'Envoyer à Whisper';

  @override
  String get transcribingLabel => 'Transcription...';

  @override
  String get transcriptionResultLabel => 'Résultat de la transcription';

  @override
  String get transcriptionFailedLabel => 'Échec de la transcription';

  @override
  String get debugInformationLabel => 'Information';

  @override
  String get debugConsoleHint =>
      'Vérifiez la console pour les journaux détaillés';

  @override
  String get debugDevicesFound => 'Appareils trouvés';

  @override
  String get debugSelectedDevice => 'Appareil sélectionné';

  @override
  String get debugDeviceRateNative => 'Débit de l\'appareil (natif)';

  @override
  String get debugRequestedRate => 'Tarif demandé';

  @override
  String get debugActualRate => 'Taux réel utilisé';

  @override
  String get debugActualRateForced => '⚠ forcé';

  @override
  String get debugActualRateOk => '✓';

  @override
  String get debugRecordingMode => 'Mode d\'enregistrement';

  @override
  String get debugLastRecording => 'Dernier enregistrement';

  @override
  String get debugFileSize => 'Taille du fichier';

  @override
  String get debugStereo => 'Stéréo';

  @override
  String get debugMono => 'Mono';

  @override
  String get recordingSavedSnack => 'Enregistrement sauvegardé';

  @override
  String get recordingTooShortSnack =>
      'L\'enregistrement est trop court. Veuillez enregistrer pendant au moins 1 seconde.';

  @override
  String get recordingSmallSnack =>
      'Le fichier d\'enregistrement est très petit. L\'enregistrement a peut-être échoué.';

  @override
  String get noAudioDataSnack => 'Aucune donnée audio enregistrée';

  @override
  String get noDeviceSelectedSnack =>
      'Veuillez sélectionner un périphérique audio';

  @override
  String get failedToInitRtAudio => 'Échec de l\'initialisation de RTAudio';

  @override
  String get envelopeScoreLabel => 'Enveloppe';

  @override
  String get rhythmScoreLabel => 'Rythme';

  @override
  String get textScoreLabel => 'Texte';

  @override
  String get help => 'Aide';

  @override
  String get trainingHelpTitle => 'Conseils de formation';

  @override
  String get trainingHelpText =>
      'Pour rendre votre formation aussi efficace que possible, suivez ces étapes :\n1. Cliquez sur le bouton « Effacer les compteurs » pour que tous les éléments de ce package soient marqués comme connus.\n2. Définissez « Portée de l\'élément » sur « Tous les éléments »\n3. Définissez « Ordre des articles » sur « Aléatoire »\n4. Choisissez votre langue maternelle sous « Langue d\'affichage »\n5. Démarrez la formation et continuez jusqu\'à ce que vous identifiiez environ 20 à 30 éléments que vous ne connaissez pas.\n6. Revenez aux paramètres de formation et modifiez « Portée de l\'élément » par « Uniquement les éléments inconnus ».\n7. Reprenez l\'entraînement et continuez jusqu\'à ce que vous ayez appris tous les éléments précédemment inconnus.';

  @override
  String get trainingProTip =>
      'Conseil de pro : commencez par tous les éléments ; plus tard, concentrez-vous uniquement sur les inconnues.';

  @override
  String get onboardingWelcomeTitle => 'Bienvenue au Rallye des Langues !';

  @override
  String get onboardingSetupSubtitle => 'Configurons l\'application pour vous.';

  @override
  String get onboardingSelectUiLanguage => 'Langue de l\'interface';

  @override
  String get onboardingUiLanguageNote =>
      'Vous pouvez modifier cela plus tard dans Paramètres → Langue de l\'interface utilisateur.';

  @override
  String get onboardingNext => 'Suivant';

  @override
  String get onboardingBack => 'Dos';

  @override
  String get onboardingSelectPackagesTitle =>
      'Choisissez les packages linguistiques';

  @override
  String get onboardingSelectPackagesSubtitle =>
      'Sélectionnez les packages de vocabulaire à importer. Vous pouvez toujours en ajouter plus ultérieurement à partir du menu principal (Afficher les packages).';

  @override
  String get onboardingAnalyzingPackages => 'Analyse des packages disponibles…';

  @override
  String onboardingScanningPackagesProgress(
    int scanned,
    int total,
    int alreadyInDb,
  ) {
    return 'Scanné $scanned/$total • déjà dans la base de données $alreadyInDb';
  }

  @override
  String get onboardingImportSelected => 'Importer la sélection';

  @override
  String get onboardingSkipImport => 'Sauter';

  @override
  String get onboardingSelectAll => 'Sélectionner tout';

  @override
  String get onboardingDeselectAll => 'Désélectionner tout';

  @override
  String onboardingNPackages(int count) {
    return 'Forfaits $count';
  }

  @override
  String get onboardingGetStarted => 'Commencer';

  @override
  String get onboardingImportCompleteTitle => 'Importation terminée !';

  @override
  String get importBuiltInPkg => 'Forfaits gratuits';

  @override
  String get importBuiltInPkgTooltip =>
      'Importez des packages linguistiques groupés gratuits';

  @override
  String get globalSearch => 'Recherche globale';

  @override
  String get globalSearchTitle => 'Rechercher dans tous les packages';

  @override
  String get globalSearchSelectLanguage => 'Sélectionnez le code de langue';

  @override
  String get globalSearchEnterWord => 'Mot(s) à rechercher';

  @override
  String get globalSearchEnterWordHint =>
      'par ex. \"der\", \"order\" — trouve des correspondances partielles';

  @override
  String get globalSearchButton => 'Recherche';

  @override
  String get globalSearchResults => 'Résultats';

  @override
  String globalSearchNoResults(String query) {
    return 'Aucun résultat trouvé pour \"$query\"';
  }

  @override
  String globalSearchResultsCount(int count) {
    return '$count résultat(s) trouvé(s)';
  }

  @override
  String get globalSearchSearching => 'Recherche…';

  @override
  String get globalSearchSelectLanguageFirst =>
      'Veuillez d\'abord sélectionner un code de langue';

  @override
  String get globalSearchEnterTermFirst =>
      'Veuillez saisir un terme de recherche';

  @override
  String get globalSearchMatchInExamples => 'Trouvé dans les exemples';

  @override
  String get globalSearchViewItem => 'Voir';

  @override
  String get globalSearchGoToPackage => 'Aller au forfait';

  @override
  String get globalSearchLoadingPackages => 'Chargement des paquets…';

  @override
  String get globalSearchNoPackages =>
      'Aucun package de langue n\'est encore installé';

  @override
  String get globalSearchCancelSearch => 'Annuler la recherche';

  @override
  String globalSearchProgressOf(int current, int total) {
    return 'Recherche du package $current de $total…';
  }

  @override
  String globalSearchCancelledMessage(int count) {
    return 'Recherche annulée — $count résultat(s) trouvé(s) jusqu\'à présent';
  }

  @override
  String get storeTitle => 'Magasin de packages linguistiques';

  @override
  String get storeRestorePurchases => 'Restaurer les achats';

  @override
  String get storeRefresh => 'Rafraîchir';

  @override
  String get storeSearchHint => 'Rechercher des forfaits…';

  @override
  String get storeNoPackagesMatchSearch =>
      'Aucun forfait ne correspond à votre recherche.';

  @override
  String get storeNoPackagesAvailable => 'Aucun forfait disponible.';

  @override
  String storeInstalledCount(int installed, int total) {
    return '$installed / $total installé';
  }

  @override
  String get storeLoadErrorTitle => 'Impossible de charger le magasin.';

  @override
  String get storeIapNotAvailableMessage =>
      'Les achats intégrés ne sont pas disponibles sur cette plateforme. Visitez notre site Web pour acheter des forfaits.';

  @override
  String get storeOpenWebsite => 'Ouvrir le site Web';

  @override
  String storePurchaseSuccess(String title) {
    return '$title installé avec succès !';
  }

  @override
  String get storePurchaseCancelled => 'Achat annulé.';

  @override
  String storePurchaseAlreadyOwned(String title) {
    return '$title est déjà installé.';
  }

  @override
  String get storePurchaseError =>
      'Quelque chose s\'est mal passé. Veuillez réessayer.';

  @override
  String get storePurchasesRestored => 'Achats restaurés';

  @override
  String get storeAllLevels => 'Tous les niveaux';

  @override
  String get storeAllGroups => 'Toutes les langues';

  @override
  String get storeFilterLevel => 'Niveau';

  @override
  String get storeFilterLanguage => 'Langue';

  @override
  String get storeDownload => 'Télécharger';

  @override
  String get storeBuy => 'Acheter';

  @override
  String get storeInstalledLabel => 'Installé';

  @override
  String get storeDownloading => 'Téléchargement…';

  @override
  String get storeRetry => 'Réessayer';

  @override
  String get storeIapAndroidOnly =>
      'Achats disponibles sur Android et iOS uniquement.';

  @override
  String get storeDismiss => 'Rejeter';

  @override
  String get storeAddToCart => 'Ajouter au panier';

  @override
  String get storeRemoveFromCart => 'Retirer';

  @override
  String get storeCartTitle => 'Panier';

  @override
  String get storeCartEmpty => 'Votre panier est vide';

  @override
  String get storeCartClearAll => 'Tout effacer';

  @override
  String get storeCartCheckout => 'Vérifier';

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
  String get storePackageDuplicateTitle => 'Le package existe déjà';

  @override
  String storePackageDuplicateMessage(String packageName, String groupName) {
    return 'Le package \"$packageName\" existe déjà dans le groupe \"$groupName\". Voulez-vous l\'écraser ? Le package existant et toute sa progression de formation seront définitivement supprimés.';
  }

  @override
  String get storePackageDuplicateOverwrite => 'Écraser';

  @override
  String get storePackageDuplicateKeep => 'Conserver l\'existant';

  @override
  String splashSettingUpPackages(int current, int total) {
    return 'Mise en place des packages : $current / $total';
  }

  @override
  String get splashThisHappensOnce => 'Cela n\'arrive qu\'une seule fois.';

  @override
  String get splashLoading => 'Chargement…';

  @override
  String get aiItemCreator => 'Gourou du chat IA';

  @override
  String get aiItemCreatorAppBarHint =>
      'Collectez et enregistrez des mots et des expressions en discutant avec l\'IA';

  @override
  String get chatWithAI => 'Discutez avec l\'IA';

  @override
  String get enterYourPrompt => 'Entrez votre invite...';

  @override
  String get aiItemCreatorPromptHint =>
      'Décrivez un sujet et le coach en IA posera des questions, suggérera un vocabulaire utile et testera vos connaissances. Par exemple : aidez-moi à rassembler et à pratiquer les dangers liés aux voyages au niveau de connaissances B2';

  @override
  String get send => 'Envoyer';

  @override
  String get sending => 'Envoi...';

  @override
  String get aiResponse => 'Réponse de l\'IA';

  @override
  String get itemInputs => 'Entrées d\'articles';

  @override
  String get aiItemCreatorBothItemsRequired =>
      'Veuillez remplir les champs dans les deux langues avant d\'enregistrer.';

  @override
  String get aiItemCreatorDuplicateItemMessage =>
      'Un élément avec la même paire de textes existe déjà dans ce package.';

  @override
  String get language1 => 'Langue 1';

  @override
  String get language2 => 'Langue 2';

  @override
  String get translateLang1ToLang2 => 'Traduire en Lang 2';

  @override
  String get translateLang2ToLang1 => 'Traduire en Lang 1';

  @override
  String translateToLanguageCode(String languageCode) {
    return 'Traduire en $languageCode';
  }

  @override
  String get example => 'Exemple';

  @override
  String get generating => 'Générateur...';

  @override
  String get flags => 'Drapeaux';

  @override
  String get favorite => 'Préféré';

  @override
  String get saveItems => 'Sauvegarder';

  @override
  String get saving => 'Économie...';

  @override
  String get clearItems => 'Effacer les éléments uniquement';

  @override
  String get clearAll => 'Effacer tous les champs';

  @override
  String get itemSavedSuccessfully => 'Article enregistré avec succès';

  @override
  String get promptCannotBeEmpty => 'L\'invite ne peut pas être vide';

  @override
  String get enterAtLeastOneItem => 'Veuillez saisir au moins un élément';

  @override
  String get selectPackageFirst => 'Veuillez d\'abord sélectionner un forfait';

  @override
  String get deeplKeyRequired =>
      'La clé API DeepL est requise pour la traduction';

  @override
  String get noNonPurchasedPackagesAvailable =>
      'Aucun forfait non acheté disponible';

  @override
  String get packageSelectionRemembered => 'Sélection de forfait enregistrée';

  @override
  String get aiItemCreatorOpenAiKeyNotConfiguredDetailed =>
      'La clé API OpenAI n\'est pas configurée. Veuillez ajouter votre clé API dans Paramètres.';

  @override
  String get aiItemCreatorOpenAiKeyNotConfigured =>
      'La clé API OpenAI n\'est pas configurée.';

  @override
  String get aiItemCreatorProcessingComplete => 'Traitement terminé';

  @override
  String get aiItemCreatorTranslationComingSoon =>
      'Fonctionnalité de traduction bientôt disponible';

  @override
  String get aiItemCreatorDefaultCategoryName => 'IA créée';

  @override
  String get aiItemCreatorStartNewConversation =>
      'Démarrer une nouvelle conversation';

  @override
  String get aiItemCreatorChatHint =>
      'Décrivez un sujet et le coach en IA posera des questions, suggérera un vocabulaire utile et testera vos connaissances.';

  @override
  String get aiItemCreatorConversation => 'Conversation';

  @override
  String get aiItemCreatorYou => 'Toi';

  @override
  String get aiItemCreatorCoach => 'Coach IA';

  @override
  String get aiItemCreatorAiSuggestions => 'Suggestions d\'IA';

  @override
  String get aiItemCreatorTapChipToFill =>
      'Appuyez sur une puce pour remplir un champ d\'élément et traduire automatiquement.';

  @override
  String get aiItemCreatorNoSuggestedItems =>
      'Pas encore de mots ou d\'expressions.';

  @override
  String get aiItemCreatorNextSteps => 'Comment continuer';

  @override
  String get aiItemCreatorNoNextSteps =>
      'Aucune suggestion de suite pour l\'instant.';

  @override
  String get aiItemCreatorModelCostTip =>
      'Conseil de pro : les modèles plus récents sont plus chers, tandis que les modèles plus anciens et turbo sont moins chers et peuvent être beaucoup plus rapides.';

  @override
  String get aiItemCreatorSelectPackageDialogTitle =>
      'Choisir le forfait linguistique';

  @override
  String get aiItemCreatorSelectPackageDialogMessage =>
      'Sélectionnez le package linguistique à utiliser pour cette session. Votre dernier choix est présélectionné.';

  @override
  String aiItemCreatorMissingApiKeysWarning(String keys) {
    return 'Clés API manquantes : $keys. Vous pouvez continuer, mais les fonctionnalités d\'IA et de traduction premium peuvent être limitées.';
  }

  @override
  String get about => 'À propos';

  @override
  String get aboutWebsite => 'Site web';

  @override
  String get aboutSummaryVideo => 'Summary video';

  @override
  String get aboutSupportEmail => 'Adresse e-mail d\'assistance';

  @override
  String get aboutWebsiteUrl => 'https://sites.google.com/view/langue-rally';

  @override
  String get aboutSummaryVideoUrl =>
      'https://www.youtube.com/watch?v=64Pl9iNF88c';

  @override
  String get aboutSupportEmailAddress => 'langagerally.support@gmail.com';

  @override
  String aboutVersionWithValue(String version) {
    return 'Version : $version';
  }

  @override
  String aboutCouldNotOpen(String uri) {
    return 'Impossible d\'ouvrir : $uri';
  }

  @override
  String get aboutWelcomeSplashNotFound =>
      'Image de démarrage de bienvenue introuvable';

  @override
  String get chooseTheme => 'Choisir un thème';

  @override
  String get darkMode => 'Mode sombre';

  @override
  String get toggleBetweenLightAndDark => 'Basculer entre clair et foncé';

  @override
  String get colorTheme => 'Thème de couleur :';

  @override
  String get toggleBrightness => 'Basculer la luminosité';

  @override
  String get changeTheme => 'Changer de thème';

  @override
  String get managePackageGroups => 'Gérer les groupes de packages';

  @override
  String get noPackageGroups => 'Aucun groupe de packages';

  @override
  String get createFirstPackageGroup =>
      'Créez votre premier groupe de packages';

  @override
  String get addGroup => 'Ajouter un groupe';

  @override
  String get addPackageGroup => 'Ajouter un groupe de packages';

  @override
  String get editPackageGroup => 'Modifier le groupe de packages';

  @override
  String get groupName => 'Nom du groupe';

  @override
  String get enterGroupName => 'Entrez le nom du groupe';

  @override
  String get groupNameRequired => 'Le nom du groupe est obligatoire';

  @override
  String get duplicateGroupName => 'Nom en double';

  @override
  String groupNameAlreadyExists(String name) {
    return 'Un groupe portant le nom « $name » existe déjà.';
  }

  @override
  String groupCreatedSuccessfully(String name) {
    return 'Groupe \"$name\" créé avec succès';
  }

  @override
  String failedToCreateGroup(String error) {
    return 'Échec de la création du groupe : $error';
  }

  @override
  String groupRenamedTo(String name) {
    return 'Groupe renommé \"$name\"';
  }

  @override
  String failedToUpdateGroup(String error) {
    return 'Échec de la mise à jour du groupe : $error';
  }

  @override
  String get deleteGroup => 'Supprimer le groupe';

  @override
  String deleteGroupConfirm(String name) {
    return 'Etes-vous sûr de vouloir supprimer le groupe « $name » ?\n\nCette action ne peut pas être annulée.';
  }

  @override
  String get cannotDeleteGroup => 'Impossible de supprimer';

  @override
  String groupHasPackages(int count) {
    return 'Ce groupe a encore $count package(s). Veuillez d\'abord les déplacer ou les supprimer.';
  }

  @override
  String groupDeleted(String name) {
    return 'Groupe \"$name\" supprimé';
  }

  @override
  String failedToDeleteGroup(String error) {
    return 'Échec de la suppression du groupe : $error';
  }

  @override
  String get cannotDeleteHasPackagesTooltip =>
      'Impossible de supprimer (contient des packages)';

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
  String get manageGroups => 'Gérer les groupes';

  @override
  String get featureLangPower => 'Le pouvoir du langage';

  @override
  String get featureAiIntegration => 'Intégration de l\'IA';

  @override
  String get featureAdaptivePractice => 'Pratique adaptative';

  @override
  String get featureMasterAccent => 'L\'accent du maître';

  @override
  String get allBadgesEarned =>
      '🎉 Tous les badges gagnés ! Vous êtes un Maître !';

  @override
  String nextBadgeLabel(String name) {
    return 'Suivant : $name';
  }

  @override
  String pointsToGo(String percent) {
    return '$percent% à emporter';
  }

  @override
  String progressPercent(String percent) {
    return '$percent % de progression';
  }

  @override
  String errorTogglingFavourite(String error) {
    return 'Erreur lors du basculement des favoris : $error';
  }

  @override
  String errorTogglingImportant(String error) {
    return 'Erreur de basculement importante : $error';
  }

  @override
  String categoryAdded(String name) {
    return 'Catégorie \"$name\" ajoutée';
  }

  @override
  String errorAddingCategory(String error) {
    return 'Erreur lors de l\'ajout de la catégorie : $error';
  }

  @override
  String categoryRemoved(String name) {
    return 'Catégorie \"$name\" supprimée';
  }

  @override
  String errorRemovingCategory(String error) {
    return 'Erreur lors de la suppression de la catégorie : $error';
  }

  @override
  String couldNotOpenUrl(String url) {
    return 'Impossible d\'ouvrir l\'URL : $url';
  }

  @override
  String errorOpeningUrl(String error) {
    return 'Erreur lors de l\'ouverture de l\'URL : $error';
  }

  @override
  String get pleaseSelectLanguage => 'Veuillez sélectionner une langue';

  @override
  String get add => 'Ajouter';

  @override
  String get speak => 'Parler';

  @override
  String get recordingFailedToStart =>
      'L\'enregistrement n\'a pas pu démarrer !\n\nVérifiez :\n1. Le microphone est connecté\n2. Le microphone est défini comme périphérique par défaut\n3. Aucune autre application n\'utilise un microphone';

  @override
  String get recordingFailedNoAudioFile =>
      'L\'enregistrement a échoué - aucun fichier audio n\'a été créé !\n\nCauses possibles :\n1. Microphone non connecté\n2. Aucune entrée audio détectée\n3. Problème de paramètres audio Windows';

  @override
  String errorStartingRecordingDetails(String error) {
    return 'Erreur lors du démarrage de l\'enregistrement : $error';
  }

  @override
  String get openaiEmptyResponse =>
      'Le modèle d\'IA sélectionné a renvoyé une réponse vide';

  @override
  String get tryDifferentModel =>
      'Essayez de sélectionner un autre modèle dans le sélecteur de modèle';

  @override
  String get modelMayNotBeSupported =>
      'Ce modèle peut ne pas être pris en charge ou disponible pour votre compte';

  @override
  String get reduceTextOrRetry => 'Réduisez la longueur du texte ou réessayez';

  @override
  String get openaiNullContent =>
      'Le modèle d\'IA sélectionné n\'a renvoyé aucun contenu';

  @override
  String get modelUnsupportedParameter =>
      'Le modèle sélectionné ne prend pas en charge un paramètre API requis';
}
