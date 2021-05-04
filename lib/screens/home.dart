import 'package:flutter/material.dart';
import 'package:flutter_dialpad/flutter_dialpad.dart';

import 'package:coverify/constants.dart';
import 'package:coverify/dummy_data.dart';
import 'package:coverify/theme.dart';

import 'package:coverify/screens/dialer.dart';
import 'package:coverify/utils/call_helper.dart';
import 'package:coverify/widgets/appbar.dart';
import 'package:coverify/widgets/contact_card.dart';
import 'package:coverify/widgets/feedback_sheet.dart';
import 'package:coverify/widgets/location_sheet.dart';

import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:phonecallstate/phonecallstate.dart';


class HomeScreen extends StatefulWidget {

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  String currentLocation = '';
  String chosenFilter    = '';
  var locationList       = [];

  var contactsList           = [];
  bool isLoadingContactsList = true;

  CallHelper callHelper = CallHelper();

  @override
  void initState() {

    // Get current location and location list
    setState(() {
      currentLocation = 'Dehradun';
      locationList    = ['', 'Ahmedabad', 'Bangalore', 'Chennai', 'Dehradun', 'Ghaziabad', 'Hyderabad', 'NCR', 'Mumbai'];
    });

    // Get contacts list
    setState(() {
      isLoadingContactsList = false;
      contactsList = contactsDummy;
    });

    super.initState();
  }

  void locationChanged(String newLocation) {
    setState(() {
      currentLocation = newLocation;
    });
  }

  void filterChanged(String newFilter) {

    if (newFilter == chosenFilter) {
      newFilter = '';
    }

    setState(() {
      chosenFilter = newFilter;
    });
  }

  Future _loadMoreContacts() async {

  }

  Future<void> callNumberAndSaveFeedback(String formattedPhoneNumber) async {

    print(formattedPhoneNumber);

    final diff = await callHelper.callAndGetDuration(formattedPhoneNumber);
    showFeedbackBottomSheet(
      context,
      (feedback) {
        // TODO: Update database
        print(feedback);
      }
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar : appBarCommon(currentLocation, () { showLocationBottomSheet(context, locationList, locationChanged); }),
      body   : Dialer(),

      bottomNavigationBar: BottomNavigationBar(
        type  : BottomNavigationBarType.fixed,
        items : [
          BottomNavigationBarItem(icon: Icon(Icons.person_search), label: 'Browse'),
          BottomNavigationBarItem(icon: Icon(Icons.dialpad),       label: 'Dial New'),
          BottomNavigationBarItem(icon: Icon(Icons.av_timer),      label: 'Recent')
        ],
      ),
    );
  }
}


