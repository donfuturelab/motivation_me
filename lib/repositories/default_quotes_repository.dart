import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../core/database/database_helper.dart';
import '../models/default_quote.dart';

part 'default_quotes_repository.g.dart';

class DefaultQuotesRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  //get random 20 quotes from default_quotes table
  Future<List<DefaultQuote>> getRandomQuotes() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        ''' SELECT dq.id, dq.quote_content, dq.author_id, a.author_name, 
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
        ''' SELECT dq.id, dq.quote_content, dq.author_id, a.author_name,
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

    if (categoryId == 1) {
      return getRandomQuotes(); //get random quotes without considering category ==1
    } else if (categoryId == 2) {
      var likedQuotes = await getLikedQuotes();
      if (likedQuotes.isEmpty) {
        likedQuotes =
            await getRandomQuotes(); //get random quotes if no liked quotes
      } //get liked quotes
      return likedQuotes;
    } else {
      //get quotes by category not general and not liked
      final List<Map<String, dynamic>> maps =
          await db.rawQuery(_rawQueryForQuoteNotGeneralNotLiked, [categoryId]);

      return List.generate(maps.length, (i) {
        return DefaultQuote.fromMap(maps[i]);
      });
    }
  }

  Future<List<DefaultQuote>> getSomeRandomQuotes(
      {required int numerOfQuotes, int? categoryId}) async {
    final db = await _dbHelper.database;
    List<DefaultQuote> mapQuotes = [];

    //create switch case for categoryId
    if (categoryId == null) {
      List<Map<String, dynamic>> maps =
          await db.rawQuery(_rawQueryForNotMentionCategory, [numerOfQuotes]);
      mapQuotes = List.generate(maps.length, (i) {
        return DefaultQuote.fromMap(maps[i]);
      });
    } else {
      List<Map<String, dynamic>> maps = await db
          .rawQuery(_rawQueryForSpecificCategory, [categoryId, numerOfQuotes]);
      mapQuotes = List.generate(maps.length, (i) {
        return DefaultQuote.fromMap(maps[i]);
      });
    }
    return mapQuotes;
  }

  //get quotes liked by user
  Future<List<DefaultQuote>> getLikedQuotes() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
            SELECT dq.id, dq.quote_content, dq.author_id, a.author_name,
                  CASE WHEN l.quote_id IS NOT NULL THEN 1 ELSE 0 END as is_liked
            FROM default_quotes dq
            LEFT JOIN authors a ON dq.author_id = a.id
            INNER JOIN likes l ON (dq.id = l.quote_id) AND (l.quote_source = 'default')
            WHERE is_liked = 1
            ORDER BY RANDOM()
            LIMIT 40
          '''); // enhance later for pagination for now limit to 40

    return List.generate(maps.length, (i) {
      return DefaultQuote.fromMap(maps[i]);
    });
  }

  final _rawQueryForSpecificCategory =
      ''' SELECT dq.id, dq.quote_content, dq.author_id, a.author_name,
            CASE WHEN l.id IS NOT NULL THEN 1 ELSE 0 END as is_liked
            FROM default_quotes dq
            LEFT JOIN authors a ON dq.author_id = a.id
            INNER JOIN quote_categories qc ON dq.id = qc.quote_id
            LEFT JOIN likes l ON (dq.id = l.quote_id) AND (l.quote_source = 'default')
            WHERE qc.category_id = ? 
            ORDER BY RANDOM()
            LIMIT ?
      ''';
  final _rawQueryForNotMentionCategory =
      ''' SELECT dq.id, dq.quote_content, dq.author_id, a.author_name,
            CASE WHEN l.id IS NOT NULL THEN 1 ELSE 0 END as is_liked
            FROM default_quotes dq
            LEFT JOIN authors a ON dq.author_id = a.id 
            LEFT JOIN likes l ON (dq.id = l.quote_id) AND (l.quote_source = 'default')
            ORDER BY RANDOM()
            LIMIT ? 
      '''; // not ok quote need to handle

  final _rawQueryForQuoteNotGeneralNotLiked = '''
            SELECT dq.id, dq.quote_content, dq.author_id, a.author_name,
                  CASE WHEN l.id IS NOT NULL THEN 1 ELSE 0 END as is_liked
            FROM default_quotes dq
            LEFT JOIN authors a ON dq.author_id = a.id
            INNER JOIN quote_categories qc ON dq.id = qc.quote_id
            LEFT JOIN likes l ON (dq.id = l.quote_id) AND (l.quote_source = 'default')
            WHERE qc.category_id = ? 
            ORDER BY RANDOM()
            LIMIT 20
          '''; //ok quote
}

@riverpod
DefaultQuotesRepository defaultQuotesRepository(
    DefaultQuotesRepositoryRef ref) {
  return DefaultQuotesRepository();
}
