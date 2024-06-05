import 'package:day_night_time_picker/day_night_time_picker.dart';

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
    final times = <Time>[];
    for (var i = 0; i < timesPerDay; i++) {
      final hour =
          startAt.hour + i * ((endAt.hour - startAt.hour) ~/ timesPerDay);
      final minute =
          startAt.minute + i * ((endAt.minute - startAt.minute) ~/ timesPerDay);
      times.add(Time(hour: hour, minute: minute));
    }

    final dateTimes = <DateTime>[];

    for (var day in daysOfWeek) {
      var scheduledDay = DateTime.now().weekday == day
          ? DateTime.now()
          : DateTime.now()
              .add(Duration(days: (day - DateTime.now().weekday) % 7));
      for (var time in times) {
        var scheduledTime = DateTime(scheduledDay.year, scheduledDay.month,
            scheduledDay.day, time.hour, time.minute);
        dateTimes.add(scheduledTime);
      }
    }
    return dateTimes;
  }

  static void scheduleQuoteReminder(
      {required List<DateTime> dateTimes,
      required List<int> daysOfWeek,
      required int timesPerDay}) async {
    final defaulQuoteRepo = DefaultQuotesRepository();

    List<DefaultQuote> quotes = [];
    final numberOfQuotes = daysOfWeek.length * timesPerDay;
    quotes = await defaulQuoteRepo.getSomeRandomQuotes(
        numerOfQuotes: numberOfQuotes);

    // need to loop through the times and days of the week
    // and based on the list of quotes, schedule the notifications

    for (var i = 0; i < daysOfWeek.length; i++) {
      for (var j = 0; j < timesPerDay; j++) {
        await NotificationService.scheduleNotification(
            body: quotes[i * timesPerDay + j].quoteContent,
            scheduledTime: dateTimes[j],
            payload: quotes[i * timesPerDay + j].id.toString());
      }
    }
  }
}
