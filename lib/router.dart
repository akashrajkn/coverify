import 'package:coverify/screens/error.dart';
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

      case errorRoute:
        String args = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => ErrorScreen(args));

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}.\n Please restart the app')),
          ));
    }
  }
}