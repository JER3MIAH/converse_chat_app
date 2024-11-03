import 'package:intl/intl.dart';

String formatDate(
  dynamic dateTime, {
  required String format,
}) {
  DateTime? date;
  if (dateTime is String) {
    date = DateTime.parse(dateTime);
  } else if (dateTime is DateTime) {
    date = dateTime;
  } else {
    throw ArgumentError('dateTime must be a String or DateTime object');
  }

  return DateFormat(format).format(date);
}
