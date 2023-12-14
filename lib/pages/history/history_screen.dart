import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:rent_car/pages/history/detail_history_screen.dart';

import '../../../model/payment_model.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<DocumentSnapshot> getUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    } else {
      throw ("No user logged in");
    }
  }

  Future<Map<String, String>> _fetchCarNames(List<String> carIds) async {
    var carNames = <String, String>{};
    for (var carId in carIds) {
      var carSnapshot =
          await FirebaseFirestore.instance.collection('cars').doc(carId).get();
      carNames[carId] = carSnapshot.data()?['name'] ?? 'Unknown Car';
    }
    return carNames;
  }

  @override
  Widget build(BuildContext context) {
    String currentUserId = _auth.currentUser?.uid ?? "";
    return Scaffold(
      backgroundColor: const Color(0xFF29233B),
      appBar: AppBar(
        title: const Text('Daftar Riwayat'),
        backgroundColor: const Color(0xFF110925),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('payments')
            .where('userId', isEqualTo: currentUserId)
            .where('paymentStatus', isEqualTo: 'Selesai')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
                child: Text(
              'Tidak ada data tersedia',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ));
          }

          var payments = snapshot.data!.docs
              .map((doc) => PaymentModel.fromSnapshot(doc))
              .toList();
          var carIds =
              payments.map((payment) => payment.carId).toSet().toList();

          return FutureBuilder(
            future: _fetchCarNames(carIds),
            builder:
                (context, AsyncSnapshot<Map<String, String>> carNamesSnapshot) {
              if (carNamesSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (carNamesSnapshot.hasError || !carNamesSnapshot.hasData) {
                return const Text('Failed to load car names');
              }

              var carNames = carNamesSnapshot.data!;

              return ListView.builder(
                itemCount: payments.length,
                itemBuilder: (context, index) {
                  var payment = payments[index];
                  var carName = carNames[payment.carId] ?? 'Unknown Car';

                  return ListTile(
                    title: Text(
                      carName,
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                    ),
                    subtitle: Text(
                      payment.isWithDriver == true
                          ? 'Dengan Supir'
                          : 'Tanpa Supir',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                      ),
                    ),
                    trailing: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          DateFormat('dd MMMM yyyy')
                              .format(DateTime.parse(payment.dateRent)),
                          style: const TextStyle(color: Colors.white60),
                        ),
                        Text(
                          '${payment.datePickUp} WIB',
                          style: const TextStyle(color: Colors.white60),
                        )
                      ],
                    ),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            DetailHistoryScreen(dataPayment: payment),
                      ));
                    },
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
