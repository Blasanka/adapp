import 'package:ad_app/image_page_view.dart';
import 'package:ad_app/model/ad.dart';
import 'package:flutter/material.dart';

class ViewDetailedAdPage extends StatefulWidget {
  ViewDetailedAdPage({Key key, this.ad, this.username}) : super(key: key);

  final Ad ad;
  final String username;

  @override
  _ViewDetailedAdPageState createState() => _ViewDetailedAdPageState();
}

class _ViewDetailedAdPageState extends State<ViewDetailedAdPage> {
  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w200,
        fontSize: 15.0,
        fontFamily: 'PT_Sans');

    Ad thisAd = widget.ad;

    return Scaffold(
      backgroundColor: Color(0xFFEEEEEE),
      body: SafeArea(
        child: ListView(children: <Widget>[
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: getTextWidget(
                            thisAd.title,
                            textStyle.copyWith(
                                fontWeight: FontWeight.w700, fontSize: 22.0)),
                      ),
                    ),
                    IconButton(
                      padding: EdgeInsets.only(top: 4.0),
                      color: Colors.grey,
                      icon: Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                SizedBox(height: 10.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: getTextWidget(
                      thisAd.description,
                      textStyle.copyWith(
                          color: Color(0xFF666666),
                          fontWeight: FontWeight.w300,
                          fontSize: 16.0)),
                ),
                SizedBox(height: 10.0),
                _getRow(
                    'Rs. ${thisAd.price.toString()}',
                    textStyle.copyWith(
                        fontWeight: FontWeight.w600, fontSize: 18.0),
                    Icons.monetization_on),
                _getRow(widget.username, textStyle, Icons.person),
                _getRow(thisAd.email, textStyle, Icons.email),
                _getRow(thisAd.contact, textStyle, Icons.contact_phone),
              ],
            ),
          ),
          SizedBox(height: 8.0),
          _getImage(thisAd, context),
        ]),
      ),
    );
  }

  Widget getTextWidget(String text, textStyle) {
    return new Text(
      '${(text != null) ? text : 'text'}',
      style: textStyle,
    );
  }

  Widget _getRow(String text, TextStyle textStyle, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22.0),
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(icon),
            onPressed: null,
          ),
          SizedBox(width: 10.0),
          getTextWidget(text, textStyle),
        ],
      ),
    );
  }

  Widget _getImage(Ad ad, BuildContext context) {
    return (ad.imageUrl != null)
        ? Container(child: ImageView(ad: ad))
        : SizedBox();
  }
}
