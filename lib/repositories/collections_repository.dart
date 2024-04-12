import 'package:sqflite/sqflite.dart';
import '../core/database/database_helper.dart';
import '../models/collection.dart';

class CollectionsRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<List<Collection>> getCollections() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('user_collections');

    return List.generate(maps.length, (i) {
      return Collection.fromMap(maps[i]);
    });
  }

  // Insert a collection into the database
  Future<Collection> addCollection(String name) async {
    final db = await _dbHelper.database;
    final id = await db.insert(
      'user_collections',
      {
        'collection_name': name,
        'quote_count': 0,
        'created_at': DateTime.now().toIso8601String()
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return Collection(
      id: id,
      name: name,
      quoteCount: 0,
    );
  }

  // Update a collection in the database
  Future<void> updateCollectionName(Collection collection) async {
    final db = await _dbHelper.database;
    await db.update(
      'user_collections',
      {
        'collection_name': collection.name,
      },
      where: 'id = ?',
      whereArgs: [collection.id],
    );
  }

  // update quote count in collection
  Future<void> updateQuoteCount(int collectionId, int quoteCount) async {
    final db = await _dbHelper.database;
    await db.rawUpdate(
        'UPDATE user_collections SET quote_count = ? WHERE id = ?',
        [quoteCount, collectionId]);
  }

  Future<void> increaseQuoteCount(int collectionId) async {
    final db = await _dbHelper.database;
    await db.rawUpdate(
        'UPDATE user_collections SET quote_count = quote_count + 1 WHERE id = ?',
        [collectionId]);
  }

  //decrease quote count in collection
  Future<void> decreaseQuoteCount(int collectionId) async {
    final db = await _dbHelper.database;
    await db.rawUpdate(
        'UPDATE user_collections SET quote_count = quote_count - 1 WHERE id = ?',
        [collectionId]);
  }

  // Delete a collection from the database
  Future<void> deleteCollection(int id) async {
    final db = await _dbHelper.database;
    await db.delete(
      'user_collections',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // add quote to collection
}
