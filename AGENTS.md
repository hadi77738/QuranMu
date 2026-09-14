# PROTOKOL OPERASIONAL AI (ANTIGRAVITY SYSTEM HOOK)

> [!IMPORTANT]
> **INSTRUKSI SISTEM UNTUK SEMUA AI AGENT:**
> File ini dibaca secara otomatis oleh Antigravity IDE di setiap awal percakapan dan setiap instruksi pengguna. File ini menghubungkan Anda dengan **Living Memory** dan **SOP Proyek**. Patuhi protokol ini tanpa pengecualian!

---

## 🧭 PROTOKOL BOOTSTRAP (WAJIB DI AWAL SETIAP SESI)

Sebelum Anda menulis kode, menjalankan perintah, atau memberikan saran arsitektur, jalankan 3 langkah berikut secara berurutan:

```
[Mulai Sesi/Prompt Baru]
          │
          ▼
1. BACA FILE MEMORI PROYEK ─────────► [PROJECT_MEMORY.md]
   (Ambil status terakhir, stack yang terkunci, & pantangan proyek)
          │
          ▼
2. IDENTIFIKASI USE CASE ───────────► [AI_MASTER_GUIDE.md]
   (Pilih SOP kerja: New App / Bug Fix / Eksplorasi / Fitur Baru / Refactor)
          │
          ▼
3. EKSEKUSI & UPDATE STATUS ────────► Perbarui [PROJECT_MEMORY.md] saat ada perubahan
```

1. **Step 0 — Baca Memori Aktif:**
   Buka dan baca `PROJECT_MEMORY.md`. Pahami:
   * Stack teknologi yang **sudah terkunci** (dilarang mengganti framework/library tanpa izin).
   * Status pengerjaan terakhir (*Current Task* dan *Next Steps*).
   * Daftar pantangan (*Do's and Don'ts*) dan *Known Issues*.

2. **Step 1 — Tentukan Use Case & Buka SOP Terkait:**
   Cocokkan tugas dari pengguna dengan salah satu kategori di `AI_MASTER_GUIDE.md`:
   * **USE CASE 1:** Inisiasi Proyek Baru (*From Scratch*)
   * **USE CASE 2:** Bug Fixing & Troubleshooting Mendalam
   * **USE CASE 3:** Eksplorasi & Pemahaman Proyek Eksisting (*Onboarding*)
   * **USE CASE 4:** Pengembangan Fitur Lanjutan (*Feature Addition*)
   * **USE CASE 5:** Refactoring & Optimasi Performa

3. **Step 2 — Jalankan Protokol Handover (Disiplin Memori):**
   Setiap kali Anda menyelesaikan suatu tahapan, memperbaiki bug, atau sebelum sesi berakhir:
   * **Wajib perbarui** `PROJECT_MEMORY.md` (Bagian: *Status Saat Ini*, *Todo Selanjutnya*, atau *Failed Attempts Log* jika ada percobaan gagal).

---

## 🛡️ ATURAN INTEGRITAS KODE (UNIVERSAL LAWS)

1. **Dilarang Berasumsi (No Hallucinated Tools):** Gunakan hanya library yang tercatat pada `PROJECT_MEMORY.md`. Jika butuh library baru, jelaskan alasannya dan minta konfirmasi pengguna terlebih dahulu.
2. **Isolasi Perubahan:** Jangan pernah mengubah struktur kode atau file lain di luar cakupan tugas tanpa analisis dampak (*Impact Analysis*).
3. **Format Tautan File:** Selalu gunakan format markdown link GitHub dengan skema `file://` saat merujuk file proyek.
