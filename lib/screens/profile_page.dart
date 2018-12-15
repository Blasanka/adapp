import 'package:ad_app/model/user.dart';
import 'package:ad_app/screens/edit_user_profile.dart';
import 'package:ad_app/user_post_list_view.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key key, this.title, this.curentUser}) : super(key: key);

  final String title;
  final User curentUser;

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
      appBar: PreferredSize(
        preferredSize: Size(MediaQuery.of(context).size.width,
            MediaQuery.of(context).size.height / 3),
        child: Container(
          decoration: new BoxDecoration(
            gradient: new LinearGradient(
                colors: [Color(0xFF84dab0), Color(0xFF8dd3d4)],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(0.5, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp),
          ),
          child: SafeArea(
            child: Column(
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 6.0),
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
                Text(widget.curentUser.username ?? 'Username',
                    style: textStyle.copyWith(
                        color: Colors.white, fontSize: 20.0)),
                Text(
                  'Posted ad count ${29}',
                  style: textStyle.copyWith(color: Colors.white),
                ),
                IconButton(
                  iconSize: 30.0,
                  color: Colors.white,
                  icon: Icon(Icons.settings),
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditUserPage(
                                  title: 'Edit Profile',
                                  curentUser: widget.curentUser,
                                )));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          UserAdItemList(
            title: widget.title,
            user: widget.curentUser,
          ),
        ],
      ),
    );
  }
}
