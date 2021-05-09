import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';

import 'package:coverify/constants.dart';
import 'package:coverify/theme.dart';
import 'package:coverify/models/contact.dart';
import 'package:coverify/models/location.dart';
import 'package:coverify/models/resource.dart';
import 'package:coverify/utils/api.dart';
import 'package:coverify/utils/call_helper.dart';
import 'package:coverify/utils/db.dart';
import 'package:coverify/widgets/contact_card.dart';
import 'package:coverify/widgets/feedback_sheet.dart';


class BrowsePage extends StatefulWidget {

  final LocationModel location;
  final List<ResourceModel> resources;
  BrowsePage({Key key, this.location, this.resources}) : super(key: key);

  @override
  BrowsePageState createState() => BrowsePageState();
}


class BrowsePageState extends State<BrowsePage> {

  LocationModel currentLocation;
  String chosenFilter    = '';
  int    offset          = 0;
  var contactsList       = [];
  bool isLoading         = true;
  bool isLazyLoading     = true;

  CallHelper callHelper  = CallHelper();

  @override
  void initState() {

    chosenFilter = widget.resources[0].id;

    if (widget.location != null && widget.location.id.isNotEmpty) {
      getFilteredContactsForLocation(widget.location);
    }

    super.initState();
  }

  @override
  void setState(fn) {
    if(mounted) {
      super.setState(fn);
    }
  }

  Future<void> getFilteredContactsForLocation(LocationModel whichLocation) async {

    setState(() { isLoading = true; });

    ResourceModel whichResource = widget.resources.firstWhere((element) => element.id == chosenFilter, orElse: () { return null; });
    var response                = await callFilterContactsEndpoint(whichLocation, whichResource, 0);
    if (response['request'] == 'error') {
      Navigator.of(context).pushReplacementNamed(errorRoute, arguments: response['error']);
    }

    setState(() {
      isLoading       = false;
      contactsList    = response['contacts'];
      currentLocation = whichLocation;
    });
  }

  void locationUpdated(LocationModel newLocation) {
    print('location updated from browse page');
    getFilteredContactsForLocation(newLocation);
  }

  void filterChanged(String newFilter) {

    if (newFilter == chosenFilter) {
      // newFilter = '';
      return;
    }

    setState(() { chosenFilter = newFilter; });

    getFilteredContactsForLocation(currentLocation);
  }

  Future refreshContacts() async {
  }

  Future _loadMoreContacts() async {

  }

  Future<void> callNumberAndSaveFeedback(ContactModel model) async {

    print(model.contactNumber);

    final diff = await callHelper.callAndGetDuration(model.contactNumber);
    showFeedbackBottomSheet(
      context,
        (feedback) {
        // TODO: Update online database
        print(feedback);
        insertRecordToDatabase(null, model, chosenFilter);

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
          padding: EdgeInsets.fromLTRB(30, 0, 20, 0),
          scrollDirection : Axis.horizontal,
          child           : Row(
            crossAxisAlignment : CrossAxisAlignment.center,
            mainAxisAlignment  : MainAxisAlignment.start,
            children           : List<Widget>.generate(widget.resources.length, (index) {

              return Container(
                padding : EdgeInsets.fromLTRB(0, 0, 10, 0),
                child   : TextButton(
                  style     : TextButton.styleFrom(
                    primary         : chosenFilter == widget.resources[index].id ? Colors.white : primaryColor,
                    backgroundColor : chosenFilter == widget.resources[index].id ? primaryColor : Colors.white,
                    onSurface       : Colors.grey,
                    side            : BorderSide(color: primaryColor, width: 0.5),
                    padding         : EdgeInsets.fromLTRB(15, 0, 15, 0),
                  ),
                  onPressed : () { filterChanged(widget.resources[index].id); },
                  child     : Text(widget.resources[index].name, style: TextStyle(fontWeight: chosenFilter == widget.resources[index].id ? FontWeight.bold : FontWeight.normal, fontSize: 13),)
                ),
              );
            }),
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
