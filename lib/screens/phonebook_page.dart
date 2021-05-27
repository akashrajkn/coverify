import 'package:flutter/material.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:contacts_service/contacts_service.dart';

import 'package:coverify/models/resource.dart';
import 'package:coverify/models/location.dart';


class PhonebookPage extends StatefulWidget {

  @override
  _PhonebookPageState createState() => _PhonebookPageState();
}


class _PhonebookPageState extends State<PhonebookPage> {

  bool readyToDisplay         = false;
  bool hasPhonebookPermission = false;
  var phonebookList;

  @override
  void initState() {
    readyToDisplay = true;

    getPhonebookPermission()
    .then((value) {
      hasPhonebookPermission = value;
      print(value);
      getPhonebookContacts();
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

  @override
  Widget build(BuildContext context) {

    return Container(
      padding : EdgeInsets.fromLTRB(20, 10, 20, 10),

      child   : !hasPhonebookPermission ? Container() : ListView.builder(

        itemCount   : phonebookList?.length ?? 0,
        itemBuilder : (BuildContext context, int index) {

          Contact contact = phonebookList?.elementAt(index);

          return ListTile(
            contentPadding : const EdgeInsets.symmetric(vertical: 2, horizontal: 18),
            title          : Text(contact.displayName ?? ''),
          );
        },
      ),
    );
  }
}
