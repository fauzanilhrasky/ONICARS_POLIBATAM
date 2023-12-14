import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentModel {
  String id;
  String carId;
  String userId;
  String? imageSim;
  String? imageKtp;
  String dateRent;
  int durationRent;
  String? locationDestination;
  String locationPickUp;
  String datePickUp;
  String userName;
  String userContact;
  bool isWithDriver;
  String trfMethod;
  int priceRent;
  String paymentStatus;
  String? driverId;
  String? driverName;

  PaymentModel({
    required this.id,
    required this.carId,
    required this.userId,
    this.imageSim,
    this.imageKtp,
    required this.dateRent,
    required this.durationRent,
    this.locationDestination,
    required this.locationPickUp,
    required this.datePickUp,
    required this.userName,
    required this.userContact,
    required this.isWithDriver,
    required this.trfMethod,
    required this.priceRent,
    required this.paymentStatus,
    this.driverId,
    this.driverName,
  });

  PaymentModel.fromSnapshot(DocumentSnapshot snapshot)
      : id = snapshot.id,
        carId = snapshot['carId'],
        userId = snapshot['userId'],
        imageSim = snapshot['imageSim'],
        imageKtp = snapshot['imageKtp'],
        dateRent = snapshot['dateRent'],
        durationRent = snapshot['durationRent'],
        locationDestination = snapshot['locationDestination'],
        locationPickUp = snapshot['locationPickUp'],
        datePickUp = snapshot['datePickUp'],
        userName = snapshot['userName'],
        userContact = snapshot['userContact'],
        isWithDriver = snapshot['isWithDriver'],
        trfMethod = snapshot['trfMethod'],
        priceRent = snapshot['priceRent'],
        paymentStatus = snapshot['paymentStatus'],
        driverId = snapshot['driverId'],
        driverName = snapshot['driverName'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'carId': carId,
        'userId': userId,
        'imageSim': imageSim,
        'imageKtp': imageKtp,
        'dateRent': dateRent,
        'durationRent': durationRent,
        'locationDestination': locationDestination,
        'locationPickUp': locationPickUp,
        'datePickUp': datePickUp,
        'userName': userName,
        'userContact': userContact,
        'isWithDriver': isWithDriver,
        'trfMethod': trfMethod,
        'priceRent': priceRent,
        'paymentStatus': paymentStatus,
        'driverId': driverId,
        'driverName': driverName,
      };
}
