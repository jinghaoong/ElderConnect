import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mobile/pages/reminders.dart';
import 'package:mobile/pages/reminder_detail.dart';
import 'package:mobile/pages/reminder_edit.dart';

class RemindersArchive extends StatefulWidget {
  @override
  _RemindersArchiveState createState() => _RemindersArchiveState();
}

Future<List<Reminder>> fetchReminders() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String token = sharedPreferences.get("token");
  var jsonData;
  var url = 'http://127.0.0.1:8000/api/api_reminders_archive/';
  var response = await http.get(
      url,
      headers: {"Authorization": "Token " + token,}
  );

  if (response.statusCode == 200) {
    return jsonData = (jsonDecode(response.body) as List)
        .map((data) => Reminder.fromJson(data))
        .toList();
  }
  else {
    throw Exception("Unable to retrieve Archived Reminders");
  }
}

class _RemindersArchiveState extends State<RemindersArchive> {
  Future<List<Reminder>> _remindersFuture;
  bool _isLoading = false;

  _deleteReminder(int id) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.get("token");

    var response = await http.delete(
        'http://127.0.0.1:8000/api/api_reminders/$id/',
        headers: {"Authorization": "Token " + token}
    );

    if (response.statusCode == 204) {
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

  @override
  void initState() {
    super.initState();
    _remindersFuture = fetchReminders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Archived Reminders'),
        centerTitle: true,
        backgroundColor: Colors.grey[700],
      ),
      body: Center(
        child: FutureBuilder<List<Reminder>>(
            future: _remindersFuture,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      Reminder reminder = snapshot.data[index];
                      String times = timeString(reminder.time1,
                          reminder.time2,
                          reminder.time3,
                          reminder.time4);
                      return ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ReminderDetail(
                                  reminder: reminder,
                                  times: times
                              ))
                          );
                        },
                        title: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              reminder.title,
                              style: TextStyle(
                                  fontSize: 20.0
                              )
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 8.0),
                          child: Text(
                            times,
                            style: TextStyle(color: Colors.grey[400]),
                          ),
                        ),
                        trailing: Wrap(
                          children: <Widget>[
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ReminderEdit(reminder: reminder),
                                    )
                                );
                              },
                              icon: Icon(Icons.edit),
                            ),
                            IconButton(
                              onPressed: () {
                                final confirmDelete = SnackBar(
                                  backgroundColor: Colors.grey[700],
                                  behavior: SnackBarBehavior.floating,
                                  content: Text(
                                    "Confirm deletion?",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  action: SnackBarAction(
                                    label: 'Delete',
                                    textColor: Colors.white,
                                    onPressed: () {
                                      setState(() {
                                        _isLoading = true;
                                      });
                                      _deleteReminder(reminder.pk);
                                    },
                                  ),
                                );
                                Scaffold.of(context).showSnackBar(confirmDelete);
                              },
                              icon: Icon(Icons.delete),
                              color: Colors.red[400],
                            ),
                          ],
                        ),
                      );
                    }
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return CircularProgressIndicator();
            }
        ),
      ),
    );
  }
}
