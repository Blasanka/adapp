import 'package:ad_app/model/user.dart';
import 'package:ad_app/screens/home_page.dart';
import 'package:ad_app/screens/signup.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();

  String _email;
  String _password;

  FirebaseUser _firebaseUser;

  bool _validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void _authenticateUser() async {
    if (_validateAndSave()) {
      FirebaseUser user;
      try {
        user = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: _email, password: _password);
        if (user != null) {
          final usersReference = FirebaseDatabase.instance
              .reference()
              .child('add-app')
              .child('users');

          usersReference
              .orderByChild('email')
              .equalTo(user.email)
              .once()
              .then((DataSnapshot snapshot) {
            Map<dynamic, dynamic> snap = snapshot.value;
            List<User> users =
                snap.values.map((u) => User.fromJsonUser(u)).toList();

            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => HomePage(title: users[0].username),
                ),
                (Route<dynamic> route) => false);
          });
        } else {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text('This user cannot find!'),
              );
            },
          );
        }
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text('Err!'),
            );
          },
        );
      } finally {
        if (user != null) {
          //Log in was successfull!
          setState(() {
            _firebaseUser = user;
          });
        }
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
                      labelText: 'Email', border: OutlineInputBorder()),
                  onSaved: (value) => _email = value,
                  validator: (value) =>
                      value.isEmpty ? 'email cant be empty' : null,
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
                      value.isEmpty ? 'Password cant be empty' : null,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  InkWell(
                    splashColor: Color(0xFF008394),
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  SignupPage(title: 'Sign up')),
                          (Route<dynamic> route) => false);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        'or Sign Up',
                        style: TextStyle(fontSize: 16.0, color: Colors.white70),
                      ),
                    ),
                  ),
                  RaisedButton(
                    child: Text('Signin'),
                    color: Color(0xFF008394),
                    onPressed: _authenticateUser,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
