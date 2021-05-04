import 'package:flutter/material.dart';

import 'package:coverify/constants.dart';
import 'package:coverify/theme.dart';
import 'package:coverify/widgets/appbar.dart';
import 'package:coverify/widgets/contact_card.dart';
import 'package:coverify/widgets/location_sheet.dart';


class HomeScreen extends StatefulWidget {

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  String currentLocation;
  var locationList = [];
  String chosenFilter = '';

  @override
  void initState() {

    setState(() {
      currentLocation = 'Dehradun';
      locationList    = ['', 'Ahmedabad', 'Bangalore', 'Chennai', 'Dehradun', 'Ghaziabad', 'Hyderabad', 'NCR', 'Mumbai'];
    });
    super.initState();
  }

  void locationChanged(String newLocation) {
    setState(() {
      currentLocation = newLocation;
    });
  }

  void filterChanged(String newFilter) {
    setState(() {
      chosenFilter = newFilter;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar : appBarCommon(currentLocation, () { showLocationBottomSheet(context, locationList, locationChanged); }),
      body   : Column(
        mainAxisAlignment : MainAxisAlignment.start,

        children          : <Widget>[
          Text('Each contact is updated with the most recent status'),
          SizedBox(height: 20,),
          SingleChildScrollView(
              scrollDirection : Axis.horizontal,
              child           : Row(
                crossAxisAlignment : CrossAxisAlignment.center,
                mainAxisAlignment  : MainAxisAlignment.start,
                children: [
                  SizedBox(width: 20,),
                  OutlinedButton(onPressed: (){ filterChanged('oxygen'); },     child: Text('oxygen', style: TextStyle(fontWeight: chosenFilter == 'oxygen' ? FontWeight.bold : FontWeight.normal),)),
                  SizedBox(width: 10,),
                  OutlinedButton(onPressed: (){ filterChanged('bed'); },        child: Text('bed', style: TextStyle(fontWeight: chosenFilter == 'bed' ? FontWeight.bold : FontWeight.normal),)),
                  SizedBox(width: 10,),
                  OutlinedButton(onPressed: (){ filterChanged('injections'); }, child: Text('injections & medicines', style: TextStyle(fontWeight: chosenFilter == 'injections' ? FontWeight.bold : FontWeight.normal),)),
                  SizedBox(width: 10,),
                  OutlinedButton(onPressed: (){ filterChanged('plasma'); },     child: Text('plasma', style: TextStyle(fontWeight: chosenFilter == 'plasma' ? FontWeight.bold : FontWeight.normal),)),
                  SizedBox(width: 20,),
                ],
              )
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment : MainAxisAlignment.start,

                children          : <Widget>[
                  contactCardWidget(
                      'The Enchanted Forest',
                      '+91 12345 67890',
                      '1974-03-20 00:00:00.000',
                      12456,
                      3,
                      3,
                      0,
                      'not_working'
                  ),
                  contactCardWidget(
                      'The Enchanted Forest',
                      '+91 12345 67890',
                      '1974-03-20 00:00:00.000',
                      12456,
                      3,
                      3,
                      0,
                      'helpful'
                  ),
                  contactCardWidget(
                      'The Enchanted Forest',
                      '+91 12345 67890',
                      '1974-03-20 00:00:00.000',
                      12456,
                      3,
                      3,
                      0,
                      'unresponsive'
                  ),
                  contactCardWidget(
                      'The Enchanted Forest',
                      '+91 12345 67890',
                      '1974-03-20 00:00:00.000',
                      12456,
                      3,
                      3,
                      0,
                      'out_of_stock'
                  ),
                  contactCardWidget(
                      'The Enchanted Forest',
                      '+91 12345 67890',
                      '1974-03-20 00:00:00.000',
                      12456,
                      3,
                      3,
                      0,
                      'not_working'
                  ),
                  contactCardWidget(
                      'The Enchanted Forest',
                      '+91 12345 67890',
                      '1974-03-20 00:00:00.000',
                      12456,
                      3,
                      3,
                      0,
                      'helpful'
                  ),
                  contactCardWidget(
                      'The Enchanted Forest',
                      '+91 12345 67890',
                      '1974-03-20 00:00:00.000',
                      12456,
                      3,
                      3,
                      0,
                      'unresponsive'
                  ),
                  contactCardWidget(
                      'The Enchanted Forest',
                      '+91 12345 67890',
                      '1974-03-20 00:00:00.000',
                      12456,
                      3,
                      3,
                      0,
                      'out_of_stock'
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type  : BottomNavigationBarType.fixed,
        items : [
          BottomNavigationBarItem(icon: Icon(Icons.person_search), label: 'Browse'),
          BottomNavigationBarItem(icon: Icon(Icons.dialpad), label: 'Dial New'),
          BottomNavigationBarItem(icon: Icon(Icons.av_timer), label: 'Recent')
        ],
      ),
    );
  }
}
