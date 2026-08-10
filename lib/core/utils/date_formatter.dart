import 'package:intl/intl.dart';

class DateFormatter {
  static String relative(DateTime date) {

    final now = DateTime.now();

    final difference = now.difference(date);

    if (difference.inSeconds < 60) {
      return "À l'instant";
    }

    if (difference.inMinutes < 60) {
      return "Il y a ${difference.inMinutes} min";
    }

    if (difference.inHours < 24) {
      return "Il y a ${difference.inHours} h";
    }

    if (difference.inDays == 1) {
      return "Hier";
    }

    if (difference.inDays < 7) {
      return DateFormat(
        "EEEE",
        "fr",
      ).format(date);
    }

    return DateFormat(
      "dd MMM",
      "fr",
    ).format(date);
  }
}