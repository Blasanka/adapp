import 'package:ad_app/model/ad.dart';
import 'package:flutter/material.dart';

class AdListItem extends StatelessWidget {
  final Ad ad;

  AdListItem(this.ad);

  @override
  Widget build(BuildContext context) {
    double cardWidth = MediaQuery.of(context).size.width - 20.0;
    TextStyle textStyle = TextStyle(
        color: Colors.black,
        fontSize: 18.0,
        fontFamily: 'PT_Sans',
        fontWeight: FontWeight.w400);

    return new Padding(
      padding: new EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Container(
        width: cardWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3.0),
        ),
        child: Card(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _displayImage(cardWidth),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(ad.title,
                      style: textStyle.copyWith(fontWeight: FontWeight.w600)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(ad.description,
                      style: textStyle.copyWith(
                          fontSize: 14.0, color: Color(0xFF888888))),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text('Rs. ${ad.price.toString()}',
                      style: textStyle.copyWith(fontSize: 14.0)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _displayImage(double cardWidth) {
    return Container(
      child: Image.network(
        ad.imageUrl[0],
        fit: BoxFit.cover,
        width: cardWidth,
        height: 100.0,
      ),
    );
  }
}
