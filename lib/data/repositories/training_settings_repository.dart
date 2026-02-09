// lib/data/repositories/training_settings_repository.dart
import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import '../database_helper.dart';
import '../models/training_settings.dart';

class TrainingSettingsRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  // Save or update settings for a package
  Future<void> saveSettings(TrainingSettings settings) async {
    final db = await _dbHelper.database;
    await db.insert(
      'training_settings',
      _settingsToMap(settings),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get settings for a package
  Future<TrainingSettings?> getSettingsForPackage(String packageId) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'training_settings',
      where: 'package_id = ?',
      whereArgs: [packageId],
      limit: 1,
    );
    if (maps.isEmpty) return null;
    return _mapToSettings(maps.first);
  }

  // Get settings or create default for a package
  Future<TrainingSettings> getOrCreateSettings(String packageId) async {
    final existing = await getSettingsForPackage(packageId);
    if (existing != null) return existing;

    // Create default settings
    final defaultSettings = TrainingSettings(packageId: packageId);
    await saveSettings(defaultSettings);
    return defaultSettings;
  }

  // Update specific setting field
  Future<void> updateItemScope(String packageId, ItemScope scope) async {
    final db = await _dbHelper.database;
    await db.update(
      'training_settings',
      {'item_scope': scope.name},
      where: 'package_id = ?',
      whereArgs: [packageId],
    );
  }

  Future<void> updateDisplayLanguage(String packageId, DisplayLanguage language) async {
    final db = await _dbHelper.database;
    await db.update(
      'training_settings',
      {'display_language': language.name},
      where: 'package_id = ?',
      whereArgs: [packageId],
    );
  }

  Future<void> updateSelectedCategories(String packageId, List<String> categoryIds) async {
    final db = await _dbHelper.database;
    await db.update(
      'training_settings',
      {'selected_category_ids': jsonEncode(categoryIds)},
      where: 'package_id = ?',
      whereArgs: [packageId],
    );
  }

  // Delete settings for a package
  Future<void> deleteSettings(String packageId) async {
    final db = await _dbHelper.database;
    await db.delete(
      'training_settings',
      where: 'package_id = ?',
      whereArgs: [packageId],
    );
  }

  // Helper methods
  Map<String, dynamic> _settingsToMap(TrainingSettings settings) {
    return <String, dynamic>{
      'package_id': settings.packageId,
      'item_scope': settings.itemScope.name,
      'last_n_items': settings.lastNItems,
      'item_order': settings.itemOrder.name,
      'display_language': settings.displayLanguage.name,
      'selected_category_ids': jsonEncode(settings.selectedCategoryIds),
      'dont_know_threshold': settings.dontKnowThreshold,
    };
  }

  TrainingSettings _mapToSettings(Map<String, dynamic> map) {
    return TrainingSettings(
      packageId: map['package_id'] as String,
      itemScope: ItemScope.values.firstWhere(
        (e) => e.name == map['item_scope'],
        orElse: () => ItemScope.all,
      ),
      lastNItems: map['last_n_items'] as int,
      itemOrder: ItemOrder.values.firstWhere(
        (e) => e.name == map['item_order'],
        orElse: () => ItemOrder.random,
      ),
      displayLanguage: DisplayLanguage.values.firstWhere(
        (e) => e.name == map['display_language'],
        orElse: () => DisplayLanguage.random,
      ),
      selectedCategoryIds: map['selected_category_ids'] != null
          ? List<String>.from(jsonDecode(map['selected_category_ids'] as String))
          : [],
      dontKnowThreshold: map['dont_know_threshold'] as int,
    );
  }
}

