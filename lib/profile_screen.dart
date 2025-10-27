import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Saya'),
        backgroundColor: const Color(0xFF005f9f),
      ),
      body: const Center(
        child: Text('Halaman Akun Pengguna', style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
