import 'package:flutter/material.dart';
import 'package:mobile/pages/blood_pressure.dart';

import 'package:mobile/pages/dashboard.dart';
import 'package:mobile/pages/reminders.dart';
import 'package:mobile/widgets/logout_button.dart';

class SidebarDrawer extends StatefulWidget {
  final bool isTeal;

  SidebarDrawer({
    Key key,
    @required this.isTeal
  }) : super(key: key);

  @override
  _SidebarDrawerState createState() => _SidebarDrawerState(isTeal);
}

class _SidebarDrawerState extends State<SidebarDrawer> {
  final bool isTeal;

  _SidebarDrawerState(this.isTeal);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text(
                'ElderConnect+',
                style: TextStyle(fontSize: 25.0)
            ),
            decoration: BoxDecoration(
              color: isTeal ? Colors.teal[700] : Colors.deepOrange[900],
            ),
          ),
          ListTile(
            title: Text(
                'Dashboard',
                style: TextStyle(fontSize: 18.0)
            ),
            trailing: Icon(Icons.dashboard),
            onTap: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (BuildContext context) => Dashboard()),
                      (route) => false
              );
            },
          ),
          Divider(),
          ListTile(
            title: Text(
                'Reminders',
                style: TextStyle(fontSize: 18.0)
            ),
            trailing: Icon(Icons.announcement),
            onTap: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (BuildContext context) => RemindersPage()),
                      (route) => false
              );
            },
          ),
          ListTile(
            title: Text(
                'Blood Pressure',
                style: TextStyle(fontSize: 18.0)
            ),
            trailing: Icon(Icons.favorite),
            onTap: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (BuildContext context) => BloodPressurePage()),
                      (route) => false
              );
            },
          ),
        ],
      ),
    );
  }
}
