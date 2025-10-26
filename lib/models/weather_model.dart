import 'dart:convert'; // Untuk jsonDecode

class WeatherModel {
  final String cityName;
  final String description;
  final double temperature;
  final String iconCode; // Tambahkan ini untuk ikon cuaca nanti (opsional)

  WeatherModel({
    required this.cityName,
    required this.description,
    required this.temperature,
    required this.iconCode,
  });

  // Factory method untuk membuat WeatherModel dari JSON
  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    // Ambil data dari struktur JSON OpenWeatherMap
    final weather = json['weather'][0];
    final main = json['main'];

    return WeatherModel(
      // Ambil nama kota dari key 'name'
      cityName: json['name'] ?? 'Unknown City', 
      // Ambil deskripsi dari 'weather' array index 0, key 'description'
      description: weather['description'] ?? 'No description', 
      // Ambil temperatur dari 'main', key 'temp'
      // Pastikan konversi ke double aman
      temperature: (main['temp'] as num?)?.toDouble() ?? 0.0, 
      // Ambil kode ikon dari 'weather' array index 0, key 'icon'
      iconCode: weather['icon'] ?? '01d', // Default ikon cerah
    );
  }

  // Fungsi helper untuk mendapatkan URL ikon (opsional tapi bagus)
  String getIconUrl() {
    return 'https://openweathermap.org/img/wn/$iconCode@2x.png';
  }
}

// Helper function untuk parsing JSON string (jika diperlukan)
WeatherModel weatherModelFromJson(String str) => WeatherModel.fromJson(json.decode(str));