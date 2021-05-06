import 'package:coverify/models/contact_card.dart';
import 'package:coverify/utils/db.dart';
import 'package:flutter/material.dart';

import 'package:coverify/constants.dart';
import 'package:coverify/dummy_data.dart';
import 'package:coverify/theme.dart';
import 'package:coverify/utils/call_helper.dart';
import 'package:coverify/widgets/contact_card.dart';
import 'package:coverify/widgets/feedback_sheet.dart';

import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';


class BrowsePage extends StatefulWidget {

  final String location;
  BrowsePage({Key key, this.location}) : super(key: key);

  @override
  BrowsePageState createState() => BrowsePageState();
}


class BrowsePageState extends State<BrowsePage> {

  String currentLocation = '';
  String chosenFilter    = '';

  var contactsList       = [];
  bool isLoading         = true;
  bool isLazyLoading     = true;

  CallHelper callHelper  = CallHelper();

  @override
  void initState() {
    getContactsForLocation(widget.location);

    super.initState();
  }

  @override
  void setState(fn) {
    if(mounted) {
      super.setState(fn);
    }
  }

  Future<void> getContactsForLocation(String location) async {

    setState(() { isLoading = true; });
    // TODO: Fetch from database
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      isLoading             = false;
      contactsList          = contactsDummy;
      currentLocation       = location;
    });
  }

  void locationUpdated(String newLocation) {
    getContactsForLocation(newLocation);
  }

  void filterChanged(String newFilter) {

    if (newFilter == chosenFilter) {
      newFilter = '';
    }

    setState(() { chosenFilter = newFilter; });
  }

  Future refreshContacts() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() { contactsList = contactsDummy; });
  }

  Future _loadMoreContacts() async {
    setState(() { isLazyLoading = true; });
    await Future.delayed(Duration(milliseconds: 500));
    setState(() { isLazyLoading = false; });
  }

  Future<void> callNumberAndSaveFeedback(ContactCardModel model) async {

    print(model.contactNumber);

    final diff = await callHelper.callAndGetDuration(model.contactNumber);
    showFeedbackBottomSheet(
      context,
        (feedback) {
        // TODO: Update online database
        print(feedback);

        // TODO: Add record to local database
        insertRecordToDatabase(null, model);

        final snackBar = SnackBar(
          backgroundColor : feedbackColors[feedback],
          content         : Row(
            mainAxisAlignment  : MainAxisAlignment.center,
            crossAxisAlignment : CrossAxisAlignment.center,

            children: [
              Icon(feedbackIconData[feedback], color: Colors.white, size: 20,),
              SizedBox(width: 5,),
              Text('Number marked as: $feedback', style: TextStyle(color: Colors.white),)
            ],
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    );
  }

  @override
  Widget build(BuildContext context) {

    return Column(
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
          ),
        ),
        isLoading ? Container(
          padding : EdgeInsets.fromLTRB(0, 20, 0, 0),
          child   : CircularProgressIndicator(),
        ) : Expanded(

          child: LazyLoadScrollView(
            isLoading       : isLazyLoading,
            onEndOfPage     : () => _loadMoreContacts(),
            child           : RefreshIndicator(
              onRefresh       : refreshContacts,
              backgroundColor : primaryColor,
              color           : Colors.white,
              child           : ListView.builder(
                padding     : EdgeInsets.all(10),
                shrinkWrap  : true,
                itemCount   : contactsList.length,
                itemBuilder : (context, index) {
                  return contactCardWidget(contactsList[index], callNumberAndSaveFeedback, chosenFilter);
                },
              ),
            )
          ),
        ),
      ],
    );
  }
}
