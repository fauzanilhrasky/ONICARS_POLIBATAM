import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rent_car/model/car_model.dart';
import 'package:rent_car/utils/price_ext.dart';

import '../../model/payment_model.dart';
import '../payment/payment_data_screen.dart';

class CarDetailScreen extends StatelessWidget {
  final CarModel carData;

  const CarDetailScreen({super.key, required this.carData});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xFF29233B),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF110925),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Detail Mobil',
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: size.height,
          child: Stack(
            children: [
              Container(
                height: size.height * 0.35,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                    horizontal:
                        16.0), // Sesuaikan nilai padding sesuai kebutuhan
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                          10.0), // Atur border radius sesuai kebutuhan
                      image: DecorationImage(
                        image: NetworkImage(carData.imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: size.height * 0.75,
                  width: size.width,
                  margin: EdgeInsets.only(top: size.height * 0.3),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF110925),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 10,
                        blurRadius: 10,
                        offset: const Offset(0, 0),
                      ),
                    ],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              carData.name,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8.0),
                            Row(
                              children: [
                                const Icon(
                                  Icons.car_rental,
                                  color: Colors.red,
                                ),
                                const SizedBox(width: 5.0),
                                Text(
                                  carData.type,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white54,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16.0),
                            const Text(
                              'Harga Sewa per Hari:',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF9588F9)),
                            ),
                            const SizedBox(height: 8.0),
                            Row(
                              children: [
                                const Icon(
                                  Icons.attach_money,
                                  color: Colors.green,
                                ),
                                Text(
                                  carData.price.toString().formatPrice(),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Color.fromARGB(255, 83, 230, 88),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16.0),
                            const Text(
                              'Jumlah Penumpang:',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF9588F9),
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Row(
                              children: [
                                const Icon(
                                  Icons.people,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 5.0),
                                Text(
                                  carData.passengerCount,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16.0),
                            const Text(
                              'Keluaran Tahun:',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF9588F9),
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Row(
                              children: [
                                const Icon(
                                  Icons.calendar_month,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 5.0),
                                Text(
                                  carData.createdYear.toString(),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Color.fromARGB(255, 255, 255, 255),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16.0),
                            const Text(
                              'Maksimal Jumlah Koper:',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF9588F9),
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Row(
                              children: [
                                const Icon(
                                  Icons.luggage,
                                  color: Colors.blue,
                                ),
                                const SizedBox(width: 5.0),
                                Text(
                                  carData.maksTrunk.toString(),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16.0),
                            const Text(
                              'Detail Mobil:',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF9588F9),
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              carData.detail,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                User? user = FirebaseAuth.instance.currentUser;
                                final paymentData = PaymentModel(
                                  carId: carData.id,
                                  userId: user!.uid,
                                  dateRent: '',
                                  durationRent: 1,
                                  locationPickUp: '',
                                  datePickUp: '',
                                  id: '',
                                  userName: '',
                                  userContact: '',
                                  isWithDriver: true,
                                  trfMethod: 'Transfer Bank',
                                  priceRent: 0,
                                  paymentStatus: 'Belum Bayar',
                                );
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => PaymentDataScreen(
                                      dataPayment: paymentData,
                                      carData: carData,
                                    ),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF9588F9),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                minimumSize: const Size(350, 50),
                              ),
                              child: const Text(
                                'Sewa Mobil',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
