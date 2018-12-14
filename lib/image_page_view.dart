import 'package:ad_app/model/ad.dart';
import 'package:flutter/material.dart';

class ImageView extends StatelessWidget {
  ImageView({this.ad});

  final Ad ad;

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle =
        TextStyle(color: Colors.white, fontSize: 18.0, fontFamily: 'PT_Sans');
    final List<String> images = ad.imageUrl;

    return SizedBox.fromSize(
      size: Size.fromHeight(
        MediaQuery.of(context).size.height / 2,
      ),
      child: PageView.builder(
          controller: PageController(
            initialPage: 1,
            viewportFraction: 0.8,
          ),
          itemCount: images.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
              child: Material(
                color: Colors.white70,
                elevation: 5.0,
                borderRadius: BorderRadius.circular(10.0),
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Ad image ${index + 1}',
                          style: textStyle.copyWith(fontSize: 10.0)),
                    ),
                    TheImage(image: images[index], ad: ad),
                  ],
                ),
              ),
            );
          }),
    );
  }
}

class TheImage extends StatefulWidget {
  TheImage({this.image, this.ad});

  final image;
  final Ad ad;

  _TheImageState createState() => _TheImageState();
}

class _TheImageState extends State<TheImage> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: Image.network(
        widget.image,
        fit: BoxFit.cover,
        width: MediaQuery.of(context).size.width / 4,
        height: MediaQuery.of(context).size.height / 3,
      ),
    );
  }
}
