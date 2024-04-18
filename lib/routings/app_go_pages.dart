import 'package:go_router/go_router.dart';
import 'package:motivation_me/features/categories.dart/category_screen.dart';
import 'package:motivation_me/features/home/home_screen.dart';

import '../features/main_screen/main_screen.dart';
import '../features/my_quotes/my_quotes_screen.dart';
import '../features/themes/themes_screen.dart';
import 'app_routes.dart';

final appRouters = GoRouter(routes: <RouteBase>[
  GoRoute(path: Routes.mainScreen, builder: (context, state) => MainScreen()),
  GoRoute(
      path: Routes.categories, builder: (context, state) => CategoryScreen()),
  GoRoute(path: Routes.home, builder: (context, state) => HomeScreen()),
  GoRoute(path: Routes.myQuotes, builder: (context, state) => MyQuotesScreen()),
  GoRoute(path: Routes.themes, builder: (context, state) => ThemesScreen())
]);
