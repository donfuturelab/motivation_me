import '../core/database/database_helper.dart';
import '../models/quote_category.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'categories_repository.g.dart';

class CategoriesRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<List<QuoteCategory>> getCategories() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('categories');

    return List.generate(maps.length, (i) {
      return QuoteCategory.fromMap(maps[i]);
    });
  }

  //create function to support search like with name of category
  Future<List<QuoteCategory>> searchCategories(String query) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('categories',
        where: 'category_name LIKE ?',
        whereArgs: ['%$query%'],
        orderBy: 'category_name ASC');

    return List.generate(maps.length, (i) {
      return QuoteCategory.fromMap(maps[i]);
    });
  }
}

@riverpod
CategoriesRepository categoriesRepository(CategoriesRepositoryRef ref) {
  return CategoriesRepository();
}
