import 'package:coverify/theme.dart';
import 'package:coverify/widgets/dial_button.dart';
import 'package:flutter/material.dart';


class Dialer extends StatefulWidget {

  @override
  _DialerState createState() => _DialerState();
}


class _DialerState extends State<Dialer> {

  String dialledNumber = '1234567890';

  @override
  Widget build(BuildContext context) {

    return Center(

      child: Column(
        mainAxisAlignment  : MainAxisAlignment.center,
        crossAxisAlignment : CrossAxisAlignment.center,

        children           : [
          Container(

            child: Text(dialledNumber, style: TextStyle(fontSize: 30, color: primaryColor),),
          ),
          SizedBox(height: 50,),
          Row(
            mainAxisAlignment  : MainAxisAlignment.center,
            crossAxisAlignment : CrossAxisAlignment.center,

            children           : [
              dialButton('1'),
              dialButton('2'),
              dialButton('3')
            ],
          ),
          SizedBox(height: 25,),
          Row(
            mainAxisAlignment  : MainAxisAlignment.center,
            crossAxisAlignment : CrossAxisAlignment.center,

            children           : [
              dialButton('4'),
              dialButton('5'),
              dialButton('6')
            ],
          ),
          SizedBox(height: 25,),
          Row(
            mainAxisAlignment  : MainAxisAlignment.center,
            crossAxisAlignment : CrossAxisAlignment.center,

            children           : [
              dialButton('7'),
              dialButton('8'),
              dialButton('9')
            ],
          ),
          SizedBox(height: 25,),
          Row(
            mainAxisAlignment  : MainAxisAlignment.center,
            crossAxisAlignment : CrossAxisAlignment.center,

            children           : [
              dialButton('0'),
              callButton(),
              backButton(),
            ],
          ),
        ],
      ),
    );
  }
}
