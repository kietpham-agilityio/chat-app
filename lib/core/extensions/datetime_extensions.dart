import 'package:intl/intl.dart';

extension DateTimeExtensions on DateTime {
  bool isSameDay(DateTime other) =>
      year == other.year && month == other.month && day == other.day;

  String formatChatDateTime({String locale = 'en'}) {
    final now = DateTime.now();

    final timeStr = DateFormat('hh:mm a', locale).format(this);

    if (isSameDay(now)) {
      return timeStr;
    } else {
      final formatStr = year == now.year ? 'MMM dd' : 'MMM dd, yyyy';
      final dateStr = DateFormat(formatStr, locale).format(this);
      return "$timeStr • $dateStr";
    }
  }
}
