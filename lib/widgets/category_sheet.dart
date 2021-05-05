import 'package:flutter/material.dart';


void showCategoryBottomSheet(BuildContext context, Function callback) {

  showModalBottomSheet<dynamic>(
      isScrollControlled: true,
      context : context,
      builder : (context) {

        return Wrap(
          children: <Widget>[
            Container(
              color : Color(0xff737373),
              child : Container(
                  decoration : BoxDecoration(
                    color : Theme.of(context).canvasColor,
                  ),
                  child      : Column(

                    mainAxisAlignment  : MainAxisAlignment.start,
                    crossAxisAlignment : CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding : EdgeInsets.fromLTRB(20, 20, 10, 5),

                        child   : Text('For what did you call this number?', style: TextStyle(color: Colors.grey),),
                      ),
                      ListTile(
                        title   : Text('Home ICU', style: TextStyle(color: Colors.black),),
                        onTap   : () {
                          callback('home_icu');
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        title   : Text('Plasma', style: TextStyle(color: Colors.black),),
                        onTap   : () {
                          callback('plasma');
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        title   : Text('Oxygen cylinder', style: TextStyle(color: Colors.black),),
                        onTap   : () {
                          callback('oxygen');
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        title   : Text('Injections', style: TextStyle(color: Colors.black),),
                        onTap   : () {
                          callback('injections');
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        title   : Text('Medicines', style: TextStyle(color: Colors.black),),
                        onTap   : () {
                          callback('medicines');
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  )
              ),
            )
          ],
        );
      }
  );
}
