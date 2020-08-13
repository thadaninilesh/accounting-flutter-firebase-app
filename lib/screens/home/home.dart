import 'package:accounting/commons/resources.dart';
import 'package:accounting/screens/auth/signIn.dart';
import 'package:accounting/screens/clients/manageClients.dart';
import 'package:accounting/screens/expenses/viewExpenses.dart';
import 'package:accounting/screens/user/profile.dart';
import 'package:accounting/screens/vendors/viewVendors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<String> _heading = [];
  @override
  void initState() {
    super.initState();
    _heading = [
      'Invoices Management',
      'Vendor Management',
      'Expense Management',
      'Client Management'
    ];
  }

  final globalKey = GlobalKey<ScaffoldState>();

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: screenBackgroundColor,
        appBar: appBarWidget(context, _heading.elementAt(_selectedIndex)),
        bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: _selectedIndex,
            elevation: 10,
            selectedItemColor: primaryColor,
            selectedIconTheme: IconThemeData(color: primaryColor),
            backgroundColor: bottomBarBackgroundColor,
            onTap: (int index) {
              setState(() {
                _onItemTapped(index);
              });
            },
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.fileInvoice),
                title: Text('Invoice'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.business),
                title: Text('Vendor'),
              ),
              BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.moneyBill),
                title: Text('Expense'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.group),
                title: Text('Client'),
              ),
            ]),
        body: Container(
          child: _selectedIndex == 0
              ? Container()
              : _selectedIndex == 1
                  ? ViewVendors()
                  : _selectedIndex == 2
                      ? ManageExpenses()
                      : _selectedIndex == 3 ? ManageClients() : SignIn(),
        ));
  }
}
