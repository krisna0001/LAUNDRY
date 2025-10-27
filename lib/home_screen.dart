import 'package:flutter/material.dart';
import 'package:laundry3b1titik0/catalog_screen.dart';
import 'package:get/get.dart';
import 'package:laundry3b1titik0/screens/delivery_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF005f9f);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0.0,
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo_3b.png',
              height: 80,
              color: Colors.white,
              colorBlendMode: BlendMode.modulate,
            ),
            const SizedBox(width: 12),
            const Text(
              'Laundry 3B - Admin',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        children: [
          _buildWelcomeHeader(context),

          Transform.translate(
            offset: const Offset(0.0, -70.0),
            child: buildInfoCard(),
          ),

          _buildMenuSection(context),

          const SizedBox(height: 24),

          _buildPromoSection(),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildWelcomeHeader(BuildContext context) {
    const Color primaryColor = Color(0xFF005f9f);

    return Container(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 100.0),
      decoration: const BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Dashboard Operasional',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Ringkasan status laundry hari ini.',
            style: TextStyle(fontSize: 16, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget buildInfoCard() {
    const Color cardColor = Color.fromARGB(255, 255, 3, 3);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: cardColor.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Order Perlu Perhatian',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 8),
            const Text(
              '7 Order Antri Pickup',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: Colors.white54),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text('Lihat Antrian Pickup'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Panel Kontrol',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(height: 16),
            buildMenuGrid(context),
          ],
        ),
      ),
    );
  }

  Widget buildMenuGrid(BuildContext context) {
    final List<Map<String, dynamic>> menuItems = [
      {
        'icon': Icons.inventory_2,
        'label': 'Manajemen Layanan',
        'page': const CatalogScreen(),
      },
      {
        'icon': Icons.delivery_dining,
        'label': 'Manajemen Kurir',
        'page': const DeliveryScreen(),
      },
      {'icon': Icons.store, 'label': 'Data Outlet', 'page': null},
      {
        'icon': Icons.account_balance_wallet,
        'label': 'Laporan Keuangan',
        'page': null,
      },
      {'icon': Icons.people, 'label': 'Data Pelanggan', 'page': null},
      {
        'icon': Icons.confirmation_number,
        'label': 'Manajemen Promo',
        'page': null,
      },
      {'icon': Icons.price_check, 'label': 'Atur Harga', 'page': null},
      {'icon': Icons.menu_book, 'label': 'Panduan SOP', 'page': null},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: menuItems.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemBuilder: (context, index) {
        final item = menuItems[index];

        final menuButton = HomeMenuButton(
          icon: item['icon'],
          label: item['label'],
          page: item['page'],
        );

        return menuButton;
      },
    );
  }

  Widget _buildPromoSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pemberitahuan Sistem',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 16),
          buildPromoBanner(),
        ],
      ),
    );
  }

  Widget buildPromoBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.teal[50],
        borderRadius: BorderRadius.circular(16),
        image: const DecorationImage(
          image: AssetImage('assets/images/promo_bg.png'),
          fit: BoxFit.cover,
          opacity: 0.2,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Perlu Perhatian',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal[700],
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Mesin Pengering #2 dijadwalkan maintenance sore ini pukul 16:00.',
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Icon(Icons.campaign, color: Colors.teal[300], size: 50),
        ],
      ),
    );
  }
}

class HomeMenuButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final Widget? page;

  const HomeMenuButton({
    super.key,
    required this.icon,
    required this.label,
    required this.page,
  });

  @override
  State<HomeMenuButton> createState() => _HomeMenuButtonState();
}

class _HomeMenuButtonState extends State<HomeMenuButton> {
  bool _isInteracting = false;
  static const Duration _animDuration = Duration(milliseconds: 150);
  static const Color _primaryColor = Color(0xFF005f9f);

  @override
  Widget build(BuildContext context) {
    final scale = _isInteracting ? 0.95 : 1.0;
    final bgColor = _isInteracting
        ? _primaryColor.withOpacity(0.2)
        : _primaryColor.withOpacity(0.1);

    return InkWell(
      onTapDown: (_) => setState(() => _isInteracting = true),
      onTapUp: (_) {
        setState(() => _isInteracting = false);

        if (widget.page != null) {
          Get.to(() => widget.page!);
        } else {
          Get.snackbar(
            'Fitur Belum Aktif',
            'Panel "${widget.label}" sedang dalam persiapan.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.grey[700],
            colorText: Colors.white,
          );
        }
      },
      onTapCancel: () => setState(() => _isInteracting = false),
      onHover: (isHovering) => setState(() => _isInteracting = isHovering),

      borderRadius: BorderRadius.circular(12),
      child: AnimatedScale(
        scale: scale,
        duration: _animDuration,
        curve: Curves.easeOut,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: _animDuration,
              curve: Curves.easeOut,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(widget.icon, color: _primaryColor, size: 28),
            ),
            const SizedBox(height: 8),
            Text(
              widget.label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 11, color: Colors.black54),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
