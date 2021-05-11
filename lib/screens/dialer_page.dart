import 'package:coverify/models/location.dart';
import 'package:coverify/utils/api.dart';
import 'package:coverify/utils/misc.dart';
import 'package:coverify/widgets/location_sheet.dart';
import 'package:coverify/widgets/name_sheet.dart';
import 'package:flutter/material.dart';

import 'package:coverify/models/resource.dart';
import 'package:coverify/theme.dart';
import 'package:coverify/utils/call_helper.dart';
import 'package:coverify/utils/pretty.dart';
import 'package:coverify/widgets/dial_button.dart';
import 'package:coverify/widgets/feedback_sheet.dart';
import 'package:coverify/widgets/resource_sheet.dart';


class Dialer extends StatefulWidget {

  final List<LocationModel> locations;
  final List<ResourceModel> resources;
  final Map<String, String> info;
  Dialer({this.locations, this.resources, this.info});

  @override
  _DialerState createState() => _DialerState();
}


class _DialerState extends State<Dialer> {

  String dialledNumber  = '';
  CallHelper callHelper = CallHelper();
  bool readyToDisplay = false;

  @override
  void initState() {
    if (widget.locations.length > 0 && widget.resources.length > 0) {
      readyToDisplay = true;
    }

    super.initState();
  }

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

  void showSnackBarFlow(snackBar, diallerContext, exists, formattedContactNumber) {
    showFeedbackBottomSheet(diallerContext, (feedback) {
      print(feedback);

      showResourcesBottomSheet(diallerContext, widget.resources, (resourceID) {
        print(resourceID);
        if (!exists) {
          showLocationBottomSheet(diallerContext, widget.locations, (location) {
            print(location.id);

            showNameBottomSheet(diallerContext, (contactName) {
              print(contactName);
              ScaffoldMessenger.of(diallerContext).showSnackBar(snackBar)
              .closed
              .then((value) {
                if (value == SnackBarClosedReason.swipe || value == SnackBarClosedReason.timeout) {
                  callReportContactURL(formattedContactNumber, exists, resourceID, feedback, location.id, contactName, widget.info['imei']);
                } else if (value == SnackBarClosedReason.action) {
                  showSnackBarFlow(snackBar, diallerContext, exists, formattedContactNumber);
                }
              });
            });
          });

        } else {
          ScaffoldMessenger.of(diallerContext).showSnackBar(snackBar)
          .closed
          .then((value) {
            if (value == SnackBarClosedReason.swipe || value == SnackBarClosedReason.timeout) {
              callReportContactURL(formattedContactNumber, exists, resourceID, feedback, '', '', widget.info['imei']);
            } else if (value == SnackBarClosedReason.action) {
              showSnackBarFlow(snackBar, diallerContext, exists, formattedContactNumber);
            }
          });
        }
      });
    });
  }

  Future<void> callButtonTapped() async {

    String formattedContactNumber = getFormattedContactNumber(dialledNumber);
    var response = await callContactStatusEndpoint(formattedContactNumber, widget.info['imei']);
    bool exists  = false;
    if (response['request'] == 'success') {
      exists     = response['exists'];
    }
    print(response);

    final snackBar = SnackBar(
      duration        : Duration(seconds: 2),
      backgroundColor : Colors.green,
      content         : Row(
        mainAxisAlignment  : MainAxisAlignment.center,
        crossAxisAlignment : CrossAxisAlignment.center,

        children: [
          Icon(Icons.check_circle, color: Colors.white, size: 20,),
          SizedBox(width: 5,),
          Text('Contact added', style: TextStyle(color: Colors.white),),
        ],
      ),
      action          : SnackBarAction(
        label     : 'UNDO',
        textColor : Colors.white,
        onPressed : () { },
      ),
    );

    final diff   = await callHelper.callAndGetDuration(dialledNumber);

    BuildContext diallerContext = context;
    showSnackBarFlow(snackBar, diallerContext, exists, formattedContactNumber);
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
                callButton(readyToDisplay ? callButtonTapped : () {}),
                backButton(backButtonTapped),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
