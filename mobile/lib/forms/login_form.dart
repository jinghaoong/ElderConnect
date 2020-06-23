import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Username',
              hintText: 'Enter your Username',
              border: OutlineInputBorder(
                borderSide: BorderSide()
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
              decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter your Password',
                  border: OutlineInputBorder(
                      borderSide: BorderSide()
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
          FlatButton(
            onPressed: () {},
            color: Colors.cyan[800],
            textColor: Colors.white,
            child: Text('Login'),
          ),
        ],
      )
    );
  }
}
