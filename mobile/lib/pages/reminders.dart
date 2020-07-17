import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_tts/flutter_tts.dart';

import 'package:mobile/main.dart';
import 'package:mobile/pages/reminder_detail.dart';
import 'package:mobile/pages/reminders_archive.dart';
import 'package:mobile/pages/reminder_create.dart';
import 'package:mobile/pages/reminder_edit.dart';

import 'package:mobile/widgets/sidebar_drawer.dart';

class RemindersPage extends StatefulWidget {
  @override
  _RemindersPageState createState() => _RemindersPageState();
}

enum TtsState { playing, stopped, paused, continued }

class _RemindersPageState extends State<RemindersPage> {

  FlutterTts flutterTts;
  String language = 'en-US';
  double volume = 0.5;
  double pitch = 1.0;
  double rate = 0.2;

  String _voiceText;

  TtsState ttsState = TtsState.stopped;

  ScrollController controller;
  bool showFab = true;
  Future<List<Reminder>> _remindersFuture;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _remindersFuture = fetchReminders();
    controller = ScrollController();
    controller.addListener(() {
      setState(() {
        showFab = controller.position.userScrollDirection == ScrollDirection.forward;
      });
    });
    initTts();
  }

  initTts() {
    flutterTts = FlutterTts();

    if(!kIsWeb) {
      if (Platform.isAndroid) {
        _getEngines();
      }
    }

    flutterTts.setStartHandler(() {
      setState(() {
        print("Playing");
        ttsState = TtsState.playing;
      });
    });

    flutterTts.setCompletionHandler(() {
      setState(() {
        print("Complete");
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setCancelHandler(() {
      setState(() {
        print("Cancel");
        ttsState = TtsState.stopped;
      });
    });

    if (kIsWeb || Platform.isIOS) {
      flutterTts.setPauseHandler(() {
        setState(() {
          print("Paused");
          ttsState = TtsState.paused;
        });
      });

      flutterTts.setContinueHandler(() {
        setState(() {
          print("Continued");
          ttsState = TtsState.continued;
        });
      });
    }

    flutterTts.setErrorHandler((msg) {
      setState(() {
        print("error: $msg");
        ttsState = TtsState.stopped;
      });
    });
  }

  Future _getEngines() async {
    var engines = await flutterTts.getEngines;
    if (engines != null) {
      for (dynamic engine in engines) {
        print(engine);
      }
    }
  }

  Future _speak() async {
    if (_voiceText != null) {
      if (_voiceText.isNotEmpty) {
        var result = await flutterTts.speak(_voiceText);
        if (result == 1) setState(() => ttsState = TtsState.playing);
      }
    }
  }

  Future _stop() async {
    var result = await flutterTts.stop();
    if (result == 1) setState(() => ttsState = TtsState.stopped);
  }

  Future _pause() async {
    var result = await flutterTts.pause();
    if (result == 1) setState(() => ttsState = TtsState.paused);
  }

  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
  }

  _deleteReminder(int id) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.get("token");

    var url = 'http://$host:8000/api/api_reminders/$id/';
    var response = await http.delete(
        url,
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
      throw Exception("Deletion failed");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reminders', style: TextStyle(fontSize: 25.0)),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RemindersArchive())
              );
            },
            icon: Icon(Icons.archive),
          ),
        ],
        backgroundColor: Colors.teal[700],
      ),
      drawer: SidebarDrawer(isTeal: true),
      body: Center(
        child: FutureBuilder<List<Reminder>>(
            future: _remindersFuture,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                int numItems = snapshot.data.length;
                if (numItems == 0) {
                  return Center(
                    child: Text(
                        'No active reminders!',
                        style: TextStyle(fontSize: 30.0),
                        textAlign: TextAlign.center,
                    ),
                  );
                }
                return ListView.builder(
                    controller: controller,
                    itemCount: numItems,
                    itemBuilder: (context, index) {
                      Reminder reminder = snapshot.data[index];
                      String times = timeString(reminder.time1,
                          reminder.time2,
                          reminder.time3,
                          reminder.time4);
                      return ListTile(
                        leading: IconButton(
                          onPressed: () {
                            setState(() {
                              _voiceText = reminder.title + '|' + times;
                            });
                            _speak();
                          },
                          icon: Icon(Icons.hearing),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ReminderDetail(
                                reminder: reminder,
                                times: times,
                                active: true,
                              ))
                          );
                        },
                        title: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                              reminder.title,
                              style: TextStyle(
                                  fontSize: 18.0
                              )
                          ),
                        ),
                        subtitle: Padding(
                          padding: EdgeInsets.fromLTRB(8.0, 0, 0, 8.0),
                          child: Text(
                            times,
                            style: TextStyle(color: Colors.teal[200]),
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
                                  backgroundColor: Colors.teal[700],
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
      floatingActionButton: AnimatedOpacity(
        child: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (BuildContext context) => ReminderCreate()));
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.teal[300],
          foregroundColor: Colors.white,
        ),
        duration: Duration(milliseconds: 400),
        opacity: showFab ? 1 : 0,
      ),
    );
  }
}

class Reminder {
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
    this.pk, this.title, this.description, this.currentDate, this.endDate,
    this.time1, this.time2, this.time3, this.time4, this.imgUrl
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
    );
  }
}

Future<List<Reminder>> fetchReminders() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String token = sharedPreferences.get("token");

  var jsonData;
  var url = 'http://$host:8000/api/api_reminders/';
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

