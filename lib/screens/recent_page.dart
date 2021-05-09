import 'package:flutter/material.dart';

import 'package:coverify/models/contact.dart';
import 'package:coverify/utils/db.dart';
import 'package:coverify/widgets/contact_card.dart';


class RecentPage extends StatefulWidget {

  RecentPage({Key key}) : super(key: key);

  @override
  _RecentPageState createState() => _RecentPageState();
}


class _RecentPageState extends State<RecentPage> {

  bool isLoading         = true;
  var recentCalls;
  String chosenFilter    = '';
  var recentCallsList    = [];

  @override
  void initState() {

    openDatabaseAndFetchRecords();
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

    return Column(
      mainAxisAlignment : MainAxisAlignment.start,

      children          : <Widget>[
        Text(''),
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
