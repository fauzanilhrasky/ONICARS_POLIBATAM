import 'package:cloud_firestore/cloud_firestore.dart';

class DriverModel {
  String id;
  String name;
  String imageUrl;

  DriverModel({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  DriverModel.fromSnapshot(DocumentSnapshot snapshot)
      : id = snapshot.id,
        name = snapshot['name'],
        imageUrl = snapshot['imageUrl'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'imageUrl': imageUrl,
      };
}
