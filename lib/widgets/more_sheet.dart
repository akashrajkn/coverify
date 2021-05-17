import 'package:flutter/material.dart';


void showMoreBottomSheet(BuildContext context) {

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
                    ListTile(
                      leading : Icon(Icons.help_rounded, color: Colors.grey,),
                      title   : Text('How to use coverify', style: TextStyle(color: Colors.black),),
                      onTap   : () {
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading : Icon(Icons.feedback_rounded, color: Colors.grey,),
                      title   : Text('Give feedback', style: TextStyle(color: Colors.black),),
                      onTap   : () {
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading : Icon(Icons.handyman_rounded, color: Colors.grey,),
                      title   : Text('Terms & conditions', style: TextStyle(color: Colors.black),),
                      onTap   : () {
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading : Icon(Icons.lock_rounded, color: Colors.grey,),
                      title   : Text('Privacy policy', style: TextStyle(color: Colors.black),),
                      onTap   : () {
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading : Icon(Icons.info_rounded, color: Colors.grey,),
                      title   : Text('About us', style: TextStyle(color: Colors.black),),
                      onTap   : () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            )
          ],
        );
      }
  );
}
