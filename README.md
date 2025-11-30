# Modul 5: Location-Aware & Upload Image Feature

## 📋 Ringkasan Penambahan

Modul 5 mengimplementasikan 2 fitur utama:
1. **Pelacakan lokasi real-time** dengan perbandingan akurasi GPS vs Network
2. **Upload gambar layanan** ke Supabase Storage dengan fitur multi-select layanan

---

## 📁 File & Folder yang Ditambahkan/Diupdate

### Fitur 1: Location-Aware

#### 1. `lib/controllers/location_controller.dart` (Baru)
**Lokasi:** Baris 1-170+
- Observable untuk tracking: `latitude`, `longitude`, `accuracy`, `timestamp`, `isGpsMode`, `isTracking`
- Default lokasi: UMM Malang `LatLng(-7.9213, 112.5992)`
- Fungsi: `toggleMode()` (switch GPS/Network), `startLiveTracking()` (streaming real-time), `getCurrentPosition()` (ambil posisi sekali)
- Support Android Location Manager untuk emulator (`forceLocationManager: true`)

#### 2. `lib/pages/location_experiment_page.dart` (Baru)
**Lokasi:** Baris 1-180+
- **UI Atas (60%):** FlutterMap dengan TileLayer OpenStreetMap, MarkerLayer dengan ikon tracking
- **UI Bawah (40%):** Data real-time, toggle mode GPS/Network, tombol Mulai/Hentikan Tracking
- Responsif dengan Obx untuk update real-time

#### 3. `lib/home_screen.dart` (Update)
**Lokasi Perubahan:**
- Baris 55-58: Tambah menu item "Lokasi & Peta" dengan icon `Icons.map`
- Baris 75-78: Inject `LocationController` saat navigasi
- Baris 195-210: Tambah `HomeMenuButton` untuk menu interaktif

### Fitur 2: Upload Image & Cuaca GPS

#### 1. `lib/services/supabase_service.dart` (Update)
**Lokasi Perubahan:**
- Baris 12-45: Fungsi `uploadServiceImage()` menggunakan `uploadBinary()` dengan `FileOptions(upsert: true, contentType: 'image/jpeg')`
- Baris 47-63: Fungsi `setPricing()` dengan parameter `imageUrl`
- Baris 65-85: Fungsi `getPricing()` dengan logging detail

#### 2. `lib/pages/atur_harga_page.dart` (Rewrite)
**Lokasi:** Baris 1-280+
- State: `_imageFile`, `_isLoadingServices`, `_isSubmitting`, `_pricingList`
- UI: Upload foto dengan preview, dropdown loading/error handling, daftar harga dengan gambar
- Fungsi: `_loadServices()`, `_pickImage()`, `_addPricing()`

#### 3. `lib/pages/add_order_page.dart` (Rewrite - Multi-Select Feature)
**Lokasi:** Baris 1-350+
- **State Management:**
  - Ganti `_selectedService` (String) → `List<Map> _selectedServices`
  - Getter: `double get _totalPrice` (fold otomatis)
- **UI:**
  - Baris 80-85: Tombol "Pilih Layanan (+)" mengganti dropdown
  - Baris 120-180: `showModalBottomSheet()` dengan `StatefulBuilder` untuk multi-select
  - Baris 200-220: Tampilkan pilihan dengan `Wrap` + `Chip` (bisa dihapus)
  - Baris 225-240: Tampilkan total harga otomatis
- **Submit:** Join layanan dengan koma, simpan total harga

#### 4. `lib/controllers/delivery_controller.dart` (Update)
**Lokasi Perubahan:**
- Baris 14: Tambah observable `currentMapPosition = LatLng(-7.9213, 112.5992)`
- Baris 74-75: Update `currentMapPosition` setelah `getCurrentPosition()`
- Baris 78-82: URL API menggunakan koordinat GPS
- Baris 96-120: Fetch cuaca dari Open-Meteo (no API key), reverse geocoding nama kota

#### 5. `lib/screens/delivery_screen.dart` (Update)
**Lokasi Perubahan:**
- Baris 1-71: `FlutterMap` dengan marker kurir, centered ke `currentMapPosition`
- Baris 80-150: Card cuaca dengan badge "📍 GPS Akurat", info suhu/kelembaban/angin
- Baris 155-230: `_buildForecastSection()` menampilkan prakiraan cuaca dari Open-Meteo

### Models

#### 1. `lib/models/weather_model.dart` (Rewrite)
**Lokasi:** Baris 1-100+
- Class: `WeatherModel`, `MainData`, `WeatherData`, `WindData`
- Support Hive serialization (@HiveType)
- Factory constructors untuk parsing API JSON

#### 2. `lib/models/weather_model.g.dart` (Generated)
**Lokasi:** Baris 1-150+
- Auto-generated Hive adapters untuk semua class
- TypeId: WeatherModel=0, MainData=3, WeatherData=4, WindData=5

#### 3. `lib/models/forecast_model.dart` (Existing)
- Class: `ForecastModel`, `ForecastItem`
- Property: `dateTime` (DateTime), `description` (String)

### Config & Dependencies

#### `lib/main.dart` (Update)
**Lokasi Perubahan:**
- Baris 17-25: Registrasi adapter Hive (6 adapters)
- Baris 27-31: Inisialisasi Supabase dengan URL & key
- Baris 33: Init `ThemeService`

#### `pubspec.yaml` (Update)
**Dependencies ditambahkan:**
```yaml
geolocator: ^9.0.2       # GPS tracking
flutter_map: ^6.0.0      # Peta OpenStreetMap
latlong2: ^0.9.1         # Format koordinat
image_picker: ^1.0.7     # Upload gambar
```

#### `android/app/src/main/AndroidManifest.xml` (Update)
**Permission ditambahkan:**
```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.INTERNET" />
```

---

## 🎯 Status Fitur Modul 5

| # | Fitur | Status | Lokasi |
|----|-------|--------|--------|
| 1 | Tracking GPS Real-time | ✅ LENGKAP | `location_controller.dart` |
| 2 | Perbandingan GPS vs Network | ✅ LENGKAP | `location_experiment_page.dart` L:25-40 |
| 3 | Peta OpenStreetMap | ✅ LENGKAP | `location_experiment_page.dart` L:45-85 |
| 4 | Upload Gambar ke Supabase | ✅ LENGKAP | `supabase_service.dart` L:12-45 |
| 5 | Preview Gambar | ✅ LENGKAP | `atur_harga_page.dart` L:100-135 |
| 6 | Cuaca Real-time GPS | ✅ LENGKAP | `delivery_controller.dart` L:74-120 |
| 7 | Peta di Delivery Screen | ✅ LENGKAP | `delivery_screen.dart` L:40-85 |
| 8 | Prakiraan Cuaca | ✅ LENGKAP | `delivery_screen.dart` L:155-230 |
| 9 | Multi-Select Layanan | ✅ LENGKAP | `add_order_page.dart` L:80-220 |
| 10 | Dark Mode Support | ✅ LENGKAP | `home_screen.dart` L:48-55 |

---

## ✅ Checklist Implementasi

- [x] Buat LocationController dengan GPS tracking
- [x] Buat LocationExperimentPage dengan peta & toggle mode
- [x] Update HomeScreen dengan menu "Lokasi & Peta"
- [x] Fix upload gambar dengan `uploadBinary()`
- [x] Update AturHargaPage dengan preview gambar
- [x] Update DeliveryController dengan GPS cuaca
- [x] Update DeliveryScreen dengan peta & forecast
- [x] Implementasi multi-select layanan di AddOrderPage
- [x] Support dark mode di semua UI
- [x] Registrasi Hive adapters di main.dart
- [x] Update AndroidManifest dengan GPS permissions

---

## 📊 Teknologi yang Digunakan

- **Location:** Geolocator (GPS/Network)
- **Maps:** Flutter Map + OpenStreetMap
- **Weather API:** Open-Meteo (free, no API key)
- **Storage:** Supabase Storage (bucket: gambar_layanan)
- **Local DB:** Hive (caching)
- **State:** GetX (Obx, GetView, GetxController)
- **UI:** Material 3, Dark Mode

---

## 🚀 Hasil Akhir

Aplikasi Laundry3B sekarang memiliki:
- ✅ Tracking kurir real-time dengan peta interaktif
- ✅ Perbandingan akurasi GPS vs Network untuk eksperimen
- ✅ Upload gambar layanan dengan preview
- ✅ Cuaca real-time berdasarkan lokasi GPS kurir
- ✅ Pemilihan multiple layanan saat tambah order
- ✅ UI yang responsif dan mendukung dark mode

**Status Modul 5: SELESAI 100%** ✅

