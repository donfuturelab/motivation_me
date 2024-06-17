import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:motivation_me/core/constant/configurations.dart';

import '../../models/default_quote.dart';
import '../../repositories/default_quotes_repository.dart';
import 'notification_service.dart';

class NotificationHelper {
  // create function to generate list of dateTimes based on the current date and list of days of the week
  static List<DateTime> generateDateTimes(
      {required List<int> daysOfWeek,
      required int timesPerDay,
      required Time startAt,
      required Time endAt}) {
    //generate Time for each day of the week
    //based on the start and end time and the number of times per day

    print('daysOfWeek: $daysOfWeek');
    print('timesPerDay: $timesPerDay');
    print('startAt: $startAt');
    print('endAt: $endAt');

    final times = <Time>[];
    // for (var i = 0; i < timesPerDay; i++) {
    //   final hour =
    //       startAt.hour + i * ((endAt.hour - startAt.hour) ~/ timesPerDay);
    //   final minute =
    //       startAt.minute + i * ((endAt.minute - startAt.minute) ~/ timesPerDay);
    //   print('hour: $hour, minute: $minute');
    //   times.add(Time(hour: hour, minute: minute));
    // }

    // calculate the total minutes between start and end time
    final totalMinutes =
        (endAt.hour - startAt.hour) * 60 + (endAt.minute - startAt.minute);

    // calculate interval between each time slot

    final interval = totalMinutes ~/ (timesPerDay - 1);

    for (var i = 0; i < timesPerDay; i++) {
      // calculate the minutes offset to loop through the times
      final minutesOffset = i * interval;
      final hour = (startAt.hour * 60 + startAt.minute + minutesOffset) ~/ 60;
      final minute = (startAt.hour * 60 + startAt.minute + minutesOffset) % 60;

      times.add(Time(hour: hour, minute: minute));
    }

    final dateTimes = <DateTime>[];

    // for (var day in daysOfWeek) {
    //   var scheduledDay = DateTime.now().weekday == day
    //       ? DateTime.now()
    //       : DateTime.now()
    //           .add(Duration(days: (day - DateTime.now().weekday) % 7));
    //   for (var time in times) {
    //     var scheduledTime = DateTime(scheduledDay.year, scheduledDay.month,
    //         scheduledDay.day, time.hour, time.minute);
    //     dateTimes.add(scheduledTime);
    //   }
    // }

    var currentDate = DateTime.now();

    while (dateTimes.length < maxDaysForScheduleNotification * timesPerDay) {
      if (daysOfWeek.contains(currentDate.weekday)) {
        for (var time in times) {
          var scheduledTime = DateTime(currentDate.year, currentDate.month,
              currentDate.day, time.hour, time.minute);
          dateTimes.add(scheduledTime);
          if (dateTimes.length ==
              maxDaysForScheduleNotification * timesPerDay) {
            break;
          }
        }
      }
      currentDate = currentDate.add(const Duration(days: 1));
    }
    for (var dateTime in dateTimes) {
      print(
          'dateTime: ${dateTime.month} ${dateTime.day}, ${dateTime.hour}, ${dateTime.minute}');
    }
    return dateTimes;
  }

  static Future<void> scheduleQuoteReminders(
      {required List<DateTime> dateTimes,
      required List<int> daysOfWeek,
      required int timesPerDay}) async {
    final defaulQuoteRepo = DefaultQuotesRepository();

    List<DefaultQuote> quotes = [];
    final numberOfQuotes = dateTimes.length;
    quotes = await defaulQuoteRepo.getSomeRandomQuotes(
        numerOfQuotes: numberOfQuotes);

    // need to loop through the times and days of the week
    // and based on the list of quotes, schedule the notifications

    // for (var i = 0; i < daysOfWeek.length; i++) {
    //   for (var j = 0; j < timesPerDay; j++) {
    //     await NotificationService.scheduleNotification(
    //         body: quotes[i * timesPerDay + j].quoteContent,
    //         scheduledTime: dateTimes[j],
    //         payload: quotes[i * timesPerDay + j].id.toString());
    //   }
    //   print('scheduled notification for ${daysOfWeek[i]}');
    // }

    for (var i = 0; i < dateTimes.length; i++) {
      await NotificationService.scheduleNotification(
          id: i,
          body: quotes[i].quoteContent,
          scheduledTime: dateTimes[i],
          payload: quotes[i].id.toString());
      print('scheduled notification for ${dateTimes[i]} - id $i');
    }
  }

  static Future<List<DefaultQuote>> fetchQuotes(
      int numberOfQuotes, DefaultQuotesRepository defaulQuoteRepo) async {
    return await defaulQuoteRepo.getSomeRandomQuotes(
        numerOfQuotes: numberOfQuotes);
  }

  // create function to create schedule reminders. this is the main function to be called
  static Future<void> createReminders(
      {required int timesPerDay,
      required Time startTime,
      required Time endTime,
      required List<int> reminderDays}) async {
    final dateTimes = generateDateTimes(
        daysOfWeek: reminderDays,
        timesPerDay: timesPerDay,
        startAt: startTime,
        endAt: endTime);

    await scheduleQuoteReminders(
        dateTimes: dateTimes,
        daysOfWeek: reminderDays,
        timesPerDay: timesPerDay);
  }
}
