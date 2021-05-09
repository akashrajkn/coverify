import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:coverify/constants.dart';
import 'package:coverify/models/location.dart';
import 'package:coverify/screens/browse_page.dart';
import 'package:coverify/screens/dialer_page.dart';
import 'package:coverify/screens/recent_page.dart';
import 'package:coverify/utils/api.dart';
import 'package:coverify/utils/misc.dart';
import 'package:coverify/widgets/appbar.dart';
import 'package:coverify/widgets/location_sheet.dart';


class HomeScreen extends StatefulWidget {

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  bool       initApp              = true;
  BrowsePage browsePage;
  Dialer     dialerPage;
  int currentNavigationIndex      = -1;
  GlobalKey<BrowsePageState> browsePageKey = GlobalKey();

  LocationModel currentLocation   = LocationModel(id: '', name: '');
  var locationList                = [];
  var resourcesList               = [];
  var statusList                  = [];

  SharedPreferences prefs;

  @override
  void initState() {

    isInternetAvailable().then((available) {
      if (!available) {
        Navigator.of(context).pushNamed(errorRoute, arguments: 'Internet not available');
      }
    });

    getInitDataFromBackend()
    .then((_) {
      setHomeLocation().then((_) {

        browsePage = BrowsePage(key: browsePageKey, location: currentLocation, resources: resourcesList,);
        dialerPage = Dialer();
        currentNavigationIndex = 0;
      });
    })
    .onError((error, stackTrace) {
      Navigator.of(context).pushNamed(errorRoute, arguments: error.toString());
    });

    super.initState();
  }

  Future<void> getInitDataFromBackend() async {

    var response = await callBootstrapEndpoint();
    if (response['request'] == 'error') {
      Navigator.of(context).pushReplacementNamed(errorRoute, arguments: response['error']);
    }

    response['locations'].insert(0, LocationModel(id: '', name: '')); // FIXME: This is just for compatibility, get rid of it at a later point
    setState(() {
      locationList  = response['locations'];
      resourcesList = response['resources'];
      statusList    = response['status'];
    });
    print(response);
    print('INIT DATA DONE');
  }

  Future<void> setHomeLocation() async {

    prefs        = await SharedPreferences.getInstance();
    String loc   = prefs.getString('location') ?? '';
    String locID = prefs.getString('locationID') ?? '';

    if (loc != '') {
      setState(() {
        currentLocation = LocationModel(id: locID, name: loc);
        initApp         = false;
      });
      return;
    }

    showLocationBottomSheet(context, locationList, locationChanged);
  }

  Future<void> locationChanged(LocationModel newLocation) async {

    prefs = await SharedPreferences.getInstance();
    prefs.setString('location',   newLocation.name);
    prefs.setString('locationID', newLocation.id);

    setState(() {
      initApp         = false;
      currentLocation = newLocation;
    });

    if (browsePageKey.currentState != null) {
      browsePageKey.currentState.locationUpdated(newLocation);
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor : Colors.white,
      appBar          : appBarCommon(currentLocation, () { showLocationBottomSheet(context, locationList, locationChanged); }, !initApp && currentNavigationIndex == 0),
      body            : initApp || (currentNavigationIndex == -1) ? Container() : IndexedStack(
        index    : currentNavigationIndex,
        children : [
          browsePage,
          dialerPage,
          RecentPage(key: GlobalKey(), resources: resourcesList,)
        ],
      ),
      bottomNavigationBar: currentNavigationIndex == -1 ? null : BottomNavigationBar(
        type         : BottomNavigationBarType.fixed,
        currentIndex : currentNavigationIndex,
        items        : [
          BottomNavigationBarItem(icon: Icon(Icons.person_search_rounded), label: 'Browse'),
          BottomNavigationBarItem(icon: Icon(Icons.dialpad_rounded),       label: 'Dial New'),
          BottomNavigationBarItem(icon: Icon(Icons.av_timer_rounded),      label: 'Recent')
        ],
        onTap        : (int _index) {
          setState(() { currentNavigationIndex = _index; });
        },
      ),
    );
  }
}
