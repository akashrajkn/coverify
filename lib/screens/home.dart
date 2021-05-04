import 'package:coverify/widgets/feedback_sheet.dart';
import 'package:flutter/material.dart';

import 'package:coverify/constants.dart';
import 'package:coverify/dummy_data.dart';
import 'package:coverify/theme.dart';
import 'package:coverify/utils/call_helper.dart';
import 'package:coverify/widgets/appbar.dart';
import 'package:coverify/widgets/contact_card.dart';
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
      body   : Column(
        mainAxisAlignment : MainAxisAlignment.start,

        children          : <Widget>[
          Text('Each contact is updated with the most recent status'),
          SizedBox(height: 20,),
          SingleChildScrollView(
              scrollDirection : Axis.horizontal,
              child           : Row(
                crossAxisAlignment : CrossAxisAlignment.center,
                mainAxisAlignment  : MainAxisAlignment.start,
                children: [
                  SizedBox(width: 30,),
                  OutlinedButton(onPressed: (){ filterChanged('oxygen'); },     child: Text('oxygen', style: TextStyle(fontWeight: chosenFilter == 'oxygen' ? FontWeight.bold : FontWeight.normal),)),
                  SizedBox(width: 10,),
                  OutlinedButton(onPressed: (){ filterChanged('bed'); },        child: Text('bed', style: TextStyle(fontWeight: chosenFilter == 'bed' ? FontWeight.bold : FontWeight.normal),)),
                  SizedBox(width: 10,),
                  OutlinedButton(onPressed: (){ filterChanged('injections'); }, child: Text('injections & medicines', style: TextStyle(fontWeight: chosenFilter == 'injections' ? FontWeight.bold : FontWeight.normal),)),
                  SizedBox(width: 10,),
                  OutlinedButton(onPressed: (){ filterChanged('plasma'); },     child: Text('plasma', style: TextStyle(fontWeight: chosenFilter == 'plasma' ? FontWeight.bold : FontWeight.normal),)),
                  SizedBox(width: 30,),
                ],
              )
          ),
          Expanded(
            child: LazyLoadScrollView(
              isLoading       : isLoadingContactsList,
              onEndOfPage     : () => _loadMoreContacts(),
              child           : ListView.builder(
                padding     : EdgeInsets.all(10),
                shrinkWrap  : true,
                itemCount   : contactsList.length,
                itemBuilder : (context, index) {
                  return contactCardWidget(contactsList[index], callNumberAndSaveFeedback, chosenFilter);
                },
              )
            ),
          ),
        ],
      ),
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
