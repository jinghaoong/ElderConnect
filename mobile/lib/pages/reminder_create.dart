import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/pages/reminders.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReminderCreate extends StatefulWidget {
  @override
  _ReminderCreateState createState() => _ReminderCreateState();
}

class _ReminderCreateState extends State<ReminderCreate> {

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController currDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController timeFirstController = TextEditingController();
  TextEditingController timeSecondController = TextEditingController();
  TextEditingController timeThirdController = TextEditingController();
  TextEditingController timeFourthController = TextEditingController();

  _create(String title, desc, currDate, endDate, t1, t2, t3, t4) async {
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

    var response = await http.post('http://127.0.0.1:8000/api/api_reminders/',
        body: data,
        headers: {"Authorization": "Token " + token});

    if (response.statusCode == 201) {
      setState(() {
        _isLoading = false;
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => RemindersPage()),
                (route) => false);
      });
    } else {
      print(response.body);
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
                controller: descController,
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
                controller: currDateController,
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
                controller: endDateController,
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
                controller: timeFirstController,
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
                controller: timeSecondController,
                decoration: InputDecoration(
                    hintText: 'Time 2 [hh:mm]',
                ),
            ),
            TextFormField(
              controller: timeSecondController,
              decoration: InputDecoration(
                  hintText: 'Time 3 [hh:mm]',
              ),
            ),
            TextFormField(
              controller: timeSecondController,
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
                  _create(
                    titleController.text,
                    descController.text,
                    currDateController.text,
                    endDateController.text,
                    timeFirstController.text,
                    timeSecondController.text,
                    timeThirdController.text,
                    timeFourthController.text,
                  );
                },
                child: Text('Save'),
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                    'New Reminder',
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
