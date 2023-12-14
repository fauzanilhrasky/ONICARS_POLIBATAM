import 'package:flutter/material.dart';
import 'package:rent_car/pages/home/home_screen.dart';
import 'package:rent_car/pages/notification/notification_screen.dart';
import 'package:rent_car/pages/profile/profile_screen.dart'; // Gantilah dengan impor yang sesuai

class DashboardScreen extends StatefulWidget {
  final int initialIndex;
  const DashboardScreen({Key? key, required this.initialIndex})
      : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex =
        widget.initialIndex; // Use initialIndex for the initial state
  }

  final List<Widget> _pages = [
    const HomeScreen(),
    const NotificationScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF9588F9),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.white, // Warna ikon ketika aktif
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Colors.white,
            ),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.notifications,
              color: Colors.white,
            ),
            label: 'Notifikasi',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: Colors.white,
            ),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
