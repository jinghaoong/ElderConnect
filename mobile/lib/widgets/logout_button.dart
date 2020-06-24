import 'package:flutter/material.dart';
import 'package:mobile/pages/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogoutButton extends StatefulWidget {
  @override
  _LogoutButtonState createState() => _LogoutButtonState();
}

class _LogoutButtonState extends State<LogoutButton> {

  _logout() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      sharedPreferences.remove("token");
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => Home()),
              (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {
        _logout();
      },
      child: Text('Logout'),
    );
  }
}

