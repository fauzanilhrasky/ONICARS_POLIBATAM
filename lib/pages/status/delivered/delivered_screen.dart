import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rent_car/pages/status/delivered/detail_delivered_screen.dart';

import '../../../model/payment_model.dart';

class DeliveredScreen extends StatefulWidget {
  const DeliveredScreen({super.key});

  @override
  State<DeliveredScreen> createState() => _DeliveredScreenState();
}

class _DeliveredScreenState extends State<DeliveredScreen> {
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
        title: const Text('Menuju Lokasi'),
        backgroundColor: const Color(0xFF110925),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('payments')
            .where('userId', isEqualTo: currentUserId)
            .where('paymentStatus', isEqualTo: 'Menuju Lokasi')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Check if the snapshot has data and is not empty
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
                child: Text(
              'Tidak ada data tersedia',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ));
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
                          width: 100,
                          height: 100,
                          child: Image.network(carDetail['imageUrl']!),
                        ),
                        title: Text(
                          carDetail['name']!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        subtitle: Text(
                          '${carDetail['type']!}\npenjemputan: ${payment.datePickUp}\nJadwal: ${payment.dateRent}',
                          style: const TextStyle(
                            color: Colors.white,
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
                                DetailDeliveredScreen(dataPayment: payment),
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
