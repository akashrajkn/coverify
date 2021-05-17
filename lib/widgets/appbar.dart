import 'package:flutter/material.dart';

import 'package:coverify/constants.dart';
import 'package:coverify/models/location.dart';
import 'package:coverify/theme.dart';


Widget appBarCommon(LocationModel location, Function callback, bool showLocation, Function showMoreSheet) {

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

          child   : Image.asset(withoutNameLogoPath, height: 35,),
        ),
        Text(
          'coverify',
          style : TextStyle(color: primaryColor),
        )
      ],
    ),
    actions: [
      !showLocation ? Container() : InkWell(

        child : Padding(
          padding : EdgeInsets.fromLTRB(10, 0, 10, 0),

          child   : Row(
            mainAxisSize       : MainAxisSize.min,
            mainAxisAlignment  : MainAxisAlignment.center,
            crossAxisAlignment : CrossAxisAlignment.center,

            children           : [
              Icon(Icons.location_on, color: Colors.grey, size : 20),
              Text(
                location.name,
                style: TextStyle(color: primaryColorMaterial[500]),
              )
            ],
          )
        ),
        onTap : () { callback(); },
      ),
      InkWell(
        child: Padding(
          padding : EdgeInsets.fromLTRB(10, 0, 15, 0),
          child   : Icon(Icons.more_vert_rounded, color: Colors.grey),
        ),
        onTap   : () { showMoreSheet(); }
      ),
    ],
  );
}
