import 'package:flutter/material.dart';
import 'package:get/get.dart'; // <--- Impor Get
import 'package:laundry3b1titik0/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Ganti MaterialApp menjadi GetMaterialApp
    return GetMaterialApp( 
      title: 'Laundry 3B',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // Atur warna primer kustom kita
        primaryColor: const Color(0xFF005f9f), 
      ),
      debugShowCheckedModeBanner: false,
      // Halaman awal tetap SplashScreen
      home: const SplashScreen(), 
    );
  }
}