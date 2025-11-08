import 'package:intl/intl.dart';

class Formatters {
  static final _currency = NumberFormat.simpleCurrency();

  static String currency(double value) => _currency.format(value);
  static String shortDate(int millis) => DateFormat.yMMMd().format(DateTime.fromMillisecondsSinceEpoch(millis));
}
