import 'package:coverify/screens/recent_page.dart';
import 'package:flutter/material.dart';

import 'package:coverify/constants.dart';
import 'package:coverify/dummy_data.dart';
import 'package:coverify/theme.dart';

import 'package:coverify/screens/browse_page.dart';
import 'package:coverify/screens/dialer_page.dart';
import 'package:coverify/widgets/appbar.dart';
import 'package:coverify/widgets/location_sheet.dart';


class HomeScreen extends StatefulWidget {

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  BrowsePage browsePage;
  Dialer     dialerPage;
  RecentPage recentPage;
  int currentNavigationIndex      = 0;
  List<Widget> navigationChildren = [];

  String currentLocation          = '';
  var locationList                = [];

  @override
  void initState() {

    // TODO: Get current location and location list
    setState(() {
      currentLocation  = 'Dehradun';
      locationList     = ['', 'Ahmedabad', 'Bangalore', 'Chennai', 'Dehradun', 'Ghaziabad', 'Hyderabad', 'NCR', 'Mumbai'];
    });

    browsePage         = BrowsePage(location: currentLocation,);
    dialerPage         = Dialer();
    recentPage         = RecentPage();
    navigationChildren = [browsePage, dialerPage, recentPage];

    super.initState();
  }

  void locationChanged(String newLocation) {
    setState(() {
      currentLocation = newLocation;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar : appBarCommon(currentLocation, () { showLocationBottomSheet(context, locationList, locationChanged); }, currentNavigationIndex == 0),
      body   : navigationChildren[currentNavigationIndex],

      bottomNavigationBar: BottomNavigationBar(
        type         : BottomNavigationBarType.fixed,
        currentIndex : currentNavigationIndex,
        items        : [
          BottomNavigationBarItem(icon: Icon(Icons.person_search), label: 'Browse'),
          BottomNavigationBarItem(icon: Icon(Icons.dialpad),       label: 'Dial New'),
          BottomNavigationBarItem(icon: Icon(Icons.av_timer),      label: 'Recent')
        ],
        onTap        : (int _index) {
          setState(() { currentNavigationIndex = _index; });
        },
      ),
    );
  }
}
