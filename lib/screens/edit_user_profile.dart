import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class EditAdPage extends StatefulWidget {
  EditAdPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _EditAdPageState createState() => _EditAdPageState();
}

class _EditAdPageState extends State<EditAdPage> {
  final formKey = GlobalKey<FormState>();

  String _email, _currentPassword, _newPassword, _confirmPassword;

  final adReference =
      FirebaseDatabase.instance.reference().child('add-app').child('ad');

  StorageReference reference;

  @override
  void initState() {
    super.initState();
  }

  bool _validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<Null> changePassword(String newPassword) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    const String API_KEY = 'YOUR_API_KEY';
    final String changePasswordUrl =
        'https://www.googleapis.com/identitytoolkit/v3/relyingparty/setAccountInfo?key=$API_KEY';

    final String idToken =
        await user.getIdToken(); // where user is FirebaseUser user

    final Map<String, dynamic> payload = {
      'email': idToken,
      'password': newPassword,
      'returnSecureToken': true
    };

    await http.post(
      changePasswordUrl,
      body: json.encode(payload),
      headers: {'Content-Type': 'application/json'},
    );
  }

  void _createAd() async {
    if (_validateAndSave()) {
      formKey.currentState.reset();
      try {
        adReference.push().set(user.toJson()).then((_) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text('Successfully changed!'),
              );
            },
          );
        });
      } catch (e) {
        print('error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF00bcd4),
        appBar: AppBar(
          title: Text(widget.title),
          backgroundColor: Color(0xFF008394),
        ),
        body: Padding(
          padding: EdgeInsets.all(20.0),
          child: Form(
            key: formKey,
            child: new ListView(children: <Widget>[
              new TextFormField(
                decoration: InputDecoration(
                    hintText: 'Current Password',
                    labelText: 'Current Password'),
                onSaved: (value) => _currentPassword = value,
                validator: (value) =>
                    (value.isEmpty) ? 'Cannot be emplty' : null,
              ),
              new TextFormField(
                decoration: InputDecoration(
                    hintText: 'New Password', labelText: 'New Password'),
                onSaved: (value) => _newPassword = value,
                validator: (value) =>
                    (value.isEmpty) ? 'Cannot be emplty' : null,
              ),
              new TextFormField(
                decoration: InputDecoration(
                    hintText: 'Confirm Password',
                    labelText: 'Confirm Password'),
                onSaved: (value) => _confirmPassword = value,
                validator: (value) =>
                    (value.isEmpty) ? 'Cannot be emplty' : null,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    RaisedButton(
                      color: Color(0xFF008394),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'CHANGE',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                      onPressed: _createAd,
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ));
  }

  @override
  void dispose() {
    super.dispose();
  }
}
