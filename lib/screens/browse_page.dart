import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:coverify/models/location.dart';
import 'package:coverify/models/resource.dart';
import 'package:coverify/widgets/browse_page_tab.dart';


class BrowsePage extends StatefulWidget {

  final LocationModel       location;
  final List<ResourceModel> resources;
  final Map<String, String> info;
  final TabController       tabController;

  BrowsePage({Key key, this.location, this.resources, this.info, this.tabController}) : super(key: key);

  @override
  BrowsePageState createState() => BrowsePageState();
}


class BrowsePageState extends State<BrowsePage> {

  LocationModel currentLocation;
  var contactsList       = [];
  bool readyToDisplay    = false;

  @override
  void initState() {

    currentLocation = widget.location;
    widget.tabController.addListener(() {
      if (widget.tabController.indexIsChanging) {
        // print('index changing');
      } else {
        // print('index changed');
      }
    });

    createTabPageKeys();
    super.initState();
  }

  @override
  void setState(fn) {
    if(mounted) {
      super.setState(fn);
    }
  }

  Future<void> createTabPageKeys() async {

    setState(() { readyToDisplay = true; });
  }

  void locationUpdated(LocationModel newLocation) {
    print('location updated from browse page');
    setState(() { currentLocation = newLocation; });
  }

  @override
  Widget build(BuildContext context) {

    return !readyToDisplay ? Container() : TabBarView(
      controller : widget.tabController,
      children   : List<Widget>.generate(widget.resources.length, (index) {

        print(currentLocation.name);
        return BrowsePageTab(
          location           : currentLocation,
          resources          : widget.resources,
          whichResourceIndex : index,
          info               : widget.info,
        );
      }),
    );
  }
}
