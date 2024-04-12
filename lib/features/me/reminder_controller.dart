import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:get/get.dart';

import '../../core/local_storage/configuration_storage.dart';
import '../../core/notification/notification_helper.dart';
import '../../core/notification/notification_service.dart';

class ReminderController extends GetxController {
  ReminderController();

  final RxInt _timePerDay = ConfigurationStorage.getTimePerDay().obs;
  int get timePerDay => _timePerDay.value;

  final Rx<Time> _startTime = ConfigurationStorage.getStartTime().obs;
  Time get startTime => _startTime.value;

  final Rx<Time> _endTime = ConfigurationStorage.getEndTime().obs;
  Time get endTime => _endTime.value;

  final RxList<int> _reminderDays = ConfigurationStorage.getReminderDays().obs;
  List<int> get reminderDays => _reminderDays.toList();

  void increaseTimePerDay() async {
    _timePerDay.value++;
  }

  void decreaseTimePerDay() async {
    _timePerDay.value--;
  }

  void changeStartTime(Time time) async {
    _startTime.value = time;
  }

  void changeEndTime(Time time) async {
    _endTime.value = time;
  }

  // change a day to be selected or unselected
  void toggleReminderDay(int index) async {
    if (_reminderDays.contains(index)) {
      _reminderDays.remove(index);
    } else {
      _reminderDays.add(index);
    }
  }

  void onSaveReminder() async {
    // schedule the reminder
    await ConfigurationStorage.saveStartTime(_startTime.value);
    await ConfigurationStorage.saveEndTime(_endTime.value);
    await ConfigurationStorage.saveReminderDays(_reminderDays.toList());
    await ConfigurationStorage.saveTimePerDay(_timePerDay.value);

    final dateTimes = NotificationHelper.generateDateTimes(
        daysOfWeek: _reminderDays.toList(),
        timesPerDay: _timePerDay.value,
        startAt: _startTime.value,
        endAt: _endTime.value);

    final isAcceptNotification = ConfigurationStorage.getIsAcceptNotification();

    if (isAcceptNotification) {
      NotificationService.cancelNotification(0);
      NotificationHelper.scheduleQuoteReminder(
          dateTimes: dateTimes,
          daysOfWeek: _reminderDays.toList(),
          timesPerDay: _timePerDay.value);
    } else {
      NotificationService.requestPermissions();
      await ConfigurationStorage.isAcceptNotification(true);
      NotificationService.cancelNotification(0);
      NotificationHelper.scheduleQuoteReminder(
          dateTimes: dateTimes,
          daysOfWeek: _reminderDays.toList(),
          timesPerDay: _timePerDay.value);
    }
  }

  void initReminder() async {
    _timePerDay.value = ConfigurationStorage.getTimePerDay();
    _startTime.value = ConfigurationStorage.getStartTime();
    _endTime.value = ConfigurationStorage.getEndTime();
    _reminderDays.value = ConfigurationStorage.getReminderDays();

    final dateTimes = NotificationHelper.generateDateTimes(
        daysOfWeek: _reminderDays.toList(),
        timesPerDay: _timePerDay.value,
        startAt: _startTime.value,
        endAt: _endTime.value);
    final isAcceptNotification = ConfigurationStorage.getIsAcceptNotification();

    if (isAcceptNotification) {
      NotificationService.cancelNotification(0);
      NotificationHelper.scheduleQuoteReminder(
          dateTimes: dateTimes,
          daysOfWeek: _reminderDays.toList(),
          timesPerDay: _timePerDay.value);
      ConfigurationStorage.isSetInitReminder(true);
    } else {
      NotificationService.requestPermissions();
      await ConfigurationStorage.isAcceptNotification(true);
      NotificationService.cancelNotification(0);
      NotificationHelper.scheduleQuoteReminder(
          dateTimes: dateTimes,
          daysOfWeek: _reminderDays.toList(),
          timesPerDay: _timePerDay.value);
      ConfigurationStorage.isSetInitReminder(true);
    }
  }
}
