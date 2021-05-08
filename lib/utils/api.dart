import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:coverify/constants.dart';
import 'package:coverify/models/contact.dart';
import 'package:coverify/models/location.dart';
import 'package:coverify/models/resource.dart';

Future<dynamic> callBootstrapEndpoint() async {

  String url = apiBootstrapURL;

  try {
    var response = await http.get(Uri.parse(url));
    final parsed = jsonDecode(response.body);

    List<LocationModel> locations = [];
    for (int i = 0; i < parsed['locations'].length; i++) {
      locations.add(LocationModel(
        id   : parsed['locations'][i]['id'].toString(),
        name : parsed['locations'][i]['name'],
      ));
    }

    List<ResourceModel> resources = [];
    for (int i = 0; i < parsed['tags'].length; i++) {
      resources.add(ResourceModel(
        id   : parsed['resources'][i]['id'].toString(),
        name : parsed['resources'][i]['name'],
      ));
    }

    return {
      'request'   : 'success',
      'locations' : locations,
      'resources' : resources,
      'status'    : parsed['status']
    };

  } on Exception catch (_) {
    return {
      'request' : 'error',
      'error'   : _.toString(),
    };
  }
}

Future<dynamic> callFilterContactsEndpoint(LocationModel location, ResourceModel resource, int offset) async {

  String url = apiFilterContactsURL + '?location=${location.id}&requirement=${resource.id}&offset=${offset}';

  try {
    var response = await http.get(Uri.parse(url));
    final parsed = jsonDecode(response.body);

    List<ContactModel> contacts = [];
    for (int i = 0; i < parsed['data'].length; i++) {

      List<String> resourceID     = [];
      Map<String, dynamic> counts = {};
      List<dynamic> tags          = parsed['data']['tags'];

      for (int j = 0; j < tags.length; j++) {
        String _id = tags[j]['id'].toString();

        resourceID.add(_id);
        counts[_id] = {
          'helpfulCount'      : tags[j]['meta']['totalWorkedCount'],
          'unresponsiveCount' : tags[j]['meta']['totalUnresponsiveCount'],
          'invalidCount'      : tags[j]['meta']['totalNotWorkedCount'],
          'outOfStockCount'   : tags[j]['meta']['totalNotWorkedCount'],
        };
      }

      contacts.add(ContactModel(
        id            : parsed['data'][i]['id'].toString(),
        name          : parsed['data'][i]['name'],
        contactNumber : parsed['data'][i]['contactNumber'],
        locationID    : parsed['data'][i]['location'].toString(),
        lastActivity  : parsed['data'][i]['lastActivity'] ?? '',
        lastState     : parsed['data'][i]['lastState'] ?? '',
        resourceID    : resourceID,
        counts        : counts,
      ));
    }

    return {
      'request'  : 'success',
      'contacts' : contacts,
    };

  } on Exception catch (_) {
    return {
      'request' : 'error',
      'error'   : _.toString(),
    };
  }
}

Future<dynamic> callContactStatusEndpoint(String phoneNumber) async {
  String url = apiContactStatusURL;

  try {
    var response = await http.post(Uri.parse(url), body: {'phoneNumber' : phoneNumber});
    final parsed = jsonDecode(response.body);
    return {
      'request' : 'success',
      'exists'  : parsed['exists']
    };

  } on Exception catch (_) {
    return {
      'request' : 'error',
      'error'   : _.toString()
    };
  }
}

Future<dynamic> callReportContactURL(String phoneNumber, bool exists, int resourceID, String status, int locationID, String name) async {

  String url         = apiReportContactURL;
  var body           = {
    'phoneNumber'    : phoneNumber,
    'tag'            : resourceID,
    'status'         : status
  };
  if (!exists) {
    body['location'] = locationID;
    body['name']     = name;
  }

  try {
    await http.post(Uri.parse(url), body: body);
    return { 'request' : 'success' };
  } on Exception catch (_) {
    return {
      'request' : 'error',
      'error'   : _.toString()
    };
  }
}
