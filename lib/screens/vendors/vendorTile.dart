import 'package:accounting/commons/resources.dart';
import 'package:accounting/screens/vendors/editVendor.dart';
import 'package:accounting/services/vendorService.dart';
import 'package:flutter/material.dart';

class VendorTile extends StatefulWidget {
  final Map<String, dynamic> vendor;
  final int index;

  VendorTile({this.vendor, this.index});

  @override
  _VendorTileState createState() => _VendorTileState();
}

class _VendorTileState extends State<VendorTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.zero,
      child: Card(
          elevation: 2.0,
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
                          widget.vendor['name'],
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: secondaryColor),
                        ),
                        Divider(),
                        widget.vendor.containsKey('email') &&
                                widget.vendor['email'].toString().isNotEmpty
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
                                      TextSpan(
                                          text: "${widget.vendor['email']}")
                                    ]),
                              )
                            : Container(),
                        SizedBox(
                          height: widget.vendor.containsKey('email') &&
                                  widget.vendor['email'].toString().isNotEmpty
                              ? 3.0
                              : 0,
                        ),
                        widget.vendor.containsKey('phone') &&
                                widget.vendor['phone'].toString().isNotEmpty
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
                                      TextSpan(
                                          text: "${widget.vendor['phone']}")
                                    ]),
                              )
                            : Container(),
                        SizedBox(
                          height: widget.vendor.containsKey('phone') &&
                                  widget.vendor['phone'].toString().isNotEmpty
                              ? 3.0
                              : 0,
                        ),
                        widget.vendor.containsKey('gst') &&
                                widget.vendor['gst'].toString().isNotEmpty
                            ? RichText(
                                text: TextSpan(
                                    text: '',
                                    style: TextStyle(color: Colors.black),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: "GST: ",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          )),
                                      TextSpan(text: "${widget.vendor['gst']}")
                                    ]),
                              )
                            : Container(),
                        SizedBox(
                          height: widget.vendor.containsKey('gst') &&
                                  widget.vendor['gst'].toString().isNotEmpty
                              ? 3.0
                              : 0,
                        ),
                        widget.vendor.containsKey('pan') &&
                                widget.vendor['pan'].toString().isNotEmpty
                            ? RichText(
                                text: TextSpan(
                                    text: '',
                                    style: TextStyle(color: Colors.black),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: "PAN: ",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          )),
                                      TextSpan(text: "${widget.vendor['pan']}")
                                    ]),
                              )
                            : Container(),
                        SizedBox(
                          height: widget.vendor.containsKey('pan') &&
                                  widget.vendor['pan'].toString().isNotEmpty
                              ? 3.0
                              : 0,
                        ),
                        widget.vendor.containsKey('website') &&
                                widget.vendor['website'].toString().isNotEmpty
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
                                          text: "${widget.vendor['website']}")
                                    ]),
                              )
                            : Container(),
                        SizedBox(
                          height: widget.vendor.containsKey('website') &&
                                  widget.vendor['website'].toString().isNotEmpty
                              ? 3.0
                              : 0,
                        ),
                        widget.vendor.containsKey('address') &&
                                widget.vendor['address'].toString().isNotEmpty
                            ? Text("${widget.vendor['address']}")
                            : Container(),
                      ],
                    ),
                  )),
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
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(
                                        'Do you really want to delete ${widget.vendor['name']}?'),
                                    content: Text(
                                        'All expenses related to this vendor will also be deleted'),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text('Cancel'),
                                        onPressed: () {
                                          Navigator.of(context).pop(true);
                                        },
                                      ),
                                      RaisedButton(
                                        child: Text('Confirm'),
                                        color: Colors.red,
                                        onPressed: () async {
                                          Navigator.of(context).pop(true);
                                        },
                                      )
                                    ],
                                  );
                                }).then((value) async {
                              if (value is bool && value) {
                                bool isSuccess = await VendorService()
                                    .deleteVendor(widget.vendor['vendorUID']);
                                showSimpleDialogBox(
                                    context, 'Vendor Deleted', false);
                              }
                            });
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
                                    builder: (context) => EditVendor(
                                          vendorDetails: widget.vendor,
                                        )));
                          },
                        )
                      ],
                    ),
                  ))
            ],
          )),
    );
  }
}
