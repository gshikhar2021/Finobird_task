import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/LoginScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color(0xFF075E54),
      ),
      home: LoginScreen(),
    );
  }
}

