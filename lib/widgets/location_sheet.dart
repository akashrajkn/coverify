import 'package:flutter/material.dart';


void showLocationBottomSheet(BuildContext context, dynamic locationList, Function callback) {

  showModalBottomSheet(
    context : context,
    builder : (context) {

      return Container(
        color : Color(0xff737373),
        child : Container(
          decoration : BoxDecoration(
            color: Theme.of(context).canvasColor,
            // borderRadius: BorderRadius.only(
            //   topLeft: Radius.circular(30),
            //   topRight: Radius.circular(30)
            // ),
          ),
          child      : ListView.builder(
            itemCount   : locationList.length,
            itemBuilder : (BuildContext _context, int index) {

              if (index == 0) {
                return ListTile(
                  leading : Icon(Icons.location_on),
                  title   : Text('Select your location to view contacts', style: TextStyle(color: Colors.grey[600]),)
                );
              }

              return ListTile(
                title   : Text(locationList[index]),
                onTap   : () {
                  print(locationList[index]);
                  callback(locationList[index]);
                  Navigator.pop(context);
                },
              );
            },
          )
        ),
      );
    }
  );
}
