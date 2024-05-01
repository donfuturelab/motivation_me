import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:sqflite/sqflite.dart';

import '../core/database/database_helper.dart';
import '../core/ultils/helpers/convert_datetime.dart';
import '../models/enum.dart';

part 'likes_repository.g.dart';

class LikesRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  //create function to record like in likes table
  Future<void> likeQuote(
      {required int quoteId, required QuoteSource quoteSource}) async {
    final db = await _dbHelper.database;
    await db.insert(
      'likes',
      {
        'quote_id': quoteId,
        'quote_source': quoteSourceToString(quoteSource),
        'created_at': dateTimeToString(DateTime.now()),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  //create function to record unlike in likes table
  Future<void> unlikeQuote(
      {required int quoteId, required QuoteSource quoteSource}) async {
    final db = await _dbHelper.database;
    await db.delete(
      'likes',
      where: 'quote_id = ? AND quote_source = ?',
      whereArgs: [quoteId, quoteSourceToString(quoteSource)],
    );

    print('unlike quote successful deleting $quoteId');
  }

  // Future<List<Like>> getLikes(int pageNumber) async {
  //   final db = await DBProvider.db.database;
  //   final List<Map<String, dynamic>> maps = await db.query(
  //     'likes',
  //     orderBy: 'created_at DESC',
  //     limit: 30,
  //     offset: pageNumber * 30,
  //   );

  //   return List.generate(maps.length, (i) {
  //     return Like(
  //       id: maps[i]['id'],
  //       quoteId: maps[i]['quote_id'],
  //       quoteSource: maps[i]['quote_source'],
  //       createdAt: maps[i]['created_at'],
  //     );
  //   });
  // }
}

//get likes from 02 tables
// SELECT
//     CASE
//         WHEN l.quote_source = 'default' THEN dq.quote_content
//         WHEN l.quote_source = 'user' THEN ucq.quote_content
//     END as quote_content,
//     l.created_at
// FROM likes l
// LEFT JOIN default_quotes dq ON l.quote_id = dq.id AND l.quote_source = 'default'
// LEFT JOIN user_created_quotes ucq ON l.quote_id = ucq.id AND l.quote_source = 'user'
// ORDER BY l.created_at DESC
// LIMIT 30 OFFSET [Page_Number * 30];

// SELECT q.*, l.created_at
// FROM default_quotes q
// JOIN likes l ON q.id = l.quote_id AND l.quote_source = 'default'

// UNION

// SELECT q.*, l.created_at
// FROM user_created_quotes q
// JOIN likes l ON q.id = l.quote_id AND l.quote_source = 'user_created'

// ORDER BY created_at DESC
// LIMIT 30 OFFSET [Page_Number * 30];

@riverpod
LikesRepository likesRepository(LikesRepositoryRef ref) {
  return LikesRepository();
}
