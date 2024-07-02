import '../constant/configurations.dart';
import '../local_storage/configuration_storage.dart';
import 'notification_helper.dart';
import 'notification_service.dart';

// Future<void> checkNoti() async {
//   NotificationService.getRemainNoti().then((value) {
//     print('remaining reminder: ${value.length}');
//     print('remaining reminder: ${value[0].body}');
//   });
// }

Future<void> initNotificationWhenLessThan10() async {
  if (ConfigurationStorage.getIsAcceptNotification() == true) {
    final remainNotis = await NotificationService.getRemainNoti();
    if (remainNotis.length < remaningNotificationToSetNew) {
      await NotificationService.cancelQuoteNotifications();
      NotificationHelper.createReminders(
          timesPerDay: ConfigurationStorage.getTimePerDay(),
          startTime: ConfigurationStorage.getStartTime(),
          endTime: ConfigurationStorage.getEndTime(),
          reminderDays: ConfigurationStorage.getReminderDays());
      print('init new notification');
    }
  }
}
