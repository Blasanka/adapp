import 'package:ad_app/model/ad.dart';
import 'package:ad_app/model/user.dart';
import 'package:ad_app/screens/ad_add_page.dart';
import 'package:ad_app/screens/edit_ad.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class UserAdItemList extends StatefulWidget {
  const UserAdItemList({this.title, this.user});

  final String title;
  final User user;

  _UserAdItemListState createState() => _UserAdItemListState();
}

class _UserAdItemListState extends State<UserAdItemList> {
  int _currentIndex = 0;

  DatabaseReference dbRef =
      FirebaseDatabase.instance.reference().child("add-app").child('ad');

  @override
  Widget build(BuildContext context) {
    Query userRef = dbRef.orderByChild('email').equalTo(widget.user.email);
    return StreamBuilder(
        stream: userRef.onValue,
        builder: (BuildContext context, AsyncSnapshot<Event> snapshot) {
          if (snapshot.hasData) {
            Map<dynamic, dynamic> map = snapshot.data.snapshot.value;
            if (map != null) {
              return new ListView.builder(
                itemCount: map.values.toList().length,
                padding: const EdgeInsets.all(2.0),
                itemBuilder: (BuildContext context, int index) {
                  Ad ad = Ad.fromAdJson(map.values.toList()[index]);
                  return _buildItem(ad);
                },
              );
            } else {
              return Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("You haven't posted any ads, yet"),
                    SizedBox(width: 4.0),
                    InkWell(
                      child: Text('Create an Ad',
                          style: TextStyle(color: Colors.blueAccent)),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AdCreatePage(
                                    title: widget.user.username ?? 'anonymous',
                                    email: widget.user.email)));
                      },
                    ),
                  ],
                ),
              );
            }
          } else {
            return Center(
              child: new CircularProgressIndicator(),
            );
          }
        });
  }

  Widget _buildItem(Ad ad) {
    TextStyle textStyle = TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w200,
        fontSize: 15.0,
        fontFamily: 'PT_Sans');

    return Padding(
      key: Key(ad.title),
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 12.0),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(ad.imageUrl[0]),
        ),
        title: Text(ad.title ?? 'loading..',
            style: textStyle.copyWith(fontSize: 18.0)),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                // Text(ad.description ?? 'loading...'),
                SizedBox(width: 16.0),
                Text('Manage this Ad: '),
                IconButton(
                    tooltip: 'EDIT',
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  AdEditPage(title: 'Edit this Ad')));
                      // builder: (context) => EditPage(title: 'Login')));
                    }),
                SizedBox(width: 16.0),
                IconButton(
                    tooltip: 'DELETE',
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      showDialog(
                        context: context,
                        child: new AlertDialog(
                          title: Text("Are you sure ?"),
                          content: Text(
                              "'${ad.title}' will be permanently deleted!"),
                          actions: [
                            new FlatButton(
                              child: const Text("CANCEL"),
                              onPressed: () =>
                                  Navigator.of(context, rootNavigator: true)
                                      .pop('dialog'),
                            ),
                            new FlatButton(
                                child: const Text("DELETE"),
                                onPressed: () {
                                  setState(() {
                                    dbRef
                                        .orderByChild(ad.title)
                                        .equalTo(ad.title)
                                        .once()
                                        .then((DataSnapshot snapshot) {
                                      Map map = snapshot.value;
                                      String snapShotKeyToDel =
                                          map.keys.toList()[0].toString();
                                      dbRef.child(snapShotKeyToDel).remove();
                                    });
                                  });
                                  Navigator.of(context, rootNavigator: true)
                                      .pop('dialog');
                                }),
                          ],
                        ),
                      );
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
