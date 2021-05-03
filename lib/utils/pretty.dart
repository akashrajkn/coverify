import 'package:intl/intl.dart';

/// Util functions


String prettifyNumberForCard(int num) {

  if (num > 1000) {
    int ks = (num / 1000).ceil();

    return ks.toString() + 'k';
  }
  return num.toString();
}


String prettifyTimeForCard(String formattedTime) {

  var dateTime = DateTime.parse(formattedTime);

  return DateFormat.jm().format(dateTime);
}