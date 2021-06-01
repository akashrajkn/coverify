import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:coverify/constants.dart';
import 'package:coverify/router.dart' as router;
import 'package:coverify/theme.dart';
import 'package:coverify/utils/db.dart';


Future<bool> sharedPrefsShowTerms() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool agreedTerms = prefs.getBool('agreed_terms') ?? false;

  return agreedTerms;
}

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await checkAndCreateDatabase();

  var infoStartup = { 'show_terms' : !(await sharedPrefsShowTerms()) };
  runApp(CoVerify(infoStartup));
}

class CoVerify extends StatelessWidget {

  final infoStartup;
  CoVerify(this.infoStartup);

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title           : 'CoVerify',
      theme           : ThemeData(primarySwatch: primaryColorMaterial,),
      initialRoute    : infoStartup['show_terms'] ? onBoardingRoute : homeRoute,
      onGenerateRoute : router.Router.generateRoute,
    );
  }
}
