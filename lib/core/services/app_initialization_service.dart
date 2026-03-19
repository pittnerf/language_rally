import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/database_helper.dart';
import '../../data/repositories/language_package_group_repository.dart';
import '../../data/repositories/language_package_repository.dart';
import '../../data/repositories/category_repository.dart';
import '../../data/repositories/item_repository.dart';
import '../../data/repositories/import_export_repository.dart';
import '../../data/models/language_package_group.dart';
import '../utils/debug_print.dart';

/// Service responsible for app initialization tasks
/// Performs heavy operations that might block the UI during startup
class AppInitializationService {
  static bool _isInitialized = false;
  static const String defaultGroupId = 'default-group-id';
  static const String defaultGroupName = 'Default';

  /// SharedPreferences key that marks seed-package import as done.
  /// Bump the version suffix (v1 → v2 …) when you add new seed packages so
  /// existing installations pick them up on the next update.
  static const String _seedFlagKey = 'seed_packages_v1_imported';

  /// Asset paths of language packages that are bundled with the app.
  /// Add a new entry here whenever you drop a new .zip into assets/seed_packages/.
  static const List<String> _seedPackageAssets = [
    'assets/seed_packages/package_en-UK_de-DE.zip',
    // 'assets/seed_packages/english_french_basic.zip',
  ];

  /// Initialize the app with necessary setup tasks
  /// Returns true if initialization was successful
  static Future<bool> initialize() async {
    if (_isInitialized) {
      return true;
    }

    try {
      // Database must be ready before anything else
      await _initializeDatabase();

      // Asset warm-up and package seeding can run in parallel
      await Future.wait([
        _warmUpAssets(),
        _seedDefaultPackages(),
      ]);

      _isInitialized = true;
      return true;
    } catch (e) {
      logDebug('Error during app initialization: $e');
      return false;
    }
  }

  /// Initialize database connection and run any pending migrations
  static Future<void> _initializeDatabase() async {
    try {
      // Get database instance to ensure it's initialized
      await DatabaseHelper.instance.database;
      logDebug('✓ Database initialized');

      // Ensure default group exists (safety check)
      // await _ensureDefaultGroupExists();
      // logDebug('✓ Default group verified');
    } catch (e) {
      logDebug('✗ Database initialization failed: $e');
      rethrow;
    }
  }

  /// Ensure the default group exists in the database
  /// This is a safety measure to prevent foreign key constraint errors
  /// when creating packages on a fresh installation
  static Future<void> _ensureDefaultGroupExists() async {
    try {
      final groupRepo = LanguagePackageGroupRepository();

      // Check if default group exists
      final existingGroup = await groupRepo.getGroupById(defaultGroupId);

      if (existingGroup == null) {
        // Create default group if it doesn't exist
        final defaultGroup = LanguagePackageGroup(
          id: defaultGroupId,
          name: defaultGroupName,
        );
        await groupRepo.insertGroup(defaultGroup);
        logDebug('  ✓ Created default package group');
      } else {
        logDebug('  ✓ Default package group exists');
      }
    } catch (e) {
      logDebug('  ⚠️  Error ensuring default group: $e');
      // Don't rethrow - this is a non-critical error
    }
  }

  /// Pre-load or warm up assets to avoid first-load delays
  static Future<void> _warmUpAssets() async {
    // Add a small delay to prevent blocking
    await Future.delayed(const Duration(milliseconds: 100));
    logDebug('✓ Assets warmed up');
  }

  /// On the very first launch, import every ZIP listed in [_seedPackageAssets]
  /// from the Flutter asset bundle into the database.
  ///
  /// A [SharedPreferences] flag prevents re-importing on subsequent launches.
  /// To ship additional packages in a later app version, create a new flag key
  /// (e.g. _seedFlagKey = 'seed_packages_v2_imported') and add the new paths.
  static Future<void> _seedDefaultPackages() async {
    if (_seedPackageAssets.isEmpty) return;

    try {
      final prefs = await SharedPreferences.getInstance();

      if (prefs.getBool(_seedFlagKey) == true) {
        logDebug('  ✓ Seed packages already imported, skipping');
        return;
      }

      logDebug('🌱 Seeding default packages…');

      final importRepo = ImportExportRepository(
        packageRepo: LanguagePackageRepository(),
        groupRepo:   LanguagePackageGroupRepository(),
        categoryRepo: CategoryRepository(),
        itemRepo:    ItemRepository(),
      );

      int successCount = 0;

      for (final assetPath in _seedPackageAssets) {
        try {
          final byteData = await rootBundle.load(assetPath);
          final bytes = byteData.buffer.asUint8List();
          final result = await importRepo.importPackageFromZipBytes(bytes);
          logDebug(
            '  ✓ Seeded $assetPath'
            ' — ${result.itemCount} items in group "${result.groupName}"',
          );
          successCount++;
        } catch (e) {
          // A single bad ZIP must not block the rest
          logDebug('  ⚠️  Failed to seed $assetPath: $e');
        }
      }

      // Mark done only after at least one package was imported
      if (successCount > 0) {
        await prefs.setBool(_seedFlagKey, true);
      }

      logDebug(
        '✓ Seeding complete: $successCount / ${_seedPackageAssets.length} packages imported',
      );
    } catch (e) {
      // Seeding is non-critical — the app works fine without seed data
      logDebug('⚠️  Error during package seeding: $e');
    }
  }

  /// Reset initialization state (useful for testing)
  static void reset() {
    _isInitialized = false;
  }

  /// Remove all seed-package SharedPreferences flags so the next call to
  /// [initialize] re-imports every bundled package.
  /// Call this from any "clear all data" admin tool after wiping the database.
  static Future<void> resetSeedFlags() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // Remove every known seed flag; add new ones here when you bump the key.
      await prefs.remove(_seedFlagKey);
      logDebug('  ✓ Seed-package import flag cleared');
    } catch (e) {
      logDebug('  ⚠️  Could not clear seed flags: $e');
    }
    // Also reset the in-process flag so initialize() will re-run seeding
    // if called again in the same process (e.g. after a hot-restart in dev).
    _isInitialized = false;
  }
}

