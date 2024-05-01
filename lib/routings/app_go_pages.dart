import 'package:go_router/go_router.dart';
import 'package:motivation_me/features/categories.dart/category_screen.dart';
import 'package:motivation_me/features/home/home_screen.dart';

import '../features/main_screen/main_screen.dart';
import '../features/my_quotes/my_quotes_screen.dart';
import '../features/themes/themes_screen.dart';
import 'app_routes.dart';

final appRouters = GoRouter(
  initialLocation: Routes.mainScreen,
  routes: <RouteBase>[
    GoRoute(
        name: Routes.mainScreen,
        path: Routes.mainScreen,
        builder: (context, state) => MainScreen()),
    GoRoute(
        name: Routes.categories,
        path: Routes.categories,
        builder: (context, state) => const CategoryScreen()),
    GoRoute(path: Routes.home, builder: (context, state) => const HomeScreen()),
    GoRoute(
        name: Routes.myQuotes,
        path: Routes.myQuotes,
        builder: (context, state) => const MyQuotesScreen()),
    GoRoute(
        name: Routes.themes,
        path: Routes.themes,
        builder: (context, state) => const ThemesScreen())
  ],
);
