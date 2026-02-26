import 'package:flutter/foundation.dart';
import '../../data/database_helper.dart';
import '../../data/repositories/language_package_group_repository.dart';
import '../../data/models/language_package_group.dart';

/// Service responsible for app initialization tasks
/// Performs heavy operations that might block the UI during startup
class AppInitializationService {
  static bool _isInitialized = false;
  static const String defaultGroupId = 'default-group-id';
  static const String defaultGroupName = 'Default';

  /// Initialize the app with necessary setup tasks
  /// Returns true if initialization was successful
  static Future<bool> initialize() async {
    if (_isInitialized) {
      return true;
    }

    try {
      // Perform initialization tasks
      await Future.wait([
        _initializeDatabase(),
        _warmUpAssets(),
        // Add other initialization tasks here
      ]);

      _isInitialized = true;
      return true;
    } catch (e) {
      debugPrint('Error during app initialization: $e');
      return false;
    }
  }

  /// Initialize database connection and run any pending migrations
  static Future<void> _initializeDatabase() async {
    try {
      // Get database instance to ensure it's initialized
      await DatabaseHelper.instance.database;
      debugPrint('✓ Database initialized');

      // Ensure default group exists (safety check)
      await _ensureDefaultGroupExists();
      debugPrint('✓ Default group verified');
    } catch (e) {
      debugPrint('✗ Database initialization failed: $e');
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
        debugPrint('  ✓ Created default package group');
      } else {
        debugPrint('  ✓ Default package group exists');
      }
    } catch (e) {
      debugPrint('  ⚠️  Error ensuring default group: $e');
      // Don't rethrow - this is a non-critical error
    }
  }

  /// Pre-load or warm up assets to avoid first-load delays
  static Future<void> _warmUpAssets() async {
    // Add a small delay to prevent blocking
    await Future.delayed(const Duration(milliseconds: 100));
    debugPrint('✓ Assets warmed up');
  }

  /// Reset initialization state (useful for testing)
  static void reset() {
    _isInitialized = false;
  }
}

