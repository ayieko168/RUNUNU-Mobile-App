import 'package:flutter/material.dart';
import 'package:rununu_app/add_key.dart';
import 'package:rununu_app/home.dart';
import 'package:rununu_app/new_key_details.dart';
import 'package:rununu_app/key.dart';


void main() {
  runApp(MaterialApp(
    initialRoute: '/home', 
    routes: {
    // '/': (context) => SplashScreen(),
    '/home': (context) => HomePage(),
    '/key': (context) => KeyPage(),
    '/add_key': (context) => AddKeyPage(),
    '/add_key_next': (context) => KeyDetailsPage(),
  }));
}
