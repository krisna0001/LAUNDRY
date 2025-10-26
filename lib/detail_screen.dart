// Salin dan GANTIKAN seluruh isi file lib/detail_screen.dart

import 'package:flutter/material.dart';
import 'catalog_screen.dart'; // Impor class LaundryService

class DetailScreen extends StatelessWidget {
  final LaundryService service;

  const DetailScreen({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(service.name),
        backgroundColor: const Color(0xFF005f9f), // Warna Biru Primer
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ===== PERUBAHAN DI SINI =====
            Hero(
              tag: 'service_icon_${service.name}',
              child: Material( // <--- TAMBAHKAN INI
                type: MaterialType.transparency, // <-- Agar transparan
                child: Icon(
                  service.icon,
                  size: 120, 
                  color: const Color(0xFF005f9f),
                ),
              ),
            ),
            // =============================
            const SizedBox(height: 24),
            Text(
              service.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 28,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              service.price,
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Ini adalah deskripsi layanan ${service.name}. Kami memastikan pakaian Anda bersih, wangi, dan rapi dengan penanganan profesional. Proses pengerjaan cepat dan terjamin kualitasnya.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}