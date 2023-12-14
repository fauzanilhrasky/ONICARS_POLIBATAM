import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rent_car/model/payment_model.dart';

import '../../dashboard/dashboard_screen.dart'; // Adjust the path to your PaymentModel

class DetailProcessedScreen extends StatefulWidget {
  final PaymentModel dataPayment;

  const DetailProcessedScreen({Key? key, required this.dataPayment})
      : super(key: key);

  @override
  State<DetailProcessedScreen> createState() => _DetailProcessedScreenState();
}

class _DetailProcessedScreenState extends State<DetailProcessedScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const DashboardScreen(initialIndex: 2),
          ),
        );
        // Preventing popping using device's back button
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF29233B),
        appBar: AppBar(
          title: const Text('Rincian Pembayaran'),
          backgroundColor: const Color(0xFF110925),
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white), // Optional: Add border
              borderRadius:
                  BorderRadius.circular(10.0), // Optional: Add border radius
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Mohon menunggu konfirmasi admin",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(height: 10),
                Text(
                  'Metode Pembayaran: ${widget.dataPayment.trfMethod}',
                  style: const TextStyle(fontSize: 15, color: Colors.white60),
                ),
                const SizedBox(height: 20),
                if (widget.dataPayment.trfMethod == 'Transfer Bank')
                  FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('payments')
                        .doc(widget.dataPayment.id)
                        .get(),
                    builder: (BuildContext context,
                        AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasData && snapshot.data!.exists) {
                        var imageBuktiTrfUrl = snapshot.data!['imageBuktiTrf'];
                        return imageBuktiTrfUrl != null
                            ? Image.network(imageBuktiTrfUrl)
                            : const Text('No transfer proof available.');
                      } else {
                        return const Text('Payment details not found.');
                      }
                    },
                  )
                else if (widget.dataPayment.trfMethod == 'Bayar tunai')
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Jadwal Penjemputan: ${widget.dataPayment.datePickUp}',
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Mohon siapkan uang tunai saat bertemu",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.red),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
