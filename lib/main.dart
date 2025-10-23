import 'package:flutter/material.dart';
import 'splash_screen.dart'; // Impor file splash screen

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Laundry 3B',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(), // Atur SplashScreen sebagai halaman pertama
      debugShowCheckedModeBanner: false,
    );
  }
}