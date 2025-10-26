import 'package:flutter/material.dart';
import 'package:get/get.dart'; // <--- Impor Get
import 'package:laundry3b1titik0/controllers/main_page_controller.dart'; 
import 'package:laundry3b1titik0/home_screen.dart';
import 'package:laundry3b1titik0/orders_screen.dart';
import 'package:laundry3b1titik0/chat_screen.dart';
import 'package:laundry3b1titik0/profile_screen.dart';

// ===== PERUBAHAN DI SINI =====
// Ganti dari StatefulWidget menjadi GetView<MainPageController>
class MainPage extends GetView<MainPageController> {
  const MainPage({super.key});

  // Pindahkan daftar halaman ke sini
  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    OrdersScreen(),
    ChatScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    // Inisialisasi controller
    // Get.put() mendaftarkan controller ke GetX
    final MainPageController controller = Get.put(MainPageController());

    return Scaffold(
      // ===== PERUBAHAN DI SINI =====
      // Bungkus body dengan Obx()
      // Obx akan "mendengarkan" perubahan pada variabel .obs di controller
      body: Obx(() {
        // Ambil nilai selectedIndex dari controller
        return Center(
          child: _widgetOptions.elementAt(controller.selectedIndex.value),
        );
      }),
      // =============================
      bottomNavigationBar: Obx(() => BottomNavigationBar( // Bungkus lagi agar icon-nya ganti
        type: BottomNavigationBarType.fixed, // Agar warna label terlihat
        selectedItemColor: Theme.of(context).primaryColor, // Warna biru
        unselectedItemColor: Colors.grey, // Warna abu-abu
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Pesanan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Akun',
          ),
        ],
        // ===== PERUBAHAN DI SINI =====
        // Ambil index dari controller
        currentIndex: controller.selectedIndex.value,
        // Panggil fungsi controller saat di-tap
        onTap: (index) => controller.changePage(index),
        // =============================
      )),
    );
  }
}