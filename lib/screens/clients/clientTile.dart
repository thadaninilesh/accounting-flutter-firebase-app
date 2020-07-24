import 'package:accounting/commons/resources.dart';
import 'package:accounting/screens/clients/editClient.dart';
import 'package:accounting/services/clientService.dart';
import 'package:flutter/material.dart';

class ClientTile extends StatefulWidget {
  final Map<String, dynamic> client;
  final int index;
  ClientTile({this.client, this.index});
  @override
  _ClientTileState createState() => _ClientTileState();
}

class _ClientTileState extends State<ClientTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.zero,
      child: Card(
        elevation: 2,
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.client['clientName'],
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: secondaryColor),
                      ),
                      Divider(),
                      widget.client.containsKey('email') &&
                              widget.client['email'].toString().isNotEmpty
                          ? RichText(
                              text: TextSpan(
                                  text: '',
                                  style: TextStyle(color: Colors.black),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: "Email Address: ",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        )),
                                    TextSpan(text: "${widget.client['email']}")
                                  ]),
                            )
                          : Container(),
                      SizedBox(
                        height: widget.client.containsKey('email') &&
                                widget.client['email'].toString().isNotEmpty
                            ? 3.0
                            : 0,
                      ),
                      widget.client.containsKey('phone') &&
                              widget.client['phone'].toString().isNotEmpty
                          ? RichText(
                              text: TextSpan(
                                  text: '',
                                  style: TextStyle(color: Colors.black),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: "Phone: ",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        )),
                                    TextSpan(text: "${widget.client['phone']}")
                                  ]),
                            )
                          : Container(),
                      SizedBox(
                        height: widget.client.containsKey('phone') &&
                                widget.client['phone'].toString().isNotEmpty
                            ? 3.0
                            : 0,
                      ),
                      widget.client.containsKey('website') &&
                              widget.client['website'].toString().isNotEmpty
                          ? RichText(
                              text: TextSpan(
                                  text: '',
                                  style: TextStyle(color: Colors.black),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: "Website: ",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        )),
                                    TextSpan(
                                        text: "${widget.client['website']}")
                                  ]),
                            )
                          : Container(),
                      SizedBox(
                        height: widget.client.containsKey('website') &&
                                widget.client['website'].toString().isNotEmpty
                            ? 3.0
                            : 0,
                      ),
                      widget.client.containsKey('address') &&
                              widget.client['address'].toString().isNotEmpty
                          ? Text("${widget.client['address']}")
                          : Container(),
                    ]),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    RaisedButton(
                      child: Text(
                        'Delete',
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.red,
                      onPressed: () async {
                        bool isSuccess = await ClientService()
                            .deleteClient(widget.client['clientUID']);
                        showSimpleDialogBox(context, 'Client Deleted', false);
                      },
                    ),
                    RaisedButton(
                      child: Text(
                        'Edit',
                        style: TextStyle(color: Colors.white),
                      ),
                      color: primaryLightColor,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditClient(
                                      clientDetails: widget.client,
                                    )));
                      },
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
