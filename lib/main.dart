import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundry3b1titik0/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Laundry 3B',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: const Color(0xFF005f9f),
      ),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
