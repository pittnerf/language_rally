// test/database_migration_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:language_rally/data/database_migrations.dart';

void main() {
  // Initialize FFI for testing
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  test('Migration from version 1 to 2 adds is_compact_view column', () async {
    // Use a temporary file path instead of in-memory for persistence
    final dbPath = '${inMemoryDatabasePath}_migration_test.db';

    // Delete existing test database if any
    try {
      await databaseFactory.deleteDatabase(dbPath);
    } catch (_) {}

    // Create a database at version 1
    final db = await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
        // Create version 1 schema (without is_compact_view)
        await db.execute('''
          CREATE TABLE language_packages (
            id TEXT PRIMARY KEY,
            language_code1 TEXT NOT NULL,
            language_name1 TEXT NOT NULL,
            language_code2 TEXT NOT NULL,
            language_name2 TEXT NOT NULL,
            description TEXT,
            icon TEXT,
            author_name TEXT,
            author_email TEXT,
            author_webpage TEXT,
            version TEXT DEFAULT '1.0.0',
            package_type TEXT NOT NULL,
            is_purchased INTEGER NOT NULL,
            is_readonly INTEGER NOT NULL,
            purchased_at INTEGER,
            created_at INTEGER NOT NULL,
            price REAL NOT NULL
          )
        ''');
      },
    );

    // Insert test data at version 1
    await db.insert('language_packages', {
      'id': 'test-package-1',
      'language_code1': 'en',
      'language_name1': 'English',
      'language_code2': 'de',
      'language_name2': 'German',
      'description': 'Test package',
      'package_type': 'userCreated',
      'is_purchased': 0,
      'is_readonly': 0,
      'created_at': DateTime.now().millisecondsSinceEpoch,
      'price': 0.0,
    });

    // Verify data was inserted
    var result = await db.query('language_packages');
    expect(result.length, 1);
    expect(result.first['id'], 'test-package-1');

    // Check that is_compact_view doesn't exist yet
    expect(result.first.containsKey('is_compact_view'), false);

    await db.close();

    // Reopen database with version 2 (triggers migration)
    final db2 = await openDatabase(
      dbPath,
      version: 2,
      onCreate: DatabaseMigrations.createDatabase,
      onUpgrade: DatabaseMigrations.upgradeDatabase,
    );

    // Verify the column was added with migration
    result = await db2.query('language_packages');
    expect(result.length, 1);
    expect(result.first.containsKey('is_compact_view'), true);
    expect(result.first['is_compact_view'], 0); // Default value

    await db2.close();

    // Cleanup
    await databaseFactory.deleteDatabase(dbPath);
  });

  test('Creating new database starts at current version', () async {
    final db = await openDatabase(
      inMemoryDatabasePath,
      version: DatabaseMigrations.currentVersion,
      onCreate: DatabaseMigrations.createDatabase,
    );

    // Verify the database has the is_compact_view column from the start
    // First create a default group
    await db.insert('language_package_groups', {
      'id': 'default-group-id',
      'name': 'Default',
    });

    await db.insert('language_packages', {
      'id': 'test-package-2',
      'group_id': 'default-group-id',
      'language_code1': 'en',
      'language_name1': 'English',
      'language_code2': 'fr',
      'language_name2': 'French',
      'description': 'Test package',
      'package_type': 'userCreated',
      'is_purchased': 0,
      'is_readonly': 0,
      'is_compact_view': 1, // Can set the new column
      'created_at': DateTime.now().millisecondsSinceEpoch,
      'price': 0.0,
    });

    final result = await db.query('language_packages');
    expect(result.first['is_compact_view'], 1);
    expect(result.first['group_id'], 'default-group-id');

    await db.close();
  });

  test('Verify current version is 4', () {
    expect(DatabaseMigrations.currentVersion, 4);
  });

  test('Migration map contains all versions', () {
    expect(DatabaseMigrations.migrations.containsKey(2), true);
    expect(DatabaseMigrations.migrations.containsKey(3), true);
    expect(DatabaseMigrations.migrations.containsKey(4), true);
  });
}

