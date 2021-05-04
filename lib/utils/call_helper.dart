import 'dart:async';

import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:phonecallstate/phonecallstate.dart';


enum PhonecallState { incoming, dialing, connected, disconnected, none }
enum PhonecallStateError { notimplementedyet }

class CallHelper {
  Phonecallstate phonecallstate;
  PhonecallState phonecallstatus;
  DateTime connectedTime;
  DateTime disconnectedTime;

  Future callAndGetDuration(String number) {
    Completer c = new Completer();
    print("Phonecallstate init");

    phonecallstate = new Phonecallstate();
    phonecallstatus = PhonecallState.none;

    phonecallstate.setConnectedHandler(() {
      print("connected");
      connectedTime = DateTime.now();
    });

    phonecallstate.setDisconnectedHandler(() {
      print("disconnected");
      if(connectedTime != null) {
        disconnectedTime = DateTime.now();
        var diff = disconnectedTime.difference(connectedTime);
        print(diff.inSeconds);
        c.complete(diff.inSeconds);
      }
    });

    phonecallstate.setErrorHandler((msg) {});

    FlutterPhoneDirectCaller.callNumber(number);
    return c.future;
  }
}
