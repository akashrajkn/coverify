import 'package:flutter/material.dart';

import 'package:coverify/constants.dart';
import 'package:coverify/models/location.dart';
import 'package:coverify/theme.dart';


Widget appBarCommon(LocationModel location, Function callback, bool showLocation, Function showMoreSheet) {

  return AppBar(
    elevation                 : 0,
    backgroundColor           : Colors.white,
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


Widget appBarTabs(
    LocationModel location,
    Function      changeLocation,
    Function      showMoreSheet,
    TabController controller,
    List<Widget>  tabs,
    String        displayText,
  ) {

  return PreferredSize(
    preferredSize : Size.fromHeight(130),
    child         : AppBar(
      elevation                 : 4,
      backgroundColor           : Colors.white,
      automaticallyImplyLeading : false,
      flexibleSpace             : SafeArea(
        child: Column(
          mainAxisAlignment  : MainAxisAlignment.start,
          crossAxisAlignment : CrossAxisAlignment.center,
          children           : [
            Container(
              padding : EdgeInsets.fromLTRB(20, 10, 20, 0),
              child   : Row(
                mainAxisAlignment  : MainAxisAlignment.center,
                crossAxisAlignment : CrossAxisAlignment.center,
                mainAxisSize       : MainAxisSize.min,
                children           : [
                  Padding(
                    padding : EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child   : Image.asset(withoutNameLogoPath, height: 35,),
                  ),
                  Text('coverify', style : TextStyle(color: primaryColor, fontWeight: FontWeight.w500, fontSize: 20),),
                  Spacer(),
                  location.name == '' ? Container() : InkWell(
                    child : Padding(
                      padding : EdgeInsets.fromLTRB(10, 0, 10, 0),

                      child   : Row(
                        mainAxisSize       : MainAxisSize.min,
                        mainAxisAlignment  : MainAxisAlignment.center,
                        crossAxisAlignment : CrossAxisAlignment.center,

                        children           : [
                          Icon(Icons.location_on, color: Colors.grey, size : 17),
                          Text(location.name, style: TextStyle(color: Colors.grey[600], fontSize: 15),),
                        ],
                      ),
                    ),
                    onTap : () { changeLocation(); },
                  ),
                  InkWell(
                    child: Padding(
                      padding : EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child   : Icon(Icons.more_vert_rounded, color: Colors.grey),
                    ),
                    onTap   : () { showMoreSheet(); },
                  ),
                ],
              ),
            ),
            Container(
              padding : EdgeInsets.fromLTRB(20, 15, 20, 0),
              child   : Row(
                mainAxisAlignment  : MainAxisAlignment.start,
                crossAxisAlignment : CrossAxisAlignment.center,
                mainAxisSize       : MainAxisSize.min,

                children           : [
                  Text(displayText, style: TextStyle(color: primaryColor, fontSize: 14),),
                  Spacer(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottom : tabs == null ? null : TabBar(
        labelPadding: EdgeInsets.fromLTRB(20, 0, 20, 0),
        isScrollable   : true,
        indicatorColor : Colors.green,
        labelColor     : primaryColor,
        controller     : controller,
        tabs           : tabs
      ),
    ),
  );
}