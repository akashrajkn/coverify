import 'package:flutter/material.dart';


Widget internetUnavailableSnackBar() {

  return SnackBar(
    duration        : Duration(days: 365),
    backgroundColor : Colors.orange,
    content         : Row(
      mainAxisAlignment  : MainAxisAlignment.center,
      crossAxisAlignment : CrossAxisAlignment.center,

      children           : [
        Text('Please check your internet connection', style: TextStyle(color: Colors.white),)
      ],
    ),
  );
}