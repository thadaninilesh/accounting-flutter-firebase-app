import 'dart:collection';

class Expense {
  List<Map<String, dynamic>> expenses;
  HashMap<String, String> vendorUIDVsVendorName;
  Expense({this.expenses, this.vendorUIDVsVendorName});
}
