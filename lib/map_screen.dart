// lib/map_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart'; // Package ini otomatis ikut ter-install

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lokasi Outlet Kami'),
        backgroundColor: const Color(0xFF005f9f),
      ),
      body: FlutterMap(
        // Opsi untuk mengatur peta
        options: MapOptions(
          // Titik tengah awal peta (ini contoh di Monas, Jakarta)
          initialCenter: LatLng(-6.1753924, 106.8271528),
          initialZoom: 15.0, // Level zoom awal
        ),

        // Layer-layer yang akan ditampilkan di peta
        children: [
          // 1. Layer Gambar Peta (Tile Layer)
          TileLayer(
            // URL untuk mengambil gambar peta dari OpenStreetMap
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName:
                'com.example.laundryapp', // Ganti dengan nama paket aplikasimu
          ),

          // 2. Layer Penanda (Marker Layer)
          MarkerLayer(
            markers: [
              // Daftar penanda di peta
              Marker(
                width: 80.0,
                height: 80.0,
                point: LatLng(-6.1753924, 106.8271528), // Posisi penanda
                child: Column(
                  children: [
                    Icon(Icons.location_pin, color: Colors.red, size: 40),
                    Text(
                      'Outlet Pusat',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade900,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
