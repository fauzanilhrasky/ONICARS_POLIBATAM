import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:rent_car/model/payment_model.dart';
import 'package:rent_car/model/car_model.dart';
import 'package:rent_car/pages/payment/payment_screen.dart';
import 'package:rent_car/pages/status/processed/detail_processed_screen.dart';
import 'package:rent_car/utils/price_ext.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';

class PaymentDataScreen extends StatefulWidget {
  final PaymentModel dataPayment;
  final CarModel carData;

  const PaymentDataScreen(
      {Key? key, required this.dataPayment, required this.carData})
      : super(key: key);

  @override
  State<PaymentDataScreen> createState() => _PaymentDataScreenState();
}

class _PaymentDataScreenState extends State<PaymentDataScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController durationController = TextEditingController();
  TextEditingController locationDestinationController = TextEditingController();
  TextEditingController locationPickUpController = TextEditingController();
  TextEditingController timeController = TextEditingController();

  User? _user;
  String? _uid;
  DateTime _selectedDate = DateTime.now();
  int _duration = 1;
  bool _isWithDriver = true;
  String? _selectedPaymentMethod;
  String? imageUrlSim;
  String? imageUrlKtp;
  String? driverId;
  String? driverName;
  String paymentStatus = 'Belum Bayar';

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;
    _uid = _user!.uid;

    _firestore.collection('users').doc(_uid).get().then((doc) {
      if (doc.exists) {
        setState(() {
          nameController.text = doc['name'];
          contactController.text = doc['noTelp'];
        });
      }
    });

    _selectedPaymentMethod = 'Transfer Bank';
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
        dateController.text = DateFormat('yyyy-MM-dd').format(_selectedDate);
      });
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      final formattedTime =
          "${pickedTime.hour}:${pickedTime.minute.toString().padLeft(2, '0')}";
      setState(() {
        timeController.text = formattedTime;
      });
    }
  }

  Future<String> uploadImageSimToFirestore(
      String imagePath, String folderName) async {
    try {
      Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('$folderName/$_uid/${DateTime.now().millisecondsSinceEpoch}');

      UploadTask uploadTask = storageReference.putFile(File(imagePath));

      await uploadTask.whenComplete(() => null);

      String downloadURL = await storageReference.getDownloadURL();

      return downloadURL;
    } catch (e) {
      print('Terjadi kesalahan saat mengunggah foto: $e');
      return '';
    }
  }

  Future<String> uploadImageKtpToFirestore(
      String imagePath, String folderName) async {
    try {
      Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('$folderName/$_uid/${DateTime.now().millisecondsSinceEpoch}');

      UploadTask uploadTask = storageReference.putFile(File(imagePath));

      await uploadTask.whenComplete(() => null);

      String downloadURL = await storageReference.getDownloadURL();

      return downloadURL;
    } catch (e) {
      print('Terjadi kesalahan saat mengunggah foto: $e');
      return '';
    }
  }

  Future<void> _getImageSim() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      String simImageURL =
          await uploadImageSimToFirestore(pickedFile.path, 'sim_images');
      setState(() {
        imageUrlSim =
            simImageURL; // Memastikan ini adalah URL dari Firebase Storage
      });
    }
  }

  Future<void> _getImageKtp() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      String ktpImageURL =
          await uploadImageSimToFirestore(pickedFile.path, 'ktp_images');
      setState(() {
        imageUrlKtp =
            ktpImageURL; // Memastikan ini adalah URL dari Firebase Storage
      });
    }
  }

  Future<void> savePaymentData() async {
    try {
      int basePrice = widget.carData.price * _duration;
      int totalPrice = _isWithDriver
          ? basePrice + (200000 * _duration) // Harga dengan supir
          : basePrice; // Harga tanpa supir

      DocumentReference paymentRef =
          await _firestore.collection('payments').add({
        'carId': widget.carData.id,
        'userId': _uid,
        'imageSim': imageUrlSim,
        'imageKtp': imageUrlKtp,
        'dateRent': dateController.text,
        'durationRent': int.parse(durationController.text),
        'locationDestination': locationDestinationController.text,
        'locationPickUp': locationPickUpController.text,
        'datePickUp': timeController.text,
        'userName': nameController.text,
        'userContact': contactController.text,
        'isWithDriver': _isWithDriver,
        'trfMethod': _selectedPaymentMethod,
        'priceRent': totalPrice,
        'paymentStatus': paymentStatus,
        'driverId': '',
        'driverName': '',
      });
      print('Data pembayaran berhasil disimpan.');

      final PaymentModel dataPayment = PaymentModel(
        id: paymentRef.id,
        carId: widget.carData.id,
        userId: _uid!,
        imageSim: imageUrlSim,
        imageKtp: imageUrlKtp,
        dateRent: dateController.text,
        durationRent: _duration,
        locationDestination: locationDestinationController.text,
        locationPickUp: locationPickUpController.text,
        datePickUp: timeController.text,
        userName: nameController.text,
        userContact: contactController.text,
        isWithDriver: _isWithDriver,
        trfMethod: _selectedPaymentMethod!,
        priceRent: totalPrice,
        paymentStatus: paymentStatus,
        driverId: '',
        driverName: '',
      );

      if (_selectedPaymentMethod == 'Transfer Bank') {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => PaymentScreen(dataPayment: dataPayment),
          ),
        );
      } else {
        await paymentRef.update({
          'paymentStatus': 'Diproses',
        });

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) =>
                DetailProcessedScreen(dataPayment: dataPayment),
          ),
        );
      }
    } catch (e) {
      print('Terjadi kesalahan saat menyimpan data pembayaran: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final carData = widget.carData;
    Size size = MediaQuery.of(context).size;

    int totalPrice = carData.price * _duration;
    int totalPriceWithDriver = carData.price * _duration + 200000 * _duration;

    return Scaffold(
      backgroundColor: const Color(0xFF29233B),
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text("Kembali"),
        backgroundColor: const Color(0xFF110925),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
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
                          width: size.height * 0.20,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(carData.imageUrl),
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
                              carData.name,
                              style: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 5.0),
                            Text(
                              carData.type,
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 10.0),
                            Text(
                              carData.detail,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  ToggleSwitch(
                    minWidth: 150.0,
                    initialLabelIndex: _isWithDriver
                        ? 0
                        : 1, // Atur sesuai dengan nilai _isWithDriver
                    cornerRadius: 10.0,
                    activeBgColor: const [Color(0xFF9588F9)],
                    activeFgColor: Colors.white,
                    inactiveBgColor: Colors.grey,
                    inactiveFgColor: Colors.white,
                    totalSwitches: 2,
                    labels: const ['Dengan Supir', 'Tanpa Supir'],
                    onToggle: (index) {
                      setState(() {
                        _isWithDriver = index == 0;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Kontak",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      TextField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: 'Nama Lengkap',
                        ),
                      ),
                      TextField(
                        controller: contactController,
                        decoration: const InputDecoration(
                          labelText: 'No Telpon / Whatsapp',
                        ),
                      ),
                      const SizedBox(height: 24.0),
                      const Text(
                        "Jadwal Penyewaan",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _selectDate(context);
                        },
                        child: AbsorbPointer(
                          child: TextFormField(
                            controller: dateController,
                            decoration: const InputDecoration(
                              labelText: 'Tanggal Penyewaan',
                              suffixIcon: Icon(Icons.calendar_month,
                                  color: Color(0xFF9588F9)),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 25, 144, 241),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                            ),
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  if (_duration > 1) {
                                    _duration--;
                                  }
                                  durationController.text =
                                      _duration.toString();
                                });
                              },
                              icon: const Icon(
                                Icons.remove,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 20.0),
                          Expanded(
                            child: TextFormField(
                              controller: durationController,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              onChanged: (value) {
                                setState(() {
                                  if (value.isNotEmpty) {
                                    _duration = int.parse(value);
                                  }
                                });
                              },
                              decoration: const InputDecoration(
                                  labelText: 'Durasi Penyewaan',
                                  suffixText: "Hari"),
                            ),
                          ),
                          const SizedBox(width: 20.0),
                          Container(
                            decoration: const BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                            ),
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  _duration++;
                                  durationController.text =
                                      _duration.toString();
                                });
                              },
                              icon: const Icon(Icons.add, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24.0),
                      const Text(
                        "Alamat",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Visibility(
                        visible: _isWithDriver,
                        child: TextField(
                          controller: locationDestinationController,
                          decoration: const InputDecoration(
                            labelText: 'Lokasi Dituju',
                          ),
                        ),
                      ),
                      TextField(
                        controller: locationPickUpController,
                        decoration: const InputDecoration(
                          labelText: 'Lokasi Penjemputan',
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _selectTime(context);
                        },
                        child: AbsorbPointer(
                          child: TextFormField(
                            controller: timeController,
                            decoration: const InputDecoration(
                              labelText: 'Waktu Penjemputan',
                              suffixIcon: Icon(
                                Icons.timer_sharp,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Visibility(
                        visible: !_isWithDriver,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Foto SIM",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                await _getImageSim();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(imageUrlSim != null
                                        ? 'Foto SIM berhasil diunggah.'
                                        : 'Gagal mengunggah foto SIM.'),
                                  ),
                                );
                              },
                              child: Text(
                                imageUrlSim != null
                                    ? 'Sudah diupload'
                                    : 'Upload SIM',
                                style: const TextStyle(color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: imageUrlSim != null
                                    ? Colors.green
                                    : const Color(0xFF9588F9),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "Foto KTP",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          await _getImageKtp();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(imageUrlKtp != null
                                  ? 'Foto KTP berhasil diunggah.'
                                  : 'Gagal mengunggah foto KTP.'),
                            ),
                          );
                        },
                        child: Text(
                          imageUrlKtp != null ? 'Sudah diupload' : 'Upload KTP',
                          style: const TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: imageUrlKtp != null
                              ? Colors.green
                              : const Color(0xFF9588F9),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "Pilih Metode Pembayaran",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      DropdownButton<String>(
                        value: _selectedPaymentMethod,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedPaymentMethod = newValue;
                          });
                        },
                        items: <String>['Bayar tunai', 'Transfer Bank']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Visibility(
                            visible: _isWithDriver,
                            child: Text(
                              totalPriceWithDriver
                                  .toStringAsFixed(2)
                                  .formatPrice(),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ),
                          Visibility(
                            visible: !_isWithDriver,
                            child: Text(
                              totalPrice.toStringAsFixed(2).formatPrice(),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              savePaymentData();
                            },
                            child: const Text("Rental Sekarang"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF9588F9),
                            ),
                          ),
                        ],
                      )
                    ],
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
