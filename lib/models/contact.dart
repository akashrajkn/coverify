
class ContactModel {

  String               id;             // Contact ID
  String               name;           // Contact name
  String               contactNumber;  // Contact phone number
  String               lastActivity;   // Last Updated time
  String               lastState;      // Last updated state of the contact: ['helpful', 'unresponsive', 'out_of_stock', 'not_working']
  String               locationID;     // Contact location
  List<String>         resourceID;     // List of resources available for this contact ['1', '2', ...]
  Map<String, dynamic> counts;         // status counts

  ContactModel({
    this.id,
    this.name,
    this.contactNumber,
    this.lastActivity,
    this.lastState,
    this.locationID,
    this.resourceID,
    this.counts,
  });
}
