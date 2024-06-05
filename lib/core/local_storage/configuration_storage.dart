import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:get_storage/get_storage.dart';

import '../constant/configurations.dart';
import '../ultils/helpers/convert_datetime.dart';

class ConfigurationStorage {
  static final _box = GetStorage('ConfigurationStorage');

  static resetSelectedCategory() async {
    await _box.write('selectedCategoryId', 1);
    await _box.write('selectedCategoryName', 'General');
    await _box.write('isResetSelectedCategory', 1);
  }

  static getIsResetSelectedCategory() {
    return _box.read('isResetSelectedCategory') ?? 0;
  }

  static Future<void> saveSelectedCategory({
    required int categoryId,
    required String categoryName,
  }) async {
    await _box.write('selectedCategoryId', categoryId);
    await _box.write('selectedCategoryName', categoryName);
  }

  static int getSelectedCategoryId() {
    return _box.read('selectedCategoryId') ?? 0;
  }

  static String getSelectedCategoryName() {
    return _box.read('selectedCategoryName') ?? 'General';
  }

  static Future<void> isAcceptNotification(bool isActive) async {
    await _box.write('isActiveNotification', isActive);
  }

  static bool getIsAcceptNotification() {
    return _box.read('isActiveNotification') ?? false;
  }

  static Future<void> isSetInitReminder(bool isSet) async {
    await _box.write('isSetInitReminder', isSet);
  }

  static bool getIsSetInitReminder() {
    return _box.read('isSetInitReminder') ?? false;
  }

  static Future<void> saveTimePerDay(int time) async {
    await _box.write('reminderTimePerDay', time);
  }

  static int getTimePerDay() {
    return _box.read('reminderTimePerDay') ?? reminderTimePerDays;
  }

  // save start time of reminder as string format hh24:mm
  static Future<void> saveStartTime(Time time) async {
    await _box.write('reminderStartTime', timeToString24(time));
  }

  static Time getStartTime() {
    final textTime = _box.read('reminderStartTime') ?? reminderStartTime;
    return string24ToTime(textTime);
  }

  // save end time of reminder as string format hh24:mm
  static Future<void> saveEndTime(Time time) async {
    await _box.write('reminderEndTime', timeToString24(time));
  }

  static Time getEndTime() {
    final textTime = _box.read('reminderEndTime') ?? reminderEndTime;
    return string24ToTime(textTime);
  }

  static Future<void> saveReminderDays(List<int> days) async {
    await _box.write('reminderDays', days);
  }

  static List<int> getReminderDays() {
    if (_box.read('reminderDays') == null) {
      return reminderRepeatDays;
    }
    return (_box.read('reminderDays') as List<dynamic>).cast<int>();
  }

  static Future<void> remove(String key) async {
    await _box.remove(key);
  }
}
