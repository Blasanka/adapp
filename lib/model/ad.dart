import 'package:firebase_database/firebase_database.dart';

class Ad {
  final String key;
  final String title;
  final String description;
  final double price;
  final List<String> imageUrl;
  final String contact;
  final String email;

  const Ad({
    this.key,
    this.title,
    this.description,
    this.price,
    this.imageUrl,
    this.contact,
    this.email,
  });

  Ad.fromJson(Map<String, dynamic> json)
      : key = json['key'],
        title = json['title'],
        description = json['descripton'],
        price = double.parse(json['price'].toString()),
        imageUrl =
            (json['imageUrl'] != null) ? json['imageUrl'].cast<String>() : [],
        contact = json['contact'],
        email = json['email'];

  Ad.fromAdJson(Map<dynamic, dynamic> json)
      : key = json['key'],
        title = json['title'],
        description = json['descripton'],
        price = double.parse(json['price'].toString()),
        imageUrl =
            (json['imageUrl'] != null) ? json['imageUrl'].cast<String>() : [],
        contact = json['contact'],
        email = json['email'];

  Ad.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.value['key'],
        title = snapshot.value['title'],
        description = snapshot.value['description'],
        imageUrl = (snapshot.value['imageUrl'] != null)
            ? snapshot.value['imageUrl'].cast<String>()
            : [],
        email = snapshot.value['email'],
        contact = snapshot.value['contact'],
        price = double.parse(snapshot.value['price'].toString());

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'price': price,
        'imageUrl': imageUrl,
        'email': email,
        'contact': contact
      };
}
