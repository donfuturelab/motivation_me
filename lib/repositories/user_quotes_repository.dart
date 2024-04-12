import '../core/database/database_helper.dart';
import '../models/user_quote.dart';

class UserQuotesRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  final String tbName = 'user_quotes';

  //create a new quote
  Future<int> createQuote(UserQuoteMap quoteMap) async {
    final db = await _dbHelper.database;
    return await db.insert(tbName, quoteMap.toMap());
  }

  //get list 20 quotes latest from user_quotes table for page and pagination
  Future<List<UserQuote>> getQuotes(
      {required int page, int pageSize = 20}) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps =
        await db.rawQuery(''' SELECT uq.id, uq.quote_content, uq.created_at,
        CASE WHEN l.id IS NOT NULL THEN 1 ELSE 0 END as is_liked
            FROM user_quotes uq
            LEFT JOIN likes l ON (uq.id = l.quote_id) AND (l.quote_source = 'user')
            ORDER BY uq.created_at DESC
            LIMIT ? OFFSET ?
        ''', [pageSize, (page - 1) * pageSize]);

    return List.generate(maps.length, (i) {
      return UserQuote.fromMap(maps[i]);
    });
  }
}
/*
SELECT dq.id, dq.quote_content, dq.author_id, dq.category_id, a.author_name, 
            CASE WHEN l.id IS NOT NULL THEN 1 ELSE 0 END as is_liked
            FROM default_quotes dq
            LEFT JOIN authors a ON dq.author_id = a.id
            LEFT JOIN likes l ON dq.id = l.quote_id
          ORDER BY RANDOM()
          LIMIT 20
*/