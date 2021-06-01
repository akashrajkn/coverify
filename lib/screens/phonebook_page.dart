import 'package:flutter/material.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:contacts_service/contacts_service.dart';

import 'package:coverify/models/resource.dart';
import 'package:coverify/models/location.dart';
import 'package:coverify/utils/api.dart';
import 'package:coverify/utils/call_helper.dart';
import 'package:coverify/utils/misc.dart';
import 'package:coverify/widgets/feedback_sheet.dart';
import 'package:coverify/widgets/location_sheet.dart';
import 'package:coverify/widgets/resource_sheet.dart';
import 'package:coverify/widgets/name_sheet.dart';


class PhonebookPage extends StatefulWidget {

  final List<LocationModel> locations;
  final List<ResourceModel> resources;
  final Map<String, String> info;

  PhonebookPage({this.locations, this.resources, this.info});

  @override
  _PhonebookPageState createState() => _PhonebookPageState();
}


class _PhonebookPageState extends State<PhonebookPage> {

  CallHelper callHelper        = CallHelper();
  bool readyToDisplay          = false;
  bool hasPhonebookPermission  = false;
  var phonebookList;
  var filteredPhonebookList;

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    readyToDisplay = true;

    getPhonebookPermission()
    .then((value) {
      hasPhonebookPermission = value;
      print(value);
      getPhonebookContacts();
    });

    searchController.addListener(() {
      filterContacts();
    });

    super.initState();
  }

  Future<bool> getPhonebookPermission() async {

    var status = await Permission.contacts.status;

    if (status.isGranted) { return true; }
    if (await Permission.contacts.request().isGranted) { return true; }

    return false;
  }

  Future<void> getPhonebookContacts() async {
    Iterable<Contact> contacts = await ContactsService.getContacts(withThumbnails: false);

    setState(() { phonebookList = contacts; });
  }

  void filterContacts() {
    var _contacts = [];
    _contacts.addAll(phonebookList);

    if (searchController.text.isNotEmpty) {
      _contacts.retainWhere((element) {
        String searchTerm  = searchController.text.toLowerCase();
        String contactName = element.displayName.toLowerCase();
        return contactName.contains(searchTerm);
      });

      setState(() { filteredPhonebookList = _contacts; });
    }
  }

  void showSnackBarFlow(snackBar, diallerContext, exists, formattedContactNumber, displayName) {
    showFeedbackBottomSheet(diallerContext, (feedback) {
      print(feedback);

      showResourcesBottomSheet(diallerContext, widget.resources, (resourceID) {
        print(resourceID);
        if (!exists) {
          showLocationBottomSheet(diallerContext, widget.locations, (location) {
            print(location.id);

            showNameBottomSheet(diallerContext, displayName, (contactName) {
              print(contactName);
              ScaffoldMessenger.of(diallerContext).showSnackBar(snackBar)
              .closed
              .then((value) {
                if (value == SnackBarClosedReason.swipe || value == SnackBarClosedReason.timeout) {
                  callReportContactURL(formattedContactNumber, exists, resourceID, feedback, location.id, contactName, widget.info['imei']);
                } else if (value == SnackBarClosedReason.action) {
                  showSnackBarFlow(snackBar, diallerContext, exists, formattedContactNumber, displayName);
                }
              });
            });
          });

        } else {
          ScaffoldMessenger.of(diallerContext).showSnackBar(snackBar)
          .closed
          .then((value) {
            if (value == SnackBarClosedReason.swipe || value == SnackBarClosedReason.timeout) {
              callReportContactURL(formattedContactNumber, exists, resourceID, feedback, '', '', widget.info['imei']);
            } else if (value == SnackBarClosedReason.action) {
              showSnackBarFlow(snackBar, diallerContext, exists, formattedContactNumber, displayName);
            }
          });
        }
      });
    });
  }

  Future<void> callButtonTapped(String contactNumber, String contactName) async {

    var response = await callContactStatusEndpoint(contactNumber, widget.info['imei']);
    bool exists  = false;
    if (response['request'] == 'success') {
      exists     = response['exists'];
    }
    print(response);

    final snackBar = SnackBar(
      duration        : Duration(seconds: 2),
      backgroundColor : Colors.green,
      content         : Row(
        mainAxisAlignment  : MainAxisAlignment.center,
        crossAxisAlignment : CrossAxisAlignment.center,

        children: [
          Icon(Icons.check_circle, color: Colors.white, size: 20,),
          SizedBox(width: 5,),
          Text('Contact added', style: TextStyle(color: Colors.white),),
        ],
      ),
      action          : SnackBarAction(
        label     : 'UNDO',
        textColor : Colors.white,
        onPressed : () { },
      ),
    );

    final diff                  = await callHelper.callAndGetDuration(contactNumber);
    BuildContext diallerContext = context;
    showSnackBarFlow(snackBar, diallerContext, exists, contactNumber, contactName);
  }

  @override
  Widget build(BuildContext context) {

    bool isSearching = searchController.text.isNotEmpty;

    return Container(
      padding : EdgeInsets.fromLTRB(20, 10, 20, 10),

      child   : Column(
        
        mainAxisAlignment: MainAxisAlignment.center,
        
        children: [
          Container(
            width : double.infinity,
            color : Colors.grey[50],
            child : TextField(
              controller : searchController,
              decoration : InputDecoration(
                  border     : InputBorder.none,
                  prefixIcon : Icon(Icons.search, color: Colors.grey,)
              ),
            ),
          ),
          SizedBox(height: 10,),
          Expanded(
            child: !hasPhonebookPermission ? Container() : ListView.builder(

              itemCount   : isSearching ? filteredPhonebookList?.length ?? 0 : phonebookList?.length ?? 0,
              itemBuilder : (BuildContext context, int index) {

                Contact contact = isSearching ? filteredPhonebookList?.elementAt(index) : phonebookList?.elementAt(index);

                return Card(
                  elevation : 0,

                  child     : InkWell(
                    onTap: contact.phones.length < 1 ? null : () {
                      callButtonTapped(contact.phones.first.value, contact.displayName);
                    },
                    child: ListTile(
                    // leading        : CircleAvatar(child: Text(contact.initials()),),
                      contentPadding : const EdgeInsets.symmetric(vertical: 2, horizontal: 18),
                      title          : Text(contact.displayName ?? ''),
                      subtitle       : contact.phones.length < 1 ? null : Text(contact.phones.first.value),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
