import 'package:flutter/material.dart';
import 'package:mobile/pages/blood_pressure_create.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mobile/pages/home.dart';
import 'package:mobile/pages/login.dart';
import 'package:mobile/pages/register.dart';
import 'package:mobile/pages/dashboard.dart';
import 'package:mobile/pages/reminder_create.dart';
import 'package:mobile/pages/reminders.dart';
import 'package:mobile/pages/reminders_archive.dart';
import 'package:mobile/pages/blood_pressure.dart';

void main() {
  runApp(MyApp());
}

// development host ip
var ios = '127.0.0.1';
var android = '10.0.2.2';
var host = android;

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  SharedPreferences sharedPreferences;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  _checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("token") == null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => Home()),
              (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.teal,
          fontFamily: 'Montserrat',
        ),
        initialRoute: '/home',
        routes: {
          '/home': (context) => Home(),
          '/login': (context) => Login(),
          '/register': (context) => Register(),
          '/dashboard': (context) => Dashboard(),

          '/reminders': (context) => RemindersPage(),
          '/reminders-archive': (context) => RemindersArchive(),
          '/reminders/create': (context) => ReminderCreate(),

          '/bloodpressure': (context) => BloodPressurePage(),
          '/bloodpressure/create': (context) => BloodPressureCreate(),
        },
    );
  }
}
