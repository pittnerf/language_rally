// lib/scripts/populate_test_data_script.dart
import 'package:uuid/uuid.dart';
import '../data/models/language_package.dart';
import '../data/models/language_package_group.dart';
import '../data/models/category.dart';
import '../data/models/item.dart';
import '../data/models/item_language_data.dart';
import '../data/repositories/language_package_repository.dart';
import '../data/repositories/language_package_group_repository.dart';
import '../data/repositories/category_repository.dart';
import '../data/repositories/item_repository.dart';

/// Standalone script to populate the database with comprehensive test data
/// Run this with: flutter run lib/scripts/populate_test_data_script.dart
Future<void> main() async {
  // print('🚀 Starting comprehensive test data population...\n');

  final uuid = const Uuid();
  final packageRepo = LanguagePackageRepository();
  final groupRepo = LanguagePackageGroupRepository();
  final categoryRepo = CategoryRepository();
  final itemRepo = ItemRepository();

  try {
    // Create or get default package group
    const defaultGroupId = 'default-group-id';
    const defaultGroupName = 'Default';

    var defaultGroup = await groupRepo.getGroupById(defaultGroupId);

    if (defaultGroup == null) {
      defaultGroup = LanguagePackageGroup(
        id: defaultGroupId,
        name: defaultGroupName,
      );
      await groupRepo.insertGroup(defaultGroup);
      // print('✓ Created default package group: "$defaultGroupName"\n');
    } else {
      // print('✓ Using existing default package group: "$defaultGroupName"\n');
    }

    // Package 1: English → Spanish
    await _createEnglishSpanishPackage(uuid, packageRepo, categoryRepo, itemRepo, defaultGroupId);

    // Package 2: English → German
    await _createEnglishGermanPackage(uuid, packageRepo, categoryRepo, itemRepo, defaultGroupId);

    // Package 3: English → French
    await _createEnglishFrenchPackage(uuid, packageRepo, categoryRepo, itemRepo, defaultGroupId);

    // Package 4: Hungarian → English
    await _createHungarianEnglishPackage(uuid, packageRepo, categoryRepo, itemRepo, defaultGroupId);

    // print('\n✅ Test data population completed successfully!');
    // print('📊 Total: 4 packages with 120 items created');
  } catch (e) {
    // print('❌ Error: $e');
    // print('Stack trace: $stackTrace');
  }
}

// ============================================================================
// Package 1: English → Spanish (30 items)
// ============================================================================

Future<void> _createEnglishSpanishPackage(
  Uuid uuid,
  LanguagePackageRepository packageRepo,
  CategoryRepository categoryRepo,
  ItemRepository itemRepo,
  String groupId,
) async {
  // print('📦 Creating English → Spanish package...');
  final packageId = uuid.v4();

  final package = LanguagePackage(
    id: packageId,
    groupId: groupId,
    packageName: 'Spanish Essentials',
    languageCode1: 'en-US',
    languageName1: 'English (United States)',
    languageCode2: 'es-ES',
    languageName2: 'Spanish (Spain)',
    description: 'Comprehensive Spanish vocabulary for everyday communication',
    icon: null,
    authorName: 'María García',
    authorEmail: 'maria@languagerally.com',
    authorWebpage: 'https://languagerally.com',
    version: '1.0.0',
    packageType: PackageType.userCreated,
    isPurchased: false,
    isReadonly: false,
    createdAt: DateTime.now(),
    price: 0.0,
  );

  await packageRepo.insertPackage(package);

  // Create categories
  final greetings = Category(id: uuid.v4(), packageId: packageId, name: 'Greetings', description: 'Common greetings and polite expressions');
  final food = Category(id: uuid.v4(), packageId: packageId, name: 'Food & Drinks', description: 'Restaurant and grocery vocabulary');
  final travel = Category(id: uuid.v4(), packageId: packageId, name: 'Travel', description: 'Essential travel phrases');
  final numbers = Category(id: uuid.v4(), packageId: packageId, name: 'Numbers', description: 'Numbers and quantities');
  final time = Category(id: uuid.v4(), packageId: packageId, name: 'Time', description: 'Time expressions');

  await categoryRepo.insertCategory(greetings);
  await categoryRepo.insertCategory(food);
  await categoryRepo.insertCategory(travel);
  await categoryRepo.insertCategory(numbers);
  await categoryRepo.insertCategory(time);

  // Create 30 items
  final items = [
    // Greetings (8 items)
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [greetings.id], language1Data: const ItemLanguageData(languageCode: 'en-US', text: 'Hello'), language2Data: const ItemLanguageData(languageCode: 'es-ES', text: 'Hola'), isKnown: true, isImportant: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [greetings.id], language1Data: const ItemLanguageData(languageCode: 'en-US', text: 'Good morning'), language2Data: const ItemLanguageData(languageCode: 'es-ES', text: 'Buenos días'), isKnown: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [greetings.id], language1Data: const ItemLanguageData(languageCode: 'en-US', text: 'Good afternoon'), language2Data: const ItemLanguageData(languageCode: 'es-ES', text: 'Buenas tardes'), isKnown: false),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [greetings.id], language1Data: const ItemLanguageData(languageCode: 'en-US', text: 'Good evening'), language2Data: const ItemLanguageData(languageCode: 'es-ES', text: 'Buenas noches'), isKnown: false),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [greetings.id], language1Data: const ItemLanguageData(languageCode: 'en-US', text: 'Goodbye'), language2Data: const ItemLanguageData(languageCode: 'es-ES', text: 'Adiós'), isKnown: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [greetings.id], language1Data: const ItemLanguageData(languageCode: 'en-US', text: 'Please'), language2Data: const ItemLanguageData(languageCode: 'es-ES', text: 'Por favor'), isKnown: true, isImportant: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [greetings.id], language1Data: const ItemLanguageData(languageCode: 'en-US', text: 'Thank you'), language2Data: const ItemLanguageData(languageCode: 'es-ES', text: 'Gracias'), isKnown: true, isImportant: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [greetings.id], language1Data: const ItemLanguageData(languageCode: 'en-US', text: 'You\'re welcome'), language2Data: const ItemLanguageData(languageCode: 'es-ES', text: 'De nada'), isKnown: false),

    // Food & Drinks (8 items)
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [food.id], language1Data: const ItemLanguageData(languageCode: 'en-US', text: 'water'), language2Data: const ItemLanguageData(languageCode: 'es-ES', text: 'agua', preItem: 'el'), isKnown: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [food.id], language1Data: const ItemLanguageData(languageCode: 'en-US', text: 'bread'), language2Data: const ItemLanguageData(languageCode: 'es-ES', text: 'pan', preItem: 'el'), isKnown: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [food.id], language1Data: const ItemLanguageData(languageCode: 'en-US', text: 'coffee'), language2Data: const ItemLanguageData(languageCode: 'es-ES', text: 'café', preItem: 'el'), isKnown: false),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [food.id], language1Data: const ItemLanguageData(languageCode: 'en-US', text: 'beer'), language2Data: const ItemLanguageData(languageCode: 'es-ES', text: 'cerveza', preItem: 'la'), isKnown: false),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [food.id], language1Data: const ItemLanguageData(languageCode: 'en-US', text: 'wine'), language2Data: const ItemLanguageData(languageCode: 'es-ES', text: 'vino', preItem: 'el'), isKnown: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [food.id], language1Data: const ItemLanguageData(languageCode: 'en-US', text: 'apple'), language2Data: const ItemLanguageData(languageCode: 'es-ES', text: 'manzana', preItem: 'la'), isKnown: false, isImportant: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [food.id], language1Data: const ItemLanguageData(languageCode: 'en-US', text: 'cheese'), language2Data: const ItemLanguageData(languageCode: 'es-ES', text: 'queso', preItem: 'el'), isKnown: false),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [food.id], language1Data: const ItemLanguageData(languageCode: 'en-US', text: 'meat'), language2Data: const ItemLanguageData(languageCode: 'es-ES', text: 'carne', preItem: 'la'), isKnown: true),

    // Travel (6 items)
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [travel.id], language1Data: const ItemLanguageData(languageCode: 'en-US', text: 'airport'), language2Data: const ItemLanguageData(languageCode: 'es-ES', text: 'aeropuerto', preItem: 'el'), isKnown: false, isImportant: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [travel.id], language1Data: const ItemLanguageData(languageCode: 'en-US', text: 'train station'), language2Data: const ItemLanguageData(languageCode: 'es-ES', text: 'estación de tren', preItem: 'la'), isKnown: false),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [travel.id], language1Data: const ItemLanguageData(languageCode: 'en-US', text: 'hotel'), language2Data: const ItemLanguageData(languageCode: 'es-ES', text: 'hotel', preItem: 'el'), isKnown: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [travel.id], language1Data: const ItemLanguageData(languageCode: 'en-US', text: 'ticket'), language2Data: const ItemLanguageData(languageCode: 'es-ES', text: 'billete', preItem: 'el'), isKnown: false),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [travel.id], language1Data: const ItemLanguageData(languageCode: 'en-US', text: 'passport'), language2Data: const ItemLanguageData(languageCode: 'es-ES', text: 'pasaporte', preItem: 'el'), isKnown: true, isImportant: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [travel.id], language1Data: const ItemLanguageData(languageCode: 'en-US', text: 'suitcase'), language2Data: const ItemLanguageData(languageCode: 'es-ES', text: 'maleta', preItem: 'la'), isKnown: false),

    // Numbers (4 items)
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [numbers.id], language1Data: const ItemLanguageData(languageCode: 'en-US', text: 'one'), language2Data: const ItemLanguageData(languageCode: 'es-ES', text: 'uno'), isKnown: true, isImportant: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [numbers.id], language1Data: const ItemLanguageData(languageCode: 'en-US', text: 'two'), language2Data: const ItemLanguageData(languageCode: 'es-ES', text: 'dos'), isKnown: true, isImportant: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [numbers.id], language1Data: const ItemLanguageData(languageCode: 'en-US', text: 'ten'), language2Data: const ItemLanguageData(languageCode: 'es-ES', text: 'diez'), isKnown: false),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [numbers.id], language1Data: const ItemLanguageData(languageCode: 'en-US', text: 'hundred'), language2Data: const ItemLanguageData(languageCode: 'es-ES', text: 'cien'), isKnown: false),

    // Time (4 items)
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [time.id], language1Data: const ItemLanguageData(languageCode: 'en-US', text: 'today'), language2Data: const ItemLanguageData(languageCode: 'es-ES', text: 'hoy'), isKnown: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [time.id], language1Data: const ItemLanguageData(languageCode: 'en-US', text: 'tomorrow'), language2Data: const ItemLanguageData(languageCode: 'es-ES', text: 'mañana'), isKnown: false),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [time.id], language1Data: const ItemLanguageData(languageCode: 'en-US', text: 'yesterday'), language2Data: const ItemLanguageData(languageCode: 'es-ES', text: 'ayer'), isKnown: false),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [time.id], language1Data: const ItemLanguageData(languageCode: 'en-US', text: 'now'), language2Data: const ItemLanguageData(languageCode: 'es-ES', text: 'ahora'), isKnown: true),
  ];

  for (final item in items) {
    await itemRepo.insertItem(item);
  }

  // print('  ✓ Created 30 Spanish items across 5 categories');
}

// ============================================================================
// Package 2: English → German (30 items)
// ============================================================================

Future<void> _createEnglishGermanPackage(
  Uuid uuid,
  LanguagePackageRepository packageRepo,
  CategoryRepository categoryRepo,
  ItemRepository itemRepo,
  String groupId,
) async {
  // print('📦 Creating English → German package...');
  final packageId = uuid.v4();

  final package = LanguagePackage(
    id: packageId,
    groupId: groupId,
    packageName: 'German Basics',
    languageCode1: 'en-US',
    languageName1: 'English (United States)',
    languageCode2: 'de-DE',
    languageName2: 'German (Germany)',
    description: 'Essential German vocabulary with grammar notes',
    icon: null,
    authorName: 'Hans Schmidt',
    authorEmail: 'hans@languagerally.com',
    version: '2.0.0',
    packageType: PackageType.userCreated,
    isPurchased: false,
    isReadonly: false,
    createdAt: DateTime.now(),
    price: 0.0,
  );

  await packageRepo.insertPackage(package);

  // Create categories
  final basics = Category(id: uuid.v4(), packageId: packageId, name: 'Basics', description: 'Essential words and phrases');
  final family = Category(id: uuid.v4(), packageId: packageId, name: 'Family', description: 'Family members');
  final colors = Category(id: uuid.v4(), packageId: packageId, name: 'Colors', description: 'Common colors');
  final home = Category(id: uuid.v4(), packageId: packageId, name: 'Home', description: 'Household items');
  final weather = Category(id: uuid.v4(), packageId: packageId, name: 'Weather', description: 'Weather vocabulary');

  await categoryRepo.insertCategory(basics);
  await categoryRepo.insertCategory(family);
  await categoryRepo.insertCategory(colors);
  await categoryRepo.insertCategory(home);
  await categoryRepo.insertCategory(weather);

  // Create 30 items
  final items = [
    // Basics (8 items)
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [basics.id], language1Data: const ItemLanguageData(languageCode: 'en-US', text: 'yes'), language2Data: const ItemLanguageData(languageCode: 'de-DE', text: 'ja'), isKnown: true, isImportant: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [basics.id], language1Data: const ItemLanguageData(languageCode: 'en-US', text: 'no'), language2Data: const ItemLanguageData(languageCode: 'de-DE', text: 'nein'), isKnown: true, isImportant: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [basics.id], language1Data: const ItemLanguageData(languageCode: 'en-US', text: 'maybe'), language2Data: const ItemLanguageData(languageCode: 'de-DE', text: 'vielleicht'), isKnown: false),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [basics.id], language1Data: const ItemLanguageData(languageCode: 'en-US', text: 'sorry'), language2Data: const ItemLanguageData(languageCode: 'de-DE', text: 'Entschuldigung'), isKnown: false, isImportant: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [basics.id], language1Data: const ItemLanguageData(languageCode: 'en-US', text: 'excuse me'), language2Data: const ItemLanguageData(languageCode: 'de-DE', text: 'Entschuldigen Sie'), isKnown: false),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [basics.id], language1Data: const ItemLanguageData(languageCode: 'en-US', text: 'help'), language2Data: const ItemLanguageData(languageCode: 'de-DE', text: 'Hilfe', preItem: 'die'), isKnown: false, isImportant: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [basics.id], language1Data: const ItemLanguageData(languageCode: 'en-US', text: 'question'), language2Data: const ItemLanguageData(languageCode: 'de-DE', text: 'Frage', preItem: 'die'), isKnown: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [basics.id], language1Data: const ItemLanguageData(languageCode: 'en-US', text: 'answer'), language2Data: const ItemLanguageData(languageCode: 'de-DE', text: 'Antwort', preItem: 'die'), isKnown: false),

    // Family (7 items)
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [family.id], language1Data: const ItemLanguageData(languageCode: 'en-US', text: 'mother'), language2Data: const ItemLanguageData(languageCode: 'de-DE', text: 'Mutter', preItem: 'die'), isKnown: true, isImportant: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [family.id], language1Data: const ItemLanguageData(languageCode: 'en-US', text: 'father'), language2Data: const ItemLanguageData(languageCode: 'de-DE', text: 'Vater', preItem: 'der'), isKnown: true, isImportant: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [family.id], language1Data: const ItemLanguageData(languageCode: 'en-US', text: 'brother'), language2Data: const ItemLanguageData(languageCode: 'de-DE', text: 'Bruder', preItem: 'der'), isKnown: false),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [family.id], language1Data: const ItemLanguageData(languageCode: 'en-US', text: 'sister'), language2Data: const ItemLanguageData(languageCode: 'de-DE', text: 'Schwester', preItem: 'die'), isKnown: false),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [family.id], language1Data: const ItemLanguageData(languageCode: 'en-US', text: 'child'), language2Data: const ItemLanguageData(languageCode: 'de-DE', text: 'Kind', preItem: 'das'), isKnown: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [family.id], language1Data: const ItemLanguageData(languageCode: 'en-US', text: 'grandmother'), language2Data: const ItemLanguageData(languageCode: 'de-DE', text: 'Großmutter', preItem: 'die'), isKnown: false),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [family.id], language1Data: const ItemLanguageData(languageCode: 'en-US', text: 'grandfather'), language2Data: const ItemLanguageData(languageCode: 'de-DE', text: 'Großvater', preItem: 'der'), isKnown: false),

    // Colors (6 items)
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [colors.id], language1Data: const ItemLanguageData(languageCode: 'en-US', text: 'red'), language2Data: const ItemLanguageData(languageCode: 'de-DE', text: 'rot'), isKnown: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [colors.id], language1Data: const ItemLanguageData(languageCode: 'en-US', text: 'blue'), language2Data: const ItemLanguageData(languageCode: 'de-DE', text: 'blau'), isKnown: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [colors.id], language1Data: const ItemLanguageData(languageCode: 'en-US', text: 'green'), language2Data: const ItemLanguageData(languageCode: 'de-DE', text: 'grün'), isKnown: false),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [colors.id], language1Data: const ItemLanguageData(languageCode: 'en-US', text: 'yellow'), language2Data: const ItemLanguageData(languageCode: 'de-DE', text: 'gelb'), isKnown: false),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [colors.id], language1Data: const ItemLanguageData(languageCode: 'en-US', text: 'black'), language2Data: const ItemLanguageData(languageCode: 'de-DE', text: 'schwarz'), isKnown: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [colors.id], language1Data: const ItemLanguageData(languageCode: 'en-US', text: 'white'), language2Data: const ItemLanguageData(languageCode: 'de-DE', text: 'weiß'), isKnown: true),

    // Home (5 items)
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [home.id], language1Data: const ItemLanguageData(languageCode: 'en-US', text: 'house'), language2Data: const ItemLanguageData(languageCode: 'de-DE', text: 'Haus', preItem: 'das'), isKnown: true, isImportant: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [home.id], language1Data: const ItemLanguageData(languageCode: 'en-US', text: 'door'), language2Data: const ItemLanguageData(languageCode: 'de-DE', text: 'Tür', preItem: 'die'), isKnown: false),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [home.id], language1Data: const ItemLanguageData(languageCode: 'en-US', text: 'window'), language2Data: const ItemLanguageData(languageCode: 'de-DE', text: 'Fenster', preItem: 'das'), isKnown: false),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [home.id], language1Data: const ItemLanguageData(languageCode: 'en-US', text: 'table'), language2Data: const ItemLanguageData(languageCode: 'de-DE', text: 'Tisch', preItem: 'der'), isKnown: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [home.id], language1Data: const ItemLanguageData(languageCode: 'en-US', text: 'chair'), language2Data: const ItemLanguageData(languageCode: 'de-DE', text: 'Stuhl', preItem: 'der'), isKnown: false),

    // Weather (4 items)
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [weather.id], language1Data: const ItemLanguageData(languageCode: 'en-US', text: 'sun'), language2Data: const ItemLanguageData(languageCode: 'de-DE', text: 'Sonne', preItem: 'die'), isKnown: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [weather.id], language1Data: const ItemLanguageData(languageCode: 'en-US', text: 'rain'), language2Data: const ItemLanguageData(languageCode: 'de-DE', text: 'Regen', preItem: 'der'), isKnown: false),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [weather.id], language1Data: const ItemLanguageData(languageCode: 'en-US', text: 'snow'), language2Data: const ItemLanguageData(languageCode: 'de-DE', text: 'Schnee', preItem: 'der'), isKnown: false),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [weather.id], language1Data: const ItemLanguageData(languageCode: 'en-US', text: 'wind'), language2Data: const ItemLanguageData(languageCode: 'de-DE', text: 'Wind', preItem: 'der'), isKnown: true),
  ];

  for (final item in items) {
    await itemRepo.insertItem(item);
  }

  // print('  ✓ Created 30 German items across 5 categories');
}

// ============================================================================
// Package 3: English → French (30 items)
// ============================================================================

Future<void> _createEnglishFrenchPackage(
  Uuid uuid,
  LanguagePackageRepository packageRepo,
  CategoryRepository categoryRepo,
  ItemRepository itemRepo,
  String groupId,
) async {
  // print('📦 Creating English → French package...');
  final packageId = uuid.v4();

  final package = LanguagePackage(
    id: packageId,
    groupId: groupId,
    packageName: 'French for Business',
    languageCode1: 'en-en',
    languageName1: 'English',
    languageCode2: 'fr-fr',
    languageName2: 'French',
    description: 'French vocabulary for business and daily life',
    icon: null,
    authorName: 'Pierre Dubois',
    authorEmail: 'pierre@languagerally.com',
    version: '1.5.0',
    packageType: PackageType.userCreated,
    isPurchased: false,
    isReadonly: false,
    createdAt: DateTime.now(),
    price: 0.0,
  );

  await packageRepo.insertPackage(package);

  // Create categories
  final business = Category(id: uuid.v4(), packageId: packageId, name: 'Business', description: 'Professional vocabulary');
  final shopping = Category(id: uuid.v4(), packageId: packageId, name: 'Shopping', description: 'Shopping and prices');
  final health = Category(id: uuid.v4(), packageId: packageId, name: 'Health', description: 'Medical vocabulary');
  final education = Category(id: uuid.v4(), packageId: packageId, name: 'Education', description: 'School and learning');
  final emotions = Category(id: uuid.v4(), packageId: packageId, name: 'Emotions', description: 'Feelings and states');

  await categoryRepo.insertCategory(business);
  await categoryRepo.insertCategory(shopping);
  await categoryRepo.insertCategory(health);
  await categoryRepo.insertCategory(education);
  await categoryRepo.insertCategory(emotions);

  // Create 30 items
  final items = [
    // Business (7 items)
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [business.id], language1Data: const ItemLanguageData(languageCode: 'en-US', text: 'meeting'), language2Data: const ItemLanguageData(languageCode: 'fr-FR', text: 'réunion', preItem: 'une'), isKnown: true, isImportant: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [business.id], language1Data: const ItemLanguageData(languageCode: 'en-US', text: 'contract'), language2Data: const ItemLanguageData(languageCode: 'fr-FR', text: 'contrat', preItem: 'un'), isKnown: false, isImportant: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [business.id], language1Data: const ItemLanguageData(languageCode: 'en-US', text: 'office'), language2Data: const ItemLanguageData(languageCode: 'fr-FR', text: 'bureau', preItem: 'le'), isKnown: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [business.id], language1Data: const ItemLanguageData(languageCode: 'en-US', text: 'colleague'), language2Data: const ItemLanguageData(languageCode: 'fr-FR', text: 'collègue', preItem: 'le/la'), isKnown: false),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [business.id], language1Data: const ItemLanguageData(languageCode: 'en-US', text: 'boss'), language2Data: const ItemLanguageData(languageCode: 'fr-FR', text: 'patron', preItem: 'le'), isKnown: false),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [business.id], language1Data: const ItemLanguageData(languageCode: 'en-US', text: 'salary'), language2Data: const ItemLanguageData(languageCode: 'fr-FR', text: 'salaire', preItem: 'le'), isKnown: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [business.id], language1Data: const ItemLanguageData(languageCode: 'en-US', text: 'document'), language2Data: const ItemLanguageData(languageCode: 'fr-FR', text: 'document', preItem: 'le'), isKnown: true),

    // Shopping (6 items)
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [shopping.id], language1Data: const ItemLanguageData(languageCode: 'en-US', text: 'shop'), language2Data: const ItemLanguageData(languageCode: 'fr-FR', text: 'magasin', preItem: 'le'), isKnown: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [shopping.id], language1Data: const ItemLanguageData(languageCode: 'en-US', text: 'price'), language2Data: const ItemLanguageData(languageCode: 'fr-FR', text: 'prix', preItem: 'le'), isKnown: true, isImportant: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [shopping.id], language1Data: const ItemLanguageData(languageCode: 'en-US', text: 'expensive'), language2Data: const ItemLanguageData(languageCode: 'fr-FR', text: 'cher'), isKnown: false),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [shopping.id], language1Data: const ItemLanguageData(languageCode: 'en-US', text: 'cheap'), language2Data: const ItemLanguageData(languageCode: 'fr-FR', text: 'bon marché'), isKnown: false),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [shopping.id], language1Data: const ItemLanguageData(languageCode: 'en-US', text: 'money'), language2Data: const ItemLanguageData(languageCode: 'fr-FR', text: 'argent', preItem: "l'"), isKnown: true, isImportant: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [shopping.id], language1Data: const ItemLanguageData(languageCode: 'en-US', text: 'card'), language2Data: const ItemLanguageData(languageCode: 'fr-FR', text: 'carte', preItem: 'la'), isKnown: false),

    // Health (6 items)
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [health.id], language1Data: const ItemLanguageData(languageCode: 'en-US', text: 'doctor'), language2Data: const ItemLanguageData(languageCode: 'fr-FR', text: 'médecin', preItem: 'le'), isKnown: true, isImportant: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [health.id], language1Data: const ItemLanguageData(languageCode: 'en-US', text: 'hospital'), language2Data: const ItemLanguageData(languageCode: 'fr-FR', text: 'hôpital', preItem: "l'"), isKnown: false, isImportant: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [health.id], language1Data: const ItemLanguageData(languageCode: 'en-US', text: 'medicine'), language2Data: const ItemLanguageData(languageCode: 'fr-FR', text: 'médicament', preItem: 'le'), isKnown: false),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [health.id], language1Data: const ItemLanguageData(languageCode: 'en-US', text: 'pain'), language2Data: const ItemLanguageData(languageCode: 'fr-FR', text: 'douleur', preItem: 'la'), isKnown: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [health.id], language1Data: const ItemLanguageData(languageCode: 'en-US', text: 'fever'), language2Data: const ItemLanguageData(languageCode: 'fr-FR', text: 'fièvre', preItem: 'la'), isKnown: false),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [health.id], language1Data: const ItemLanguageData(languageCode: 'en-US', text: 'sick'), language2Data: const ItemLanguageData(languageCode: 'fr-FR', text: 'malade'), isKnown: true),

    // Education (6 items)
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [education.id], language1Data: const ItemLanguageData(languageCode: 'en-US', text: 'school'), language2Data: const ItemLanguageData(languageCode: 'fr-FR', text: 'école', preItem: "l'"), isKnown: true, isImportant: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [education.id], language1Data: const ItemLanguageData(languageCode: 'en-US', text: 'student'), language2Data: const ItemLanguageData(languageCode: 'fr-FR', text: 'étudiant', preItem: "l'"), isKnown: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [education.id], language1Data: const ItemLanguageData(languageCode: 'en-US', text: 'teacher'), language2Data: const ItemLanguageData(languageCode: 'fr-FR', text: 'professeur', preItem: 'le'), isKnown: false),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [education.id], language1Data: const ItemLanguageData(languageCode: 'en-US', text: 'book'), language2Data: const ItemLanguageData(languageCode: 'fr-FR', text: 'livre', preItem: 'le'), isKnown: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [education.id], language1Data: const ItemLanguageData(languageCode: 'en-US', text: 'exam'), language2Data: const ItemLanguageData(languageCode: 'fr-FR', text: 'examen', preItem: "l'"), isKnown: false),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [education.id], language1Data: const ItemLanguageData(languageCode: 'en-US', text: 'homework'), language2Data: const ItemLanguageData(languageCode: 'fr-FR', text: 'devoirs', preItem: 'les'), isKnown: false),

    // Emotions (5 items)
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [emotions.id], language1Data: const ItemLanguageData(languageCode: 'en-US', text: 'happy'), language2Data: const ItemLanguageData(languageCode: 'fr-FR', text: 'heureux'), isKnown: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [emotions.id], language1Data: const ItemLanguageData(languageCode: 'en-US', text: 'sad'), language2Data: const ItemLanguageData(languageCode: 'fr-FR', text: 'triste'), isKnown: false),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [emotions.id], language1Data: const ItemLanguageData(languageCode: 'en-US', text: 'angry'), language2Data: const ItemLanguageData(languageCode: 'fr-FR', text: 'en colère'), isKnown: false),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [emotions.id], language1Data: const ItemLanguageData(languageCode: 'en-US', text: 'tired'), language2Data: const ItemLanguageData(languageCode: 'fr-FR', text: 'fatigué'), isKnown: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [emotions.id], language1Data: const ItemLanguageData(languageCode: 'en-US', text: 'excited'), language2Data: const ItemLanguageData(languageCode: 'fr-FR', text: 'excité'), isKnown: false),
  ];

  for (final item in items) {
    await itemRepo.insertItem(item);
  }

  // print('  ✓ Created 30 French items across 5 categories');
}

// ============================================================================
// Package 4: Hungarian → English (30 items)
// ============================================================================

Future<void> _createHungarianEnglishPackage(
  Uuid uuid,
  LanguagePackageRepository packageRepo,
  CategoryRepository categoryRepo,
  ItemRepository itemRepo,
  String groupId,
) async {
  // print('📦 Creating Hungarian → English package...');
  final packageId = uuid.v4();

  final package = LanguagePackage(
    id: packageId,
    groupId: groupId,
    packageName: 'Hungarian for Beginners',
    languageCode1: 'hu-hu',
    languageName1: 'Hungarian',
    languageCode2: 'en-en',
    languageName2: 'English',
    description: 'Essential Hungarian-English vocabulary for beginners',
    icon: null,
    authorName: 'Kovács János',
    authorEmail: 'janos@languagerally.com',
    version: '1.0.0',
    packageType: PackageType.userCreated,
    isPurchased: false,
    isReadonly: false,
    createdAt: DateTime.now(),
    price: 0.0,
  );

  await packageRepo.insertPackage(package);

  // Create categories
  final phrases = Category(id: uuid.v4(), packageId: packageId, name: 'Common Phrases', description: 'Everyday expressions');
  final verbs = Category(id: uuid.v4(), packageId: packageId, name: 'Verbs', description: 'Action words');
  final nouns = Category(id: uuid.v4(), packageId: packageId, name: 'Nouns', description: 'Common objects');
  final adjectives = Category(id: uuid.v4(), packageId: packageId, name: 'Adjectives', description: 'Descriptive words');
  final places = Category(id: uuid.v4(), packageId: packageId, name: 'Places', description: 'Locations');

  await categoryRepo.insertCategory(phrases);
  await categoryRepo.insertCategory(verbs);
  await categoryRepo.insertCategory(nouns);
  await categoryRepo.insertCategory(adjectives);
  await categoryRepo.insertCategory(places);

  // Create 30 items
  final items = [
    // Common Phrases (7 items)
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [phrases.id], language1Data: const ItemLanguageData(languageCode: 'hu-HU', text: 'Szia'), language2Data: const ItemLanguageData(languageCode: 'en-US', text: 'Hi'), isKnown: true, isImportant: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [phrases.id], language1Data: const ItemLanguageData(languageCode: 'hu-HU', text: 'Viszlát'), language2Data: const ItemLanguageData(languageCode: 'en-US', text: 'Goodbye'), isKnown: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [phrases.id], language1Data: const ItemLanguageData(languageCode: 'hu-HU', text: 'Köszönöm'), language2Data: const ItemLanguageData(languageCode: 'en-US', text: 'Thank you'), isKnown: true, isImportant: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [phrases.id], language1Data: const ItemLanguageData(languageCode: 'hu-HU', text: 'Kérem'), language2Data: const ItemLanguageData(languageCode: 'en-US', text: 'Please'), isKnown: false, isImportant: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [phrases.id], language1Data: const ItemLanguageData(languageCode: 'hu-HU', text: 'Elnézést'), language2Data: const ItemLanguageData(languageCode: 'en-US', text: 'Excuse me'), isKnown: false),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [phrases.id], language1Data: const ItemLanguageData(languageCode: 'hu-HU', text: 'Nem értem'), language2Data: const ItemLanguageData(languageCode: 'en-US', text: "I don't understand"), isKnown: false, isImportant: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [phrases.id], language1Data: const ItemLanguageData(languageCode: 'hu-HU', text: 'Segítség'), language2Data: const ItemLanguageData(languageCode: 'en-US', text: 'Help'), isKnown: true),

    // Verbs (7 items)
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [verbs.id], language1Data: const ItemLanguageData(languageCode: 'hu-HU', text: 'lenni'), language2Data: const ItemLanguageData(languageCode: 'en-US', text: 'to be'), isKnown: true, isImportant: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [verbs.id], language1Data: const ItemLanguageData(languageCode: 'hu-HU', text: 'menni'), language2Data: const ItemLanguageData(languageCode: 'en-US', text: 'to go'), isKnown: false, isImportant: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [verbs.id], language1Data: const ItemLanguageData(languageCode: 'hu-HU', text: 'jönni'), language2Data: const ItemLanguageData(languageCode: 'en-US', text: 'to come'), isKnown: false),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [verbs.id], language1Data: const ItemLanguageData(languageCode: 'hu-HU', text: 'enni'), language2Data: const ItemLanguageData(languageCode: 'en-US', text: 'to eat'), isKnown: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [verbs.id], language1Data: const ItemLanguageData(languageCode: 'hu-HU', text: 'inni'), language2Data: const ItemLanguageData(languageCode: 'en-US', text: 'to drink'), isKnown: false),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [verbs.id], language1Data: const ItemLanguageData(languageCode: 'hu-HU', text: 'beszélni'), language2Data: const ItemLanguageData(languageCode: 'en-US', text: 'to speak'), isKnown: false),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [verbs.id], language1Data: const ItemLanguageData(languageCode: 'hu-HU', text: 'tanulni'), language2Data: const ItemLanguageData(languageCode: 'en-US', text: 'to learn'), isKnown: true, isImportant: true),

    // Nouns (6 items)
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [nouns.id], language1Data: const ItemLanguageData(languageCode: 'hu-HU', text: 'könyv'), language2Data: const ItemLanguageData(languageCode: 'en-US', text: 'book'), isKnown: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [nouns.id], language1Data: const ItemLanguageData(languageCode: 'hu-HU', text: 'asztal'), language2Data: const ItemLanguageData(languageCode: 'en-US', text: 'table'), isKnown: false),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [nouns.id], language1Data: const ItemLanguageData(languageCode: 'hu-HU', text: 'szék'), language2Data: const ItemLanguageData(languageCode: 'en-US', text: 'chair'), isKnown: false),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [nouns.id], language1Data: const ItemLanguageData(languageCode: 'hu-HU', text: 'ház'), language2Data: const ItemLanguageData(languageCode: 'en-US', text: 'house'), isKnown: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [nouns.id], language1Data: const ItemLanguageData(languageCode: 'hu-HU', text: 'autó'), language2Data: const ItemLanguageData(languageCode: 'en-US', text: 'car'), isKnown: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [nouns.id], language1Data: const ItemLanguageData(languageCode: 'hu-HU', text: 'víz'), language2Data: const ItemLanguageData(languageCode: 'en-US', text: 'water'), isKnown: false),

    // Adjectives (5 items)
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [adjectives.id], language1Data: const ItemLanguageData(languageCode: 'hu-HU', text: 'jó'), language2Data: const ItemLanguageData(languageCode: 'en-US', text: 'good'), isKnown: true, isImportant: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [adjectives.id], language1Data: const ItemLanguageData(languageCode: 'hu-HU', text: 'rossz'), language2Data: const ItemLanguageData(languageCode: 'en-US', text: 'bad'), isKnown: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [adjectives.id], language1Data: const ItemLanguageData(languageCode: 'hu-HU', text: 'nagy'), language2Data: const ItemLanguageData(languageCode: 'en-US', text: 'big'), isKnown: false),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [adjectives.id], language1Data: const ItemLanguageData(languageCode: 'hu-HU', text: 'kicsi'), language2Data: const ItemLanguageData(languageCode: 'en-US', text: 'small'), isKnown: false),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [adjectives.id], language1Data: const ItemLanguageData(languageCode: 'hu-HU', text: 'szép'), language2Data: const ItemLanguageData(languageCode: 'en-US', text: 'beautiful'), isKnown: true),

    // Places (5 items)
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [places.id], language1Data: const ItemLanguageData(languageCode: 'hu-HU', text: 'iskola'), language2Data: const ItemLanguageData(languageCode: 'en-US', text: 'school'), isKnown: true, isImportant: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [places.id], language1Data: const ItemLanguageData(languageCode: 'hu-HU', text: 'bolt'), language2Data: const ItemLanguageData(languageCode: 'en-US', text: 'shop'), isKnown: false),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [places.id], language1Data: const ItemLanguageData(languageCode: 'hu-HU', text: 'étterem'), language2Data: const ItemLanguageData(languageCode: 'en-US', text: 'restaurant'), isKnown: false),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [places.id], language1Data: const ItemLanguageData(languageCode: 'hu-HU', text: 'park'), language2Data: const ItemLanguageData(languageCode: 'en-US', text: 'park'), isKnown: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [places.id], language1Data: const ItemLanguageData(languageCode: 'hu-HU', text: 'pályaudvar'), language2Data: const ItemLanguageData(languageCode: 'en-US', text: 'train station'), isKnown: false, isImportant: true),
  ];

  for (final item in items) {
    await itemRepo.insertItem(item);
  }

  // print('  ✓ Created 30 Hungarian items across 5 categories');
}

