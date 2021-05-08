import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:coverify/constants.dart';
import 'package:coverify/theme.dart';

import 'package:coverify/screens/browse_page.dart';
import 'package:coverify/screens/dialer_page.dart';
import 'package:coverify/screens/recent_page.dart';
import 'package:coverify/utils/misc.dart';
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
  int currentNavigationIndex      = -1;
  List<Widget> navigationChildren = [];
  GlobalKey<BrowsePageState> browsePageKey = GlobalKey();

  String currentLocation          = '';
  String currentLocationID        = '';
  var locationList                = [];
  var resourcesList               = [];

  SharedPreferences prefs;

  @override
  void initState() {

    isInternetAvailable().then((available) {
      if (!available) {
        Navigator.of(context).pushNamed(errorRoute, arguments: 'Internet not available');
      }
    });

    getLocationsFromDB()
    .then((_) {
      setHomeLocation().then((_) {
        browsePage         = BrowsePage(key: browsePageKey, location: { 'name' : currentLocation, 'id': currentLocationID }, resources: resourcesList,);
        dialerPage         = Dialer();
        recentPage         = RecentPage();
        navigationChildren = [browsePage, dialerPage, recentPage];
        currentNavigationIndex = 0;
      });
    })
    .onError((error, stackTrace) {
      Navigator.of(context).pushNamed(errorRoute, arguments: error.toString());
    });

    super.initState();
  }

  Future<void> getLocationsFromDB() async {

    var response = await http.get(Uri.parse(apiBootstrapURL));
    final parsed = jsonDecode(response.body);

    List<dynamic> tempLocations = parsed['locations'];
    tempLocations.insert(0, { 'id' : '', 'name' : '' }); // FIXME: This is just for compatibility, get rid of it at a later point

    setState(() {
      locationList  = tempLocations;
      resourcesList = parsed['tags'];
    });
  }

  Future<void> setHomeLocation() async {

    prefs        = await SharedPreferences.getInstance();
    String loc   = prefs.getString('location') ?? '';
    String locID = prefs.getString('locationID') ?? '';

    if (loc != '') {
      setState(() {
        currentLocation   = loc;
        currentLocationID = locID;
      });
      return;
    }

    showLocationBottomSheet(context, locationList, locationChanged);
  }

  Future<void> locationChanged(dynamic newLocation) async {

    newLocation['id'] = newLocation['id'].toString();

    prefs = await SharedPreferences.getInstance();
    prefs.setString('location', newLocation['name']);
    prefs.setString('locationID', newLocation['id']);

    setState(() {
      currentLocation   = newLocation['name'];
      currentLocationID = newLocation['id'];
    });

    if (browsePageKey.currentState != null) {
      browsePageKey.currentState.locationUpdated(newLocation);
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor    : Colors.white,
      appBar             : appBarCommon(currentLocation, () { showLocationBottomSheet(context, locationList, locationChanged); }, currentNavigationIndex == 0),
      body               : currentNavigationIndex == -1 ? Container() : navigationChildren[currentNavigationIndex],
      bottomNavigationBar: currentNavigationIndex == -1 ? null : BottomNavigationBar(
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
