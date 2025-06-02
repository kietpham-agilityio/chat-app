import 'package:intl/intl.dart';

extension DateTimeExtensions on DateTime {
  bool isSameDay(DateTime other) =>
      year == other.year && month == other.month && day == other.day;

  String formatChatDateTime({String locale = 'en'}) {
    final now = DateTime.now();

    final timeStr =
        "${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}";

    if (isSameDay(now)) {
      return timeStr;
    } else {
      final formatStr = year == now.year ? 'MMM dd' : 'MMM dd, yyyy';
      final dateStr = DateFormat(formatStr, locale).format(this);
      return "$timeStr • $dateStr";
    }
  }
}
