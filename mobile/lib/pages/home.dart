import 'package:flutter/material.dart';
import 'package:mobile/pages/login.dart';
import 'package:mobile/pages/register.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  final List<Tab> homeTabs = <Tab>[
    Tab(icon: Icon(Icons.home)),
    Tab(text: 'Login'),
    Tab(text: 'Register'),
  ];

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: homeTabs.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ElderConnect+'),
        backgroundColor: Colors.cyan[800],
        bottom: TabBar(
          controller: _tabController,
          tabs: homeTabs,
          indicatorColor: Colors.white,
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(15.0),
        child: TabBarView(
          controller: _tabController,
          children: [
            Center(child: Text('Home Page')),
            Login(),
            Register(),
          ]
        ),
      ),
    );
  }
}

