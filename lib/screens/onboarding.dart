import 'package:coverify/constants.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


class OnBoardingScreen extends StatefulWidget {

  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor : Colors.white,
      body: SafeArea(

        child: Center(

          child: Column(
            mainAxisAlignment  : MainAxisAlignment.center,
            crossAxisAlignment : CrossAxisAlignment.center,
            mainAxisSize       : MainAxisSize.min,

            children           : [
              // SizedBox(height: 20,),
              Image.asset('assets/images/splash.png'),
              SizedBox(height: 20),
              Container(
                padding : EdgeInsets.fromLTRB(30, 5, 30, 5),
                child   : Row(
                  mainAxisAlignment  : MainAxisAlignment.start,
                  crossAxisAlignment : CrossAxisAlignment.center,
                  children           : [
                    Icon(Icons.check, color: Colors.green,),
                    SizedBox(width: 10,),
                    Text('Verified leads by the people', style: TextStyle(fontSize: 16, color: Colors.grey[600]),),
                  ],
                ),
              ),
              Container(
                padding : EdgeInsets.fromLTRB(30, 5, 30, 5),
                child   : Row(
                  mainAxisAlignment  : MainAxisAlignment.start,
                  crossAxisAlignment : CrossAxisAlignment.center,
                  children           : [
                    Icon(Icons.check, color: Colors.green,),
                    SizedBox(width: 10,),
                    Text('Works on trust', style: TextStyle(fontSize: 16, color: Colors.grey[600]),),
                  ],
                ),
              ),
              Container(
                padding : EdgeInsets.fromLTRB(30, 5, 30, 5),
                child   : Row(
                  mainAxisAlignment  : MainAxisAlignment.start,
                  crossAxisAlignment : CrossAxisAlignment.center,
                  children           : [
                    Icon(Icons.check, color: Colors.green,),
                    SizedBox(width: 10,),
                    Text('Crowdsourced, use cautiously', style: TextStyle(fontSize: 16, color: Colors.grey[600]),),
                  ],
                ),
              ),
              SizedBox(height: 30,),
              Container(
                padding : EdgeInsets.fromLTRB(30, 5, 30, 5),
                child   : Text(
                  'I will use coverify only to help myself and others in medical need and enter all information true to my knowledge',
                  style: TextStyle(fontSize: 17,),
                ),
              ),
              SizedBox(height: 10,),
              Container(
                padding : EdgeInsets.fromLTRB(30, 5, 30, 5),
                child   : RichText(
                  text : TextSpan(
                    children : <TextSpan>[
                      TextSpan(
                        style : TextStyle(color: Colors.black87),
                        text  : 'By continuing I agree to Coverify\'s ',
                      ),
                      TextSpan(
                        style      : TextStyle(color: Colors.blue, decoration: TextDecoration.underline,),
                        text       : 'Privacy Policy',
                        recognizer : TapGestureRecognizer()..onTap = () async {
                          if (await canLaunch(privacyPolicyURL)) {
                            await launch(privacyPolicyURL);
                          }
                        },
                      ),
                      TextSpan(
                        style : TextStyle(color: Colors.black87),
                        text  : ' and ',
                      ),
                      TextSpan(
                        style      : TextStyle(color: Colors.blue, decoration: TextDecoration.underline,),
                        text       : 'Terms & Conditions',
                        recognizer : TapGestureRecognizer()..onTap = () async {
                          if (await canLaunch(termsAndConditionsURL)) {
                            await launch(termsAndConditionsURL);
                          }
                        },
                      ),
                    ]
                  ),
                ),
              ),
              Container(
                padding : EdgeInsets.fromLTRB(30, 30, 30, 5),
                child : SizedBox(
                  width  : double.infinity,
                  height : 45,

                  child  : TextButton(
                    style     : TextButton.styleFrom(
                      primary         : Colors.white,
                      backgroundColor : Colors.green,
                      onSurface       : Colors.grey,
                      side            : BorderSide(color: Colors.green, width: 0.5),
                      padding         : EdgeInsets.fromLTRB(15, 0, 15, 0),
                    ),
                    onPressed : () { },
                    child     : Text('Agree and get started', style: TextStyle(fontSize: 19),),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}