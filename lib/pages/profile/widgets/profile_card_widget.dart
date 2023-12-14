import 'package:flutter/material.dart';

Widget buildProfileCard(String text, IconData iconData, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Row(
      children: <Widget>[
        const SizedBox(width: 20.0),
        Icon(
          iconData, // Menggunakan ikon yang diberikan sebagai parameter
          size: 30,
          color: Colors.black, // Ganti warna ikon sesuai kebutuhan
        ),
        const SizedBox(width: 20.0),
        Text(
          text,
          style: const TextStyle(
            fontSize: 18.0,
          ),
        ),
      ],
    ),
  );
}
