import 'package:flutter/material.dart';
import 'package:flutterfiretest/login_screen.dart';
//https://medium.com/flutter-community/flutter-crud-operations-using-firebase-cloud-firestore-a7ef38bbf027


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlutterFireTest',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        brightness: Brightness.dark,
      ),
      home: LoginScreen(),
    );
  }
}
