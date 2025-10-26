import 'package:flutter/material.dart';
import 'package:laundry3b1titik0/catalog_screen.dart';
import 'package:get/get.dart';
import 'package:laundry3b1titik0/screens/delivery_screen.dart';
import 'dart:ui' as ui;

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
              'Laundry 3B',
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
          // Bagian Header Konten (Salam)
          _buildWelcomeHeader(context),

          // "Efek Gantung"
          Transform.translate(
            offset: const Offset(0.0, -70.0), // Sesuai settingan terakhirmu
            child: buildInfoCard(),
          ),

          // Bagian 2: Menu Grid (8 Item)
          _buildMenuSection(context),

          // Jarak antara Menu dan Promo
          const SizedBox(height: 24),

          // Bagian 3: Promo Banner
          _buildPromoSection(),

          // Beri jarak di bawah agar tidak terlalu mepet
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // WIDGET MODIFIKASI: Teks Salam + Latar Biru
  Widget _buildWelcomeHeader(BuildContext context) {
    const Color primaryColor = Color(0xFF005f9f);

    return Container(
      padding: const EdgeInsets.fromLTRB(
        16.0,
        16.0,
        16.0,
        100.0,
      ), // Sesuai settingan terakhirmu
      decoration: const BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Selamat Datang, Pelanggan!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Ada yang bisa kami bantu hari ini?',
            style: TextStyle(fontSize: 16, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  // WIDGET MODIFIKASI: Kartu Status (Oranye & Floating)
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
              // ignore: deprecated_member_use
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
              'Status Pesanan Terkini',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 8),
            const Text(
              'Pakaian - Sedang Dicuci',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () {
                // Aksi untuk 'Lacak Detail'
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: Colors.white54),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text('Lacak Detail'),
            ),
          ],
        ),
      ),
    );
  }

  // WIDGET BARU: Wrapper untuk Judul dan Grid Menu
  Widget _buildMenuSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Layanan Kami',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(height: 16),
            buildMenuGrid(context), // Panggil Grid 8 Menu
          ],
        ),
      ),
    );
  }

  // WIDGET MODIFIKASI: Grid 8 Menu
  Widget buildMenuGrid(BuildContext context) {
    final List<Map<String, dynamic>> menuItems = [
      {
        'icon': Icons.local_laundry_service,
        'label': 'Katalog',
        'page': const CatalogScreen(),
      },
      {
        'icon': Icons.delivery_dining,
        'label': 'Antar-Jemput',
        'page': const DeliveryScreen(),
      },
      {'icon': Icons.store, 'label': 'Outlet', 'page': null},
      {
        'icon': Icons.account_balance_wallet,
        'label': 'Isi Saldo',
        'page': null,
      },
      {'icon': Icons.card_giftcard, 'label': 'Poin', 'page': null},
      {'icon': Icons.confirmation_number, 'label': 'Voucher', 'page': null},
      {'icon': Icons.price_check, 'label': 'Cek Harga', 'page': null},
      {'icon': Icons.help_outline, 'label': 'Bantuan', 'page': null},
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

        // Buat widget tombol
        final menuButton = HomeMenuButton(
          icon: item['icon'],
          label: item['label'],
          page: item['page'],
        );

        // Jika bukan, kembalikan tombol biasa
        return menuButton;
        // ===========================================
      },
    );
  }

  // WIDGET buildMenuButton() LAMA DIHAPUS

  // WIDGET BARU: Wrapper untuk Judul dan Banner Promo
  Widget _buildPromoSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Info & Promo',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 16),
          buildPromoBanner(), // Panggil Banner yang sudah ada
        ],
      ),
    );
  }

  // WIDGET UNTUK BAGIAN 3: PROMO BANNER (Tidak berubah, hanya dipanggil)
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
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Promo Spesial!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Diskon 20% untuk cuci Bed Cover hari ini.',
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
    // Tentukan skala dan warna berdasarkan state _isInteracting
    final scale = _isInteracting ? 0.95 : 1.0;
    final bgColor = _isInteracting
        // ignore: deprecated_member_use
        ? _primaryColor.withOpacity(0.2) // Warna saat di-hover/tekan
        // ignore: deprecated_member_use
        : _primaryColor.withOpacity(0.1); // Warna normal

    return InkWell(
      // --- Handler untuk deteksi interaksi ---
      onTapDown: (_) => setState(() => _isInteracting = true),
      onTapUp: (_) {
        setState(() => _isInteracting = false);

        // ===== PERUBAHAN DI SINI =====
        // Jalankan aksi navigasi menggunakan GetX
        if (widget.page != null) {
          Get.to(() => widget.page!); // <--- Ganti Navigator.push
        } else {
          // 2. PERBAIKI NAMA FUNGSI MENJADI 'Get.snackbar'
          Get.snackbar(
            'Segera Hadir',
            'Fitur "${widget.label}" sedang dalam pengembangan.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.grey[700],
            colorText: Colors.white,
          );
        }
        // =============================
      },
      onTapCancel: () => setState(() => _isInteracting = false),
      onHover: (isHovering) => setState(() => _isInteracting = isHovering),

      // ----------------------------------------
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
                color: bgColor, // Gunakan warna animasi
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
