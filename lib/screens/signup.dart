import 'package:ad_app/screens/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  SignupPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final formKey = GlobalKey<FormState>();

  final usersReference =
      FirebaseDatabase.instance.reference().child('add-app').child('users');

  String _email;
  String _password;
  String _username;

  bool _validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void _addUser() async {
    if (_validateAndSave()) {
      try {
        FirebaseUser user = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: _email, password: _password);
        if (user.uid.isNotEmpty) {
          usersReference.push().set({'email': _email, 'username': _username});
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text('Successfully added, please sign in!'),
                actions: <Widget>[
                  FlatButton(
                    child: Text('SIGN IN'),
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginPage(title: 'Login')),
                          (Route<dynamic> route) => false);
                    },
                  ),
                ],
              );
            },
          );
        } else {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text('Cannot add this user!'),
              );
            },
          );
        }
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text('Email address taken!'),
            );
          },
        );
        print('error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xFF00bcd4),
      backgroundColor: Color(0xFFEEEEEE),
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Color(0xFF008394),
      ),
      body: Padding(
        padding: EdgeInsets.all(25.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Name', border: OutlineInputBorder()),
                  onSaved: (value) => _username = value,
                  validator: (value) =>
                      value.isEmpty ? 'Userame cant be empty' : null,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Email', border: OutlineInputBorder()),
                  onSaved: (value) => _email = value,
                  validator: (value) =>
                      value.isEmpty ? 'Name cant be empty' : null,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                      labelText: 'Password', border: OutlineInputBorder()),
                  onSaved: (value) => _password = value,
                  validator: (value) =>
                      value.isEmpty ? 'Name cant be empty' : null,
                ),
              ),
              Row(
                children: <Widget>[
                  RaisedButton(
                    color: Color(0xFF008394),
                    child: Text('Signup'),
                    onPressed: _addUser,
                  ),
                  SizedBox(width: 5.0),
                  InkWell(
                    splashColor: Color(0xFF008394),
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginPage(title: 'Login')),
                          (Route<dynamic> route) => false);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          Text(
                            'Already a member? ',
                            style: TextStyle(
                                fontSize: 14.0, color: Colors.black54),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Text(
                            'Sign In',
                            style: TextStyle(
                                fontSize: 16.0, color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
