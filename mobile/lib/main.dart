import 'package:flutter/material.dart';
import 'package:mobile/pages/home.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => Home(),
      /*
      '/login': (context) => Login(),
      '/register': (context) => Register(),
      '/dashboard': (context) => Dashboard(),
       */
    }
  ));
}
