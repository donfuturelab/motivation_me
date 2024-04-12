import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:motivation_me/features/add_to_collection/add_to_collection_screen.dart';
import 'package:motivation_me/models/enum.dart';

import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:timezone/data/latest_all.dart' as tz;

import 'core/constant/colors.dart';
import 'core/constant/revenue_cat.dart';
import 'core/database/check_and_update_database.dart';
import 'core/dependency injection/dependency_injection.dart' as di;
import 'core/local_storage/quote_theme_storage.dart';
import 'core/notification/notification_service.dart';
import 'core/store_config/config_sdk.dart';
import 'core/store_config/store_config.dart';
import 'features/main_screen/main_screen.dart';
import 'routings/app_pages.dart';

void main() async {
  if (Platform.isIOS) {
    StoreConfig(store: Store.appStore, apiKey: appleApiKey);
  }

  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init('dbVersion');
  await initializeDatabase();

  await GetStorage.init('QuoteThemeStorage');
  await GetStorage.init('ConfigurationStorage');
  // await QuoteThemeStorage().remove('quoteTheme');
  await QuoteThemeStorage().init();

  await configSDK(); // Config SDK for in-app purchase

  await NotificationService.initNotification();
  tz.initializeTimeZones();

  // InitialBindings();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Motivation',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: const TextTheme(
          displayLarge: TextStyle(
              fontSize: 20.0, fontWeight: FontWeight.w600, color: Colors.white),
          displayMedium: TextStyle(
              fontSize: 18.0, fontWeight: FontWeight.w500, color: Colors.white),
          displaySmall: TextStyle(
              fontSize: 16.0, fontWeight: FontWeight.w400, color: Colors.white),
          labelLarge: TextStyle(
              fontSize: 18.0, fontWeight: FontWeight.w500, color: Colors.white),
          labelMedium: TextStyle(
              fontSize: 16.0, fontWeight: FontWeight.w500, color: Colors.white),
          labelSmall: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
              color: Colors.white,
              letterSpacing: 0.0),
          titleMedium: TextStyle(
              fontSize: 16.0, fontWeight: FontWeight.w500, color: Colors.white),
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.main),
        useMaterial3: true,
      ),
      getPages: AppPages.pages,
      home: MainScreen(),
    );
  }
}
