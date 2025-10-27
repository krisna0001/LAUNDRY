import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:laundry3b1titik0/models/weather_model.dart';

class DeliveryController extends GetxController {
  var isLoading = false.obs;
  var weatherData = Rx<WeatherModel?>(null);
  var errorMessage = ''.obs;
  var fetchTimeHttp = ''.obs;
  var fetchTimeDio = ''.obs;

  final String _apiKey = '70497336d3d17d0f79edd66a0b679ff4';
  final String _cityName = 'Malang';
  late String _apiUrl;

  final Dio _dio = Dio();

  @override
  void onInit() {
    super.onInit();
    _apiUrl =
        'https://api.openweathermap.org/data/2.5/weather?q=$_cityName&appid=$_apiKey&units=metric&lang=id';
  }

  Future<void> fetchWeatherHttp() async {
    isLoading.value = true;
    errorMessage.value = '';
    fetchTimeHttp.value = '';
    fetchTimeDio.value = '';
    weatherData.value = null;
    final stopwatch = Stopwatch()..start();

    try {
      final response = await http.get(Uri.parse(_apiUrl));
      stopwatch.stop();
      fetchTimeHttp.value = '${stopwatch.elapsedMilliseconds} ms';
      print('Eksperimen HTTP selesai dalam: ${fetchTimeHttp.value}');

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        weatherData.value = WeatherModel.fromJson(jsonData);
      } else {
        errorMessage.value =
            'Gagal memuat data (HTTP): Status ${response.statusCode}';
        print('Error HTTP: ${response.body}');
      }
    } catch (e) {
      stopwatch.stop();
      errorMessage.value = 'Terjadi kesalahan (HTTP): $e';
      print('Exception HTTP: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void fetchWeatherDio() {
    isLoading.value = true;
    errorMessage.value = '';
    fetchTimeHttp.value = '';
    fetchTimeDio.value = '';
    weatherData.value = null;
    final stopwatch = Stopwatch()..start();

    _dio
        .get(_apiUrl)
        .then((response) {
          stopwatch.stop();
          fetchTimeDio.value = '${stopwatch.elapsedMilliseconds} ms';
          print('Eksperimen DIO selesai dalam: ${fetchTimeDio.value}');

          if (response.statusCode == 200) {
            weatherData.value = WeatherModel.fromJson(response.data);
          } else {
            errorMessage.value =
                'Gagal memuat data (Dio): Status ${response.statusCode}';
            print('Error Dio: ${response.statusMessage}');
          }
          isLoading.value = false;
        })
        .catchError((error) {
          stopwatch.stop();
          if (error is DioException) {
            errorMessage.value = 'Terjadi kesalahan (Dio): ${error.message}';
            print('DioException: ${error.response?.data ?? error.message}');
          } else {
            errorMessage.value =
                'Terjadi kesalahan tidak dikenal (Dio): $error';
            print('Exception Dio: $error');
          }
          isLoading.value = false;
          weatherData.value = null;
        });
  }

  String getWeatherAdvice(String description) {
    description = description.toLowerCase();
    if (description.contains('hujan') || description.contains('gerimis')) {
      return 'Tenang, kami jemput laundry-mu biar gak kehujanan! 🚚☔';
    } else if (description.contains('cerah')) {
      return 'Cuaca cerah nih! Yuk, kunjungi outlet kami atau jadwalkan penjemputan. ☀️🧺';
    } else if (description.contains('awan')) {
      return 'Agak mendung nih! Kalau takut tiba-tiba hujan, biar kami yang jemput laundry-mu. ☁️👕';
    } else if (description.contains('kabut') || description.contains('asap')) {
      return 'Agak berkabut, tapi layanan antar jemput kami tetap siap! 🌫️🚗';
    } else {
      return 'Apapun cuacanya, laundry tetap jalan terus! 😉';
    }
  }
}
