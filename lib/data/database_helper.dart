// lib/data/database_helper.dart
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'database_migrations.dart';
import '../core/utils/debug_print.dart';

// Import this to ensure SQLite native libraries are bundled

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  static bool _isInitialized = false;

  DatabaseHelper._init();

  /// Initialize database factory for desktop platforms
  static void initializeDatabaseFactory() {
    if (_isInitialized) return;
    
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      // The sqlite3_flutter_libs package will automatically handle
      // finding and loading the correct native library for the platform

      // Initialize FFI for desktop platforms
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }
    
    _isInitialized = true;
  }

  Future<Database> get database async {
    // Check if existing connection is still valid
    if (_database != null) {
      try {
        // Test the connection with a simple query
        await _database!.rawQuery('SELECT 1');
        return _database!;
      } catch (e) {
        // Connection is stale, close it and create a new one
        logDebug('Database connection is stale, recreating: $e');
        try {
          await _database!.close();
        } catch (_) {
          // Ignore errors when closing stale connection
        }
        _database = null;
      }
    }

    // Ensure database factory is initialized for desktop
    initializeDatabaseFactory();
    
    _database = await _initDB('language_rally.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    String dbPath;
    
    // Use different path strategies for mobile vs desktop
    if (Platform.isAndroid || Platform.isIOS) {
      dbPath = await getDatabasesPath();
    } else {
      // For desktop platforms, use application documents directory
      final appDocDir = await getApplicationDocumentsDirectory();
      dbPath = join(appDocDir.path, 'language_rally_db');
      // Create directory if it doesn't exist
      await Directory(dbPath).create(recursive: true);
    }
    
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: DatabaseMigrations.currentVersion,
      onCreate: DatabaseMigrations.createDatabase,
      onUpgrade: DatabaseMigrations.upgradeDatabase,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
    );
  }


  Future close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }
}