import 'package:intl/intl.dart';

DateTime dateTimeFromServerToLocale(String dateTime) {
  return DateFormat('EEE, dd MMM yyyy hh:mm:ss z', 'en_US').parse(dateTime, true).toLocal();
}
