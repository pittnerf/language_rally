// lib/data/repositories/language_package_repository.dart
import 'package:sqflite/sqflite.dart';
import '../database_helper.dart';
import '../models/language_package.dart';

class LanguagePackageRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  // Create
  Future<void> insertPackage(LanguagePackage package) async {
    final db = await _dbHelper.database;
    await db.insert(
      'language_packages',
      _packageToMap(package),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Read
  Future<List<LanguagePackage>> getAllPackages() async {
    final db = await _dbHelper.database;
    final maps = await db.query(
        'language_packages', orderBy: 'created_at DESC');
    return maps.map((map) => _mapToPackage(map)).toList();
  }

  Future<List<LanguagePackage>> getPackagesByGroupId(String groupId) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'language_packages',
      where: 'group_id = ?',
      whereArgs: [groupId],
      orderBy: 'created_at DESC',
    );
    return maps.map((map) => _mapToPackage(map)).toList();
  }

  Future<LanguagePackage?> getPackageById(String id) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'language_packages',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return _mapToPackage(maps.first);
  }

  // Update
  Future<void> updatePackage(LanguagePackage package) async {
    final db = await _dbHelper.database;
    await db.update(
      'language_packages',
      _packageToMap(package),
      where: 'id = ?',
      whereArgs: [package.id],
    );
  }

  // Delete
  Future<void> deletePackage(String id) async {
    final db = await _dbHelper.database;
    await db.delete(
      'language_packages',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Delete package with all related data (cascade deletion)
  /// This deletes:
  /// - Package itself
  /// - Categories (and their item associations via FK)
  /// - Training sessions
  /// - Training statistics
  /// - Training settings
  /// Note: Items themselves are preserved but their category associations are removed
  Future<void> deletePackageWithAllData(String id) async {
    final db = await _dbHelper.database;
    await db.transaction((txn) async {
      // Foreign key constraints will cascade delete:
      // - categories (ON DELETE CASCADE)
      // - item_categories (via categories FK)
      // - training_sessions (ON DELETE CASCADE)
      // - training_statistics (ON DELETE CASCADE)
      // - training_settings (ON DELETE CASCADE)

      // Delete the package (cascade will handle related records)
      await txn.delete(
        'language_packages',
        where: 'id = ?',
        whereArgs: [id],
      );
    });
  }

  /// Clear all training counters for a package
  /// Resets dont_know_counter for all items in the package's categories
  /// and resets training statistics
  Future<void> clearPackageCounters(String id) async {
    final db = await _dbHelper.database;
    await db.transaction((txn) async {
      // Get all category IDs for this package
      final categories = await txn.query(
        'categories',
        columns: ['id'],
        where: 'package_id = ?',
        whereArgs: [id],
      );

      final categoryIds = categories.map((c) => c['id'] as String).toList();

      if (categoryIds.isNotEmpty) {
        // Get all item IDs associated with these categories
        final placeholders = List.filled(categoryIds.length, '?').join(',');
        final itemAssociations = await txn.rawQuery('''
          SELECT DISTINCT item_id
          FROM item_categories
          WHERE category_id IN ($placeholders)
        ''', categoryIds);

        final itemIds = itemAssociations.map((row) => row['item_id'] as String).toList();

        // Reset dont_know_counter for all items
        if (itemIds.isNotEmpty) {
          final itemPlaceholders = List.filled(itemIds.length, '?').join(',');
          await txn.rawUpdate('''
            UPDATE items
            SET dont_know_counter = 0
            WHERE id IN ($itemPlaceholders)
          ''', itemIds);
        }
      }

      // Reset training statistics
      await txn.update(
        'training_statistics',
        {
          'total_items_learned': 0,
          'total_items_reviewed': 0,
          'current_streak': 0,
          'longest_streak': 0,
          'average_accuracy': 0.0,
        },
        where: 'package_id = ?',
        whereArgs: [id],
      );
    });
  }

  // Helper methods
  Map<String, dynamic> _packageToMap(LanguagePackage package) {
    return <String, dynamic>{
      'id': package.id,
      'group_id': package.groupId,
      'language_code1': package.languageCode1,
      'language_name1': package.languageName1,
      'language_code2': package.languageCode2,
      'language_name2': package.languageName2,
      'description': package.description,
      'icon': package.icon,
      'author_name': package.authorName,
      'author_email': package.authorEmail,
      'author_webpage': package.authorWebpage,
      'version': package.version,
      'package_type': package.packageType.name,
      'is_purchased': package.isPurchased ? 1 : 0,
      'is_readonly': package.isReadonly ? 1 : 0,
      'is_compact_view': package.isCompactView ? 1 : 0,
      'purchased_at': package.purchasedAt?.millisecondsSinceEpoch,
      'created_at': package.createdAt.millisecondsSinceEpoch,
      'price': package.price,
    };
  }

  LanguagePackage _mapToPackage(Map<String, dynamic> map) {
    return LanguagePackage(
      id: map['id'] as String,
      groupId: map['group_id'] as String,
      languageCode1: map['language_code1'] as String,
      languageName1: map['language_name1'] as String,
      languageCode2: map['language_code2'] as String,
      languageName2: map['language_name2'] as String,
      description: map['description'] as String?,
      icon: map['icon'] as String?, // null = use default dictionary icon
      authorName: map['author_name'] as String?,
      authorEmail: map['author_email'] as String?,
      authorWebpage: map['author_webpage'] as String?,
      version: (map['version'] as String?) ?? '1.0.0',
      packageType: PackageType.values.firstWhere(
        (e) => e.name == map['package_type'],
        orElse: () => PackageType.userCreated,
      ),
      isPurchased: (map['is_purchased'] as int) == 1,
      isReadonly: (map['is_readonly'] as int) == 1,
      isCompactView: (map['is_compact_view'] as int?) == 1,
      purchasedAt: map['purchased_at'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['purchased_at'] as int)
          : null,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
      price: (map['price'] as num).toDouble(),
    );
  }

  // Close database connection
  Future<void> closeDatabase() async {
    await _dbHelper.close();
  }
}