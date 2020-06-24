import 'package:flutter/material.dart';
import 'package:mobile/pages/home.dart';
import 'package:mobile/pages/login.dart';
import 'package:mobile/pages/register.dart';
import 'package:mobile/pages/dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

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
        initialRoute: '/dashboard',
        routes: {
          '/home': (context) => Home(),
          '/login': (context) => Login(),
          '/register': (context) => Register(),
          '/dashboard': (context) => Dashboard(),
        },
    );
  }
}
