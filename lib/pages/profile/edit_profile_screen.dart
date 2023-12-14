import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _simController = TextEditingController();
  TextEditingController _noTelpController = TextEditingController();
  TextEditingController _alamatController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  User? _user;
  String? _uid;
  String? _oldEmail;
  String? _oldImage;
  bool _obscurePassword = true;
  XFile? _image;

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;
    _uid = _user!.uid;

    _firestore.collection('users').doc(_uid).get().then((doc) {
      if (doc.exists) {
        setState(() {
          _nameController.text = doc['name'];
          _simController.text = doc['sim'];
          _noTelpController.text = doc['noTelp'];
          _alamatController.text = doc['alamat'];
          _emailController.text = _user!.email!;
          _oldEmail = _user?.email;
          _oldImage = doc['imageURL'] ?? '';
        });
      }
    });
  }

  void _updateProfile() async {
    if (_image != null) {
      String imageUrl = await uploadImage();
      // Menyimpan URL gambar ke Firestore
      await _firestore.collection('users').doc(_uid).update({
        'imageURL': imageUrl,
      });
    }

    await _firestore.collection('users').doc(_uid).update({
      'name': _nameController.text,
      'sim': _simController.text,
      'noTelp': _noTelpController.text,
      'alamat': _alamatController.text,
    });

    if (_emailController.text != _oldEmail) {
      try {
        await _user?.updateEmail(_emailController.text);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Email berhasil diperbarui!'),
          ),
        );
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Terjadi kesalahan saat memperbarui email: $error'),
          ),
        );
      }
    }

    if (_passwordController.text.isNotEmpty) {
      try {
        // Hanya update password jika password diisi
        await _user?.updatePassword(_passwordController.text);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password berhasil diperbarui!'),
          ),
        );
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Terjadi kesalahan saat memperbarui password: $error'),
          ),
        );
      }
    }

    Navigator.pop(context, true);
  }

  Future<void> selectImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = image;
      });
    }
  }

  Future<String> uploadImage() async {
    Reference storageReference =
        FirebaseStorage.instance.ref().child('profile_images').child(_uid!);
    UploadTask uploadTask = storageReference.putFile(File(_image!.path));
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
    String imageUrl = await storageReference.getDownloadURL();
    return imageUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF110925),
        title: const Text("Pengaturan Akun"),
        actions: [
          TextButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _updateProfile();
              }
            },
            child: const Text(
              "Simpan",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: _image != null
                          ? FileImage(File(_image!.path))
                          : (_oldImage != null && _oldImage!.isNotEmpty)
                              ? NetworkImage(_oldImage!)
                              : AssetImage('assets/images/default_avatar.jpg')
                                  as ImageProvider<Object>,
                    ),
                    Positioned(
                      child: IconButton(
                        onPressed: selectImage,
                        icon: Icon(Icons.add_a_photo,
                            size: 30, color: Colors.redAccent),
                      ),
                      bottom: -10,
                      left: 60,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: "Nama Lengkap"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your name";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _simController,
                  decoration: const InputDecoration(labelText: "Nomor SIM"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your SIM";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _noTelpController,
                  decoration:
                      const InputDecoration(labelText: "Nomor HP/ WhatsApp"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your phone number";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _alamatController,
                  decoration:
                      const InputDecoration(labelText: "ALamat Lengkap"),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: "Email"),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your email";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _passwordController,
                        decoration:
                            const InputDecoration(labelText: "Password"),
                        obscureText: _obscurePassword,
                        validator: (value) {
                          if (value != null && value.isNotEmpty) {
                            // Validasi hanya jika password diisi
                            if (value.length < 6) {
                              return "Password must be at least 6 characters";
                            }
                          }
                          return null;
                        },
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
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
