import 'dart:io';
import 'package:path/path.dart' as p;

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ad_app/add_image_section.dart';
import 'package:ad_app/model/ad.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AdCreatePage extends StatefulWidget {
  AdCreatePage({Key key, this.title, this.email}) : super(key: key);

  final String title;
  final String email;

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

  StorageReference mainStorageReference, storageReference;

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
  }

  Future<List<String>> _addToStorage() async {

    List<String> _downloadableImageUrls = [];

    if (_images.length > 0) {
      FirebaseStorage _storage = FirebaseStorage.instance;
      mainStorageReference = _storage
          .ref()
          .child("ads_images")
          .child(widget.title);

      for (var image in _images) {
        storageReference = mainStorageReference.child(p.basename(image.path));
        if (!storageReference.putFile(image).isComplete) {
          _imageUrl = await storageReference.getDownloadURL() as String;
          _downloadableImageUrls.add(_imageUrl);
          print('pending...');
        } else {
          print('success....');
        } 
        // showDialog(
        //   context: context,
        //   barrierDismissible: false,
        //   builder: (context) => new Dialog(
        //     child: new Column(
        //       mainAxisSize: MainAxisSize.min,
        //       children: [
        //         new CircularProgressIndicator(),
        //         new Text("Please, wait a second!"),
        //       ],
        //     ),
        //   ),
        // );
        // new Future.delayed(new Duration(seconds: 2), () {
        //   Navigator.pop(context);
        // });
      }
    }
    return _downloadableImageUrls;
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
      List<String> images = await _addToStorage();
      images.forEach((f)=>print(f));
      Ad ad = new Ad(
          title: _title,
          description: _description,
          price: _price,
          contact: _contact,
          imageUrl: images,
          email: widget.email); //upcoming emailR
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
      
      formKey.currentState.reset();
      setState(() {
        _images = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFEEEEEE),
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
                keyboardType: TextInputType.number,
                decoration:
                    InputDecoration(hintText: 'Price', labelText: 'price', prefix: Text('Rs.')),
                onSaved: (value) => _price = double.tryParse(value),
                validator: (value) =>
                    (value.isEmpty) ? 'Cannot be emplty' : null,
              ),
              new TextFormField(
                keyboardType: TextInputType.number,
                decoration:
                    InputDecoration(hintText: 'Contact', labelText: 'contact'),
                onSaved: (value) => _contact = value,
                validator: validateMobile,
              ),
              ImageWidgetSection(_getImage, storageReference, _images ?? []),
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

  String validateMobile(String value) {
    if (value.length != 10)
      return 'Mobile Number must be of 10 digit';
    else
      return null;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
