import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mobile/main.dart';
import 'package:mobile/pages/blood_pressure_create.dart';
import 'package:mobile/pages/blood_pressure_edit.dart';

import 'package:mobile/widgets/sidebar_drawer.dart';

class BloodPressurePage extends StatefulWidget {
  @override
  _BloodPressurePageState createState() => _BloodPressurePageState();
}

class BloodPressure {
  final int pk;
  final String title;
  final String comments;
  final String date;
  final String time;
  final int systolic;
  final int diastolic;

  BloodPressure({
    this.pk, this.title, this.comments, this.date, this.time,
    this.systolic, this.diastolic
  });

  factory BloodPressure.fromJson(Map<String, dynamic> json) {
    return BloodPressure(
      pk: json['id'],
      title: json['title'],
      comments: json['comments'],
      date: json['date'],
      time: json['time'],
      systolic: json['systolic'],
      diastolic: json['diastolic'],
    );
  }
}

Future<List<BloodPressure>> fetchBloodPressure() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String token = sharedPreferences.get("token");

  var jsonData;
  var url = 'http://$host:8000/api/api_bp/';
  var response = await http.get(
      url,
      headers: {"Authorization": "Token " + token,}
  );

  if (response.statusCode == 200) {
    return jsonData = (jsonDecode(response.body) as List)
        .map((data) => BloodPressure.fromJson(data))
        .toList();
  }
  else {
    throw Exception("Unable to retrieve Blood Pressure Records");
  }
}

String _reading(int sys, dia) {
  String reading = '[ ' + sys.toString() + ' / ' + dia.toString() + ' ]';
  return reading;
}

class _BloodPressurePageState extends State<BloodPressurePage> {
  Future<List<BloodPressure>> _bloodPressureFuture;
  bool _isLoading = false;

  _deleteBP(int id) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.get("token");

    var url = 'http://$host:8000/api/api_bp/$id/';
    var response = await http.delete(
        url,
        headers: {"Authorization": "Token " + token,}
    );

    if (response.statusCode == 204) {
      setState(() {
        _isLoading = false;
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => BloodPressurePage()),
                (route) => false);
      });
    } else {
      throw Exception("Deletion failed");
    }
  }

  @override
  void initState() {
    super.initState();
    _bloodPressureFuture = fetchBloodPressure();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Blood Pressure',
            style: TextStyle(fontSize: 25.0)
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
              onPressed: () {},
              icon: Icon(Icons.insert_chart)
          ),
        ],
        backgroundColor: Colors.deepOrange[900],
      ),
      drawer: SidebarDrawer(isTeal: false),
      body: Center(
          child: FutureBuilder<List<BloodPressure>>(
              future: _bloodPressureFuture,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        BloodPressure bp = snapshot.data[index];
                        String reading = _reading(bp.systolic, bp.diastolic);
                        String expandedText = 'Time:  ' + bp.time + '\n' +
                            'Comments:  ' + bp.comments;
                        return ExpansionTile(
                          title: Padding(
                              padding: EdgeInsets.fromLTRB(4.0, 4.0, 4.0, 4.0),
                              child: Text(
                                bp.date + '      ' + reading,
                                style: TextStyle(
                                    fontSize: 20.0,
                                    color: Colors.white
                                ),
                              )
                          ),
                          trailing: Icon(
                              Icons.favorite_border,
                              color: Colors.deepOrange
                          ),
                          children: <Widget>[
                            Text(
                                expandedText,
                                style: TextStyle(fontSize: 18.0)
                            ),
                            ButtonBar(
                                alignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => BloodPressureEdit(bp: bp),
                                            )
                                        );
                                      },
                                      icon: Icon(Icons.edit)
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        final confirmDelete = SnackBar(
                                          backgroundColor: Colors.deepOrange[700],
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
                                              _deleteBP(bp.pk);
                                            },
                                          ),
                                        );
                                        Scaffold.of(context).showSnackBar(confirmDelete);
                                      },
                                      icon: Icon(Icons.delete),
                                      color: Colors.red[400]
                                  ),
                                ]
                            )
                          ],
                        );
                      }
                  );
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                return CircularProgressIndicator();
              }
          )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (BuildContext context) => BloodPressureCreate()));
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.deepOrange[700],
        foregroundColor: Colors.white,
      ),
    );
  }
}
