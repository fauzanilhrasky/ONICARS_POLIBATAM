import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rent_car/utils/price_ext.dart';

import '../../model/driver_model.dart';
import '../../model/payment_model.dart';

class DetailHistoryScreen extends StatefulWidget {
  final PaymentModel dataPayment;

  const DetailHistoryScreen({Key? key, required this.dataPayment})
      : super(key: key);

  @override
  State<DetailHistoryScreen> createState() => _DetailHistoryScreenState();
}

class _DetailHistoryScreenState extends State<DetailHistoryScreen> {
  String? selectedDriverName;
  String? selectedDriverId;

  Map<String, String> carNames = {};
  Map<String, String> carImages = {};
  Map<String, String> carTypes = {};
  Map<String, String> carDetails = {};

  @override
  void initState() {
    super.initState();
    _fetchCarNames([widget.dataPayment.carId]);
  }

  Future<void> _fetchCarNames(List<String> carIds) async {
    for (var carId in carIds) {
      var carSnapshot =
          await FirebaseFirestore.instance.collection('cars').doc(carId).get();
      setState(() {
        carNames[carId] = carSnapshot.data()?['name'] ?? 'Unknown Car';
        carImages[carId] = carSnapshot.data()?['imageUrl'] ?? 'Unknown Car';
        carTypes[carId] = carSnapshot.data()?['type'] ?? 'Unknown Car';
        carDetails[carId] = carSnapshot.data()?['detail'] ?? 'Unknown Car';
      });
    }
  }

  void _showFullscreenImage(String imageUrl) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: Image.network(imageUrl, fit: BoxFit.contain),
        ),
      ),
    );
  }

  Future<void> _updatePaymentStatus(String newStatus) async {
    await FirebaseFirestore.instance
        .collection('payments')
        .doc(widget.dataPayment.id)
        .update({'paymentStatus': newStatus});

    setState(() {
      widget.dataPayment.paymentStatus = newStatus;
    });
  }

  Future<void> _deletePayment() async {
    await FirebaseFirestore.instance
        .collection('payments')
        .doc(widget.dataPayment.id)
        .delete();

    Navigator.pop(context);
  }

  Future<List<DriverModel>> _fetchDrivers() async {
    var driversSnapshot =
        await FirebaseFirestore.instance.collection('drivers').get();
    return driversSnapshot.docs
        .map((doc) => DriverModel.fromSnapshot(doc))
        .toList();
  }

  Future<void> _assignDriver(String driverId, String driverName) async {
    if (widget.dataPayment.isWithDriver &&
        widget.dataPayment.paymentStatus == 'Diproses') {
      await FirebaseFirestore.instance
          .collection('payments')
          .doc(widget.dataPayment.id)
          .update({
        'driverId': driverId,
        'driverName': driverName,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xFF29233B),
      appBar: AppBar(
        title: const Text('Detail Riwayat Pesanan'),
        backgroundColor: const Color(0xFF110925),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Card(
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Container(
                          height: size.height * 0.15,
                          width: size.width * 0.35,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                  carImages[widget.dataPayment.carId] ??
                                      'Unknown Car'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10.0),
                            Text(
                              carNames[widget.dataPayment.carId] ??
                                  'Unknown Car',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5.0),
                            Text(
                              carTypes[widget.dataPayment.carId] ??
                                  'Unknown Type',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 10.0),
                            Text(
                              carDetails[widget.dataPayment.carId] ??
                                  'Unknown Detail',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Card(
                    elevation: 2.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    color: Colors.white,
                    child: Container(
                      width: size.width * 35,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              widget.dataPayment.isWithDriver == true
                                  ? 'Dengan Supir'
                                  : 'Tanpa Supir',
                              style: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Kontak",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text('Nama: ${widget.dataPayment.userName}'),
                        Text('No Telp/WA: ${widget.dataPayment.userContact}'),
                        const SizedBox(height: 16.0),
                        const Text(
                          "Jadwal Penyewaan",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                            'Tanggal Sewa: ${DateFormat('dd MMMM yyyy').format(DateTime.parse(widget.dataPayment.dateRent))}'),
                        Text(
                            'Durasi Sewa: ${widget.dataPayment.durationRent} Hari'),
                        const SizedBox(height: 16.0),
                        const Text(
                          "Alamat",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                            'Lokasi Penjemputan: ${widget.dataPayment.locationPickUp}'),
                        Text(
                            'Waktu Penjemputan: ${widget.dataPayment.datePickUp}'),
                        Text(
                            'Lokasi Dituju: ${widget.dataPayment.locationDestination!.isNotEmpty ? widget.dataPayment.locationDestination : '-'}'),
                        const SizedBox(height: 16.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.dataPayment.trfMethod,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.pinkAccent,
                              ),
                            ),
                            Text(
                              '${widget.dataPayment.priceRent}'.formatPrice(),
                              style: const TextStyle(
                                color: Colors.green,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            if (widget.dataPayment.imageKtp != null)
                              GestureDetector(
                                onTap: () {
                                  _showFullscreenImage(
                                      widget.dataPayment.imageKtp!);
                                },
                                child: Column(
                                  children: [
                                    const Text("Scan KTP"),
                                    const SizedBox(
                                      height: 6,
                                    ),
                                    Card(
                                      child: Container(
                                        width: 100,
                                        height: 100,
                                        child: Image.network(
                                          widget.dataPayment.imageKtp!,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            if (widget.dataPayment.imageSim != null)
                              GestureDetector(
                                onTap: () {
                                  _showFullscreenImage(
                                      widget.dataPayment.imageSim!);
                                },
                                child: Column(
                                  children: [
                                    const Text("Scan SIM"),
                                    const SizedBox(
                                      height: 6,
                                    ),
                                    Card(
                                      child: Container(
                                        width: 100,
                                        height: 100,
                                        child: Image.network(
                                          widget.dataPayment.imageSim!,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            if (widget.dataPayment.trfMethod == 'Transfer Bank')
                              FutureBuilder<DocumentSnapshot>(
                                future: FirebaseFirestore.instance
                                    .collection('payments')
                                    .doc(widget.dataPayment.id)
                                    .get(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  }

                                  if (snapshot.hasData &&
                                      snapshot.data!.exists) {
                                    var imageBuktiTrfUrl =
                                        snapshot.data!['imageBuktiTrf'];
                                    return imageBuktiTrfUrl != null
                                        ? GestureDetector(
                                            onTap: () {
                                              _showFullscreenImage(
                                                  imageBuktiTrfUrl);
                                            },
                                            child: Column(
                                              children: [
                                                const Text("Bukti Transfer"),
                                                const SizedBox(
                                                  height: 6,
                                                ),
                                                Card(
                                                  child: Container(
                                                    width: 100,
                                                    height: 100,
                                                    child: Image.network(
                                                      imageBuktiTrfUrl,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ))
                                        : const Text(
                                            'No transfer proof available.');
                                  } else {
                                    return const Text(
                                        'Payment details not found.');
                                  }
                                },
                              ),
                            if (widget.dataPayment.trfMethod == 'Bayar Tunai')
                              Text(
                                'Jadwal Penjemputan: ${widget.dataPayment.datePickUp}',
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
