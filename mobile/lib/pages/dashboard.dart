import 'package:flutter/material.dart';
import 'package:mobile/widgets/logout_button.dart';
import 'package:mobile/pages/reminders.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        centerTitle: true,
        backgroundColor: Colors.teal[800],
        actions: <Widget>[
          LogoutButton(),
        ],
      ),
      drawer: Drawer(
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
              title: Text('Reminders'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => RemindersPage()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
