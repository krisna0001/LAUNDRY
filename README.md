## UPDATE

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
### API YANG DI GUNAKAN
#### Open-Meteo API
- Kegunaan: Mengambil data cuaca real-time (suhu, kelembaban, kecepatan angin) dan prakiraan cuaca tanpa memerlukan API Key.
  Lokasi Kode: lib/controllers/delivery_controller.dart.

#### NewsAPI
  Kegunaan: Mengambil berita terkini yang relevan dengan lokasi pengguna saat ini (berdasarkan nama lokasi yang didapat dari GPS).
  Lokasi Kode: lib/controllers/delivery_controller.dart.

#### Nominatim API (OpenStreetMap)

- Kegunaan: Melakukan reverse geocoding, yaitu mengubah koordinat GPS (latitude & longitude) menjadi nama lokasi atau alamat yang bisa dibaca manusia (kota, kecamatan, desa). 
  Lokasi Kode: lib/controllers/delivery_controller.dart.

#### OpenStreetMap Tile API

- Kegunaan: Menyediakan gambar peta (tiles) untuk ditampilkan di layar menggunakan widget FlutterMap. 
  Lokasi Kode: lib/screens/delivery_screen.dart, lib/pages/location_experiment_page.dart.

---