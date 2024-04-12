import '../core/database/database_helper.dart';
import '../models/enums/theme.dart';
import '../models/theme/quote_theme.dart';

class ThemesRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<List<QuoteTheme>> getFreeThemes(
      {required Set<int> isSelectedThemeIDs}) async {
    final db = await _dbHelper.database;
    //get random 5 themes
    final List<Map<String, dynamic>> maps = await db.query(
      'themes',
      limit: 5,
      orderBy: 'RANDOM()',
    );

    //check and only return list themes that are not added
    final themes = <QuoteTheme>[]; //create empty list of themes
    for (final map in maps) {
      final theme = QuoteTheme.fromMap(map);
      if (!isSelectedThemeIDs.contains(theme.themeID)) {
        //if added, set isSelected to true
        themes.add(theme.copyWith(themeType: ThemeType.free));
      }
    }
    return themes;
  }

  //create function to get themes by category
  Future<List<QuoteTheme>> getThemesByCategory(
      {required ThemeCategory themeCategory,
      required Set<int> isSelectedThemeIDs}) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'themes',
      where: 'category_id = ?',
      whereArgs: [themeCategoryToInt(themeCategory)],
    );

    //check and only return list themes that are not added
    final themes = <QuoteTheme>[]; //create empty list of themes
    for (final map in maps) {
      final theme = QuoteTheme.fromMap(map);
      if (!isSelectedThemeIDs.contains(theme.themeID)) {
        //if added, set isSelected to true
        themes.add(theme);
      }
    }
    return themes;

    // return List.generate(maps.length, (i) {
    //   //check if the theme is already added
    //   final theme = QuoteTheme.fromMap(maps[i]);
    //   if (isSelectedThemeIDs.contains(theme.themeID)) {
    //     //if added, set isSelected to true
    //     return;
    //   } else {
    //     return theme;
    //   }
    // }
    // );
  }
}
