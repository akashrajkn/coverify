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


class BrowsePage extends StatefulWidget {

  final LocationModel location;
  final List<ResourceModel> resources;
  final Map<String, String> info;
  BrowsePage({Key key, this.location, this.resources, this.info}) : super(key: key);

  @override
  BrowsePageState createState() => BrowsePageState();
}


class BrowsePageState extends State<BrowsePage> {

  LocationModel currentLocation;
  ResourceModel currentResource;
  int    offset          = 0;
  var contactsList       = [];
  bool isLoading         = true;
  bool isLazyLoading     = false;
  bool readyToDisplay    = false;
  bool showErrorWidget   = false;

  Map<String, dynamic> contactsByFilter = {};

  CallHelper callHelper  = CallHelper();

  @override
  void initState() {

    if (widget.resources.length > 0 && widget.resources.length > 0) {
      readyToDisplay  = true;
      currentResource = widget.resources[0];

      if (widget.location != null && widget.location.id.isNotEmpty) {
        getFilteredContactsForLocation(widget.location);
      }
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

    setState(() {
      isLoading       = true;
      currentLocation = whichLocation;
    });

    var response                = await callFilterContactsEndpoint(whichLocation, currentResource, 0, widget.info['imei']);
    if (response['request'] == 'error') {
      // Navigator.of(context).pushReplacementNamed(errorRoute, arguments: response['error']);
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

  void filterChanged(ResourceModel newFilter) {

    if (newFilter.id == currentResource.id) { return; }

    setState(() {
      currentResource = newFilter;
      offset       = 0;
    });
    getFilteredContactsForLocation(currentLocation);
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

  void showSnackBarFlow(ContactModel model) {
    showFeedbackBottomSheet(
      context,
      (feedback) {
        print(feedback);

        final snackBar = SnackBar(
          duration        : Duration(seconds: 2),
          backgroundColor : feedbackColors[feedback],
          content         : Row(
            mainAxisAlignment  : MainAxisAlignment.center,
            crossAxisAlignment : CrossAxisAlignment.center,

            children           : [
              Icon(feedbackIconData[feedback], color: Colors.white, size: 20,),
              SizedBox(width: 5,),
              Text('Number marked as: $feedback', style: TextStyle(color: Colors.white),)
            ],
          ),
          action          : SnackBarAction(
            label     : 'UNDO',
            textColor : Colors.white,
            onPressed : () { },
          ),
        );
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

    return !readyToDisplay ? Container() : Column(
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
                    primary         : currentResource.id == widget.resources[index].id ? Colors.white : primaryColor,
                    backgroundColor : currentResource.id == widget.resources[index].id ? primaryColor : Colors.white,
                    onSurface       : Colors.grey,
                    side            : BorderSide(color: primaryColor, width: 0.5),
                    padding         : EdgeInsets.fromLTRB(15, 0, 15, 0),
                  ),
                  onPressed : () { filterChanged(widget.resources[index]); },
                  child     : Text(widget.resources[index].name, style: TextStyle(fontWeight: currentResource.id == widget.resources[index].id ? FontWeight.bold : FontWeight.normal, fontSize: 13),)
                ),
              );
            }),
          ),
        ),
        isLoading ? Container(
          padding : EdgeInsets.fromLTRB(0, 20, 0, 0),
          child   : CircularProgressIndicator(),
        ) : showErrorWidget ? Container() : contactsList.length == 0 ? Expanded(

          child : ListView(

            children : [
              SizedBox(height: 100,),
              Icon(Icons.block_rounded, color: Colors.grey, size: 100,),
              Container(
                padding : EdgeInsets.fromLTRB(20, 20, 20, 10),
                child   : Text('No contacts available for ${currentResource.name} in ${currentLocation.name}.', style: TextStyle(fontSize: 26, color: primaryColor), textAlign: TextAlign.center,),
              ),
              Container(
                padding : EdgeInsets.fromLTRB(20, 10, 20, 0),
                child   : Text('Please check back later.', style: TextStyle(fontSize: 26, color: primaryColor), textAlign: TextAlign.center,),
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
              backgroundColor : primaryColor,
              color           : Colors.white,
              child           : ListView.builder(
                padding     : EdgeInsets.all(10),
                shrinkWrap  : true,
                itemCount   : contactsList.length,
                itemBuilder : (context, index) {
                  return contactCardWidget(contactsList[index], callNumberAndSaveFeedback, currentResource.id);
                },
              ),
            )
          ),
        ),
        !showErrorWidget ? Container() : Expanded(
          child: ListView(

            children : [
              SizedBox(height: 100,),
              Icon(Icons.refresh_rounded, color: Colors.grey, size: 100,),
              Container(
                padding : EdgeInsets.fromLTRB(20, 20, 20, 10),
                child   : Text('There was a problem getting contacts.', style: TextStyle(fontSize: 26, color: primaryColor), textAlign: TextAlign.center,),
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
