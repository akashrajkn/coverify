import 'package:coverify/widgets/report_sheet.dart';
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
import 'package:coverify/widgets/more_sheet.dart';
import 'package:coverify/widgets/snackbar.dart';


class HomeScreen extends StatefulWidget {

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {

  BrowsePage    browsePage;
  TabController browsePageTabController;
  List<Widget>  browsePageTabs;

  Dialer        dialerPage;
  TabController dialerPageTabController;
  List<Widget>  dialerPageTabs;

  TabController recentPageTabController;
  List<Widget>  recentPageTabs;

  bool initApp                    = true;
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

    dialerPageTabController = TabController(length: 2, vsync: this);
    dialerPageTabs          = [
      Tab(child: Text('Dial New', style: TextStyle(fontWeight: FontWeight.bold),),),
      Tab(child: Text('Contacts', style: TextStyle(fontWeight: FontWeight.bold),),),
    ];

    isInternetAvailable().then((available) {
      if (!available) {

        final snackBar = internetUnavailableSnackBar();
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

  @override
  void dispose() {
    browsePageTabController.dispose();
    dialerPageTabController.dispose();
    recentPageTabController.dispose();

    super.dispose();
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

    List<Widget> resourcesTabs_ = List.generate(response['resources'].length, (index) {
      return Tab(child: Text(response['resources'][index].name, style: TextStyle(fontWeight: FontWeight.bold),),);
    });
    setState(() {
      locationList  = response['locations'];
      resourcesList = response['resources'];
      statusList    = response['status'];
      browsePageTabController = TabController(length: resourcesList.length, vsync: this);
      recentPageTabController = TabController(length: resourcesList.length, vsync: this);
      browsePageTabs          = resourcesTabs_;
      recentPageTabs          = resourcesTabs_;
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
        browsePage      = BrowsePage(key: browsePageKey, location: LocationModel(id: locID, name: loc), resources: resourcesList, info: {'imei': imei }, tabController: browsePageTabController,);
        dialerPage      = Dialer(locations: locationList, resources: resourcesList, info: {'imei': imei}, tabController: dialerPageTabController,);
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
        browsePage    = BrowsePage(key: browsePageKey, location: newLocation, resources: resourcesList, info: {'imei': imei }, tabController: browsePageTabController,);
        dialerPage    = Dialer(locations: locationList, resources: resourcesList, info: {'imei': imei }, tabController: dialerPageTabController,);
        currentNavigationIndex = 0;
      });
    }

    setState(() {
      initApp         = false;
      currentLocation = newLocation;
    });

    print(browsePageKey);

    if (browsePageKey.currentState != null) {
      browsePageKey.currentState.locationUpdated(newLocation);
    }

    Navigator.of(context).popAndPushNamed(homeRoute);
  }
  
  Future<void> moreInfoBottomSheet() async {
    showMoreBottomSheet(context);
  }


  @override
  Widget build(BuildContext context) {

    var whichTabController;
    var whichTabs;
    String whichDisplayText = '';
    if (currentNavigationIndex > -1) {
      whichTabController = currentNavigationIndex == 0 ? browsePageTabController : (currentNavigationIndex == 1 ? dialerPageTabController : recentPageTabController);
      whichTabs          = currentNavigationIndex == 0 ? browsePageTabs          : (currentNavigationIndex == 1 ? dialerPageTabs          : recentPageTabs);
      whichDisplayText   = currentNavigationIndex == 0 ? browsePageAppBarText    : (currentNavigationIndex == 1 ? ''                      : recentPageAppBarText);
    }

    return Scaffold(
      backgroundColor : Colors.white,
      appBar          : appBarTabs(currentLocation, () { showLocationBottomSheet(context, locationList, locationChanged); }, moreInfoBottomSheet, whichTabController, whichTabs, whichDisplayText),
      body            : initApp || (currentNavigationIndex == -1) ? Container() : IndexedStack(
        index    : currentNavigationIndex,
        children : [
          browsePage,
          dialerPage,
          RecentPage(key: GlobalKey(), resources: resourcesList, tabController: recentPageTabController,)
        ],
      ),
      bottomNavigationBar: currentNavigationIndex == -1 ? null : BottomNavigationBar(
        elevation    : 5,
        type         : BottomNavigationBarType.fixed,
        currentIndex : currentNavigationIndex,
        items        : [
          BottomNavigationBarItem(icon: Icon(Icons.person_search_rounded), label: 'Browse'),
          BottomNavigationBarItem(icon: Icon(Icons.dialpad_rounded),       label: 'Phone'),
          BottomNavigationBarItem(icon: Icon(Icons.av_timer_rounded),      label: 'Recent')
        ],
        onTap        : (int _index) {
          setState(() { currentNavigationIndex = _index; });
        },
      ),
    );
  }
}
