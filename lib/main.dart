import 'package:flutter/material.dart';
import 'package:weatherapp/ui/homepage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Weather App',
        debugShowCheckedModeBanner: false,
        home: HomePage());
  }
}
