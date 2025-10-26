import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:laundry3b1titik0/main_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

// ===== 1. TAMBAHKAN 'with SingleTickerProviderStateMixin' =====
class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  // ==========================================================

  // ===== 2. DEKLARASIKAN ANIMATION CONTROLLER & ANIMATION =====
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  // ==========================================================

  @override
  void initState() {
    super.initState();

    // ===== 3. INISIALISASI CONTROLLER & ANIMATION =====
    _controller = AnimationController(
      duration: const Duration(seconds: 2), // Durasi animasi fade-in
      vsync: this, // Gunakan 'this' karena sudah ada mixin
    );
    // Buat animasi curve (dari 0.0 ke 1.0)
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn, // Efek muncul perlahan
    );
    // ==================================================

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        // Pastikan widget masih ada
        _controller.forward();
      }
    });

    // Timer untuk pindah halaman (tetap sama)
    Timer(const Duration(seconds: 3), () {
      Get.off(() => const MainPage());
    });
  }

  // ===== 4. JANGAN LUPA DISPOSE CONTROLLER =====
  @override
  void dispose() {
    _controller.dispose(); // Hentikan controller saat widget dihapus
    super.dispose();
  }
  // =============================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(
        255,
        255,
        255,
        255,
      ), // Warna primer kita
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ===== 5. BUNGKUS DENGAN FadeTransition =====
            FadeTransition(
              opacity: _fadeAnimation, // Gunakan animasi fade
              child: Image.asset(
                'assets/images/logo_3b.png',
                height: 400,
                color: Colors.white,
                colorBlendMode: BlendMode.modulate,
              ),
            ),
            const SizedBox(height: 20),
            FadeTransition(
              // Bungkus Teks juga
              opacity: _fadeAnimation, // Gunakan animasi yang sama
              child: const Text(
                'Laundry 3B',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ),
            ),
            // =============================================
            const SizedBox(height: 40),
            // Loading indicator biarkan saja muncul langsung
            const SizedBox(
              height: 15.0,
              width: 15.0,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Color.fromARGB(255, 0, 0, 0),
                ),
                strokeWidth: 3.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
