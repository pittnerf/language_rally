// lib/data/repositories/category_repository.dart
import 'package:sqflite/sqflite.dart';
import '../database_helper.dart';
import '../models/category.dart';

class CategoryRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  // Create
  Future<void> insertCategory(Category category) async {
    final db = await _dbHelper.database;
    await db.insert(
      'categories',
      _categoryToMap(category),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Read
  Future<List<Category>> getCategoriesForPackage(String packageId) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'categories',
      where: 'package_id = ?',
      whereArgs: [packageId],
      orderBy: 'name ASC',
    );
    return maps.map((map) => _mapToCategory(map)).toList();
  }

  Future<Category?> getCategoryById(String id) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'categories',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (maps.isEmpty) return null;
    return _mapToCategory(maps.first);
  }

  Future<List<Category>> getCategoriesByIds(List<String> ids) async {
    if (ids.isEmpty) return [];
    final db = await _dbHelper.database;
    final placeholders = List.filled(ids.length, '?').join(',');
    final maps = await db.query(
      'categories',
      where: 'id IN ($placeholders)',
      whereArgs: ids,
    );
    return maps.map((map) => _mapToCategory(map)).toList();
  }

  // Update
  Future<void> updateCategory(Category category) async {
    final db = await _dbHelper.database;
    await db.update(
      'categories',
      _categoryToMap(category),
      where: 'id = ?',
      whereArgs: [category.id],
    );
  }

  // Delete
  Future<void> deleteCategory(String id) async {
    final db = await _dbHelper.database;
    await db.delete(
      'categories',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Update item count for a category
  Future<int> getItemCount(String categoryId) async {
    final db = await _dbHelper.database;
    final count = Sqflite.firstIntValue(await db.rawQuery(
      'SELECT COUNT(*) FROM item_categories WHERE category_id = ?',
      [categoryId],
    ));
    return count ?? 0;
  }

  // Helper methods
  Map<String, dynamic> _categoryToMap(Category category) {
    return <String, dynamic>{
      'id': category.id,
      'package_id': category.packageId,
      'name': category.name,
      'description': category.description,
    };
  }

  Category _mapToCategory(Map<String, dynamic> map) {
    return Category(
      id: map['id'] as String,
      packageId: map['package_id'] as String,
      name: map['name'] as String,
      description: map['description'] as String?,
    );
  }
}

