import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:laundry3b1titik0/models/weather_model.dart';
import 'package:laundry3b1titik0/models/forecast_model.dart';
import 'package:collection/collection.dart';

class DeliveryController extends GetxController {
  var isLoading = false.obs;
  var weatherData = Rx<WeatherModel?>(null);
  var operationalWarning = ''.obs;
  var errorMessage = ''.obs;

  var fetchTimeHttp = ''.obs;
  var fetchTimeDio = ''.obs;
  var fetchTimeChain = ''.obs;

  var forecastList = <ForecastItem>[].obs;

  final String _apiKey = '70497336d3d17d0f79edd66a0b679ff4';
  final String _cityName = 'Malang';
  late String _apiUrl;
  late String _forecastApiUrl;

  final String _gnewsApiKey = 'GANTI_DENGAN_API_KEY_GNEWS_ANDA';

  final Dio _dio = Dio();

  @override
  void onInit() {
    super.onInit();
    _apiUrl =
        'https://api.openweathermap.org/data/2.5/weather?q=$_cityName&appid=$_apiKey&units=metric&lang=id';
    _forecastApiUrl =
        'https://api.openweathermap.org/data/2.5/forecast?q=$_cityName&appid=$_apiKey&units=metric&lang=id';
  }

  Future<void> _fetchForecast() async {
    try {
      final response = await _dio.get(_forecastApiUrl);
      if (response.statusCode == 200) {
        forecastList.value = ForecastModel.fromJson(response.data).list;
        print('Sukses memuat ${forecastList.length} data perkiraan cuaca.');
      } else {
        print('Gagal memuat perkiraan cuaca: ${response.statusMessage}');
      }
    } catch (e) {
      print('Error memuat perkiraan cuaca: ${e.toString()}');
    }
  }

  Future<void> fetchWeatherHttp() async {
    isLoading.value = true;
    errorMessage.value = '';
    fetchTimeHttp.value = '';
    fetchTimeDio.value = '';
    fetchTimeChain.value = '';
    weatherData.value = null;
    operationalWarning.value = '';
    forecastList.clear();
    final stopwatch = Stopwatch()..start();

    try {
      final response = await http.get(Uri.parse(_apiUrl));
      stopwatch.stop();
      fetchTimeHttp.value = '${stopwatch.elapsedMilliseconds} ms';
      print('Eksperimen HTTP selesai dalam: ${fetchTimeHttp.value}');

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        weatherData.value = WeatherModel.fromJson(jsonData);
        await _fetchForecast();
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
    forecastList.clear();
    final stopwatch = Stopwatch()..start();

    _dio
        .get(_apiUrl)
        .then((response) async {
          stopwatch.stop();
          fetchTimeDio.value = '${stopwatch.elapsedMilliseconds} ms';
          print('Eksperimen DIO selesai dalam: ${fetchTimeDio.value}');

          if (response.statusCode == 200) {
            weatherData.value = WeatherModel.fromJson(response.data);
            await _fetchForecast();
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
          'Rantai #1: Cuaca Buruk (${weather.description}). Lanjut Cek Berita Darurat...',
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
        print(
          'Rantai #1: Cuaca Aman (${weather.description}). Rantai Berhenti.',
        );
        stopwatch.stop();
        fetchTimeChain.value = '${stopwatch.elapsedMilliseconds} ms';

        operationalWarning.value =
            'INFO CUACA SEDANG (${weather.description}). Operasional normal.';
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

  String getWeatherAdvice(WeatherModel weather) {
    String description = weather.description.toLowerCase();
    final now = DateTime.now();

    if (description.contains('hujan') || description.contains('gerimis')) {
      return 'REKOMENDASI (Hujan Sekarang): Sedang hujan! Ingatkan kurir bawa jas hujan & perlengkapan anti-air. Prioritaskan pickup di zona rawan macet.';
    }
    if (description.contains('cerah')) {
      return 'INFO (Cerah): Kondisi ideal. Operasional kurir dan penjemuran (jika ada) berjalan normal.';
    }

    if (description.contains('awan') || description.contains('mendung')) {
      if (forecastList.isEmpty) {
        return 'INFO (Mendung): Cuaca saat ini mendung. Belum bisa memuat data perkiraan cuaca.';
      }

      final upcomingForecastsToday = forecastList
          .where(
            (item) =>
                item.dateTime.isAfter(now) && item.dateTime.day == now.day,
          )
          .toList();

      if (upcomingForecastsToday.isEmpty) {
        return 'INFO (Mendung): Cuaca mendung. Sisa hari ini aman (tidak ada perkiraan hujan).';
      }

      final firstRainEvent = upcomingForecastsToday.firstWhereOrNull(
        (item) =>
            item.description.contains('hujan') ||
            item.description.contains('gerimis'),
      );

      if (firstRainEvent == null) {
        return 'INFO (Mendung): Cuaca mendung, namun perkiraan cuaca sisa hari ini **AMAN** (tidak ada tanda hujan). Operasional normal.';
      } else {
        final rainStartTime = firstRainEvent.dateTime;
        final rainTimeStr = '${rainStartTime.hour}:00';

        final clearWeatherAfterRain = forecastList.firstWhereOrNull(
          (item) =>
              item.dateTime.isAfter(rainStartTime) &&
              !(item.description.contains('hujan') ||
                  item.description.contains('gerimis')),
        );

        if (clearWeatherAfterRain != null) {
          final clearTimeStr = '${clearWeatherAfterRain.dateTime.hour}:00';
          return 'WASPADA (Mendung): Ada potensi hujan hari ini sekitar jam $rainTimeStr. \nREKOMENDASI: Selesaikan pickup sebelum jam itu. \nINFO: Hujan diperkirakan akan reda sekitar jam $clearTimeStr.';
        } else {
          return 'WASPADA (Mendung): Ada potensi hujan hari ini sekitar jam $rainTimeStr dan diperkirakan berlangsung lama. \nREKOMENDASI: Selesaikan semua pickup SEBELUM jam $rainTimeStr.';
        }
      }
    }

    if (description.contains('kabut') || description.contains('asap')) {
      return 'INFO (Berkabut): Jarak pandang kurir mungkin terbatas. Ingatkan tim untuk hati-hati di jalan.';
    }

    return 'Data cuaca diterima: $description. Belum ada rekomendasi khusus.';
  }
}
