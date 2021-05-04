import 'package:flutter/material.dart';

import 'package:coverify/models/contact_card.dart';
import 'package:coverify/utils/pretty.dart';


Widget contactCardWidget(ContactCardModel model, Function callback) {

  String title    = model.name;
  String subtitle = model.contactNumber;

  if (title.isEmpty) {
    title    = subtitle;
    subtitle = '';
  }

  List<Color> colorsList = [Colors.grey, Colors.grey, Colors.grey, Colors.grey];
  String      stateText  = '';
  Color       stateTextColor;

  switch (model.state) {
    case 'helpful':
      colorsList[0]  = Colors.green;
      stateText      = 'helpful';
      stateTextColor = Colors.green;
      break;

    case 'unresponsive':
      colorsList[1]  = Colors.red;
      stateText      = 'unresponsive';
      stateTextColor = Colors.red;
      break;

    case 'out_of_stock':
      colorsList[2]  = Colors.orange;
      stateText      = 'out of stock';
      stateTextColor = Colors.orange;
      break;

    case 'not_working':
      colorsList[3]  = Colors.black;
      stateText      = 'not working';
      stateTextColor = Colors.black;
      break;
  }
  
  return Card(
    elevation : 0,

    child     : InkWell(
      onTap : () { callback(model.contactNumber); },

      child : Column(
        mainAxisSize : MainAxisSize.min,

        children     : <Widget>[
          ListTile(
            title    : Text(title, overflow: TextOverflow.ellipsis,),
            subtitle : Text(subtitle),
            trailing : Text(prettifyTimeForCard(model.lastActivity), style: TextStyle(color: Colors.grey),),
          ),
          Row(
            mainAxisAlignment : MainAxisAlignment.start,

            children          : <Widget>[
              SizedBox(width: 17,),
              Icon(Icons.thumb_up, size: 20, color: colorsList[0]),
              SizedBox(width: 3,),
              Text(prettifyNumberForCard(model.helpfulCount), style: TextStyle(color: colorsList[0]),),
              SizedBox(width: 15,),
              Icon(Icons.phone_missed, size: 20, color: colorsList[1],),
              SizedBox(width: 3,),
              Text(prettifyNumberForCard(model.unresponsiveCount), style: TextStyle(color: colorsList[1]),),
              SizedBox(width: 15,),
              Icon(Icons.shopping_cart_outlined, size: 20, color: colorsList[2]),
              SizedBox(width: 3,),
              Text(prettifyNumberForCard(model.outOfStockCount), style: TextStyle(color: colorsList[2]),),
              SizedBox(width: 15,),
              Icon(Icons.block, size: 20, color: colorsList[3],),
              SizedBox(width: 3,),
              Text(prettifyNumberForCard(model.notWorkingCount), style: TextStyle(color: colorsList[3]),),
              Spacer(),
              Container(
                padding : EdgeInsets.fromLTRB(0, 0, 16, 0),
                child   : Text(stateText, style: TextStyle(color: stateTextColor),),
              )
            ],
          ),
          SizedBox(height: 15,),
          Container(
            decoration : BoxDecoration(
                border : Border(bottom: BorderSide(color: Colors.grey[300]))
            ),
          ),
        ],
      ),
    ),
  );
}
