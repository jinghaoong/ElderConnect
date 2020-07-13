import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mobile/main.dart';
import 'package:mobile/pages/blood_pressure.dart';

class BloodPressureCreate extends StatefulWidget {
  @override
  _BloodPressureCreateState createState() => _BloodPressureCreateState();
}

class _BloodPressureCreateState extends State<BloodPressureCreate> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  TextEditingController titleController = TextEditingController();
  TextEditingController commentsController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController systolicController = TextEditingController();
  TextEditingController diastolicController = TextEditingController();

  _create(String title, comments, date, time, systolic, diastolic) async {
    Map data = {
      'title': title,
      'comments': comments,
      'date': date,
      'time': time,
      'systolic': systolic,
      'diastolic': diastolic,
    };

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.get('token');

    var url = 'http://$host:8000/api/api_bp/';
    var response = await http.post(
        url,
        body: data,
        headers: {"Authorization": "Token " + token});

    if (response.statusCode == 201) {
      setState(() {
        _isLoading = false;
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => BloodPressurePage()),
                (route) => false);
      });
    } else {
      throw Exception("Failed to create new Blood Pressure record");
    }
  }

  Widget _createForm() {
    return Form(
      key: _formKey,
      child: Column(
          children: <Widget>[
            TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                    icon: Icon(Icons.title),
                    hintText: 'Title',
                    border: OutlineInputBorder(
                        borderSide: BorderSide()
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[100])
                    )
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                }
            ),
            SizedBox(height: 8.0),
            TextFormField(
                maxLines: 2,
                controller: commentsController,
                decoration: InputDecoration(
                    icon: Icon(Icons.text_fields),
                    hintText: 'Comments',
                    border: OutlineInputBorder(
                        borderSide: BorderSide()
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[100])
                    )
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some comments';
                  }
                  return null;
                }
            ),
            SizedBox(height: 8.0),
            TextFormField(
              controller: dateController,
              decoration: InputDecoration(
                  icon: Icon(Icons.date_range),
                  hintText: 'Date [YYYY-MM-DD]',
                  border: OutlineInputBorder(
                      borderSide: BorderSide()
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[100])
                  )
              ),
            ),
            SizedBox(height: 8.0),
            TextFormField(
                controller: timeController,
                decoration: InputDecoration(
                    icon: Icon(Icons.timer),
                    hintText: 'Time [hh:mm]',
                    border: OutlineInputBorder(
                        borderSide: BorderSide()
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[100])
                    )
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a time';
                  }
                  return null;
                }
            ),
            SizedBox(height: 8.0),
            TextFormField(
                controller: systolicController,
                decoration: InputDecoration(
                    icon: Icon(Icons.favorite),
                    hintText: 'Systolic Reading',
                    border: OutlineInputBorder(
                        borderSide: BorderSide()
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[100])
                    )
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter the systolic value';
                  }
                  return null;
                }
            ),
            SizedBox(height: 8.0),
            TextFormField(
                controller: diastolicController,
                decoration: InputDecoration(
                    icon: Icon(Icons.favorite_border),
                    hintText: 'Diastolic Reading',
                    border: OutlineInputBorder(
                        borderSide: BorderSide()
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[100])
                    )
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter the diastolic value';
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
                    _create(
                      titleController.text,
                      commentsController.text,
                      dateController.text,
                      timeController.text,
                      systolicController.text,
                      diastolicController.text,
                    );
                  }
                },
                child: Text('Save'),
                color: Colors.deepOrange[600],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
              ),
            ),
          ]
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(25.0),
        child: Center(
          child: ListView(
            children: <Widget>[
              Text(
                  'New Reading',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 40.0,
                  )
              ),
              SizedBox(height: 50.0),
              _createForm(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Icon(Icons.arrow_back),
        backgroundColor: Colors.deepOrange[500],
        foregroundColor: Colors.white,
      ),
    );
  }
}
