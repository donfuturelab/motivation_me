import '../core/database/database_helper.dart';
import '../models/default_quote.dart';

class DefaultQuotesRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  //get random 20 quotes from default_quotes table
  Future<List<DefaultQuote>> getRandomQuotes() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        ''' SELECT dq.id, dq.quote_content, dq.author_id, dq.category_id, a.author_name, 
            CASE WHEN l.id IS NOT NULL THEN 1 ELSE 0 END as is_liked
            FROM default_quotes dq
            LEFT JOIN authors a ON dq.author_id = a.id
            LEFT JOIN likes l ON (dq.id = l.quote_id) AND (l.quote_source = 'default')
          ORDER BY RANDOM()
          LIMIT 20
      ''');

    return List.generate(maps.length, (i) {
      return DefaultQuote.fromMap(maps[i]);
    });
  }

  //get a quote with quoteId from default_quotes table
  Future<DefaultQuote> getDefaultQuote(int quoteId) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        ''' SELECT dq.id, dq.quote_content, dq.author_id, dq.category_id, a.author_name,
            CASE WHEN l.id IS NOT NULL THEN 1 ELSE 0 END as is_liked
            FROM default_quotes dq
            LEFT JOIN authors a ON dq.author_id = a.id
            LEFT JOIN likes l ON (dq.id = l.quote_id) AND (l.quote_source = 'default')
            WHERE dq.id = ?
      ''', [quoteId]);

    return DefaultQuote.fromMap(maps.first);
  }

  //get quotes with categoryId from default_quotes table
  Future<List<DefaultQuote>> getQuotesByCategory(int categoryId) async {
    final db = await _dbHelper.database;

    if (categoryId == 0) {
      return getRandomQuotes(); //get random quotes without considering category ==0
    } else {
      final List<Map<String, dynamic>> maps = await db.rawQuery(
          ''' SELECT dq.id, dq.quote_content, dq.author_id, dq.category_id, a.author_name,
            CASE WHEN l.id IS NOT NULL THEN 1 ELSE 0 END as is_liked
            FROM default_quotes dq
            LEFT JOIN authors a ON dq.author_id = a.id
            LEFT JOIN likes l ON (dq.id = l.quote_id) AND (l.quote_source = 'default')
            WHERE dq.category_id = ? 
            ORDER BY RANDOM()
            LIMIT 20
      ''', [categoryId]);

      return List.generate(maps.length, (i) {
        return DefaultQuote.fromMap(maps[i]);
      });
    }
  }

  Future<List<DefaultQuote>> getSomeRandomQuotes(
      {required int numerOfQuotes, int? categoryId}) async {
    final db = await _dbHelper.database;

    late String rawQuery;

    List<DefaultQuote> mapQuotes = [];

    //create switch case for categoryId
    if (categoryId == null) {
      rawQuery =
          ''' SELECT dq.id, dq.quote_content, dq.author_id, dq.category_id, a.author_name,
            CASE WHEN l.id IS NOT NULL THEN 1 ELSE 0 END as is_liked
            FROM default_quotes dq
            LEFT JOIN authors a ON dq.author_id = a.id
            LEFT JOIN likes l ON (dq.id = l.quote_id) AND (l.quote_source = 'default')
            ORDER BY RANDOM()
            LIMIT ?
      ''';
      List<Map<String, dynamic>> maps =
          await db.rawQuery(rawQuery, [numerOfQuotes]);
      mapQuotes = List.generate(maps.length, (i) {
        return DefaultQuote.fromMap(maps[i]);
      });
    } else {
      rawQuery =
          ''' SELECT dq.id, dq.quote_content, dq.author_id, dq.category_id, a.author_name,
            CASE WHEN l.id IS NOT NULL THEN 1 ELSE 0 END as is_liked
            FROM default_quotes dq
            LEFT JOIN authors a ON dq.author_id = a.id
            LEFT JOIN likes l ON (dq.id = l.quote_id) AND (l.quote_source = 'default')
            WHERE dq.category_id = ? 
            ORDER BY RANDOM()
            LIMIT ?
      ''';

      List<Map<String, dynamic>> maps =
          await db.rawQuery(rawQuery, [categoryId, numerOfQuotes]);
      mapQuotes = List.generate(maps.length, (i) {
        return DefaultQuote.fromMap(maps[i]);
      });
    }
    return mapQuotes;
  }
}
