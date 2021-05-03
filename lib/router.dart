import 'package:flutter/material.dart';

import 'package:coverify/constants.dart';
import 'package:coverify/screens/home.dart';


class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    print("----------------------------");
    print(settings.name);
    print("----------------------------");

    switch (settings.name) {

      case homeRoute:
        return MaterialPageRoute(builder: (_) => HomeScreen());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}.\n Please restart the app')),
          ));
    }
  }
}