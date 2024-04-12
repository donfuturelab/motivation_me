import 'package:get_storage/get_storage.dart';

import '../../models/theme/quote_theme.dart';
import '../constant/theme_data.dart';

class QuoteThemeStorage {
  final GetStorage _box = GetStorage('QuoteThemeStorage');
  final String _key = 'quoteTheme';

  Future<void> init() async {
    if (!_box.hasData(_key)) {
      final defaultTheme = [theme1, theme2];
      _box.write(_key, defaultTheme.map((theme) => theme.toMap()).toList());
    }
  }

  List<QuoteTheme> getThemes() {
    final themeMapList = _box.read<List>(_key) ?? [];
    return themeMapList
        .map((themeMap) => QuoteTheme.fromMap(themeMap))
        .toList();
  }

  Future<void> addTheme(QuoteTheme theme) async {
    final themeMap = theme.toMap();
    final themeMapList = _box.read<List>(_key) ?? [];
    themeMapList.insert(0, themeMap);
    await _box.write(_key, themeMapList);
  }

  Future<void> updateNewThemeList(List<QuoteTheme> themes) async {
    final themeMapList = themes.map((theme) => theme.toMap()).toList();
    await _box.write(_key, themeMapList);
  }

  Future<void> removeTheme({required int themeIndex}) async {
    final themeMapList = _box.read<List>(_key) ?? [];
    themeMapList.removeAt(themeIndex);
    await _box.write(_key, themeMapList);
  }

  Future<void> remove(String key) async {
    _box.remove(key);
  }
}
