import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rent_car/pages/auth/login_screen.dart';

import '../dashboard/dashboard_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _simController = TextEditingController();
  TextEditingController _noTelpController = TextEditingController();
  TextEditingController _alamatController =
      TextEditingController(); // Controller untuk alamat

  String _email = "";
  String _password = "";
  String _name = "";
  String _gender = "Laki-Laki"; // Default gender: Laki-Laki
  String _sim = "";
  String _noTelp = "";
  String _alamat = ""; // Alamat domisili
  bool _isPasswordVisible = false; // Untuk mengontrol tampilan kata sandi

  void _handleSignUp() async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _email,
        password: _password,
      );

      // Simpan data pengguna ke Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'uid': userCredential.user!.uid,
        'name': _name,
        'email': _email,
        'gender': _gender,
        'isAdmin': false, // Ubah sesuai kebutuhan
        'sim': _sim,
        'noTelp': _noTelp,
        'alamat': _alamat, // Simpan alamat
      });

      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) {
        return const DashboardScreen(
          initialIndex: 0,
        );
      }), (route) => false);
      print("User Registered: ${userCredential.user!.email}");
    } catch (e) {
      print("Error During Registration: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF110925),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                const Text(
                  "ONICARS", // Tambahkan teks ONICARS di sini
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF9588F9),
                  ),
                ),
                const SizedBox(height: 40),
                TextFormField(
                  controller: _nameController, // Controller untuk nama
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Nama Lengkap", // Field Nama
                    filled:
                        true, // Mengatur background menjadi filled (dengan warna putih)
                    fillColor: Colors.white,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Masukkan Nama Lengkap Anda";
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _name = value;
                    });
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Alamat Email",
                    filled:
                        true, // Mengatur background menjadi filled (dengan warna putih)
                    fillColor: Colors.white,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Masukkan Alamat Email Anda";
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _email = value;
                    });
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                DropdownButtonFormField<String>(
                  value: _gender, // Nilai yang dipilih
                  items: ["Laki-Laki", "Perempuan"].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _gender = value!;
                    });
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Jenis Kelamin", // Field Jenis Kelamin
                    filled:
                        true, // Mengatur background menjadi filled (dengan warna putih)
                    fillColor: Colors
                        .white, // Mengatur warna latar belakang menjadi putih
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _simController, // Controller untuk SIM
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Nomor SIM", // Field SIM
                    filled:
                        true, // Mengatur background menjadi filled (dengan warna putih)
                    fillColor: Colors
                        .white, // Mengatur warna latar belakang menjadi putih
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Masukkan Nomor SIM Anda";
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _sim = value;
                    });
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller:
                      _noTelpController, // Controller untuk nomor telepon
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Nomor Telepon", // Field Nomor Telepon
                    filled:
                        true, // Mengatur background menjadi filled (dengan warna putih)
                    fillColor: Colors
                        .white, // Mengatur warna latar belakang menjadi putih
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Masukkan Nomor Telepon Anda";
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _noTelp = value;
                    });
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _alamatController, // Controller untuk alamat
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Alamat Domisili", // Field Alamat
                    filled:
                        true, // Mengatur background menjadi filled (dengan warna putih)
                    fillColor: Colors
                        .white, // Mengatur warna latar belakang menjadi putih
                  ),
                  onChanged: (value) {
                    setState(() {
                      _alamat = value;
                    });
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _passController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: "Kata Sandi",
                    filled:
                        true, // Mengatur background menjadi filled (dengan warna putih)
                    fillColor: Colors
                        .white, // Mengatur warna latar belakang menjadi putih
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Masukkan Kata sandi Anda";
                    } else if (value.length < 8) {
                      return "Kata sandi harus terdiri dari minimal 8 karakter";
                    } else if (!RegExp(
                            r'^(?=.*[0-9])(?=.*[a-zA-Z])([a-zA-Z0-9]+)$')
                        .hasMatch(value)) {
                      return "Kata sandi harus mengandung angka dan huruf";
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _password = value;
                    });
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  // Wrapper untuk tombol dengan lebar sesuai dengan ukuran layar
                  width: 260,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _handleSignUp();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary:
                          Color(0xFF9588F9), // Ubah warna latar belakang tombol
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: const Text("Buat Akun"),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Sudah punya akun? ',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontFamily: 'Inter',
                        ),
                      ),
                      TextSpan(
                        text: 'Masuk',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.green,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.bold,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushAndRemoveUntil(context,
                                MaterialPageRoute(builder: (context) {
                              return const LoginScreen();
                            }), (route) => false);
                          },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
