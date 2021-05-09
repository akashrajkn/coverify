import 'package:flutter/material.dart';

import 'package:coverify/models/resource.dart';
import 'package:coverify/theme.dart';
import 'package:coverify/utils/call_helper.dart';
import 'package:coverify/utils/pretty.dart';
import 'package:coverify/widgets/category_sheet.dart';
import 'package:coverify/widgets/dial_button.dart';
import 'package:coverify/widgets/feedback_sheet.dart';
import 'package:coverify/widgets/resource_sheet.dart';


class Dialer extends StatefulWidget {

  final List<ResourceModel> resources;
  Dialer({this.resources});

  @override
  _DialerState createState() => _DialerState();
}


class _DialerState extends State<Dialer> {

  String dialledNumber  = '';
  CallHelper callHelper = CallHelper();

  void dialButtonTapped(String s) {
    setState(() { dialledNumber += s; });
  }

  void backButtonTapped() {

    String _num = dialledNumber;
    if (_num != null && _num.length > 0) {
      _num = _num.substring(0, _num.length - 1);
    }
    setState(() { dialledNumber = _num; });
  }

  Future<void> callButtonTapped() async {

    // final diff = await callHelper.callAndGetDuration(dialledNumber);

    showResourcesBottomSheet(
      context,
      widget.resources,
      (resourceID) {
        print(resourceID);
      },
    );

    // showFeedbackBottomSheet(
    //   context,
    //   (feedback) {
    //     // TODO: Update database
    //     print(feedback);
    //
    //     showCategoryBottomSheet(
    //       context,
    //       (category) {
    //         // TODO: Update database
    //         print(category);
    //
    //         final snackBar = SnackBar(
    //           backgroundColor : Colors.green,
    //           content         : Row(
    //             mainAxisAlignment  : MainAxisAlignment.center,
    //             crossAxisAlignment : CrossAxisAlignment.center,
    //
    //             children: [
    //               Icon(Icons.check_circle, color: Colors.white, size: 20,),
    //               SizedBox(width: 5,),
    //               Text('Contact added', style: TextStyle(color: Colors.white),)
    //             ],
    //           ),
    //         );
    //         ScaffoldMessenger.of(context).showSnackBar(snackBar);
    //       }
    //     );
    //   }
    // );
  }

  @override
  Widget build(BuildContext context) {

    return Center(

      child: SingleChildScrollView(

        child: Column(
          mainAxisAlignment  : MainAxisAlignment.center,
          crossAxisAlignment : CrossAxisAlignment.center,

          children           : [
            Container(

              child: Text(displayDialledNumber(dialledNumber), style: TextStyle(fontSize: 30, color: primaryColor),),
            ),
            SizedBox(height: 50,),
            Row(
              mainAxisAlignment  : MainAxisAlignment.center,
              crossAxisAlignment : CrossAxisAlignment.center,

              children           : [
                dialButton('1', dialButtonTapped),
                dialButton('2', dialButtonTapped),
                dialButton('3', dialButtonTapped)
              ],
            ),
            SizedBox(height: 25,),
            Row(
              mainAxisAlignment  : MainAxisAlignment.center,
              crossAxisAlignment : CrossAxisAlignment.center,

              children           : [
                dialButton('4', dialButtonTapped),
                dialButton('5', dialButtonTapped),
                dialButton('6', dialButtonTapped)
              ],
            ),
            SizedBox(height: 25,),
            Row(
              mainAxisAlignment  : MainAxisAlignment.center,
              crossAxisAlignment : CrossAxisAlignment.center,

              children           : [
                dialButton('7', dialButtonTapped),
                dialButton('8', dialButtonTapped),
                dialButton('9', dialButtonTapped)
              ],
            ),
            SizedBox(height: 25,),
            Row(
              mainAxisAlignment  : MainAxisAlignment.center,
              crossAxisAlignment : CrossAxisAlignment.center,

              children           : [
                dialButton('0', dialButtonTapped),
                callButton(callButtonTapped),
                backButton(backButtonTapped),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
