import 'package:flutter/material.dart';
import 'package:rent_car/model/payment_model.dart';

import '../../dashboard/dashboard_screen.dart'; // Adjust the path to your PaymentModel

class DetailDeliveredScreen extends StatefulWidget {
  final PaymentModel dataPayment;

  const DetailDeliveredScreen({Key? key, required this.dataPayment})
      : super(key: key);

  @override
  State<DetailDeliveredScreen> createState() => _DetailDeliveredScreenState();
}

class _DetailDeliveredScreenState extends State<DetailDeliveredScreen> {
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
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF29233B),
        appBar: AppBar(
          title: const Text('Menuju Lokasi'),
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
                  "Mobil akan diantarkan",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(height: 10),
                Text(
                  'Metode Pembayaran: ${widget.dataPayment.trfMethod}',
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 10),
                Text(
                  "Silahkan menunggu penjemputan mobil pada lokasi ${widget.dataPayment.locationPickUp}",
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
