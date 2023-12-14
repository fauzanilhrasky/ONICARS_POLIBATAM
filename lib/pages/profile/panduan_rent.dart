import 'dart:ffi';

import 'package:flutter/material.dart';

class PanduanScreen extends StatefulWidget {
  const PanduanScreen({Key? key}) : super(key: key);

  @override
  State<PanduanScreen> createState() => _PanduanScreenState();
}

class _PanduanScreenState extends State<PanduanScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF29233B),
      appBar: AppBar(
        backgroundColor: const Color(0xFF110925),
        title: const Text('Panduan Rental'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: const Text(
                'Selamat datang\ndi Panduan Rental ONICARS!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white), // Optional: Add border
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Di sini, Anda akan menemukan informasi lengkap tentang cara menyewa mobil melalui aplikasi kami!!.\n\nAyoo Ikuti langkah-langkah berikut untuk memulai perjalanan Anda:',
                    style: TextStyle(
                        fontSize: 17,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '1. Masuk atau buat akun Anda\n2. Pilih lokasi, tanggal, dan waktu sewa.\n3. Pilih mobil yang Anda inginkan.\n4. Konfirmasi pemesanan & metode pembayaran.\n5. Selesai! Mobil Anda siap untuk diambil.',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Jangan ragu untuk menghubungi tim dukungan kami jika Anda mengalami masalah atau memerlukan bantuan selama proses penyewaan.\n\nKami siap membantu Anda.',
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
