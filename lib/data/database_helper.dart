// lib/data/database_helper.dart
import 'dart:io';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'database_migrations.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  static bool _isInitialized = false;

  DatabaseHelper._init();

  /// Initialize database factory for desktop platforms
  static void initializeDatabaseFactory() {
    if (_isInitialized) return;
    
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      // Initialize FFI for desktop platforms
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }
    
    _isInitialized = true;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    
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