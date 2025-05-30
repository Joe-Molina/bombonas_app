import 'package:bombonas_app/utils/same_day.dart';

List<DateTime> getLastFourWeeksDays() {
  List<DateTime> weeks = [];
  DateTime now = DateTime.now();

  for (int i = 0; i < 4; i++) {
    DateTime currentMonday = now.subtract(
      Duration(days: now.weekday - 1 + (i * 7)),
    );

    weeks.add(currentMonday);
  }
  return weeks.reversed.toList(); // Para tener la semana actual al final
}
