import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';


class ErrorScreen extends StatelessWidget {

  final errorText;

  ErrorScreen(this.errorText);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body : Center(

        child: Column(
          mainAxisAlignment  : MainAxisAlignment.center,
          crossAxisAlignment : CrossAxisAlignment.center,
          mainAxisSize       : MainAxisSize.min,

          children           : <Widget>[
            Container(
              child : Text(
                'Error: ' + errorText + '\n\nPlease restart the app',
                textAlign : TextAlign.center,
                style     : TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
