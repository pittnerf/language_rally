// lib/presentation/pages/dev/test_data_page.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart' show getDatabasesPath, deleteDatabase;
import '../../../data/database_helper.dart';
import '../../../data/repositories/language_package_repository.dart';
import '../../../data/repositories/language_package_group_repository.dart';
import '../../../data/repositories/item_repository.dart';
import '../../../data/repositories/category_repository.dart';
import '../../../data/repositories/training_settings_repository.dart';
import '../../../data/repositories/training_statistics_repository.dart';
import '../../../data/models/language_package.dart';
import '../../../data/models/language_package_group.dart';
import '../../../data/models/item.dart';
import '../../../data/models/item_language_data.dart';
import '../../../data/models/category.dart';
import '../../../data/models/example_sentence.dart';
import '../../../data/models/training_settings.dart';
import '../../../data/models/training_session.dart';
import '../../../data/models/training_statistics.dart';
import '../../../data/models/badge_event.dart';

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
  late final LanguagePackageGroupRepository _groupRepo;
  late final ItemRepository _itemRepo;
  late final CategoryRepository _categoryRepo;
  late final TrainingSettingsRepository _settingsRepo;
  late final TrainingStatisticsRepository _statsRepo;

  @override
  void initState() {
    super.initState();
    _packageRepo = LanguagePackageRepository();
    _groupRepo = LanguagePackageGroupRepository();
    _itemRepo = ItemRepository();
    _categoryRepo = CategoryRepository();
    _settingsRepo = TrainingSettingsRepository();
    _statsRepo = TrainingStatisticsRepository();
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

      // Create or get default package group
      const defaultGroupId = 'default-group-id';
      const defaultGroupName = 'Default';

      var defaultGroup = await _groupRepo.getGroupById(defaultGroupId);

      if (defaultGroup == null) {
        defaultGroup = LanguagePackageGroup(
          id: defaultGroupId,
          name: defaultGroupName,
        );
        await _groupRepo.insertGroup(defaultGroup);
        _log('✓ Created default package group: "$defaultGroupName"\n');
      } else {
        _log('✓ Using existing default package group: "$defaultGroupName"\n');
      }

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
        groupId: 'default-group-id',
        languageCode1: 'en-US',
        languageName1: 'English (United States)',
        languageCode2: 'de-DE',
        languageName2: 'German (Germany)',
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
            languageCode: 'en-US',
            text: 'Hello',
          ),
          language2Data: const ItemLanguageData(
            languageCode: 'de-DE',
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
            languageCode: 'en-US',
            text: 'Good morning',
          ),
          language2Data: const ItemLanguageData(
            languageCode: 'de-DE',
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
            languageCode: 'en-US',
            text: 'apple',
          ),
          language2Data: const ItemLanguageData(
            languageCode: 'de-DE',
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
            languageCode: 'en-US',
            text: 'train station',
          ),
          language2Data: const ItemLanguageData(
            languageCode: 'de-DE',
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

      // Create training data
      await _createTrainingData(packageId, items);
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
        groupId: 'default-group-id',
        languageCode1: 'en-US',
        languageName1: 'English (United States)',
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
            languageCode: 'en-US',
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
            languageCode: 'en-US',
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
            languageCode: 'en-US',
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

      // Create training data
      await _createTrainingData(packageId, items);
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
        groupId: 'default-group-id',
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
            languageCode: 'fr-FR',
            text: 'réunion',
            preItem: 'une',
          ),
          language2Data: const ItemLanguageData(
            languageCode: 'en-US',
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
            languageCode: 'fr-FR',
            text: 'contrat',
            preItem: 'un',
          ),
          language2Data: const ItemLanguageData(
            languageCode: 'en-US',
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

      // Create training data
      await _createTrainingData(packageId, items);
    } catch (e) {
      _log('  ❌ Error creating FR-EN package: $e');
      rethrow;
    }
  }

  Future<void> _createTrainingData(String packageId, List<Item> items) async {
    _log('  📊 Creating training data...');

    try {
      // Create two different training settings
      final settings1 = TrainingSettings(
        packageId: packageId,
        itemScope: ItemScope.all,
        itemOrder: ItemOrder.random,
        displayLanguage: DisplayLanguage.random,
        selectedCategoryIds: [],
        dontKnowThreshold: 3,
      );

      final settings2 = TrainingSettings(
        packageId: packageId,
        itemScope: ItemScope.lastN,
        lastNItems: 5,
        itemOrder: ItemOrder.sequential,
        displayLanguage: DisplayLanguage.motherTongue,
        selectedCategoryIds: items.isNotEmpty ? [items.first.categoryIds.first] : [],
        dontKnowThreshold: 5,
      );

      await _settingsRepo.saveSettings(settings1);
      await _settingsRepo.saveSettings(settings2);
      _log('    ✓ Training settings created');

      // Create first training session (completed with good accuracy)
      final session1ItemIds = items.take(3).map((i) => i.id).toList();
      final session1Outcomes = [true, true, false]; // 2 correct, 1 wrong
      final session1StartTime = DateTime.now().subtract(const Duration(days: 2));

      final session1 = TrainingSession(
        id: _uuid.v4(),
        packageId: packageId,
        settings: settings1,
        itemIds: session1ItemIds,
        itemOutcomes: session1Outcomes,
        historicalAccuracyRatios: [100.0, 100.0, 66.67], // Accuracy after each answer
        badgeEvents: [
          BadgeEvent.earned(
            badgeId: 'badge_50', // 50% Learner badge
            totalAnswers: 2,
            accuracy: 100.0,
          ),
          BadgeEvent.lost(
            badgeId: 'badge_50', // Lost when accuracy dropped
            totalAnswers: 3,
            accuracy: 66.67,
          ),
          BadgeEvent.earned(
            badgeId: 'badge_25', // 25% Beginner badge at 66.67%
            totalAnswers: 3,
            accuracy: 66.67,
          ),
        ],
        currentItemIndex: session1ItemIds.length,
        correctAnswers: 2,
        totalAnswers: 3,
        startedAt: session1StartTime,
        completedAt: session1StartTime.add(const Duration(minutes: 5)),
        status: SessionStatus.completed,
      );

      await _statsRepo.saveSession(session1);
      _log('    ✓ Training session 1 created (completed, 66% accuracy)');

      // Create second training session (completed with high accuracy)
      final session2ItemIds = items.take(4).map((i) => i.id).toList();
      final session2Outcomes = [true, true, true, true]; // All correct
      final session2StartTime = DateTime.now().subtract(const Duration(days: 1));

      final session2 = TrainingSession(
        id: _uuid.v4(),
        packageId: packageId,
        settings: settings2,
        itemIds: session2ItemIds,
        itemOutcomes: session2Outcomes,
        historicalAccuracyRatios: [100.0, 100.0, 100.0, 100.0],
        badgeEvents: [
          BadgeEvent.earned(
            badgeId: 'badge_25', // 25% Beginner
            totalAnswers: 1,
            accuracy: 100.0,
          ),
          BadgeEvent.earned(
            badgeId: 'badge_50', // 50% Learner
            totalAnswers: 2,
            accuracy: 100.0,
          ),
          BadgeEvent.earned(
            badgeId: 'badge_75', // 75% Skilled
            totalAnswers: 3,
            accuracy: 100.0,
          ),
          BadgeEvent.earned(
            badgeId: 'badge_80', // 80% Advanced
            totalAnswers: 4,
            accuracy: 100.0,
          ),
          BadgeEvent.earned(
            badgeId: 'badge_85', // 85% Proficient
            totalAnswers: 4,
            accuracy: 100.0,
          ),
          BadgeEvent.earned(
            badgeId: 'badge_90', // 90% Excellent
            totalAnswers: 4,
            accuracy: 100.0,
          ),
          BadgeEvent.earned(
            badgeId: 'badge_95', // 95% Master
            totalAnswers: 4,
            accuracy: 100.0,
          ),
          BadgeEvent.earned(
            badgeId: 'badge_100', // 100% Wizard
            totalAnswers: 4,
            accuracy: 100.0,
          ),
        ],
        currentItemIndex: session2ItemIds.length,
        correctAnswers: 4,
        totalAnswers: 4,
        startedAt: session2StartTime,
        completedAt: session2StartTime.add(const Duration(minutes: 8)),
        status: SessionStatus.completed,
      );

      await _statsRepo.saveSession(session2);
      _log('    ✓ Training session 2 created (completed, 100% accuracy)');

      // Create training statistics
      final statistics = TrainingStatistics(
        packageId: packageId,
        totalItemsLearned: items.where((i) => i.isKnown).length,
        totalItemsReviewed: 7, // Total from both sessions
        currentStreak: 2,
        longestStreak: 2,
        lastTrainedAt: session2StartTime.add(const Duration(minutes: 8)),
        averageAccuracy: 85.71, // Average of 66.67% and 100%
      );

      await _statsRepo.saveStatistics(statistics);
      _log('    ✓ Training statistics created');
      _log('  ✅ Training data complete');
    } catch (e) {
      _log('  ❌ Error creating training data: $e');
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

      // Get the database path
      final path = await _getDatabasePath();
      _log('  Database path: $path');

      // Close the database connection through the singleton
      final dbHelper = DatabaseHelper.instance;
      await dbHelper.close();
      _log('  ✓ Database connection closed');

      // Give a small delay to ensure the connection is fully released
      await Future.delayed(const Duration(milliseconds: 100));

      // Delete the database using sqflite's deleteDatabase (which handles locks properly)
      if (Platform.isAndroid || Platform.isIOS) {
        // On Android/iOS, use sqflite's deleteDatabase
        await deleteDatabase(path);
        _log('  ✓ Database deleted using sqflite deleteDatabase');
      } else {
        // On desktop, delete the file directly
        final dbFile = File(path);
        if (await dbFile.exists()) {
          await dbFile.delete();
          _log('  ✓ Database file deleted');
        } else {
          _log('  ⚠ Database file not found (may be already deleted)');
        }
      }

      // Delete custom icons directory
      try {
        final appDir = await getApplicationDocumentsDirectory();
        final customIconsDir = Directory(join(appDir.path, 'custom_package_icons'));

        if (await customIconsDir.exists()) {
          await customIconsDir.delete(recursive: true);
          _log('  ✓ Custom icons directory deleted');
        } else {
          _log('  ⚠ Custom icons directory not found');
        }
      } catch (e) {
        _log('  ⚠ Could not delete custom icons directory: $e');
        // Don't fail the entire reset if custom icons deletion fails
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
      // For mobile, use sqflite's getDatabasesPath
      dbPath = await getDatabasesPath();
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
      body: SafeArea(
        child: Padding(
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
      ),
    );
  }
}

