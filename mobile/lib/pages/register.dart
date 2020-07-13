import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/pages/home.dart';
import 'package:mobile/pages/login.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController password1Controller = TextEditingController();
  TextEditingController password2Controller = TextEditingController();


  _register(String username, email, password1, password2) async{
    Map data = {
      'username': username,
      'email': email,
      'password1': password1,
      'password2': password2,
    };

    var host = '10.0.2.2';
    var url = 'http://$host:8000/rest-auth/registration/';
    var response = await http.post(url, body: data);

    if (response.statusCode == 201) {
      setState(() {
        _isLoading = false;
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => Login()),
                (route) => false);
      });
    } else {
      print(response.body);
    }
  }

  Widget _registrationForm() {
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
                    return 'Please enter a username';
                  }
                  return null;
                }
            ),
            SizedBox(height: 8.0),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                  icon: Icon(Icons.email),
                  hintText: 'Email',
                  border: OutlineInputBorder(
                      borderSide: BorderSide()
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[100])
                  )
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter an email address';
                }
                return null;
              }
            ),
            SizedBox(height: 8.0),
            TextFormField(
                obscureText: true,
                controller: password1Controller,
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
                    return 'Please enter a password';
                  }
                  return null;
                }
            ),
            SizedBox(height: 8.0),
            TextFormField(
                obscureText: true,
                controller: password2Controller,
                decoration: InputDecoration(
                    icon: Icon(Icons.lock_outline),
                    hintText: 'Confirm Password',
                    border: OutlineInputBorder(
                        borderSide: BorderSide()
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[100])
                    )
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please re-enter your password';
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
                    _register(
                        usernameController.text,
                        emailController.text,
                        password1Controller.text,
                        password2Controller.text
                    );
                  }
                },
                child: Text('Register'),
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
                      MaterialPageRoute(builder: (BuildContext context) => Login()),
                          (route) => false);
                },
                child: Text("Already have an account? Login here!"),
                color: Colors.grey[600],
              ),
            ),
          ],
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(25.0),
        child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                    'Registration',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 40.0,
                    )
                ),
                SizedBox(height: 50.0),
                _registrationForm(),
              ],
            )
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (BuildContext context) => Home()),
                  (route) => false);
        },
        child: Icon(Icons.home, color: Colors.white),
        backgroundColor: Colors.teal[600],
      ),
    );
  }
}
