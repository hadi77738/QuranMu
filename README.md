# 📖 QuranMu (Al-Qur'an & Ibadah Harian)

<p align="center">
  <img src="android/app/src/main/res/drawable/splash_icon.png" width="128" height="128" alt="QuranMu Logo" />
</p>

<p align="center">
  <b>Aplikasi Al-Qur'an Android Modern, Offline-First, dan Ringan</b><br>
  Dilengkapi Mushaf Standar Indonesia, Audio Murottal Multi-Qari, Jadwal Sholat Kemenag, Kompas Kiblat Sensorik, Doa Harian, dan Android Homescreen Widget 4x2.
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.47.2-02569B?logo=flutter" alt="Flutter Version" />
  <img src="https://img.shields.io/badge/Dart-3.13.2-0175C2?logo=dart" alt="Dart Version" />
  <img src="https://img.shields.io/badge/Platform-Android-3DDC84?logo=android" alt="Platform" />
  <img src="https://img.shields.io/badge/Architecture-Riverpod%203-blueviolet" alt="State Management" />
  <img src="https://img.shields.io/badge/License-MIT-green" alt="License" />
</p>

---

## 🌟 Fitur Utama

### 1. 📖 Al-Qur'an 30 Juz & 114 Surah (Offline-First)
* **2 Pilihan Mode Baca:**
  * **Mode Terjemahan:** Ayat per ayat lengkap dengan teks Arab otentik (*font Amiri*), transliterasi Latin fonetik Indonesia, terjemahan resmi Kemenag RI, serta aksi cepat (salin teks, putar audio per ayat, buka tafsir, tandai bacaan).
  * **Mode Mushaf Arab Murni:** Aliran kaligrafi kontinu layaknya mushaf cetak standar Kemenag RI/Kudus, bingkai ornamen ganda zamrud-emas, medali nomor ayat islami, garis penuntun baca horizontal (*mushaf bergaris*), dan baris penutup halaman (*Ayat Pojok*).
* **Mode Lanskap / Potret:** Toggle rotasi layar otomatis dengan tampilan mushaf melebar yang nyaman di mata.
* **Tafsir Lengkap Kemenag RI:** Penjelasan tafsir mendalam per ayat via modal lembar geser (*bottom sheet*).
* **Kustomisasi Teks:** Pengaturan ukuran font Arab (18–36pt) dan terjemahan (12–20pt) dengan *live preview*.
* **Penanda Terakhir Dibaca:** Disimpan secara offline dan dapat dilanjutkan seketika dari beranda.

### 2. 🎧 Pemutar Murottal Interaktif & Persistent Mini-Player
* **Mini Audio Player Global:** Bar audio mengambang yang tetap aktif dan dapat dikontrol di semua tab navigasi.
* **Expandable Interactive Sheet:** Buka player layar penuh dengan sentuhan:
  * Slider penunjuk waktu (*seek bar*) menit dan detik.
  * Tombol lompat mundur -10 detik dan maju +10 detik.
  * Pilihan kecepatan putar audio (0.75x, 1.0x, 1.25x, 1.5x).
* **Tap-to-Play Mode Mushaf:** Cukup sentuh teks ayat atau medali nomornya untuk langsung memutar bacaan ayat tersebut, lengkap dengan highlight visual berwarna zamrud saat audio berputar.
* **5 Pilihan Qari Internasional:**
  * Syaikh Misyari Rasyid Al-Afasy
  * Syaikh Abdullah Al-Juhany
  * Syaikh Abdul Muhsin Al-Qasim
  * Syaikh Abdurrahman As-Sudais
  * Syaikh Ibrahim Al-Dossari

### 3. 🕌 Jadwal Sholat Presisi & Notifikasi Adzan
* **Engine Hisab Astronomis Offline:** Perhitungan hisab akurat dengan penyesuaian ikhtiyat Kemenag RI (+2 menit) untuk Subuh, Syuruq/Terbit, Dzuhur, Ashar, Maghrib, dan Isya.
* **Deteksi Lokasi GPS Otomatis:** Menentukan posisi riil perangkat dan menerjemahkannya ke nama kecamatan/kabupaten via Android Geocoder tanpa memerlukan API key eksternal.
* **Live Countdown:** Menghitung mundur waktu sholat berikutnya secara real-time di beranda.
* **Alarm Adzan Suara Asli:** Notifikasi pengingat sholat dengan pilihan audio adzan asli (Adzan Makkah, Adzan Madinah, Adzan Mesir, atau nada dering sistem bawaan).

### 4. 🧭 Kompas Arah Kiblat Real-Time
* Menggunakan sensor magnetometer fisik perangkat (`flutter_compass`).
* Jarum kompas dan derajat berputar halus secara real-time mengikuti pergerakan fisik HP.
* Dilengkapi indikator keselarasan Ka'bah, status dial berubah hijau zamrud saat tepat menghadap kiblat (toleransi ±3°), dan getaran haptic feedback.

### 5. 🤲 Doa Harian & Dzikir Offline
* Kumpulan doa ma'tsur dan dzikir harian lengkap dengan teks Arab, transliterasi Latin, terjemahan, dan hadits rujukan shahih.
* Fitur pencarian instan dan filter kategori doa.

### 6. 📱 Android Homescreen Widget 4x2 (Ayat Pilihan 8 Jam)
* Widget native Android modern dengan sudut lengkung 24dp (*Material You / Modern launcher friendly*).
* **Rotasi Otomatis Tiap 8 Jam:** Berganti pada pukul 00:00, 08:00, dan 16:00 dari koleksi 60 ayat pilihan inspiratif se-Al-Qur'an.
* **100% Sinkron dengan Beranda:** Beranda aplikasi dan widget homescreen selalu menampilkan 1 ayat utuh yang persis sama.
* Tampilan terpusat (*centered alignment*), teks Arab 21sp bold, terjemahan 13sp, tidak terpotong, dan dapat langsung diketuk untuk membuka surah terkait di aplikasi.

---

## 🛠️ Tech Stack & Arsitektur

| Kategori | Teknologi | Deskripsi |
| :--- | :--- | :--- |
| **Framework** | Flutter 3.47.2 / Dart 3.13.2 | Multiplatform Mobile SDK |
| **State Management** | `flutter_riverpod` ^3.4.3 | Reactive & modular state |
| **Navigasi** | `go_router` ^18.0.1 | Declarative routing & deep-linking |
| **Audio Engine** | `just_audio` ^0.10.6 | Background audio streaming & offline cache |
| **Penyimpanan Lokal** | `shared_preferences` ^2.5.5 | Konfigurasi pengguna & penanda bacaan |
| **Networking & Cache** | `dio` ^5.11.1 & `path_provider` | Download surah & audio buffering |
| **Lokasi & Geocoder** | `geolocator` ^14.0.3 & `geocoding` ^5.0.0 | Deteksi koordinat GPS dan resolusi nama wilayah |
| **Sensor Kompas** | `flutter_compass` ^0.8.1 | Sensor magnetometer arah kiblat |
| **Notifikasi & Alarm** | `flutter_local_notifications` ^22.3.1 | Alarm adzan & notifikasi sholat terjadwal |
| **Android Integration** | Kotlin / RemoteViews / AGP 9.1.0 | AppWidget 4x2 & splash screen API Android 12+ |

---

## 📁 Struktur Folder Proyek

```
QuranMu/
├── android/                 # Proyek native Android (Widget, Splash, Res, Manifest)
│   └── app/src/main/
│       ├── kotlin/          # AyatWidgetProvider.kt & MainActivity.kt
│       └── res/             # Layout widget 4x2, drawable splash, audio raw adzan
├── assets/                  # Aset statis aplikasi
│   ├── audio/               # File audio MP3 adzan
│   ├── fonts/               # Font Arab otentik (Amiri-Regular & Amiri-Bold)
│   └── json/                # Dataset 114 Surah offline & 60 daily verses
├── lib/
│   ├── components/          # Komponen UI (MiniAudioPlayer, BottomSheet, Cards)
│   ├── data/                # Dataset doa harian & ayat rotasi 8 jam
│   ├── models/              # Data model (Surah, Ayat, Tafsir, Doa, UserLocation)
│   ├── pages/               # Layar utama (Beranda, Al-Qur'an, Detail, Kiblat, Doa, Pengaturan)
│   ├── services/            # AudioService, PrayerService, NotificationService, QuranService
│   ├── theme/               # Palet tema Material 3 Hijau Zamrud & Emas
│   └── main.dart            # Entry point aplikasi & inisialisasi route
└── test/                    # Suite pengujian widget & unit test
```

---

## 🚀 Panduan Memulai (Getting Started)

### Prasyarat:
* [Flutter SDK](https://docs.flutter.dev/get-started/install) versi `>= 3.47.0`
* [Android SDK](https://developer.android.com/studio) dengan NDK yang terpasang
* [Git](https://git-scm.com/)

### Langkah Instalasi:

1. **Clone Repositori:**
   ```bash
   git clone https://github.com/hadi77738/QuranMu.git
   cd QuranMu
   ```

2. **Pasang Dependensi:**
   ```bash
   flutter pub get
   ```

3. **Jalankan Uji Tes Otomatis:**
   ```bash
   flutter test
   ```

4. **Jalankan di Perangkat Android:**
   ```bash
   flutter run
   ```

5. **Build APK Release:**
   ```bash
   flutter build apk --release
   ```
   *File APK release akan tersedia di:* `build/app/outputs/flutter-apk/app-release.apk`

---

## 📄 Lisensi
Proyek ini didistribusikan di bawah lisensi [MIT License](LICENSE).

---

<p align="center">
  Dibuat dengan dedikasi untuk memudahkan interaksi dengan Al-Qur'an setiap hari. ✨
</p>
