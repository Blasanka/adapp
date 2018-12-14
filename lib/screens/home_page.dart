import 'package:ad_app/ad_list_item.dart';
import 'package:ad_app/model/ad.dart';
import 'package:ad_app/screens/ad_add_page.dart';
import 'package:ad_app/screens/view_ad_page.dart';
import 'package:ad_app/screens/profile_page.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Ad> adSaves = new List();

  ScrollController _listViewScrollController = new ScrollController();
  double _itemExtent = 50.0;

  final adReference =
      FirebaseDatabase.instance.reference().child('add-app').child('ad');

  _HomePageState() {
    adReference.onChildAdded.listen(_onEntryAdded);
  }

  @override
  Widget build(BuildContext context) {
    // TextStyle textStyle = TextStyle(color: Colors.white, fontSize: 18.0);

    return Scaffold(
      backgroundColor: Color(0xFFEEEEEE),
      appBar: AppBar(
        title: Text(widget.title ?? 'Profile Page'),
        backgroundColor: Color(0xFF008394),
        leading: IconButton(
          tooltip: 'Your profile',
          icon: const Icon(Icons.face),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ProfilePage(title: widget.title)));
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.menu),
            tooltip: 'options',
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(15.0),
        child: new ListView.builder(
          shrinkWrap: true,
          reverse: true,
          controller: _listViewScrollController,
          itemCount: adSaves.length,
          itemBuilder: (buildContext, index) {
            //calculating difference
            return new InkWell(
                onTap: () => _openViewDialog(adSaves[index]),
                child: new AdListItem(adSaves[index]));
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF008394),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      AdCreatePage(title: widget.title ?? 'anonymous')));
        },
        tooltip: 'Create an add',
        child: Icon(Icons.create),
      ),
    );
  }

  _openViewDialog(Ad ad) {
    Navigator.of(context)
        .push(
      new MaterialPageRoute<Ad>(
        builder: (BuildContext context) {
          return new ViewDetailedAdPage(ad: ad, username: widget.title);
        },
        fullscreenDialog: true,
      ),
    )
        .then((Ad newAd) {
      if (newAd != null) {
        adReference.child(ad.key).set(newAd.toJson());
      }
    });
  }

  _onEntryAdded(Event event) {
    setState(() {
      adSaves.add(new Ad.fromSnapshot(event.snapshot));
    });
    _scrollToTop();
  }

  _onEntryEdited(Event event) {
    var oldValue =
        adSaves.singleWhere((entry) => entry.key == event.snapshot.key);
    setState(() {
      adSaves[adSaves.indexOf(oldValue)] = new Ad.fromSnapshot(event.snapshot);
      adSaves.sort((one, two) => one.price.compareTo(two.price));
    });
  }

  _scrollToTop() {
    _listViewScrollController.animateTo(
      adSaves.length * _itemExtent,
      duration: const Duration(microseconds: 1),
      curve: new ElasticInCurve(0.01),
    );
  }
}
