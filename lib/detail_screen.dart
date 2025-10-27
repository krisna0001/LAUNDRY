import 'package:flutter/material.dart';
import 'catalog_screen.dart';

class DetailScreen extends StatelessWidget {
  final LaundryService service;

  const DetailScreen({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Data Layanan: ${service.name}'),
        backgroundColor: const Color(0xFF005f9f),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Hero(
              tag: 'service_icon_${service.name}',
              child: Material(
                type: MaterialType.transparency,
                child: Icon(
                  service.icon,
                  size: 120,
                  color: const Color(0xFF005f9f),
                ),
              ),
            ),
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
                color: Colors.red[700],
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 32),

            const Text(
              'Ringkasan SOP (Standard Operating Procedure):',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _getSop(service.name),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                height: 1.5,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getSop(String serviceName) {
    if (serviceName.contains('Sepatu')) {
      return '1. Cek bahan sepatu (Canvas/Kulit). \n2. Gunakan sikat & sabun khusus. \n3. Keringkan di ruang angin, JANGAN dijemur matahari langsung.';
    }
    if (serviceName.contains('Dry Cleaning')) {
      return '1. Cek label garmen. \n2. Gunakan solvent (Perchloroethylene) di mesin Dry Clean. \n3. Proses finishing menggunakan setrika uap khusus.';
    }
    if (serviceName.contains('Bed Cover')) {
      return '1. Gunakan mesin kapasitas besar (min. 15kg). \n2. Pastikan bed cover terendam sempurna. \n3. Proses pengeringan 100% di mesin pengering agar tidak apek.';
    }
    return '1. Pisahkan pakaian putih & berwarna. \n2. Timbang berat kering. \n3. Masukkan ke mesin cuci, set deterjen & pelembut. \n4. Keringkan 100% di mesin pengering.';
  }
}
