import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundry3b1titik0/controllers/delivery_controller.dart'; 

class DeliveryScreen extends GetView<DeliveryController> {
  const DeliveryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DeliveryController controller = Get.put(DeliveryController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Layanan Antar-Jemput'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch, 
          children: [
            const Text(
              'Cek Cuaca Sebelum Antar-Jemput',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // --- Tombol Eksperimen ---
            ElevatedButton(
              onPressed: () => controller.fetchWeatherHttp(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
              ),
              child: const Text('Cek Cuaca (via HTTP)'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => controller.fetchWeatherDio(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 255, 0, 0),
                foregroundColor: Colors.white,
              ), 
              child: const Text('Cek Cuaca (via Dio)'),
            ),
            const SizedBox(height: 30),

            // --- Area Hasil (Reaktif dengan Obx) ---
            Obx(() {
              // Tampilkan loading
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              // Tampilkan error
              if (controller.errorMessage.isNotEmpty) {
                 return Center(
                   child: Text(
                     controller.errorMessage.value, 
                     style: const TextStyle(color: Colors.red, fontSize: 16),
                     textAlign: TextAlign.center,
                   ),
                 );
              }
              // Tampilkan data cuaca
              if (controller.weatherData.value != null) {
                final weather = controller.weatherData.value!;
                final advice = controller.getWeatherAdvice(weather.description);
                // ===== PERBAIKAN LOGIKA WAKTU FETCH =====
                final timeHttp = controller.fetchTimeHttp.value;
                final timeDio = controller.fetchTimeDio.value;
                String fetchTimeText = ''; // String kosong default
                if (timeHttp.isNotEmpty) {
                    fetchTimeText = 'Fetch Time (HTTP): $timeHttp';
                } else if (timeDio.isNotEmpty) {
                    fetchTimeText = 'Fetch Time (Dio): $timeDio';
                }
                // =========================================

                return Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Cuaca di ${weather.cityName}:', // Tampilkan nama kota dari API
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        Row( // Gunakan Row untuk ikon dan teks
                          children: [
                            // ===== PERBAIKAN IKON CUACA =====
                            CircleAvatar( // Bungkus dengan CircleAvatar
                              radius: 25, // Ukuran lingkaran
                              backgroundColor: const Color.fromARGB(255, 150, 157, 255), // Warna latar biru muda
                              child: Image.network(
                                weather.getIconUrl(), 
                                width: 40, // Sedikit lebih kecil agar pas di lingkaran
                                height: 40,
                                errorBuilder: (context, error, stackTrace) => 
                                    Icon(Icons.cloud_off, size: 30, color: Colors.grey[700]), // Sesuaikan fallback
                              ),
                            ),
                            // ==================================
                            const SizedBox(width: 12),
                            Expanded( // Agar teks tidak overflow
                              child: Text(
                                // Ubah deskripsi jadi Kapital di awal kata
                                '${weather.description.split(' ').map((word) => 
                                   word[0].toUpperCase() + word.substring(1)).join(' ')} (${weather.temperature.toStringAsFixed(1)}°C)',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Saran:',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(advice),
                        const SizedBox(height: 10),
                        // Tampilkan teks waktu fetch jika tidak kosong
                        if (fetchTimeText.isNotEmpty) 
                           Text(
                             fetchTimeText, 
                             style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                           ),
                      ],
                    ),
                  ),
                );
              }
              // Tampilan default
              return const Center(
                  child: Text('Tekan tombol di atas untuk mengecek cuaca.'));
            }),
          ],
        ),
      ),
    );
  }
}