import 'package:sqflite/sqflite.dart';

import '../core/database/database_helper.dart';
import '../models/enum.dart';

class SavesRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  // add a quote id to table saves which link with user_collections
  Future<void> addQuoteToCollection({
    required int collectionId,
    required int quoteId,
    required QuoteSource quoteSource,
  }) async {
    final db = await _dbHelper.database;
    await db.insert(
      'saves',
      {
        'collection_id': collectionId,
        'quote_source': quoteSourceToString(quoteSource),
        'quote_id': quoteId,
        'created_at': DateTime.now().toIso8601String()
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  //check if quote is already in collection
  Future<bool> isQuoteInCollection({
    required int collectionId,
    required int quoteId,
    required QuoteSource quoteSource,
  }) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'saves',
      where: 'collection_id = ? AND quote_id = ? AND quote_source = ?',
      whereArgs: [collectionId, quoteId, quoteSourceToString(quoteSource)],
    );
    return maps.isNotEmpty;
  }
}
