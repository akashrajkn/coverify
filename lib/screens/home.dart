import 'package:coverify/theme.dart';
import 'package:coverify/widgets/appbar.dart';
import 'package:coverify/widgets/contact_card.dart';
import 'package:flutter/material.dart';

import 'package:coverify/constants.dart';


class HomeScreen extends StatefulWidget {

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar : appBarCommon('dehradun'),
      body   : Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
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
          ],
        ),
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
