import 'package:flutter/material.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pesanan Saya'),
        backgroundColor: const Color(0xFF005f9f),
      ),
      body: const Center(
        child: Text(
          'Halaman Daftar Pesanan (Aktif & Riwayat)',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
