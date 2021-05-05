import 'package:flutter/material.dart';

const Color         primaryColor         = Color(0xff393E41);
const MaterialColor primaryColorMaterial = const MaterialColor(
  0xff393E41,
  const <int, Color>{
    50 : const Color(0xff687278),
    100: const Color(0xff5f686d),
    200: const Color(0xff555d62),
    300: const Color(0xff4c5357),
    400: const Color(0xff42494c),
    500: const Color(0xff393E41),
    600: const Color(0xff2f3437),
    700: const Color(0xff26292c),
    800: const Color(0xff1c1f21),
    900: const Color(0xff131516),
  }
);


// Feedback () constants
Map<String, Color> feedbackColors = {
  'helpful'      : Colors.green,
  'unresponsive' : Colors.red,
  'out_of_stock' : Colors.orange,
  'invalid'      : Colors.black,
};

Map<String, IconData> feedbackIconData = {
  'helpful'      : Icons.thumb_up,
  'unresponsive' : Icons.phone_missed,
  'out_of_stock' : Icons.shopping_cart_outlined,
  'invalid'      : Icons.block,
};



