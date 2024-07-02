import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:motivation_me/features/categories.dart/category_screen.dart';
import 'package:motivation_me/features/home/home_screen.dart';

import '../features/main_screen/main_screen.dart';
import '../features/my_quotes/my_quotes_screen.dart';
import '../features/themes/themes_screen.dart';
import 'app_routes.dart';

// navigatekey
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final appRouters = GoRouter(
  navigatorKey: navigatorKey,
  initialLocation: Routes.mainScreen,
  routes: <RouteBase>[
    GoRoute(
        name: Routes.mainScreen,
        path: Routes.mainScreen,
        builder: (context, state) {
          var stringQuoteId = state.pathParameters['id'];
          if (stringQuoteId == null) {
            return MainScreen();
          } else {
            final quoteId = int.tryParse(stringQuoteId);
            return MainScreen(quoteId: quoteId);
          }
        }),
    GoRoute(
        name: Routes.categories,
        path: Routes.categories,
        builder: (context, state) => const CategoryScreen()),
    GoRoute(
        name: Routes.home,
        path: Routes.home,
        builder: (context, state) {
          // var stringQuoteId = state.pathParameters['id'];
          // if (stringQuoteId == null) {
          //   return const HomeScreen();
          // } else {
          //   final quoteId = int.tryParse(stringQuoteId);
          //   return HomeScreen(quoteId: quoteId);
          // }
          return HomeScreen();
        }),
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
