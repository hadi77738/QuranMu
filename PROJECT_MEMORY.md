# PROJECT MEMORY & LIVING STATE

> [!IMPORTANT]
> **PERINGATAN UNTUK AI:**
> File ini adalah **Otak Memori Eksternal Proyek**.
> Baca file ini di awal sesi untuk memulihkan konteks.
> **WAJIB PERBARUI** file ini setiap kali ada perubahan stack, penyelesaian fitur, penemuan bug, atau percobaan bug yang gagal!

---

## 📌 1. IDENTITAS & TUJUAN PROYEK

* **Nama Proyek:** QuranMu (Q besar, M besar)
* **Application ID / Package Identifier:** `com.quranmu.pacman`
* **Tujuan Utama:** Aplikasi Android Islami (Offline-first) untuk membaca Al-Qur'an (Mushaf & Terjemahan+Tafsir), fitur Murottal Audio, jadwal sholat, adzan, ayat hari ini rotasi 8 jam, dan widget homescreen 4x2.
* **Target Pengguna:** Mobile users (Android)
* **Repository / Lingkungan:** Lokal

---

## 🔒 2. LOCKED TECH STACK & DEPENDENCIES

> AI dilarang mengganti framework, styling library, atau package manager yang ada di sini tanpa persetujuan pengguna!

| Kategori | Teknologi / Library | Versi | Catatan Khusus |
| :--- | :--- | :--- | :--- |
| **Bahasa / Runtime** | Dart | 3.13.2 | SDK ^3.13.2 |
| **Framework Utama** | Flutter | 3.47.2 | Target Android (NDK 28.2.13676358) |
| **Build Tool** | Flutter CLI / Gradle 9.3.1 | AGP 9.1.0 | Desugaring enabled (desugar_jdk_libs 2.1.5) |
| **Styling Engine** | Flutter Material 3 | - | Tema Hijau Zamrud (#00BFA5) & Emas (#FFD54F) |
| **State Management** | Riverpod (`flutter_riverpod`) | ^3.4.3 | ProviderScope di main.dart |
| **Routing / Navigasi** | GoRouter (`go_router`) | ^18.0.1 | ShellRoute dengan Bottom Navigation Bar |
| **Database / Storage** | SharedPreferences (`shared_preferences`) | ^2.5.5 | Penyimpanan konfigurasi & bookmark |
| **Audio Player** | Just Audio (`just_audio`) | ^0.10.6 | Pemutar murottal audio offline/online |
| **HTTP Client** | Dio (`dio`) | ^5.11.1 | Download surah & koneksi API |
| **Lokasi & Notifikasi** | Geolocator (^14.0.3) & Notifications (^22.3.1) | Latest | Jadwal sholat & notifikasi adzan |
| **Geocoding Wilayah** | Geocoding (`geocoding`) | ^5.0.0 | Resolusi nama kecamatan & kabupaten otomatis |
| **Sensor Kompas** | Flutter Compass (`flutter_compass`) | ^0.8.1 | Sensor magnetometer arah kiblat real-time |
| **Testing Tool** | Flutter Test | SDK | Smoke & unit test passing (7/7) |

### Pustaka & Plugin Tambahan Penting:
* `cupertino_icons` (^1.0.9): Ikon pendukung iOS style
* `path_provider` (^2.1.6): Akses direktori penyimpanan lokal perangkat
* `flutter_lints` (^6.0.0): Standar linter resmi Flutter
* `flutter_compass` (^0.8.1): Streaming heading kompas magnetometer
* `geocoding` (^5.0.0): Menerjemahkan koordinat GPS ke nama distrik/kabupaten (Tanggungharjo, Grobogan, dll)

---

## 📁 3. ARSITEKTUR & DIRECTORY MAP

> Peta navigasi folder penting agar AI di sesi berikutnya langsung tahu lokasi file tanpa mencari-cari ulang.

```
/
├── lib/
│   ├── components/      # Komponen UI reusable (buttons, cards, etc)
│   ├── pages/           # Layar utama (main_layout.dart, home_page.dart, quran_page.dart, settings_page.dart)
│   ├── services/        # Audio Player, API, Download Manager, Local Storage
│   ├── utils/           # Helper fungsi, formatter, konstanta
│   ├── theme/           # Konfigurasi tema warna & typography
│   └── main.dart        # Entry point & konfigurasi GoRouter + ProviderScope
├── test/
│   └── widget_test.dart # Smoke testing aplikasi
└── assets/              # Aset statis (fonts Arab/Latin, data JSON Al-Qur'an lokal)
```

### File-File Kritis (Core Files):
* `lib/main.dart` (Entry point aplikasi & konfigurasi route)
* `lib/pages/main_layout.dart` (Kerangka Bottom Navigation Bar 3 Tab)
* `lib/pages/home_page.dart` (Tampilan Beranda lengkap dengan kartu Ayat, Sholat, Menu)
* `pubspec.yaml` (Manajemen dependensi)
* `android/app/build.gradle.kts` (Konfigurasi NDK & Core Library Desugaring)

---

## 📋 4. PANTANGAN & ATURAN KHUSUS (DO'S & DON'TS)

* ✅ **DO:** Gunakan format markdown link GitHub dengan skema `file://` saat merujuk file proyek.
* ✅ **DO:** Gunakan `.withValues(alpha: ...)` pengganti `.withOpacity(...)` untuk kompatibilitas Flutter 3.47+.
* ✅ **DO:** Pastikan desugaring tetap aktif di `build.gradle.kts` untuk dependensi notifikasi.
* ❌ **DON'T:** Jangan mengubah versi NDK tanpa memeriksa direktori NDK lokal yang terpasang di `D:\Android\ndk`.
* ❌ **DON'T:** Jangan mengganti dependensi inti tanpa verifikasi kompatibilitas resolver Flutter.

---

## 🚦 5. STATUS AKTIF & ROADMAP PENGERJAAN

* **Status Saat Ini:** Tahap 4 Modul Pengaturan Komprehensif, Doa Harian & Dzikir Offline, Pemutar Murottal Cepat, dan Persistent Mini Audio Bar telah selesai dan terverifikasi penuh (7/7 tests passing, 0 analyzer issues).
* **Terakhir Dikerjakan:** 
  * [x] Audit dan update versi plugin ke rilis terbaru pub.dev (`cupertino_icons: ^1.0.9`, riverpod 3.4.3, go_router 18.0.1, dll)
  * [x] Perbaikan issue cold-start Android splash screen (mengganti blank putih default dengan brand emerald green & centered app icon)
  * [x] Redesign UI/UX Beranda (`lib/pages/home_page.dart`): hero gradient prayer card, live countdown, 5 symmetrical prayer capsules, 4 symmetrical feature grid
  * [x] Tahap 1 Al-Qur'an: Dataset offline lengkap 114 Surah, model Surah & Juz, service provider Riverpod 3, antarmuka Tab Surah & Juz di `lib/pages/quran_page.dart`
  * [x] Tahap 2 Al-Qur'an: Model `Ayat`, `SurahDetail`, dan `TafsirAyat`
  * [x] Pre-bundle aset lokal surah populer (Surah 1, 112, 113, 114) dan mekanisme caching offline disk via Dio + `path_provider`
  * [x] Audio service berbasis `just_audio` (`lib/services/audio_service.dart`) dengan mini-player bar
  * [x] Halaman Baca Al-Qur'an (`lib/pages/surah_detail_page.dart`):
    * Mode 1: Ayat + Terjemahan Indonesia + Transliterasi Latin + Aksi Ayat (Audio, Tafsir, Copy, Bookmark)
    * Mode 2: Mushaf Arab Murni (aliran kaligrafi berkesinambungan layaknya mushaf cetak)
    * Bottom sheet Tafsir lengkap Kemenag RI per ayat
  * [x] Tahap 3 Jadwal Sholat & Arah Kiblat:
    * Engine hisab astronomis offline akurat (`lib/services/prayer_service.dart`) dengan penyesuaian ikhtiyat Kemenag RI (+2 menit) untuk Subuh, Syuruq/Terbit, Dzuhur, Ashar, Maghrib, Isya.
    * Rumus trigonometri bola (spherical trigonometry) perhitungan sudut Kiblat Ka'bah Makkah.
    * Deteksi GPS real-time via `geolocator` dengan fallback ke koordinat Jakarta.
    * Service notifikasi pengingat waktu sholat (`lib/services/notification_service.dart`) via `flutter_local_notifications` dengan konfigurasi Android Notification Channel.
    * Halaman Kompas Arah Kiblat interaktif (`lib/pages/qibla_page.dart`) berdesain visual dial kompas, kartu derajat kiblat, info koordinat, dan tombol kalibrasi GPS.
    * Integrasi navigasi GoRouter `/qibla` dan tombol cepat 'Arah Kiblat' di Beranda.
    * Provider stream live waktu sholat & countdown real-time di kartu beranda.
  * [x] Tahap 4 Pengaturan, Doa Harian, & Audio Murottal:
    * State Management `settingsProvider` (`lib/services/settings_service.dart`) dengan SharedPreferences persistence.
    * Slider ukuran font Arab (18–36pt) dan font terjemahan (12–20pt) dengan live preview langsung terhubung ke halaman baca Al-Qur'an.
    * Pilihan Qari Murottal (Misyari Rasyid Al-Afasy, Abdullah Al-Juhany, Abdul Muhsin Al-Qasim, Abdurrahman As-Sudais, Ibrahim Al-Dossari).
    * Notifikasi jadwal sholat on/off master switch dan per-waktu sholat (Subuh, Dzuhur, Ashar, Maghrib, Isya), serta tombol tes notifikasi adzan langsung.
    * Modul Doa Harian & Dzikir (`lib/data/doa_data.dart` & `lib/pages/doa_page.dart`) lengkap dengan teks Arab, Latin, arti, hadits riwayat shahih, fitur pencarian instan, dan filter kategori.
    * Sheet Pemutar Murottal Cepat di Beranda untuk memutar surah-surah populer seketika.
    * Persistent `MiniAudioPlayer` bar (`lib/components/mini_audio_player.dart`) di `MainLayout` yang melayang di atas Bottom Navigation Bar dan aktif di semua tab.
  * [x] Widget testing (`widget_test.dart`) 7/7 passed & `flutter analyze` 0 issues
* **Todo Selanjutnya (Tahap 5):**
  * [ ] Dark Theme Mode toggle dan implementasi skema warna malam yang nyaman di mata
  * [ ] Export APK release / testing build validation
---

## 🐞 6. BUG TRACKER & FAILED ATTEMPTS LEDGER

### Known Issues (Terselesaikan):
* [x] **Issue #1:** `flutter_local_notifications` membutuhkan `desugar_jdk_libs` versi >= 2.1.4.
  * *File terkait:* `android/app/build.gradle.kts`
  * *Solusi:* Ditambahkan `coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")` dan `isCoreLibraryDesugaringEnabled = true`.
* [x] **Issue #2:** Layar blank putih lama saat aplikasi dibuka pada cold-start.
  * *File terkait:* `android/app/src/main/res/drawable/launch_background.xml`, `android/app/src/main/res/values/styles.xml`, `lib/main.dart`
  * *Solusi:* Konfigurasi Android 12+ SplashScreen dan Android LaunchTheme dengan warna brand hijau zamrud `#0B3B2C` serta ikon aplikasi, dan inisialisasi awal binding di `main.dart`.

### Failed Attempts Ledger:
| ID Bug | Solusi yang Pernah Dicoba | Hasil / Mengapa Gagal | Tanggal |
| :--- | :--- | :--- | :--- |
| NDK-1 | Menetapkan ndkVersion ke versi r28c default | Download NDK Gradle lambat karena kendala koneksi | 2026-09-14 |

---

## 📜 7. RIWAYAT HANDOVER SESI (SESSION LOG)

* **2026-09-14:** Tahap 2 Modul Al-Qur'an selesai: Implementasi Halaman Baca Ayat (`lib/pages/surah_detail_page.dart`) dengan dukungan 2 mode baca (Mode Terjemahan per ayat & Mode Mushaf Arab murni), bottom sheet tafsir Kemenag RI, pemutar audio murottal berbasis `just_audio`, persistensi penanda terakhir dibaca ke `shared_preferences`, dan integrasi routing GoRouter. Tes unit suite 3/3 lulus dan analisis statis bersih (0 warning/error).
* **2026-09-14:** Tahap 3 Jadwal Sholat Dinamis & Kompas Kiblat selesai: Implementasi hisab astronomis offline standar Kemenag RI (`lib/services/prayer_service.dart`), integrasi GPS `geolocator`, kalkulasi sudut bearing Kiblat Makkah, notifikasi pengingat sholat (`lib/services/notification_service.dart`), halaman kompas Kiblat (`lib/pages/qibla_page.dart`), integrasi tombol cepat dan kartu dinamis di beranda, serta penambahan unit test dan widget test komprehensif (5/5 tests passing, 0 analyzer issues).
* **2026-09-14:** Tahap 4 Modul Pengaturan, Doa Harian & Murottal selesai: Implementasi `settingsProvider` dengan SharedPreferences (`lib/services/settings_service.dart`), Halaman Pengaturan lengkap (`lib/pages/settings_page.dart`) dengan live slider font Arab & Terjemahan, selector Qari favorit, toggle notifikasi sholat & tes alarm adzan, Modul Doa & Dzikir offline (`lib/data/doa_data.dart` & `lib/pages/doa_page.dart`) dengan pencarian & filter, sheet murottal cepat di beranda, dan persistent `MiniAudioPlayer` (`lib/components/mini_audio_player.dart`) di `MainLayout`. Semua pengujian lulus (7/7 tests passed) dan analisis statis 0 issues.
* **2026-09-14:** Revisi Halaman Utama & Kompas Kiblat:
  * Memperbaiki deteksi lokasi dinamis perangkat: menambahkan `userLocationProvider` yang otomatis mendeteksi koordinat GPS riil perangkat secara berkala dan menerjemahkannya ke nama wilayah (misal: "Tanggungharjo, Grobogan") via `geocoding` Android Geocoder (tanpa API key).
  * Menambahkan tombol interaktif pembaruan GPS langsung pada kartu jadwal sholat Beranda (`lib/pages/home_page.dart`), sehingga jadwal sholat langsung otomatis terhitung ulang di manapun pengguna bepergian.
  * Memperbaiki kompas arah kiblat (`lib/pages/qibla_page.dart`) dengan integrasi sensor magnetometer fisik via `flutter_compass`. Kompas berputar secara dinamis mengikuti arah fisik perangkat, dilengkapi indikator keselarasan Ka'bah, status warna hijau zamrud saat tepat menghadap kiblat (toleransi ±3°), dan respon haptic feedback.
  * Seluruh pengujian passing 7/7 dan analisis kode 0 issues.
* **2026-09-15:** Revisi Font Arab, Format Mushaf Standar Indonesia & Mode Lanskap, Navigasi Back Navbar, Player Murottal Interaktif, dan Kustomisasi Suara Adzan:
  * [x] **Font Arab Asli & Eliminasi Bug Kotak (Tofu):** Mem-bundle font Arab otentik `Amiri-Regular.ttf` & `Amiri-Bold.ttf` ke `assets/fonts/` dan `pubspec.yaml`, membersihkan karakter pemisah/waqaf `\u08D6` / `ࣖ` yang menyebabkan glyph kotak tidak terbaca di "Ayat Hari Ini" dan teks ayat surah.
  * [x] **Susunan Mushaf Standar Indonesia & Mode Lanskap:**
    * Menyusun tampilan Mushaf Arab Murni (`_buildMushafMode`) mengikuti kaidah Mushaf Standar Indonesia (Kemenag/Kudus): bingkai ganda (emas #C89737 dan hijau zamrud #0D6E55), latar perkamen krem `#FDFBF5`, kepala surah berpola ornamen kaligrafi dengan detail makkiyyah/madaniyyah, ornamen bismillah islami, garis-garis penuntun baca horizontal ("Mushaf Bergaris" via `MushafRuledLinesPainter`), medali penanda ayat berbentuk lingkaran bunga emas dengan angka Arab timbul, dan baris "Ayat Pojok" di kaki halaman.
    * Menambahkan tombol toggle Mode Lanskap / Potret di AppBar dengan `SystemChrome.setPreferredOrientations` dan auto-restore saat dispose.
  * [x] **Navigasi Tombol Back Android di Navbar:** Mengimplementasikan `PopScope` di `lib/pages/main_layout.dart` sehingga saat pengguna menekan tombol kembali Android di Tab Al-Qur'an (`/quran`) atau Tab Pengaturan (`/settings`), aplikasi kembali ke Beranda (`/`) dan tidak langsung keluar dari aplikasi.
  * [x] **Upgrade Pemutar Audio Murottal Interaktif:**
    * Meng-upgrade `MiniAudioPlayer` (`lib/components/mini_audio_player.dart`) menjadi audio player interaktif: bilah progress garis atas, modal lembar player yang dapat dibuka dengan sentuhan (expandable sheet), slider seek interaktif untuk menggeser ke menit/detik berapa pun, timestamp dinamis (`00:00 / 00:00`), tombol lompat mundur -10 detik dan lompat maju +10 detik via `seekRelative`, dan pilihan kecepatan putar (0.75x, 1.0x, 1.25x, 1.5x).
  * [x] **Kustomisasi Suara Adzan Asli & Pilihan Gaya Adzan:**
    * Menyertakan file audio adzan asli (`adzan_makkah.mp3`, `adzan_madinah.mp3`, `adzan_mesir.mp3`) di `android/app/src/main/res/raw/` dan `assets/audio/`.
    * Memperbarui `NotificationService` dengan kanal khusus adzan Android untuk memainkan audio adzan asli (`RawResourceAndroidNotificationSound`).
    * Memperbarui `AppSettings` dan `SettingsPage` dengan dropdown pilihan gaya adzan (Adzan Makkah, Adzan Madinah, Adzan Mesir, Suara Bawaan Sistem), tombol pratinjau putar/stop suara adzan langsung di pengaturan, dan tombol tes notifikasi adzan.
  * [x] Seluruh suite pengujian otomatis lulus (8/8 tests passed) dan `flutter analyze` bersih (0 issues).
* **2026-09-15 (Revisi Lanjutan):** Tap-to-Play Ayat Mode Mushaf & Perbaikan Bug Dual Player Bar:
  * [x] **Tap-to-Play Ayat Mode Mushaf:**
    * Di [lib/pages/surah_detail_page.dart](file:///c:/web/QuranMu/lib/pages/surah_detail_page.dart), teks ayat Arab (`TextSpan`) dan medali nomor ayat (`WidgetSpan`) kini langsung memutar audio ayat tersebut saat disentuh (`TapGestureRecognizer`), lengkap dengan snackbar konfirmasi nama qari.
    * Menambahkan visual highlight real-time saat ayat sedang berputar (latar teks hijau tosca transparan dan medali aktif berkedip zamrud).
    * Sentuhan panjang (long-press) pada medali tetap membuka modal opsi (Buka Tafsir & Tandai Baca), serta kini tersedia tombol aksi 'Putar Audio' di dalam modal.
  * [x] **Eliminasi Bug Dua Player Bar:**
    * Menghapus bar audio usang `_buildAudioBar` di [lib/pages/surah_detail_page.dart](file:///c:/web/QuranMu/lib/pages/surah_detail_page.dart).
    * Di [lib/pages/main_layout.dart](file:///c:/web/QuranMu/lib/pages/main_layout.dart), menyempurnakan `bottomNavigationBar` sehingga pada sub-halaman bacaan (`/quran/:id`, `/qibla`, `/doa`), navigasi tab disembunyikan dan hanya menampilkan satu `MiniAudioPlayer` interaktif global. Tidak ada lagi dua bar player bertumpuk.
    * Tombol back Android di sub-halaman kini mem-pop kembali ke halaman sebelumnya secara alami (`canPop: !isMainTab`).
  * [x] Verifikasi: `flutter analyze` 0 issues, `flutter test` 8/8 test suites passed.
* **2026-09-15 (Pembaruan Identitas, Ikon Konsep 3, Splash Screen, Widget 4x2, & Izin Lengkap):**
  * [x] **Ikon Aplikasi Konsep 3:** Mengimplementasikan ikon Konsep 3 (geometric flat Quran dengan bulan sabit & kubah minimalis) ke seluruh density Android: `mipmap-mdpi` (48px), `mipmap-hdpi` (72px), `mipmap-xhdpi` (96px), `mipmap-xxhdpi` (144px), `mipmap-xxxhdpi` (192px), serta splash icon (256px).
  * [x] **Redesign Splash Screen:** Mengganti latar splash screen dari hijau tua ke warna putih semi hijau (`#F4F9F6`) di [colors.xml](file:///c:/web/QuranMu/android/app/src/main/res/values/colors.xml), [styles.xml](file:///c:/web/QuranMu/android/app/src/main/res/values/styles.xml), dan [launch_background.xml](file:///c:/web/QuranMu/android/app/src/main/res/drawable/launch_background.xml), dengan ikon Konsep 3 di tengah.
  * [x] **Perubahan Nama & Package Identifier:**
    * Nama tampilan aplikasi: `QuranMu` (Q besar, M besar) di [AndroidManifest.xml](file:///c:/web/QuranMu/android/app/src/main/AndroidManifest.xml) dan [strings.xml](file:///c:/web/QuranMu/android/app/src/main/res/values/strings.xml).
    * Identifier paket: `com.quranmu.pacman` dikonfigurasi di [build.gradle.kts](file:///c:/web/QuranMu/android/app/build.gradle.kts) (`namespace` & `applicationId`) dan [MainActivity.kt](file:///c:/web/QuranMu/android/app/src/main/kotlin/com/quranmu/pacman/MainActivity.kt).
  * [x] **Perizinan Lengkap AndroidManifest Siap Build:**
    * Lokasi (`ACCESS_FINE_LOCATION`, `ACCESS_COARSE_LOCATION`)
    * Notifikasi & Alarm (`POST_NOTIFICATIONS`, `SCHEDULE_EXACT_ALARM`, `USE_EXACT_ALARM`, `RECEIVE_BOOT_COMPLETED`, `VIBRATE`)
    * Layanan Latar Belakang & Media (`WAKE_LOCK`, `FOREGROUND_SERVICE`, `FOREGROUND_SERVICE_MEDIA_PLAYBACK`, `REQUEST_IGNORE_BATTERY_OPTIMIZATIONS`)
    * Penyimpanan (`READ_EXTERNAL_STORAGE`, `WRITE_EXTERNAL_STORAGE`)
    * Internet & Jaringan (`INTERNET`, `ACCESS_NETWORK_STATE`)
  * [x] **Ayat Hari Ini Rotasi Otomatis Setiap 8 Jam:**
    * Dataset & fungsi rotasi waktu 8 jam (00:00–08:00, 08:00–16:00, 16:00–24:00) di [lib/data/daily_verses_data.dart](file:///c:/web/QuranMu/lib/data/daily_verses_data.dart).
    * Terintegrasi mulus di beranda [lib/pages/home_page.dart](file:///c:/web/QuranMu/lib/pages/home_page.dart) dengan label periode waktu, tombol salin, bookmark, dan navigasi langsung ke surah terkait.
  * [x] **Android Home Screen Widget 4x2 (Ayat Hari Ini):**
    * Konfigurasi AppWidget 4x2 di [android/app/src/main/res/xml/ayat_widget_info.xml](file:///c:/web/QuranMu/android/app/src/main/res/xml/ayat_widget_info.xml) (`targetCellWidth="4"`, `targetCellHeight="2"`, `minWidth="250dp"`, `minHeight="110dp"`).
    * Tampilan kartu responsif di [android/app/src/main/res/layout/ayat_widget_layout.xml](file:///c:/web/QuranMu/android/app/src/main/res/layout/ayat_widget_layout.xml) dengan latar putih semi hijau, logo QuranMu, badge rujukan surah, teks Arab, terjemahan Indonesia, dan info periode waktu 8 jam.
    * Kotlin provider [AyatWidgetProvider.kt](file:///c:/web/QuranMu/android/app/src/main/kotlin/com/quranmu/pacman/AyatWidgetProvider.kt) yang menyinkronkan ayat sesuai periode waktu 8 jam dan aksi klik untuk membuka aplikasi (`PendingIntent`).
    * Terdaftar resmi sebagai `<receiver>` di [AndroidManifest.xml](file:///c:/web/QuranMu/android/app/src/main/AndroidManifest.xml).
  * [x] **Verifikasi Kualitas:** `flutter analyze` 0 issues, `flutter test` 8/8 passing.
* **2026-09-15 (Rombak Total Splash Screen Uncropped & Sinkronisasi Widget 4x2 60 Ayat Se-Al-Qur'an):**
  * [x] **Rombak Splash Screen (Putih Agak Hijau + Medallion Anti-Crop):**
    * *Root Cause:* Android 12+ SplashScreen memotong icon ke dalam safe-zone lingkaran (masking ~66% dari kanvas). Akibatnya lingkaran medallion yang berukuran penuh terpotong di tepi atas/bawah/kiri/kanan sehingga tampak seperti terpotong siku/kotak.
    * *Solusi:*
      * Menghasilkan master circular medallion baru dalam kanvas 512x512 dengan diameter aman 344px (radius 172px) dan padding transparan 84px di sekelilingnya. Medallion memiliki lingkaran hijau zamrud `#074633`, cincin ganda emas murni `#DCB43C`, dan lambang Al-Qur'an emas proporsional di tengahnya.
      * Menyebarkan aset baru ke [res/drawable/splash_icon.png](file:///c:/web/QuranMu/android/app/src/main/res/drawable/splash_icon.png), [res/drawable-v21/splash_icon.png](file:///c:/web/QuranMu/android/app/src/main/res/drawable-v21/splash_icon.png), dan launcher icon [res/mipmap-*/ic_launcher.png](file:///c:/web/QuranMu/android/app/src/main/res/mipmap-hdpi/ic_launcher.png).
      * Mengubah warna background splash screen menjadi putih agak hijau (White Mint `#F4F9F6`) di [colors.xml](file:///c:/web/QuranMu/android/app/src/main/res/values/colors.xml) dan [styles.xml](file:///c:/web/QuranMu/android/app/src/main/res/values/styles.xml). Medallion kini mengambang elegan di atas latar putih kehijauan tanpa terpotong sama sekali.
  * [x] **Koleksi 60 Ayat Pilihan Se-Al-Qur'an & Sinkronisasi 100%:**
    * Menyusun dataset 60 ayat inspiratif standalone (1 ayat utuh per waktu) dari berbagai surah se-Al-Qur'an (Juz 1 s/d 30) lengkap dengan teks Arab bersih tanpa glitch kotak/tofu, transliterasi Latin, terjemahan Indonesia akurat, dan tema.
    * Mem-bundle dataset ke [android/app/src/main/res/raw/daily_verses.json](file:///c:/web/QuranMu/android/app/src/main/res/raw/daily_verses.json) (native Android), [assets/json/daily_verses.json](file:///c:/web/QuranMu/assets/json/daily_verses.json), dan [lib/data/daily_verses_data.dart](file:///c:/web/QuranMu/lib/data/daily_verses_data.dart).
    * Rumus penentuan ayat 8 jam di Flutter dan Android Kotlin dibuat identik: `(dayNumber * 3 + period) % totalVerses` (00:00–08:00, 08:00–16:00, 16:00–24:00). Beranda dan Homescreen Widget dijamin menampilkan 1 ayat utuh yang persis sama.
  * [x] **Rombak Widget Homescreen 4x2 Mantap & Centered Modern (Revisi Visual Pengguna):**
    * *Root Cause Area Kosong:* Semua komponen sebelumnya di-stack secara vertikal dari atas dengan `wrap_content`, menyisakan >50% ruang kosong putih di bawah kartu, dan font terlalu kecil (15sp Arab & 11.5sp Indo).
    * *Solusi:*
      * Menata ulang [ayat_widget_layout.xml](file:///c:/web/QuranMu/android/app/src/main/res/layout/ayat_widget_layout.xml) dengan `layout_weight="1"` dan `gravity="center"` pada kontainer konten tengah, sehingga teks ayat Arab dan terjemahan otomatis berada tepat di tengah vertikal dan horizontal kartu.
      * Teks Arab diperbesar menjadi **21sp Bold** (`#064E3B`) dengan line spacing 1.25x dan alignment centered.
      * Terjemahan diperbesar menjadi **13sp** (`#334155`) dengan line spacing 1.18x dan alignment centered.
      * Sudut kartu dimodernisasi menjadi rounded **24dp** di [widget_card_bg.xml](file:///c:/web/QuranMu/android/app/src/main/res/drawable/widget_card_bg.xml) agar serasi dengan widget modern Android / MIUI (seperti widget jam di atasnya).
      * Header tetap rapi di atas dan footer tetap proporsional di bawah kartu.
  * [x] **Verifikasi:** `flutter analyze` 0 issues, `flutter test` 8/8 test passed, `flutter build apk --debug` SUCCEEDED (build/app/outputs/flutter-apk/app-debug.apk).


