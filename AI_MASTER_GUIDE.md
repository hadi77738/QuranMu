# AI MASTER GUIDE — STANDAR OPERASIONAL PROSEDUR (SOP)

> [!IMPORTANT]
> **PANDUAN UTAMA UNTUK AI AGENT:**
> Dokumen ini memuat Standar Operasional Prosedur (SOP) yang mengatur cara berpikir, menganalisis, dan mengeksekusi kode di seluruh siklus hidup proyek. 
> Semua tindakan teknis wajib merujuk pada salah satu kategori Use Case di bawah ini.

---

## DAFTAR ISI SOP

1. [Prinsip Dasar & Integritas Kerja](#-prinsip-dasar--integritas-kerja)
2. [USE CASE 1: Inisiasi Proyek Baru (From Scratch)](#-use-case-1-inisiasi-proyek-baru-from-scratch)
3. [USE CASE 2: Bug Fixing & Troubleshooting Mendalam](#-use-case-2-bug-fixing--troubleshooting-mendalam)
4. [USE CASE 3: Eksplorasi & Pemahaman Proyek Eksisting](#-use-case-3-eksplorasi--pemahaman-proyek-eksisting)
5. [USE CASE 4: Pengembangan Fitur Lanjutan](#-use-case-4-pengembangan-fitur-lanjutan)
6. [USE CASE 5: Refactoring & Optimasi Performa](#-use-case-5-refactoring--optimasi-performa)
7. [Protokol Handover & Sinkronisasi Memori](#-protokol-handover--sinkronisasi-memori)

---

## 💎 PRINSIP DASAR & INTEGRITAS KERJA

1. **Single Source of Truth:** Selalu jadikan `PROJECT_MEMORY.md` sebagai acuan state proyek saat ini.
2. **Anti-Asumsi:** Jika ada dependensi, versi pustaka, atau alur data yang ambigu, lakukan klarifikasi atau inspeksi berkas terlebih dahulu sebelum menulis kode.
3. **Eksekusi Bertahap (Incremental Delivery):** Jangan pernah menulis atau merombak seluruh aplikasi sekaligus dalam satu prompt panjang. Kerjakan modul per modul, verifikasi, lalu lanjutkan.
4. **Preservasi Gaya Kode:** Hormati konvensi penamaan, arsitektur folder, dan gaya penulisan (*indentation*, *casing*, struktur modul) yang telah ada.

---

## 🚀 USE CASE 1: INISIASI PROYEK BARU (FROM SCRATCH)

Gunakan SOP ini ketika pengguna meminta membuat website atau aplikasi baru dari awal.

### Alur Kerja (Workflow)
1. **Analisis Kebutuhan & Clarification:**
   * Pahami tujuan inti aplikasi, target pengguna, dan fitur-fitur MVP (*Minimum Viable Product*).
   * Tanyakan kebutuhan khusus jika belum didefinisikan (misal: perlu otentikasi? tipe database? desain responsif/mobile-first?).
2. **Kunci Tech Stack (Tech Stack Locking):**
   * Tentukan bahasa pemrograman, runtime, framework (beserta versi spesifik), styling engine (Vanilla CSS / Tailwind / UI Library), dan build tool (Vite / Next.js / dsb).
   * **WAJIB:** Catat seluruh stack ini ke Bagian 2 di `PROJECT_MEMORY.md` agar di sesi selanjutnya AI tidak beralih ke stack lain.
3. **Rancang Arsitektur & Struktur Folder:**
   * Buat struktur folder modular yang terpisah jelas (misal: pemisahan antara UI/komponen, alur data/services, assets, dan utilitas).
   * Catat arsitektur ini ke dalam *Directory Map* di `PROJECT_MEMORY.md`.
4. **Eksekusi Fase MVP secara Bertahap:**
   * **Fase 1:** Inisiasi scaffolding, config build, dan fondasi styling / design system.
   * **Fase 2:** Komponen inti dan layout utama.
   * **Fase 3:** Logika data / state management / integrasi API.
   * **Fase 4:** Polishing, responsive testing, dan penanganan edge cases.
5. **Update State:** Catat progress setiap fase selesai ke `PROJECT_MEMORY.md`.

---

## 🔍 USE CASE 2: BUG FIXING & TROUBLESHOOTING MENDALAM

Gunakan SOP ini ketika menangani error, crash, regresi, atau perilaku aplikasi yang tidak sesuai ekspektasi.

### Alur Kerja (Workflow)
1. **Reproduksi Masalah & Kumpulkan Fakta:**
   * Baca pesan error lengkap (*stack trace*), konteks file, dan langkah reproduksi (*reproduction steps*).
   * Jangan langsung menebak-nebak kode tanpa melacak asal muasal variabel atau data.
2. **Cek Riwayat Solusi Gagal (Anti-Looping):**
   * Buka tabel **Failed Attempts Ledger** di `PROJECT_MEMORY.md`.
   * Pastikan Anda **TIDAK MENCOBA KEMBALI** hipotesis atau solusi yang sudah terbukti gagal di sesi sebelumnya!
3. **Root Cause Analysis (RCA):**
   * Lacak *data flow* dari titik input sampai titik error meletus.
   * Identifikasi apakah masalah berasal dari tipe data (misal: `undefined/null`), masalah asinkron (Promise/race condition), salah routing, atau versi dependensi tidak kompatibel.
4. **Isolasi Perbaikan (Zero-Regression):**
   * Buat perubahan seminimal mungkin yang menyelesaikan akar masalah tanpa mengubah kontrak publik fungsi (*function signature*) jika digunakan oleh modul lain.
5. **Jika Perbaikan Berhasil:**
   * Hapus bug dari daftar *Known Issues* di `PROJECT_MEMORY.md`, dan catat solusi ringkasnya pada log riwayat.
6. **Jika Percobaan Gagal:**
   * **WAJIB CATAT** percobaan gagal tersebut ke tabel *Failed Attempts Ledger* di `PROJECT_MEMORY.md` beserta alasan mengapa gagal, agar tidak diulang oleh AI berikutnya.

---

## 🗺️ USE CASE 3: EKSPLORASI & PEMAHAMAN PROYEK EKSISTING

Gunakan SOP ini ketika pengguna memasukkan kode lama, repositori baru, atau meminta AI mempelajari struktur proyek untuk mencari insight.

### Alur Kerja (Workflow)
1. **Audit Struktur Repositori (Bird's-Eye View):**
   * Periksa berkas manifest: `package.json`, `requirements.txt`, `pubspec.yaml`, `composer.json`, dsb.
   * Identifikasi framework utama, dependensi penting, dan script perintah (`build`, `dev`, `test`).
2. **Petakan Alur Masuk (Entry Points) & Routing:**
   * Temukan file entry point (misal: `index.html`, `main.js`, `App.jsx`, `server.js`).
   * Lacak alur routing halaman/layanan.
3. **Petakan Manajemen State & Data Flow:**
   * Identifikasi bagaimana data dialirkan: lewat props, context, global store (Redux/Zustand), atau pemanggilan API langsung.
   * Identifikasi folder database/model jika ada.
4. **Dokumentasikan Hasil Temuan ke `PROJECT_MEMORY.md`:**
   * Isi atau perbarui **Directory Map & Key Files**.
   * Catat **Do's & Don'ts Proyek** (misal: "Proyek ini menggunakan camelCase untuk penamaan file", "Komponen harus dibungkus dengan HOC tertentu", dll).
5. **Konfirmasi Pemahaman ke Pengguna:**
   * Berikan ringkasan arsitektur 1-2 paragraf kepada pengguna untuk memastikan pemahaman AI sudah selaras dengan rancangan pemilik proyek.

---

## ⚡ USE CASE 4: PENGEMBANGAN FITUR LANJUTAN

Gunakan SOP ini ketika menambahkan modul, halaman, atau fungsionalitas baru pada proyek yang sudah berjalan.

### Alur Kerja (Workflow)
1. **Impact Analysis (Analisis Dampak):**
   * Cek file-file yang akan terpengaruh oleh fitur baru ini.
   * Pastikan penambahan fitur baru tidak merusak API contract atau fungsi eksisting.
2. **Konsistensi Design & Komponen:**
   * Gunakan kembali (*reuse*) komponen UI yang sudah ada (misal: Button, Modal, Card, Typography) daripada membuat styling baru dari nol.
   * Patuhi sistem token warna dan spacing yang tercatat di `PROJECT_MEMORY.md`.
3. **Penerapan Bertahap:**
   * Tahap A: Buat service/data layer atau fungsi helper.
   * Tahap B: Buat komponen UI dan hubungkan dengan state.
   * Tahap C: Integrasikan ke dalam navigasi atau alur utama.
4. **Validasi & Verifikasi:**
   * Uji apakah fitur baru bekerja dan fitur lama tetap berjalan normal (*no regression*).
5. **Update Roadmap:**
   * Pindahkan task terkait dari *Todo Selanjutnya* ke *Terakhir Dikerjakan* di `PROJECT_MEMORY.md`.

---

## 🧹 USE CASE 5: REFACTORING & OPTIMASI PERFORMA

Gunakan SOP ini ketika diminta merapikan kode (*clean code*), restrukturisasi arsitektur, atau mempercepat performa tanpa mengubah fungsi bisnis.

### Alur Kerja (Workflow)
1. **Behavior Preservation (Jaminan Fungsi Tidak Berubah):**
   * Refactoring HANYA boleh mengubah struktur internal kode, BUKAN perilaku eksternal (*observable behavior*).
2. **Identifikasi Titik Lemah (Code Smells / Bottlenecks):**
   * Duplikasi kode (*DRY violation*).
   * Komponen/fungsi terlalu besar (*God functions*).
   * Re-render berlebihan, memory leaks, atau bundle size yang membengkak.
3. **Refactor Bertahap & Terisolasi:**
   * Pecah perubahan menjadi langkah-langkah kecil (*micro-steps*). Jangan refactor 10 file sekaligus dalam satu aksi.
4. **Bersihkan Dead Code:**
   * Hapus variabel, import, atau file yang tidak lagi digunakan setelah refactoring selesai.
5. **Catat Rangkuman:** Tuliskan ringkasan modul apa yang dioptimasi ke dalam `PROJECT_MEMORY.md`.

---

## 🤝 PROTOKOL HANDOVER & SINKRONISASI MEMORI

Setiap kali sesi akan berakhir, atau setelah menyelesaikan tugas besar:

| Situasi | Tindakan AI pada `PROJECT_MEMORY.md` |
| :--- | :--- |
| **Fitur/Tugas Selesai** | Pindahkan status ke `Terakhir Dikerjakan`. Tulis apa yang siap dikerjakan berikutnya pada `Todo Selanjutnya`. |
| **Menemukan Bug Baru** | Tambahkan ke daftar `Known Issues`. |
| **Solusi Bug Gagal** | Wajib catat ke tabel `Failed Attempts Ledger` (Gejala, solusi yang dicoba, alasan gagal). |
| **Menambah Library Baru** | Wajib catat nama paket + versinya ke `Daftar Dependensi & Plugin`. |
| **Perubahan Struktur Folder** | Update bagian `Directory Map & Key Files`. |

> *Dengan mematuhi protokol ini, AI di sesi percakapan berikutnya akan langsung tahu konteks proyek tanpa Anda perlu menjelaskan ulang dari awal.*
