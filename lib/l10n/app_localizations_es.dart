// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get helloWorld => '¡Hola Mundo!';

  @override
  String get welcome => 'Bienvenidos al Rally de Idiomas';

  @override
  String get appTitle => 'Rally de idiomas';

  @override
  String get createPackage => 'Crear paquete';

  @override
  String get editPackage => 'Editar paquete';

  @override
  String get packageDetails => 'Detalles del paquete';

  @override
  String get packageName => 'Nombre del paquete';

  @override
  String get packageNameHint =>
      'por ejemplo, conceptos básicos de español, conceptos básicos de alemán';

  @override
  String get languageCode1 => 'Código de idioma fuente';

  @override
  String get languageName1 => 'Nombre del idioma de origen';

  @override
  String get languageCode2 => 'Código de idioma de destino';

  @override
  String get languageName2 => 'Nombre del idioma de destino';

  @override
  String get description => 'Descripción';

  @override
  String get descriptionHint => 'Breve descripción de este paquete de idiomas';

  @override
  String get authorName => 'Nombre del autor';

  @override
  String get authorEmail => 'Correo electrónico del autor';

  @override
  String get authorWebpage => 'Página web del autor';

  @override
  String get version => 'Versión';

  @override
  String get items => 'elementos';

  @override
  String get packageIcon => 'Icono de paquete';

  @override
  String get packageGroup => 'Grupo de paquetes';

  @override
  String get selectIcon => 'Seleccionar icono';

  @override
  String get defaultIcon => 'Icono predeterminado';

  @override
  String get customIcon => 'Icono personalizado';

  @override
  String get upload => 'Icono de carga';

  @override
  String get uploadCustomIcon =>
      'Cargar icono personalizado (máx. 512x512, 1 MB)';

  @override
  String get customIconUploaded => 'Ícono personalizado cargado exitosamente';

  @override
  String get save => 'Ahorrar';

  @override
  String get edit => 'Editar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get delete => 'Borrar';

  @override
  String get confirmDelete =>
      '¿Está seguro de que desea eliminar este paquete?';

  @override
  String get packageSaved => 'Paquete guardado exitosamente';

  @override
  String get packageDeleted => 'Paquete eliminado exitosamente';

  @override
  String get errorSavingPackage => 'Error al guardar el paquete';

  @override
  String get errorDeletingPackage => 'Error al eliminar el paquete';

  @override
  String get fieldRequired => 'Este campo es obligatorio';

  @override
  String get invalidEmail => 'Dirección de correo electrónico no válida';

  @override
  String get readOnlyPackage =>
      'Este paquete es de solo lectura y no se puede editar.';

  @override
  String get purchasedPackage => 'Los paquetes comprados no se pueden editar';

  @override
  String get badges => 'Insignias';

  @override
  String get noBadges => 'Aún no se han obtenido insignias';

  @override
  String get selectLanguageCode => 'Seleccionar código de idioma';

  @override
  String get typeToSearchLanguages => 'Escribe para buscar idiomas...';

  @override
  String get search => 'Buscar...';

  @override
  String get clearCounters => 'Borrar contadores';

  @override
  String get confirmClearCounters =>
      '¿Estás seguro de que deseas borrar todos los contadores de entrenamiento de este paquete? Esto restablecerá los contadores de \"no sé\" y las estadísticas de entrenamiento.';

  @override
  String get clear => 'Claro';

  @override
  String get countersCleared => 'Contadores borrados exitosamente';

  @override
  String get errorClearingCounters => 'Error al borrar contadores';

  @override
  String get deleteAll => 'Eliminar paquete';

  @override
  String get confirmDeleteAllData =>
      '¿Estás seguro de que deseas eliminar este paquete con TODOS sus datos? Esto eliminará permanentemente todas las categorías, elementos y estadísticas de entrenamiento. ¡Esta acción no se puede deshacer!';

  @override
  String get allDataDeleted =>
      'Paquete y todos los datos eliminados correctamente.';

  @override
  String get exportPackage => 'Paquete de exportación';

  @override
  String get selectExportLocation => 'Seleccione la ubicación de exportación';

  @override
  String get packageExported => 'Paquete exportado exitosamente';

  @override
  String get errorExportingPackage => 'Error al exportar el paquete';

  @override
  String get importItems => 'Importar elementos (JSON)';

  @override
  String get importItemsDialogTitle => 'Importar elementos (JSON)';

  @override
  String get importItemsFromLocalJson => 'Importar desde un archivo JSON local';

  @override
  String get enterItemsUrl => 'URL JSON de elementos (https://…)';

  @override
  String get downloadingItems => 'Descargando elementos...';

  @override
  String get selectImportFile => 'Seleccione Importar archivo';

  @override
  String get importFormat => 'Formato de importación';

  @override
  String get importFormatDescription =>
      'Importar elementos desde un archivo de texto. Cada línea debe contener un elemento en el siguiente formato:';

  @override
  String get importResults => 'Importar resultados';

  @override
  String get successfullyImported => 'Importado exitosamente';

  @override
  String get failedToImport => 'No se pudo importar';

  @override
  String get error => 'Error';

  @override
  String get ok => 'DE ACUERDO';

  @override
  String get importPackage => 'Paquete de importación';

  @override
  String get importPackageTooltip =>
      'Importar paquete desde un archivo ZIP o URL';

  @override
  String get importPackageDialogTitle => 'Importar paquete de idioma';

  @override
  String get importFromLocalFile => 'Importar desde archivo local';

  @override
  String get importFromUrl => 'Importar desde URL';

  @override
  String get enterPackageUrl => 'URL del paquete (https://…)';

  @override
  String get downloadingPackage => 'Descargando paquete…';

  @override
  String get downloadFailed =>
      'La descarga falló. Por favor verifique la URL y su conexión a Internet.';

  @override
  String get invalidUrl => 'Introduzca una URL http:// o https:// válida.';

  @override
  String get orLabel => 'o';

  @override
  String get selectPackageZipFile => 'Seleccione el archivo ZIP del paquete';

  @override
  String get couldNotAccessFile =>
      'No se pudo acceder al archivo seleccionado.';

  @override
  String get importingPackage => 'Importando paquete...';

  @override
  String get packageImportedSuccessfully => '¡Paquete importado exitosamente!';

  @override
  String packageImportedWithItems(Object count) {
    return '¡Paquete importado exitosamente! ($count artículos)';
  }

  @override
  String packageImportedWithGroup(Object count, Object groupName) {
    return '¡Paquete importado al grupo \"$groupName\"! ($count artículos)';
  }

  @override
  String get importError => 'Error de importación';

  @override
  String get failedToImportPackage => 'No se pudo importar el paquete';

  @override
  String get packageAlreadyExists => 'El paquete ya existe';

  @override
  String packageExistsMessage(Object groupName) {
    return 'Ya existe un paquete con el mismo par de idiomas, descripción, información del autor y versión en el grupo \"$groupName\". ¿Le gustaría importarlo como un paquete nuevo de todos modos?';
  }

  @override
  String get importAsNew => 'Importar de todos modos';

  @override
  String get zipFileNotFound => 'Archivo ZIP no encontrado';

  @override
  String get invalidPackageZip =>
      'Paquete ZIP no válido: falta package_data.json';

  @override
  String get invalidPackageFormat => 'Formato de archivo de paquete no válido';

  @override
  String get languagePackages => 'Paquetes de idiomas';

  @override
  String get loadingPackages => 'Cargando paquetes...';

  @override
  String get tapAndHoldToReorder =>
      'Mantenga presionado para reordenar las tarjetas';

  @override
  String get tapAndHoldToReorderList =>
      'Toque y mantenga presionado ≡ para reordenar • Toque ⋮ para alternar la vista compacta';

  @override
  String get noPackagesYet => 'Aún no hay paquetes';

  @override
  String get createFirstPackage => 'Crea tu primer paquete de idioma';

  @override
  String get versionLabel => 'Versión';

  @override
  String get purchased => 'Comprado';

  @override
  String get compactView => 'compacto';

  @override
  String get expand => 'Expandir';

  @override
  String get allCategories => 'Todas las categorías';

  @override
  String get categoriesInPackage => 'Categorías en este paquete';

  @override
  String get categories => 'Categorías';

  @override
  String get testInterFonts => 'Probar fuentes internas';

  @override
  String get viewPackages => 'Ver paquetes';

  @override
  String get simplifiedPackageView => 'Lista de paquetes';

  @override
  String get createNewPackage => 'Crear nuevo paquete';

  @override
  String get generateTestData => 'Generar datos de prueba';

  @override
  String get designSystemShowcase => 'Escaparate del sistema de diseño';

  @override
  String get badgeEarned => '¡Insignia obtenida!';

  @override
  String get achievement => 'Logro';

  @override
  String get awesome => '¡Impresionante!';

  @override
  String get importFormatNotes => 'Notas:';

  @override
  String get importFormatLine1 => '• Cada línea representa un elemento';

  @override
  String get importFormatLine2 => '• Los campos están separados por |';

  @override
  String get importFormatLine3 => '• Las categorías están separadas por ;';

  @override
  String get importFormatLine4 => '• El último | es opcional';

  @override
  String get importFormatLine5 => '• Las líneas vacías se ignoran';

  @override
  String get importFormatLine6 => '• Se omiten los duplicados';

  @override
  String get importFormatNewDescription =>
      'Importar elementos desde un archivo de texto. Cada línea debe contener un elemento con campos separados por ---';

  @override
  String get importFormatNewLine1 => '• Delimitador principal: ---';

  @override
  String get importFormatNewLine2 =>
      '• L1=<texto> - Texto principal del idioma 1 (obligatorio si falta L2)';

  @override
  String get importFormatNewLine3 =>
      '• L2=<texto> - Texto principal del idioma 2 (obligatorio si falta L1)';

  @override
  String get importFormatNewLine4 =>
      '• L1pre=<texto> - Prefijo de idioma 1 (opcional)';

  @override
  String get importFormatNewLine5 =>
      '• L1post=<texto> - Sufijo del idioma 1 (opcional)';

  @override
  String get importFormatNewLine6 =>
      '• L2pre=<texto> - Prefijo de idioma 2 (opcional)';

  @override
  String get importFormatNewLine7 =>
      '• L2post=<texto> - Sufijo del idioma 2 (opcional)';

  @override
  String get importFormatNewLine8 =>
      '• EX=<texto L1>:::<texto L2> - Ejemplo (opcional, puede ser múltiple)';

  @override
  String get importFormatNewLine9 =>
      '• CAT=<cat1>:::<cat2>:::<cat3> - Categorías (opcional)';

  @override
  String get importFormatNewLine10 =>
      '• Al menos uno de L1= o L2= debe estar presente';

  @override
  String get importFormatNewLine11 => '• Las líneas vacías se ignoran';

  @override
  String get importFormatNewLine12 => '• Se omiten los duplicados';

  @override
  String get invalidImportLine => 'Línea no válida';

  @override
  String get missingRequiredFields => 'Falta \'L1=\' vago \'L2=\'';

  @override
  String get unknownField => 'Prefijo de campo desconocido';

  @override
  String andMore(Object count) {
    return '... y $count más';
  }

  @override
  String get browseItems => 'Explorar artículos';

  @override
  String get itemDetails => 'Detalles';

  @override
  String get filterItems => 'Filtrar artículos';

  @override
  String searchLanguage1(Object language) {
    return 'Buscar en $language';
  }

  @override
  String searchLanguage2(Object language) {
    return 'Buscar en $language';
  }

  @override
  String get caseSensitive => 'Distingue mayúsculas y minúsculas';

  @override
  String get knownStatus => 'Estado conocido';

  @override
  String get filterStatusAll => 'todo';

  @override
  String get filterStatusKnown => 'conocido';

  @override
  String get filterStatusUnknown => 'desconocido';

  @override
  String get allItems => 'Todos los artículos';

  @override
  String get itemsIKnew => 'Artículos que conocía';

  @override
  String get itemsIDidNotKnow => 'Artículos que no conocía';

  @override
  String get known => 'Conocido';

  @override
  String get unknown => 'Desconocido';

  @override
  String get important => 'Importante';

  @override
  String get favourite => 'Favorito';

  @override
  String get badge => 'Insignia';

  @override
  String get position => 'Posición';

  @override
  String get stepsUntilLearned => 'Pasos hasta aprender';

  @override
  String get examples => 'Ejemplos';

  @override
  String get noExamples => 'No hay ejemplos disponibles';

  @override
  String get pronounce => 'Pronunciar';

  @override
  String get ttsError => 'Texto a voz no disponible';

  @override
  String get noItemsFound => 'No se encontraron artículos';

  @override
  String get noItemsInPackage => 'Aún no hay artículos en este paquete';

  @override
  String get addItem => 'Agregar artículo';

  @override
  String get emptyPackageHint =>
      'Agregue elementos manualmente o use IA para importar elementos rápidamente';

  @override
  String get noItemsToTrain =>
      'No hay elementos disponibles para practicar con la configuración actual';

  @override
  String get clearFilters => 'Claro';

  @override
  String itemCount(Object count) {
    return '$count artículos';
  }

  @override
  String filteredItemCount(Object filtered, Object total) {
    return '$filtered de $total artículos';
  }

  @override
  String get trainingRally => 'Rally de entrenamiento';

  @override
  String get startTraining => 'Empezar a entrenar';

  @override
  String get trainingComingSoon => 'Rally de entrenamiento: ¡próximamente!';

  @override
  String get aiServiceNotConfigured =>
      'Servicio de IA no configurado. Agregue su clave API de OpenAI.';

  @override
  String pleaseEnterTextInLanguageFirst(Object language) {
    return 'Por favor ingrese el texto en $language primero';
  }

  @override
  String translationCompletedSuccessfully(Object service) {
    return '¡La traducción se completó exitosamente usando $service!';
  }

  @override
  String get translationFailed => 'La traducción falló';

  @override
  String addedExamplesSuccessfully(Object count) {
    return '¡Se agregaron $count ejemplos exitosamente!';
  }

  @override
  String get failedToGenerateExamples => 'No se pudieron generar ejemplos';

  @override
  String get selectExamplesToAdd => 'Seleccione ejemplos para agregar';

  @override
  String get selectWhichExamples =>
      'Seleccione qué ejemplos desea agregar a este elemento:';

  @override
  String get addSelected => 'Agregar seleccionados';

  @override
  String get pleaseSelectAtLeastOne =>
      'Por favor seleccione al menos un ejemplo';

  @override
  String get addNewItem => 'Agregar nuevo artículo';

  @override
  String get editItem => 'Editar artículo';

  @override
  String get deleteItem => 'Eliminar artículo';

  @override
  String get confirmDeleteItem =>
      '¿Está seguro de que desea eliminar este elemento?';

  @override
  String get thisActionCannotBeUndone => 'Esta acción no se puede deshacer.';

  @override
  String get itemDeleted => 'Artículo eliminado';

  @override
  String get errorDeletingItem => 'Error al eliminar el artículo';

  @override
  String get errorSavingItem => 'Error al guardar el elemento';

  @override
  String get itemSaved => 'Artículo actualizado exitosamente';

  @override
  String get itemCreated => 'Artículo creado exitosamente';

  @override
  String get preTextOptional => 'Texto previo (opcional)';

  @override
  String get mainText => 'Texto principal';

  @override
  String get postTextOptional => 'Post-texto (opcional)';

  @override
  String get forExampleToForVerbs => 'por ejemplo, \"to\" para verbos';

  @override
  String get additionalContext => 'Contexto adicional';

  @override
  String get translate => 'Traducir';

  @override
  String translateFromTo(Object from, Object to) {
    return 'Traducir $from → $to';
  }

  @override
  String get aiExampleGeneration => 'Generación de ejemplos de IA';

  @override
  String get aiExampleSearch => 'Búsqueda de ejemplo de IA';

  @override
  String searchExamplesOnInternet(Object text) {
    return 'Busque oraciones de ejemplo en Internet usando AI para \'$text\'';
  }

  @override
  String generateExampleSentences(Object language) {
    return 'Genera oraciones de ejemplo basadas en el texto principal en $language';
  }

  @override
  String get voiceInput => 'Entrada de voz';

  @override
  String get settings => 'Ajustes';

  @override
  String get uiLanguage => 'Idioma de la interfaz de usuario';

  @override
  String get uiLanguageDescription => 'Idioma de la interfaz de la aplicación';

  @override
  String get uiLanguageHelper =>
      'Seleccione el idioma para menús, botones y etiquetas.';

  @override
  String get userLanguage => 'Idioma del usuario';

  @override
  String get userLanguageDescription =>
      'Tu lengua materna preferida para crear nuevos paquetes de idiomas';

  @override
  String get apiKeys => 'Claves API';

  @override
  String get deeplApiKey => 'Clave API de DeepL';

  @override
  String get deeplApiKeyDescription =>
      'Para una calidad de traducción superior al editar elementos de idioma. Ver https://www.deepl.com/pro-api';

  @override
  String get openaiApiKey => 'Clave API de OpenAI';

  @override
  String get openaiApiKeyDescription =>
      'Por ejemplo, generación con IA al editar elementos de idioma. Ver https://platform.openai.com/api-keys';

  @override
  String get enterApiKey => 'Ingrese la clave API';

  @override
  String get optional => 'opcional';

  @override
  String get required => 'requerido';

  @override
  String get settingsSaved => 'Configuración guardada exitosamente';

  @override
  String get errorSavingSettings => 'Error al guardar la configuración';

  @override
  String get usingGoogleTranslate => 'Usando el Traductor de Google gratuito';

  @override
  String get usingDeepL => 'Usando DeepL (premium)';

  @override
  String get noTranslationReceivedFromGoogle =>
      'No se recibió ninguna traducción de Google.';

  @override
  String get googleTranslationFailed => 'La traducción de Google falló';

  @override
  String get googleTranslationError => 'Error de traducción de Google';

  @override
  String get noTranslationReceivedFromDeepL =>
      'No se recibió traducción de DeepL';

  @override
  String get invalidDeepLApiKey => 'Clave API de DeepL no válida';

  @override
  String get deeplTranslationQuotaExceeded =>
      'Se superó la cuota de traducción de DeepL';

  @override
  String get deeplTranslationFailed => 'La traducción de DeepL falló';

  @override
  String get deeplTranslationError => 'Error de traducción de DeepL';

  @override
  String get invalidApiKeyConfigureOpenAI =>
      'Clave API no válida. Configure su clave API de OpenAI.';

  @override
  String get apiRateLimitExceeded =>
      'Se superó el límite de tasa API. Inténtelo de nuevo más tarde.';

  @override
  String get aiRequestFailed => 'La solicitud de IA falló';

  @override
  String get failedToParseAiResponse =>
      'No se pudo analizar la respuesta de la IA. Por favor inténtalo de nuevo.';

  @override
  String get aiGenerationError => 'Error de generación de IA';

  @override
  String get voiceInputPlaceholder =>
      'La entrada de voz se implementará utilizando el paquete Speech_to_text';

  @override
  String get improveQualityWithApiKeys =>
      '💡 Consejo: La calidad de las traducciones y las búsquedas de ejemplo se puede mejorar significativamente agregando las claves API de DeepL y OpenAI en la configuración de la aplicación.';

  @override
  String get noApiKeyFallbackMessage =>
      'Sin claves API, se proporcionan traducciones básicas y ejemplos limitados. Para obtener mejores resultados, configure sus claves API en Configuración.';

  @override
  String get listeningForSpeech => 'Escuchando... Habla ahora';

  @override
  String get speechRecognitionNotAvailable =>
      'El reconocimiento de voz no está disponible en este dispositivo';

  @override
  String get speechRecognitionPermissionDenied =>
      'Se denegó el permiso de reconocimiento de voz';

  @override
  String get speechRecognitionError => 'Error de reconocimiento de voz';

  @override
  String get tapToSpeak => 'Toca el micrófono para hablar';

  @override
  String get tapToStop => 'Toca para detener la grabación';

  @override
  String get speechNotRecognized =>
      'No se reconoció ningún discurso. Por favor inténtalo de nuevo.';

  @override
  String get usingWhisperApiSlower =>
      'Usar IA en la nube para el reconocimiento de voz (puede ser más lento)';

  @override
  String languageNotSupportedAddApiKey(String languageCode) {
    return 'El idioma $languageCode no es compatible de forma nativa. Agregue la clave API OpenAI en Configuración para el reconocimiento de voz impulsado por IA.';
  }

  @override
  String get recordingTapToStop => 'Grabando... Toque nuevamente para detener';

  @override
  String get speakClearlyKeepRecording =>
      'Habla claramente. Graba al menos 1 segundo.';

  @override
  String get pleaseRecordLonger =>
      'Habla durante al menos 1 segundo y toca detener.';

  @override
  String get errorStartingRecording => 'Error al iniciar la grabación';

  @override
  String get noAudioRecorded => 'No se grabó ningún audio.';

  @override
  String get errorTranscribing => 'Error al transcribir audio';

  @override
  String get trainingSettings => 'Configuración de entrenamiento';

  @override
  String get trainingPresetTitle => 'Configuración rápida';

  @override
  String get trainingPresetHint =>
      'Elija un ajuste preestablecido y las configuraciones a continuación se configurarán automáticamente.';

  @override
  String get trainingPresetComboLabel => 'Programar';

  @override
  String get trainingPresetAllExamplesForeignLanguage =>
      'Todos los ejemplos, idioma extranjero.';

  @override
  String get trainingPresetAllExamplesRandomLanguage =>
      'Todos los ejemplos, lenguaje aleatorio.';

  @override
  String get trainingPresetFavouriteItemsForeignLanguage =>
      'Artículos favoritos, idioma extranjero.';

  @override
  String get trainingPresetFavouriteItemsRandomLanguage =>
      'Artículos favoritos, idioma aleatorio';

  @override
  String get trainingPresetImportantItemsForeignLanguage =>
      'Artículos importantes, idioma extranjero.';

  @override
  String get trainingPresetImportantItemsRandomLanguage =>
      'Artículos importantes, idioma aleatorio.';

  @override
  String get trainingPresetRandomItemsRandomLanguage =>
      'Elementos aleatorios, idioma aleatorio';

  @override
  String get trainingPresetUnknownItemsForeignLanguage =>
      'Elementos desconocidos, idioma extranjero.';

  @override
  String get trainingPresetUnknownItemsRandomLanguage =>
      'Elementos desconocidos, idioma aleatorio.';

  @override
  String trainingPresetAppliedTapStart(String actionLabel) {
    return 'Preestablecido aplicado. Toca \"$actionLabel\" para comenzar.';
  }

  @override
  String get trainingPresetSelectPackageFirst =>
      'Por favor seleccione un paquete primero.';

  @override
  String get itemScope => 'Alcance del artículo';

  @override
  String get lastNItems => 'Últimos N elementos';

  @override
  String get onlyUnknown => 'Sólo elementos desconocidos';

  @override
  String get onlyImportant => 'Solo elementos importantes';

  @override
  String get onlyFavourite => 'Solo artículos favoritos';

  @override
  String get numberOfItems => 'Número de artículos';

  @override
  String get itemOrder => 'Orden del artículo';

  @override
  String get randomOrder => 'Orden aleatorio';

  @override
  String get sequentialOrder => 'Orden secuencial';

  @override
  String get itemType => 'Tipo de artículo';

  @override
  String get dictionaryItems => 'Elementos del diccionario';

  @override
  String get examplesType => 'Ejemplos';

  @override
  String get displayLanguage => 'Idioma de visualización';

  @override
  String get motherTongue => 'Lengua materna';

  @override
  String get targetLanguage => 'Lengua de llegada';

  @override
  String get randomLanguage => 'Aleatorio';

  @override
  String get categoryFilter => 'Filtro de categoría';

  @override
  String get categoryFilterHint =>
      'Seleccione las categorías para incluir (vacío = todas las categorías)';

  @override
  String get noCategories => 'No hay categorías disponibles';

  @override
  String get dontKnowThreshold => 'No sé el umbral';

  @override
  String get dontKnowThresholdHint =>
      'Número de veces que es necesario marcar un artículo como \"no sé\" antes de realizar un tratamiento especial';

  @override
  String get startTrainingRally => 'Iniciar rally de entrenamiento';

  @override
  String get clearTrainingSettings => 'Borrar configuración';

  @override
  String get confirmClearTrainingSettings =>
      '¿Estás seguro de que quieres restablecer todas las configuraciones de entrenamiento a los valores predeterminados?';

  @override
  String get trainingSettingsCleared =>
      'Se han borrado los ajustes de entrenamiento.';

  @override
  String get startingTraining => 'Empezando a entrenar...';

  @override
  String get noMoreItemsToDisplay =>
      'No hay elementos para mostrar según la configuración de su filtro.';

  @override
  String get noItems => 'Sin artículos';

  @override
  String get trainingComplete => 'Entrenamiento completo';

  @override
  String get allItemsCompleted =>
      '¡Felicidades! Ha completado todos los elementos de esta sesión de formación.';

  @override
  String get closeTraining => 'Cerrar Entrenamiento';

  @override
  String get confirmCloseTraining =>
      '¿Estás seguro de que quieres cerrar la formación? Tu progreso ha sido guardado.';

  @override
  String get question => 'Pregunta';

  @override
  String get answer => 'Respuesta';

  @override
  String get iKnow => 'Lo sé';

  @override
  String get iDontKnow => 'No sé';

  @override
  String get previousItem => 'Artículo anterior';

  @override
  String get iDidNotKnowEither => 'Después de todo no lo sabía';

  @override
  String get exportBeforeDelete => '¿Exportar antes de eliminar?';

  @override
  String get aiTextAnalysis => 'Extraiga elementos de un texto/lista con IA';

  @override
  String get aiTextAnalysisImport =>
      'Extraiga elementos de un texto o lista con la herramienta de análisis de texto AI';

  @override
  String get knowledgeLevel => 'Nivel de conocimiento';

  @override
  String get a1Beginner => 'A1 - Principiante';

  @override
  String get a2Elementary => 'A2 - Primaria';

  @override
  String get b1Intermediate => 'B1 - Intermedio';

  @override
  String get b2UpperIntermediate => 'B2 - Intermedio Alto';

  @override
  String get c1Advanced => 'C1 - Avanzado';

  @override
  String get c2Proficient => 'C2 - Competente';

  @override
  String get pasteTextHere => 'Pega tu texto aquí...';

  @override
  String get extractWords => 'Extraer palabras';

  @override
  String get extractExpressions => 'Extraer expresiones';

  @override
  String get maxItems => 'Máximo de artículos nuevos';

  @override
  String get maxItemsHint => 'Dejar vacío sin límite';

  @override
  String get generateExamples => 'Generar ejemplos';

  @override
  String get categoryName => 'Nombre de categoría';

  @override
  String get categoryNameHint =>
      'Nombre de la categoría de artículos importados';

  @override
  String get analyzeText => 'Analizar texto';

  @override
  String get configureAnalysis => 'Configurar elementos para extraer';

  @override
  String get openaiModel => 'Modelo de IA';

  @override
  String get openaiModelDescription => 'Seleccione el modelo ChatGPT';

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
      'El equilibrio más nuevo entre calidad y velocidad para uso general';

  @override
  String get modelGpt55ProDesc =>
      'Variante GPT-5.5 de gama alta para el razonamiento y la calidad más sólidos';

  @override
  String get modelGpt54Desc =>
      'Potente modelo de generación GPT-5 de uso general';

  @override
  String get modelGpt54ProDesc =>
      'Variante GPT-5.4 de mayor capacidad para tareas exigentes';

  @override
  String get modelGpt54MiniDesc =>
      'Variante GPT-5.4 más pequeña y rápida para tareas cotidianas de menor costo';

  @override
  String get modelGpt5MiniDesc =>
      'Modelo compacto de la familia GPT-5 optimizado para velocidad y costo';

  @override
  String get modelGpt41Desc =>
      'Opción confiable GPT-4.1 para compatibilidad y calidad sólida';

  @override
  String get modelGpt4o => 'GPT-4o';

  @override
  String get modelGpt35Turbo => 'GPT-3.5 Turbo (heredado, económico)';

  @override
  String get modelGpt35Turbo16k => 'GPT-3.5 Turbo 16K';

  @override
  String get modelGpt4 => 'GPT-4';

  @override
  String get modelGpt4Turbo => 'GPT-4 Turbo (heredado)';

  @override
  String get modelGpt4oDesc =>
      'La mejor opción de uso general; Rápido, multimodal y de gran calidad.';

  @override
  String get modelGpt35TurboDesc =>
      'Opción heredada de bajo costo; útil para tareas más simples y usos sensibles al costo';

  @override
  String get modelGpt35Turbo16kDesc =>
      'Igual que GPT-3.5, pero ventana de contexto de token de 16K';

  @override
  String get modelGpt4Desc =>
      'Alta calidad de razonamiento; normalmente más lento y más caro';

  @override
  String get modelGpt4TurboDesc =>
      'Opción familiar Legacy GPT-4; sigue siendo útil cuando quieres una alternativa más antigua y barata';

  @override
  String get analyzing => 'Analizando...';

  @override
  String get languageDetected => 'Idioma detectado';

  @override
  String get itemsFound => 'Artículos encontrados';

  @override
  String get selectItemsToImport => 'Seleccionar elementos para importar';

  @override
  String get selectAll => 'Seleccionar todo';

  @override
  String get deselectAll => 'Deseleccionar todo';

  @override
  String get importSelected => 'Importar seleccionado';

  @override
  String get importing => 'Importador...';

  @override
  String get itemsImported => 'Artículos importados exitosamente';

  @override
  String get noItemsSelected => 'No hay elementos seleccionados';

  @override
  String get textCannotBeEmpty => 'El texto no puede estar vacío';

  @override
  String get selectAtLeastOneType =>
      'Seleccione al menos un tipo (palabras o expresiones)';

  @override
  String get languageNotMatching =>
      'El idioma detectado no coincide con ningún idioma del paquete';

  @override
  String get openaiKeyRequired =>
      'Se requiere la clave API de OpenAI para esta función';

  @override
  String analyzingProgress(Object current, Object total) {
    return 'Analizando: $current / $total';
  }

  @override
  String translatingProgress(Object current, Object total) {
    return 'Traduciendo: $current / $total';
  }

  @override
  String get duplicate => 'Duplicado';

  @override
  String importProgress(Object current, Object total) {
    return 'Importando $current de $total';
  }

  @override
  String get detectingLanguage => 'Detectando idioma...';

  @override
  String get extractingItems => 'Extrayendo elementos...';

  @override
  String get checkingDuplicates => 'Comprobando duplicados...';

  @override
  String get translating => 'Traductorio...';

  @override
  String get generatingExamples => 'Generando ejemplos...';

  @override
  String get errorAnalyzingText => 'Error al analizar el texto';

  @override
  String get errorImportingItems => 'Error al importar artículos';

  @override
  String get warning => 'Advertencia';

  @override
  String get textIsVeryLarge => 'El texto es muy grande.';

  @override
  String get words => 'palabras';

  @override
  String get continueAnalysis =>
      'Esto puede tardar más en procesarse y se analizará en partes. ¿Quieres continuar?';

  @override
  String get continueLabel => 'Continuar';

  @override
  String get exportBeforeDeleteMessage =>
      '¿Le gustaría exportar este paquete antes de eliminarlo? Esto guardará todos sus datos en un archivo ZIP.';

  @override
  String get deleteWithoutExport => 'Eliminar sin exportar';

  @override
  String get exportAndDelete => 'Exportar y eliminar';

  @override
  String get exportingPackage => 'Exportando paquete...';

  @override
  String packageExportedToPath(Object path) {
    return 'Paquete exportado a: $path';
  }

  @override
  String errorLoadingItems(Object error) {
    return 'Error al cargar elementos: $error';
  }

  @override
  String badgeEarnedWithName(Object badgeName) {
    return 'Insignia obtenida: $badgeName!';
  }

  @override
  String badgeLostWithName(Object badgeName) {
    return 'Insignia perdida: $badgeName';
  }

  @override
  String get trainingSessionProgress =>
      'Estadísticas de la sesión de entrenamiento';

  @override
  String get total => 'Total';

  @override
  String lastNValue(Object value) {
    return 'norte = $value';
  }

  @override
  String errorLoadingSettings(Object error) {
    return 'Error al cargar la configuración: $error';
  }

  @override
  String get selectPackage => 'Seleccionar paquete';

  @override
  String get noPackagesAvailable => 'No hay paquetes disponibles';

  @override
  String get possibleSolutions => 'Posibles soluciones';

  @override
  String get technicalDetails => 'Detalles técnicos';

  @override
  String get close => 'Cerca';

  @override
  String get checkApiKey => 'Verifique su clave API de OpenAI';

  @override
  String get ensureValidOpenAIKey =>
      'Asegúrese de que la clave API sea válida y activa';

  @override
  String get verifyKeyInSettings => 'Verifique la clave en Configuración';

  @override
  String get rateLimitExceeded => 'Se superó el límite de tasa API';

  @override
  String get waitAndRetry => 'Espera unos minutos y vuelve a intentarlo.';

  @override
  String get checkAccountQuota => 'Verifique la cuota de su cuenta OpenAI';

  @override
  String get invalidRequest => 'Formato de solicitud no válido';

  @override
  String get tryReducingTextLength => 'Intente reducir la longitud del texto.';

  @override
  String get checkTextFormat =>
      'Comprueba que el formato del texto sea correcto.';

  @override
  String get checkInternetConnection => 'Comprueba tu conexión a Internet';

  @override
  String get retryInMoment => 'Vuelve a intentarlo en un momento';

  @override
  String get checkFirewall => 'Verifique la configuración del firewall';

  @override
  String get textMayBeTooShort => 'El texto puede ser demasiado corto';

  @override
  String get tryDifferentKnowledgeLevel =>
      'Pruebe un nivel de conocimiento diferente';

  @override
  String get ensureTextInCorrectLanguage =>
      'Asegúrese de que el texto esté en el idioma correcto';

  @override
  String get requestTimedOut => 'Solicitud agotada';

  @override
  String get textMayBeTooLong => 'El texto puede ser demasiado largo';

  @override
  String get tryAgainOrReduceSize =>
      'Inténtalo de nuevo o reduce el tamaño del texto.';

  @override
  String get unexpectedError => 'Ocurrió un error inesperado';

  @override
  String get checkErrorDetails =>
      'Verifique los detalles del error a continuación';

  @override
  String get tryAgainLater => 'Vuelve a intentarlo más tarde';

  @override
  String get translationServiceFailed => 'El servicio de traducción falló';

  @override
  String get checkApiKeys => 'Verifique sus claves API (DeepL, OpenAI)';

  @override
  String get retryImport => 'Reintentar la importación';

  @override
  String get exampleGenerationFailed => 'Error al generar el ejemplo';

  @override
  String get itemsStillImported => 'Los artículos todavía eran importados.';

  @override
  String get canAddExamplesManually =>
      'Puedes agregar ejemplos manualmente más tarde.';

  @override
  String get databaseError => 'Se produjo un error en la base de datos.';

  @override
  String get checkStorageSpace =>
      'Consultar espacio de almacenamiento disponible';

  @override
  String get restartApp => 'Intenta reiniciar la aplicación.';

  @override
  String get groupLabel => 'Grupo:';

  @override
  String get amendGroups => 'Enmendar';

  @override
  String get exportItemsJson => 'Exportar elementos (JSON)';

  @override
  String get exportItemsJsonTooltip =>
      'Exportar todos los elementos como archivo JSON';

  @override
  String get noCategoriesInPackage =>
      'No se encontraron categorías en este paquete.';

  @override
  String get noItemsToExport => 'No se encontraron artículos para exportar';

  @override
  String itemsExportedSuccessfully(int count, String path) {
    return 'Exportados exitosamente $count elementos a:\n$path';
  }

  @override
  String get errorExportingItems => 'Error al exportar artículos';

  @override
  String get languageMismatch => 'Discrepancia de idioma';

  @override
  String get languageMismatchDescription =>
      'Los idiomas del archivo JSON no coinciden con los idiomas del paquete:';

  @override
  String packageLanguages(String lang1, String lang2) {
    return 'Paquete: $lang1 → $lang2';
  }

  @override
  String jsonFileLanguages(String lang1, String lang2) {
    return 'Archivo JSON: $lang1 → $lang2';
  }

  @override
  String get continueImportQuestion =>
      '¿Quieres seguir importando de todos modos?';

  @override
  String get continueImport => 'Continuar importando';

  @override
  String get pleaseSelectPackageGroup =>
      'Por favor seleccione un grupo de paquetes';

  @override
  String get customIconLabel => 'Costumbre';

  @override
  String get defaultIconLabel => 'Por defecto';

  @override
  String get icon2Label => 'Libro abierto';

  @override
  String get icon3Label => 'Libro coloreado';

  @override
  String get icon4Label => 'Conversación';

  @override
  String get icon5Label => 'Graduación';

  @override
  String get icon6Label => 'Cerebro';

  @override
  String get icon7Label => 'Pila de libros';

  @override
  String get icon8Label => 'tarjeta didáctica';

  @override
  String get icon9Label => 'Globo';

  @override
  String get icon10Label => 'Lápiz';

  @override
  String get icon11Label => 'Trofeo';

  @override
  String get icon12Label => 'Buscar';

  @override
  String get customIconFile => 'Icono personalizado';

  @override
  String get importedIconFile => 'Icono importado';

  @override
  String get unableToReadImageFile =>
      'No se puede leer el archivo de imagen. Por favor seleccione una imagen válida.';

  @override
  String iconDimensionsTooLarge(int width, int height) {
    return 'Las dimensiones del icono son demasiado grandes (${width}x$height). El máximo permitido es 512x512 píxeles.';
  }

  @override
  String get iconFileTooLarge =>
      'El archivo de icono es demasiado grande. El tamaño máximo es 1 MB.';

  @override
  String failedToUploadIcon(String error) {
    return 'No se pudo cargar el ícono: $error';
  }

  @override
  String get pleaseSelectValidLanguage =>
      'Por favor seleccione un idioma válido de la lista';

  @override
  String get status => 'Estado';

  @override
  String get addExample => 'Agregar ejemplo';

  @override
  String get noExamplesYet =>
      'Aún no hay ejemplos. Haga clic en + para agregar.';

  @override
  String get speakText => 'hablar texto';

  @override
  String get removeCategory => 'Eliminar categoría';

  @override
  String removeCategoryConfirm(String categoryName) {
    return '¿Eliminar la categoría \"$categoryName\" de este artículo?';
  }

  @override
  String get remove => 'Eliminar';

  @override
  String get extractFullItems => 'Extraer elementos completos';

  @override
  String get pasteFromClipboard => 'Pegar desde el portapapeles';

  @override
  String get noItemsFoundOrAllDuplicates =>
      'No se encontraron elementos en el texto o ya existen todos los elementos en el paquete';

  @override
  String get aboutLanguageRally => 'Acerca del Rally de Idiomas';

  @override
  String get welcomeTitle => '🚀 Bienvenidos al Rally de Idiomas';

  @override
  String get welcomeSubtitle =>
      'Desbloquee el increíble poder del aprendizaje de idiomas con aproximadamente 4000 palabras, 4000 expresiones y la misma cantidad de oraciones de ejemplo, ¡cuidadosamente seleccionadas para cada nivel de dominio! Utilice la IA para importar elementos de sus propios textos o charle con la IA sobre cualquier tema para generar las palabras, expresiones y ejemplos exactos que desea aprender.\nMejora tus habilidades lingüísticas, ¡de forma inteligente y divertida!';

  @override
  String get welcomeIntro =>
      'Aprenda vocabulario y expresiones de manera eficiente practicando lo que realmente le interesa. Sin listas aburridas. Sin pérdida de tiempo.';

  @override
  String get sectionPlayYourGame => '🎮 Juega tu propio juego';

  @override
  String get sectionPlayYourGameDesc =>
      'Crea tus propios paquetes de vocabulario. Entrena sólo las palabras y expresiones que quieras dominar. ¿Ya lo sabes? ¡Será marcado y omitido!';

  @override
  String get sectionAITeammate => '🤖 IA como tu compañero de equipo';

  @override
  String get sectionAITeammateDesc =>
      'Pega cualquier texto y deja que AI:\n• Extraer vocabulario útil\n• Elige expresiones que coincidan con tu nivel\n• Cree paquetes listos para entrenar en segundos\n\nChatea con la IA:\n• Deja que te sugiera palabras y expresiones para tu tema.\n• Haga clic para generar ejemplos y guardarlos en su PROPIO paquete';

  @override
  String get sectionTrainSmart => '🔁 Entrena de forma inteligente';

  @override
  String get sectionTrainSmartDesc =>
      'Nuestro sistema de repetición afinado muestra elementos exactamente cuando su cerebro los necesita para memorizarlos de manera efectiva. Progreso máximo. Mínimo esfuerzo.';

  @override
  String get sectionRealExamples => '🌍 Ejemplos reales. Grandes traducciones.';

  @override
  String get sectionRealExamplesDesc =>
      'Obtenga ejemplos de uso en el mundo real. Traduce con calidad premium a través de DeepL. Practica la pronunciación y suena seguro.';

  @override
  String get sectionTeachersWelcome => '👩‍🏫 Maestros bienvenidos';

  @override
  String get sectionTeachersWelcomeDesc =>
      'Cree un paquete → Copie y pegue elementos o extraiga, traduzca y agregue ejemplos con AI → Exportar → Cargar/Enviar → Listo. Tus alumnos lo importan y comienzan a practicar al instante.';

  @override
  String get sectionUnlockAI => '🔑 Desbloquea todo el poder de la IA';

  @override
  String get sectionUnlockAIDesc =>
      'Para traducción de alta calidad y funciones de IA, simplemente:\n\n1. Crea tu clave API de DeepL\n   https://www.deepl.com/pro-api\n2. Cree su clave API de OpenAI\n   https://platform.openai.com/api-keys\n3. Pegue ambas claves en Configuración\n\nUna pequeña inversión desbloquea potentes herramientas lingüísticas de nivel profesional. ¿Por qué te las perderías?\n(Recomendamos utilizar el acceso API pago para obtener mejores resultados).';

  @override
  String get readyToStart => '¿Listo para comenzar tu rally? 🏁';

  @override
  String get welcomeDescription =>
      'Language Rally es su compañero integral de aprendizaje de idiomas. Cree paquetes de vocabulario personalizados, organice elementos por categorías y entrene con un sistema inteligente de repetición espaciada.';

  @override
  String get browseStore => 'Explorar tienda';

  @override
  String get featureInteractiveTraining => 'Entrenamiento interactivo';

  @override
  String get featureInteractiveTrainingDesc =>
      'Practica con algoritmos de aprendizaje adaptativo';

  @override
  String get featureSmartOrganization => 'Organización inteligente';

  @override
  String get featureSmartOrganizationDesc =>
      'Categoriza y filtra tu vocabulario';

  @override
  String get featureTrackProgress => 'Seguimiento del progreso';

  @override
  String get featureTrackProgressDesc =>
      'Supervise su aprendizaje con estadísticas detalladas';

  @override
  String get featureImportExport => 'Importar y Exportar';

  @override
  String get featureImportExportDesc =>
      'Comparta paquetes y sincronícelos entre dispositivos';

  @override
  String get startAppTour => 'Iniciar recorrido por la aplicación';

  @override
  String get quickStartGuide => 'Guía de inicio rápido';

  @override
  String get tourStep1Title => 'Crear o importar paquetes';

  @override
  String get tourStep1Desc =>
      'Comience creando un nuevo paquete de idioma o importe uno existente desde un archivo.';

  @override
  String get tourStep2Title => 'Agregar elementos de vocabulario';

  @override
  String get tourStep2Desc =>
      'Explore sus paquetes y agregue palabras, frases o expresiones con ejemplos y categorías.';

  @override
  String get tourStep3Title => 'Configurar entrenamiento';

  @override
  String get tourStep3Desc =>
      'Elija qué elementos practicar, establezca niveles de dificultad y personalice su experiencia de aprendizaje.';

  @override
  String get tourStep4Title => 'Empezar a aprender';

  @override
  String get tourStep4Desc =>
      'Comience su sesión de entrenamiento y marque elementos como conocidos o desconocidos para realizar un seguimiento de su progreso.';

  @override
  String get tourStep5Title => 'Revisar estadísticas';

  @override
  String get tourStep5Desc =>
      'Verifique su progreso de aprendizaje con estadísticas detalladas e insignias de logros.';

  @override
  String get gotIt => '¡Entiendo!';

  @override
  String get appTourTitle => 'Bienvenidos al Rally de Idiomas';

  @override
  String get appTourSubtitle =>
      'Tu compañero de aprendizaje de idiomas inteligente, divertido y totalmente personalizado.';

  @override
  String get tourPage1Title =>
      'Aprende y practica lo que quieres y lo que necesitas';

  @override
  String get tourPage1Desc =>
      'Nuestro sistema de aprendizaje adaptativo garantiza que revise los elementos en el momento perfecto, maximizando la retención y minimizando el esfuerzo.\n\nAprenda con la ayuda de la automatización incorporada.\nDeja de perder el tiempo con palabras que ya conoces.\n\nPractica sólo el vocabulario y las expresiones que te interesen. Crea y entrena tus propios elementos, totalmente adaptados a tus objetivos y nivel.';

  @override
  String get tourPage2Title => 'Crea tu propio paquete de idiomas';

  @override
  String get tourPage2Desc =>
      'Cree colecciones de vocabulario personalizadas que coincidan con sus intereses y objetivos de aprendizaje.\n\nOrganiza palabras y expresiones por tema, dificultad o contexto.\n\nControl total sobre lo que aprendes y cuándo.';

  @override
  String get tourPage3Title => 'Creación de artículos impulsada por IA';

  @override
  String get tourPage3Desc =>
      'Cree sus propios paquetes de aprendizaje en un abrir y cerrar de ojos:\n\n• Pega cualquier texto y deja que la IA extraiga vocabulario relevante automáticamente\n• Identificar palabras y expresiones perfectamente adaptadas a tu nivel.\n• Deja que la IA haga la traducción por ti\n• Deje que la IA busque ejemplos en tiempo real\n\nChatea con la IA:\n• Deja que te sugiera palabras y expresiones para tu tema.\n• Haga clic para generar ejemplos y guardarlos en su PROPIO paquete\n• Cree paquetes listos para la capacitación rápidamente';

  @override
  String get tourPage4Title =>
      'Ejemplos del mundo real impulsados ​​por IA y traducción premium';

  @override
  String get tourPage4Desc =>
      '• Busque instantáneamente ejemplos de uso auténticos\n• Traduce palabras, expresiones y oraciones completas con integración DeepL de alta calidad\n• Obtenga resultados precisos y contextuales';

  @override
  String get tourPage5Title => 'Organización inteligente de paquetes';

  @override
  String get tourPage5Desc =>
      '• Organizar el vocabulario en categorías personalizadas\n• Filtrar y centrarse en temas específicos\n• Importar y exportar paquetes entre dispositivos\n• Comparta paquetes fácilmente con otros';

  @override
  String get tourPage6Title => 'Entrenando tu pronunciación';

  @override
  String get tourPage6Desc =>
      'Pruebe y mejore su pronunciación con herramientas de práctica interactivas.\n\nGenere confianza al hablar, no solo al leer.';

  @override
  String get tourPage7Title => 'Para profesores';

  @override
  String get tourPage7Desc =>
      'Cree paquetes de vocabulario listos para usar para sus alumnos con solo unos pocos clics.\n\nExportarlos, enviarlos a su clase y, una vez importados, estarán listos instantáneamente para practicar en el dispositivo de cada estudiante.\n\nSimple. Rápido. Eficaz.';

  @override
  String get tourPage8Title => 'Desbloquee soporte de IA de alta calidad';

  @override
  String get tourPage8Desc =>
      'Para traducciones premium y funciones avanzadas de IA, simplemente:\n 1. Crea tu propia clave API de DeepL\n 2. Crea tu propia clave API de OpenAI\n 3. Pegue ambas claves en la sección Configuración.\n\nEsto requiere sólo un pequeño presupuesto (unos pocos dólares), pero le brinda acceso a herramientas lingüísticas potentes y de nivel profesional.\nNota: Recomendamos utilizar el acceso API pago para obtener mejores resultados. Cuesta sólo unos pocos dólares.\n\n🔑 Clave API de DeepL: https://www.deepl.com/pro-api\n\n🔑 Clave API de OpenAI: https://platform.openai.com/api-keys';

  @override
  String get previousPage => 'Anterior';

  @override
  String get nextPage => 'Próximo';

  @override
  String get endTour => 'Fin del recorrido';

  @override
  String pageIndicator(int current, int total) {
    return 'Página $current de $total';
  }

  @override
  String get practicePronunciation => 'Practica la pronunciación';

  @override
  String get pronunciationPractice => 'Práctica de pronunciación';

  @override
  String get startPractice => 'Empezar a practicar';

  @override
  String get listenToPronunciation => 'Escuchar la pronunciación';

  @override
  String get tapToRecord => 'Toca para grabar';

  @override
  String get recording => 'Grabación...';

  @override
  String get recorded => 'Grabado';

  @override
  String get speakNow =>
      'Habla ahora: habla con claridad y cerca del micrófono.';

  @override
  String get noSpeechDetected =>
      'No se detectó ninguna voz. Por favor inténtalo de nuevo.';

  @override
  String get noTextRecognized =>
      'No se reconoció ningún discurso en la grabación. Asegúrese de que su micrófono esté funcionando e inténtelo nuevamente.';

  @override
  String get processingAudio => 'Procesando audio con IA...';

  @override
  String get playbackRecording => 'Reproducir mi grabación';

  @override
  String get playbackRecordingSubtitle =>
      'Escuche su grabación mientras la IA la procesa';

  @override
  String get recordingTooShort =>
      'Grabación demasiado corta. Por favor habla durante al menos 1 segundo.';

  @override
  String get microphonePermissionRequired =>
      'Se requiere permiso del micrófono para practicar la pronunciación.';

  @override
  String get speechRecognitionNotSupported =>
      'Esta plataforma no admite el reconocimiento de voz. Utilice la aplicación móvil (Android/iOS) para practicar la pronunciación.';

  @override
  String get speechRecognitionUnavailable =>
      'El reconocimiento de voz no está disponible en este dispositivo.';

  @override
  String get pronunciationAccuracy => 'Pronunciación\nPrecisión';

  @override
  String get excellent => '¡Excelente!';

  @override
  String get good => 'Bien';

  @override
  String get fair => 'Justo';

  @override
  String get needsImprovement => 'Necesita mejorar';

  @override
  String get tryAgain => 'Intentar otra vez';

  @override
  String get nextItem => 'Siguiente artículo';

  @override
  String get endPractice => 'Finalizar la práctica';

  @override
  String get practiced => 'Experto';

  @override
  String get windowsAudioTestPageTitle =>
      'Prueba de audio de Windows (RTAudio)';

  @override
  String get configureWindowsAudio =>
      'Probar y configurar audio\nentrada en Windows';

  @override
  String get configureWindowsAudioDescription =>
      'Grabe, reproduzca y transcriba audio utilizando el controlador RTAudio nativo de Windows';

  @override
  String get audioTestTitle => 'Prueba de grabación de audio de Windows';

  @override
  String get audioTestSubtitle =>
      'RTAudio: grabación de audio nativa de Windows';

  @override
  String get audioInputDevice => 'Dispositivo de entrada de audio';

  @override
  String get selectMicrophone => 'Seleccionar micrófono';

  @override
  String get refreshDevices => 'Actualizar dispositivos';

  @override
  String get noAudioDevicesFound =>
      'No se encontraron dispositivos de entrada de audio';

  @override
  String get loadingAudioDevices => 'Cargando dispositivos de audio...';

  @override
  String get recordingSettings => 'Configuración de grabación';

  @override
  String get stereoRecording => 'Grabación estéreo';

  @override
  String get stereoChannels => '2 canales (estéreo)';

  @override
  String get monoChannel => '1 canal (mono)';

  @override
  String get sampleRateLabel => 'Frecuencia de muestreo';

  @override
  String get nativeRateBadge => 'nativo';

  @override
  String get microphoneGainLabel => 'Ganancia de micrófono';

  @override
  String get gainHint => '1x = sin refuerzo • 3x ≈ +9,5 dB • 10x ≈ +20 dB';

  @override
  String get tapToStartRec => 'Toque para comenzar a grabar';

  @override
  String get tapToStopRec => 'Toque para detener la grabación';

  @override
  String get recordingCompleteLabel => 'Grabación completa';

  @override
  String get tapMicToStop => 'Toque el micrófono para detener';

  @override
  String get playRecordingLabel => 'Reproducir grabación';

  @override
  String get stopPlaybackLabel => 'Detener';

  @override
  String get whisperSectionTitle => 'Transcripción de susurros de OpenAI';

  @override
  String get whisperWavNote =>
      'Whisper admite WAV (PCM de 16 bits) de forma nativa, sin necesidad de conversión.';

  @override
  String get sendToWhisperLabel => 'Enviar a susurro';

  @override
  String get transcribingLabel => 'Transcribiendo...';

  @override
  String get transcriptionResultLabel => 'Resultado de la transcripción';

  @override
  String get transcriptionFailedLabel => 'Error de transcripción';

  @override
  String get debugInformationLabel => 'Información';

  @override
  String get debugConsoleHint =>
      'Consulte la consola para obtener registros detallados.';

  @override
  String get debugDevicesFound => 'Dispositivos encontrados';

  @override
  String get debugSelectedDevice => 'Dispositivo seleccionado';

  @override
  String get debugDeviceRateNative => 'Tarifa del dispositivo (nativo)';

  @override
  String get debugRequestedRate => 'Tarifa solicitada';

  @override
  String get debugActualRate => 'Tarifa real utilizada';

  @override
  String get debugActualRateForced => '⚠ forzado';

  @override
  String get debugActualRateOk => '✓';

  @override
  String get debugRecordingMode => 'Modo de grabación';

  @override
  String get debugLastRecording => 'Última grabación';

  @override
  String get debugFileSize => 'Tamaño de archivo';

  @override
  String get debugStereo => 'Estéreo';

  @override
  String get debugMono => 'Mononucleosis infecciosa';

  @override
  String get recordingSavedSnack => 'Grabación guardada';

  @override
  String get recordingTooShortSnack =>
      'La grabación es demasiado corta. Por favor grabe durante al menos 1 segundo.';

  @override
  String get recordingSmallSnack =>
      'El archivo de grabación es muy pequeño. Es posible que la grabación haya fallado.';

  @override
  String get noAudioDataSnack => 'No hay datos de audio grabados';

  @override
  String get noDeviceSelectedSnack =>
      'Por favor seleccione un dispositivo de audio';

  @override
  String get failedToInitRtAudio => 'No se pudo inicializar RTAudio';

  @override
  String get envelopeScoreLabel => 'Sobre';

  @override
  String get rhythmScoreLabel => 'Ritmo';

  @override
  String get textScoreLabel => 'Texto';

  @override
  String get help => 'Ayuda';

  @override
  String get trainingHelpTitle => 'Consejos de entrenamiento';

  @override
  String get trainingHelpText =>
      'Para que tu entrenamiento sea lo más efectivo posible, sigue estos pasos:\n1. Haga clic en el botón \'Borrar contadores\' para que todos los elementos de este paquete se marquen como conocidos.\n2. Establezca \'Alcance del artículo\' en \'Todos los artículos\'\n3. Establezca \'Orden de artículos\' en \'Aleatorio\'\n4. Elija su idioma nativo en \'Idioma de visualización\'\n5. Inicie la capacitación y continúe hasta que identifique aproximadamente entre 20 y 30 elementos que no conoce.\n6. Regrese a la configuración de capacitación y cambie \'Alcance del elemento\' a \'Solo elementos desconocidos\'\n7. Reanude el entrenamiento y continúe hasta que haya aprendido todos los elementos desconocidos anteriormente.';

  @override
  String get trainingProTip =>
      'Consejo profesional: comience con todos los elementos; Más tarde, concéntrate sólo en lo desconocido.';

  @override
  String get onboardingWelcomeTitle => '¡Bienvenidos al Rally de Idiomas!';

  @override
  String get onboardingSetupSubtitle =>
      'Configuremos la aplicación para usted.';

  @override
  String get onboardingSelectUiLanguage => 'Idioma de la interfaz';

  @override
  String get onboardingUiLanguageNote =>
      'Puede cambiar esto más tarde en Configuración → Idioma de la interfaz de usuario.';

  @override
  String get onboardingNext => 'Próximo';

  @override
  String get onboardingBack => 'Atrás';

  @override
  String get onboardingSelectPackagesTitle => 'Elija paquetes de idiomas';

  @override
  String get onboardingSelectPackagesSubtitle =>
      'Seleccione qué paquetes de vocabulario importar. Siempre puedes agregar más más tarde desde el menú principal (Ver paquetes).';

  @override
  String get onboardingAnalyzingPackages => 'Analizando paquetes disponibles…';

  @override
  String onboardingScanningPackagesProgress(
    int scanned,
    int total,
    int alreadyInDb,
  ) {
    return 'Escaneado $scanned/$total • ya en DB $alreadyInDb';
  }

  @override
  String get onboardingImportSelected => 'Importar seleccionado';

  @override
  String get onboardingSkipImport => 'Saltar';

  @override
  String get onboardingSelectAll => 'Seleccionar todo';

  @override
  String get onboardingDeselectAll => 'Deseleccionar todo';

  @override
  String onboardingNPackages(int count) {
    return '$count paquetes';
  }

  @override
  String get onboardingGetStarted => 'Empezar';

  @override
  String get onboardingImportCompleteTitle => '¡Importación completada!';

  @override
  String get importBuiltInPkg => 'Paquetes gratis';

  @override
  String get importBuiltInPkgTooltip =>
      'Importe paquetes de idiomas incluidos de forma gratuita';

  @override
  String get globalSearch => 'Búsqueda global';

  @override
  String get globalSearchTitle => 'Buscar en todos los paquetes';

  @override
  String get globalSearchSelectLanguage => 'Seleccionar código de idioma';

  @override
  String get globalSearchEnterWord => 'Palabra(s) a buscar';

  @override
  String get globalSearchEnterWordHint =>
      'p.ej. \"der\", \"order\" — busca coincidencias parciales';

  @override
  String get globalSearchButton => 'Buscar';

  @override
  String get globalSearchResults => 'Resultados';

  @override
  String globalSearchNoResults(String query) {
    return 'No se han encontrado resultados para \"$query\"';
  }

  @override
  String globalSearchResultsCount(int count) {
    return '$count resultado(s) encontrado(s)';
  }

  @override
  String get globalSearchSearching => 'Búsqueda…';

  @override
  String get globalSearchSelectLanguageFirst =>
      'Seleccione primero un código de idioma';

  @override
  String get globalSearchEnterTermFirst =>
      'Por favor ingrese un término de búsqueda';

  @override
  String get globalSearchMatchInExamples => 'Encontrado en ejemplos';

  @override
  String get globalSearchViewItem => 'Vista';

  @override
  String get globalSearchGoToPackage => 'Ir al paquete';

  @override
  String get globalSearchLoadingPackages => 'Cargando paquetes…';

  @override
  String get globalSearchNoPackages =>
      'Aún no hay paquetes de idiomas instalados';

  @override
  String get globalSearchCancelSearch => 'Cancelar búsqueda';

  @override
  String globalSearchProgressOf(int current, int total) {
    return 'Buscando paquete $current de $total…';
  }

  @override
  String globalSearchCancelledMessage(int count) {
    return 'Búsqueda cancelada: $count resultado(s) encontrado(s) hasta el momento';
  }

  @override
  String get storeTitle => 'Tienda de paquetes de idiomas';

  @override
  String get storeRestorePurchases => 'Restaurar compras';

  @override
  String get storeRefresh => 'Refrescar';

  @override
  String get storeSearchHint => 'Buscar paquetes…';

  @override
  String get storeNoPackagesMatchSearch =>
      'Ningún paquete coincide con su búsqueda.';

  @override
  String get storeNoPackagesAvailable => 'No hay paquetes disponibles.';

  @override
  String storeInstalledCount(int installed, int total) {
    return '$installed / $total instalado';
  }

  @override
  String get storeLoadErrorTitle => 'No se pudo cargar la tienda.';

  @override
  String get storeIapNotAvailableMessage =>
      'Las compras dentro de la aplicación no están disponibles en esta plataforma. Visita nuestro sitio web para comprar paquetes.';

  @override
  String get storeOpenWebsite => 'Abrir sitio web';

  @override
  String storePurchaseSuccess(String title) {
    return '¡$title se instaló exitosamente!';
  }

  @override
  String get storePurchaseCancelled => 'Compra cancelada.';

  @override
  String storePurchaseAlreadyOwned(String title) {
    return '$title ya está instalado.';
  }

  @override
  String get storePurchaseError =>
      'Algo salió mal. Por favor inténtalo de nuevo.';

  @override
  String get storePurchasesRestored => 'Compras restauradas';

  @override
  String get storeAllLevels => 'Todos los niveles';

  @override
  String get storeAllGroups => 'Todos los idiomas';

  @override
  String get storeFilterLevel => 'Nivel';

  @override
  String get storeFilterLanguage => 'Idioma';

  @override
  String get storeDownload => 'Descargar';

  @override
  String get storeBuy => 'Comprar';

  @override
  String get storeInstalledLabel => 'Instalado';

  @override
  String get storeDownloading => 'Descargando…';

  @override
  String get storeRetry => 'Rever';

  @override
  String get storeIapAndroidOnly =>
      'Compras disponibles solo en Android e iOS.';

  @override
  String get storeDismiss => 'Despedir';

  @override
  String get storeAddToCart => 'añadir a la cesta';

  @override
  String get storeRemoveFromCart => 'Eliminar';

  @override
  String get storeCartTitle => 'Carro de la compra';

  @override
  String get storeCartEmpty => 'Tu carrito está vacío';

  @override
  String get storeCartClearAll => 'Borrar todo';

  @override
  String get storeCartCheckout => 'Verificar';

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
  String get storePackageDuplicateTitle => 'El paquete ya existe';

  @override
  String storePackageDuplicateMessage(String packageName, String groupName) {
    return 'El paquete \"$packageName\" ya existe en el grupo \"$groupName\". ¿Quieres sobrescribirlo? El paquete existente y todo su progreso de capacitación se eliminarán permanentemente.';
  }

  @override
  String get storePackageDuplicateOverwrite => 'Exagerar';

  @override
  String get storePackageDuplicateKeep => 'Mantener existente';

  @override
  String splashSettingUpPackages(int current, int total) {
    return 'Configurando paquetes: $current / $total';
  }

  @override
  String get splashThisHappensOnce => 'Esto sólo sucede una vez.';

  @override
  String get splashLoading => 'Cargando…';

  @override
  String get aiItemCreator => 'Gurú del chat de IA';

  @override
  String get aiItemCreatorAppBarHint =>
      'Recoge y guarda palabras y expresiones chateando con la IA.';

  @override
  String get chatWithAI => 'Chatea con IA';

  @override
  String get enterYourPrompt => 'Ingrese su mensaje...';

  @override
  String get aiItemCreatorPromptHint =>
      'Describe un tema y el entrenador de IA te hará preguntas, te sugerirá vocabulario útil y pondrá a prueba tus conocimientos. Por ejemplo: ayúdame a recopilar y practicar los peligros relacionados con los viajes en el nivel de conocimiento B2.';

  @override
  String get send => 'Enviar';

  @override
  String get sending => 'Envío...';

  @override
  String get aiResponse => 'Respuesta de la IA';

  @override
  String get itemInputs => 'Entradas de artículos';

  @override
  String get aiItemCreatorBothItemsRequired =>
      'Complete ambos campos de idioma antes de guardar.';

  @override
  String get aiItemCreatorDuplicateItemMessage =>
      'Ya existe un artículo con el mismo par de texto en este paquete.';

  @override
  String get language1 => 'Idioma 1';

  @override
  String get language2 => 'Idioma 2';

  @override
  String get translateLang1ToLang2 => 'Traducir al idioma 2';

  @override
  String get translateLang2ToLang1 => 'Traducir al idioma 1';

  @override
  String translateToLanguageCode(String languageCode) {
    return 'Traducir a $languageCode';
  }

  @override
  String get example => 'Ejemplo';

  @override
  String get generating => 'Generando...';

  @override
  String get flags => 'Banderas';

  @override
  String get favorite => 'Favorito';

  @override
  String get saveItems => 'Ahorrar';

  @override
  String get saving => 'Ahorro...';

  @override
  String get clearItems => 'Borrar solo elementos';

  @override
  String get clearAll => 'Borrar todos los campos';

  @override
  String get itemSavedSuccessfully => 'Artículo guardado exitosamente';

  @override
  String get promptCannotBeEmpty => 'El mensaje no puede estar vacío';

  @override
  String get enterAtLeastOneItem => 'Por favor ingresa al menos un elemento';

  @override
  String get selectPackageFirst => 'Por favor seleccione un paquete primero';

  @override
  String get deeplKeyRequired =>
      'Se requiere la clave API de DeepL para la traducción';

  @override
  String get noNonPurchasedPackagesAvailable =>
      'No hay paquetes disponibles no comprados';

  @override
  String get packageSelectionRemembered => 'Selección de paquete guardada';

  @override
  String get aiItemCreatorOpenAiKeyNotConfiguredDetailed =>
      'La clave API de OpenAI no está configurada. Agregue su clave API en Configuración.';

  @override
  String get aiItemCreatorOpenAiKeyNotConfigured =>
      'La clave API de OpenAI no está configurada.';

  @override
  String get aiItemCreatorProcessingComplete => 'Procesamiento completo';

  @override
  String get aiItemCreatorTranslationComingSoon =>
      'Función de traducción próximamente';

  @override
  String get aiItemCreatorDefaultCategoryName => 'IA creada';

  @override
  String get aiItemCreatorStartNewConversation => 'Iniciar nueva conversación';

  @override
  String get aiItemCreatorChatHint =>
      'Describe un tema y el entrenador de IA te hará preguntas, te sugerirá vocabulario útil y pondrá a prueba tus conocimientos.';

  @override
  String get aiItemCreatorConversation => 'Conversación';

  @override
  String get aiItemCreatorYou => 'Tú';

  @override
  String get aiItemCreatorCoach => 'Entrenador de IA';

  @override
  String get aiItemCreatorAiSuggestions => 'Sugerencias de IA';

  @override
  String get aiItemCreatorTapChipToFill =>
      'Toque un chip para completar un campo de elemento y traducirlo automáticamente.';

  @override
  String get aiItemCreatorNoSuggestedItems =>
      'Aún no hay palabras ni expresiones.';

  @override
  String get aiItemCreatorNextSteps => 'como continuar';

  @override
  String get aiItemCreatorNoNextSteps =>
      'Aún no hay sugerencias de continuación.';

  @override
  String get aiItemCreatorModelCostTip =>
      'Consejo profesional: los modelos más nuevos son más caros, mientras que los modelos más antiguos y turbo son más baratos y pueden ser significativamente más rápidos.';

  @override
  String get aiItemCreatorSelectPackageDialogTitle =>
      'Elija el paquete de idioma';

  @override
  String get aiItemCreatorSelectPackageDialogMessage =>
      'Seleccione el paquete de idioma que desea utilizar en esta sesión. Su última opción está preseleccionada.';

  @override
  String aiItemCreatorMissingApiKeysWarning(String keys) {
    return 'Claves API faltantes: $keys. Puede continuar, pero las funciones de traducción premium e IA pueden ser limitadas.';
  }

  @override
  String get about => 'Acerca de';

  @override
  String get aboutWebsite => 'Sitio web';

  @override
  String get aboutSummaryVideo => 'Video resumen';

  @override
  String get aboutSupportEmail => 'Dirección de correo electrónico de soporte';

  @override
  String get aboutWebsiteUrl => 'https://sites.google.com/view/language-rally';

  @override
  String get aboutSummaryVideoUrl =>
      'https://www.youtube.com/watch?v=64Pl9iNF88c';

  @override
  String get aboutSupportEmailAddress => 'languagerally.support@gmail.com';

  @override
  String aboutVersionWithValue(String version) {
    return 'Versión: $version';
  }

  @override
  String aboutCouldNotOpen(String uri) {
    return 'No se pudo abrir: $uri';
  }

  @override
  String get aboutWelcomeSplashNotFound =>
      'Imagen de presentación de bienvenida no encontrada';

  @override
  String get chooseTheme => 'Elige el tema';

  @override
  String get darkMode => 'Modo oscuro';

  @override
  String get toggleBetweenLightAndDark => 'Alternar entre claro y oscuro';

  @override
  String get colorTheme => 'Tema de color:';

  @override
  String get toggleBrightness => 'Alternar brillo';

  @override
  String get changeTheme => 'Cambiar tema';

  @override
  String get managePackageGroups => 'Administrar grupos de paquetes';

  @override
  String get noPackageGroups => 'Sin grupos de paquetes';

  @override
  String get createFirstPackageGroup => 'Crea tu primer grupo de paquetes';

  @override
  String get addGroup => 'Agregar grupo';

  @override
  String get addPackageGroup => 'Agregar grupo de paquetes';

  @override
  String get editPackageGroup => 'Editar grupo de paquetes';

  @override
  String get groupName => 'Nombre del grupo';

  @override
  String get enterGroupName => 'Introduzca el nombre del grupo';

  @override
  String get groupNameRequired => 'El nombre del grupo es obligatorio.';

  @override
  String get duplicateGroupName => 'Nombre duplicado';

  @override
  String groupNameAlreadyExists(String name) {
    return 'Ya existe un grupo con el nombre \"$name\".';
  }

  @override
  String groupCreatedSuccessfully(String name) {
    return 'Grupo \"$name\" creado exitosamente';
  }

  @override
  String failedToCreateGroup(String error) {
    return 'No se pudo crear el grupo: $error';
  }

  @override
  String groupRenamedTo(String name) {
    return 'Grupo renombrado a \"$name\"';
  }

  @override
  String failedToUpdateGroup(String error) {
    return 'No se pudo actualizar el grupo: $error';
  }

  @override
  String get deleteGroup => 'Eliminar grupo';

  @override
  String deleteGroupConfirm(String name) {
    return '¿Está seguro de que desea eliminar el grupo \"$name\"?\n\nEsta acción no se puede deshacer.';
  }

  @override
  String get cannotDeleteGroup => 'No se puede eliminar';

  @override
  String groupHasPackages(int count) {
    return 'Este grupo todavía tiene $count paquete(s). Muévalos o elimínelos primero.';
  }

  @override
  String groupDeleted(String name) {
    return 'Grupo \"$name\" eliminado';
  }

  @override
  String failedToDeleteGroup(String error) {
    return 'No se pudo eliminar el grupo: $error';
  }

  @override
  String get cannotDeleteHasPackagesTooltip =>
      'No se puede eliminar (tiene paquetes)';

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
  String get manageGroups => 'Administrar grupos';

  @override
  String get featureLangPower => 'Poder del lenguaje';

  @override
  String get featureAiIntegration => 'Integración de IA';

  @override
  String get featureAdaptivePractice => 'Práctica adaptativa';

  @override
  String get featureMasterAccent => 'acento maestro';

  @override
  String get allBadgesEarned =>
      '🎉 ¡Todas las insignias obtenidas! ¡Eres un Maestro!';

  @override
  String nextBadgeLabel(String name) {
    return 'Siguiente: $name';
  }

  @override
  String pointsToGo(String percent) {
    return '$percent% para ir';
  }

  @override
  String progressPercent(String percent) {
    return '$percent% de progreso';
  }

  @override
  String errorTogglingFavourite(String error) {
    return 'Error al alternar favorito: $error';
  }

  @override
  String errorTogglingImportant(String error) {
    return 'Error al alternar importante: $error';
  }

  @override
  String categoryAdded(String name) {
    return 'Categoría \"$name\" agregada';
  }

  @override
  String errorAddingCategory(String error) {
    return 'Error al agregar categoría: $error';
  }

  @override
  String categoryRemoved(String name) {
    return 'Categoría \"$name\" eliminada';
  }

  @override
  String errorRemovingCategory(String error) {
    return 'Error al eliminar la categoría: $error';
  }

  @override
  String couldNotOpenUrl(String url) {
    return 'No se pudo abrir la URL: $url';
  }

  @override
  String errorOpeningUrl(String error) {
    return 'Error al abrir URL: $error';
  }

  @override
  String get pleaseSelectLanguage => 'Por favor seleccione un idioma';

  @override
  String get add => 'Agregar';

  @override
  String get speak => 'Hablar';

  @override
  String get recordingFailedToStart =>
      '¡La grabación no pudo comenzar!\n\nComprobar:\n1. El micrófono está conectado\n2. El micrófono está configurado como dispositivo predeterminado\n3. Ninguna otra aplicación utiliza el micrófono.';

  @override
  String get recordingFailedNoAudioFile =>
      'Error de grabación: ¡no se creó ningún archivo de audio!\n\nPosibles causas:\n1. Micrófono no conectado\n2. No se detectó ninguna entrada de audio\n3. Problema de configuración de audio de Windows';

  @override
  String errorStartingRecordingDetails(String error) {
    return 'Error al iniciar la grabación: $error';
  }

  @override
  String get openaiEmptyResponse =>
      'El modelo de IA seleccionado arrojó una respuesta vacía';

  @override
  String get tryDifferentModel =>
      'Intente seleccionar un modelo diferente en el selector de modelos.';

  @override
  String get modelMayNotBeSupported =>
      'Es posible que este modelo no sea compatible o no esté disponible para su cuenta';

  @override
  String get reduceTextOrRetry =>
      'Reduce la longitud del texto o inténtalo de nuevo.';

  @override
  String get openaiNullContent =>
      'El modelo de IA seleccionado no arrojó contenido';

  @override
  String get modelUnsupportedParameter =>
      'El modelo seleccionado no admite un parámetro API requerido';
}
