import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../model/payment_model.dart';
import '../../payment/payment_screen.dart';

class NotYetPaidScreen extends StatefulWidget {
  const NotYetPaidScreen({super.key});

  @override
  State<NotYetPaidScreen> createState() => _NotYetPaidScreenState();
}

class _NotYetPaidScreenState extends State<NotYetPaidScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<DocumentSnapshot> getUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    } else {
      throw ("No user logged in");
    }
  }

  Future<Map<String, Map<String, String>>> _fetchCarDetails(
      List<String> carIds) async {
    var carDetails = <String, Map<String, String>>{};
    for (var carId in carIds) {
      var carSnapshot =
          await FirebaseFirestore.instance.collection('cars').doc(carId).get();
      var carData = carSnapshot.data();
      if (carData != null) {
        carDetails[carId] = {
          'name': carData['name'] ?? 'Unknown Car',
          'type': carData['type'] ?? 'Unknown Car',
          'imageUrl': carData['imageUrl'] ?? 'Unknown Car'
        };
      } else {
        carDetails[carId] = {
          'name': 'Unknown Car',
          'type': 'Unknown Car',
          'imageUrl': 'Unknown Car',
        };
      }
    }
    return carDetails;
  }

  @override
  Widget build(BuildContext context) {
    String currentUserId = _auth.currentUser?.uid ?? "";
    return Scaffold(
      backgroundColor: const Color(0xFF29233B),
      appBar: AppBar(
        title: const Text('Belum Bayar'),
        backgroundColor: const Color(0xFF110925),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('payments')
            .where('userId', isEqualTo: currentUserId)
            .where('paymentStatus', isEqualTo: 'Belum Bayar')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Something went wrong'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'Tidak ada data tersedia',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
            );
          }

          var payments = snapshot.data!.docs
              .map((doc) => PaymentModel.fromSnapshot(doc))
              .toList();
          var carIds =
              payments.map((payment) => payment.carId).toSet().toList();

          return FutureBuilder(
            future: _fetchCarDetails(carIds),
            builder: (context,
                AsyncSnapshot<Map<String, Map<String, String>>>
                    carDetailsSnapshot) {
              if (carDetailsSnapshot.connectionState ==
                  ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (carDetailsSnapshot.hasError || !carDetailsSnapshot.hasData) {
                return const Center(child: Text('Failed to load car details'));
              }

              var carDetails = carDetailsSnapshot.data!;

              return ListView.builder(
                itemCount: payments.length,
                itemBuilder: (context, index) {
                  var payment = payments[index];
                  var carDetail = carDetails[payment.carId] ??
                      {
                        'name': 'Unknown Car',
                        'type': 'Unknown Car',
                        'imageUrl': 'Unknown Car'
                      };

                  return Card(
                    margin: const EdgeInsets.all(10.0),
                    clipBehavior: Clip.antiAlias,
                    color: const Color(0xFF110925),
                    elevation: 2.0,
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: ListTile(
                        leading: Container(
                          width: 130,
                          height: 90,
                          child: Image.network(
                            carDetail['imageUrl']!,
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Text(
                          '${carDetail['name']!}\n ${carDetail['type']!}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        subtitle: Container(
                          margin: const EdgeInsets.only(
                              top: 8.0), // Tambahkan margin di atas subtitle
                          child: Text(
                            'jemput: ${payment.datePickUp} WIB \nJadwal: ${payment.dateRent}',
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        trailing: Text(
                          payment.paymentStatus,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: Colors.white),
                        ),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                PaymentScreen(dataPayment: payment),
                          ));
                        },
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
