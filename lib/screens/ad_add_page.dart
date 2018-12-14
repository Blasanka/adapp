import 'dart:io';
import 'package:path/path.dart' as p;

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ad_app/add_image_section.dart';
import 'package:ad_app/model/ad.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AdCreatePage extends StatefulWidget {
  AdCreatePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _AdCreatePageState createState() => _AdCreatePageState();
}

class _AdCreatePageState extends State<AdCreatePage> {
  final formKey = GlobalKey<FormState>();

  String _title, _description, _contact, _imageUrl;
  double _price;
  List<File> _images;

  final adReference =
      FirebaseDatabase.instance.reference().child('add-app').child('ad');

  StorageReference reference;

  @override
  void initState() {
    _images = [];
    super.initState();
  }

  void _getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _images.add(image);
    });

    if (_images.length > 0) {
      FirebaseStorage _storage = FirebaseStorage.instance;
      reference = _storage
          .ref()
          .child("ads_images")
          .child(widget.title)
          .child(p.basename(image.path));

      if (!reference.putFile(_images[_images.length - 1]).isSuccessful) {
        print('uploading....');
      } else {
        print('unsuccessful!');
      }

      _imageUrl = await reference.getDownloadURL() as String;
    }
  }

  bool _validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void _createAd() async {
    if (_validateAndSave()) {
      List<String> images = _images.map((m) => m.path).toList();
      Ad ad = new Ad(
          title: _title,
          description: _description,
          price: _price,
          contact: _contact,
          imageUrl: images,
          email: widget.title); //upcoming emailR
      formKey.currentState.reset();
      try {
        adReference.push().set(ad.toJson()).then((_) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text('Successfully added'),
              );
            },
          );
        });
      } catch (e) {
        print('error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF00bcd4),
        appBar: AppBar(
          title: Text(widget.title),
          backgroundColor: Color(0xFF008394),
        ),
        body: Padding(
          padding: EdgeInsets.all(20.0),
          child: Form(
            key: formKey,
            child: new ListView(children: <Widget>[
              new TextFormField(
                decoration:
                    InputDecoration(hintText: 'Title', labelText: 'Title'),
                onSaved: (value) => _title = value,
                validator: (value) =>
                    (value.isEmpty) ? 'Cannot be emplty' : null,
              ),
              new TextFormField(
                decoration: InputDecoration(
                    hintText: 'Description', labelText: 'description'),
                onSaved: (value) => _description = value,
                validator: (value) =>
                    (value.isEmpty) ? 'Cannot be emplty' : null,
              ),
              new TextFormField(
                decoration:
                    InputDecoration(hintText: 'Price', labelText: 'price'),
                onSaved: (value) => _price = double.tryParse(value),
                validator: (value) =>
                    (value.isEmpty) ? 'Cannot be emplty' : null,
              ),
              new TextFormField(
                decoration:
                    InputDecoration(hintText: 'Contact', labelText: 'contact'),
                onSaved: (value) => _contact = value,
                validator: (value) =>
                    (value.isEmpty) ? 'Cannot be emplty' : null,
              ),
              ImageWidgetSection(_getImage, reference, _images ?? []),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    RaisedButton(
                      color: Color(0xFF008394),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Add',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                      onPressed: _createAd,
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ));
  }

  @override
  void dispose() {
    super.dispose();
  }
}
