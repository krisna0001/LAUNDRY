import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../controllers/location_controller.dart';

class LocationExperimentPage extends GetView<LocationController> {
  const LocationExperimentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Inisialisasi posisi saat halaman dibuka
    controller.getCurrentPosition();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lokasi & Peta'),
        elevation: 0,
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          // ========== BAGIAN PETA ==========
          Expanded(
            flex: 2,
            child: Obx(
              () => FlutterMap(
                options: MapOptions(
                  initialCenter: controller.userLocation.value,
                  initialZoom: 18.0,
                  interactionOptions: const InteractionOptions(
                    flags: InteractiveFlag.pinchZoom |
                        InteractiveFlag.drag |
                        InteractiveFlag.flingAnimation,
                  ),
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    subdomains: const ['a', 'b', 'c'],
                  ),
                  MarkerLayer(
                    markers: [
                      if (controller.userLocation.value.latitude != 0 &&
                          controller.userLocation.value.longitude != 0)
                        Marker(
                          point: controller.userLocation.value,
                          width: 80.0,
                          height: 80.0,
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 3,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.location_on,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                              // Circle untuk akurasi
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.blue.withOpacity(0.3),
                                    width: 2,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // ========== BAGIAN DATA & KONTROL ==========
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.grey[100],
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Data Real-time
                    Text(
                      'Data Lokasi Real-Time:',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Obx(
                      () => Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Text(
                          controller.locationMessage.value,
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 12,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Mode Toggle
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Mode: ${controller.isGpsMode.value ? "GPS (High Accuracy)" : "Network (Low Accuracy)"}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Obx(
                          () => Switch(
                            value: controller.isGpsMode.value,
                            onChanged: (value) {
                              controller.toggleMode(value);
                            },
                            activeColor: Colors.teal,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Tombol Tracking
                    Row(
                      children: [
                        Expanded(
                          child: Obx(
                            () => ElevatedButton.icon(
                              icon: Icon(
                                controller.isTracking.value
                                    ? Icons.stop_circle
                                    : Icons.play_circle,
                              ),
                              label: Text(
                                controller.isTracking.value
                                    ? 'Hentikan Tracking'
                                    : 'Mulai Tracking',
                              ),
                              onPressed: () {
                                if (controller.isTracking.value) {
                                  controller.stopLiveTracking();
                                } else {
                                  controller.startLiveTracking();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: controller.isTracking.value
                                    ? Colors.red
                                    : Colors.teal,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Info untuk laporan
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue[200]!),
                      ),
                      child: const Text(
                        '💡 Catatan: Catat data akurasi di sini untuk:\n'
                        '• GPS Mode (outdoor untuk hasil maksimal)\n'
                        '• Network Mode (untuk perbandingan)\n'
                        '• Bandingkan akurasi indoor vs outdoor',
                        style: TextStyle(fontSize: 11),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
