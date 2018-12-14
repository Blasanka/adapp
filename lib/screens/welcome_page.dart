import 'package:flutter/material.dart';
import 'package:ad_app/screens/signup.dart';
import 'package:ad_app/screens/login_page.dart';

class WelcomePage extends StatefulWidget {
  WelcomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF00bcd4),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 100.0,
            height: 100.0,
            child: CircleAvatar(
              // child: Text('Ad App'),
              backgroundColor: Color(0xFF1769aa),
              backgroundImage: AssetImage('assets/image/logo.jpg'),
              radius: 10.0,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  RaisedButton(
                    child: Text('Login'),
                    color: Color(0xFF1769aa),
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginPage(title: 'Login')),
                          (Route<dynamic> route) => false);
                    },
                  ),
                  RaisedButton(
                    child: Text('Signup'),
                    color: Color(0xFF1769aa),
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  SignupPage(title: 'Sign up')),
                          (Route<dynamic> route) => false);
                    },
                  ),
                ]),
          ),
        ],
      ),
    );
  }
}
