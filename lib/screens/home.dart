import 'package:flutter/material.dart';

import 'package:imei_plugin/imei_plugin.dart';
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

  String imei                     = '';
  SharedPreferences prefs;

  @override
  void initState() {

    isInternetAvailable().then((available) {
      if (!available) {

        final snackBar = SnackBar(
          duration        : Duration(days: 365),
          backgroundColor : Colors.orange,
          content         : Row(
            mainAxisAlignment  : MainAxisAlignment.center,
            crossAxisAlignment : CrossAxisAlignment.center,

            children           : [
              Text('Please check your internet connection', style: TextStyle(color: Colors.white),)
            ],
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        getImei()
          .then((_) {
          getInitDataFromBackend()
            .then((_) {
            setHomeLocation().then((_) {
              setState(() { });
            });
          })
          .onError((error, stackTrace) {
            Navigator.of(context).pushNamed(errorRoute, arguments: error.toString());
          });
        });
      }
    });

    super.initState();
  }

  Future<void> getImei() async {
    String _imei = await ImeiPlugin.getImei();
    setState(() { imei = _imei; });
  }

  Future<void> getInitDataFromBackend() async {

    var response = await callBootstrapEndpoint(imei);
    if (response['request'] == 'error') {
      Navigator.of(context).pushReplacementNamed(errorRoute, arguments: response['error']);
    }

    response['locations'].insert(0, LocationModel(id: '', name: '')); // FIXME: This is just for compatibility, get rid of it at a later point
    setState(() {
      locationList  = response['locations'];
      resourcesList = response['resources'];
      statusList    = response['status'];
    });
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
        browsePage      = BrowsePage(key: browsePageKey, location: LocationModel(id: locID, name: loc), resources: resourcesList, info: {'imei': imei },);
        dialerPage      = Dialer(locations: locationList, resources: resourcesList, info: {'imei': imei},);
        currentNavigationIndex = 0;
      });
      return;
    }

    showLocationBottomSheet(context, locationList, locationChanged);
  }

  Future<void> locationChanged(LocationModel newLocation) async {

    prefs = await SharedPreferences.getInstance();
    prefs.setString('location',   newLocation.name);
    prefs.setString('locationID', newLocation.id);

    if (initApp) {
      setState(() {
        browsePage = BrowsePage(key: browsePageKey, location: newLocation, resources: resourcesList, info: {'imei': imei },);
        dialerPage = Dialer(locations: locationList, resources: resourcesList, info: {'imei': imei },);
        currentNavigationIndex = 0;
      });
    }

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
