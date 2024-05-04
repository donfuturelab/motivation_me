import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:equatable/equatable.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/local_storage/configuration_storage.dart';
import '../../core/notification/notification_helper.dart';
import '../../core/notification/notification_service.dart';

part 'reminder_controller.g.dart';

// class ReminderController extends GetxController {
//   ReminderController();

//   final RxInt _timePerDay = ConfigurationStorage.getTimePerDay().obs;
//   int get timePerDay => _timePerDay.value;

//   final Rx<Time> _startTime = ConfigurationStorage.getStartTime().obs;
//   Time get startTime => _startTime.value;

//   final Rx<Time> _endTime = ConfigurationStorage.getEndTime().obs;
//   Time get endTime => _endTime.value;

//   final RxList<int> _reminderDays = ConfigurationStorage.getReminderDays().obs;
//   List<int> get reminderDays => _reminderDays.toList();

//   void increaseTimePerDay() async {
//     _timePerDay.value++;
//   }

//   void decreaseTimePerDay() async {
//     _timePerDay.value--;
//   }

//   void changeStartTime(Time time) async {
//     _startTime.value = time;
//   }

//   void changeEndTime(Time time) async {
//     _endTime.value = time;
//   }

//   // change a day to be selected or unselected
//   void toggleReminderDay(int index) async {
//     if (_reminderDays.contains(index)) {
//       _reminderDays.remove(index);
//     } else {
//       _reminderDays.add(index);
//     }
//   }

//   void onSaveReminder() async {
//     // schedule the reminder
//     await ConfigurationStorage.saveStartTime(_startTime.value);
//     await ConfigurationStorage.saveEndTime(_endTime.value);
//     await ConfigurationStorage.saveReminderDays(_reminderDays.toList());
//     await ConfigurationStorage.saveTimePerDay(_timePerDay.value);

//     final dateTimes = NotificationHelper.generateDateTimes(
//         daysOfWeek: _reminderDays.toList(),
//         timesPerDay: _timePerDay.value,
//         startAt: _startTime.value,
//         endAt: _endTime.value);

//     final isAcceptNotification = ConfigurationStorage.getIsAcceptNotification();

//     if (isAcceptNotification) {
//       NotificationService.cancelNotification(0);
//       NotificationHelper.scheduleQuoteReminder(
//           dateTimes: dateTimes,
//           daysOfWeek: _reminderDays.toList(),
//           timesPerDay: _timePerDay.value);
//     } else {
//       NotificationService.requestPermissions();
//       await ConfigurationStorage.isAcceptNotification(true);
//       NotificationService.cancelNotification(0);
//       NotificationHelper.scheduleQuoteReminder(
//           dateTimes: dateTimes,
//           daysOfWeek: _reminderDays.toList(),
//           timesPerDay: _timePerDay.value);
//     }
//   }

//   void initReminder() async {
//     _timePerDay.value = ConfigurationStorage.getTimePerDay();
//     _startTime.value = ConfigurationStorage.getStartTime();
//     _endTime.value = ConfigurationStorage.getEndTime();
//     _reminderDays.value = ConfigurationStorage.getReminderDays();

//     final dateTimes = NotificationHelper.generateDateTimes(
//         daysOfWeek: _reminderDays.toList(),
//         timesPerDay: _timePerDay.value,
//         startAt: _startTime.value,
//         endAt: _endTime.value);
//     final isAcceptNotification = ConfigurationStorage.getIsAcceptNotification();

//     if (isAcceptNotification) {
//       NotificationService.cancelNotification(0);
//       NotificationHelper.scheduleQuoteReminder(
//           dateTimes: dateTimes,
//           daysOfWeek: _reminderDays.toList(),
//           timesPerDay: _timePerDay.value);
//       ConfigurationStorage.isSetInitReminder(true);
//     } else {
//       NotificationService.requestPermissions();
//       await ConfigurationStorage.isAcceptNotification(true);
//       NotificationService.cancelNotification(0);
//       NotificationHelper.scheduleQuoteReminder(
//           dateTimes: dateTimes,
//           daysOfWeek: _reminderDays.toList(),
//           timesPerDay: _timePerDay.value);
//       ConfigurationStorage.isSetInitReminder(true);
//     }
//   }
// }

@riverpod
class ReminderController extends _$ReminderController {
  @override
  ReminderState build() {
    final timePerDay = ConfigurationStorage.getTimePerDay();
    final startTime = ConfigurationStorage.getStartTime();
    final endTime = ConfigurationStorage.getEndTime();
    final reminderDays = ConfigurationStorage.getReminderDays();

    print('reminderDays: ${reminderDays.length}');

    return ReminderState(
      timePerDay: timePerDay,
      startTime: startTime,
      endTime: endTime,
      reminderDays: reminderDays,
    );
  }

  void increaseTimePerDay() {
    state = state.copyWith(timePerDay: state.timePerDay + 1);
  }

  void decreaseTimePerDay() {
    if (state.timePerDay <= 1) return;
    state = state.copyWith(timePerDay: state.timePerDay - 1);
  }

  void changeStartTime(Time time) {
    state = state.copyWith(startTime: time);
  }

  void changeEndTime(Time time) {
    state = state.copyWith(endTime: time);
  }

  void toggleReminderDay(int index) {
    List<int> reminderDays = List<int>.from(state.reminderDays);

    if (reminderDays.contains(index)) {
      reminderDays.remove(index);
    } else {
      reminderDays.add(index);
    }
    state = state.copyWith(reminderDays: reminderDays);
  }

  //init reminder
  void initReminder() {
    final dateTimes = NotificationHelper.generateDateTimes(
        daysOfWeek: state.reminderDays,
        timesPerDay: state.timePerDay,
        startAt: state.startTime,
        endAt: state.endTime);
    final isAcceptNotification = ConfigurationStorage.getIsAcceptNotification();

    if (isAcceptNotification) {
      NotificationService.cancelNotification(0);
      NotificationHelper.scheduleQuoteReminder(
          dateTimes: dateTimes,
          daysOfWeek: state.reminderDays,
          timesPerDay: state.timePerDay);
      ConfigurationStorage.isSetInitReminder(true);
    } else {
      NotificationService.requestPermissions();
      ConfigurationStorage.isAcceptNotification(true);
      NotificationService.cancelNotification(0);
      NotificationHelper.scheduleQuoteReminder(
          dateTimes: dateTimes,
          daysOfWeek: state.reminderDays,
          timesPerDay: state.timePerDay);
      ConfigurationStorage.isSetInitReminder(true);
    }
  }

  //save reminder
  void onSaveReminder() async {
    // schedule the reminder
    await ConfigurationStorage.saveStartTime(state.startTime);
    await ConfigurationStorage.saveEndTime(state.endTime);
    await ConfigurationStorage.saveReminderDays(state.reminderDays);
    await ConfigurationStorage.saveTimePerDay(state.timePerDay);

    final dateTimes = NotificationHelper.generateDateTimes(
        daysOfWeek: state.reminderDays,
        timesPerDay: state.timePerDay,
        startAt: state.startTime,
        endAt: state.endTime);

    final isAcceptNotification = ConfigurationStorage.getIsAcceptNotification();

    if (isAcceptNotification) {
      NotificationService.cancelNotification(0);
      NotificationHelper.scheduleQuoteReminder(
          dateTimes: dateTimes,
          daysOfWeek: state.reminderDays,
          timesPerDay: state.timePerDay);
    } else {
      NotificationService.requestPermissions();
      ConfigurationStorage.isAcceptNotification(true);
      NotificationService.cancelNotification(0);
      NotificationHelper.scheduleQuoteReminder(
          dateTimes: dateTimes,
          daysOfWeek: state.reminderDays,
          timesPerDay: state.timePerDay);
    }
  }
}

class ReminderState extends Equatable {
  final int timePerDay;
  final Time startTime;
  final Time endTime;
  final List<int> reminderDays;

  const ReminderState({
    required this.timePerDay,
    required this.startTime,
    required this.endTime,
    required this.reminderDays,
  });

  ReminderState copyWith({
    int? timePerDay,
    Time? startTime,
    Time? endTime,
    List<int>? reminderDays,
  }) {
    return ReminderState(
      timePerDay: timePerDay ?? this.timePerDay,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      reminderDays: reminderDays ?? this.reminderDays,
    );
  }

  @override
  List<Object> get props => [timePerDay, startTime, endTime, reminderDays];
}
