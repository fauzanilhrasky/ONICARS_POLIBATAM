import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<Map<String, String>> _fetchCarNames(Set<String> carIds) async {
    var carNames = <String, String>{};
    for (var carId in carIds) {
      var carSnapshot = await _firestore.collection('cars').doc(carId).get();
      carNames[carId] = carSnapshot.data()?['name'] ?? 'Unknown Car';
    }
    return carNames;
  }

  @override
  Widget build(BuildContext context) {
    final User? currentUser = _auth.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFF29233B),
      appBar: AppBar(
        title: const Text('Notifikasi'),
        backgroundColor: const Color(0xFF110925),
      ),
      body: currentUser == null
          ? const Center(child: Text('Tidak ada pengguna yang login.'))
          : StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('payments')
                  .where('userId', isEqualTo: currentUser.uid)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text('Terjadi kesalahan');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final documents = snapshot.data?.docs ?? [];
                final carIds =
                    documents.map((doc) => doc['carId'].toString()).toSet();

                return FutureBuilder<Map<String, String>>(
                  future: _fetchCarNames(carIds),
                  builder: (context,
                      AsyncSnapshot<Map<String, String>> carNamesSnapshot) {
                    if (carNamesSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    var carNames = carNamesSnapshot.data ?? {};
                    return ListView(
                      children: documents.map((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data()! as Map<String, dynamic>;
                        String carName =
                            carNames[data['carId']] ?? 'Unknown Car';
                        String title = '';
                        String subtitle = '';

                        switch (data['paymentStatus']) {
                          case 'Diproses':
                            title = 'Pembayaran Anda Diterima';
                            subtitle =
                                'Ajuan sewa anda untuk merental mobil $carName telah diterima';
                            break;
                          case 'Ditolak':
                            title = 'Pembayaran Anda Ditolak';
                            subtitle =
                                'Pembayaran anda untuk merental mobil $carName ditolak';
                            break;
                          case 'Disiapkan':
                            title = 'Pembayaran Anda Sedang Disiapkan';
                            subtitle =
                                'Pembayaran anda untuk merental mobil $carName telah diterima';
                            break;
                          case 'Menuju Lokasi':
                            title = 'Pesanan Anda Sedang Diantarkan';
                            subtitle =
                                'Pesanan anda untuk merental mobil $carName akan tiba';
                            break;
                          case 'Selesai':
                            title = 'Pesanan Anda Telah Selesai';
                            subtitle =
                                'Sewa anda untuk merental mobil $carName telah selesai';
                            break;
                          default:
                            title = 'Status: ${data['paymentStatus']}';
                        }

                        return Card(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: ListTile(
                            title: Text(title,
                                style: const TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold)),
                            subtitle: Text(subtitle),
                            trailing: Icon(Icons.notifications,
                                color: Theme.of(context).primaryColor),
                          ),
                        );
                      }).toList(),
                    );
                  },
                );
              },
            ),
    );
  }
}
