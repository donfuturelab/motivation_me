import 'package:day_night_time_picker/day_night_time_picker.dart';

String dateTimeToString(DateTime dateTime) {
  return dateTime.toIso8601String();
}

DateTime stringToDateTime(String dateTime) {
  return DateTime.parse(dateTime);
}

//conver index to first letter of days of week
String indexToDayOfWeek(int index) {
  switch (index) {
    case 1:
      return 'M';
    case 2:
      return 'T';
    case 3:
      return 'W';
    case 4:
      return 'T';
    case 5:
      return 'F';
    case 6:
      return 'S';
    case 7:
      return 'S';
    default:
      return 'M';
  }
}

//convert time format as string hh24:mm to Time object
Time string24ToTime(String time) {
  final List<String> timeList = time.split(':');
  return Time(
    hour: int.parse(timeList[0]),
    minute: int.parse(timeList[1]),
  );
}

//convert Time object to string format hh24:mm
String timeToString24(Time time) {
  return '${time.hour}:${time.minute}';
}

//convert Time object to string format hh12:mm
String timeToString12(Time time) {
  final int hour = time.hour > 12 ? time.hour - 12 : time.hour;
  final String minute =
      time.minute < 10 ? '0${time.minute}' : time.minute.toString();
  final String period = time.hour > 12 ? 'PM' : 'AM';
  return '$hour:$minute $period';
}
