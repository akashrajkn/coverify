import 'package:intl/intl.dart';


String prettifyNumberForCard(int num) {

  if (num == null) {
    return '';
  }

  if (num > 1000) {
    int ks = (num / 1000).floor();

    return ks.toString() + 'k';
  }
  return num.toString();
}


String prettifyTimeForCard(String formattedTime) {

  print("------------------");
  print(formattedTime);
  print("------------------");

  try {
    var dateTime = DateTime.parse(formattedTime);
    return DateFormat.jm().format(dateTime);
  } on Exception catch (_) {
    return '';
  }

}


String displayDialledNumber(String dialledNumber) {

  if (dialledNumber.length <= 5) {
    return dialledNumber;
  }

  String formattedNumber = dialledNumber.substring(0, 5) + ' ' + dialledNumber.substring(5, dialledNumber.length);
  return formattedNumber;
}
