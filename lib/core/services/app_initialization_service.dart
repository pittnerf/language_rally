import 'dart:convert';
import 'package:archive/archive.dart';
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
  static bool _needsOnboarding = false;
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

  /// Key that marks the first-launch onboarding wizard as completed.
  static const String _onboardingFlagKey = 'onboarding_v1_complete';

  /// True when the onboarding wizard has not yet been completed.
  /// Set during [initialize]; safe to read after [initialize] returns.
  static bool get needsOnboarding => _needsOnboarding;

  /// Asset paths of language packages that are bundled with the app.
  /// Add a new entry here whenever you drop a new .zip into assets/seed_packages/.
  static const List<String> _seedPackageAssets = [
    // Expressions - EN-DE
    //A1
    'assets/seed_packages/expressions/pkg_en_de_A1_Animals.zip',
    'assets/seed_packages/expressions/pkg_en_de_A1_Basic_daily_routines.zip',
    'assets/seed_packages/expressions/pkg_en_de_A1_Basic_health_feeling_sick_doctor.zip',
    'assets/seed_packages/expressions/pkg_en_de_A1_Body_parts.zip',
    'assets/seed_packages/expressions/pkg_en_de_A1_Clothing_colors.zip',
    'assets/seed_packages/expressions/pkg_en_de_A1_Countries_nationalities.zip',
    'assets/seed_packages/expressions/pkg_en_de_A1_Directions_left_right_near.zip',
    'assets/seed_packages/expressions/pkg_en_de_A1_Family_relationships.zip',
    'assets/seed_packages/expressions/pkg_en_de_A1_Food_drinks.zip',
    'assets/seed_packages/expressions/pkg_en_de_A1_Furniture_household_items.zip',
    'assets/seed_packages/expressions/pkg_en_de_A1_Greetings_introductions.zip',
    'assets/seed_packages/expressions/pkg_en_de_A1_Home_rooms.zip',
    'assets/seed_packages/expressions/pkg_en_de_A1_Leisure_activities.zip',
    'assets/seed_packages/expressions/pkg_en_de_A1_Numbers_dates_time.zip',
    'assets/seed_packages/expressions/pkg_en_de_A1_School_classroom.zip',
    'assets/seed_packages/expressions/pkg_en_de_A1_Shopping_basic_items_prices.zip',
    'assets/seed_packages/expressions/pkg_en_de_A1_Sports_basic.zip',
    'assets/seed_packages/expressions/pkg_en_de_A1_Transport_bus_train_taxi.zip',
    'assets/seed_packages/expressions/pkg_en_de_A1_Weather.zip',
    'assets/seed_packages/expressions/pkg_en_de_A1_Work_basic_jobs.zip',

    // A2
    'assets/seed_packages/expressions/pkg_en_de_A2_Basic_grammar_topics_presentpastfuture_simple_conditionals.zip',
    'assets/seed_packages/expressions/pkg_en_de_A2_City_places_bank_post_office.zip',
    'assets/seed_packages/expressions/pkg_en_de_A2_Communication_phone_messages.zip',
    'assets/seed_packages/expressions/pkg_en_de_A2_Daily_routines_detailed.zip',
    'assets/seed_packages/expressions/pkg_en_de_A2_Directions_navigation.zip',
    // B1
    'assets/seed_packages/expressions/pkg_en_de_B1_Basic_politics_society.zip',
    'assets/seed_packages/expressions/pkg_en_de_B1_City_vs_countryside.zip',
    'assets/seed_packages/expressions/pkg_en_de_B1_Communication_language_learning.zip',
    'assets/seed_packages/expressions/pkg_en_de_B1_Culture_traditions.zip',
    'assets/seed_packages/expressions/pkg_en_de_B1_Education_systems.zip',
    // B2
    'assets/seed_packages/expressions/pkg_en_de_B2_Business_basics.zip',
    'assets/seed_packages/expressions/pkg_en_de_B2_Career_development.zip',
    'assets/seed_packages/expressions/pkg_en_de_B2_Crime_law_basic.zip',
    'assets/seed_packages/expressions/pkg_en_de_B2_Culture_identity.zip',
    'assets/seed_packages/expressions/pkg_en_de_B2_Debate_argumentation.zip',
    // C1
    'assets/seed_packages/expressions/pkg_en_de_C1_Academic_writing_rhetoric.zip',
    'assets/seed_packages/expressions/pkg_en_de_C1_Advanced_technology_AI_digitalization.zip',
    'assets/seed_packages/expressions/pkg_en_de_C1_Art_literature_interpretation.zip',
    'assets/seed_packages/expressions/pkg_en_de_C1_Business_strategy.zip',
    'assets/seed_packages/expressions/pkg_en_de_C1_Communication_strategies.zip',
    // C2
    'assets/seed_packages/expressions/pkg_en_de_C2_Advanced_business_corporate_strategy.zip',
    'assets/seed_packages/expressions/pkg_en_de_C2_Advanced_economics_finance.zip',
    'assets/seed_packages/expressions/pkg_en_de_C2_Advanced_rhetoric_persuasion.zip',
    'assets/seed_packages/expressions/pkg_en_de_C2_Cultural_discourse_identity_theory.zip',
    'assets/seed_packages/expressions/pkg_en_de_C2_Ethics_in_technology_AI_bioethics.zip',


    // A1 - EN-DE
    'assets/seed_packages/words/pkg_en_de_A1_Greetings_introductions.zip',
    'assets/seed_packages/words/pkg_en_de_A1_Numbers_dates_time.zip',
    'assets/seed_packages/words/pkg_en_de_A1_Family_relationships.zip',
    'assets/seed_packages/words/pkg_en_de_A1_Food_drinks.zip',
    'assets/seed_packages/words/pkg_en_de_A1_Basic_daily_routines.zip',
    'assets/seed_packages/words/pkg_en_de_A1_Home_rooms.zip',
    'assets/seed_packages/words/pkg_en_de_A1_Furniture_household_items.zip',
    'assets/seed_packages/words/pkg_en_de_A1_Clothing_colors.zip',
    'assets/seed_packages/words/pkg_en_de_A1_Body_parts.zip',
    'assets/seed_packages/words/pkg_en_de_A1_Basic_health_feeling_sick_doctor.zip',
    'assets/seed_packages/words/pkg_en_de_A1_Weather.zip',
    'assets/seed_packages/words/pkg_en_de_A1_Shopping_basic_items_prices.zip',
    'assets/seed_packages/words/pkg_en_de_A1_Transport_bus_train_taxi.zip',
    'assets/seed_packages/words/pkg_en_de_A1_Directions_left_right_near.zip',
    'assets/seed_packages/words/pkg_en_de_A1_Work_basic_jobs.zip',
    'assets/seed_packages/words/pkg_en_de_A1_School_classroom.zip',
    'assets/seed_packages/words/pkg_en_de_A1_Leisure_activities.zip',
    'assets/seed_packages/words/pkg_en_de_A1_Sports_basic.zip',
    'assets/seed_packages/words/pkg_en_de_A1_Animals.zip',
    'assets/seed_packages/words/pkg_en_de_A1_Countries_nationalities.zip',
    // A2 - EN-DE
    'assets/seed_packages/words/pkg_en_de_A2_Travel_holidays.zip',
    'assets/seed_packages/words/pkg_en_de_A2_Hotels_accommodation.zip',
    'assets/seed_packages/words/pkg_en_de_A2_Restaurants_ordering_food.zip',
    'assets/seed_packages/words/pkg_en_de_A2_Shopping_clothes_sizes_preferences.zip',
    'assets/seed_packages/words/pkg_en_de_A2_Daily_routines_detailed.zip',

    // B1 - EN-DE
    'assets/seed_packages/words/pkg_en_de_B1_Travel_experiences_problems.zip',
    'assets/seed_packages/words/pkg_en_de_B1_Culture_traditions.zip',
    'assets/seed_packages/words/pkg_en_de_B1_Food_culture_cooking.zip',
    'assets/seed_packages/words/pkg_en_de_B1_Work_career.zip',
    'assets/seed_packages/words/pkg_en_de_B1_Education_systems.zip',


    // B2
    'assets/seed_packages/words/pkg_en_de_B2_Society_social_issues.zip',
    'assets/seed_packages/words/pkg_en_de_B2_Education_systems.zip',
    'assets/seed_packages/words/pkg_en_de_B2_Work-life_balance.zip',
    'assets/seed_packages/words/pkg_en_de_B2_Career_development.zip',
    'assets/seed_packages/words/pkg_en_de_B2_Business_basics.zip',

    // C1
    'assets/seed_packages/words/pkg_en_de_C1_Politics_governance.zip',
    'assets/seed_packages/words/pkg_en_de_C1_Economics_global_markets.zip',
    'assets/seed_packages/words/pkg_en_de_C1_Philosophy_ethics.zip',
    'assets/seed_packages/words/pkg_en_de_C1_Psychology_behavior.zip',
    'assets/seed_packages/words/pkg_en_de_C1_Advanced_technology_AI_digitalization.zip',

    // C2
    'assets/seed_packages/words/pkg_en_de_C2_Political_theory_ideology.zip',
    'assets/seed_packages/words/pkg_en_de_C2_Advanced_economics_finance.zip',
    'assets/seed_packages/words/pkg_en_de_C2_Legal_systems_case_analysis.zip',
    'assets/seed_packages/words/pkg_en_de_C2_Philosophy_deep_analysis.zip',
    'assets/seed_packages/words/pkg_en_de_C2_Linguistics_language_theory.zip',



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

      // Determine whether the first-run onboarding wizard is still pending.
      // Show onboarding ONLY when:
      //  (a) the onboarding-complete flag has never been set, AND
      //  (b) the database is genuinely empty (no packages imported yet).
      // This prevents the wizard appearing for users who already have data
      // (e.g. after an app update that accidentally cleared SharedPreferences).
      final prefs = await SharedPreferences.getInstance();
      final flagMissing = prefs.getBool(_onboardingFlagKey) != true;
      final dbEmpty = flagMissing &&
          await LanguagePackageRepository().getPackageCount() == 0;
      _needsOnboarding = flagMissing && dbEmpty;

      if (_needsOnboarding) {
        // Onboarding hasn't been completed yet – skip automatic seeding.
        // The wizard will call importSelectedGroups() after the user picks
        // the packages they want.
        await _warmUpAssets();
      } else {
        // Asset warm-up and package seeding can run in parallel
        await Future.wait([
          _warmUpAssets(),
          _seedDefaultPackages(),
        ]);
      }

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

  /// Reads a ZIP byte array and returns the value of `package.name` from
  /// its embedded `package_data.json`, or null if it cannot be determined.
  /// The ZIP is fully decoded to access the JSON entry.
  static String? _extractPackageName(List<int> bytes) {
    try {
      final archive = ZipDecoder().decodeBytes(bytes, verify: false);
      for (final entry in archive) {
        if (entry.isFile && entry.name == 'package_data.json') {
          final jsonStr = utf8.decode(entry.content as List<int>);
          final data = jsonDecode(jsonStr) as Map<String, dynamic>;
          final pkgData = data['package'] as Map<String, dynamic>?;
          return pkgData?['name'] as String?;
        }
      }
    } catch (_) {}
    return null;
  }

  /// On the very first launch, import every ZIP listed in [_seedPackageAssets]
  /// from the Flutter asset bundle into the database.
  ///
  /// Before importing each file, the package name is extracted from the ZIP and
  /// checked against the database.  Packages that already exist by name are
  /// silently skipped, making the seeder safe to re-run after partial imports.
  ///
  /// Progress is reported through [seedingProgress] so the SplashScreen can
  /// display a real-time progress indicator.
  ///
  /// Each successfully processed path is recorded in SharedPreferences
  /// immediately, so the process can be **resumed** if interrupted.
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

      final packageRepo = LanguagePackageRepository();
      final importRepo = ImportExportRepository(
        packageRepo: packageRepo,
        groupRepo: LanguagePackageGroupRepository(),
        categoryRepo: CategoryRepository(),
        itemRepo: ItemRepository(),
      );

      for (final assetPath in pending) {
        try {
          final byteData = await rootBundle.load(assetPath);
          final bytes = byteData.buffer.asUint8List();

          // Req 2: skip if a package with this name already exists in the DB.
          final pkgName = _extractPackageName(bytes);
          if (pkgName != null && await packageRepo.existsByName(pkgName)) {
            logDebug('  ✓ Skipping "$pkgName" — already in DB');
            doneSet.add(assetPath);
            await prefs.setString(
                _seedProgressKey, jsonEncode(doneSet.toList()));
            seedingProgress.value = SeedingProgress(
              current: doneSet.length,
              total: total,
              isActive: true,
            );
            continue;
          }

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
      await prefs.remove(_onboardingFlagKey);
      logDebug('  ✓ Seed-package import flags cleared');
    } catch (e) {
      logDebug('  ⚠️  Could not clear seed flags: $e');
    }
    // Also reset the in-process flag so initialize() will re-run seeding
    // if called again in the same process (e.g. after a hot-restart in dev).
    _isInitialized = false;
    _needsOnboarding = false;
  }

  // ---------------------------------------------------------------------------
  // Onboarding helpers
  // ---------------------------------------------------------------------------

  /// Marks the first-launch onboarding wizard as complete and also ensures
  /// the seed-package flag is set so automatic seeding is skipped on the
  /// next launch (whether or not the user imported anything during onboarding).
  static Future<void> markOnboardingComplete() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_onboardingFlagKey, true);
      // Ensure seeding is also marked done so the background seeder is skipped.
      await prefs.setBool(_seedFlagKey, true);
      await prefs.remove(_seedProgressKey);
      logDebug('  ✓ Onboarding marked complete');
    } catch (e) {
      logDebug('  ⚠️  Could not mark onboarding complete: $e');
    }
    _needsOnboarding = false;
  }

  /// Quickly scans all seed-package ZIPs to discover the unique group names
  /// they belong to, **without** importing anything into the database.
  ///
  /// Packages whose name already exists in the database are **excluded** from
  /// the result, so only groups that have at least one not-yet-imported
  /// package are returned.
  ///
  /// Returns a map of `group_name → [assetPath, …]` sorted by group name.
  /// Suitable for driving the onboarding package-selection UI.
  static Future<Map<String, List<String>>> scanSeedPackageGroups() async {
    final result = <String, List<String>>{};
    final packageRepo = LanguagePackageRepository();

    for (final assetPath in _seedPackageAssets) {
      try {
        final byteData = await rootBundle.load(assetPath);
        final bytes = byteData.buffer.asUint8List();

        // Decode ZIP and search for package_data.json
        final archive = ZipDecoder().decodeBytes(bytes);
        ArchiveFile? jsonEntry;
        for (final entry in archive) {
          if (entry.isFile && entry.name == 'package_data.json') {
            jsonEntry = entry;
            break;
          }
        }

        if (jsonEntry != null) {
          final jsonStr = utf8.decode(jsonEntry.content as List<int>);
          final data = jsonDecode(jsonStr) as Map<String, dynamic>;
          final packageData = data['package'] as Map<String, dynamic>?;
          if (packageData != null) {
            final groupName =
                (packageData['group_name'] as String?) ?? 'Default';
            final pkgName = packageData['name'] as String?;

            // Skip packages that already exist in the database.
            if (pkgName != null && await packageRepo.existsByName(pkgName)) {
              logDebug('  ✓ Scan: skipping "$pkgName" — already in DB');
              continue;
            }

            result.putIfAbsent(groupName, () => []).add(assetPath);
          }
        }
      } catch (e) {
        logDebug('  ⚠️  Failed to scan $assetPath for group name: $e');
      }
    }

    // Return sorted by group name
    return Map.fromEntries(
      result.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
    );
  }

  /// Import only the seed packages whose group name is in [selectedGroupNames].
  ///
  /// [groupToAssets] is the map returned by [scanSeedPackageGroups].
  /// Progress is reported through [seedingProgress].
  ///
  /// After all selected packages are imported, [markOnboardingComplete] is
  /// called automatically so the app moves to the home screen.
  static Future<void> importSelectedGroups(
    Set<String> selectedGroupNames,
    Map<String, List<String>> groupToAssets,
  ) async {
    // Flatten the selected asset paths.
    final toImport = <String>[];
    for (final groupName in selectedGroupNames) {
      toImport.addAll(groupToAssets[groupName] ?? []);
    }

    if (toImport.isEmpty) {
      await markOnboardingComplete();
      return;
    }

    try {
      final prefs = await SharedPreferences.getInstance();

      // Resume any partially-completed import.
      final doneJson = prefs.getString(_seedProgressKey) ?? '[]';
      final doneSet = Set<String>.from(
        (jsonDecode(doneJson) as List<dynamic>).cast<String>(),
      );

      final total = toImport.length;
      final pending = toImport.where((p) => !doneSet.contains(p)).toList();

      logDebug(
        '🌱 Onboarding import: ${doneSet.length} already done, '
        '${pending.length} pending (total $total)…',
      );

      seedingProgress.value = SeedingProgress(
        current: doneSet.length,
        total: total,
        isActive: true,
      );

      final packageRepo = LanguagePackageRepository();
      final importRepo = ImportExportRepository(
        packageRepo: packageRepo,
        groupRepo: LanguagePackageGroupRepository(),
        categoryRepo: CategoryRepository(),
        itemRepo: ItemRepository(),
      );

      for (final assetPath in pending) {
        try {
          final byteData = await rootBundle.load(assetPath);
          final bytes = byteData.buffer.asUint8List();

          // Req 2: skip if a package with this name already exists in the DB.
          final pkgName = _extractPackageName(bytes);
          if (pkgName != null && await packageRepo.existsByName(pkgName)) {
            logDebug('  ✓ Skipping "$pkgName" — already in DB');
            doneSet.add(assetPath);
            await prefs.setString(
                _seedProgressKey, jsonEncode(doneSet.toList()));
            seedingProgress.value = SeedingProgress(
              current: doneSet.length,
              total: total,
              isActive: true,
            );
            continue;
          }

          final result =
              await importRepo.importPackageFromZipBytesSeeding(bytes);

          doneSet.add(assetPath);
          await prefs.setString(
              _seedProgressKey, jsonEncode(doneSet.toList()));

          logDebug(
            '  ✓ Seeded $assetPath'
            ' — ${result.itemCount} items in group "${result.groupName}"',
          );
        } catch (e) {
          logDebug('  ⚠️  Failed to seed $assetPath: $e');
        }

        seedingProgress.value = SeedingProgress(
          current: doneSet.length,
          total: total,
          isActive: true,
        );
      }

      logDebug(
        '✓ Onboarding import done: ${doneSet.length}/$total packages',
      );
    } catch (e) {
      logDebug('⚠️  Error during onboarding import: $e');
    } finally {
      seedingProgress.value = SeedingProgress(
        current: seedingProgress.value.current,
        total: seedingProgress.value.total,
        isActive: false,
      );
    }

    await markOnboardingComplete();
  }
}
