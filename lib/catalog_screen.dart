// lib/catalog_screen.dart

import 'package:flutter/material.dart';
import 'detail_screen.dart'; // Pastikan import ini benar

// Model data untuk layanan, sudah bagus, tidak perlu diubah.
class LaundryService {
  final String name;
  final String price;
  final IconData icon;

  LaundryService({required this.name, required this.price, required this.icon});
}

// Halaman utama untuk menampilkan katalog layanan.
class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key});

  // Memindahkan daftar layanan ke sini agar tidak dibuat ulang setiap kali build.
  static final List<LaundryService> services = [
    LaundryService(
      name: 'Cuci Kering Lipat',
      price: 'Rp 7.000/kg',
      icon: Icons.local_laundry_service,
    ),
    LaundryService(
      name: 'Setrika Kiloan',
      price: 'Rp 5.000/kg',
      icon: Icons.iron,
    ),
    LaundryService(
      name: 'Cuci Satuan Kemeja',
      price: 'Rp 15.000/pcs',
      icon: Icons.checkroom,
    ),
    LaundryService(
      name: 'Cuci Bed Cover',
      price: 'Rp 25.000/pcs',
      icon: Icons.king_bed,
    ),
    LaundryService(
      name: 'Cuci Sepatu',
      price: 'Rp 30.000/psg',
      icon: Icons.ice_skating,
    ),
    LaundryService(
      name: 'Dry Cleaning Jas',
      price: 'Rp 50.000/pcs',
      icon: Icons.dry_cleaning,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // --- MediaQuery untuk responsivitas ---
    final screenWidth = MediaQuery.of(context).size.width;
    final int crossAxisCount = screenWidth > 600 ? 3 : 2;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Katalog Layanan'),
        backgroundColor: const Color(0xFF005f9f),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(12.0), // Padding untuk seluruh grid
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.9,
        ),
        itemCount: services.length,
        itemBuilder: (context, index) {
          // Mengirim data layanan ke ServiceCard
          return ServiceCard(service: services[index]);
        },
      ),
    );
  }
}

// Widget untuk setiap kartu layanan.
class ServiceCard extends StatefulWidget {
  const ServiceCard({super.key, required this.service});
  final LaundryService service;

  @override
  State<ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<ServiceCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    // ---- PROPERTI ANIMASI YANG DILEBIHKAN ----
    final Color cardColor = _isPressed ? Colors.amberAccent : Colors.blueAccent;
    final Matrix4 transform = _isPressed
        ? (Matrix4.identity()..scale(0.95)) // Efek MENGECIL agar lebih terlihat
        : Matrix4.identity();
    final double shadowBlur = _isPressed ? 20.0 : 8.0;

    return GestureDetector(
      // ---- BAGIAN PENTING ADA DI SINI ----
      onTapDown: (_) {
        print("TAP DOWN DETECTED!"); // Debugging
        setState(() {
          _isPressed = true;
        });
      },
      onTapUp: (_) async {
        print("TAP UP DETECTED!"); // Debugging
        setState(() {
          _isPressed = false;
        });
        await Future.delayed(
          const Duration(milliseconds: 300),
        ); // Jeda lebih lama
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailScreen(service: widget.service),
            ),
          );
        }
      },
      onTapCancel: () {
        print("TAP CANCEL DETECTED!"); // Debugging
        setState(() {
          _isPressed = false;
        });
      },
      child: AnimatedContainer(
        // ---- DURASI ANIMASI DIPERLAMBAT ----
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        transform: transform, // Menerapkan efek scaling
        transformAlignment: Alignment.center, // Pastikan scaling dari tengah
        decoration: BoxDecoration(
          color: cardColor, // Menerapkan perubahan warna
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: shadowBlur, // Menerapkan perubahan bayangan
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return constraints.maxWidth < 180
                ? _buildCompactLayout()
                : _buildWideLayout();
          },
        ),
      ),
    );
  }

  // Bagian ini tidak perlu diubah
  Widget _buildCompactLayout() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Hero(
            tag: widget.service.name,
            child: Icon(
              widget.service.icon,
              size: 40,
              color: const Color(0xFF005f9f),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            widget.service.name,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            widget.service.price,
            style: TextStyle(color: Colors.grey[700], fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildWideLayout() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Hero(
            tag: widget.service.name,
            child: Icon(
              widget.service.icon,
              size: 48,
              color: const Color(0xFF005f9f),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.service.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  widget.service.price,
                  style: TextStyle(color: Colors.grey[700], fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
