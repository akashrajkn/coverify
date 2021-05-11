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
  String chosenFilter    = '';
  int    offset          = 0;
  var contactsList       = [];
  bool isLoading         = true;
  bool isLazyLoading     = false;
  bool readyToDisplay    = false;

  Map<String, dynamic> contactsByFilter = {};

  CallHelper callHelper  = CallHelper();

  @override
  void initState() {

    if (widget.resources.length > 0 && widget.resources.length > 0) {
      readyToDisplay = true;
      chosenFilter   = widget.resources[0].id;

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

    setState(() { isLoading = true; });

    ResourceModel whichResource = widget.resources.firstWhere((element) => element.id == chosenFilter, orElse: () { return null; });
    var response                = await callFilterContactsEndpoint(whichLocation, whichResource, 0, widget.info['imei']);
    if (response['request'] == 'error') {
      Navigator.of(context).pushReplacementNamed(errorRoute, arguments: response['error']);
    }

    setState(() {
      isLoading       = false;
      contactsList    = response['contacts'];
      currentLocation = whichLocation;
      currentResource = whichResource;
    });
  }

  void locationUpdated(LocationModel newLocation) {
    print('location updated from browse page');
    getFilteredContactsForLocation(newLocation);
  }

  void filterChanged(String newFilter) {

    if (newFilter == chosenFilter) { return; }

    setState(() {
      chosenFilter = newFilter;
      offset       = 0;
    });
    getFilteredContactsForLocation(currentLocation);
  }

  Future refreshContacts() async {
    setState(() { offset = 0; });
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
            callReportContactURL(model.contactNumber, true, chosenFilter, feedback, '', '', widget.info['imei'])
            .then((value) {
              print('report api response');
              print(value);
            });
            insertRecordToDatabase(null, model, chosenFilter);
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
        ) : contactsList.length == 0 ? Expanded(

          child : Column(
            mainAxisAlignment  : MainAxisAlignment.center,
            crossAxisAlignment : CrossAxisAlignment.center,

            children           : [
              Icon(Icons.block_rounded, color: Colors.grey, size: 100,),
              Container(
                padding : EdgeInsets.fromLTRB(20, 20, 20, 10),
                child   : Text('No contacts available for $chosenFilter in ${widget.location.name}.', style: TextStyle(fontSize: 26), textAlign: TextAlign.center,),
              ),
              Container(
                padding : EdgeInsets.fromLTRB(20, 10, 20, 0),
                child   : Text('Please check back later.', style: TextStyle(fontSize: 26), textAlign: TextAlign.center,),
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
