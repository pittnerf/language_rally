// lib/presentation/pages/dev/test_data_page.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../../../data/repositories/language_package_repository.dart';
import '../../../data/repositories/item_repository.dart';
import '../../../data/repositories/category_repository.dart';
import '../../../data/models/language_package.dart';
import '../../../data/models/item.dart';
import '../../../data/models/item_language_data.dart';
import '../../../data/models/category.dart';
import '../../../data/models/example_sentence.dart';

class TestDataPage extends StatefulWidget {
  const TestDataPage({super.key});

  @override
  State<TestDataPage> createState() => _TestDataPageState();
}

class _TestDataPageState extends State<TestDataPage> {
  bool _isLoading = false;
  String _statusMessage = '';
  final _uuid = const Uuid();
  late final LanguagePackageRepository _packageRepo;
  late final ItemRepository _itemRepo;
  late final CategoryRepository _categoryRepo;

  @override
  void initState() {
    super.initState();
    _packageRepo = LanguagePackageRepository();
    _itemRepo = ItemRepository();
    _categoryRepo = CategoryRepository();
  }

  void _log(String message) {
    setState(() {
      _statusMessage += '$message\n';
    });
    debugPrint(message);
  }

  Future<void> _populateData() async {
    setState(() {
      _isLoading = true;
      _statusMessage = '';
    });

    try {
      _log('🚀 Starting test data population...');

      await _createEnglishGermanPackage();
      await _createEnglishSpanishPackage();
      await _createFrenchEnglishPackage();

      _log('\n✅ Test data population completed!');
      _log('\nGo back to home and tap "View Packages" to see the results.');
    } catch (e, stackTrace) {
      _log('❌ Error: $e');
      _log('Stack trace: $stackTrace');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _createEnglishGermanPackage() async {
    _log('\n📦 Creating English → German package...');
    final packageId = _uuid.v4();

    try {
      final package = LanguagePackage(
        id: packageId,
        languageCode1: 'en',
        languageName1: 'English',
        languageCode2: 'de',
        languageName2: 'German',
        description: 'Essential German vocabulary for beginners',
        icon: null,
        authorName: 'Test Author',
        authorEmail: 'test@languagerally.com',
        authorWebpage: 'https://languagerally.com',
        version: '1.0.0',
        packageType: PackageType.userCreated,
        isPurchased: false,
        isReadonly: false,
        createdAt: DateTime.now(),
        price: 0.0,
      );

      await _packageRepo.insertPackage(package);
      _log('  ✓ Package created');

      // Create categories
      final greetingsCat = Category(
        id: _uuid.v4(),
        packageId: packageId,
        name: 'Greetings',
        description: 'Common greetings',
      );

      final foodCat = Category(
        id: _uuid.v4(),
        packageId: packageId,
        name: 'Food',
        description: 'Food and drinks',
      );

      final travelCat = Category(
        id: _uuid.v4(),
        packageId: packageId,
        name: 'Travel',
        description: 'Travel phrases',
      );

      await _categoryRepo.insertCategory(greetingsCat);
      await _categoryRepo.insertCategory(foodCat);
      await _categoryRepo.insertCategory(travelCat);
      _log('  ✓ Categories created');

      // Create items
      final items = [
        Item(
          id: _uuid.v4(),
          packageId: packageId,
          categoryIds: [greetingsCat.id],
          language1Data: const ItemLanguageData(
            languageCode: 'en',
            text: 'Hello',
          ),
          language2Data: const ItemLanguageData(
            languageCode: 'de',
            text: 'Hallo',
          ),
          examples: [
            ExampleSentence(
              id: _uuid.v4(),
              textLanguage1: 'Hello, how are you?',
              textLanguage2: 'Hallo, wie geht es dir?',
            ),
          ],
          isKnown: false,
          isImportant: true,
        ),
        Item(
          id: _uuid.v4(),
          packageId: packageId,
          categoryIds: [greetingsCat.id],
          language1Data: const ItemLanguageData(
            languageCode: 'en',
            text: 'Good morning',
          ),
          language2Data: const ItemLanguageData(
            languageCode: 'de',
            text: 'Guten Morgen',
          ),
          examples: [],
          isKnown: true,
        ),
        Item(
          id: _uuid.v4(),
          packageId: packageId,
          categoryIds: [foodCat.id],
          language1Data: const ItemLanguageData(
            languageCode: 'en',
            text: 'apple',
          ),
          language2Data: const ItemLanguageData(
            languageCode: 'de',
            text: 'Apfel',
            preItem: 'der',
          ),
          examples: [],
          isKnown: true,
        ),
        Item(
          id: _uuid.v4(),
          packageId: packageId,
          categoryIds: [travelCat.id],
          language1Data: const ItemLanguageData(
            languageCode: 'en',
            text: 'train station',
          ),
          language2Data: const ItemLanguageData(
            languageCode: 'de',
            text: 'Bahnhof',
            preItem: 'der',
          ),
          examples: [],
          isKnown: false,
          isImportant: true,
        ),
      ];

      for (final item in items) {
        await _itemRepo.insertItem(item);
      }
      _log('  ✓ Created ${items.length} items');
    } catch (e) {
      _log('  ❌ Error creating EN-DE package: $e');
      rethrow;
    }
  }

  Future<void> _createEnglishSpanishPackage() async {
    _log('\n📦 Creating English → Spanish package...');
    final packageId = _uuid.v4();

    try {
      final package = LanguagePackage(
        id: packageId,
        languageCode1: 'en',
        languageName1: 'English',
        languageCode2: 'es',
        languageName2: 'Spanish',
        description: 'Essential Spanish phrases for travelers',
        icon: null,
        authorName: 'Maria Garcia',
        authorEmail: 'maria@example.com',
        version: '2.1.0',
        packageType: PackageType.userCreated,
        isPurchased: false,
        isReadonly: false,
        createdAt: DateTime.now(),
        price: 0.0,
      );

      await _packageRepo.insertPackage(package);
      _log('  ✓ Package created');

      final greetingsCat = Category(
        id: _uuid.v4(),
        packageId: packageId,
        name: 'Greetings',
      );

      final restaurantCat = Category(
        id: _uuid.v4(),
        packageId: packageId,
        name: 'Restaurant',
      );

      await _categoryRepo.insertCategory(greetingsCat);
      await _categoryRepo.insertCategory(restaurantCat);
      _log('  ✓ Categories created');

      final items = [
        Item(
          id: _uuid.v4(),
          packageId: packageId,
          categoryIds: [greetingsCat.id],
          language1Data: const ItemLanguageData(
            languageCode: 'en',
            text: 'Hello',
          ),
          language2Data: const ItemLanguageData(
            languageCode: 'es',
            text: 'Hola',
          ),
          examples: [],
          isKnown: true,
          isImportant: true,
        ),
        Item(
          id: _uuid.v4(),
          packageId: packageId,
          categoryIds: [restaurantCat.id],
          language1Data: const ItemLanguageData(
            languageCode: 'en',
            text: 'I would like',
          ),
          language2Data: const ItemLanguageData(
            languageCode: 'es',
            text: 'Quisiera',
          ),
          examples: [],
          isKnown: false,
          isImportant: true,
        ),
        Item(
          id: _uuid.v4(),
          packageId: packageId,
          categoryIds: [restaurantCat.id],
          language1Data: const ItemLanguageData(
            languageCode: 'en',
            text: 'The bill, please',
          ),
          language2Data: const ItemLanguageData(
            languageCode: 'es',
            text: 'La cuenta, por favor',
          ),
          examples: [],
          isKnown: true,
        ),
      ];

      for (final item in items) {
        await _itemRepo.insertItem(item);
      }
      _log('  ✓ Created ${items.length} items');
    } catch (e) {
      _log('  ❌ Error creating EN-ES package: $e');
      rethrow;
    }
  }

  Future<void> _createFrenchEnglishPackage() async {
    _log('\n📦 Creating French → English package (Purchased)...');
    final packageId = _uuid.v4();

    try {
      final package = LanguagePackage(
        id: packageId,
        languageCode1: 'fr',
        languageName1: 'French',
        languageCode2: 'en',
        languageName2: 'English',
        description: 'Professional French vocabulary for business',
        icon: null,
        authorName: 'Language Rally Team',
        authorEmail: 'support@languagerally.com',
        authorWebpage: 'https://languagerally.com/premium',
        version: '3.5.2',
        packageType: PackageType.purchased,
        isPurchased: true,
        isReadonly: true,
        purchasedAt: DateTime.now().subtract(const Duration(days: 30)),
        createdAt: DateTime.now().subtract(const Duration(days: 90)),
        price: 9.99,
      );

      await _packageRepo.insertPackage(package);
      _log('  ✓ Package created');

      final businessCat = Category(
        id: _uuid.v4(),
        packageId: packageId,
        name: 'Business',
      );

      await _categoryRepo.insertCategory(businessCat);
      _log('  ✓ Categories created');

      final items = [
        Item(
          id: _uuid.v4(),
          packageId: packageId,
          categoryIds: [businessCat.id],
          language1Data: const ItemLanguageData(
            languageCode: 'fr',
            text: 'réunion',
            preItem: 'une',
          ),
          language2Data: const ItemLanguageData(
            languageCode: 'en',
            text: 'meeting',
            preItem: 'a',
          ),
          examples: [],
          isKnown: true,
          isImportant: true,
        ),
        Item(
          id: _uuid.v4(),
          packageId: packageId,
          categoryIds: [businessCat.id],
          language1Data: const ItemLanguageData(
            languageCode: 'fr',
            text: 'contrat',
            preItem: 'un',
          ),
          language2Data: const ItemLanguageData(
            languageCode: 'en',
            text: 'contract',
            preItem: 'a',
          ),
          examples: [],
          isKnown: false,
          isImportant: true,
        ),
      ];

      for (final item in items) {
        await _itemRepo.insertItem(item);
      }
      _log('  ✓ Created ${items.length} items');
    } catch (e) {
      _log('  ❌ Error creating FR-EN package: $e');
      rethrow;
    }
  }

  Future<void> _clearData() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Clearing all data...';
    });

    try {
      final packages = await _packageRepo.getAllPackages();
      for (final package in packages) {
        await _packageRepo.deletePackage(package.id);
      }
      setState(() {
        _statusMessage = '✅ All test data cleared!';
      });
    } catch (e) {
      setState(() {
        _statusMessage = '❌ Error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _resetDatabase() async {
    setState(() {
      _isLoading = true;
      _statusMessage = '';
    });

    try {
      _log('🔄 Resetting database...');

      // Import required dependencies
      final path = await _getDatabasePath();
      _log('  Database path: $path');

      // Close the database connection
      await _packageRepo.closeDatabase();
      _log('  ✓ Database connection closed');

      // Delete the database file
      final dbFile = File(path);
      if (await dbFile.exists()) {
        await dbFile.delete();
        _log('  ✓ Database file deleted');
      } else {
        _log('  ⚠ Database file not found (may be already deleted)');
      }

      _log('\n✅ Database reset complete!');
      _log('The app will now restart to recreate the database.');
      _log('\nPlease close and reopen the app, then run "Populate Test Data".');

      // Force app exit after a delay
      await Future.delayed(const Duration(seconds: 2));
      exit(0);
    } catch (e, stackTrace) {
      _log('❌ Error: $e');
      _log('Stack trace: $stackTrace');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<String> _getDatabasePath() async {
    String dbPath;
    if (Platform.isAndroid || Platform.isIOS) {
      // For mobile, use getDatabasesPath - we need to import sqflite for this
      dbPath = join(
        (await getApplicationDocumentsDirectory()).path,
        'databases'
      );
    } else {
      // For desktop platforms, use application documents directory
      final appDocDir = await getApplicationDocumentsDirectory();
      dbPath = join(appDocDir.path, 'language_rally_db');
    }
    return join(dbPath, 'language_rally.db');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Data Generator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Test Data Generator',
                          style: theme.textTheme.titleLarge,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'This tool will create 3 language packages with sample items:',
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '• English → German (Basics)\n'
                      '• English → Spanish (Travel)\n'
                      '• French → English (Business, Purchased)',
                      style: theme.textTheme.bodySmall,
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.errorContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.warning_amber_rounded,
                            color: theme.colorScheme.error,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Run this only once! Running multiple times will create duplicates.',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.error,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _populateData,
              icon: const Icon(Icons.add_circle_outline),
              label: const Text('Populate Test Data'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _isLoading ? null : _clearData,
              icon: const Icon(Icons.delete_outline),
              label: const Text('Clear All Data'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _isLoading ? null : _resetDatabase,
              icon: const Icon(Icons.refresh),
              label: const Text('Reset Database (Fix Schema Issues)'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                foregroundColor: theme.colorScheme.error,
              ),
            ),
            const SizedBox(height: 24),
            if (_isLoading)
              const Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Please wait...'),
                  ],
                ),
              ),
            if (_statusMessage.isNotEmpty && !_isLoading)
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      child: Text(
                        _statusMessage,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

