// lib/home_screen.dart

import 'package:flutter/material.dart';
import 'package:laundry3b1titik0/catalog_screen.dart';
import 'package:laundry3b1titik0/map_screen.dart';

class MenuItem {
  final String title;
  final IconData icon;
  final Color color;

  MenuItem({required this.title, required this.icon, required this.color});
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<MenuItem> menuItems = [
    MenuItem(
      title: 'Pesanan',
      icon: Icons.shopping_basket_outlined,
      color: Colors.orange,
    ),
    MenuItem(
      title: 'Layanan & Harga',
      icon: Icons.receipt_long_outlined,
      color: Colors.lightBlue,
    ),
    MenuItem(
      title: 'Pelanggan',
      icon: Icons.groups_outlined,
      color: Colors.green,
    ),
    MenuItem(
      title: 'Outlet',
      icon: Icons.store_outlined,
      color: Colors.blue.shade800,
    ),
    MenuItem(
      title: 'Laporan',
      icon: Icons.bar_chart_outlined,
      color: Colors.teal,
    ),
    MenuItem(
      title: 'Pengaturan',
      icon: Icons.settings_outlined,
      color: Colors.grey.shade600,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    print('Bottom nav item $index diketuk');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            _buildLaundrySelector(),
            _buildMenuGrid(),
            _buildBanner(),
            const SizedBox(height: 20),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.orange,
        child: const Icon(Icons.qr_code_scanner),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.home,
                color: _selectedIndex == 0
                    ? const Color(0xFF005f9f)
                    : Colors.grey,
              ),
              onPressed: () => _onItemTapped(0),
            ),
            IconButton(
              icon: Icon(
                Icons.sync_alt,
                color: _selectedIndex == 1
                    ? const Color(0xFF005f9f)
                    : Colors.grey,
              ),
              onPressed: () => _onItemTapped(1),
            ),
            const SizedBox(width: 40),
            IconButton(
              icon: Icon(
                Icons.account_balance_wallet,
                color: _selectedIndex == 2
                    ? const Color(0xFF005f9f)
                    : Colors.grey,
              ),
              onPressed: () => _onItemTapped(2),
            ),
            IconButton(
              icon: Icon(
                Icons.person,
                color: _selectedIndex == 3
                    ? const Color(0xFF005f9f)
                    : Colors.grey,
              ),
              onPressed: () => _onItemTapped(3),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 50, 20, 60),
      decoration: const BoxDecoration(
        color: Color(0xFF29B6F6),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white70,
                    child: Icon(Icons.home, color: Color(0xFF005f9f)),
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Hi, rdt',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.timer_outlined,
                          color: Colors.white,
                          size: 16,
                        ),
                        SizedBox(width: 5),
                        Text(
                          'Masa Aktif',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.notifications, color: Colors.white),
                ],
              ),
            ],
          ),
          const SizedBox(height: 25),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pendapatan hari ini',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Rp. 210.000',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                Icon(Icons.arrow_drop_down, color: Colors.grey, size: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLaundrySelector() {
    return Container(
      transform: Matrix4.translationValues(0.0, -25.0, 0.0),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'INI LAUNDRY',
            style: TextStyle(
              color: Color(0xFF005f9f),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 4),
          Icon(Icons.arrow_drop_down, color: Color(0xFF005f9f)),
        ],
      ),
    );
  }

  Widget _buildMenuGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.0,
        ),
        itemCount: menuItems.length,
        itemBuilder: (context, index) {
          final item = menuItems[index];
          return GestureDetector(
            // --- INI BAGIAN YANG DIPERBAIKI ---
            onTap: () {
              if (item.title == 'Layanan & Harga') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CatalogScreen(),
                  ),
                );
              } else if (item.title == 'Outlet') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MapScreen()),
                );
              } else {
                print('${item.title} diketuk!');
              }
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: item.color.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(item.icon, color: item.color, size: 30),
                ),
                const SizedBox(height: 8),
                Text(
                  item.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBanner() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Image.asset('assets/images/promo_banner.png', fit: BoxFit.cover),
      ),
    );
  }
}
