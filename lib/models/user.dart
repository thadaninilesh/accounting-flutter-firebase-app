import 'dart:convert';

class UserId {
  String uid;
  UserId({this.uid});
}

class User {
  final String uid;
  final String userName;
  String phoneNumber = '';
  final String emailAddress;
  final String businessName;
  String gst = '';
  String pan = '';
  String address = '';
  String website = '';

  User(
      {this.uid,
      this.userName,
      this.emailAddress,
      this.phoneNumber,
      this.businessName,
      this.gst,
      this.pan,
      this.address,
      this.website});
}
