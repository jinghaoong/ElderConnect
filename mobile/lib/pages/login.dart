import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/pages/home.dart';
import 'package:mobile/pages/register.dart';
import 'package:mobile/pages/dashboard.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  _login(String username, password) async{
    Map data = {
      'username': username,
      'password': password,
    };

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    var host = '10.0.2.2';
    var url = 'http://$host:8000/rest-auth/login/';
    var response = await http.post(url, body: data);

    var jsonData;
    if (response.statusCode == 200) {
      jsonData = jsonDecode(response.body);
      setState(() {
        _isLoading = false;
        sharedPreferences.setString("token", jsonData['key']);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => Dashboard()),
                (route) => false);
      });
    } else {
      print(response.body);
    }
  }

  Widget _loginForm() {
    return Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
                controller: usernameController,
                decoration: InputDecoration(
                    icon: Icon(Icons.account_box),
                    hintText: 'Username',
                    border: OutlineInputBorder(
                        borderSide: BorderSide()
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[100])
                    )
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter your username';
                  }
                  return null;
                }
            ),
            SizedBox(height: 8.0),
            TextFormField(
                obscureText: true,
                controller: passwordController,
                decoration: InputDecoration(
                    icon: Icon(Icons.lock),
                    hintText: 'Password',
                    border: OutlineInputBorder(
                        borderSide: BorderSide()
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[100])
                    )
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                }
            ),
            SizedBox(height: 15.0),
            ButtonTheme(
              minWidth: 150.0,
              child: RaisedButton(
                onPressed: () {
                  setState(() {
                    _isLoading = true;
                  });

                  if (_formKey.currentState.validate()) {
                    _login(
                        usernameController.text,
                        passwordController.text
                    );
                  }
                },
                child: Text('Login'),
                color: Colors.teal[600],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
              ),
            ),
            SizedBox(height: 25.0),
            ButtonTheme(
              child: RaisedButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (BuildContext context) => Register()),
                          (route) => false);
                },
                child: Text("Don't have an account? Register here!"),
                color: Colors.grey[600],
              ),
            ),
          ],
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool showFab = MediaQuery.of(context).viewInsets.bottom == 0.0;
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      body: Container(
        padding: EdgeInsets.all(25.0),
        child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('ElderConnect+', style: TextStyle(fontSize: 40.0)),
                SizedBox(height: 50.0),
                _loginForm(),
              ],
            )
        ),
      ),
      floatingActionButton: showFab ? FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (BuildContext context) => Home()),
                  (route) => false);
        },
        child: Icon(Icons.home, color: Colors.white),
        backgroundColor: Colors.teal[600],
      ) : null,
    );
  }
}
