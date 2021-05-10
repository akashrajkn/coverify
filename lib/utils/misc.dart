import 'dart:io';


/// Check if internet connection is available
Future<bool> isInternetAvailable() async {

  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      print('Internet connection available');
      return true;
    }
  } on SocketException catch (_) {
    return false;
  }
  return false;
}


String getFormattedContactNumber(String number) {
  if (number.startsWith('0')) {
    number = number.substring(1);
  }

  number = number.replaceAll(' ', '');

  if (number.startsWith('+91')) {
    return number;
  }

  return '+91' + number;
}