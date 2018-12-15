import 'package:ad_app/screens/login_page.dart';
import 'package:ad_app/screens/welcome_page.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

void main() {
  FirebaseDatabase.instance.setPersistenceEnabled(true);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ad app',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(title: 'Login'), //WelcomePage(title: 'login'),
    );
  }
}
