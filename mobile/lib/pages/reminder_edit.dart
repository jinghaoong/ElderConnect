import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mobile/pages/reminders.dart';

class ReminderEdit extends StatefulWidget {
  final Reminder reminder;

  ReminderEdit({Key key, @required this.reminder}) : super(key: key);

  @override
  _ReminderEditState createState() => _ReminderEditState(reminder);
}

class _ReminderEditState extends State<ReminderEdit> {
  Reminder reminder;

  _ReminderEditState(this.reminder); // Constructor

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  TextEditingController _titleController;
  TextEditingController _descController;
  TextEditingController _currDateController;
  TextEditingController _endDateController;
  TextEditingController _timeFirstController;
  TextEditingController _timeSecondController;
  TextEditingController _timeThirdController;
  TextEditingController _timeFourthController;

  @override
  void initState() {
    _titleController = TextEditingController(text: reminder.title);
    _descController = TextEditingController(text: reminder.description);
    _currDateController = TextEditingController(text: reminder.currentDate);
    _endDateController = TextEditingController(text: reminder.endDate);
    _timeFirstController = TextEditingController(text: reminder.time1);
    _timeSecondController = TextEditingController(text: reminder.time2);
    _timeThirdController = TextEditingController(text: reminder.time3);
    _timeFourthController = TextEditingController(text: reminder.time4);
    super.initState();
  }

  _edit(String title, desc, currDate, endDate, t1, t2, t3, t4) async {
    Map data = {
      'title': title,
      'description': desc,
      'date_current': currDate,
      'date_end': endDate,
      'time_1': t1,
      'time_2': t2,
      'time_3': t3,
      'time_4': t4,
    };

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.get('token');

    var response = await http.put(
        'http://127.0.0.1:8000/api/api_reminders/${reminder.pk}/',
        body: data,
        headers: {"Authorization": "Token " + token}
    );

    if (response.statusCode == 200) {
      setState(() {
        _isLoading = false;
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => RemindersPage()),
                (route) => false);
      });
    } else {
      throw Exception("Failed to save Reminder");
    }
  }

  Widget _editForm() {
    return Form(
      key: _formKey,
      child: Column(
          children: <Widget>[
            TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                    icon: Icon(Icons.title),
                    hintText: 'Reminder Title',
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
                maxLines: 3,
                controller: _descController,
                decoration: InputDecoration(
                    icon: Icon(Icons.text_fields),
                    hintText: 'Description',
                    border: OutlineInputBorder(
                        borderSide: BorderSide()
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[100])
                    )
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a short description';
                  }
                  return null;
                }
            ),
            SizedBox(height: 8.0),
            TextFormField(
                controller: _currDateController,
                decoration: InputDecoration(
                    icon: Icon(Icons.date_range),
                    hintText: 'Current Date [YYYY-MM-DD]',
                    border: OutlineInputBorder(
                        borderSide: BorderSide()
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[100])
                    )
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter the current date';
                  }
                  return null;
                }
            ),
            SizedBox(height: 8.0),
            TextFormField(
                controller: _endDateController,
                decoration: InputDecoration(
                    icon: Icon(Icons.date_range),
                    hintText: 'End Date [YYYY-MM-DD]',
                    border: OutlineInputBorder(
                        borderSide: BorderSide()
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[100])
                    )
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter the end date';
                  }
                  return null;
                }
            ),
            SizedBox(height: 8.0),
            TextFormField(
                controller: _timeFirstController,
                decoration: InputDecoration(
                  hintText: 'Time 1 [hh:mm]',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter reminder time';
                  }
                  return null;
                }
            ),
            TextFormField(
              controller: _timeSecondController,
              decoration: InputDecoration(
                hintText: 'Time 2 [hh:mm]',
              ),
            ),
            TextFormField(
              controller: _timeThirdController,
              decoration: InputDecoration(
                hintText: 'Time 3 [hh:mm]',
              ),
            ),
            TextFormField(
              controller: _timeFourthController,
              decoration: InputDecoration(
                hintText: 'Time 4 [hh:mm]',
              ),
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
                      _descController.text,
                      _currDateController.text,
                      _endDateController.text,
                      _timeFirstController.text,
                      _timeSecondController.text,
                      _timeThirdController.text,
                      _timeFourthController.text,
                    );
                  }
                },
                child: Text('Update'),
                color: Colors.teal[600],
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
                    'Edit Reminder',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 40.0,
                    )
                ),
                SizedBox(height: 50.0),
                _editForm(),
              ],
            )
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Icon(Icons.arrow_back),
        backgroundColor: Colors.teal[300],
        foregroundColor: Colors.white,
      ),
    );
  }
}
