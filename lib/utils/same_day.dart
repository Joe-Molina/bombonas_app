import 'package:intl/intl.dart';

bool sameDay(DateTime? date1, DateTime? date2) {
  return date1?.year == date2?.year &&
      date1?.month == date2?.month &&
      date1?.day == date2?.day;
}

bool isInWeek(List<DateTime> weekDays, DateTime date) {
  if (weekDays.isEmpty) return false;
  final firstDate = weekDays.first;
  final lastDate = weekDays.last;
  return date.isAfter(firstDate.subtract(const Duration(days: 7))) &&
      date.isBefore(lastDate.add(const Duration(days: 7)));
}

String formatter(DateTime date) {
  return DateFormat('yyyy-MM-dd').format(date);
}
