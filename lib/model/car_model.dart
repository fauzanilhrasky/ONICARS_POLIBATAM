import 'package:cloud_firestore/cloud_firestore.dart';

class CarModel {
  String id;
  String name;
  String type;
  String imageUrl;
  String passengerCount;
  int price;
  int maksPassenger;
  int createdYear;
  int maksTrunk;
  String detail;

  CarModel({
    required this.id,
    required this.name,
    required this.type,
    required this.imageUrl,
    required this.passengerCount,
    required this.price,
    required this.maksPassenger,
    required this.createdYear,
    required this.maksTrunk,
    required this.detail,
  });

  CarModel.fromSnapshot(DocumentSnapshot snapshot)
      : id = snapshot.id,
        name = snapshot['name'],
        type = snapshot['type'],
        imageUrl = snapshot['imageUrl'],
        passengerCount = snapshot['passengerCount'],
        price = snapshot['price'],
        maksPassenger = snapshot['maksPassenger'],
        createdYear = snapshot['createdYear'],
        maksTrunk = snapshot['maksTrunk'],
        detail = snapshot['detail'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'type': type,
        'imageUrl': imageUrl,
        'passengerCount': passengerCount,
        'price': price,
        'maksPassenger': maksPassenger,
        'createdYear': createdYear,
        'maksTrunk': maksTrunk,
        'detail': detail,
      };
}
