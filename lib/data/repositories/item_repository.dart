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
  Future<int> getItemCountForPackage(String packageId) async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM items WHERE package_id = ?',
      [packageId],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<List<Item>> getItemsForPackage(String packageId) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'items',
      where: 'package_id = ?',
      whereArgs: [packageId],
    );
    return _mapItemsFromMaps(maps);
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

    return _mapItemsFromMaps(maps);
  }

  Future<List<Item>> getAllItems() async {
    final db = await _dbHelper.database;
    final maps = await db.query('items');
    return _mapItemsFromMaps(maps);
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
    return (await _mapItemsFromMaps(maps)).first;
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
    return _mapItemsFromMaps(maps);
  }

  /// Insert an item within an already-open [DatabaseExecutor] (e.g. a
  /// caller-owned [Transaction]).  Unlike [insertItem] this does NOT start its
  /// own inner transaction, so many items can be batched inside one outer
  /// `db.transaction()` call for maximum write throughput.
  Future<void> insertItemInTransaction(DatabaseExecutor txn, Item item) async {
    await txn.insert('items', _itemToMap(item),
        conflictAlgorithm: ConflictAlgorithm.replace);
    await txn.insert(
        'item_language_data', _languageDataToMap(item.id, item.language1Data, 1),
        conflictAlgorithm: ConflictAlgorithm.replace);
    await txn.insert(
        'item_language_data', _languageDataToMap(item.id, item.language2Data, 2),
        conflictAlgorithm: ConflictAlgorithm.replace);
    for (final example in item.examples) {
      await txn.insert(
          'example_sentences', _exampleToMap(item.id, example),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
    for (final categoryId in item.categoryIds) {
      await txn.insert(
          'item_categories', {'item_id': item.id, 'category_id': categoryId},
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  /// Bulk variant of [insertItemInTransaction] optimized for large imports.
  ///
  /// Items are written in chunks via [Batch] to minimize platform-channel
  /// roundtrips while still running inside the caller-owned transaction.
  Future<void> insertItemsBulkInTransaction(
    DatabaseExecutor txn,
    List<Item> items, {
    int chunkSize = 100,
    void Function(int insertedCount)? onProgress,
  }) async {
    if (items.isEmpty) return;
    final safeChunkSize = chunkSize <= 0 ? 100 : chunkSize;
    var inserted = 0;

    for (var start = 0; start < items.length; start += safeChunkSize) {
      final end = start + safeChunkSize > items.length
          ? items.length
          : start + safeChunkSize;
      final chunk = items.sublist(start, end);

      final batch = txn.batch();
      for (final item in chunk) {
        batch.insert(
          'items',
          _itemToMap(item),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        batch.insert(
          'item_language_data',
          _languageDataToMap(item.id, item.language1Data, 1),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        batch.insert(
          'item_language_data',
          _languageDataToMap(item.id, item.language2Data, 2),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        for (final example in item.examples) {
          batch.insert(
            'example_sentences',
            _exampleToMap(item.id, example),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
        for (final categoryId in item.categoryIds) {
          batch.insert(
            'item_categories',
            {'item_id': item.id, 'category_id': categoryId},
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
      }

      await batch.commit(noResult: true, continueOnError: false);
      inserted += chunk.length;
      onProgress?.call(inserted);
    }
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

  Future<List<Item>> _mapItemsFromMaps(List<Map<String, dynamic>> maps) async {
    final db = await _dbHelper.database;
    if (maps.isEmpty) return [];

    final itemIds = maps.map((map) => map['id'] as String).toList();

    final categoryIdsByItem = await _loadCategoryIdsByItemIds(db, itemIds);
    final languageDataByItem = await _loadLanguageDataByItemIds(db, itemIds);
    final examplesByItem = await _loadExamplesByItemIds(db, itemIds);

    return maps.map((map) {
      final itemId = map['id'] as String;
      final langData = languageDataByItem[itemId] ?? const <int, ItemLanguageData>{};
      final lang1Data = langData[1];
      final lang2Data = langData[2];

      return Item(
        id: itemId,
        packageId: map['package_id'] as String,
        categoryIds: categoryIdsByItem[itemId] ?? const [],
        language1Data: lang1Data ?? ItemLanguageData(languageCode: '', text: ''),
        language2Data: lang2Data ?? ItemLanguageData(languageCode: '', text: ''),
        examples: examplesByItem[itemId] ?? const [],
        isKnown: (map['is_known'] as int) == 1,
        isFavourite: (map['is_favourite'] as int) == 1,
        isImportant: (map['is_important'] as int) == 1,
        dontKnowCounter: map['dont_know_counter'] as int,
        lastReviewedAt: map['last_reviewed_at'] != null
            ? DateTime.fromMillisecondsSinceEpoch(map['last_reviewed_at'] as int)
            : null,
      );
    }).toList();
  }

  Future<Map<String, List<String>>> _loadCategoryIdsByItemIds(
    Database db,
    List<String> itemIds,
  ) async {
    final rows = await _queryRowsByItemIds(
      db,
      table: 'item_categories',
      itemColumn: 'item_id',
      itemIds: itemIds,
      columns: const ['item_id', 'category_id'],
    );

    final result = <String, List<String>>{};
    for (final row in rows) {
      final itemId = row['item_id'] as String;
      final categoryId = row['category_id'] as String;
      result.putIfAbsent(itemId, () => []).add(categoryId);
    }
    return result;
  }

  Future<Map<String, Map<int, ItemLanguageData>>> _loadLanguageDataByItemIds(
    Database db,
    List<String> itemIds,
  ) async {
    final rows = await _queryRowsByItemIds(
      db,
      table: 'item_language_data',
      itemColumn: 'item_id',
      itemIds: itemIds,
      columns: const [
        'item_id',
        'language_code',
        'language_number',
        'text',
        'pre_item',
        'post_item',
      ],
      orderBy: 'item_id ASC, language_number ASC',
    );

    final result = <String, Map<int, ItemLanguageData>>{};
    for (final row in rows) {
      final itemId = row['item_id'] as String;
      final languageNumber = row['language_number'] as int;
      final langData = ItemLanguageData(
        languageCode: row['language_code'] as String,
        text: row['text'] as String,
        preItem: row['pre_item'] as String?,
        postItem: row['post_item'] as String?,
      );
      result.putIfAbsent(itemId, () => <int, ItemLanguageData>{})[languageNumber] = langData;
    }
    return result;
  }

  Future<Map<String, List<ExampleSentence>>> _loadExamplesByItemIds(
    Database db,
    List<String> itemIds,
  ) async {
    final rows = await _queryRowsByItemIds(
      db,
      table: 'example_sentences',
      itemColumn: 'item_id',
      itemIds: itemIds,
      columns: const ['id', 'item_id', 'text_language1', 'text_language2'],
      orderBy: 'item_id ASC',
    );

    final result = <String, List<ExampleSentence>>{};
    for (final row in rows) {
      final itemId = row['item_id'] as String;
      result.putIfAbsent(itemId, () => []).add(
        ExampleSentence(
          id: row['id'] as String,
          textLanguage1: row['text_language1'] as String,
          textLanguage2: row['text_language2'] as String,
        ),
      );
    }
    return result;
  }

  Future<List<Map<String, Object?>>> _queryRowsByItemIds(
    Database db, {
    required String table,
    required String itemColumn,
    required List<String> itemIds,
    required List<String> columns,
    String? orderBy,
  }) async {
    if (itemIds.isEmpty) return [];

    const chunkSize = 500;
    final rows = <Map<String, Object?>>[];

    for (var start = 0; start < itemIds.length; start += chunkSize) {
      final end = start + chunkSize > itemIds.length ? itemIds.length : start + chunkSize;
      final chunk = itemIds.sublist(start, end);
      final placeholders = List.filled(chunk.length, '?').join(',');
      final part = await db.query(
        table,
        columns: columns,
        where: '$itemColumn IN ($placeholders)',
        whereArgs: chunk,
        orderBy: orderBy,
      );
      rows.addAll(part);
    }

    return rows;
  }
}

