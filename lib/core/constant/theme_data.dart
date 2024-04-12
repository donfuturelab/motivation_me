import '../../models/enums/theme.dart';
import '../../models/theme/quote_theme.dart';

QuoteTheme theme1 = QuoteTheme(
    themeID: 17,
    imageCode: '19_1',
    fontColor: '#FFFFFF',
    fontFamily: 'Merriweather',
    fontSize: 20,
    shadowColor: '#000000',
    themeType: ThemeType.free);

QuoteTheme theme2 = QuoteTheme(
    themeID: 18,
    imageCode: '19_2',
    fontColor: '#FFFFFF',
    fontFamily: 'Lobster',
    fontSize: 20,
    shadowColor: '#000000',
    themeType: ThemeType.free);
final defaultTheme = [theme1, theme2];
