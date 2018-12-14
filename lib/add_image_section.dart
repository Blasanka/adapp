import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class ImageWidgetSection extends StatefulWidget {
  ImageWidgetSection(this.getImage, this.reference, this.images);

  final getImage;
  final StorageReference reference;
  final List<File> images;

  @override
  _ImageWidgetSectionState createState() => new _ImageWidgetSectionState();
}

class _ImageWidgetSectionState extends State<ImageWidgetSection> {
  bool _imageStatus = true;
  int _imageCount = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        (_imageCount < 3)
            ? IconButton(
                icon: Icon(Icons.album),
                iconSize: 20.0,
                onPressed: widget.getImage,
              )
            : SizedBox(),
        _imageRow(widget.images)
      ],
    );
  }

  Widget _imageRow(List<File> images) {
    return (images.length == 0)
        ? new Text('No image selected.')
        : Row(
            children: images.map((w) {
              setState(() {
                (w != null) ? _imageCount++ : _imageCount--;
              });
              return InkWell(
                onTap: () => _toggleImage(w),
                child: new Container(
                  padding: EdgeInsets.all(4.0),
                  width: 50.0,
                  height: 50.0,
                  child: (w != null)
                      ? Image.file(
                          w,
                          width: 50.0,
                          height: 50.0,
                        )
                      : Image.asset(
                          'assets/image/addimage.png',
                          width: 50.0,
                          height: 50.0,
                        ),
                ),
              );
            }).toList(),
          );
  }

  void _toggleImage(File w) {
    if (_imageStatus) {
      setState(() {
        _imageStatus = false;
        widget.images.remove(w);
        //TODO: delete from firebase
        // widget.reference.delete();
      });
      widget.getImage();
    } else {
      setState(() {
        _imageStatus = true;
        _imageCount++;
      });
    }
    // return _imageStatus;
  }

  // void chooseOrDeleteImage(File w) {
  //   if (_toggleImage(w)) {

  //   }
  // }
}
