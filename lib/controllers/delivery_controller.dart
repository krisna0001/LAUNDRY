import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:laundry3b1titik0/models/weather_model.dart';
import 'package:laundry3b1titik0/models/forecast_model.dart';

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
  late Box<WeatherModel> _weatherBox;
  late Box<ForecastItem> _forecastBox;

  @override
  void onInit() {
    super.onInit();
    _apiUrl =
        'https://api.openweathermap.org/data/2.5/weather?q=$_cityName&appid=$_apiKey&units=metric&lang=id';
    _forecastApiUrl =
        'https://api.openweathermap.org/data/2.5/forecast?q=$_cityName&appid=$_apiKey&units=metric&lang=id';
    _initializeHiveBoxes();
  }

  Future<void> _initializeHiveBoxes() async {
    _weatherBox = await Hive.openBox<WeatherModel>('weather');
    _forecastBox = await Hive.openBox<ForecastItem>('forecast');
    print('Hive boxes initialized');
  }

  void _loadCachedData() {
    // Load cached weather data
    if (_weatherBox.isNotEmpty) {
      weatherData.value = _weatherBox.getAt(0);
      print('Loaded cached weather data: ${weatherData.value?.cityName}');
    }

    // Load cached forecast data
    forecastList.clear();
    if (_forecastBox.isNotEmpty) {
      forecastList.addAll(_forecastBox.values);
      print('Loaded ${forecastList.length} cached forecast items');
    }
  }

  Future<void> _saveCachedData(
    WeatherModel weather,
    List<ForecastItem> forecasts,
  ) async {
    // Save weather data (keep only 1 latest record)
    await _weatherBox.clear();
    await _weatherBox.add(weather);
    print('Saved weather data to cache');

    // Save forecast data
    await _forecastBox.clear();
    for (var forecast in forecasts) {
      await _forecastBox.add(forecast);
    }
    print('Saved ${forecasts.length} forecast items to cache');
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
    operationalWarning.value = '';

    // Load cached data first
    _loadCachedData();

    final stopwatch = Stopwatch()..start();

    try {
      final response = await http.get(Uri.parse(_apiUrl));
      stopwatch.stop();
      fetchTimeHttp.value = '${stopwatch.elapsedMilliseconds} ms';
      print('Eksperimen HTTP selesai dalam: ${fetchTimeHttp.value}');

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final newWeather = WeatherModel.fromJson(jsonData);
        weatherData.value = newWeather;
        await _fetchForecast();

        // Save to cache
        await _saveCachedData(newWeather, forecastList);
      } else {
        if (weatherData.value != null) {
          errorMessage.value =
              'Gagal update data (HTTP): Status ${response.statusCode}. Menampilkan data cache terakhir.';
        } else {
          errorMessage.value =
              'Gagal memuat data (HTTP): Status ${response.statusCode}';
        }
        print('Error HTTP: ${response.body}');
      }
    } catch (e) {
      stopwatch.stop();
      if (weatherData.value != null) {
        errorMessage.value =
            'Terjadi kesalahan (HTTP): ${e.toString()}. Menampilkan data cache terakhir.';
      } else {
        errorMessage.value = 'Terjadi kesalahan (HTTP): ${e.toString()}';
      }
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
    operationalWarning.value = '';

    // Load cached data first
    _loadCachedData();

    final stopwatch = Stopwatch()..start();

    _dio
        .get(_apiUrl)
        .then((response) async {
          stopwatch.stop();
          fetchTimeDio.value = '${stopwatch.elapsedMilliseconds} ms';
          print('Eksperimen DIO selesai dalam: ${fetchTimeDio.value}');

          if (response.statusCode == 200) {
            final newWeather = WeatherModel.fromJson(response.data);
            weatherData.value = newWeather;
            await _fetchForecast();

            // Save to cache
            await _saveCachedData(newWeather, forecastList);
          } else {
            if (weatherData.value != null) {
              errorMessage.value =
                  'Gagal update data (Dio): Status ${response.statusCode}. Menampilkan data cache terakhir.';
            } else {
              errorMessage.value =
                  'Gagal memuat data (Dio): Status ${response.statusCode}';
            }
            print('Error Dio: ${response.statusMessage}');
          }
          isLoading.value = false;
        })
        .catchError((error) {
          stopwatch.stop();
          if (error is DioException) {
            if (weatherData.value != null) {
              errorMessage.value =
                  'Terjadi kesalahan (Dio): ${error.message}. Menampilkan data cache terakhir.';
            } else {
              errorMessage.value = 'Terjadi kesalahan (Dio): ${error.message}';
            }
            print('DioException: ${error.response?.data ?? error.message}');
          } else {
            if (weatherData.value != null) {
              errorMessage.value =
                  'Terjadi kesalahan tidak dikenal (Dio): ${error.toString()}. Menampilkan data cache terakhir.';
            } else {
              errorMessage.value =
                  'Terjadi kesalahan tidak dikenal (Dio): ${error.toString()}';
            }
            print('Exception Dio: ${error.toString()}');
          }
          isLoading.value = false;
        });
  }

  Future<void> checkOperationalImpact() async {
    isLoading.value = true;
    errorMessage.value = '';
    operationalWarning.value = '';
    fetchTimeHttp.value = '';
    fetchTimeDio.value = '';
    fetchTimeChain.value = '';

    // Load cached data first
    _loadCachedData();

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

        weatherData.value = weather;
        await _fetchForecast();
        await _saveCachedData(weather, forecastList);
      } else {
        print(
          'Rantai #1: Cuaca Aman (${weather.description}). Rantai Berhenti.',
        );
        stopwatch.stop();
        fetchTimeChain.value = '${stopwatch.elapsedMilliseconds} ms';

        operationalWarning.value =
            'INFO CUACA SEDANG (${weather.description}). Operasional normal.';

        weatherData.value = weather;
        await _fetchForecast();
        await _saveCachedData(weather, forecastList);
      }
    } catch (e) {
      stopwatch.stop();
      if (e is DioException) {
        if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
          if (weatherData.value != null) {
            errorMessage.value =
                'Gagal Cek Berita: API Key GNews salah atau kuota habis. Menampilkan data cache terakhir.';
          } else {
            errorMessage.value =
                'Gagal Cek Berita: API Key GNews salah atau kuota habis.';
          }
        } else {
          if (weatherData.value != null) {
            errorMessage.value =
                'Terjadi kesalahan Rantai (Dio): ${e.message}. Menampilkan data cache terakhir.';
          } else {
            errorMessage.value = 'Terjadi kesalahan Rantai (Dio): ${e.message}';
          }
        }
        print('DioException Rantai: ${e.response?.data ?? e.message}');
      } else {
        if (weatherData.value != null) {
          errorMessage.value =
              'Terjadi kesalahan Rantai: ${e.toString()}. Menampilkan data cache terakhir.';
        } else {
          errorMessage.value = 'Terjadi kesalahan Rantai: ${e.toString()}';
        }
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

      // Ganti firstWhereOrNull dengan firstWhere + orElse
      final firstRainEvent =
          upcomingForecastsToday.cast<ForecastItem?>().firstWhere(
                (item) =>
                    item != null &&
                    (item.description.contains('hujan') ||
                        item.description.contains('gerimis')),
                orElse: () => null,
              )
              as ForecastItem?;

      if (firstRainEvent == null) {
        return 'INFO (Mendung): Cuaca mendung, namun perkiraan cuaca sisa hari ini **AMAN** (tidak ada tanda hujan). Operasional normal.';
      } else {
        final rainStartTime = firstRainEvent.dateTime;
        final rainTimeStr = '${rainStartTime.hour}:00';

        final clearWeatherAfterRain =
            forecastList.cast<ForecastItem?>().firstWhere(
                  (item) =>
                      item != null &&
                      item.dateTime.isAfter(rainStartTime) &&
                      !(item.description.contains('hujan') ||
                          item.description.contains('gerimis')),
                  orElse: () => null,
                )
                as ForecastItem?;

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
