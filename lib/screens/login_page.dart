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

          Query query = usersReference
              .orderByChild('email')
              .equalTo(user.email);
          if (query != null) {
              query.once()
              .then((DataSnapshot snapshot) {
                Map<dynamic, dynamic> snap = snapshot.value;
                List<User> users =
                    snap.values.map((u) => User.fromJsonUser(u)).toList();

                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(curentUser: users[0]),
                    ),
                    (Route<dynamic> route) => false);
              });
          } else {
            print('why why why????');
          }
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
              content: Text('Cannot login!'),
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
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      labelText: 'Email', border: OutlineInputBorder()),
                  onSaved: (value) => _email = value,
                  validator: validateEmail,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                      labelText: 'Password', border: OutlineInputBorder()),
                  onSaved: (value) => _password = value,
                  validator: validatPassword,
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
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          Text(
                            'Still not a member? ',
                            style: TextStyle(
                                fontSize: 14.0, color: Colors.black54),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Text(
                            'Sign Up',
                            style: TextStyle(
                                fontSize: 16.0, color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 5.0),
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
  
  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }

  String validatPassword(String value) {
    if (value.length < 5)
      return 'Password must be strong';
    else
      return null;
  }

}
