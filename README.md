# Modul 5: Location-Aware Feature

## 📋 Ringkasan Penambahan

Modul 5 menambahkan fitur **pelacakan lokasi real-time** dengan perbandingan akurasi GPS vs Network pada aplikasi Laundry3B.

---

## 📁 File & Folder yang Ditambahkan

### 1. **lib/controllers/location_controller.dart** (Baru)
**Lokasi:** `lib/controllers/`

**Fungsi:** 
- Mengelola data lokasi (latitude, longitude, accuracy)
- Toggle mode GPS (High Accuracy) vs Network (Low Accuracy)
- Streaming lokasi real-time menggunakan `Geolocator`
- Handling permission dan error

**Variabel Utama:**
- `latitude` & `longitude` - Koordinat real-time
- `accuracy` - Tingkat akurasi (meter)
- `isGpsMode` - Mode GPS on/off
- `isTracking` - Status tracking aktif/tidak

---

### 2. **lib/pages/location_experiment_page.dart** (Baru)
**Lokasi:** `lib/pages/`

**Fungsi:**
- Menampilkan **peta OpenStreetMap** dengan Flutter Map
- Menampilkan **marker lokasi user** yang bergerak real-time
- Panel kontrol untuk toggle mode dan tracking
- Menampilkan data akurasi untuk laporan eksperimen

**UI Terdiri dari:**
- **Bagian Atas (60%):** Peta dengan marker lokasi
- **Bagian Bawah (40%):** Data real-time + tombol kontrol

---

### 3. **pubspec.yaml** (Update)
**Lokasi:** Root project

**Dependensi Ditambahkan:**
```yaml
geolocator: ^9.0.2        # Akses GPS/Network lokasi
flutter_map: ^6.0.0       # Menampilkan peta
latlong2: ^0.9.1          # Format koordinat
```

---

### 4. **android/app/src/main/AndroidManifest.xml** (Update)
**Lokasi:** `android/app/src/main/`

**Permission Ditambahkan:**
```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.INTERNET" />
```

Izin ini diperlukan untuk akses lokasi dan menampilkan peta online.

---

### 5. **lib/home_screen.dart** (Update)
**Lokasi:** `lib/`

**Perubahan:**
- Menambah menu grid baru: **"Lokasi & Peta"**
- Icon: `Icons.map`
- Warna: Orange
- Navigasi ke `LocationExperimentPage`
- Inject `LocationController` saat tombol ditekan

---

## 🎯 Cara Kerja Fitur

1. **User membuka menu "Lokasi & Peta"** → Masuk ke `LocationExperimentPage`
2. **Aplikasi mendapat lokasi awal** → Peta centered ke lokasi user
3. **User klik "Mulai Tracking"** → Streaming lokasi real-time dimulai
4. **Mode dapat diubah:**
   - **GPS Mode (High):** Akurasi lebih tinggi, konsumsi battery besar
   - **Network Mode (Low):** Akurasi lebih rendah, battery hemat
5. **Data akurasi dicatat** → Untuk laporan eksperimen indoor vs outdoor

---

## 📊 Struktur File Proyek

