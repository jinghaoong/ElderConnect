import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/pages/dashboard.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {

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
    var jsonData;
    var response = await http.post('http://127.0.0.1:8000/rest-auth/login/', body: data);

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

  @override
  Widget build(BuildContext context) {
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
                icon: Icon(Icons.dialpad),
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
          SizedBox(height: 8.0),
          RaisedButton(
            onPressed: () {
              setState(() {
                _isLoading = true;
              });
              _login(usernameController.text, passwordController.text);
            },
            child: Text('Login'),
            color: Colors.teal[600],
          ),
        ],
      )
    );
  }
}
