# Instrumen Pengujian Performance Efficiency Aplikasi Check-In

Dokumen ini adalah instrumen uji efisiensi kinerja (performance efficiency) untuk keperluan penelitian/skripsi pada aplikasi Check-In. Setiap baris mewakili satu proses/halaman yang diukur waktunya. Bahasa disusun akademis, humanis, dan mudah dipahami.

Ruang lingkup dan pengecualian:
- Cakupan mencakup seluruh peran: Admin, Guru, Siswa, serta halaman umum dan informasi bersama.
- Dikecualikan dari pengukuran: aksi refresh (pull-to-refresh), notifikasi (local/push), dan notifikasi perizinan/error atau sejenisnya.

Petunjuk pengukuran waktu:
- Satuan waktu: detik (s). Catat hingga dua desimal bila memungkinkan.
- Definisi waktu proses: mulai saat pengguna menekan aksi/berpindah halaman hingga kondisi antarmuka stabil dan hasil utama tampil (misal daftar muncul lengkap, konfirmasi sukses, atau berkas selesai diunduh/diunggah).
- Lakukan 5 kali percobaan per baris pada kondisi yang konsisten. Isi kolom Percobaan 1–5, lalu hitung Minimum, Maksimum, dan Rata-Rata.
- Catat variabel lingkungan (opsional tetapi disarankan): perangkat, OS, versi aplikasi, kualitas jaringan (Wi‑Fi/seluler), jarak ke server, jam uji.

Format tabel:
- No | Halaman/Proses yang diuji | Percobaan 1 | Percobaan 2 | Percobaan 3 | Percobaan 4 | Percobaan 5 | Waktu Minimal | Waktu Maksimal | Waktu Rata‑Rata

---

## 1) Halaman Umum & Navigasi

| No | Halaman/Proses yang diuji | Percobaan 1 | Percobaan 2 | Percobaan 3 | Percobaan 4 | Percobaan 5 | Waktu Minimal | Waktu Maksimal | Waktu Rata-Rata |
|---:|---|---|---|---|---|---|---|---|---|
| 1 | Peluncuran aplikasi hingga Home tampil |  |  |  |  |  |  |  |  |
| 2 | Navigasi dari Home ke Login |  |  |  |  |  |  |  |  |
| 3 | Navigasi dari Home ke Registrasi |  |  |  |  |  |  |  |  |
| 4 | Navigasi dari Home ke Pengaturan |  |  |  |  |  |  |  |  |

## 2) Pengaturan (Settings)

| No | Halaman/Proses yang diuji | Percobaan 1 | Percobaan 2 | Percobaan 3 | Percobaan 4 | Percobaan 5 | Waktu Minimal | Waktu Maksimal | Waktu Rata-Rata |
|---:|---|---|---|---|---|---|---|---|---|
| 5 | Ubah tema ke Gelap (waktu penerapan) |  |  |  |  |  |  |  |  |
| 6 | Ubah tema ke Terang (waktu penerapan) |  |  |  |  |  |  |  |  |
| 7 | Ubah tema ke Sistem (waktu penerapan) |  |  |  |  |  |  |  |  |
| 8 | Pemuatan tema tersimpan saat aplikasi dibuka ulang |  |  |  |  |  |  |  |  |
| 9 | Membuka “Tentang Aplikasi” |  |  |  |  |  |  |  |  |
| 10 | Membuka Panduan (Admin/Guru/Siswa) |  |  |  |  |  |  |  |  |

## 3) Autentikasi & Registrasi

| No | Halaman/Proses yang diuji | Percobaan 1 | Percobaan 2 | Percobaan 3 | Percobaan 4 | Percobaan 5 | Waktu Minimal | Waktu Maksimal | Waktu Rata-Rata |
|---:|---|---|---|---|---|---|---|---|---|
| 11 | Login Admin (kredensial valid) hingga beranda Admin tampil |  |  |  |  |  |  |  |  |
| 12 | Login Admin (kredensial invalid) hingga pesan penolakan tampil |  |  |  |  |  |  |  |  |
| 13 | Login Guru (email valid) hingga beranda Guru tampil |  |  |  |  |  |  |  |  |
| 14 | Login Guru (email tidak terdaftar) hingga penolakan tampil |  |  |  |  |  |  |  |  |
| 15 | Login Siswa (email valid) hingga beranda Siswa tampil |  |  |  |  |  |  |  |  |
| 16 | Login Siswa (email tidak terdaftar) hingga penolakan tampil |  |  |  |  |  |  |  |  |
| 17 | Membuka halaman Registrasi Admin dari Home |  |  |  |  |  |  |  |  |
| 18 | Registrasi Admin (data valid) hingga konfirmasi sukses |  |  |  |  |  |  |  |  |
| 19 | Validasi wajib isi Registrasi (kirim form tak lengkap) hingga penolakan tampil |  |  |  |  |  |  |  |  |

## 4) Admin – Beranda & Profil

| No | Halaman/Proses yang diuji | Percobaan 1 | Percobaan 2 | Percobaan 3 | Percobaan 4 | Percobaan 5 | Waktu Minimal | Waktu Maksimal | Waktu Rata-Rata |
|---:|---|---|---|---|---|---|---|---|---|
| 20 | Membuka tab Profil Admin dan memuat data |  |  |  |  |  |  |  |  |
| 21 | Simpan perubahan Profil Admin |  |  |  |  |  |  |  |  |
| 22 | Ubah kata sandi Admin (simpan) |  |  |  |  |  |  |  |  |
| 23 | Hapus akun Admin (konfirmasi hingga selesai) |  |  |  |  |  |  |  |  |
| 24 | Buka Info Sekolah dari Profil Admin |  |  |  |  |  |  |  |  |

## 5) Admin – Unduh Template & Import Data (Excel)

| No | Halaman/Proses yang diuji | Percobaan 1 | Percobaan 2 | Percobaan 3 | Percobaan 4 | Percobaan 5 | Waktu Minimal | Waktu Maksimal | Waktu Rata-Rata |
|---:|---|---|---|---|---|---|---|---|---|
| 25 | Membuka halaman Unduh Template |  |  |  |  |  |  |  |  |
| 26 | Unduh template Data_Sekolah.xlsx |  |  |  |  |  |  |  |  |
| 27 | Unduh template Data_Guru.xlsx |  |  |  |  |  |  |  |  |
| 28 | Unduh template Data_Siswa.xlsx |  |  |  |  |  |  |  |  |
| 29 | Unduh semua template (jika tersedia) |  |  |  |  |  |  |  |  |
| 30 | Membuka halaman Import Data Excel |  |  |  |  |  |  |  |  |
| 31 | Import Excel Sekolah – mode replace_all (unggah→selesai) |  |  |  |  |  |  |  |  |
| 32 | Import Excel Sekolah – mode add_new (unggah→selesai) |  |  |  |  |  |  |  |  |
| 33 | Import Excel Guru – mode replace_all |  |  |  |  |  |  |  |  |
| 34 | Import Excel Guru – mode add_new |  |  |  |  |  |  |  |  |
| 35 | Import Excel Siswa – mode replace_all |  |  |  |  |  |  |  |  |
| 36 | Import Excel Siswa – mode add_new |  |  |  |  |  |  |  |  |
| 37 | Unduh Excel eksisting (Sekolah/Guru/Siswa) |  |  |  |  |  |  |  |  |
| 38 | Tampilkan status import Excel (ambil status server) |  |  |  |  |  |  |  |  |

## 6) Admin – Import Foto (ZIP) & Arsip

| No | Halaman/Proses yang diuji | Percobaan 1 | Percobaan 2 | Percobaan 3 | Percobaan 4 | Percobaan 5 | Waktu Minimal | Waktu Maksimal | Waktu Rata-Rata |
|---:|---|---|---|---|---|---|---|---|---|
| 39 | Membuka halaman Import Foto (Guru/Siswa) |  |  |  |  |  |  |  |  |
| 40 | Import Foto Guru – mode replace_all (unggah→selesai) |  |  |  |  |  |  |  |  |
| 41 | Import Foto Guru – mode add_new (unggah→selesai) |  |  |  |  |  |  |  |  |
| 42 | Import Foto Siswa – mode replace_all (unggah→selesai) |  |  |  |  |  |  |  |  |
| 43 | Import Foto Siswa – mode add_new (unggah→selesai) |  |  |  |  |  |  |  |  |
| 44 | Tampilkan status import Foto (ambil status server) |  |  |  |  |  |  |  |  |
| 45 | Unduh arsip foto (ZIP) |  |  |  |  |  |  |  |  |

## 7) Admin – Lihat Data (Browse/Edit)

| No | Halaman/Proses yang diuji | Percobaan 1 | Percobaan 2 | Percobaan 3 | Percobaan 4 | Percobaan 5 | Waktu Minimal | Waktu Maksimal | Waktu Rata-Rata |
|---:|---|---|---|---|---|---|---|---|---|
| 46 | Memuat daftar Guru (per prodi/bidang) |  |  |  |  |  |  |  |  |
| 47 | Simpan perubahan data Guru |  |  |  |  |  |  |  |  |
| 48 | Memuat daftar Siswa (per tahun/prodi/kelas) |  |  |  |  |  |  |  |  |
| 49 | Simpan perubahan data Siswa |  |  |  |  |  |  |  |  |

## 8) Guru – Beranda & Profil

| No | Halaman/Proses yang diuji | Percobaan 1 | Percobaan 2 | Percobaan 3 | Percobaan 4 | Percobaan 5 | Waktu Minimal | Waktu Maksimal | Waktu Rata-Rata |
|---:|---|---|---|---|---|---|---|---|---|
| 50 | Membuka tab Profil Guru dan memuat data |  |  |  |  |  |  |  |  |
| 51 | Buka Info (Sekolah/Admin Pembuat) dari Profil |  |  |  |  |  |  |  |  |

## 9) Guru – Riwayat Presensi (Pengelolaan Jadwal)

| No | Halaman/Proses yang diuji | Percobaan 1 | Percobaan 2 | Percobaan 3 | Percobaan 4 | Percobaan 5 | Waktu Minimal | Waktu Maksimal | Waktu Rata-Rata |
|---:|---|---|---|---|---|---|---|---|---|
| 52 | Menelusuri hingga daftar Pertemuan tampil (Tahun→Prodi→Kelas→Semester→Mapel) |  |  |  |  |  |  |  |  |
| 53 | Mulai presensi (ubah status ke aktif) |  |  |  |  |  |  |  |  |
| 54 | Selesaikan presensi (ubah status ke selesai) |  |  |  |  |  |  |  |  |
| 55 | Edit jadwal pertemuan (simpan) |  |  |  |  |  |  |  |  |
| 56 | Buka detail pertemuan (halaman Detail Presensi Guru) |  |  |  |  |  |  |  |  |

## 10) Guru – Detail Presensi Kelas

| No | Halaman/Proses yang diuji | Percobaan 1 | Percobaan 2 | Percobaan 3 | Percobaan 4 | Percobaan 5 | Waktu Minimal | Waktu Maksimal | Waktu Rata-Rata |
|---:|---|---|---|---|---|---|---|---|---|
| 57 | Memuat daftar siswa & status presensi |  |  |  |  |  |  |  |  |
| 58 | Ubah status siswa ke Hadir (simpan) |  |  |  |  |  |  |  |  |
| 59 | Ubah status siswa ke Tidak Hadir (isi keterangan→simpan) |  |  |  |  |  |  |  |  |
| 60 | Memuat hasil face recognition (jika tersedia) |  |  |  |  |  |  |  |  |
| 61 | Buka dialog detail face recognition |  |  |  |  |  |  |  |  |

## 11) Guru – Rekap Presensi & Mata Pelajaran

| No | Halaman/Proses yang diuji | Percobaan 1 | Percobaan 2 | Percobaan 3 | Percobaan 4 | Percobaan 5 | Waktu Minimal | Waktu Maksimal | Waktu Rata-Rata |
|---:|---|---|---|---|---|---|---|---|---|
| 62 | Unduh rekap presensi (Excel) |  |  |  |  |  |  |  |  |
| 63 | Unduh template mata pelajaran |  |  |  |  |  |  |  |  |
| 64 | Unggah/Update mata pelajaran – replace_all |  |  |  |  |  |  |  |  |
| 65 | Unggah/Update mata pelajaran – add_new |  |  |  |  |  |  |  |  |
| 66 | Unduh berkas mata pelajaran terakhir |  |  |  |  |  |  |  |  |

## 12) Guru – Data Siswa (Per Kelas)

| No | Halaman/Proses yang diuji | Percobaan 1 | Percobaan 2 | Percobaan 3 | Percobaan 4 | Percobaan 5 | Waktu Minimal | Waktu Maksimal | Waktu Rata-Rata |
|---:|---|---|---|---|---|---|---|---|---|
| 67 | Memuat daftar Prodi & Kelas |  |  |  |  |  |  |  |  |
| 68 | Membuka daftar siswa per Kelas |  |  |  |  |  |  |  |  |
| 69 | Render daftar siswa dengan foto (hingga stabil) |  |  |  |  |  |  |  |  |

## 13) Siswa – Beranda & Profil

| No | Halaman/Proses yang diuji | Percobaan 1 | Percobaan 2 | Percobaan 3 | Percobaan 4 | Percobaan 5 | Waktu Minimal | Waktu Maksimal | Waktu Rata-Rata |
|---:|---|---|---|---|---|---|---|---|---|
| 70 | Membuka tab Profil Siswa dan memuat data |  |  |  |  |  |  |  |  |
| 71 | Buka Info (Sekolah/Admin Pembuat) dari Profil Siswa |  |  |  |  |  |  |  |  |

## 14) Siswa – Riwayat & Detail Presensi

| No | Halaman/Proses yang diuji | Percobaan 1 | Percobaan 2 | Percobaan 3 | Percobaan 4 | Percobaan 5 | Waktu Minimal | Waktu Maksimal | Waktu Rata-Rata |
|---:|---|---|---|---|---|---|---|---|---|
| 72 | Menelusuri hingga daftar Pertemuan tampil (Tahun→Kelas→Semester→Mapel) |  |  |  |  |  |  |  |  |
| 73 | Membuka halaman Detail Presensi Siswa |  |  |  |  |  |  |  |  |
| 74 | Memuat status/keterangan presensi |  |  |  |  |  |  |  |  |
| 75 | Memuat hasil face recognition (jika tersedia) |  |  |  |  |  |  |  |  |
| 76 | Buka dialog detail face recognition |  |  |  |  |  |  |  |  |

## 15) Halaman Informasi Bersama

| No | Halaman/Proses yang diuji | Percobaan 1 | Percobaan 2 | Percobaan 3 | Percobaan 4 | Percobaan 5 | Waktu Minimal | Waktu Maksimal | Waktu Rata-Rata |
|---:|---|---|---|---|---|---|---|---|---|
| 77 | Membuka halaman Info Sekolah |  |  |  |  |  |  |  |  |
| 78 | Membuka halaman Info Admin Pembuat |  |  |  |  |  |  |  |  |

---

## Catatan Eksekusi & Pelaporan
- Tandai setiap percobaan dengan nilai waktu aktual (detik). Disarankan menyertakan catatan singkat bila terjadi variasi besar.
- Isi kolom Minimal/Maksimal/Rata-Rata setelah 5 percobaan. Rata-rata dapat dihitung sebagai mean aritmetika sederhana.
- Untuk proses unduh/unggah berkas, pastikan ukuran berkas dan jaringan relatif konstan antar percobaan.

## Asumsi Lingkungan Uji
- Perangkat uji, OS, dan versi aplikasi konsisten selama pengujian.
- Akses jaringan ke server aplikasi tersedia dan stabil.
- Dataset uji (akun, mapel, jadwal, Excel/ZIP) telah disiapkan untuk memungkinkan seluruh proses dijalankan tanpa menguji skenario refresh/notifikasi.

## Kriteria Kinerja (contoh acuan, opsional)
- Respon UI navigasi halaman sederhana < 1–2 detik pada jaringan stabil.
- Operasi jaringan ringan (muat profil/daftar) < 2–4 detik.
- Operasi unggah/unduh atau impor data besar bergantung ukuran berkas dan kondisi jaringan; catat serta bandingkan antar percobaan.
