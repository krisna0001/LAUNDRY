import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundry3b1titik0/detail_screen.dart';
import 'package:laundry3b1titik0/controllers/catalog_controller.dart';

class LaundryService {
  final String name;
  final String price;
  final IconData icon;

  LaundryService({required this.name, required this.price, required this.icon});

  factory LaundryService.fromJson(Map<String, dynamic> json) {
    // Map icon strings to IconData (assuming 'icon' field contains icon name as string)
    final iconName = json['icon'] ?? 'local_laundry_service';
    final iconData = _getIconFromString(iconName);

    return LaundryService(
      name: json['name'] ?? 'Unknown Service',
      price: json['price'] ?? 'Price not available',
      icon: iconData,
    );
  }

  static IconData _getIconFromString(String iconName) {
    const iconMap = {
      'local_laundry_service': Icons.local_laundry_service,
      'iron': Icons.iron,
      'checkroom': Icons.checkroom,
      'king_bed': Icons.king_bed,
      'ice_skating': Icons.ice_skating,
      'dry_cleaning': Icons.dry_cleaning,
    };
    return iconMap[iconName] ?? Icons.local_laundry_service;
  }
}

class CatalogScreen extends GetView<CatalogController> {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CatalogController catalogController = Get.put(CatalogController());

    final Size screenSize = MediaQuery.of(context).size;
    final int crossAxisCount = screenSize.width > 600 ? 3 : 2;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manajemen Layanan'),
        backgroundColor: const Color(0xFF005f9f),
        elevation: 1,
      ),
      body: Obx(() {
        if (catalogController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (catalogController.services.isEmpty) {
          return const Center(child: Text('Tidak ada layanan tersedia'));
        }

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 0.9,
            ),
            itemCount: catalogController.services.length,
            itemBuilder: (context, index) {
              return ServiceCard(service: catalogController.services[index]);
            },
          ),
        );
      }),
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
          style: TextStyle(color: Colors.red[700], fontSize: 12),
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
                style: TextStyle(color: Colors.red[700], fontSize: 14),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
