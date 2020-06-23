import 'package:flutter/material.dart';
import 'package:mobile/forms/login_form.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Login to ElderConnect+',
              style: TextStyle(
                fontSize: 20.0,
              )
            ),
            SizedBox(height: 30.0),
            LoginForm(),
          ],
        )
    );
  }
}
