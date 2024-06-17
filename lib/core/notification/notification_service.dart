import 'dart:io';
import 'package:timezone/timezone.dart' as tz;

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

class NotificationService {
  static final flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initNotification() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
            requestAlertPermission: false,
            requestBadgePermission: false,
            requestSoundPermission: false,
            onDidReceiveLocalNotification: (int id, String? title, String? body,
                String? payload) async {});
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsDarwin);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {
      // this is where you can handle notification tap
      Get.toNamed('/');
    });
  }

  static void requestPermissions() {
    if (Platform.isAndroid) {
      flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
    }
    if (Platform.isIOS) {
      flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    }
  }

  static _notificationDetails() async {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'channelId',
        'channelName',
        importance: Importance.max,
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  static Future<void> showNotification(
      {int id = 0, String? title, String? body, String? payload}) async {
    return flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      await _notificationDetails(),
      payload: payload,
    );
  }

  static Future<void> scheduleNotification({
    int id = 0,
    String? title,
    required String body,
    required DateTime scheduledTime,
    String? payload,
  }) async {
    return flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledTime, tz.local),
      await _notificationDetails(),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
    );
  }

  static Future<List<PendingNotificationRequest>> getRemainNoti() async {
    return await flutterLocalNotificationsPlugin.pendingNotificationRequests();
  }

  static Future<void> cancelQuoteNotifications() async {
    // final timesPerDay = ConfigurationStorage.getTimePerDay();

    await flutterLocalNotificationsPlugin.cancelAll();

    // for (int i = 0; i < timesPerDay * maxDaysForScheduleNotification; i++) {
    //   await flutterLocalNotificationsPlugin.cancelAll();
    // }
    // print('cancel notification');
  }
}
