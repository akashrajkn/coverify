import 'package:intl/intl.dart';


String prettifyNumberForCard(int num) {

  if (num > 1000) {
    int ks = (num / 1000).floor();

    return ks.toString() + 'k';
  }
  return num.toString();
}


String prettifyTimeForCard(String formattedTime) {

  var dateTime = DateTime.parse(formattedTime);

  return DateFormat.jm().format(dateTime);
}


String displayDialledNumber(String dialledNumber) {

  if (dialledNumber.length <= 5) {
    return dialledNumber;
  }

  String formattedNumber = dialledNumber.substring(0, 5) + ' ' + dialledNumber.substring(5, dialledNumber.length);
  return formattedNumber;
}
