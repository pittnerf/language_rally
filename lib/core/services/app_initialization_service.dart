import 'dart:convert';
import 'package:flutter/foundation.dart';
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

// ---------------------------------------------------------------------------
// Progress model
// ---------------------------------------------------------------------------

/// Carries the current seeding state for the [SplashScreen] to display.
class SeedingProgress {
  final int current;   // packages imported so far in this run
  final int total;     // total packages that need importing
  final bool isActive; // true while seeding is ongoing

  const SeedingProgress({
    this.current = 0,
    this.total = 0,
    this.isActive = false,
  });

  /// 0.0 → 1.0 progress fraction; safe when total == 0.
  double get fraction => total > 0 ? current / total : 0.0;
}

/// Service responsible for app initialization tasks
/// Performs heavy operations that might block the UI during startup
class AppInitializationService {
  static bool _isInitialized = false;
  static const String defaultGroupId = 'default-group-id';
  static const String defaultGroupName = 'Default';

  // ---------------------------------------------------------------------------
  // Progress notifier — SplashScreen listens to this
  // ---------------------------------------------------------------------------
  static final ValueNotifier<SeedingProgress> seedingProgress =
      ValueNotifier(const SeedingProgress());

  /// SharedPreferences key that marks seed-package import as done.
  /// Bump the version suffix (v1 → v2 …) when you add new seed packages so
  /// existing installations pick them up on the next update.
  static const String _seedFlagKey = 'seed_packages_v1_imported';

  /// Key that stores a JSON-encoded list of already-imported asset paths.
  /// Used to resume an interrupted seeding run on the next launch.
  static const String _seedProgressKey = 'seed_packages_v1_done_list';

  /// Asset paths of language packages that are bundled with the app.
  /// Add a new entry here whenever you drop a new .zip into assets/seed_packages/.
  static const List<String> _seedPackageAssets = [
    // A1 - EN-DE
    'assets/seed_packages/package_en-UK_German (Germany)_1774378257775.zip',
    'assets/seed_packages/package_en-UK_German (Germany)_1774378260444.zip',
    'assets/seed_packages/package_en-UK_German (Germany)_1774378263494.zip',
    'assets/seed_packages/package_en-UK_German (Germany)_1774378266041.zip',
    'assets/seed_packages/package_en-UK_German (Germany)_1774378269032.zip',
    'assets/seed_packages/package_en-UK_German (Germany)_1774378271453.zip',
    'assets/seed_packages/package_en-UK_German (Germany)_1774378273973.zip',
    'assets/seed_packages/package_en-UK_German (Germany)_1774378276582.zip',
    'assets/seed_packages/package_en-UK_German (Germany)_1774378279644.zip',
    'assets/seed_packages/package_en-UK_German (Germany)_1774378282176.zip',
    'assets/seed_packages/package_en-UK_German (Germany)_1774378284586.zip',
    'assets/seed_packages/package_en-UK_German (Germany)_1774378287175.zip',
    'assets/seed_packages/package_en-UK_German (Germany)_1774378289632.zip',
    'assets/seed_packages/package_en-UK_German (Germany)_1774378292483.zip',
    'assets/seed_packages/package_en-UK_German (Germany)_1774378294992.zip',
    'assets/seed_packages/package_en-UK_German (Germany)_1774378297685.zip',
    'assets/seed_packages/package_en-UK_German (Germany)_1774378300104.zip',
    'assets/seed_packages/package_en-UK_German (Germany)_1774378302651.zip',
    'assets/seed_packages/package_en-UK_German (Germany)_1774378304962.zip',
    'assets/seed_packages/package_en-UK_German (Germany)_1774378307726.zip',
    // A2 - EN-DE
    'assets/seed_packages/package_en-UK_German (Germany)_1774378310200.zip',
    'assets/seed_packages/package_en-UK_German (Germany)_1774378313190.zip',
    'assets/seed_packages/package_en-UK_German (Germany)_1774378315617.zip',
    'assets/seed_packages/package_en-UK_German (Germany)_1774378318592.zip',
    'assets/seed_packages/package_en-UK_German (Germany)_1774378321052.zip',
    'assets/seed_packages/package_en-UK_German (Germany)_1774378323965.zip',
    'assets/seed_packages/package_en-UK_German (Germany)_1774378326376.zip',
    'assets/seed_packages/package_en-UK_German (Germany)_1774378329166.zip',
    'assets/seed_packages/package_en-UK_German (Germany)_1774378331665.zip',
    'assets/seed_packages/package_en-UK_German (Germany)_1774378335203.zip',
    'assets/seed_packages/package_en-UK_German (Germany)_1774378337681.zip',
    'assets/seed_packages/package_en-UK_German (Germany)_1774378340373.zip',
    'assets/seed_packages/package_en-UK_German (Germany)_1774378342719.zip',
    'assets/seed_packages/package_en-UK_German (Germany)_1774378345598.zip',
    'assets/seed_packages/package_en-UK_German (Germany)_1774378348007.zip',
    'assets/seed_packages/package_en-UK_German (Germany)_1774378350838.zip',
    'assets/seed_packages/package_en-UK_German (Germany)_1774378353315.zip',
    'assets/seed_packages/package_en-UK_German (Germany)_1774378356234.zip',
    'assets/seed_packages/package_en-UK_German (Germany)_1774378358615.zip',
    'assets/seed_packages/package_en-UK_German (Germany)_1774378360994.zip',

    // B1 - EN-DE
    'assets/seed_packages/package_en-UK_German (Germany)_1774378363629.zip',
    'assets/seed_packages/package_en-UK_German (Germany)_1774378366023.zip',
    'assets/seed_packages/package_en-UK_German (Germany)_1774378368624.zip',
    'assets/seed_packages/package_en-UK_German (Germany)_1774378371008.zip',
    'assets/seed_packages/package_en-UK_German (Germany)_1774378373623.zip',


    // B2
    'assets/seed_packages/package_en-UK_German (Germany)_1774378415376.zip',
    'assets/seed_packages/package_en-UK_German (Germany)_1774378417822.zip',
    'assets/seed_packages/package_en-UK_German (Germany)_1774378420799.zip',
    'assets/seed_packages/package_en-UK_German (Germany)_1774378423343.zip',
    'assets/seed_packages/package_en-UK_German (Germany)_1774378425779.zip',

    // C1
    'assets/seed_packages/package_en-UK_German (Germany)_1774378466342.zip',
    'assets/seed_packages/package_en-UK_German (Germany)_1774378468806.zip',
    'assets/seed_packages/package_en-UK_German (Germany)_1774378471418.zip',
    'assets/seed_packages/package_en-UK_German (Germany)_1774378473813.zip',
    'assets/seed_packages/package_en-UK_German (Germany)_1774378476496.zip',

    // C2
    'assets/seed_packages/package_en-UK_German (Germany)_1774378524244.zip',
    'assets/seed_packages/package_en-UK_German (Germany)_1774378527274.zip',
    'assets/seed_packages/package_en-UK_German (Germany)_1774378530452.zip',
    'assets/seed_packages/package_en-UK_German (Germany)_1774378533823.zip',
    'assets/seed_packages/package_en-UK_German (Germany)_1774378536906.zip',



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
  /// Progress is reported through [seedingProgress] so the SplashScreen can
  /// display a real-time progress indicator.
  ///
  /// Each successfully imported package is recorded in SharedPreferences
  /// immediately, so the process can be **resumed** from where it stopped if
  /// the app is sent to the background or the screen saver fires mid-seeding.
  static Future<void> _seedDefaultPackages() async {
    if (_seedPackageAssets.isEmpty) return;

    try {
      final prefs = await SharedPreferences.getInstance();

      // Fast-path: all packages were already imported (old or completed runs).
      if (prefs.getBool(_seedFlagKey) == true) {
        logDebug('  ✓ Seed packages already imported, skipping');
        return;
      }

      // Load the set of packages already imported in previous (interrupted) runs.
      final doneJson = prefs.getString(_seedProgressKey) ?? '[]';
      final doneSet = Set<String>.from(
        (jsonDecode(doneJson) as List<dynamic>).cast<String>(),
      );

      final total = _seedPackageAssets.length;

      // If all paths are already done, set the fast-path flag and exit.
      if (doneSet.length >= total) {
        await prefs.setBool(_seedFlagKey, true);
        await prefs.remove(_seedProgressKey);
        logDebug('  ✓ All seed packages already done (via progress set)');
        return;
      }

      final pending =
          _seedPackageAssets.where((p) => !doneSet.contains(p)).toList();

      logDebug(
        '🌱 Seeding packages: ${doneSet.length} already done, '
        '${pending.length} pending (total $total)…',
      );

      // Announce the overall progress so the SplashScreen can show a bar.
      seedingProgress.value = SeedingProgress(
        current: doneSet.length,
        total: total,
        isActive: true,
      );

      final importRepo = ImportExportRepository(
        packageRepo: LanguagePackageRepository(),
        groupRepo: LanguagePackageGroupRepository(),
        categoryRepo: CategoryRepository(),
        itemRepo: ItemRepository(),
      );

      for (final assetPath in pending) {
        try {
          final byteData = await rootBundle.load(assetPath);
          final bytes = byteData.buffer.asUint8List();

          // Use the seeding-optimised importer (single DB transaction per package).
          final result =
              await importRepo.importPackageFromZipBytesSeeding(bytes);

          // Persist the completion of this individual package immediately.
          doneSet.add(assetPath);
          await prefs.setString(_seedProgressKey, jsonEncode(doneSet.toList()));

          logDebug(
            '  ✓ Seeded $assetPath'
            ' — ${result.itemCount} items in group "${result.groupName}"',
          );
        } catch (e) {
          // A single bad ZIP must not block the rest.
          logDebug('  ⚠️  Failed to seed $assetPath: $e');
        }

        // Update progress after every attempt (success or failure).
        seedingProgress.value = SeedingProgress(
          current: doneSet.length,
          total: total,
          isActive: true,
        );
      }

      // When all packages are done, set the fast-path flag and clean up.
      if (doneSet.length >= total) {
        await prefs.setBool(_seedFlagKey, true);
        await prefs.remove(_seedProgressKey);
      }

      logDebug(
        '✓ Seeding complete: ${doneSet.length}/$total packages imported',
      );
    } catch (e) {
      logDebug('⚠️  Error during package seeding: $e');
    } finally {
      // Always clear the "active" flag so the SplashScreen stops showing progress.
      seedingProgress.value = SeedingProgress(
        current: seedingProgress.value.current,
        total: seedingProgress.value.total,
        isActive: false,
      );
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
      await prefs.remove(_seedProgressKey);
      logDebug('  ✓ Seed-package import flags cleared');
    } catch (e) {
      logDebug('  ⚠️  Could not clear seed flags: $e');
    }
    // Also reset the in-process flag so initialize() will re-run seeding
    // if called again in the same process (e.g. after a hot-restart in dev).
    _isInitialized = false;
  }
}
