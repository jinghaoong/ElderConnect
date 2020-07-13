import 'package:flutter/material.dart';
import 'package:mobile/pages/reminders.dart';
import 'package:mobile/pages/reminder_edit.dart';

class ReminderDetail extends StatefulWidget {
  final Reminder reminder;
  final String times;
  final bool active;

  ReminderDetail(
      {Key key,
        @required this.reminder,
        @required this.times,
        @required this.active}
      ) : super(key: key);

  @override
  _ReminderDetailState createState() => _ReminderDetailState(reminder, times, active);
}

class _ReminderDetailState extends State<ReminderDetail> {
  final Reminder reminder;
  final String times;
  final bool active;

  _ReminderDetailState(this.reminder, this.times, this.active);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: active ? Colors.teal[800] : Colors.grey[800],
        child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  '${reminder.title}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30.0,
                  ),
                ),
                SizedBox(height: 30.0),
                Image.network('${reminder.imgUrl}'),
                SizedBox(height: 30.0),
                Text(
                  'Start Date: ${reminder.currentDate}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  'End Date: ${reminder.endDate}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
                SizedBox(height: 16.0),
                Text('${reminder.time1}', style: TextStyle(fontSize: 18.0)),
                reminder.time2 != null ?
                Text('${reminder.time2}', style: TextStyle(fontSize: 18.0)) :
                SizedBox(),
                reminder.time3 != null ?
                Text('${reminder.time3}', style: TextStyle(fontSize: 18.0)) :
                SizedBox(),
                reminder.time4 != null ?
                Text('${reminder.time4}', style: TextStyle(fontSize: 18.0)) :
                SizedBox(),
                SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                  ],
                )
              ],
            )
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Icon(Icons.arrow_back),
        backgroundColor: active ? Colors.teal[300] : Colors.grey[500],
        foregroundColor: Colors.white,
      ),
    );
  }
}
