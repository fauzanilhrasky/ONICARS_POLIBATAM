import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String uid;
  String name;
  String email;
  String gender;
  bool isAdmin;
  String sim;
  String noTelp;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.gender,
    required this.isAdmin,
    required this.sim,
    required this.noTelp,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      gender: map['gender'] ?? '',
      isAdmin: map['isAdmin'] ?? false,
      sim: map['sim'] ?? '',
      noTelp: map['noTelp'] ?? '',
    );
  }

  factory UserModel.fromSnapshot(DocumentSnapshot doc) {
    return UserModel.fromMap(doc.data() as Map<String, dynamic>);
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'gender': gender,
      'isAdmin': isAdmin,
      'sim': sim,
      'noTelp': noTelp,
    };
  }
}
