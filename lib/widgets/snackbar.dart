import 'package:coverify/theme.dart';
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

Widget numberReportSnackBar(String feedback) {

  return SnackBar(
    duration        : Duration(seconds: 2),
    backgroundColor : feedbackColors[feedback],
    content         : Row(
      mainAxisAlignment  : MainAxisAlignment.center,
      crossAxisAlignment : CrossAxisAlignment.center,

      children           : [
        Icon(feedbackIconData[feedback], color: Colors.white, size: 20,),
        SizedBox(width: 5,),
        Text('Number marked as: $feedback', style: TextStyle(color: Colors.white),)
      ],
    ),
    action          : SnackBarAction(
      label     : 'UNDO',
      textColor : Colors.white,
      onPressed : () { },
    ),
  );
}