# PANDUAN PENGGUNAAN TEMPLATE STARTER KIT

Folder ini berisi starter kit berkas panduan & memori AI untuk digunakan pada proyek-proyek Anda di Antigravity IDE.

---

## 📦 Berkas yang Tersedia

1. **`AGENTS.template.md`** -> Rename menjadi **`AGENTS.md`** di root proyek.
   * *Fungsi:* Dibaca secara otomatis oleh Antigravity IDE setiap percakapan dimulai. Berfungsi sebagai pemicu agar AI membaca memori proyek terlebih dahulu.
2. **`AI_MASTER_GUIDE.template.md`** -> Rename menjadi **`AI_MASTER_GUIDE.md`** di root proyek.
   * *Fungsi:* Buku panduan SOP teknis yang mencakup 5 Use Case (Bikin baru, Bug fixing, Pahami proyek lama, Tambah fitur, Refactor).
3. **`PROJECT_MEMORY.template.md`** -> Rename menjadi **`PROJECT_MEMORY.md`** di root proyek.
   * *Fungsi:* Otak memori eksternal tempat mencatat tech stack yang terkunci, daftar bug, failed attempts, dan status pengerjaan saat ini.

---

## ⚡ Cara Pakai di Proyek Baru (Hanya 3 Langkah)

1. **Salin 3 Berkas:**
   Salin `AGENTS.template.md`, `AI_MASTER_GUIDE.template.md`, dan `PROJECT_MEMORY.template.md` ke folder root proyek baru Anda.
2. **Hapus ekstensi `.template`:**
   Ubah namanya menjadi:
   * `AGENTS.md`
   * `AI_MASTER_GUIDE.md`
   * `PROJECT_MEMORY.md`
3. **Mulai Chat di Antigravity IDE:**
   Anda tidak perlu lagi mengetik prompt panjang meminta AI membaca aturan. Cukup berikan instruksi tugas Anda seperti biasa (misal: *"Tolong buatkan halaman login"* atau *"Tolong cari penyebab bug di auth.js"*). AI di Antigravity akan secara otomatis membaca `AGENTS.md`, memeriksa `PROJECT_MEMORY.md`, dan menjalankan SOP di `AI_MASTER_GUIDE.md`!
