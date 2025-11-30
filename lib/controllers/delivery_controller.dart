import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'dart:convert';
import 'package:laundry3b1titik0/models/weather_model.dart';
import 'package:laundry3b1titik0/models/forecast_model.dart';

class DeliveryController extends GetxController {
  final weatherData = Rx<WeatherModel?>(null);
  final forecastData = Rx<ForecastModel?>(null);
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final currentLocationName = 'Mendeteksi lokasi...'.obs;

  // PERBAIKAN: Tambahkan variabel untuk peta
  final currentMapPosition = LatLng(-7.9213, 112.5992).obs;

  final String _newsApiKey = 'bb4b2cb3cf1342f0a05b16748241612b';

  late String _apiUrl;
  late String _forecastApiUrl;

  @override
  void onInit() {
    super.onInit();
    fetchOperationalData();
  }

  /// Fungsi utama: Cek cuaca berdasarkan GPS dengan permission handling lengkap
  Future<void> fetchOperationalData() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Step 1: Cek apakah layanan lokasi aktif
      final bool isServiceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!isServiceEnabled) {
        errorMessage.value = '❌ GPS mati - Silakan aktifkan Location Services';
        currentLocationName.value = 'GPS Tidak Aktif';
        isLoading.value = false;
        return;
      }

      print('✓ GPS Service aktif');

      // Step 2: Cek permission lokasi saat ini
      LocationPermission permission = await Geolocator.checkPermission();
      print('Current permission status: $permission');

      // Step 3: Jika permission denied, minta izin
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        print('Permission setelah request: $permission');
      }

      // Step 4: Jika permission deniedForever, return error
      if (permission == LocationPermission.deniedForever) {
        errorMessage.value =
            '❌ Izin lokasi ditolak permanen - Ubah di pengaturan aplikasi';
        currentLocationName.value = 'Izin Ditolak';
        isLoading.value = false;
        return;
      }

      // Step 5: Jika permission tidak whileInUse atau always, return error
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        errorMessage.value =
            '❌ Izin lokasi belum diberikan - Silakan berikan izin';
        currentLocationName.value = 'Izin Belum Diberikan';
        isLoading.value = false;
        return;
      }

      print('✓ Permission granted: $permission');

      // Step 6: Dapatkan posisi GPS saat ini
      final Position position = await Geolocator.getCurrentPosition(
        forceAndroidLocationManager: true,
      );

      final double latitude = position.latitude;
      final double longitude = position.longitude;

      print('✓ GPS Location obtained: Lat=$latitude, Lon=$longitude');

      // PERBAIKAN: Update posisi peta
      currentMapPosition.value = LatLng(latitude, longitude);

      // Step 7: Update URL API untuk menggunakan Open-Meteo (gratis, no key)
      _apiUrl =
          'https://api.open-meteo.com/v1/forecast?latitude=$latitude&longitude=$longitude&current=temperature_2m,relative_humidity_2m,weather_code,wind_speed_10m&timezone=auto';
      _forecastApiUrl =
          'https://api.open-meteo.com/v1/forecast?latitude=$latitude&longitude=$longitude&daily=weather_code,temperature_2m_max,temperature_2m_min&timezone=auto';

      // Step 8: Fetch data cuaca
      await _fetchWeatherData(latitude, longitude);

      // Step 9: Ambil nama lokasi dari reverse geocoding dan fetch berita
      if (weatherData.value != null &&
          currentLocationName.value != 'Mendeteksi lokasi...') {
        await _fetchNews(currentLocationName.value);
      }
    } catch (e) {
      errorMessage.value = '❌ Error: $e';
      currentLocationName.value = 'Error';
      print('Error in fetchOperationalData: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetch data cuaca dari Open-Meteo (gratis, no API key)
  Future<void> _fetchWeatherData(double latitude, double longitude) async {
    try {
      print('Fetching weather from Open-Meteo: $_apiUrl');

      final response = await http.get(Uri.parse(_apiUrl)).timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          throw Exception('Weather API request timeout (15s)');
        },
      );

      print('Response Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        // Konversi dari Open-Meteo format ke WeatherModel format
        weatherData.value = _convertOpenMeteoToWeatherModel(jsonData);

        // Dapatkan nama lokasi dari reverse geocoding
        await _getLocationName(latitude, longitude);

        errorMessage.value = '';
        print('✓ Weather data fetched successfully from Open-Meteo');
      } else {
        throw Exception(
            'Failed to fetch weather data - Status: ${response.statusCode}');
      }
    } catch (e) {
      errorMessage.value = '❌ Error fetching weather: $e';
      print('Error in _fetchWeatherData: $e');
    }
  }

  /// Convert Open-Meteo response ke WeatherModel format
  WeatherModel _convertOpenMeteoToWeatherModel(Map<String, dynamic> json) {
    final current = json['current'] as Map<String, dynamic>?;

    return WeatherModel(
      name: 'Lokasi Saat Ini',
      main: current != null
          ? MainData(
              temp: (current['temperature_2m'] as num?)?.toDouble(),
              humidity: (current['relative_humidity_2m'] as num?)?.toInt(),
              pressure: null,
            )
          : null,
      weather: current != null
          ? [
              WeatherData(
                main: _getWeatherDescription(current['weather_code'] as int?),
                description:
                    _getWeatherDescription(current['weather_code'] as int?),
              )
            ]
          : null,
      wind: current != null
          ? WindData(
              speed: (current['wind_speed_10m'] as num?)?.toDouble(),
              deg: null,
            )
          : null,
    );
  }

  /// Dapatkan deskripsi cuaca dari WMO weather code
  String _getWeatherDescription(int? code) {
    if (code == null) return 'Unknown';

    const Map<int, String> weatherCodes = {
      0: 'Clear Sky',
      1: 'Mainly Clear',
      2: 'Partly Cloudy',
      3: 'Overcast',
      45: 'Foggy',
      48: 'Foggy (Rime)',
      51: 'Light Drizzle',
      53: 'Moderate Drizzle',
      55: 'Dense Drizzle',
      61: 'Slight Rain',
      63: 'Moderate Rain',
      65: 'Heavy Rain',
      71: 'Slight Snow',
      73: 'Moderate Snow',
      75: 'Heavy Snow',
      77: 'Snow Grains',
      80: 'Slight Rain Showers',
      81: 'Moderate Rain Showers',
      82: 'Violent Rain Showers',
      85: 'Slight Snow Showers',
      86: 'Heavy Snow Showers',
      95: 'Thunderstorm',
      96: 'Thunderstorm with Slight Hail',
      99: 'Thunderstorm with Heavy Hail',
    };

    return weatherCodes[code] ?? 'Unknown ($code)';
  }

  /// Dapatkan nama lokasi dari reverse geocoding (Nominatim)
  Future<void> _getLocationName(double latitude, double longitude) async {
    try {
      final url =
          'https://nominatim.openstreetmap.org/reverse?format=json&lat=$latitude&lon=$longitude';

      final response = await http.get(Uri.parse(url)).timeout(
            const Duration(seconds: 10),
          );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final address = jsonData['address'] as Map<String, dynamic>?;

        String locationName = 'Lokasi Saat Ini';

        if (address != null) {
          locationName = address['city'] as String? ??
              address['town'] as String? ??
              address['village'] as String? ??
              address['county'] as String? ??
              'Lokasi Saat Ini';
        }

        currentLocationName.value = locationName;
        print('✓ Location name: $locationName');
      }
    } catch (e) {
      print('⚠ Warning getting location name: $e');
      currentLocationName.value = 'Lokasi Saat Ini';
    }
  }

  /// Fetch berita berdasarkan nama lokasi
  Future<void> _fetchNews(String locationName) async {
    try {
      final String newsUrl =
          'https://newsapi.org/v2/everything?q=$locationName weather&sortBy=publishedAt&language=id&apiKey=$_newsApiKey';

      print('Fetching news from: $newsUrl');
      final response = await http.get(Uri.parse(newsUrl)).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('News API request timeout');
        },
      );

      if (response.statusCode == 200) {
        print('✓ News data fetched successfully for $locationName');
      } else {
        print(
            '⚠ Warning: Failed to fetch news data - Status: ${response.statusCode}');
      }
    } catch (e) {
      print('⚠ Warning fetching news: $e');
    }
  }

  /// Refresh manual data cuaca
  Future<void> refreshWeatherData() async {
    await fetchOperationalData();
  }
}
