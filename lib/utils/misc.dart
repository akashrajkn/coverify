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
