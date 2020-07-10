import 'package:accounting/commons/resources.dart';
import 'package:accounting/models/user.dart';
import 'package:accounting/screens/vendor/addVendor.dart';
import 'package:accounting/screens/vendor/vendorTile.dart';
import 'package:accounting/services/vendorService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ViewVendors extends StatefulWidget {
  @override
  _ViewVendorsState createState() => _ViewVendorsState();
}

class _ViewVendorsState extends State<ViewVendors> {
  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<UserId>(context);
    return Container(
        padding: EdgeInsets.all(5),
        child: Column(
          children: <Widget>[
            RaisedButton(
              color: primaryLightColor,
              child: Text(
                'Add Vendor',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddVendor()));
              },
            ),
            Divider(),
            Flexible(
              child: StreamBuilder(
                stream: VendorService().getVendorStream(userId),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (false) {
                    // check here, leads to infinite loading. @TODO
                    return Container(
                        child: Center(
                      child: CircularProgressIndicator(),
                    ));
                  } else {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context, index) {
                          snapshot.data.documents[index].data.putIfAbsent(
                              'vendorUID',
                              () => snapshot.data.documents[index].documentID);
                          return VendorTile(
                              vendor: snapshot.data.documents[index].data);
                        },
                      );
                    } else {
                      return Container(
                          child: Center(
                        child: Text('You have not added any Vendor yet.'),
                      ));
                    }
                  }
                },
              ),
            )
          ],
        ));
  }
}
