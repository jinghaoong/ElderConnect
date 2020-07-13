import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mobile/main.dart';
import 'package:mobile/pages/blood_pressure.dart';

class BloodPressureEdit extends StatefulWidget {
  final BloodPressure bp;

  BloodPressureEdit({Key key, @required this.bp}) : super(key: key);

  @override
  _BloodPressureEditState createState() => _BloodPressureEditState(bp);
}

class _BloodPressureEditState extends State<BloodPressureEdit> {
  BloodPressure bp;

  _BloodPressureEditState(this.bp);

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  TextEditingController _titleController;
  TextEditingController _commentsController;
  TextEditingController _dateController;
  TextEditingController _timeController;
  TextEditingController _systolicController;
  TextEditingController _diastolicController;

  @override
  void initState() {
    _titleController = TextEditingController(text: bp.title);
    _commentsController = TextEditingController(text: bp.comments);
    _dateController = TextEditingController(text: bp.date);
    _timeController = TextEditingController(text: bp.time);
    _systolicController = TextEditingController(text: bp.systolic.toString());
    _diastolicController = TextEditingController(text: bp.diastolic.toString());
    super.initState();
  }


  _edit(String title, comments, date, time, systolic, diastolic) async {
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

    var url = 'http://$host:8000/api/api_bp/${bp.pk}/';
    var response = await http.put(
        url,
        body: data,
        headers: {"Authorization": "Token " + token});

    if (response.statusCode == 200) {
      setState(() {
        _isLoading = false;
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => BloodPressurePage()),
                (route) => false);
      });
    } else {
      throw Exception("Failed to save new Blood Pressure record");
    }
  }

  Widget _createForm() {
    return Form(
      key: _formKey,
      child: Column(
          children: <Widget>[
            TextFormField(
                controller: _titleController,
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
                controller: _commentsController,
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
              controller: _dateController,
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
                controller: _timeController,
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
                controller: _systolicController,
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
                controller: _diastolicController,
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
                    _edit(
                      _titleController.text,
                      _commentsController.text,
                      _dateController.text,
                      _timeController.text,
                      _systolicController.text,
                      _diastolicController.text,
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
    final showFab = MediaQuery.of(context).viewInsets.bottom == 0.0;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(25.0),
        child: Center(
            child: ListView(
              children: <Widget>[
                SizedBox(height: 50.0),
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
            )
        ),
      ),
      floatingActionButton: showFab ? FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Icon(Icons.arrow_back),
        backgroundColor: Colors.deepOrange[500],
        foregroundColor: Colors.white,
      ) : null,
    );
  }
}
