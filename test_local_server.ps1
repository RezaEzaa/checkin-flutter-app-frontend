# ========================================
# TEST LOCAL SERVER CONNECTION
# Script untuk memverifikasi koneksi ke server lokal
# ========================================

$baseUrl = "http://192.168.1.17/aplikasi-checkin"
$testResults = @()

Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "   TEST KONEKSI SERVER LOKAL" -ForegroundColor Cyan
Write-Host "   IP: 192.168.1.17" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""

# Test 1: Backend Root
Write-Host "[1/10] Testing Backend Root..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "$baseUrl/" -Method GET -TimeoutSec 5
    Write-Host "  ✅ Backend accessible (Status: $($response.StatusCode))" -ForegroundColor Green
    $testResults += "✅ Backend Root"
} catch {
    Write-Host "  ❌ Backend not accessible: $($_.Exception.Message)" -ForegroundColor Red
    $testResults += "❌ Backend Root"
}

# Test 2: Database Connection File
Write-Host "[2/10] Testing Database Connection..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "$baseUrl/db_aplikasi_checkin.php" -Method GET -TimeoutSec 5
    Write-Host "  ✅ Database file accessible (Status: $($response.StatusCode))" -ForegroundColor Green
    $testResults += "✅ Database Connection"
} catch {
    Write-Host "  ❌ Database file error: $($_.Exception.Message)" -ForegroundColor Red
    $testResults += "❌ Database Connection"
}

# Test 3: Login Admin Endpoint
Write-Host "[3/10] Testing Admin Login Endpoint..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "$baseUrl/pages/admin/login_admin.php" -Method GET -TimeoutSec 5
    Write-Host "  ✅ Admin login endpoint accessible (Status: $($response.StatusCode))" -ForegroundColor Green
    $testResults += "✅ Admin Login"
} catch {
    Write-Host "  ❌ Admin login endpoint error: $($_.Exception.Message)" -ForegroundColor Red
    $testResults += "❌ Admin Login"
}

# Test 4: Login Guru Endpoint
Write-Host "[4/10] Testing Teacher Login Endpoint..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "$baseUrl/pages/guru/login_guru.php" -Method GET -TimeoutSec 5
    Write-Host "  ✅ Teacher login endpoint accessible (Status: $($response.StatusCode))" -ForegroundColor Green
    $testResults += "✅ Teacher Login"
} catch {
    Write-Host "  ❌ Teacher login endpoint error: $($_.Exception.Message)" -ForegroundColor Red
    $testResults += "❌ Teacher Login"
}

# Test 5: Login Siswa Endpoint
Write-Host "[5/10] Testing Student Login Endpoint..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "$baseUrl/pages/siswa/login_siswa.php" -Method GET -TimeoutSec 5
    Write-Host "  ✅ Student login endpoint accessible (Status: $($response.StatusCode))" -ForegroundColor Green
    $testResults += "✅ Student Login"
} catch {
    Write-Host "  ❌ Student login endpoint error: $($_.Exception.Message)" -ForegroundColor Red
    $testResults += "❌ Student Login"
}

# Test 6: Face Recognition API
Write-Host "[6/10] Testing Face Recognition API..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "$baseUrl/api/get_face_recognition_data.php?id_presensi_siswa=1" -Method GET -TimeoutSec 5
    Write-Host "  ✅ Face recognition API accessible (Status: $($response.StatusCode))" -ForegroundColor Green
    $testResults += "✅ Face Recognition API"
} catch {
    Write-Host "  ❌ Face recognition API error: $($_.Exception.Message)" -ForegroundColor Red
    $testResults += "❌ Face Recognition API"
}

# Test 7: Uploads Folder (Default Siswa)
Write-Host "[7/10] Testing Uploads - Student Default Image..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "$baseUrl/uploads/siswa/default.png" -Method GET -TimeoutSec 5
    Write-Host "  ✅ Student uploads accessible (Status: $($response.StatusCode))" -ForegroundColor Green
    $testResults += "✅ Uploads Siswa"
} catch {
    Write-Host "  ❌ Student uploads error: $($_.Exception.Message)" -ForegroundColor Red
    $testResults += "❌ Uploads Siswa"
}

# Test 8: Uploads Folder (Default Guru)
Write-Host "[8/10] Testing Uploads - Teacher Default Image..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "$baseUrl/uploads/guru/default.png" -Method GET -TimeoutSec 5
    Write-Host "  ✅ Teacher uploads accessible (Status: $($response.StatusCode))" -ForegroundColor Green
    $testResults += "✅ Uploads Guru"
} catch {
    Write-Host "  ❌ Teacher uploads error: $($_.Exception.Message)" -ForegroundColor Red
    $testResults += "❌ Uploads Guru"
}

# Test 9: API - Get Face Recognition Image
Write-Host "[9/10] Testing Face Recognition Image API..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "$baseUrl/api/get_face_recognition_image.php?foto_path=test.jpg" -Method GET -TimeoutSec 5
    Write-Host "  ✅ Face image API accessible (Status: $($response.StatusCode))" -ForegroundColor Green
    $testResults += "✅ Face Image API"
} catch {
    Write-Host "  ⚠️  Face image API error (expected if no test.jpg): $($_.Exception.Message)" -ForegroundColor Yellow
    $testResults += "⚠️  Face Image API"
}

# Test 10: Check PHP Version
Write-Host "[10/10] Checking PHP Configuration..." -ForegroundColor Yellow
try {
    $phpInfo = "$baseUrl/phpinfo.php"
    $response = Invoke-WebRequest -Uri $phpInfo -Method GET -TimeoutSec 5 -ErrorAction SilentlyContinue
    if ($response.StatusCode -eq 200) {
        Write-Host "  ✅ PHP is running (Status: $($response.StatusCode))" -ForegroundColor Green
        $testResults += "✅ PHP Running"
    }
} catch {
    Write-Host "  ⚠️  phpinfo.php not found (optional)" -ForegroundColor Yellow
    $testResults += "⚠️  PHP Info"
}

# Summary
Write-Host ""
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "   RINGKASAN TEST" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
foreach ($result in $testResults) {
    Write-Host "  $result"
}

Write-Host ""
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "   NEXT STEPS" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "1. Pastikan semua test ✅ (success)" -ForegroundColor White
Write-Host "2. Jika ada ❌, periksa:" -ForegroundColor White
Write-Host "   - Apache/XAMPP running?" -ForegroundColor Gray
Write-Host "   - File backend sudah di copy ke htdocs?" -ForegroundColor Gray
Write-Host "   - Database sudah di-import?" -ForegroundColor Gray
Write-Host "   - Firewall allow port 80?" -ForegroundColor Gray
Write-Host "3. Test dari Android device di WiFi yang sama" -ForegroundColor White
Write-Host "4. Build APK: flutter build apk --release" -ForegroundColor White
Write-Host ""
