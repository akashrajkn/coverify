import 'package:flutter/material.dart';

import 'package:coverify/theme.dart';


Widget dialButton(String number, Function callback) {

  return RawMaterialButton(
    onPressed : () { callback(number); },
    elevation : 2.0,
    fillColor : Colors.grey[100],

    child     : Text(number, style: TextStyle(fontSize: 35, color: primaryColor),),
    padding   : EdgeInsets.all(10),
    shape     : CircleBorder()
  );
}

Widget callButton(Function callback) {
  return RawMaterialButton(
      onPressed : () { callback(); },
      elevation : 2.0,
      fillColor : Colors.green,

      child     : Icon(Icons.call, color: Colors.white, size: 38,),
      padding   : EdgeInsets.all(10),
      shape     : CircleBorder()
  );
}

Widget backButton(Function callback) {
  return RawMaterialButton(
      onPressed : () { callback(); },
      elevation : 2.0,
      fillColor : Colors.grey[100],

      child     : Icon(Icons.backspace_rounded, color: Colors.grey[600], size: 32,),
      padding   : EdgeInsets.all(15),
      shape     : CircleBorder()
  );
}
