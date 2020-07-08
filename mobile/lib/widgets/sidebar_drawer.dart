import 'package:flutter/material.dart';
import 'package:mobile/pages/blood_pressure.dart';

import 'package:mobile/pages/dashboard.dart';
import 'package:mobile/pages/reminders.dart';

class SidebarDrawer extends StatelessWidget {
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
              color: Colors.teal[700],
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
