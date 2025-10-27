import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundry3b1titik0/detail_screen.dart';

class LaundryService {
  final String name;
  final String price;
  final IconData icon;

  LaundryService({required this.name, required this.price, required this.icon});
}

class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<LaundryService> services = [
      LaundryService(
        name: 'Cuci Kering Lipat',
        price: 'Rp 7.000/kg',
        icon: Icons.local_laundry_service,
      ),
      LaundryService(
        name: 'Setrika Kiloan',
        price: 'Rp 5.000/kg',
        icon: Icons.iron,
      ),
      LaundryService(
        name: 'Cuci Satuan Kemeja',
        price: 'Rp 15.000/pcs',
        icon: Icons.checkroom,
      ),
      LaundryService(
        name: 'Cuci Bed Cover',
        price: 'Rp 25.000/pcs',
        icon: Icons.king_bed,
      ),
      LaundryService(
        name: 'Cuci Sepatu',
        price: 'Rp 30.000/psg',
        icon: Icons.ice_skating,
      ),
      LaundryService(
        name: 'Dry Cleaning Jas',
        price: 'Rp 50.000/pcs',
        icon: Icons.dry_cleaning,
      ),
    ];

    final Size screenSize = MediaQuery.of(context).size;

    final int crossAxisCount = screenSize.width > 600 ? 3 : 2;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Katalog Layanan'),
        backgroundColor: const Color(0xFF005f9f),
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 0.9,
          ),
          itemCount: services.length,
          itemBuilder: (context, index) {
            return ServiceCard(service: services[index]);
          },
        ),
      ),
    );
  }
}

class ServiceCard extends StatefulWidget {
  const ServiceCard({super.key, required this.service});

  final LaundryService service;

  @override
  State<ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<ServiceCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    const Color cardColor = Colors.white;
    final double elevation = _isPressed ? 8.0 : 2.0;
    final EdgeInsets padding = _isPressed
        ? const EdgeInsets.all(16.0)
        : const EdgeInsets.all(12.0);

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapCancel: () => setState(() => _isPressed = false),
      onTapUp: (_) async {
        setState(() => _isPressed = false);
        await Future.delayed(const Duration(milliseconds: 150));
        if (mounted) {
          Get.to(() => DetailScreen(service: widget.service));
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeInOut,
        padding: padding,
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: elevation,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            if (constraints.maxWidth < 180) {
              return buildCompactCard();
            } else {
              return buildWideCard();
            }
          },
        ),
      ),
    );
  }

  Widget buildCompactCard() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Hero(
          tag: 'service_icon_${widget.service.name}',
          child: Material(
            type: MaterialType.transparency,
            child: Icon(
              widget.service.icon,
              size: 40,
              color: const Color(0xFF005f9f),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          widget.service.name,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          widget.service.price,
          style: TextStyle(color: Colors.grey[700], fontSize: 12),
        ),
      ],
    );
  }

  Widget buildWideCard() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Hero(
          tag: 'service_icon_${widget.service.name}',
          child: Material(
            type: MaterialType.transparency,
            child: Icon(
              widget.service.icon,
              size: 48,
              color: const Color(0xFF005f9f),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.service.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.service.price,
                style: TextStyle(color: Colors.grey[700], fontSize: 14),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
