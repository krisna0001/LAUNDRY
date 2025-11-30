import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:laundry3b1titik0/controllers/delivery_controller.dart';

class DeliveryScreen extends StatelessWidget {
  const DeliveryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DeliveryController controller = Get.put(DeliveryController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manajemen Kurir & Cuaca'),
        backgroundColor: Colors.teal,
        elevation: 0,
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  // ========== BAGIAN PETA =========
                  Expanded(
                    flex: 1,
                    child: Obx(
                      () => FlutterMap(
                        options: MapOptions(
                          initialCenter: controller.currentMapPosition.value,
                          initialZoom: 16.0,
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
                              Marker(
                                point: controller.currentMapPosition.value,
                                width: 80.0,
                                height: 80.0,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 3,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.red.withOpacity(0.5),
                                            blurRadius: 10,
                                            spreadRadius: 2,
                                          ),
                                        ],
                                      ),
                                      padding: const EdgeInsets.all(8),
                                      child: const Icon(
                                        Icons.local_shipping,
                                        color: Colors.white,
                                        size: 24,
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
                  // ========== BAGIAN CUACA & INFO ==========
                  Expanded(
                    flex: 1,
                    child: RefreshIndicator(
                      onRefresh: () => controller.refreshWeatherData(),
                      child: ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          _buildWeatherCard(controller),
                          const SizedBox(height: 20),
                          // ========== PRAKIRAAN CUACA =========
                          _buildForecastSection(controller),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildWeatherCard(DeliveryController controller) {
    return Obx(
      () => Card(
        elevation: 4,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [Colors.teal[400]!, Colors.teal[700]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Lokasi Saat Ini',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          controller.currentLocationName.value,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.4),
                        width: 1,
                      ),
                    ),
                    child: const Row(
                      children: [
                        Text(
                          '📍',
                          style: TextStyle(fontSize: 12),
                        ),
                        SizedBox(width: 6),
                        Text(
                          'GPS Akurat',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildWeatherInfo(
                    icon: Icons.thermostat,
                    label: 'Suhu',
                    value:
                        '${controller.weatherData.value?.main?.temp?.toStringAsFixed(1) ?? '--'}°C',
                  ),
                  _buildWeatherInfo(
                    icon: Icons.opacity,
                    label: 'Kelembaban',
                    value:
                        '${controller.weatherData.value?.main?.humidity ?? '--'}%',
                  ),
                  _buildWeatherInfo(
                    icon: Icons.air,
                    label: 'Angin',
                    value:
                        '${controller.weatherData.value?.wind?.speed?.toStringAsFixed(1) ?? '--'} m/s',
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      controller.weatherData.value?.weather?.first.main ??
                          'Unknown',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        controller.weatherData.value?.weather?.first.description
                                .toString()
                                .toUpperCase() ??
                            '',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ========== PRAKIRAAN CUACA (FORECAST) ==========
  Widget _buildForecastSection(DeliveryController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Prakiraan Cuaca',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Obx(
          () {
            // Dapatkan list forecast dengan aman
            final forecastList = controller.forecastData.value?.list ?? [];

            if (forecastList.isEmpty) {
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Text('Data prakiraan tidak tersedia'),
                ),
              );
            }

            return SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: forecastList.length,
                itemBuilder: (context, index) {
                  final forecast = forecastList[index];

                  // 1. Format Jam (Fix Syntax)
                  final jamText =
                      "${forecast.dateTime.hour.toString().padLeft(2, '0')}:${forecast.dateTime.minute.toString().padLeft(2, '0')}";

                  // 2. Ambil Deskripsi
                  final description = forecast.description;

                  // 3. Suhu Dummy (Karena tidak ada di model)
                  final temp = "--";

                  return Card(
                    margin: const EdgeInsets.only(right: 12),
                    child: Container(
                      width: 100,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.blue[300]!,
                            Colors.blue[700]!,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            jamText,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Icon(
                            _getWeatherIcon(description),
                            color: Colors.white,
                            size: 32,
                          ),
                          Text(
                            description,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '$temp°C',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }

  IconData _getWeatherIcon(String description) {
    final desc = description.toLowerCase();
    if (desc.contains('clear') || desc.contains('sunny')) {
      return Icons.wb_sunny;
    } else if (desc.contains('cloud')) {
      return Icons.cloud;
    } else if (desc.contains('rain')) {
      return Icons.cloud_queue;
    } else if (desc.contains('snow')) {
      return Icons.ac_unit;
    } else if (desc.contains('thunder') || desc.contains('storm')) {
      return Icons.flash_on;
    } else {
      return Icons.wb_cloudy;
    }
  }

  Widget _buildWeatherInfo(
      {required IconData icon, required String label, required String value}) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 28),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class Main {
  final double? temp;
  final int? humidity;

  Main({this.temp, this.humidity});
}

class Weather {
  final String? main;
  final String? description;

  Weather({this.main, this.description});
}

class Wind {
  final double? speed;

  Wind({this.speed});
}

class WeatherModel {
  final Main? main;
  final List<Weather>? weather;
  final Wind? wind;

  WeatherModel({this.main, this.weather, this.wind});

  // Example factory constructor for demonstration
  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      main: json['main'] != null
          ? Main(
              temp: (json['main']['temp'] as num?)?.toDouble(),
              humidity: json['main']['humidity'] as int?,
            )
          : null,
      weather: json['weather'] != null
          ? (json['weather'] as List)
              .map((w) => Weather(
                    main: w['main'] as String?,
                    description: w['description'] as String?,
                  ))
              .toList()
          : null,
      wind: json['wind'] != null
          ? Wind(
              speed: (json['wind']['speed'] as num?)?.toDouble(),
            )
          : null,
    );
  }
}

// Add ForecastItem class with weather field
class ForecastItem {
  final Main? main;
  final List<Weather>? weather;
  final String? dtTxt;

  ForecastItem({this.main, this.weather, this.dtTxt});

  factory ForecastItem.fromJson(Map<String, dynamic> json) {
    return ForecastItem(
      main: json['main'] != null
          ? Main(
              temp: (json['main']['temp'] as num?)?.toDouble(),
              humidity: json['main']['humidity'] as int?,
            )
          : null,
      weather: json['weather'] != null
          ? (json['weather'] as List)
              .map((w) => Weather(
                    main: w['main'] as String?,
                    description: w['description'] as String?,
                  ))
              .toList()
          : null,
      dtTxt: json['dt_txt'] as String?,
    );
  }
}
