import 'package:flutter/material.dart';

import 'package:coverify/models/contact.dart';
import 'package:coverify/models/resource.dart';
import 'package:coverify/theme.dart';
import 'package:coverify/utils/db.dart';
import 'package:coverify/widgets/contact_card.dart';


class RecentPage extends StatefulWidget {

  final List<ResourceModel> resources;
  RecentPage({Key key, this.resources}) : super(key: key);

  @override
  _RecentPageState createState() => _RecentPageState();
}


class _RecentPageState extends State<RecentPage> {

  bool isLoading         = true;
  var recentCalls;
  String chosenFilter    = '';
  var recentCallsList    = [];
  bool readyToDisplay    = false;

  @override
  void initState() {

    if (widget.resources.length > 0) {
      readyToDisplay = true;
      chosenFilter   = widget.resources[0].id;
      openDatabaseAndFetchRecords();
    }

    super.initState();
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
          resourceID        : recentCalls[i]['category'].split(',')
      ));
    }

    setState(() {
      isLoading       = false;
      recentCallsList = tempCalls;
    });
  }

  void filterChanged(String newFilter) {

    if (newFilter == chosenFilter) {
      newFilter = '';
    }

    setState(() { chosenFilter = newFilter; });
  }

  @override
  Widget build(BuildContext context) {

    return !readyToDisplay ? Container() : Column(
      mainAxisAlignment : MainAxisAlignment.start,

      children          : <Widget>[
        Text(''),
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
        ) : Container(),
        isLoading ? Container() : Expanded(
          child: ListView.builder(
            padding     : EdgeInsets.all(10),
            shrinkWrap  : true,
            itemCount   : recentCallsList.length,
            itemBuilder : (context, index) {
              return contactCardWidget(recentCallsList[index], (_) {}, chosenFilter);
            },
          ),
        ),
      ],
    );
  }
}
