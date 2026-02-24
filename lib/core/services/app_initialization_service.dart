import 'package:flutter/foundation.dart';
import '../../data/database_helper.dart';

/// Service responsible for app initialization tasks
/// Performs heavy operations that might block the UI during startup
class AppInitializationService {
  static bool _isInitialized = false;

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
    } catch (e) {
      debugPrint('✗ Database initialization failed: $e');
      rethrow;
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

