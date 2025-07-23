import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart' show DateFormat;

extension TimestampExtension on Timestamp {
  String timeAgo() {
    final time = toDate();
    final now = DateTime.now();
    final diff = now.difference(time);

    final isSameDay =
        now.year == time.year && now.month == time.month && now.day == time.day;

    if (isSameDay) {
      return DateFormat('hh:mm a', 'en').format(time);
    } else if (diff.inDays < 7) {
      return DateFormat.E('en').format(time);
    } else if (diff.inDays < 30) {
      final weeks = (diff.inDays / 7).floor();
      return '${weeks}w';
    } else if (diff.inDays < 365) {
      final months = (diff.inDays / 30).floor();
      return '${months}mo';
    } else {
      final years = (diff.inDays / 365).floor();
      return '${years}y';
    }
  }
}

extension DateTimeExtension on DateTime {
  String timeAgo() {
    final now = DateTime.now();
    final diff = now.difference(this);

    final isSameDay = now.year == year && now.month == month && now.day == day;

    if (isSameDay) {
      return DateFormat('hh:mm a', 'en').format(this);
    } else if (diff.inDays < 7) {
      return DateFormat.E('en').format(this); // e.g., Mon, Tue
    } else if (diff.inDays < 30) {
      final weeks = (diff.inDays / 7).floor();
      return '${weeks}w';
    } else if (diff.inDays < 365) {
      final months = (diff.inDays / 30).floor();
      return '${months}mo';
    } else {
      final years = (diff.inDays / 365).floor();
      return '${years}y';
    }
  }
}
