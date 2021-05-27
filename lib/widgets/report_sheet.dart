import 'package:flutter/material.dart';

import 'package:coverify/models/contact.dart';
import 'package:coverify/models/location.dart';
import 'package:coverify/models/resource.dart';
import 'package:coverify/theme.dart';


Future<void> showReportBottomSheet(BuildContext context, LocationModel locationModel, ResourceModel resourceModel, ContactModel contactModel, Function callback) async {

  showModalBottomSheet<dynamic>(
      isScrollControlled : false,
      context            : context,
      builder            : (context) {

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
                      decoration : BoxDecoration(
                        color  : Colors.grey[100],
                        border : Border(
                          bottom: BorderSide(width: 1, color: Colors.grey)
                        ),
                      ),
                      width      : double.infinity,
                      padding    : EdgeInsets.fromLTRB(20, 20, 20, 20),
                      child      : Column(
                        mainAxisAlignment  : MainAxisAlignment.center,
                        crossAxisAlignment : CrossAxisAlignment.center,
                        mainAxisSize       : MainAxisSize.min,

                        children           : [
                          Row(
                            mainAxisAlignment  : MainAxisAlignment.start,
                            crossAxisAlignment : CrossAxisAlignment.center,

                            children           : [
                              InkWell(
                                child : Icon(Icons.arrow_back_ios_rounded, color: primaryColor,),
                                onTap : () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              Spacer(),
                              Icon(Icons.location_on, color: Colors.grey, size : 18),
                              SizedBox(width: 5,),
                              Text(locationModel.name, style: TextStyle(color: Colors.grey[600], fontSize: 15),),
                            ],
                          ),
                          SizedBox(height: 20,),
                          Row(
                            mainAxisAlignment  : MainAxisAlignment.start,
                            crossAxisAlignment : CrossAxisAlignment.center,

                            children           : [
                              Icon(Icons.flag_rounded, color: primaryColor,),
                              SizedBox(width: 5,),
                              Text('Report', style: TextStyle(color: primaryColor, fontSize: 17),),
                              Spacer(),
                              Text(resourceModel.name, style: TextStyle(color: primaryColor, fontSize: 17, fontWeight: FontWeight.bold),),
                            ],
                          ),
                          SizedBox(height: 20,),
                          Row(
                            mainAxisAlignment  : MainAxisAlignment.start,
                            crossAxisAlignment : CrossAxisAlignment.center,

                            children           : [
                              Text(contactModel.name, style: TextStyle(color: primaryColor, fontSize: 17),),
                              Spacer(),
                              Text(contactModel.contactNumber, style: TextStyle(color: Colors.grey, fontSize: 17),),
                            ],
                          ),
                        ],
                      ),
                    ),
                    ListTile(
                      title   : Text('Scam & cheating', style: TextStyle(color: Colors.black),),
                      onTap   : () {
                        Navigator.pop(context);
                        callback();
                      },
                    ),
                    ListTile(
                      title   : Text('Selling at higher prices', style: TextStyle(color: Colors.black),),
                      onTap   : () {
                        Navigator.pop(context);
                        callback();
                      },
                    ),
                    ListTile(
                      title   : Text('Other', style: TextStyle(color: Colors.black),),
                      onTap   : () {
                        Navigator.pop(context);
                        callback();
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
