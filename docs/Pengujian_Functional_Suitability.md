# Tabel Tahapan Pengujian Functional Suitability Aplikasi Check-In

Dokumen ini merangkum skenario uji fungsional (functional suitability) untuk seluruh halaman dan fitur utama aplikasi. Bahasa disusun secara akademis, humanis, dan mudah dipahami. Cakupan menghindari aspek yang dikecualikan sesuai arahan.

Catatan dan ruang lingkup:
- Termasuk seluruh peran: Admin, Guru, dan Siswa; berikut halaman umum dan informasi.
- Dikecualikan: aksi refresh (pull-to-refresh), notifikasi (local/push), serta notifikasi terkait izin penyimpanan atau error perizinan.
- Kolom “Berhasil”/“Gagal” disediakan sebagai checklist saat eksekusi (isi manual oleh penguji).

Format tabel:
- No | Fitur yang diuji | Langkah pengujian | Hasil yang diharapkan | Berhasil | Gagal

---

## 1) Halaman Umum & Navigasi

| No | Fitur yang diuji | Langkah pengujian | Hasil yang diharapkan | Berhasil | Gagal |
|---:|---|---|---|:---:|:---:|
| 1 | Memuat aplikasi (Home) | Buka aplikasi dari perangkat. | Halaman Home tampil dengan logo dan tombol navigasi (Login, Registrasi, Pengaturan). | [ ] | [ ] |
| 2 | Navigasi ke Login | Dari Home, tekan tombol Login. | Halaman Login tampil dengan pilihan peran (Admin, Guru, Siswa). | [ ] | [ ] |
| 3 | Navigasi ke Registrasi | Dari Home, tekan tombol Registrasi. | Halaman Registrasi Admin tampil. | [ ] | [ ] |
| 4 | Navigasi ke Pengaturan | Dari Home, tekan ikon/tautan Pengaturan. | Halaman Pengaturan tampil dengan opsi tema dan tautan informasi. | [ ] | [ ] |

## 2) Pengaturan (Settings)

| No | Fitur yang diuji | Langkah pengujian | Hasil yang diharapkan | Berhasil | Gagal |
|---:|---|---|---|:---:|:---:|
| 5 | Ubah tema ke Gelap | Buka Pengaturan → pilih Tema: Gelap. | Seluruh UI beralih ke tema gelap. | [ ] | [ ] |
| 6 | Ubah tema ke Terang | Buka Pengaturan → pilih Tema: Terang. | Seluruh UI beralih ke tema terang. | [ ] | [ ] |
| 7 | Tema mengikuti Sistem | Buka Pengaturan → pilih Tema: Sistem. | Tema mengikuti preferensi sistem perangkat. | [ ] | [ ] |
| 8 | Persistensi tema | Ubah tema, tutup dan buka ulang aplikasi. | Tema terakhir tetap terpilih (persisten). | [ ] | [ ] |
| 9 | Informasi Aplikasi | Di Pengaturan, buka “Tentang Aplikasi”. | Informasi aplikasi tampil (deskripsi singkat, logo/identitas). | [ ] | [ ] |
| 10 | Panduan per peran | Di Pengaturan, buka Panduan Admin/Guru/Siswa. | Halaman panduan per peran terbuka dan dapat dibaca. | [ ] | [ ] |

## 3) Autentikasi & Registrasi

| No | Fitur yang diuji | Langkah pengujian | Hasil yang diharapkan | Berhasil | Gagal |
|---:|---|---|---|:---:|:---:|
| 11 | Login Admin berhasil | Di Login, pilih Admin → isi email dan kata sandi valid → Masuk. | Beralih ke beranda Admin; sesi admin tersimpan. | [ ] | [ ] |
| 12 | Login Admin gagal (kredensial salah) | Di Login Admin, isi email/kata sandi salah → Masuk. | Sistem menolak masuk; pengguna tetap di halaman login. | [ ] | [ ] |
| 13 | “Ingat saya” Admin | Centang “ingat saya” saat login berhasil → tutup dan buka ulang aplikasi. | Kolom email otomatis terisi/tersimpan sesuai implementasi. | [ ] | [ ] |
| 14 | Login Guru berhasil | Di Login, pilih Guru → isi email valid → Masuk. | Beralih ke beranda Guru; sesi guru tersimpan. | [ ] | [ ] |
| 15 | Login Guru gagal (email tidak terdaftar) | Di Login Guru, isi email tidak terdaftar → Masuk. | Sistem menolak masuk; tetap di halaman login. | [ ] | [ ] |
| 16 | “Ingat saya” Guru | Centang “ingat saya” saat login berhasil → tutup dan buka ulang aplikasi. | Kolom email otomatis terisi/tersimpan sesuai implementasi. | [ ] | [ ] |
| 17 | Login Siswa berhasil | Di Login, pilih Siswa → isi email valid → Masuk. | Beralih ke beranda Siswa; sesi siswa tersimpan. | [ ] | [ ] |
| 18 | Login Siswa gagal (email tidak terdaftar) | Di Login Siswa, isi email tidak terdaftar → Masuk. | Sistem menolak masuk; tetap di halaman login. | [ ] | [ ] |
| 19 | “Ingat saya” Siswa | Centang “ingat saya” saat login berhasil → tutup dan buka ulang aplikasi. | Kolom email otomatis terisi/tersimpan sesuai implementasi. | [ ] | [ ] |
| 20 | Akses Registrasi Admin | Dari Home → Registrasi. | Form registrasi Admin tampil lengkap (sesuai implementasi). | [ ] | [ ] |
| 21 | Registrasi Admin valid | Isi form registrasi Admin dengan data valid → Kirim. | Akun admin tercatat; dapat login sebagai Admin. | [ ] | [ ] |
| 22 | Validasi wajib isi Registrasi | Coba kirim form dengan kolom wajib kosong. | Sistem menolak penyimpanan; menandai kolom wajib. | [ ] | [ ] |

## 4) Admin – Beranda & Profil

| No | Fitur yang diuji | Langkah pengujian | Hasil yang diharapkan | Berhasil | Gagal |
|---:|---|---|---|:---:|:---:|
| 23 | Tab Beranda Admin | Login sebagai Admin → beranda tampil dengan tab (Profil, Input Data, Lihat Data). | Semua tab tampil dan dapat dipilih. | [ ] | [ ] |
| 24 | Muat Profil Admin | Buka tab Profil Admin. | Data profil admin termuat (nama, email, dsb.). | [ ] | [ ] |
| 25 | Ubah profil Admin | Edit profil (mis. nama) → Simpan. | Perubahan tersimpan dan tampil pada profil. | [ ] | [ ] |
| 26 | Ubah kata sandi Admin | Masukkan kata sandi lama/baru valid → Simpan. | Kata sandi berhasil diperbarui; dapat login dengan sandi baru. | [ ] | [ ] |
| 27 | Hapus akun Admin (konfirmasi) | Pilih hapus akun → konfirmasi. | Akun terhapus; pengguna keluar ke alur awal. | [ ] | [ ] |
| 28 | Tautan Info Sekolah | Dari Profil Admin, buka Info Sekolah. | Halaman info sekolah tampil. | [ ] | [ ] |

## 5) Admin – Input Data (Template/Import Excel/Foto)

| No | Fitur yang diuji | Langkah pengujian | Hasil yang diharapkan | Berhasil | Gagal |
|---:|---|---|---|:---:|:---:|
| 29 | Navigasi ke Unduh Template | Admin → Input Data → Unduh Template. | Halaman unduh template tampil (Sekolah/Guru/Siswa). | [ ] | [ ] |
| 30 | Unduh template Sekolah | Tekan unduh “Data_Sekolah.xlsx”. | Berkas terunduh dan dapat dibuka. | [ ] | [ ] |
| 31 | Unduh template Guru | Tekan unduh “Data_Guru.xlsx”. | Berkas terunduh dan dapat dibuka. | [ ] | [ ] |
| 32 | Unduh template Siswa | Tekan unduh “Data_Siswa.xlsx”. | Berkas terunduh dan dapat dibuka. | [ ] | [ ] |
| 33 | Unduh semua template | Jalankan unduh seluruh template (jika tersedia). | Ketiga berkas terunduh lengkap. | [ ] | [ ] |
| 34 | Navigasi ke Import Data Excel | Admin → Input Data → Import Data Excel. | Halaman import Excel tampil (Sekolah/Guru/Siswa). | [ ] | [ ] |
| 35 | Import Sekolah (replace_all) | Pilih tipe Sekolah → pilih mode “replace_all” → pilih berkas Excel valid → Unggah. | Data sekolah diganti seluruhnya sesuai berkas. | [ ] | [ ] |
| 36 | Import Sekolah (add_new) | Pilih tipe Sekolah → “add_new” → berkas valid → Unggah. | Data baru ditambahkan tanpa menghapus yang lama. | [ ] | [ ] |
| 37 | Import Guru (replace_all) | Pilih tipe Guru → “replace_all” → Excel valid → Unggah. | Data guru diganti sesuai berkas. | [ ] | [ ] |
| 38 | Import Guru (add_new) | Pilih tipe Guru → “add_new” → Excel valid → Unggah. | Data guru baru ditambahkan. | [ ] | [ ] |
| 39 | Import Siswa (replace_all) | Pilih tipe Siswa → “replace_all” → Excel valid → Unggah. | Data siswa diganti sesuai berkas. | [ ] | [ ] |
| 40 | Import Siswa (add_new) | Pilih tipe Siswa → “add_new” → Excel valid → Unggah. | Data siswa baru ditambahkan. | [ ] | [ ] |
| 41 | Download Excel eksisting | Pilih tipe (Sekolah/Guru/Siswa) → Unduh data saat ini. | Berkas Excel berisi data terkini. | [ ] | [ ] |
| 42 | Lihat status import Excel | Gunakan tombol/status untuk melihat status terakhir. | Status proses import tampil (ringkasan dan waktu). | [ ] | [ ] |
| 43 | Navigasi ke Import Foto | Admin → Input Data → Import Foto (Guru/Siswa). | Halaman import foto tampil. | [ ] | [ ] |
| 44 | Import Foto Guru (replace_all) | Pilih Guru → “replace_all” → pilih ZIP foto valid → Unggah. | Foto guru terunggah/terbarui, menggantikan yang lama. | [ ] | [ ] |
| 45 | Import Foto Guru (add_new) | Pilih Guru → “add_new” → ZIP foto valid → Unggah. | Foto baru ditambahkan; yang lama tetap ada. | [ ] | [ ] |
| 46 | Import Foto Siswa (replace_all) | Pilih Siswa → “replace_all” → ZIP valid → Unggah. | Foto siswa terunggah menggantikan yang lama. | [ ] | [ ] |
| 47 | Import Foto Siswa (add_new) | Pilih Siswa → “add_new” → ZIP valid → Unggah. | Foto baru ditambahkan; yang lama tetap ada. | [ ] | [ ] |
| 48 | Lihat status import Foto | Gunakan tombol/status untuk melihat status. | Status proses import foto tampil (ringkasan dan waktu). | [ ] | [ ] |
| 49 | Unduh arsip Foto | Pilih entitas (Guru/Siswa) → unduh ZIP yang tersedia. | Berkas ZIP berhasil diunduh. | [ ] | [ ] |

## 6) Admin – Lihat Data (Browse/Edit)

| No | Fitur yang diuji | Langkah pengujian | Hasil yang diharapkan | Berhasil | Gagal |
|---:|---|---|---|:---:|:---:|
| 50 | Tampilkan data Guru | Admin → Lihat Data → tab Guru. | Data guru tampil, terkelompok sesuai prodi/bidang. | [ ] | [ ] |
| 51 | Edit data Guru | Pada item Guru → buka dialog edit → simpan perubahan. | Perubahan tersimpan dan tampil di daftar. | [ ] | [ ] |
| 52 | Tampilkan data Siswa | Admin → Lihat Data → tab Siswa. | Data siswa tampil per tahun/prodi/kelas. | [ ] | [ ] |
| 53 | Edit data Siswa | Pada item Siswa → buka dialog edit → simpan perubahan. | Perubahan tersimpan dan tampil di daftar. | [ ] | [ ] |

## 7) Guru – Beranda & Profil

| No | Fitur yang diuji | Langkah pengujian | Hasil yang diharapkan | Berhasil | Gagal |
|---:|---|---|---|:---:|:---:|
| 54 | Tab Beranda Guru | Login sebagai Guru → beranda tampil (Profil, Riwayat Presensi, Rekap Presensi, Data Siswa). | Semua tab tampil dan dapat dipilih. | [ ] | [ ] |
| 55 | Muat Profil Guru | Buka tab Profil. | Data profil guru termuat (nama/email/dll.). | [ ] | [ ] |
| 56 | Tautan Info (Guru) | Dari Profil, buka Info Sekolah/Admin Pembuat. | Halaman informasi terkait tampil. | [ ] | [ ] |

## 8) Guru – Riwayat Presensi (Pengelolaan Jadwal)

| No | Fitur yang diuji | Langkah pengujian | Hasil yang diharapkan | Berhasil | Gagal |
|---:|---|---|---|:---:|:---:|
| 57 | Hirarki penelusuran | Guru → Riwayat Presensi → pilih Tahun → Prodi → Kelas → Semester → Mapel → Pertemuan. | Daftar pertemuan untuk mapel terpilih tampil. | [ ] | [ ] |
| 58 | Mulai presensi | Pada pertemuan status “belum” → pilih “Mulai/aktifkan presensi”. | Status pertemuan berubah menjadi “aktif”. | [ ] | [ ] |
| 59 | Selesaikan presensi | Pada pertemuan “aktif” → pilih “Selesaikan presensi”. | Status pertemuan berubah menjadi “selesai”. | [ ] | [ ] |
| 60 | Edit jadwal pertemuan | Buka opsi edit untuk pertemuan → ubah jadwal → simpan. | Jadwal pertemuan diperbarui. | [ ] | [ ] |
| 61 | Buka detail pertemuan | Pilih salah satu pertemuan dari daftar. | Halaman detail presensi Guru terbuka. | [ ] | [ ] |

## 9) Guru – Detail Presensi Kelas (Perubahan Status, Face Recognition)

| No | Fitur yang diuji | Langkah pengujian | Hasil yang diharapkan | Berhasil | Gagal |
|---:|---|---|---|:---:|:---:|
| 62 | Tampilkan daftar siswa & status | Di Detail Presensi, pastikan daftar siswa dan status hadir/tidak hadir terlihat. | Data siswa dan status tersaji lengkap. | [ ] | [ ] |
| 63 | Ubah status siswa ke Hadir | Pada salah satu siswa → ubah status menjadi Hadir → simpan. | Status siswa berubah ke “Hadir” dan tersimpan. | [ ] | [ ] |
| 64 | Ubah status siswa ke Tidak Hadir | Pada salah satu siswa → ubah status menjadi Tidak Hadir → isi keterangan → simpan. | Status siswa berubah ke “Tidak Hadir” beserta keterangan. | [ ] | [ ] |
| 65 | Lihat hasil deteksi wajah | Pada bagian hasil face recognition (jika tersedia), pastikan daftar dan gambar tampil. | Data deteksi wajah tampil sesuai pertemuan. | [ ] | [ ] |
| 66 | Dialog detail face recognition | Tekan “Lihat Detail” pada salah satu item deteksi. | Dialog menampilkan gambar dan metadata (akurasi/waktu/tipe match). | [ ] | [ ] |

## 10) Guru – Rekap Presensi & Mata Pelajaran

| No | Fitur yang diuji | Langkah pengujian | Hasil yang diharapkan | Berhasil | Gagal |
|---:|---|---|---|:---:|:---:|
| 67 | Unduh rekap presensi | Guru → Rekap Presensi → unduh rekap untuk rentang/mapel tertentu. | Berkas rekap Excel terunduh dan dapat dibuka. | [ ] | [ ] |
| 68 | Unduh template mapel | Di halaman yang sama → unduh template mata pelajaran. | Berkas template mapel terunduh. | [ ] | [ ] |
| 69 | Unggah/Update mapel (replace_all) | Pilih template mapel berisi data → mode “replace_all” → unggah. | Daftar mapel diperbarui menggantikan sebelumnya. | [ ] | [ ] |
| 70 | Unggah/Update mapel (add_new) | Pilih template mapel → mode “add_new” → unggah. | Mapel baru ditambahkan tanpa menghapus yang lama. | [ ] | [ ] |
| 71 | Unduh berkas mapel terakhir | Unduh berkas mapel yang tersimpan. | Berkas mapel yang terakhir diunggah tersedia. | [ ] | [ ] |

## 11) Guru – Data Siswa (Per Kelas)

| No | Fitur yang diuji | Langkah pengujian | Hasil yang diharapkan | Berhasil | Gagal |
|---:|---|---|---|:---:|:---:|
| 72 | Daftar Prodi & Kelas | Guru → Data Siswa → tampilkan daftar Prodi dan Kelas yang tersedia. | Daftar Prodi/Kelas tampil sesuai hak akses guru. | [ ] | [ ] |
| 73 | Buka daftar siswa per kelas | Pilih salah satu Prodi → Kelas. | Halaman daftar siswa per kelas tampil (nama, no absen, email, gender, foto). | [ ] | [ ] |
| 74 | Tampilkan foto siswa | Pastikan foto siswa pada daftar dapat dimuat. | Foto tampil (atau avatar default bila tidak ada). | [ ] | [ ] |

## 12) Siswa – Beranda & Profil

| No | Fitur yang diuji | Langkah pengujian | Hasil yang diharapkan | Berhasil | Gagal |
|---:|---|---|---|:---:|:---:|
| 75 | Tab Beranda Siswa | Login sebagai Siswa → beranda tampil (Profil, Riwayat Presensi). | Semua tab tampil dan dapat dipilih. | [ ] | [ ] |
| 76 | Muat Profil Siswa | Buka tab Profil. | Data profil siswa termuat (nama, kelas, prodi, no absen, foto). | [ ] | [ ] |
| 77 | Tautan Info (Siswa) | Dari Profil, buka Info Sekolah/Admin Pembuat. | Halaman informasi terkait tampil. | [ ] | [ ] |

## 13) Siswa – Riwayat & Detail Presensi

| No | Fitur yang diuji | Langkah pengujian | Hasil yang diharapkan | Berhasil | Gagal |
|---:|---|---|---|:---:|:---:|
| 78 | Hirarki penelusuran siswa | Siswa → Riwayat Presensi → pilih Tahun → Kelas → Semester → Mapel → Pertemuan. | Daftar pertemuan tampil untuk mapel terpilih. | [ ] | [ ] |
| 79 | Buka detail presensi siswa | Pilih salah satu pertemuan dari daftar. | Halaman detail presensi siswa terbuka. | [ ] | [ ] |
| 80 | Status & keterangan presensi | Di detail, pastikan status (Hadir/Tidak Hadir/Belum Diketahui) dan keterangan (jika ada) tampil. | Informasi status dan keterangan sesuai data backend. | [ ] | [ ] |
| 81 | Informasi pertemuan | Pastikan mata pelajaran, pertemuan, tanggal, jam tampil. | Seluruh informasi pertemuan tampil konsisten. | [ ] | [ ] |
| 82 | Hasil face recognition (siswa) | Jika tersedia, pastikan daftar hasil deteksi tampil. | Data deteksi wajah terkait pertemuan tampil. | [ ] | [ ] |
| 83 | Dialog detail face recognition (siswa) | Tekan “Lihat Detail” pada salah satu item. | Dialog menampilkan gambar/akurasi/waktu/tipe match. | [ ] | [ ] |

## 14) Halaman Informasi Bersama

| No | Fitur yang diuji | Langkah pengujian | Hasil yang diharapkan | Berhasil | Gagal |
|---:|---|---|---|:---:|:---:|
| 84 | Info Sekolah | Buka halaman Info Sekolah dari peran apa pun yang menyediakan tautan. | Data Info Sekolah tampil. | [ ] | [ ] |
| 85 | Info Admin Pembuat | Buka halaman Admin Pembuat dari peran apa pun yang menyediakan tautan. | Data Admin Pembuat tampil. | [ ] | [ ] |

---

## Catatan Eksekusi
- Kolom “Berhasil”/“Gagal” dapat ditandai manual (mis. [x] untuk berhasil).
- Disarankan mencatat evidensi (screenshot/berkas hasil unduh) per kasus uji penting.
- Untuk skenario yang menyangkut file, verifikasi isi berkas secara semantik (misalnya kolom/format Excel dan kesesuaian data) tanpa mengandalkan notifikasi.

## Asumsi & Batasan
- Data uji (akun Admin/Guru/Siswa, jadwal/mapel, dataset Excel/ZIP) telah disiapkan sesuai kebutuhan setiap skenario.
- Akses jaringan ke backend terkonfigurasi dan dapat dijangkau dari perangkat uji.
- Hak akses peran sesuai implementasi (Guru hanya melihat data kelas/prodi yang diampu, dst.).

## Kriteria Keberhasilan Umum
- Fungsi berjalan sesuai deskripsi tanpa kesalahan yang menghalangi alur utama.
- Data yang ditampilkan/diubah/diunduh konsisten dengan backend.
- Preferensi pengguna (tema, ingat email) tersimpan dan termuat ulang dengan benar.

