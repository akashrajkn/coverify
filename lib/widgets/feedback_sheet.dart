import 'package:flutter/material.dart';


void showFeedbackBottomSheet(BuildContext context, Function callback) {

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

                      child   : Text('Please mark the number as', style: TextStyle(color: Colors.grey),),
                    ),
                    ListTile(
                      leading : Icon(Icons.thumb_up, color: Colors.green,),
                      title   : Text('helpful', style: TextStyle(color: Colors.green),),
                      onTap   : () {
                        Navigator.pop(context);
                        callback('helpful');
                      },
                    ),
                    ListTile(
                      leading : Icon(Icons.phone_missed, color: Colors.red,),
                      title   : Text('unresponsive', style: TextStyle(color: Colors.red),),
                      onTap   : () {
                        Navigator.pop(context);
                        callback('unresponsive');
                      },
                    ),
                    ListTile(
                      leading : Icon(Icons.shopping_cart_outlined, color: Colors.orange,),
                      title   : Text('out of stock', style: TextStyle(color: Colors.orange),),
                      onTap   : () {
                        Navigator.pop(context);
                        callback('out_of_stock');
                      },
                    ),
                    ListTile(
                      leading : Icon(Icons.block, color: Colors.black,),
                      title   : Text('invalid', style: TextStyle(color: Colors.black),),
                      onTap   : () {
                        Navigator.pop(context);
                        callback('not_working');
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
