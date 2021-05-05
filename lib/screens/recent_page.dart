import 'package:coverify/utils/db.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';


class RecentPage extends StatefulWidget {

  @override
  _RecentPageState createState() => _RecentPageState();
}


class _RecentPageState extends State<RecentPage> {

  var recentCalls;

  @override
  void initState() {

    openDatabaseAndFetchRecords();
    super.initState();
  }

  Future<void> openDatabaseAndFetchRecords() async {

    var db      = await getCoverifyDatabase();
    recentCalls = await fetchRecentCallsFromDatabase(db);

    print(recentCalls);
  }

  @override
  Widget build(BuildContext context) {

    return Container();
  }
}
