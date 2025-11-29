import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class LocationController extends GetxController {
  // Observable variables
  final latitude = 0.0.obs;
  final longitude = 0.0.obs;
  final accuracy = 0.0.obs; // dalam meter
  final timestamp = DateTime.now().obs;
  final isGpsMode = true.obs;
  final locationMessage = "Belum ada data lokasi".obs;
  final isTracking = false.obs;
  final userLocation = LatLng(0, 0).obs;

  @override
  void onInit() {
    super.onInit();
    _checkLocationPermission();
  }

  // Cek dan request permission
  Future<void> _checkLocationPermission() async {
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      await Geolocator.requestPermission();
    }
  }

  // Toggle antara GPS (High Accuracy) dan Network (Low Accuracy)
  Future<void> toggleMode(bool value) async {
    isGpsMode.value = value;
    locationMessage.value = value
        ? "Mode: GPS (High Accuracy)"
        : "Mode: Network (Low Accuracy)";

    // Jika sedang tracking, restart dengan mode baru
    if (isTracking.value) {
      await stopLiveTracking();
      await Future.delayed(Duration(milliseconds: 500));
      await startLiveTracking();
    }
  }

  // Mulai pelacakan real-time
  Future<void> startLiveTracking() async {
    try {
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        locationMessage.value = "Izin lokasi ditolak";
        return;
      }

      final isServiceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!isServiceEnabled) {
        locationMessage.value = "Layanan lokasi tidak aktif";
        return;
      }

      isTracking.value = true;
      locationMessage.value = "Tracking dimulai...";

      final LocationAccuracy accuracy = isGpsMode.value
          ? LocationAccuracy.high
          : LocationAccuracy.low;

      final positionStream = Geolocator.getPositionStream(
        locationSettings: LocationSettings(
          accuracy: accuracy,
          distanceFilter: 0, // Update setiap perubahan
        ),
      );

      positionStream.listen(
        (Position position) {
          latitude.value = position.latitude;
          longitude.value = position.longitude;
          this.accuracy.value = position.accuracy;
          timestamp.value = position.timestamp ?? DateTime.now();
          userLocation.value = LatLng(position.latitude, position.longitude);

          final modeText = isGpsMode.value ? "GPS" : "Network";
          locationMessage.value =
              "$modeText | Lat: ${position.latitude.toStringAsFixed(6)}, Lon: ${position.longitude.toStringAsFixed(6)}\n"
              "Akurasi: ${position.accuracy.toStringAsFixed(2)}m\n"
              "Waktu: ${position.timestamp?.hour}:${position.timestamp?.minute}:${position.timestamp?.second}";
        },
        onError: (error) {
          locationMessage.value = "Error: $error";
          isTracking.value = false;
        },
      );
    } catch (e) {
      locationMessage.value = "Exception: $e";
      isTracking.value = false;
    }
  }

  // Hentikan pelacakan
  Future<void> stopLiveTracking() async {
    isTracking.value = false;
    locationMessage.value = "Tracking dihentikan";
  }

  // Ambil posisi sekali (untuk inisialisasi peta)
  Future<void> getCurrentPosition() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        forceAndroidLocationManager: true,
      );
      latitude.value = position.latitude;
      longitude.value = position.longitude;
      accuracy.value = position.accuracy;
      userLocation.value = LatLng(position.latitude, position.longitude);
    } catch (e) {
      locationMessage.value = "Error mendapat posisi: $e";
    }
  }
}
