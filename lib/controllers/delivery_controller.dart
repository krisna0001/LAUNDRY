import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:laundry3b1titik0/models/weather_model.dart';

class DeliveryController extends GetxController {
  var isLoading = false.obs;
  var weatherData = Rx<WeatherModel?>(null);
  var operationalWarning = ''.obs;
  var errorMessage = ''.obs;

  var fetchTimeHttp = ''.obs;
  var fetchTimeDio = ''.obs;
  var fetchTimeChain = ''.obs;

  final String _apiKey = '70497336d3d17d0f79edd66a0b679ff4';
  final String _cityName = 'Malang';
  late String _apiUrl;

  final String _gnewsApiKey = 'GANTI_DENGAN_API_KEY_GNEWS_ANDA';

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
    fetchTimeChain.value = '';
    weatherData.value = null;
    operationalWarning.value = '';
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
      errorMessage.value = 'Terjadi kesalahan (HTTP): ${e.toString()}';
      print('Exception HTTP: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  void fetchWeatherDio() {
    isLoading.value = true;
    errorMessage.value = '';
    fetchTimeHttp.value = '';
    fetchTimeDio.value = '';
    fetchTimeChain.value = '';
    weatherData.value = null;
    operationalWarning.value = '';
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
                'Terjadi kesalahan tidak dikenal (Dio): ${error.toString()}';
            print('Exception Dio: ${error.toString()}');
          }
          isLoading.value = false;
          weatherData.value = null;
        });
  }

  Future<void> checkOperationalImpact() async {
    isLoading.value = true;
    errorMessage.value = '';
    weatherData.value = null;
    operationalWarning.value = '';
    fetchTimeHttp.value = '';
    fetchTimeDio.value = '';
    fetchTimeChain.value = '';
    final stopwatch = Stopwatch()..start();

    try {
      print('Rantai #1: Memanggil API Cuaca (OpenWeather)...');
      final weatherResponse = await _dio.get(_apiUrl);
      final weather = WeatherModel.fromJson(weatherResponse.data);

      bool isWeatherBad =
          weather.description.toLowerCase().contains('hujan') ||
          weather.description.toLowerCase().contains('gerimis') ||
          weather.description.toLowerCase().contains('badai');

      if (isWeatherBad) {
        print(
          'Rantai #1: Cuaca Buruk ($weather.description). Lanjut Cek Berita Darurat...',
        );

        final String fromDateTime = DateTime.now()
            .subtract(const Duration(hours: 12))
            .toIso8601String();
        final String query = '($_cityName AND (banjir OR longsor))';

        final String gnewsApiUrl =
            'https://gnews.io/api/v4/search?q=$query&lang=id&from=$fromDateTime&token=$_gnewsApiKey';

        final newsResponse = await _dio.get(gnewsApiUrl);

        final int totalArticles = newsResponse.data['totalArticles'] ?? 0;

        stopwatch.stop();
        fetchTimeChain.value = '${stopwatch.elapsedMilliseconds} ms';

        if (totalArticles > 0) {
          final String articleTitle = newsResponse.data['articles'][0]['title'];
          operationalWarning.value =
              'PERINGATAN (Hujan + Berita): Cuaca buruk DAN terdeteksi $totalArticles laporan berita darurat (Contoh: "$articleTitle"). \nCek rute kurir & siapkan CS!';
        } else {
          operationalWarning.value =
              'INFO (Hujan): Cuaca buruk terdeteksi, namun tidak ada laporan berita darurat (banjir/longsor) dalam 12 jam terakhir. Operasional tetap waspada.';
        }
      } else {
        print('Rantai #1: Cuaca Aman ($weather.description). Rantai Berhenti.');
        stopwatch.stop();
        fetchTimeChain.value = '${stopwatch.elapsedMilliseconds} ms';
        operationalWarning.value =
            'INFO: Cuaca Cerah ($weather.description). Operasional normal.';
      }
    } catch (e) {
      stopwatch.stop();
      if (e is DioException) {
        if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
          errorMessage.value =
              'Gagal Cek Berita: API Key GNews salah atau kuota habis.';
        } else {
          errorMessage.value = 'Terjadi kesalahan Rantai (Dio): ${e.message}';
        }
        print('DioException Rantai: ${e.response?.data ?? e.message}');
      } else {
        errorMessage.value = 'Terjadi kesalahan Rantai: ${e.toString()}';
        print('Exception Rantai: ${e.toString()}');
      }
    } finally {
      isLoading.value = false;
    }
  }

  String getWeatherAdvice(String description) {
    description = description.toLowerCase();

    if (description.contains('hujan') || description.contains('gerimis')) {
      return 'REKOMENDASI (Hujan): Prioritaskan pickup di zona rawan macet. Ingatkan kurir bawa jas hujan & perlengkapan anti-air.';
    } else if (description.contains('cerah')) {
      return 'INFO (Cerah): Kondisi ideal. Operasional kurir dan penjemuran (jika ada) berjalan normal.';
    } else if (description.contains('awan')) {
      return 'WASPADA (Mendung): Potensi hujan sore hari. Percepat jadwal pickup sebelum jam 15:00 jika memungkinkan.';
    } else if (description.contains('kabut') || description.contains('asap')) {
      return 'INFO (Berkabut): Jarak pandang kurir mungkin terbatas. Ingatkan tim untuk hati-hati di jalan.';
    } else {
      return 'Data cuaca diterima. Belum ada rekomendasi operasional khusus.';
    }
  }
}
