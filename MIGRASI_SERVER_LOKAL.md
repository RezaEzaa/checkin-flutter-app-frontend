# DOKUMENTASI MIGRASI KE SERVER LOKAL
**Tanggal:** 25 Desember 2025  
**Server:** 192.168.1.17  
**Database:** u432210346_db_checkin

---

## ✅ YANG SUDAH DILAKUKAN

### 1. Frontend (Flutter)
- ✅ **Update semua URL** dari hosting → server lokal (94 lokasi)
  - Sebelum: `https://mediumvioletred-shark-913632.hostingersite.com/aplikasi-checkin/`
  - Sesudah: `http://192.168.1.17/aplikasi-checkin/`

- ✅ **AndroidManifest.xml** diupdate
  - Tambah: `android:usesCleartextTraffic="true"` (untuk HTTP)
  - Permission INTERNET & ACCESS_NETWORK_STATE sudah ada

- ✅ **File yang diupdate:**
  - Semua file di `lib/Pages/Admin/*.dart`
  - Semua file di `lib/Pages/Teacher/*.dart`
  - Semua file di `lib/Pages/Student/*.dart`
  - Semua file di `lib/Pages/shared/*.dart`

### 2. Backend
- ✅ **Server lokal berjalan** di http://192.168.1.17
- ✅ **Database** u432210346_db_checkin sudah di-import dari backup hosting
- ✅ **File backend** sudah di-copy ke htdocs

### 3. Testing
- ✅ Backend root accessible
- ✅ Database connection OK
- ✅ Face Recognition API accessible
- ⚠️ Login endpoints: 400 (normal untuk GET request tanpa body)
- ⚠️ Upload folder: Perlu copy files dari backup

---

## 📋 CHECKLIST SEBELUM TESTING DI ANDROID

### Server Requirements
- [ ] Apache/XAMPP running
- [ ] MySQL service running
- [ ] IP address 192.168.1.17 sudah set statis
- [ ] Firewall allow port 80
- [ ] Test dari browser: http://192.168.1.17/aplikasi-checkin/

### Files & Folders
- [ ] Folder `uploads/siswa/` ada dan berisi default.png
- [ ] Folder `uploads/guru/` ada dan berisi default.png
- [ ] Folder `uploads/admin/` ada
- [ ] Folder `uploads/face_recognition/` ada
- [ ] Database memiliki data test (minimal 1 admin, 1 guru, 1 siswa)

### Network
- [ ] Android device terhubung ke WiFi yang sama
- [ ] Device bisa ping 192.168.1.17
- [ ] Test dari browser mobile: http://192.168.1.17/aplikasi-checkin/

---

## 🧪 CARA TESTING

### Test dari Browser (Desktop)
```
http://192.168.1.17/aplikasi-checkin/
http://192.168.1.17/aplikasi-checkin/pages/admin/login_admin.php
http://192.168.1.17/aplikasi-checkin/uploads/siswa/default.png
```

### Test dari Browser Mobile (Android)
1. Hubungkan phone ke WiFi yang sama
2. Buka browser
3. Akses: http://192.168.1.17/aplikasi-checkin/
4. Pastikan halaman muncul

### Test dari Flutter App
```bash
# Build APK
flutter clean
flutter pub get
flutter build apk --release

# Install di device
# File: build/app/outputs/flutter-apk/CheckIn.apk

# Test fitur:
1. Login Admin
2. Login Guru
3. Login Siswa
4. Lihat profil (test load image)
5. Buat presensi
6. Face recognition
```

---

## 🔧 TROUBLESHOOTING

### Issue: "Failed to connect" di app
**Solusi:**
1. Pastikan XAMPP/Apache running
2. Cek firewall: `netsh advfirewall firewall add rule name="Apache" dir=in action=allow protocol=TCP localport=80`
3. Test ping dari Android: Settings → Network → ping 192.168.1.17
4. Pastikan device di WiFi yang sama (192.168.1.x)

### Issue: "Database connection error"
**Solusi:**
1. Check MySQL service running
2. Verify db_aplikasi_checkin.php:
   ```php
   $host = 'localhost';
   $username = 'root';
   $password = '';
   $database = 'u432210346_db_checkin';
   ```
3. Test koneksi: http://192.168.1.17/aplikasi-checkin/db_aplikasi_checkin.php

### Issue: Images tidak muncul
**Solusi:**
1. Copy folder `uploads/` dari backup hosting
2. Pastikan struktur:
   ```
   htdocs/aplikasi-checkin/uploads/
   ├── siswa/default.png
   ├── guru/default.png
   ├── admin/default.png
   └── face_recognition/
   ```
3. Set permissions (Windows: Full Control untuk folder uploads)

### Issue: "400 Bad Request" saat login
**Check:**
1. POST request dengan body JSON
2. Header: Content-Type: application/json
3. Data format benar:
   - Admin: `{"email":"...", "kata_sandi":"..."}`
   - Guru: `{"email":"..."}`
   - Siswa: `{"email":"..."}`

---

## 📱 NETWORK SETUP

### Set IP Statis di Windows
```powershell
# Via GUI:
# Control Panel → Network → Change Adapter Settings → 
# Properties → IPv4 → Use following IP:
# IP: 192.168.1.17
# Subnet: 255.255.255.0
# Gateway: 192.168.1.1
```

### Allow Apache in Firewall
```powershell
# PowerShell (Run as Admin):
netsh advfirewall firewall add rule name="Apache HTTP" dir=in action=allow protocol=TCP localport=80
netsh advfirewall firewall add rule name="Apache HTTPS" dir=in action=allow protocol=TCP localport=443
```

### Test dari PowerShell
```powershell
# Test koneksi
Invoke-WebRequest -Uri "http://192.168.1.17/aplikasi-checkin/" -Method GET

# Test login endpoint
$body = @{email="admin@test.com"; kata_sandi="test123"} | ConvertTo-Json
Invoke-WebRequest -Uri "http://192.168.1.17/aplikasi-checkin/pages/admin/login_admin.php" `
  -Method POST -Body $body -ContentType "application/json"
```

---

## 🚀 BUILD APK

```bash
# Clean project
flutter clean

# Get dependencies
flutter pub get

# Build release APK
flutter build apk --release

# Output location:
# build/app/outputs/flutter-apk/CheckIn.apk

# File size: ~70-75 MB
```

---

## 📝 PERBEDAAN HOSTING vs LOKAL

| Aspek | Hosting (Sebelum) | Lokal (Sekarang) |
|-------|------------------|------------------|
| URL | `https://mediumvioletred-shark-...` | `http://192.168.1.17` |
| Protocol | HTTPS (SSL) | HTTP (Cleartext) |
| Akses | Internet (global) | WiFi lokal only |
| Database | MySQL hosting | MySQL XAMPP |
| DB User | u432210346_xxxxx | root |
| DB Pass | (password hosting) | (kosong) |
| Upload Path | `/home/u432210346/...` | `C:\xampp\htdocs\...` |

---

## ⚠️ PENTING - SECURITY

**Karena menggunakan HTTP (bukan HTTPS):**
- ⚠️ Data tidak ter-enkripsi
- ⚠️ Hanya untuk development/testing
- ⚠️ Jangan gunakan di jaringan publik
- ⚠️ Untuk production, gunakan HTTPS

**Rekomendasi:**
- Gunakan hanya di jaringan WiFi private/terpercaya
- Untuk production deployment, kembali ke hosting dengan SSL
- Atau setup SSL certificate di server lokal (advanced)

---

## 📞 SUPPORT

Jika ada masalah:
1. Jalankan: `.\test_local_server.ps1`
2. Check log Apache: `C:\xampp\apache\logs\error.log`
3. Check log MySQL: `C:\xampp\mysql\data\*.err`
4. Check Flutter logs: `flutter logs`

---

**Status:** ✅ Frontend sudah siap untuk server lokal  
**Next:** Testing di Android device
