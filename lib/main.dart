import 'package:flutter/material.dart';

import 'package:coverify/constants.dart';
import 'package:coverify/router.dart' as router;
import 'package:coverify/theme.dart';


Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  var infoStartup = { };
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
      initialRoute    : homeRoute,
      onGenerateRoute : router.Router.generateRoute,
    );
  }
}
