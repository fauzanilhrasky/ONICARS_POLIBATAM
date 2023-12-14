import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rent_car/pages/dashboard/dashboard_screen.dart';
import 'package:rent_car/utils/price_ext.dart';
import 'package:rent_car/pages/status/not-yet-paid/not_yet_paid_screen.dart';
import '../../model/payment_model.dart';

class PaymentScreen extends StatefulWidget {
  final PaymentModel dataPayment;

  const PaymentScreen({Key? key, required this.dataPayment}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String? imageUrlBuktiTrf;
  String? _uid;

  @override
  void initState() {
    super.initState();
    // Dapatkan UID pengguna saat inisialisasi
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _uid = user.uid;
    }
  }

  Future<void> _updateBuktitrf() async {
    if (imageUrlBuktiTrf != null) {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('bukti_trf_images/$_uid/$timestamp.jpg');
      final UploadTask uploadTask =
          storageReference.putFile(File(imageUrlBuktiTrf!));
      final TaskSnapshot taskSnapshot = await uploadTask;

      if (taskSnapshot.state == TaskState.success) {
        final String downloadURL = await storageReference.getDownloadURL();

        // Simpan URL gambar bukti transfer ke Firestore
        final CollectionReference paymentRef =
            FirebaseFirestore.instance.collection('payments');
        final QuerySnapshot querySnapshot = await paymentRef
            .where('carId', isEqualTo: widget.dataPayment.carId)
            .orderBy('dateRent', descending: true)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          final DocumentSnapshot docSnapshot = querySnapshot.docs.first;
          final String paymentId = docSnapshot.id;

          await docSnapshot.reference.update(
              {'imageBuktiTrf': downloadURL, 'paymentStatus': 'Diproses'});

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Bukti Transfer telah diupload!'),
            ),
          );
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext dialogContext) {
              return AlertDialog(
                title: const Text('Konfirmasi Pembayaran'),
                content: const Text('Pembayaran berhasil Konfirmasi.'),
                actions: <Widget>[
                  TextButton(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) =>
                              const DashboardScreen(initialIndex: 2),
                        ),
                        ModalRoute.withName('/'),
                      );
                    },
                  ),
                ],
              );
            },
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Data pembayaran tidak ditemukan.'),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal mengunggah gambar. Silakan coba lagi.'),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Harap isi semua field dan pilih gambar terlebih dahulu'),
        ),
      );
    }
  }

  Future<void> _getImage(bool isFromGallery) async {
    final source = isFromGallery ? ImageSource.gallery : ImageSource.camera;
    final pickedFile = await ImagePicker().getImage(source: source);

    if (pickedFile != null) {
      setState(() {
        imageUrlBuktiTrf = pickedFile.path;
      });
    }
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Pilih Sumber Gambar"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.photo),
                  title: const Text("Pilih dari Galeri"),
                  onTap: () {
                    Navigator.of(context).pop();
                    _getImage(true); // Pilih gambar dari galeri
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.camera),
                  title: const Text("Ambil Foto dari Kamera"),
                  onTap: () {
                    Navigator.of(context).pop();
                    _getImage(false); // Ambil foto dari kamera
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

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
          title: const Text("Pembayaran"),
          backgroundColor: const Color(0xFF110925),
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text(
                    "Total Pembayaran",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    widget.dataPayment.priceRent
                        .toStringAsFixed(2)
                        .formatPrice(),
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.green),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Image.asset(
                    'assets/images/Qris OniCars.png',
                    height: 400,
                    width: 340,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: Text(
                            "Upload Bukti Transfer",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        if (imageUrlBuktiTrf != null)
                          GestureDetector(
                            onTap: _showImageSourceDialog,
                            child: Image.file(
                              File(imageUrlBuktiTrf!),
                              height: 150,
                              width: MediaQuery.of(context).size.width,
                              fit: BoxFit.cover,
                            ),
                          )
                        else
                          GestureDetector(
                            onTap: _showImageSourceDialog,
                            child: Card(
                              margin: const EdgeInsets.all(8.0),
                              child: Container(
                                height: 150,
                                width: MediaQuery.of(context)
                                    .size
                                    .width, // Use the full width of the screen
                                color: Colors.grey,
                                child: const Icon(Icons.image,
                                    size: 60,
                                    color: Color.fromARGB(125, 0, 0, 0)),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  ElevatedButton(
                    onPressed: _updateBuktitrf,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF9588F9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      minimumSize: const Size(330, 45),
                    ),
                    child: const Text(
                      'Konfirmasi  Pembayaran',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NotYetPaidScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[400],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      minimumSize: const Size(330, 45),
                    ),
                    child: const Text(
                      'Bayar Nanti',
                      style: TextStyle(fontSize: 18, color: Colors.black),
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
