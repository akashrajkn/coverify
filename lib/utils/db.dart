import 'dart:io';

import 'package:coverify/models/contact_card.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';


Future<dynamic> getCoverifyDatabase() async {
  var databasePath = await getDatabasesPath();
  String filePath  = join(databasePath, 'coverify.db');
  var db           = await openDatabase(filePath);

  return db;
}

Future<void> checkAndCreateDatabase() async {

  var databasePath = await getDatabasesPath();
  String filePath  = join(databasePath, 'coverify.db');
  bool dbExists    = await File(filePath).exists();

  if (dbExists) {
    return;
  }

  print('Creating database now');

  Database database = await openDatabase(filePath, version: 1,
    onCreate: (Database db, int version) async {
      await db.execute('''
          CREATE TABLE RecentCalls (
            _id INTEGER PRIMARY KEY AUTOINCREMENT, 
            contactNumber TEXT,
            name TEXT,
            helpfulCount INTEGER,
            unresponsiveCount INTEGER,
            notWorkingCount INTEGER,
            outOfStockCount INTEGER,
            calledTime TEXT,
            state TEXT,
            category TEXT)
      ''');
    }
  );

  await database.close();
}


Future<dynamic> fetchRecentCallsFromDatabase(Database db) async {

  List<Map> records = await db.rawQuery('SELECT * FROM RecentCalls ORDER BY _id DESC');
  return records;
}


Future<void> insertRecordToDatabase(Database db, ContactCardModel model) async {

  if (db == null) {
    db = await getCoverifyDatabase();
  }

  String contactNumber  = model.contactNumber;
  String name           = model.name;
  int helpfulCount      = model.helpfulCount;
  int unresponsiveCount = model.unresponsiveCount;
  int notWorkingCount   = model.notWorkingCount;
  int outOfStockCount   = model.outOfStockCount;
  String state          = model.state;
  String category       = model.type.join(',').toString();
  DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
  String calledTime     = dateFormat.format(DateTime.now());

  await db.transaction((txn) async {
    int id1 = await txn.rawInsert(
      '''INSERT into RecentCalls(contactNumber, name, helpfulCount, unresponsiveCount, notWorkingCount, outOfStockCount, calledTime, state, category) '''
      '''VALUES("$contactNumber", "$name", $helpfulCount, $unresponsiveCount, $notWorkingCount, $outOfStockCount, "$calledTime", "$state", "$category")'''
    );

    print('INSERT COMPLETE');
  });
}