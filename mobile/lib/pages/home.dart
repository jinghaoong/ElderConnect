import 'package:flutter/material.dart';
import 'package:mobile/pages/login.dart';
import 'package:mobile/pages/register.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ElderConnect+'),
        backgroundColor: Colors.teal[800],
        elevation: 20.0,
      ),
      body: Container(
        padding: EdgeInsets.all(25.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ButtonTheme(
                  height: 50.0,
                  minWidth: 200.0,
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (BuildContext context) => Login()),
                              (route) => false);
                    },
                    child: Text("Login"),
                    color: Colors.teal[600],
                  ),
                ),
                SizedBox(height: 10.0),
                ButtonTheme(
                  height: 50.0,
                  minWidth: 200.0,
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (BuildContext context) => Register()),
                              (route) => false);
                    },
                    child: Text("Register"),
                    color: Colors.teal[600],
                  ),
                ),
              ],
            )
          )
      ),
    );
  }
}

