import 'package:intl/intl.dart';

class DateFormats {
  static final dateTime = DateFormat('dd.MM.yyyy.  HH:mm');

  static String formatDuration(Duration duration) {
    int totalMinutes = duration.inMinutes;

    int hours = totalMinutes ~/ 60;
    int minutes = totalMinutes - hours * 60;

    if (hours == 0) {
      return '${minutes}min';
    }

    if (minutes == 0) {
      return '${hours}h';
    }

    return '${hours}h ${minutes}min';
  }
}
