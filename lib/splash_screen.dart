import 'dart:async';
import 'package:flutter/material.dart';
import 'home_screen.dart'; // Kita akan buat file ini setelah ini

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

// Gunakan 'SingleTickerProviderStateMixin' untuk efisiensi animasi
class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  // 1. Deklarasikan AnimationController dan Animation
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // 2. Inisialisasi controller
    _controller = AnimationController(
      duration: const Duration(seconds: 2), // Animasi berjalan selama 2 detik
      vsync: this,
    );

    // 3. Inisialisasi animasi dengan efek 'easeIn'
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    // 4. Mulai animasi
    _controller.forward();

    // 5. Atur timer untuk pindah ke halaman utama
    Timer(
      const Duration(seconds: 3), // Splash screen tampil selama 3 detik
      () => Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (BuildContext context) => const HomeScreen(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // 6. Jangan lupa dispose controller saat widget tidak digunakan
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Palet warna yang kita diskusikan
    // ignore: unused_local_variable
    const Color primaryBlue = Color(0xFF005f9f);
    const Color backgroundColor = Color.fromARGB(255, 255, 255, 255);

    return Scaffold(
      backgroundColor: backgroundColor,
      // GANTI BAGIAN 'body' YANG LAMA DENGAN INI
      body: Center(
        child: FadeTransition(
          opacity: _animation,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape
                  .rectangle, // Membuat bayangan mengikuti bentuk lingkaran
            ),
            child: Image.asset('assets/images/logo_3b.png', width: 200),
          ),
        ),
      ),
    );
  }
}
