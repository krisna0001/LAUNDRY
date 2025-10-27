import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundry3b1titik0/controllers/main_page_controller.dart';
import 'package:laundry3b1titik0/home_screen.dart';
import 'package:laundry3b1titik0/orders_screen.dart';
import 'package:laundry3b1titik0/chat_screen.dart';
import 'package:laundry3b1titik0/profile_screen.dart';

class MainPage extends GetView<MainPageController> {
  const MainPage({super.key});

  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    OrdersScreen(),
    ChatScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final MainPageController controller = Get.put(MainPageController());

    return Scaffold(
      body: Obx(() {
        return Center(
          child: _widgetOptions.elementAt(controller.selectedIndex.value),
        );
      }),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor: Colors.grey,
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
          currentIndex: controller.selectedIndex.value,
          onTap: (index) => controller.changePage(index),
        ),
      ),
    );
  }
}
