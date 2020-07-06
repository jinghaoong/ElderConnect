import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile/pages/reminder_create.dart';
import 'package:mobile/pages/dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RemindersPage extends StatefulWidget {
  @override
  _RemindersPageState createState() => _RemindersPageState();
}

class Reminder {
  final int userId;
  final int pk;
  final String title;
  final String description;
  final String currentDate;
  final String endDate;
  final String time1;
  final String time2;
  final String time3;
  final String time4;
  final String imgUrl;

  Reminder({
    this.userId, this.pk, this.title, this.description, this.currentDate,
    this.endDate, this.time1, this.time2, this.time3, this.time4, this.imgUrl
  });

  factory Reminder.fromJson(Map<String, dynamic> json) {
    return Reminder(
        pk: json['id'],
        title: json['title'],
        description: json['description'],
        currentDate: json['date_current'],
        endDate: json['date_end'],
        time1: json['time_1'],
        time2: json['time_2'],
        time3: json['time_3'],
        time4: json['time_4'],
        imgUrl: json['medicine_image'],
        userId: json['user'],
    );
  }
}

Future<List<Reminder>> fetchReminders() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String token = sharedPreferences.get("token");
  var jsonData;
  var url = 'http://127.0.0.1:8000/api/api_reminders/';
  var response = await http.get(url, headers: {
    "Authorization": "Token " + token,
  });

  if (response.statusCode == 200) {
    return jsonData = (jsonDecode(response.body) as List)
        .map((data) => Reminder.fromJson(data))
        .toList();
  }
  else {
    throw Exception("Unable to retrieve Reminders");
  }
}

String timeString(String t1, String t2, String t3, String t4) {
  String times = t1;
  if (t2 != null) times += '  |  ' + t2;
  if (t3 != null) times += '\n' + t3;
  if (t4 != null) times += '  |  ' + t4;

  return times;
}

class _RemindersPageState extends State<RemindersPage> {

  Future<List<Reminder>> _remindersFuture;

  @override
  void initState() {
    super.initState();
    _remindersFuture = fetchReminders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reminders'),
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.archive),
          ),
        ],
        centerTitle: true,
        backgroundColor: Colors.teal[700],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text(
                  'ElderConnect+',
                  style: TextStyle(fontSize: 25.0)
              ),
              decoration: BoxDecoration(
                color: Colors.teal[700],
              ),
            ),
            ListTile(
              title: Text('Dashboard'),
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (BuildContext context) => Dashboard()),
                    (route) => false);
              },
            ),
            ListTile(
              title: Text('Reminders'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => RemindersPage()));
              },
            ),
          ],
        ),
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
                  return ExpansionTile(
                    backgroundColor: Colors.grey[800],
                    title: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(reminder.title),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 8.0),
                      child: Text(times),
                    ),
                    trailing: Wrap(
                      children: <Widget>[
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.delete),
                        ),
                      ],
                    ),
                    children: <Widget>[
                      Image.network(reminder.imgUrl),
                      SizedBox(height: 8.0),
                      Text(reminder.description),
                      SizedBox(height: 6.0),
                    ],
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (BuildContext context) => ReminderCreate()));
          },
        child: Icon(Icons.add),
        backgroundColor: Colors.teal[300],
        foregroundColor: Colors.white,
      ),
    );
  }
}

