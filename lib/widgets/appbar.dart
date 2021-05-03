import 'package:flutter/material.dart';

import 'package:coverify/constants.dart';
import 'package:coverify/theme.dart';


Widget appBarCommon(String location, Function callback) {

  return AppBar(
    elevation                 : 0,
    backgroundColor           : Colors.transparent,
    automaticallyImplyLeading : false,
    title                     : Row(
      mainAxisAlignment  : MainAxisAlignment.center,
      crossAxisAlignment : CrossAxisAlignment.center,
      mainAxisSize       : MainAxisSize.min,

      children: [
        Padding(
          padding : EdgeInsets.fromLTRB(10, 0, 10, 0),

          child   : Image.asset(withoutNameLogoPath, height: 30,),
        ),
        Text(
          'coverify',
          style : TextStyle(color: primaryColor),
        )
      ],
    ),
    actions: [
      InkWell(

        child : Padding(
          padding : EdgeInsets.fromLTRB(10, 0, 25, 0),

          child   : Row(
            mainAxisSize       : MainAxisSize.min,
            mainAxisAlignment  : MainAxisAlignment.center,
            crossAxisAlignment : CrossAxisAlignment.center,

            children           : [
              Icon(Icons.location_on, color: Colors.grey, size : 20),
              Text(
                location,
                style: TextStyle(color: primaryColorMaterial[500]),
              )
            ],
          )
        ),
        onTap : () { callback(); },
      )
    ],
  );
}