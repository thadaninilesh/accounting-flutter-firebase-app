import 'dart:collection';

import 'package:accounting/commons/resources.dart';
import 'package:accounting/models/user.dart';
import 'package:accounting/screens/clients/addClient.dart';
import 'package:accounting/screens/clients/clientTile.dart';
import 'package:accounting/services/clientService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ManageClients extends StatefulWidget {
  @override
  _ManageClientsState createState() => _ManageClientsState();
}

class _ManageClientsState extends State<ManageClients> {
  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<UserId>(context);
    return Container(
        padding: EdgeInsets.all(5),
        child: Column(children: <Widget>[
          Center(
              child: RaisedButton(
            color: primaryLightColor,
            child: Text(
              'Add Client',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            onPressed: () async {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddClient()));
            },
          )),
          Divider(),
          Flexible(
            child: StreamBuilder<QuerySnapshot>(
                stream: ClientService().getClientStream(userId),
                builder: (context, clientSnapshot) {
                  if (false) {
                    // check here, leads to infinite loading. @TODO
                    return Container(
                        child: Center(
                      child: CircularProgressIndicator(),
                    ));
                  } else {
                    if (!clientSnapshot.hasData) {
                      return Container(
                          child: Center(
                        child: Text('You have not added any client yet.'),
                      ));
                    } else {
                      return ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: clientSnapshot.data.documents.length,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> clientDetails = new HashMap();
                          clientDetails.addAll(
                              clientSnapshot.data.documents[index].data);
                          clientDetails.putIfAbsent(
                              'clientUID',
                              () => clientSnapshot
                                  .data.documents[index].documentID);
                          return ClientTile(client: clientDetails);
                        },
                      );
                    }
                  }
                }),
          )
        ]));
  }
}
