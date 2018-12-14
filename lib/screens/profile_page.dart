import 'package:ad_app/user_post_list_view.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w200,
        fontSize: 15.0,
        fontFamily: 'PT_Sans');
    return Scaffold(
      backgroundColor: Color(0xFFEEEEEE),
      // appBar: AppBar(
      //   title: Text(widget.title),
      //   backgroundColor: Color(0xFF008394),
      // ),
      body: Stack(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 4.5,
            decoration: BoxDecoration(
              color: Colors.lightGreen,
            ),
            child: SafeArea(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                      child: Text(widget.title,
                          style: textStyle.copyWith(fontSize: 24.0)),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
          ),
          ExpansionTileSample(),
        ],
      ),
    );
  }
}
