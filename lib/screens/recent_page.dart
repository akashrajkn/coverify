import 'package:flutter/material.dart';

import 'package:coverify/models/contact.dart';
import 'package:coverify/models/resource.dart';
import 'package:coverify/theme.dart';
import 'package:coverify/utils/db.dart';
import 'package:coverify/widgets/contact_card.dart';


class RecentPage extends StatefulWidget {

  final List<ResourceModel> resources;
  final TabController tabController;
  RecentPage({Key key, this.resources, this.tabController}) : super(key: key);

  @override
  _RecentPageState createState() => _RecentPageState();
}


class _RecentPageState extends State<RecentPage> {

  var recentCalls;
  ResourceModel currentResource;
  bool isLoading              = true;
  var recentCallsList         = [];
  var recentCallsListFiltered = [];
  bool readyToDisplay         = false;

  @override
  void initState() {

    widget.tabController.addListener(() {
      if (widget.tabController.indexIsChanging) {
        print('index changing');
      } else {
        filterChanged(widget.resources[widget.tabController.index]);
      }
    });

    if (widget.resources.length > 0) {
      readyToDisplay  = true;
      currentResource = widget.resources[0];
      openDatabaseAndFetchRecords();
    }

    super.initState();
  }

  @override
  void setState(fn) {
    if(mounted) {
      super.setState(fn);
    }
  }

  Future<void> openDatabaseAndFetchRecords() async {

    var db      = await getCoverifyDatabase();
    recentCalls = await fetchRecentCallsFromDatabase(db) ?? [];
    List<ContactModel> tempCalls = [];

    for (int i = 0; i < recentCalls.length; i++) {

      tempCalls.add(ContactModel(
        name              : recentCalls[i]['name'],
        contactNumber     : recentCalls[i]['contactNumber'],
        lastActivity      : recentCalls[i]['calledTime'],
        counts            : {
          recentCalls[i]['category'] : {
            'helpfulCount'      : recentCalls[i]['helpfulCount'],
            'unresponsiveCount' : recentCalls[i]['unresponsiveCount'],
            'outOfStockCount'   : recentCalls[i]['outOfStockCount'],
            'invalidCount'      : recentCalls[i]['notWorkingCount'],
          }
        },
        lastState         : recentCalls[i]['state'] ?? 'unknown',
        resourceID        : recentCalls[i]['category'].split(','),
      ));
    }

    setState(() {
      isLoading       = false;
      recentCallsList = tempCalls;
    });

    filterChanged(currentResource);
  }

  void filterChanged(ResourceModel newFilter) {

    List<ContactModel> tempCalls = [];
    for (int i = 0; i < recentCallsList.length; i++) {
      if (recentCallsList[i].resourceID[0] == newFilter.id) {
        tempCalls.add(recentCallsList[i]);
      }
    }

    setState(() {
      currentResource         = newFilter;
      recentCallsListFiltered = tempCalls;
    });
  }

  @override
  Widget build(BuildContext context) {

    return !readyToDisplay ? Container() : Column(
      mainAxisAlignment : MainAxisAlignment.start,

      children          : <Widget>[
        isLoading ? Container(
          padding : EdgeInsets.fromLTRB(0, 20, 0, 0),
          child   : CircularProgressIndicator(),
        ) : Container(),
        isLoading ? Container() : recentCallsListFiltered.length == 0 ? Expanded(

          child : ListView(

            children : [
              SizedBox(height: 100,),
              Icon(Icons.call_end_rounded, color: Colors.grey, size: 100,),
              Container(
                padding : EdgeInsets.fromLTRB(20, 20, 20, 10),
                child   : Text('No numbers dialled recently for ${currentResource.name}.', style: TextStyle(fontSize: 20, color: primaryColor), textAlign: TextAlign.center,),
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
                    onPressed : () { },
                    child     : Text('Find a contact', style: TextStyle(fontSize: 19),),
                  ),
                ),
              ),
            ],
          ),
        ) : Expanded(
          child: ListView.builder(
            padding     : EdgeInsets.all(10),
            shrinkWrap  : true,
            itemCount   : recentCallsListFiltered.length,
            itemBuilder : (context, index) {
              return contactCardWidget(recentCallsListFiltered[index], (_) {}, currentResource.id);
            },
          ),
        ),
      ],
    );
  }
}
