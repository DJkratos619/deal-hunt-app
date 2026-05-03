import 'package:intl/intl.dart';

class DateFormatter {
  DateFormatter._();

  static final DateFormat _displayFormat = DateFormat('dd MMM yyyy', 'es');
  static final DateFormat _shortFormat = DateFormat('dd/MM/yyyy');

  static String format(DateTime date) => _displayFormat.format(date);
  static String formatShort(DateTime date) => _shortFormat.format(date);

  static bool isExpired(DateTime date) => date.isBefore(DateTime.now());

  static int daysUntilExpiry(DateTime date) {
    final diff = date.difference(DateTime.now());
    return diff.inDays;
  }

  static String expiryLabel(DateTime date) {
    if (isExpired(date)) return 'Vencido';
    
    final days = daysUntilExpiry(date);
    
    if (days == 0) return 'Vence hoy';
    if (days == 1) return 'Vence mañana';
    if (days <= 7) return 'VENCE EN $days días';
    
    return 'Vence el ${format(date)}';
  }
}