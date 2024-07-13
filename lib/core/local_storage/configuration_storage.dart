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

  static bool getIsVoiceSpeakActive() {
    _box.read('isVoiceSpeakActive') ?? 0;
    if (_box.read('isVoiceSpeakActive') == 1) {
      return true;
    } else {
      return false;
    }
  }

  static Future<void> saveIsVoiceSpeakActive(bool isActive) async {
    if (isActive) {
      await _box.write('isVoiceSpeakActive', 1);
    } else {
      await _box.write('isVoiceSpeakActive', 0);
    }
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

  static Future<void> saveLanguageCode(String languageCode) async {
    await _box.write('languageCode', languageCode);
  }

  static String getLanguageCode() {
    return _box.read('languageCode') ?? '';
  }

  static Future<void> increaseOpenAppCount() async {
    final count = getOpenAppCount();
    await _box.write('openAppCount', count + 1);
  }

  static int getOpenAppCount() {
    return _box.read('openAppCount') ?? 0;
  }

  //create static function to check today user has opened the app or not
  // just get date, month, year without time
  static bool isTodayOpenedApp() {
    final lastOpenAppDate = getLastOpenAppDate();
    final today = DateTime.now();
    final todayDate = '${today.year}-${today.month}-${today.day}';
    return lastOpenAppDate == todayDate;
  }

  static Future<void> saveLastOpenAppDate(DateTime date) async {
    await _box.write(
        'lastOpenAppDate', '${date.year}-${date.month}-${date.day}');
  }

  static String getLastOpenAppDate() {
    return _box.read('lastOpenAppDate') ?? '';
  }
}
