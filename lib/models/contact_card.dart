
class ContactCardModel {

  String name;               // Contact name
  String contactNumber;      // Contact phone number
  String lastActivity;       // Last Updated
  int    helpfulCount;       // How many marked it as helpful
  int    unresponsiveCount;  // How many marked it as unresponsive
  int    outOfStockCount;    // How many marked it as out of stock
  int    notWorkingCount;    // How many marked it as not working
  String state;              // Current state of the contact: ['helpful', 'unresponsive', 'out_of_stock', 'not_working']
  var    type;               // Type: ['oxygen', 'bed', 'injections', 'plasma']

  ContactCardModel({
    this.name,
    this.contactNumber,
    this.lastActivity,
    this.helpfulCount,
    this.unresponsiveCount,
    this.outOfStockCount,
    this.notWorkingCount,
    this.state,
    this.type
  });
}
