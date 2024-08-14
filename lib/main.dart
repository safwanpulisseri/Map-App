import 'package:flutter/material.dart';
import 'package:flutter_application_3/flutter/flutter_map.dart';
import 'package:flutter_application_3/screens/booking_ui.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Services',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MapScreenTwo(),
    );
  }
}
