// lib/data/database_migrations.dart
import 'dart:developer' as developer;
import 'package:sqflite/sqflite.dart';

/// Database migration manager
///
/// Add new migrations to the [migrations] map when you need to change the database schema.
/// The key is the version number (starting from 2), and the value is the migration function.
///
/// Example:
/// ```dart
/// 3: (db) async {
///   await db.execute('ALTER TABLE my_table ADD COLUMN new_field TEXT');
/// },
/// ```
class DatabaseMigrations {
  /// Current database version
  /// Increment this when adding a new migration
  static const int currentVersion = 4;

  /// Type definitions for database types
  static const idType = 'TEXT PRIMARY KEY';
  static const textType = 'TEXT NOT NULL';
  static const textNullable = 'TEXT';
  static const boolType = 'INTEGER NOT NULL';
  static const intType = 'INTEGER NOT NULL';
  static const intNullable = 'INTEGER';
  static const realType = 'REAL NOT NULL';

  /// Migration functions mapped by target version
  /// Each function upgrades from the previous version to the specified version
  static final Map<int, Future<void> Function(Database)> migrations = {
    // Version 1 -> 2: Add is_compact_view column to language_packages
    2: _migrateToVersion2,

    // Version 2 -> 3: Add package_id column to items table
    3: _migrateToVersion3,

    // Version 3 -> 4: Add language_package_groups table and group_id to language_packages
    4: _migrateToVersion4,

    // Add future migrations here:
    // 5: _migrateToVersion5,
  };

  /// Initial database creation (version 1)
  static Future<void> createDatabase(Database db, int version) async {
    // Language Package Groups table
    await db.execute('''
      CREATE TABLE language_package_groups (
        id $idType,
        name $textType
      )
    ''');

    // Language Packages table
    await db.execute('''
      CREATE TABLE language_packages (
        id $idType,
        group_id $textType,
        language_code1 $textType,
        language_name1 $textType,
        language_code2 $textType,
        language_name2 $textType,
        description $textNullable,
        icon $textNullable,
        author_name $textNullable,
        author_email $textNullable,
        author_webpage $textNullable,
        version $textType DEFAULT '1.0.0',
        package_type $textType,
        is_purchased $boolType,
        is_readonly $boolType,
        is_compact_view $boolType DEFAULT 0,
        purchased_at $intNullable,
        created_at $intType,
        price $realType,
        FOREIGN KEY (group_id) REFERENCES language_package_groups (id) ON DELETE RESTRICT
      )
    ''');

    // Categories table
    await db.execute('''
      CREATE TABLE categories (
        id $idType,
        package_id $textType,
        name $textType,
        description $textNullable,
        FOREIGN KEY (package_id) REFERENCES language_packages (id) ON DELETE CASCADE
      )
    ''');

    // Items table
    await db.execute('''
      CREATE TABLE items (
        id $idType,
        package_id $textType,
        is_known $boolType,
        is_favourite $boolType,
        is_important $boolType,
        dont_know_counter $intType,
        last_reviewed_at $intNullable,
        FOREIGN KEY (package_id) REFERENCES language_packages (id) ON DELETE CASCADE
      )
    ''');

    // Item Categories junction table (many-to-many)
    await db.execute('''
      CREATE TABLE item_categories (
        item_id $textType,
        category_id $textType,
        PRIMARY KEY (item_id, category_id),
        FOREIGN KEY (item_id) REFERENCES items (id) ON DELETE CASCADE,
        FOREIGN KEY (category_id) REFERENCES categories (id) ON DELETE CASCADE
      )
    ''');

    // Item Language Data table
    await db.execute('''
      CREATE TABLE item_language_data (
        id $idType,
        item_id $textType,
        language_code $textType,
        language_number $intType,
        text $textType,
        pre_item $textNullable,
        post_item $textNullable,
        FOREIGN KEY (item_id) REFERENCES items (id) ON DELETE CASCADE
      )
    ''');

    // Example Sentences table
    await db.execute('''
      CREATE TABLE example_sentences (
        id $idType,
        item_id $textType,
        text_language1 $textType,
        text_language2 $textType,
        FOREIGN KEY (item_id) REFERENCES items (id) ON DELETE CASCADE
      )
    ''');

    // Training Settings table
    await db.execute('''
      CREATE TABLE training_settings (
        package_id $idType,
        item_scope $textType,
        last_n_items $intType,
        item_order $textType,
        display_language $textType,
        selected_category_ids $textNullable,
        dont_know_threshold $intType,
        FOREIGN KEY (package_id) REFERENCES language_packages (id) ON DELETE CASCADE
      )
    ''');

    // Training Sessions table
    await db.execute('''
      CREATE TABLE training_sessions (
        id $idType,
        package_id $textType,
        settings $textType,
        item_ids $textType,
        item_outcomes $textNullable,
        historical_accuracy_ratios $textNullable,
        badge_events $textNullable,
        current_item_index $intType,
        correct_answers $intType,
        total_answers $intType,
        started_at $intType,
        completed_at $intNullable,
        status $textType,
        FOREIGN KEY (package_id) REFERENCES language_packages (id) ON DELETE CASCADE
      )
    ''');

    // Training Statistics table
    await db.execute('''
      CREATE TABLE training_statistics (
        package_id $idType,
        total_items_learned $intType,
        total_items_reviewed $intType,
        current_streak $intType,
        longest_streak $intType,
        last_trained_at $intType,
        average_accuracy $realType,
        FOREIGN KEY (package_id) REFERENCES language_packages (id) ON DELETE CASCADE
      )
    ''');

    // Create indexes for better performance
    await db.execute('CREATE INDEX idx_categories_package ON categories(package_id)');
    await db.execute('CREATE INDEX idx_item_categories_item ON item_categories(item_id)');
    await db.execute('CREATE INDEX idx_item_categories_category ON item_categories(category_id)');
    await db.execute('CREATE INDEX idx_item_language_data_item ON item_language_data(item_id)');
    await db.execute('CREATE INDEX idx_example_sentences_item ON example_sentences(item_id)');
    await db.execute('CREATE INDEX idx_training_sessions_package ON training_sessions(package_id)');
    await db.execute('CREATE INDEX idx_items_known ON items(is_known)');
    await db.execute('CREATE INDEX idx_items_favourite ON items(is_favourite)');
    await db.execute('CREATE INDEX idx_items_important ON items(is_important)');
  }

  /// Upgrade database from oldVersion to newVersion
  static Future<void> upgradeDatabase(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    developer.log('📦 Upgrading database from version $oldVersion to $newVersion', name: 'DatabaseMigrations');

    // Run each migration in sequence
    for (int version = oldVersion + 1; version <= newVersion; version++) {
      final migration = migrations[version];
      if (migration != null) {
        developer.log('  🔄 Running migration to version $version...', name: 'DatabaseMigrations');
        await migration(db);
        developer.log('  ✅ Migration to version $version completed', name: 'DatabaseMigrations');
      } else {
        developer.log('  ⚠️  No migration defined for version $version', name: 'DatabaseMigrations');
      }
    }

    developer.log('✅ Database upgrade completed successfully', name: 'DatabaseMigrations');
  }

  // ============================================================================
  // Migration Functions
  // ============================================================================

  /// Migration to version 2: Add is_compact_view column
  static Future<void> _migrateToVersion2(Database db) async {
    // Check if column already exists
    final result = await db.rawQuery('PRAGMA table_info(language_packages)');
    final columnExists = result.any((column) => column['name'] == 'is_compact_view');

    if (!columnExists) {
      // Add is_compact_view column to language_packages table
      await db.execute('''
        ALTER TABLE language_packages 
        ADD COLUMN is_compact_view $boolType DEFAULT 0
      ''');
      developer.log('  ✓ Added is_compact_view column', name: 'DatabaseMigrations');
    } else {
      developer.log('  ⚠️  Column is_compact_view already exists, skipping', name: 'DatabaseMigrations');
    }
  }

  /// Migration to version 3: Add package_id column to items table
  static Future<void> _migrateToVersion3(Database db) async {
    // Check if column already exists
    final result = await db.rawQuery('PRAGMA table_info(items)');
    final columnExists = result.any((column) => column['name'] == 'package_id');

    if (!columnExists) {
      developer.log('  ℹ️  Adding package_id column to items table...', name: 'DatabaseMigrations');

      // Step 1: Add the column without NOT NULL constraint first
      await db.execute('''
        ALTER TABLE items 
        ADD COLUMN package_id TEXT
      ''');

      // Step 2: Populate package_id from categories via item_categories junction table
      // For each item, find its categories and get the package_id from any of them
      await db.execute('''
        UPDATE items 
        SET package_id = (
          SELECT c.package_id 
          FROM item_categories ic
          JOIN categories c ON ic.category_id = c.id
          WHERE ic.item_id = items.id
          LIMIT 1
        )
      ''');

      // Step 3: Delete any items that couldn't be linked (orphaned items with no categories)
      await db.execute('''
        DELETE FROM items WHERE package_id IS NULL
      ''');

      developer.log('  ✓ Added package_id column and populated from categories', name: 'DatabaseMigrations');
    } else {
      developer.log('  ⚠️  Column package_id already exists, skipping', name: 'DatabaseMigrations');
    }
  }

  // Add future migration functions here:

  /// Migration to version 4: Add language_package_groups table and group_id to language_packages
  static Future<void> _migrateToVersion4(Database db) async {
    developer.log('  ℹ️  Adding language_package_groups table and updating language_packages...', name: 'DatabaseMigrations');

    // Step 1: Create language_package_groups table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS language_package_groups (
        id $idType,
        name $textType
      )
    ''');
    developer.log('  ✓ Created language_package_groups table', name: 'DatabaseMigrations');

    // Step 2: Create default group
    const defaultGroupId = 'default-group-id';
    const defaultGroupName = 'Default';

    // Check if default group already exists
    final existingGroups = await db.query(
      'language_package_groups',
      where: 'id = ?',
      whereArgs: [defaultGroupId],
    );

    if (existingGroups.isEmpty) {
      await db.insert('language_package_groups', {
        'id': defaultGroupId,
        'name': defaultGroupName,
      });
      developer.log('  ✓ Created default package group', name: 'DatabaseMigrations');
    } else {
      developer.log('  ⚠️  Default package group already exists', name: 'DatabaseMigrations');
    }

    // Step 3: Check if group_id column already exists in language_packages
    final result = await db.rawQuery('PRAGMA table_info(language_packages)');
    final columnExists = result.any((column) => column['name'] == 'group_id');

    if (!columnExists) {
      // Step 4: Add group_id column to language_packages
      await db.execute('''
        ALTER TABLE language_packages 
        ADD COLUMN group_id TEXT
      ''');
      developer.log('  ✓ Added group_id column to language_packages', name: 'DatabaseMigrations');

      // Step 5: Update all existing packages to use the default group
      await db.execute('''
        UPDATE language_packages 
        SET group_id = ?
      ''', [defaultGroupId]);
      developer.log('  ✓ Assigned all existing packages to default group', name: 'DatabaseMigrations');
    } else {
      developer.log('  ⚠️  Column group_id already exists in language_packages, skipping', name: 'DatabaseMigrations');
    }
  }

  // /// Migration to version 5: Example future migration
  // static Future<void> _migrateToVersion5(Database db) async {
  //   // Your migration logic here
  //   await db.execute('ALTER TABLE some_table ADD COLUMN new_field TEXT');
  // }
}




