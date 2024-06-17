import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:motivation_me/core/notification/notification_helper.dart';

import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:timezone/data/latest_all.dart' as tz;

import 'core/constant/colors.dart';
import 'core/constant/database.dart';
import 'core/constant/revenue_cat.dart';
import 'core/database/check_and_update_database.dart';
import 'core/local_storage/configuration_storage.dart';
import 'core/local_storage/quote_theme_storage.dart';
import 'core/notification/notification_init_main.dart';
import 'core/notification/notification_service.dart';
import 'core/store_config/config_sdk.dart';
import 'core/store_config/store_config.dart';
import 'routings/app_go_pages.dart';

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

  if (currentDbVersion == 3 &&
      ConfigurationStorage.getIsResetSelectedCategory() == 0) {
    await ConfigurationStorage.resetSelectedCategory();
  } // Reset selected category if db version is 2 and mark isResetSelectedCategory is 1
  // change for new version

  // check if remaining notification is less than 10 then init new notification

  await QuoteThemeStorage().init();

  await configSDK(); // Config SDK for in-app purchase

  await NotificationService.initNotification();
  tz.initializeTimeZones();

  // check if remaining notification is less than 10 then init new notification
  await initNotificationWhenLessThan10();
  // await checkNoti();

  // InitialBindings();
  // await di.init();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Motivation',
      debugShowCheckedModeBanner: false,
      routerConfig: appRouters,
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
    );
  }
}
