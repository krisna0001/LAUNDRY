// ignore_for_file: avoid_print

import 'dart:convert'; // Untuk jsonDecode
import 'package:get/get.dart';
import 'package:http/http.dart' as http; // Impor http
import 'package:dio/dio.dart'; // Impor dio
import 'package:laundry3b1titik0/models/weather_model.dart'; // Impor model

class DeliveryController extends GetxController {
  // --- State Variables ---
  var isLoading = false.obs;
  var weatherData = Rx<WeatherModel?>(null);
  var errorMessage = ''.obs;
  var fetchTimeHttp = ''.obs;
  var fetchTimeDio = ''.obs;

  // --- API Configuration ---
  // GANTI DENGAN API KEY MILIKMU!
  final String _apiKey = '70497336d3d17d0f79edd66a0b679ff4'; 
  final String _cityName = 'Malang'; // Target kota
  // URL endpoint OpenWeatherMap untuk cuaca saat ini
  // units=metric agar suhu dalam Celcius
  late String _apiUrl; 

  // Dio instance
  final Dio _dio = Dio();

  @override
  void onInit() {
    super.onInit();
    // Buat URL API lengkap saat controller diinisialisasi
    _apiUrl = 'https://api.openweathermap.org/data/2.5/weather?q=$_cityName&appid=$_apiKey&units=metric&lang=id'; // Tambah lang=id untuk deskripsi Indonesia
  }

  // --- Eksperimen 1: HTTP + async/await + Stopwatch ---
  Future<void> fetchWeatherHttp() async {
    isLoading.value = true;
    errorMessage.value = '';
    fetchTimeHttp.value = '';
    fetchTimeDio.value = ''; // Reset waktu Dio juga
    weatherData.value = null;
    final stopwatch = Stopwatch()..start(); // Mulai stopwatch

    try {
      final response = await http.get(Uri.parse(_apiUrl));
      stopwatch.stop(); // Hentikan stopwatch
      fetchTimeHttp.value = '${stopwatch.elapsedMilliseconds} ms'; // Catat waktu
      print('Eksperimen HTTP selesai dalam: ${fetchTimeHttp.value}'); // Print ke konsol

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        weatherData.value = WeatherModel.fromJson(jsonData);
      } else {
        errorMessage.value = 'Gagal memuat data (HTTP): Status ${response.statusCode}';
        print('Error HTTP: ${response.body}'); // Print error detail
      }
    } catch (e) {
      stopwatch.stop(); // Hentikan stopwatch jika error
      errorMessage.value = 'Terjadi kesalahan (HTTP): $e';
      print('Exception HTTP: $e'); // Print exception
    } finally {
      isLoading.value = false;
    }
  }

  // --- Eksperimen 2: Dio + .then() + Stopwatch ---
  void fetchWeatherDio() {
    isLoading.value = true;
    errorMessage.value = '';
    fetchTimeHttp.value = ''; // Reset waktu Http
    fetchTimeDio.value = ''; 
    weatherData.value = null;
    final stopwatch = Stopwatch()..start(); // Mulai stopwatch

    _dio.get(_apiUrl).then((response) {
      stopwatch.stop(); // Hentikan stopwatch
      fetchTimeDio.value = '${stopwatch.elapsedMilliseconds} ms'; // Catat waktu
      print('Eksperimen DIO selesai dalam: ${fetchTimeDio.value}'); // Print ke konsol

      if (response.statusCode == 200) {
        // Dio otomatis decode JSON jika responsnya valid
        weatherData.value = WeatherModel.fromJson(response.data); 
      } else {
        errorMessage.value = 'Gagal memuat data (Dio): Status ${response.statusCode}';
         print('Error Dio: ${response.statusMessage}'); // Print error detail Dio
      }
      isLoading.value = false; // Set loading false SETELAH data diproses
      
    }).catchError((error) {
      stopwatch.stop(); // Hentikan stopwatch jika error
      // Dio error handling bisa lebih detail
      if (error is DioException) {
         errorMessage.value = 'Terjadi kesalahan (Dio): ${error.message}';
         print('DioException: ${error.response?.data ?? error.message}'); // Print detail error Dio
      } else {
        errorMessage.value = 'Terjadi kesalahan tidak dikenal (Dio): $error';
        print('Exception Dio: $error'); // Print exception umum
      }
      isLoading.value = false; // Set loading false jika error
      weatherData.value = null;
    });
  }

  // --- Helper Function ---
  String getWeatherAdvice(String description) {
    description = description.toLowerCase();
    // Tambahkan lebih banyak variasi deskripsi dari OpenWeatherMap (ID)
    if (description.contains('hujan') || description.contains('gerimis')) {
      return 'Tenang, kami jemput laundry-mu biar gak kehujanan! 🚚☔';
    } else if (description.contains('cerah')) {
      return 'Cuaca cerah nih! Yuk, kunjungi outlet kami atau jadwalkan penjemputan. ☀️🧺';
    } else if (description.contains('awan')) { // Mencakup "berawan", "sedikit berawan", dll.
       return 'Agak mendung nih! Kalau takut tiba-tiba hujan, biar kami yang jemput laundry-mu. ☁️👕';
    } else if (description.contains('kabut') || description.contains('asap')) {
       return 'Agak berkabut, tapi layanan antar jemput kami tetap siap! 🌫️🚗';
    } else {
      return 'Apapun cuacanya, laundry tetap jalan terus! 😉';
    }
  }
}