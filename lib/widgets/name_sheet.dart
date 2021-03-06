import 'package:flutter/material.dart';

void showNameBottomSheet(BuildContext context, String displayName, Function callback) {

  showModalBottomSheet<dynamic>(
    isDismissible      : false,
    isScrollControlled : true,
    context            : context,
    builder            : (context) {
      String enteredName = displayName;

      return Wrap(
        children: <Widget>[

          Container(
            color : Colors.white,
            child : Container(
              padding    : EdgeInsets.fromLTRB(20, 20, 10, 5),
              decoration : BoxDecoration(
                color : Theme.of(context).canvasColor,
              ),

              child      : Text('Enter name of the contact', style: TextStyle(color: Colors.grey, fontSize: 15),),
            ),
          ),
          Container(
            child   : Container(
              padding : EdgeInsets.fromLTRB(20, 0, 20, 5),
              decoration : BoxDecoration(
                color : Theme.of(context).canvasColor,
              ),
              child      : Column(
                mainAxisAlignment   : MainAxisAlignment.start,
                crossAxisAlignment  : CrossAxisAlignment.start,

                children            : [
                  TextField(
                    autofocus       : true,
                    decoration      : InputDecoration(hintText : 'Name ...',),
                    controller      : TextEditingController(text: displayName),
                    style           : TextStyle( fontSize : 18,),
                    onChanged       : (text) { enteredName = text; },
                    textInputAction : TextInputAction.done,
                    onSubmitted     : (text) {
                      if (text.isNotEmpty) {
                        Navigator.pop(context);
                        callback(text);
                      }
                    },
                  ),
                  SizedBox(height: 10,),
                  SizedBox(
                    width  : double.infinity,
                    height : 45,

                    child  : TextButton(
                      style     : TextButton.styleFrom(
                        primary         : Colors.white,
                        backgroundColor : Colors.green,
                        onSurface       : Colors.grey,
                        side            : BorderSide(color: Colors.green, width: 0.5),
                        padding         : EdgeInsets.fromLTRB(15, 0, 15, 0),
                      ),
                      onPressed : () {
                        if (enteredName.isNotEmpty) {
                          Navigator.pop(context);
                          callback(enteredName);
                        }
                      },
                      child     : Text('Add contact', style: TextStyle(fontSize: 19),),
                    ),
                  ),
                  SizedBox(height: 30,),
                ],
              ),
            ),
          ),
        ],
      );
    },
  );
}
