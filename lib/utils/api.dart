import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:coverify/constants.dart';
import 'package:coverify/models/contact.dart';
import 'package:coverify/models/location.dart';
import 'package:coverify/models/resource.dart';

Future<dynamic> callBootstrapEndpoint(String imei) async {

  String url = apiBootstrapURL;
  print(url);

  // return {
  //   'request'   : 'forbidden',
  //   'locations' : List<LocationModel>.from([]),
  //   'resources' : List<ResourceModel>.from([]),
  //   'status'    : []
  // };

  try {
    var response = await http.get(Uri.parse(url), headers: { 'x-imei' : imei });
    if (response.statusCode == 403) {
      return {
        'request'   : 'forbidden',
        'locations' : List<LocationModel>.from([]),
        'resources' : List<ResourceModel>.from([]),
        'status'    : []
      };
    }
    final parsed = jsonDecode(response.body);

    List<LocationModel> locations = [];
    for (int i = 0; i < parsed['locations'].length; i++) {
      locations.add(LocationModel(
        id   : parsed['locations'][i]['id'].toString(),
        name : parsed['locations'][i]['name'],
      ));
    }

    List<ResourceModel> resources = [];
    for (int i = 0; i < parsed['requirements'].length; i++) {
      resources.add(ResourceModel(
        id   : parsed['requirements'][i]['id'].toString(),
        name : parsed['requirements'][i]['name'],
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

Future<dynamic> callFilterContactsEndpoint(LocationModel location, ResourceModel resource, int offset, String imei) async {

  String url = apiFilterContactsURL + '?location=${location.id}&requirement=${resource.id}&offset=$offset';
  print(url);

  // return {
  //   'request'  : 'error',
  //   'contacts' : List<ContactModel>.from([]),
  // };

  try {
    var response = await http.get(Uri.parse(url), headers: {'x-imei' : imei});
    if (response.statusCode == 403) {
      return {
        'request'  : 'forbidden',
        'contacts' : List<ContactModel>.from([]),
      };
    }

    final parsed = jsonDecode(response.body);

    List<ContactModel> contacts = [];
    for (int i = 0; i < parsed['data'].length; i++) {

      List<String> resourceID     = [];
      Map<String, dynamic> counts = {};
      String lastState            = '';
      String lastActivity         = '';
      List<dynamic> tags          = parsed['data'][i]['requirements'];

      for (int j = 0; j < tags.length; j++) {
        String _id = tags[j]['requirement'].toString();

        if (_id == resource.id) {
          lastState    = tags[j]['meta']['lastReportedStatus'] ?? '';
          lastActivity = tags[j]['updated_at'] ?? '';
        }

        resourceID.add(_id);
        counts[_id] = {
          'helpfulCount'      : tags[j]['meta']['totalHelpfulCount'],
          'unresponsiveCount' : tags[j]['meta']['totalUnresponsiveCount'],
          'invalidCount'      : tags[j]['meta']['totalInvalidCount'],
          'outOfStockCount'   : tags[j]['meta']['totalOutOfStockCount'],
        };
      }

      contacts.add(ContactModel(
        id            : parsed['data'][i]['id'].toString(),
        name          : parsed['data'][i]['name'],
        contactNumber : parsed['data'][i]['contactNumber'],
        locationID    : parsed['data'][i]['location'].toString(),
        lastActivity  : lastActivity,
        lastState     : lastState,
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
  } catch (error) {
    return {
      'request'  : 'success',
      'contacts' : []
    };
  }
}

Future<dynamic> callContactStatusEndpoint(String phoneNumber, String imei) async {
  String url = apiContactStatusURL;
  print(url);

  try {
    var response = await http.post(Uri.parse(url), body: {'phoneNumber' : phoneNumber}, headers: {'x-imei' : imei});
    if (response.statusCode == 403) {
      return {
        'request' : 'forbidden',
        'exists'  : false,
      };
    }

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
  } catch (error) {
    return {
      'request' : 'error',
      'error'   : error,
    };
  }
}

Future<dynamic> callReportContactURL(String phoneNumber, bool exists, String resourceID, String status, String locationID, String name, String imei) async {

  String url         = apiReportContactURL;
  print(url);

  var body           = {
    'phoneNumber'    : phoneNumber,
    'requirement'    : resourceID,
    'status'         : status
  };
  if (!exists) {
    body['location'] = locationID;
    body['name']     = name;
  }

  try {
    var response = await http.post(Uri.parse(url), body: body, headers: {'x-imei' : imei});
    if (response.statusCode == 403) { return { 'request' : 'forbidden' }; }
    return { 'request' : 'success' };
  } on Exception catch (_) {
    return {
      'request' : 'error',
      'error'   : _.toString()
    };
  }
}
