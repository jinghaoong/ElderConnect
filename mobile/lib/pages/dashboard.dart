import 'package:flutter/material.dart';

import 'package:mobile/pages/reminders.dart';

import 'package:mobile/widgets/sidebar_drawer.dart';
import 'package:mobile/widgets/logout_button.dart';


class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Dashboard',
            style: TextStyle(fontSize: 25.0)
        ),
        centerTitle: true,
        backgroundColor: Colors.teal[800],
        actions: <Widget>[
          LogoutButton(),
        ],
      ),
      drawer: SidebarDrawer(),
    );
  }
}
