// lib/scripts/populate_test_data_script.dart
import 'package:uuid/uuid.dart';
import '../data/models/language_package.dart';
import '../data/models/category.dart';
import '../data/models/item.dart';
import '../data/models/item_language_data.dart';
import '../data/models/example_sentence.dart';
import '../data/repositories/language_package_repository.dart';
import '../data/repositories/category_repository.dart';
import '../data/repositories/item_repository.dart';

/// Standalone script to populate the database with comprehensive test data
/// Run this with: flutter run lib/scripts/populate_test_data_script.dart
Future<void> main() async {
  print('🚀 Starting comprehensive test data population...\n');

  final uuid = const Uuid();
  final packageRepo = LanguagePackageRepository();
  final categoryRepo = CategoryRepository();
  final itemRepo = ItemRepository();

  try {
    // Package 1: English → Spanish
    await _createEnglishSpanishPackage(uuid, packageRepo, categoryRepo, itemRepo);

    // Package 2: English → German
    await _createEnglishGermanPackage(uuid, packageRepo, categoryRepo, itemRepo);

    // Package 3: English → French
    await _createEnglishFrenchPackage(uuid, packageRepo, categoryRepo, itemRepo);

    // Package 4: Hungarian → English
    await _createHungarianEnglishPackage(uuid, packageRepo, categoryRepo, itemRepo);

    print('\n✅ Test data population completed successfully!');
    print('📊 Total: 4 packages with 120 items created');
  } catch (e, stackTrace) {
    print('❌ Error: $e');
    print('Stack trace: $stackTrace');
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
) async {
  print('📦 Creating English → Spanish package...');
  final packageId = uuid.v4();

  final package = LanguagePackage(
    id: packageId,
    languageCode1: 'en',
    languageName1: 'English',
    languageCode2: 'es',
    languageName2: 'Spanish',
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
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [greetings.id], language1Data: const ItemLanguageData(languageCode: 'en', text: 'Hello'), language2Data: const ItemLanguageData(languageCode: 'es', text: 'Hola'), isKnown: true, isImportant: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [greetings.id], language1Data: const ItemLanguageData(languageCode: 'en', text: 'Good morning'), language2Data: const ItemLanguageData(languageCode: 'es', text: 'Buenos días'), isKnown: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [greetings.id], language1Data: const ItemLanguageData(languageCode: 'en', text: 'Good afternoon'), language2Data: const ItemLanguageData(languageCode: 'es', text: 'Buenas tardes'), isKnown: false),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [greetings.id], language1Data: const ItemLanguageData(languageCode: 'en', text: 'Good evening'), language2Data: const ItemLanguageData(languageCode: 'es', text: 'Buenas noches'), isKnown: false),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [greetings.id], language1Data: const ItemLanguageData(languageCode: 'en', text: 'Goodbye'), language2Data: const ItemLanguageData(languageCode: 'es', text: 'Adiós'), isKnown: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [greetings.id], language1Data: const ItemLanguageData(languageCode: 'en', text: 'Please'), language2Data: const ItemLanguageData(languageCode: 'es', text: 'Por favor'), isKnown: true, isImportant: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [greetings.id], language1Data: const ItemLanguageData(languageCode: 'en', text: 'Thank you'), language2Data: const ItemLanguageData(languageCode: 'es', text: 'Gracias'), isKnown: true, isImportant: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [greetings.id], language1Data: const ItemLanguageData(languageCode: 'en', text: 'You\'re welcome'), language2Data: const ItemLanguageData(languageCode: 'es', text: 'De nada'), isKnown: false),

    // Food & Drinks (8 items)
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [food.id], language1Data: const ItemLanguageData(languageCode: 'en', text: 'water'), language2Data: const ItemLanguageData(languageCode: 'es', text: 'agua', preItem: 'el'), isKnown: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [food.id], language1Data: const ItemLanguageData(languageCode: 'en', text: 'bread'), language2Data: const ItemLanguageData(languageCode: 'es', text: 'pan', preItem: 'el'), isKnown: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [food.id], language1Data: const ItemLanguageData(languageCode: 'en', text: 'coffee'), language2Data: const ItemLanguageData(languageCode: 'es', text: 'café', preItem: 'el'), isKnown: false),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [food.id], language1Data: const ItemLanguageData(languageCode: 'en', text: 'beer'), language2Data: const ItemLanguageData(languageCode: 'es', text: 'cerveza', preItem: 'la'), isKnown: false),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [food.id], language1Data: const ItemLanguageData(languageCode: 'en', text: 'wine'), language2Data: const ItemLanguageData(languageCode: 'es', text: 'vino', preItem: 'el'), isKnown: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [food.id], language1Data: const ItemLanguageData(languageCode: 'en', text: 'apple'), language2Data: const ItemLanguageData(languageCode: 'es', text: 'manzana', preItem: 'la'), isKnown: false, isImportant: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [food.id], language1Data: const ItemLanguageData(languageCode: 'en', text: 'cheese'), language2Data: const ItemLanguageData(languageCode: 'es', text: 'queso', preItem: 'el'), isKnown: false),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [food.id], language1Data: const ItemLanguageData(languageCode: 'en', text: 'meat'), language2Data: const ItemLanguageData(languageCode: 'es', text: 'carne', preItem: 'la'), isKnown: true),

    // Travel (6 items)
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [travel.id], language1Data: const ItemLanguageData(languageCode: 'en', text: 'airport'), language2Data: const ItemLanguageData(languageCode: 'es', text: 'aeropuerto', preItem: 'el'), isKnown: false, isImportant: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [travel.id], language1Data: const ItemLanguageData(languageCode: 'en', text: 'train station'), language2Data: const ItemLanguageData(languageCode: 'es', text: 'estación de tren', preItem: 'la'), isKnown: false),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [travel.id], language1Data: const ItemLanguageData(languageCode: 'en', text: 'hotel'), language2Data: const ItemLanguageData(languageCode: 'es', text: 'hotel', preItem: 'el'), isKnown: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [travel.id], language1Data: const ItemLanguageData(languageCode: 'en', text: 'ticket'), language2Data: const ItemLanguageData(languageCode: 'es', text: 'billete', preItem: 'el'), isKnown: false),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [travel.id], language1Data: const ItemLanguageData(languageCode: 'en', text: 'passport'), language2Data: const ItemLanguageData(languageCode: 'es', text: 'pasaporte', preItem: 'el'), isKnown: true, isImportant: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [travel.id], language1Data: const ItemLanguageData(languageCode: 'en', text: 'suitcase'), language2Data: const ItemLanguageData(languageCode: 'es', text: 'maleta', preItem: 'la'), isKnown: false),

    // Numbers (4 items)
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [numbers.id], language1Data: const ItemLanguageData(languageCode: 'en', text: 'one'), language2Data: const ItemLanguageData(languageCode: 'es', text: 'uno'), isKnown: true, isImportant: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [numbers.id], language1Data: const ItemLanguageData(languageCode: 'en', text: 'two'), language2Data: const ItemLanguageData(languageCode: 'es', text: 'dos'), isKnown: true, isImportant: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [numbers.id], language1Data: const ItemLanguageData(languageCode: 'en', text: 'ten'), language2Data: const ItemLanguageData(languageCode: 'es', text: 'diez'), isKnown: false),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [numbers.id], language1Data: const ItemLanguageData(languageCode: 'en', text: 'hundred'), language2Data: const ItemLanguageData(languageCode: 'es', text: 'cien'), isKnown: false),

    // Time (4 items)
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [time.id], language1Data: const ItemLanguageData(languageCode: 'en', text: 'today'), language2Data: const ItemLanguageData(languageCode: 'es', text: 'hoy'), isKnown: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [time.id], language1Data: const ItemLanguageData(languageCode: 'en', text: 'tomorrow'), language2Data: const ItemLanguageData(languageCode: 'es', text: 'mañana'), isKnown: false),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [time.id], language1Data: const ItemLanguageData(languageCode: 'en', text: 'yesterday'), language2Data: const ItemLanguageData(languageCode: 'es', text: 'ayer'), isKnown: false),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [time.id], language1Data: const ItemLanguageData(languageCode: 'en', text: 'now'), language2Data: const ItemLanguageData(languageCode: 'es', text: 'ahora'), isKnown: true),
  ];

  for (final item in items) {
    await itemRepo.insertItem(item);
  }

  print('  ✓ Created 30 Spanish items across 5 categories');
}

// ============================================================================
// Package 2: English → German (30 items)
// ============================================================================

Future<void> _createEnglishGermanPackage(
  Uuid uuid,
  LanguagePackageRepository packageRepo,
  CategoryRepository categoryRepo,
  ItemRepository itemRepo,
) async {
  print('📦 Creating English → German package...');
  final packageId = uuid.v4();

  final package = LanguagePackage(
    id: packageId,
    languageCode1: 'en',
    languageName1: 'English',
    languageCode2: 'de',
    languageName2: 'German',
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
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [basics.id], language1Data: const ItemLanguageData(languageCode: 'en', text: 'yes'), language2Data: const ItemLanguageData(languageCode: 'de', text: 'ja'), isKnown: true, isImportant: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [basics.id], language1Data: const ItemLanguageData(languageCode: 'en', text: 'no'), language2Data: const ItemLanguageData(languageCode: 'de', text: 'nein'), isKnown: true, isImportant: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [basics.id], language1Data: const ItemLanguageData(languageCode: 'en', text: 'maybe'), language2Data: const ItemLanguageData(languageCode: 'de', text: 'vielleicht'), isKnown: false),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [basics.id], language1Data: const ItemLanguageData(languageCode: 'en', text: 'sorry'), language2Data: const ItemLanguageData(languageCode: 'de', text: 'Entschuldigung'), isKnown: false, isImportant: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [basics.id], language1Data: const ItemLanguageData(languageCode: 'en', text: 'excuse me'), language2Data: const ItemLanguageData(languageCode: 'de', text: 'Entschuldigen Sie'), isKnown: false),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [basics.id], language1Data: const ItemLanguageData(languageCode: 'en', text: 'help'), language2Data: const ItemLanguageData(languageCode: 'de', text: 'Hilfe', preItem: 'die'), isKnown: false, isImportant: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [basics.id], language1Data: const ItemLanguageData(languageCode: 'en', text: 'question'), language2Data: const ItemLanguageData(languageCode: 'de', text: 'Frage', preItem: 'die'), isKnown: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [basics.id], language1Data: const ItemLanguageData(languageCode: 'en', text: 'answer'), language2Data: const ItemLanguageData(languageCode: 'de', text: 'Antwort', preItem: 'die'), isKnown: false),

    // Family (7 items)
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [family.id], language1Data: const ItemLanguageData(languageCode: 'en', text: 'mother'), language2Data: const ItemLanguageData(languageCode: 'de', text: 'Mutter', preItem: 'die'), isKnown: true, isImportant: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [family.id], language1Data: const ItemLanguageData(languageCode: 'en', text: 'father'), language2Data: const ItemLanguageData(languageCode: 'de', text: 'Vater', preItem: 'der'), isKnown: true, isImportant: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [family.id], language1Data: const ItemLanguageData(languageCode: 'en', text: 'brother'), language2Data: const ItemLanguageData(languageCode: 'de', text: 'Bruder', preItem: 'der'), isKnown: false),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [family.id], language1Data: const ItemLanguageData(languageCode: 'en', text: 'sister'), language2Data: const ItemLanguageData(languageCode: 'de', text: 'Schwester', preItem: 'die'), isKnown: false),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [family.id], language1Data: const ItemLanguageData(languageCode: 'en', text: 'child'), language2Data: const ItemLanguageData(languageCode: 'de', text: 'Kind', preItem: 'das'), isKnown: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [family.id], language1Data: const ItemLanguageData(languageCode: 'en', text: 'grandmother'), language2Data: const ItemLanguageData(languageCode: 'de', text: 'Großmutter', preItem: 'die'), isKnown: false),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [family.id], language1Data: const ItemLanguageData(languageCode: 'en', text: 'grandfather'), language2Data: const ItemLanguageData(languageCode: 'de', text: 'Großvater', preItem: 'der'), isKnown: false),

    // Colors (6 items)
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [colors.id], language1Data: const ItemLanguageData(languageCode: 'en', text: 'red'), language2Data: const ItemLanguageData(languageCode: 'de', text: 'rot'), isKnown: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [colors.id], language1Data: const ItemLanguageData(languageCode: 'en', text: 'blue'), language2Data: const ItemLanguageData(languageCode: 'de', text: 'blau'), isKnown: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [colors.id], language1Data: const ItemLanguageData(languageCode: 'en', text: 'green'), language2Data: const ItemLanguageData(languageCode: 'de', text: 'grün'), isKnown: false),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [colors.id], language1Data: const ItemLanguageData(languageCode: 'en', text: 'yellow'), language2Data: const ItemLanguageData(languageCode: 'de', text: 'gelb'), isKnown: false),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [colors.id], language1Data: const ItemLanguageData(languageCode: 'en', text: 'black'), language2Data: const ItemLanguageData(languageCode: 'de', text: 'schwarz'), isKnown: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [colors.id], language1Data: const ItemLanguageData(languageCode: 'en', text: 'white'), language2Data: const ItemLanguageData(languageCode: 'de', text: 'weiß'), isKnown: true),

    // Home (5 items)
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [home.id], language1Data: const ItemLanguageData(languageCode: 'en', text: 'house'), language2Data: const ItemLanguageData(languageCode: 'de', text: 'Haus', preItem: 'das'), isKnown: true, isImportant: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [home.id], language1Data: const ItemLanguageData(languageCode: 'en', text: 'door'), language2Data: const ItemLanguageData(languageCode: 'de', text: 'Tür', preItem: 'die'), isKnown: false),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [home.id], language1Data: const ItemLanguageData(languageCode: 'en', text: 'window'), language2Data: const ItemLanguageData(languageCode: 'de', text: 'Fenster', preItem: 'das'), isKnown: false),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [home.id], language1Data: const ItemLanguageData(languageCode: 'en', text: 'table'), language2Data: const ItemLanguageData(languageCode: 'de', text: 'Tisch', preItem: 'der'), isKnown: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [home.id], language1Data: const ItemLanguageData(languageCode: 'en', text: 'chair'), language2Data: const ItemLanguageData(languageCode: 'de', text: 'Stuhl', preItem: 'der'), isKnown: false),

    // Weather (4 items)
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [weather.id], language1Data: const ItemLanguageData(languageCode: 'en', text: 'sun'), language2Data: const ItemLanguageData(languageCode: 'de', text: 'Sonne', preItem: 'die'), isKnown: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [weather.id], language1Data: const ItemLanguageData(languageCode: 'en', text: 'rain'), language2Data: const ItemLanguageData(languageCode: 'de', text: 'Regen', preItem: 'der'), isKnown: false),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [weather.id], language1Data: const ItemLanguageData(languageCode: 'en', text: 'snow'), language2Data: const ItemLanguageData(languageCode: 'de', text: 'Schnee', preItem: 'der'), isKnown: false),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [weather.id], language1Data: const ItemLanguageData(languageCode: 'en', text: 'wind'), language2Data: const ItemLanguageData(languageCode: 'de', text: 'Wind', preItem: 'der'), isKnown: true),
  ];

  for (final item in items) {
    await itemRepo.insertItem(item);
  }

  print('  ✓ Created 30 German items across 5 categories');
}

// ============================================================================
// Package 3: English → French (30 items)
// ============================================================================

Future<void> _createEnglishFrenchPackage(
  Uuid uuid,
  LanguagePackageRepository packageRepo,
  CategoryRepository categoryRepo,
  ItemRepository itemRepo,
) async {
  print('📦 Creating English → French package...');
  final packageId = uuid.v4();

  final package = LanguagePackage(
    id: packageId,
    languageCode1: 'en',
    languageName1: 'English',
    languageCode2: 'fr',
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
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [business.id], language1Data: const ItemLanguageData(languageCode: 'en', text: 'meeting'), language2Data: const ItemLanguageData(languageCode: 'fr', text: 'réunion', preItem: 'une'), isKnown: true, isImportant: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [business.id], language1Data: const ItemLanguageData(languageCode: 'en', text: 'contract'), language2Data: const ItemLanguageData(languageCode: 'fr', text: 'contrat', preItem: 'un'), isKnown: false, isImportant: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [business.id], language1Data: const ItemLanguageData(languageCode: 'en', text: 'office'), language2Data: const ItemLanguageData(languageCode: 'fr', text: 'bureau', preItem: 'le'), isKnown: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [business.id], language1Data: const ItemLanguageData(languageCode: 'en', text: 'colleague'), language2Data: const ItemLanguageData(languageCode: 'fr', text: 'collègue', preItem: 'le/la'), isKnown: false),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [business.id], language1Data: const ItemLanguageData(languageCode: 'en', text: 'boss'), language2Data: const ItemLanguageData(languageCode: 'fr', text: 'patron', preItem: 'le'), isKnown: false),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [business.id], language1Data: const ItemLanguageData(languageCode: 'en', text: 'salary'), language2Data: const ItemLanguageData(languageCode: 'fr', text: 'salaire', preItem: 'le'), isKnown: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [business.id], language1Data: const ItemLanguageData(languageCode: 'en', text: 'document'), language2Data: const ItemLanguageData(languageCode: 'fr', text: 'document', preItem: 'le'), isKnown: true),

    // Shopping (6 items)
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [shopping.id], language1Data: const ItemLanguageData(languageCode: 'en', text: 'shop'), language2Data: const ItemLanguageData(languageCode: 'fr', text: 'magasin', preItem: 'le'), isKnown: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [shopping.id], language1Data: const ItemLanguageData(languageCode: 'en', text: 'price'), language2Data: const ItemLanguageData(languageCode: 'fr', text: 'prix', preItem: 'le'), isKnown: true, isImportant: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [shopping.id], language1Data: const ItemLanguageData(languageCode: 'en', text: 'expensive'), language2Data: const ItemLanguageData(languageCode: 'fr', text: 'cher'), isKnown: false),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [shopping.id], language1Data: const ItemLanguageData(languageCode: 'en', text: 'cheap'), language2Data: const ItemLanguageData(languageCode: 'fr', text: 'bon marché'), isKnown: false),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [shopping.id], language1Data: const ItemLanguageData(languageCode: 'en', text: 'money'), language2Data: const ItemLanguageData(languageCode: 'fr', text: 'argent', preItem: "l'"), isKnown: true, isImportant: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [shopping.id], language1Data: const ItemLanguageData(languageCode: 'en', text: 'card'), language2Data: const ItemLanguageData(languageCode: 'fr', text: 'carte', preItem: 'la'), isKnown: false),

    // Health (6 items)
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [health.id], language1Data: const ItemLanguageData(languageCode: 'en', text: 'doctor'), language2Data: const ItemLanguageData(languageCode: 'fr', text: 'médecin', preItem: 'le'), isKnown: true, isImportant: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [health.id], language1Data: const ItemLanguageData(languageCode: 'en', text: 'hospital'), language2Data: const ItemLanguageData(languageCode: 'fr', text: 'hôpital', preItem: "l'"), isKnown: false, isImportant: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [health.id], language1Data: const ItemLanguageData(languageCode: 'en', text: 'medicine'), language2Data: const ItemLanguageData(languageCode: 'fr', text: 'médicament', preItem: 'le'), isKnown: false),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [health.id], language1Data: const ItemLanguageData(languageCode: 'en', text: 'pain'), language2Data: const ItemLanguageData(languageCode: 'fr', text: 'douleur', preItem: 'la'), isKnown: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [health.id], language1Data: const ItemLanguageData(languageCode: 'en', text: 'fever'), language2Data: const ItemLanguageData(languageCode: 'fr', text: 'fièvre', preItem: 'la'), isKnown: false),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [health.id], language1Data: const ItemLanguageData(languageCode: 'en', text: 'sick'), language2Data: const ItemLanguageData(languageCode: 'fr', text: 'malade'), isKnown: true),

    // Education (6 items)
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [education.id], language1Data: const ItemLanguageData(languageCode: 'en', text: 'school'), language2Data: const ItemLanguageData(languageCode: 'fr', text: 'école', preItem: "l'"), isKnown: true, isImportant: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [education.id], language1Data: const ItemLanguageData(languageCode: 'en', text: 'student'), language2Data: const ItemLanguageData(languageCode: 'fr', text: 'étudiant', preItem: "l'"), isKnown: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [education.id], language1Data: const ItemLanguageData(languageCode: 'en', text: 'teacher'), language2Data: const ItemLanguageData(languageCode: 'fr', text: 'professeur', preItem: 'le'), isKnown: false),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [education.id], language1Data: const ItemLanguageData(languageCode: 'en', text: 'book'), language2Data: const ItemLanguageData(languageCode: 'fr', text: 'livre', preItem: 'le'), isKnown: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [education.id], language1Data: const ItemLanguageData(languageCode: 'en', text: 'exam'), language2Data: const ItemLanguageData(languageCode: 'fr', text: 'examen', preItem: "l'"), isKnown: false),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [education.id], language1Data: const ItemLanguageData(languageCode: 'en', text: 'homework'), language2Data: const ItemLanguageData(languageCode: 'fr', text: 'devoirs', preItem: 'les'), isKnown: false),

    // Emotions (5 items)
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [emotions.id], language1Data: const ItemLanguageData(languageCode: 'en', text: 'happy'), language2Data: const ItemLanguageData(languageCode: 'fr', text: 'heureux'), isKnown: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [emotions.id], language1Data: const ItemLanguageData(languageCode: 'en', text: 'sad'), language2Data: const ItemLanguageData(languageCode: 'fr', text: 'triste'), isKnown: false),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [emotions.id], language1Data: const ItemLanguageData(languageCode: 'en', text: 'angry'), language2Data: const ItemLanguageData(languageCode: 'fr', text: 'en colère'), isKnown: false),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [emotions.id], language1Data: const ItemLanguageData(languageCode: 'en', text: 'tired'), language2Data: const ItemLanguageData(languageCode: 'fr', text: 'fatigué'), isKnown: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [emotions.id], language1Data: const ItemLanguageData(languageCode: 'en', text: 'excited'), language2Data: const ItemLanguageData(languageCode: 'fr', text: 'excité'), isKnown: false),
  ];

  for (final item in items) {
    await itemRepo.insertItem(item);
  }

  print('  ✓ Created 30 French items across 5 categories');
}

// ============================================================================
// Package 4: Hungarian → English (30 items)
// ============================================================================

Future<void> _createHungarianEnglishPackage(
  Uuid uuid,
  LanguagePackageRepository packageRepo,
  CategoryRepository categoryRepo,
  ItemRepository itemRepo,
) async {
  print('📦 Creating Hungarian → English package...');
  final packageId = uuid.v4();

  final package = LanguagePackage(
    id: packageId,
    languageCode1: 'hu',
    languageName1: 'Hungarian',
    languageCode2: 'en',
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
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [phrases.id], language1Data: const ItemLanguageData(languageCode: 'hu', text: 'Szia'), language2Data: const ItemLanguageData(languageCode: 'en', text: 'Hi'), isKnown: true, isImportant: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [phrases.id], language1Data: const ItemLanguageData(languageCode: 'hu', text: 'Viszlát'), language2Data: const ItemLanguageData(languageCode: 'en', text: 'Goodbye'), isKnown: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [phrases.id], language1Data: const ItemLanguageData(languageCode: 'hu', text: 'Köszönöm'), language2Data: const ItemLanguageData(languageCode: 'en', text: 'Thank you'), isKnown: true, isImportant: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [phrases.id], language1Data: const ItemLanguageData(languageCode: 'hu', text: 'Kérem'), language2Data: const ItemLanguageData(languageCode: 'en', text: 'Please'), isKnown: false, isImportant: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [phrases.id], language1Data: const ItemLanguageData(languageCode: 'hu', text: 'Elnézést'), language2Data: const ItemLanguageData(languageCode: 'en', text: 'Excuse me'), isKnown: false),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [phrases.id], language1Data: const ItemLanguageData(languageCode: 'hu', text: 'Nem értem'), language2Data: const ItemLanguageData(languageCode: 'en', text: "I don't understand"), isKnown: false, isImportant: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [phrases.id], language1Data: const ItemLanguageData(languageCode: 'hu', text: 'Segítség'), language2Data: const ItemLanguageData(languageCode: 'en', text: 'Help'), isKnown: true),

    // Verbs (7 items)
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [verbs.id], language1Data: const ItemLanguageData(languageCode: 'hu', text: 'lenni'), language2Data: const ItemLanguageData(languageCode: 'en', text: 'to be'), isKnown: true, isImportant: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [verbs.id], language1Data: const ItemLanguageData(languageCode: 'hu', text: 'menni'), language2Data: const ItemLanguageData(languageCode: 'en', text: 'to go'), isKnown: false, isImportant: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [verbs.id], language1Data: const ItemLanguageData(languageCode: 'hu', text: 'jönni'), language2Data: const ItemLanguageData(languageCode: 'en', text: 'to come'), isKnown: false),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [verbs.id], language1Data: const ItemLanguageData(languageCode: 'hu', text: 'enni'), language2Data: const ItemLanguageData(languageCode: 'en', text: 'to eat'), isKnown: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [verbs.id], language1Data: const ItemLanguageData(languageCode: 'hu', text: 'inni'), language2Data: const ItemLanguageData(languageCode: 'en', text: 'to drink'), isKnown: false),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [verbs.id], language1Data: const ItemLanguageData(languageCode: 'hu', text: 'beszélni'), language2Data: const ItemLanguageData(languageCode: 'en', text: 'to speak'), isKnown: false),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [verbs.id], language1Data: const ItemLanguageData(languageCode: 'hu', text: 'tanulni'), language2Data: const ItemLanguageData(languageCode: 'en', text: 'to learn'), isKnown: true, isImportant: true),

    // Nouns (6 items)
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [nouns.id], language1Data: const ItemLanguageData(languageCode: 'hu', text: 'könyv'), language2Data: const ItemLanguageData(languageCode: 'en', text: 'book'), isKnown: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [nouns.id], language1Data: const ItemLanguageData(languageCode: 'hu', text: 'asztal'), language2Data: const ItemLanguageData(languageCode: 'en', text: 'table'), isKnown: false),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [nouns.id], language1Data: const ItemLanguageData(languageCode: 'hu', text: 'szék'), language2Data: const ItemLanguageData(languageCode: 'en', text: 'chair'), isKnown: false),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [nouns.id], language1Data: const ItemLanguageData(languageCode: 'hu', text: 'ház'), language2Data: const ItemLanguageData(languageCode: 'en', text: 'house'), isKnown: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [nouns.id], language1Data: const ItemLanguageData(languageCode: 'hu', text: 'autó'), language2Data: const ItemLanguageData(languageCode: 'en', text: 'car'), isKnown: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [nouns.id], language1Data: const ItemLanguageData(languageCode: 'hu', text: 'víz'), language2Data: const ItemLanguageData(languageCode: 'en', text: 'water'), isKnown: false),

    // Adjectives (5 items)
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [adjectives.id], language1Data: const ItemLanguageData(languageCode: 'hu', text: 'jó'), language2Data: const ItemLanguageData(languageCode: 'en', text: 'good'), isKnown: true, isImportant: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [adjectives.id], language1Data: const ItemLanguageData(languageCode: 'hu', text: 'rossz'), language2Data: const ItemLanguageData(languageCode: 'en', text: 'bad'), isKnown: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [adjectives.id], language1Data: const ItemLanguageData(languageCode: 'hu', text: 'nagy'), language2Data: const ItemLanguageData(languageCode: 'en', text: 'big'), isKnown: false),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [adjectives.id], language1Data: const ItemLanguageData(languageCode: 'hu', text: 'kicsi'), language2Data: const ItemLanguageData(languageCode: 'en', text: 'small'), isKnown: false),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [adjectives.id], language1Data: const ItemLanguageData(languageCode: 'hu', text: 'szép'), language2Data: const ItemLanguageData(languageCode: 'en', text: 'beautiful'), isKnown: true),

    // Places (5 items)
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [places.id], language1Data: const ItemLanguageData(languageCode: 'hu', text: 'iskola'), language2Data: const ItemLanguageData(languageCode: 'en', text: 'school'), isKnown: true, isImportant: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [places.id], language1Data: const ItemLanguageData(languageCode: 'hu', text: 'bolt'), language2Data: const ItemLanguageData(languageCode: 'en', text: 'shop'), isKnown: false),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [places.id], language1Data: const ItemLanguageData(languageCode: 'hu', text: 'étterem'), language2Data: const ItemLanguageData(languageCode: 'en', text: 'restaurant'), isKnown: false),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [places.id], language1Data: const ItemLanguageData(languageCode: 'hu', text: 'park'), language2Data: const ItemLanguageData(languageCode: 'en', text: 'park'), isKnown: true),
    Item(id: uuid.v4(), packageId: packageId, categoryIds: [places.id], language1Data: const ItemLanguageData(languageCode: 'hu', text: 'pályaudvar'), language2Data: const ItemLanguageData(languageCode: 'en', text: 'train station'), isKnown: false, isImportant: true),
  ];

  for (final item in items) {
    await itemRepo.insertItem(item);
  }

  print('  ✓ Created 30 Hungarian items across 5 categories');
}

