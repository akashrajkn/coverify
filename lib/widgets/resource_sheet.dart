import 'package:flutter/material.dart';

import 'package:coverify/models/resource.dart';


void showResourcesBottomSheet(BuildContext context, List<ResourceModel> resources, Function callback) {

  showModalBottomSheet<dynamic>(
    isDismissible      : false,
    isScrollControlled : true,
    context            : context,
    builder            : (context) {

      return Wrap(
        children: <Widget>[
          Container(
            color : Colors.white,
            child : Container(
              padding    : EdgeInsets.fromLTRB(20, 20, 10, 5),
              // width      : 1500,
              decoration : BoxDecoration(
                color : Theme.of(context).canvasColor,
              ),

              child      : Text('For what did you call this number?', style: TextStyle(color: Colors.grey),),
            ),
          ),
          Container(
            color : Color(0xff737373),
            child : Container(
              decoration : BoxDecoration(
                color : Theme.of(context).canvasColor,
              ),
              child      : Column(
                mainAxisAlignment  : MainAxisAlignment.start,
                crossAxisAlignment : CrossAxisAlignment.start,

                children           : List<Widget>.generate(resources.length, (index) {
                  return ListTile(
                    title   : Text(resources[index].name, style: TextStyle(color: Colors.black),),
                    onTap   : () {
                      Navigator.pop(context);
                      callback(resources[index].id);
                    },
                  );
                }),
              )
            ),
          )
        ],
      );
    }
  );
}
