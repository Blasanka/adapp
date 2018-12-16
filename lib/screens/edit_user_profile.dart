import 'package:ad_app/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class EditUserPage extends StatefulWidget {
  EditUserPage({Key key, this.title, this.curentUser}) : super(key: key);

  final String title;
  final User curentUser;

  @override
  _EditUserPageState createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  final formKey = GlobalKey<FormState>();

  String _email, _username, _contact;
  String _currentPassword;
  String _newPassword;
  String _confirmPassword;
  bool _autoValidate = false;

  FirebaseUser _user;

  @override
  void initState() {
    FirebaseAuth.instance.currentUser().then((onValue) {
      setState(() {
        _user = onValue;
      });
    });
    _email = widget.curentUser.email;
    _username = widget.curentUser.username;
    _contact = widget.curentUser.contact;
    super.initState();
  }

  bool _validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    setState(() {
      _autoValidate = true;
    });
    return false;
  }

  void _editUser() async {
    if (_validateAndSave()) {
      try {
        if (_user != null) {
          final usersReference = FirebaseDatabase.instance
              .reference()
              .child('add-app')
              .child('users');

          usersReference
              .orderByChild('email')
              .equalTo(_user.email)
              .once()
              .then((DataSnapshot snapshot) {
            // Map<dynamic, dynamic> snap = snapshot.value;
            // List<User> users =
            //     snap.values.map((u) => User.fromJsonUser(u)).toList();//users[0].toJson()
            User updatedUser = User(
              username: _username,
              email: _email,
              contact: _contact
            );
            usersReference.child(snapshot.value['key']).update(updatedUser.toJson()).then((_) {
              print('Successfully changed!');
            });
            formKey.currentState.reset();
          });
        }
        changePassword(_newPassword);
      } catch (e) {
        print('error: $e');
      }
    }
  }

  Future<Null> changePassword(String newPassword) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();

    setState(() {
      _user = user;
    });

    if (user != null) {
      user.updatePassword(newPassword);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Text('Profile updated!'),
          actions: <Widget>[
            FlatButton(
              child: Row(
                children: <Widget>[
                  Icon(Icons.arrow_back, color: Colors.black),
                  Text('Go Back')
                ],
              ),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
          ],
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFEEEEEE),
        appBar: AppBar(
          title: Text(widget.title),
          backgroundColor: Color(0xFF008394),
        ),
        body: Padding(
          padding: EdgeInsets.all(20.0),
          child: Form(
            key: formKey,
            autovalidate: _autoValidate,
            child: new ListView(children: <Widget>[
              new TextFormField(
                enabled: false,
                initialValue: _email ?? '',
                decoration:
                    InputDecoration(hintText: 'Email', labelText: 'email'),
                onSaved: (value) => _email = value,
                validator: validateEmail,
              ),
              new TextFormField(
                initialValue: _username ?? '',
                decoration: InputDecoration(
                    hintText: 'Username', labelText: 'username'),
                onSaved: (value) => _username = value,
                validator: validateName,
              ),
              new TextFormField(
                keyboardType: TextInputType.number,
                initialValue:  _contact ?? '',
                decoration: InputDecoration(
                    hintText: 'Contact', labelText: 'mobile'),
                onSaved: (value) => _contact = value,
                validator: validateMobile,
              ),
              new TextFormField(
                obscureText: true,
                initialValue: '',
                decoration: InputDecoration(
                    hintText: 'Current Password',
                    labelText: 'Current Password'),
                onSaved: (value) => _currentPassword = value,
                validator: (String arg) {
                  if (arg.length < 5)
                    return 'password must be greater than 5 charaters';
                  else
                    return null;//currentPasswordValidate(arg);
                },
              ),
              new TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                    hintText: 'New Password', labelText: 'New Password'),
                onSaved: (value) => _newPassword = value,
                validator: (String arg) {
                  if (arg.length < 5)
                    return 'password must be greater than 5 charaters';
                  else
                    return null;
                },
              ),
              new TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                    hintText: 'Confirm Password',
                    labelText: 'Confirm Password'),
                onSaved: (value) => _confirmPassword = value,
                validator: (String arg) {
                  if (arg != null)
                    return null;
                  else
                    return 'confirm password do not match!';
                },
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
                      onPressed: _editUser,
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ));
  }

  String validateName(String value) {
    if (value.length < 3)
      return 'Name must be more than 2 charater';
    else
      return null;
  }

  String validateMobile(String value) {
// Indian Mobile number are of 10 digit only
    if (value.length != 10)
      return 'Mobile Number must be of 10 digit';
    else
      return null;
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }

  // currentPasswordValidate(String value) {
  //     return FirebaseAuth.instance.reauthenticateWithEmailAndPassword(email: _email, password: value) as String;
  // }

  @override
  void dispose() {
    super.dispose();
  }
}
