// lib/data/repositories/language_package_group_repository.dart
import 'package:sqflite/sqflite.dart';
import '../database_helper.dart';
import '../models/language_package_group.dart';

class LanguagePackageGroupRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  // Create
  Future<void> insertGroup(LanguagePackageGroup group) async {
    final db = await _dbHelper.database;
    await db.insert(
      'language_package_groups',
      _groupToMap(group),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Read
  Future<List<LanguagePackageGroup>> getAllGroups() async {
    final db = await _dbHelper.database;
    final maps = await db.query('language_package_groups', orderBy: 'name ASC');
    return maps.map((map) => _mapToGroup(map)).toList();
  }

  Future<LanguagePackageGroup?> getGroupById(String id) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'language_package_groups',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return _mapToGroup(maps.first);
  }

  Future<LanguagePackageGroup?> getGroupByName(String name) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'language_package_groups',
      where: 'name = ?',
      whereArgs: [name],
    );
    if (maps.isEmpty) return null;
    return _mapToGroup(maps.first);
  }

  // Update
  Future<void> updateGroup(LanguagePackageGroup group) async {
    final db = await _dbHelper.database;
    await db.update(
      'language_package_groups',
      _groupToMap(group),
      where: 'id = ?',
      whereArgs: [group.id],
    );
  }

  // Delete
  Future<void> deleteGroup(String id) async {
    final db = await _dbHelper.database;
    await db.delete(
      'language_package_groups',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Helper methods
  Map<String, dynamic> _groupToMap(LanguagePackageGroup group) {
    return <String, dynamic>{
      'id': group.id,
      'name': group.name,
    };
  }

  LanguagePackageGroup _mapToGroup(Map<String, dynamic> map) {
    return LanguagePackageGroup(
      id: map['id'] as String,
      name: map['name'] as String,
    );
  }

  // Close database connection
  Future<void> closeDatabase() async {
    await _dbHelper.close();
  }
}

