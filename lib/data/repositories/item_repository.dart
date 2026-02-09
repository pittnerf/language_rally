// lib/data/repositories/item_repository.dart
import 'package:sqflite/sqflite.dart';
import '../database_helper.dart';
import '../models/item.dart';
import '../models/item_language_data.dart';
import '../models/example_sentence.dart';

class ItemRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  // Create
  Future<void> insertItem(Item item) async {
    final db = await _dbHelper.database;
    await db.transaction((txn) async {
      // Insert main item
      await txn.insert(
        'items',
        _itemToMap(item),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      // Insert language data for language 1
      await txn.insert(
        'item_language_data',
        _languageDataToMap(item.id, item.language1Data, 1),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      // Insert language data for language 2
      await txn.insert(
        'item_language_data',
        _languageDataToMap(item.id, item.language2Data, 2),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      // Insert examples (belong to item, contain both languages)
      await txn.delete('example_sentences', where: 'item_id = ?', whereArgs: [item.id]);
      for (final example in item.examples) {
        await txn.insert(
          'example_sentences',
          _exampleToMap(item.id, example),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      // Insert category associations
      await txn.delete('item_categories', where: 'item_id = ?', whereArgs: [item.id]);
      for (final categoryId in item.categoryIds) {
        await txn.insert(
          'item_categories',
          {'item_id': item.id, 'category_id': categoryId},
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    });
  }

  // Read
  Future<List<Item>> getItemsForPackage(String packageId) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'items',
      where: 'package_id = ?',
      whereArgs: [packageId],
    );
    return Future.wait(maps.map((map) => _mapToItem(map)));
  }

  Future<List<Item>> getItemsForCategories(List<String> categoryIds) async {
    if (categoryIds.isEmpty) return [];
    final db = await _dbHelper.database;

    final placeholders = List.filled(categoryIds.length, '?').join(',');
    final maps = await db.rawQuery('''
      SELECT DISTINCT i.*
      FROM items i
      INNER JOIN item_categories ic ON i.id = ic.item_id
      WHERE ic.category_id IN ($placeholders)
    ''', categoryIds);

    return Future.wait(maps.map((map) => _mapToItem(map)));
  }

  Future<List<Item>> getAllItems() async {
    final db = await _dbHelper.database;
    final maps = await db.query('items');
    return Future.wait(maps.map((map) => _mapToItem(map)));
  }

  Future<Item?> getItemById(String id) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'items',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (maps.isEmpty) return null;
    return _mapToItem(maps.first);
  }

  // Search and filter
  Future<List<Item>> searchItems({
    String? searchText,
    List<String>? categoryIds,
    bool? isKnown,
    bool? isFavourite,
    bool? isImportant,
  }) async {
    final db = await _dbHelper.database;
    final conditions = <String>[];
    final args = <dynamic>[];

    if (isKnown != null) {
      conditions.add('i.is_known = ?');
      args.add(isKnown ? 1 : 0);
    }

    if (isFavourite != null) {
      conditions.add('i.is_favourite = ?');
      args.add(isFavourite ? 1 : 0);
    }

    if (isImportant != null) {
      conditions.add('i.is_important = ?');
      args.add(isImportant ? 1 : 0);
    }

    String query = 'SELECT DISTINCT i.* FROM items i';

    if (categoryIds != null && categoryIds.isNotEmpty) {
      query += ' INNER JOIN item_categories ic ON i.id = ic.item_id';
      final placeholders = List.filled(categoryIds.length, '?').join(',');
      conditions.add('ic.category_id IN ($placeholders)');
      args.addAll(categoryIds);
    }

    if (searchText != null && searchText.isNotEmpty) {
      query += ' LEFT JOIN item_language_data ild ON i.id = ild.item_id';
      conditions.add('(ild.text LIKE ? OR ild.pre_item LIKE ? OR ild.post_item LIKE ?)');
      final searchPattern = '%$searchText%';
      args.addAll([searchPattern, searchPattern, searchPattern]);
    }

    if (conditions.isNotEmpty) {
      query += ' WHERE ${conditions.join(' AND ')}';
    }

    final maps = await db.rawQuery(query, args);
    return Future.wait(maps.map((map) => _mapToItem(map)));
  }

  // Update
  Future<void> updateItem(Item item) async {
    await insertItem(item); // Use insert with REPLACE conflict resolution
  }

  Future<void> markItemAsKnown(String itemId, bool isKnown) async {
    final db = await _dbHelper.database;
    await db.update(
      'items',
      {'is_known': isKnown ? 1 : 0},
      where: 'id = ?',
      whereArgs: [itemId],
    );
  }

  Future<void> incrementDontKnowCounter(String itemId) async {
    final db = await _dbHelper.database;
    await db.rawUpdate(
      'UPDATE items SET dont_know_counter = dont_know_counter + 1 WHERE id = ?',
      [itemId],
    );
  }

  Future<void> resetDontKnowCounters(List<String> categoryIds) async {
    if (categoryIds.isEmpty) return;
    final db = await _dbHelper.database;

    final placeholders = List.filled(categoryIds.length, '?').join(',');
    await db.rawUpdate('''
      UPDATE items
      SET dont_know_counter = 0
      WHERE id IN (
        SELECT DISTINCT item_id
        FROM item_categories
        WHERE category_id IN ($placeholders)
      )
    ''', categoryIds);
  }

  // Delete
  Future<void> deleteItem(String id) async {
    final db = await _dbHelper.database;
    await db.delete('items', where: 'id = ?', whereArgs: [id]);
  }

  // Helper methods
  Map<String, dynamic> _itemToMap(Item item) {
    return <String, dynamic>{
      'id': item.id,
      'package_id': item.packageId,
      'is_known': item.isKnown ? 1 : 0,
      'is_favourite': item.isFavourite ? 1 : 0,
      'is_important': item.isImportant ? 1 : 0,
      'dont_know_counter': item.dontKnowCounter,
      'last_reviewed_at': item.lastReviewedAt?.millisecondsSinceEpoch,
    };
  }

  Map<String, dynamic> _languageDataToMap(
    String itemId,
    ItemLanguageData data,
    int languageNumber,
  ) {
    return <String, dynamic>{
      'id': '${itemId}_lang$languageNumber',
      'item_id': itemId,
      'language_code': data.languageCode,
      'language_number': languageNumber,
      'text': data.text,
      'pre_item': data.preItem,
      'post_item': data.postItem,
    };
  }

  Map<String, dynamic> _exampleToMap(String itemId, ExampleSentence example) {
    return <String, dynamic>{
      'id': example.id,
      'item_id': itemId,
      'text_language1': example.textLanguage1,
      'text_language2': example.textLanguage2,
    };
  }

  Future<Item> _mapToItem(Map<String, dynamic> map) async {
    final db = await _dbHelper.database;
    final itemId = map['id'] as String;

    // Get category IDs
    final categoryMaps = await db.query(
      'item_categories',
      where: 'item_id = ?',
      whereArgs: [itemId],
    );
    final categoryIds = categoryMaps.map((m) => m['category_id'] as String).toList();

    // Get language data
    final langDataMaps = await db.query(
      'item_language_data',
      where: 'item_id = ?',
      whereArgs: [itemId],
      orderBy: 'language_number ASC',
    );

    ItemLanguageData? lang1Data;
    ItemLanguageData? lang2Data;

    for (final langMap in langDataMaps) {
      final langData = ItemLanguageData(
        languageCode: langMap['language_code'] as String,
        text: langMap['text'] as String,
        preItem: langMap['pre_item'] as String?,
        postItem: langMap['post_item'] as String?,
      );

      if ((langMap['language_number'] as int) == 1) {
        lang1Data = langData;
      } else {
        lang2Data = langData;
      }
    }

    // Get examples (belong to item, not language data)
    final examples = await _getExamplesForItem(itemId);

    return Item(
      id: itemId,
      packageId: map['package_id'] as String,
      categoryIds: categoryIds,
      language1Data: lang1Data ?? ItemLanguageData(languageCode: '', text: ''),
      language2Data: lang2Data ?? ItemLanguageData(languageCode: '', text: ''),
      examples: examples,
      isKnown: (map['is_known'] as int) == 1,
      isFavourite: (map['is_favourite'] as int) == 1,
      isImportant: (map['is_important'] as int) == 1,
      dontKnowCounter: map['dont_know_counter'] as int,
      lastReviewedAt: map['last_reviewed_at'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['last_reviewed_at'] as int)
          : null,
    );
  }

  Future<List<ExampleSentence>> _getExamplesForItem(String itemId) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'example_sentences',
      where: 'item_id = ?',
      whereArgs: [itemId],
    );

    return maps.map((map) => ExampleSentence(
      id: map['id'] as String,
      textLanguage1: map['text_language1'] as String,
      textLanguage2: map['text_language2'] as String,
    )).toList();
  }
}

