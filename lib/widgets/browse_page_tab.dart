import 'package:coverify/widgets/report_sheet.dart';
import 'package:coverify/widgets/snackbar.dart';
import 'package:flutter/material.dart';

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


class BrowsePageTab extends StatefulWidget {

  final LocationModel location;
  final List<ResourceModel> resources;
  final int whichResourceIndex;
  final Map<String, String> info;

  BrowsePageTab({this.location, this.resources, this.whichResourceIndex, this.info});

  @override
  _BrowsePageTabState createState() => _BrowsePageTabState(location);
}


class _BrowsePageTabState extends State<BrowsePageTab> {

  _BrowsePageTabState(this.currentLocation);

  LocationModel currentLocation;
  ResourceModel currentResource;
  int    offset          = 0;
  var contactsList       = [];
  bool isLoading         = true;
  bool isLazyLoading     = false;
  bool showErrorWidget   = false;

  Map<String, dynamic> contactsByFilter = {};
  CallHelper callHelper  = CallHelper();

  @override
  void initState() {

    currentResource = widget.resources[widget.whichResourceIndex];

    if (currentLocation != null && currentLocation.id.isNotEmpty) {
      getFilteredContactsForLocation(currentLocation);
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

    print('get location contacts');
    setState(() {
      isLoading       = true;
      currentLocation = whichLocation;
    });

    var response = await callFilterContactsEndpoint(whichLocation, currentResource, 0, widget.info['imei']);
    if (response['request'] == 'error') {
      setState(() {
        showErrorWidget = true;
        isLoading       = false;
      });
      return;
    }

    setState(() {
      isLoading    = false;
      contactsList = response['contacts'];
    });
  }

  void locationUpdated(LocationModel newLocation) {
    print('location updated from browse page');
    getFilteredContactsForLocation(newLocation);
  }

  Future refreshContacts() async {
    setState(() {
      offset          = 0;
      showErrorWidget = false;
    });
    getFilteredContactsForLocation(currentLocation);
  }

  Future _loadMoreContacts() async {

    setState(() { isLazyLoading = true; });

    int newOffset = offset + 1;
    var response  = await callFilterContactsEndpoint(currentLocation, currentResource, newOffset, widget.info['imei']);
    if (response['request'] == 'error') {
      Navigator.of(context).pushReplacementNamed(errorRoute, arguments: response['error']);
    }

    setState(() {
      if (response['contacts'].length > 0) { offset = newOffset; }
      contactsList  = contactsList + response['contacts'];
      isLazyLoading = false;
    });

    print('DONE LOADING NEW STUFF');
  }

  void showSnackBarAndCallReportAPI(String feedback, ContactModel model) {
    final snackBar = numberReportSnackBar(feedback);
    ScaffoldMessenger.of(context).showSnackBar(snackBar)
        .closed
        .then((value) {
      if (value == SnackBarClosedReason.timeout || value == SnackBarClosedReason.swipe) {
        callReportContactURL(model.contactNumber, true, currentResource.id, feedback, '', '', widget.info['imei'])
            .then((value) {
          print('report api response');
          print(value);
        });
        insertRecordToDatabase(null, model, currentResource.id);
      } else if (value == SnackBarClosedReason.action) {
        showSnackBarFlow(model);
      }
    });
  }

  void showSnackBarFlow(ContactModel model) {
    showFeedbackBottomSheet(
      context,
          (feedback) {
        print(feedback);

        // TODO: Weird flow - fix it
        if (feedback == 'report') {
          showReportBottomSheet(context, currentLocation, currentResource, model, () {
            showSnackBarAndCallReportAPI(feedback, model);
          });
        } else {
          showSnackBarAndCallReportAPI(feedback, model);
        }
      },
    );
  }

  Future<void> callNumberAndSaveFeedback(ContactModel model) async {

    print(model.contactNumber);
    final diff = await callHelper.callAndGetDuration(model.contactNumber);
    showSnackBarFlow(model);
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      mainAxisAlignment : MainAxisAlignment.start,

      children          : <Widget>[
        isLoading ? Container(
          padding : EdgeInsets.fromLTRB(0, 200, 0, 0),
          child   : CircularProgressIndicator(
            backgroundColor : Colors.green,
            valueColor      : AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ) : showErrorWidget ? Container() : contactsList.length == 0 ? Expanded(

          child : ListView(
            children : [
              SizedBox(height: 100,),
              Icon(Icons.block_rounded, color: Colors.grey, size: 100,),
              Container(
                padding : EdgeInsets.fromLTRB(20, 20, 20, 10),
                child   : Text('No contacts available for ${currentResource.name} in ${currentLocation.name}.', style: TextStyle(fontSize: 20, color: primaryColor), textAlign: TextAlign.center,),
              ),
              Container(
                padding : EdgeInsets.fromLTRB(20, 10, 20, 0),
                child   : Text('Please check back later.', style: TextStyle(fontSize: 20, color: primaryColor), textAlign: TextAlign.center,),
              ),
            ],
          ),
        ) : Expanded(

          child: LazyLoadScrollView(
            isLoading       : isLazyLoading,
            onEndOfPage     : () => _loadMoreContacts(),
            scrollOffset    : 100,
            child           : RefreshIndicator(
              onRefresh       : refreshContacts,
              backgroundColor : Colors.green,
              color           : Colors.white,
              child           : ListView.builder(
                padding     : EdgeInsets.all(10),
                shrinkWrap  : true,
                itemCount   : contactsList.length,
                itemBuilder : (context, index) {
                  return contactCardWidget(contactsList[index], callNumberAndSaveFeedback, currentResource.id);
                },
              ),
            ),
          ),
        ),
        !showErrorWidget ? Container() : Expanded(
          child: ListView(

            children : [
              SizedBox(height: 100,),
              Icon(Icons.refresh_rounded, color: Colors.grey, size: 100,),
              Container(
                padding : EdgeInsets.fromLTRB(20, 20, 20, 10),
                child   : Text('There was a problem getting contacts.', style: TextStyle(fontSize: 20, color: primaryColor), textAlign: TextAlign.center,),
              ),
              Container(
                padding : EdgeInsets.fromLTRB(20, 10, 20, 0),
                child   : SizedBox(
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
                    onPressed : () { refreshContacts(); },
                    child     : Text('Try again', style: TextStyle(fontSize: 19),),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
