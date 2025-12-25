import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:checkin/Pages/settings_page.dart';
import 'package:checkin/utils/loading_indicator_utils.dart';

class AdminDataImportPage extends StatefulWidget {
  const AdminDataImportPage({super.key});
  @override
  State<AdminDataImportPage> createState() => _AdminDataImportPageState();
}

class _AdminDataImportPageState extends State<AdminDataImportPage>
    with LoadingStateMixin {
  File? sekolahFile, guruFile, siswaFile;
  String? sekolahFileName, guruFileName, siswaFileName;
  String? adminEmail;
  bool hasSekolahData = false;
  bool hasGuruData = false;
  bool hasSiswaData = false;

  Map<String, double> uploadProgress = {};
  Map<String, String> uploadStatus = {};
  Map<String, String> uploadMessages = {};

  bool isDownloadingSekolah = false;
  bool isDownloadingGuru = false;
  bool isDownloadingSiswa = false;

  String importMode = 'replace_all';
  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await loadAdminEmail();
    await checkExistingData();
  }

  Future<void> loadAdminEmail() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      adminEmail = prefs.getString('admin_email');
      hasSekolahData = prefs.getBool('has_sekolah_data') ?? false;
      hasGuruData = prefs.getBool('has_guru_data') ?? false;
      hasSiswaData = prefs.getBool('has_siswa_data') ?? false;
    });
    print("🔍 loadAdminEmail - adminEmail: '$adminEmail'");
    print(
      "🔍 loadAdminEmail - hasSekolahData: $hasSekolahData, hasGuruData: $hasGuruData, hasSiswaData: $hasSiswaData",
    );
  }

  Future<void> checkExistingData() async {
    print("🔍 checkExistingData called with adminEmail: '$adminEmail'");
    if (adminEmail == null) {
      print("❌ checkExistingData: adminEmail is null, skipping");
      return;
    }
    final dio = Dio();
    try {
      final formData = FormData.fromMap({
        'admin_email': adminEmail,
        'check_type': 'all',
      });
      final resp = await dio.post(
        'http://192.168.1.17/aplikasi-checkin/pages/admin/check_upload_status.php',
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
          responseType: ResponseType.plain,
        ),
      );
      print("Check Status Response Code: ${resp.statusCode}");
      print("Check Status Response Data: ${resp.data}");
      if (resp.statusCode == 200) {
        final responseData = json.decode(resp.data);
        print("🔍 checkExistingData - Full Response: $responseData");
        if (responseData['status'] == true && responseData['data'] != null) {
          final data = responseData['data'];
          print("🔍 checkExistingData - Data section: $data");
          final prefs = await SharedPreferences.getInstance();
          setState(() {
            hasSekolahData = data['sekolah']?['excel_exists'] ?? false;
            hasGuruData = data['guru']?['excel_exists'] ?? false;
            hasSiswaData = data['siswa']?['excel_exists'] ?? false;
          });
          await prefs.setBool('has_sekolah_data', hasSekolahData);
          await prefs.setBool('has_guru_data', hasGuruData);
          await prefs.setBool('has_siswa_data', hasSiswaData);
          print("✅ Status check berhasil:");
          print("   Sekolah: $hasSekolahData");
          print("   Guru: $hasGuruData");
          print("   Siswa: $hasSiswaData");
        }
      }
    } catch (e) {
      print('Error checking existing data: $e');
      await _checkIndividualData();
    }
  }

  Future<void> _checkIndividualData() async {
    final dio = Dio();
    try {
      final sekolahFormData = FormData.fromMap({'admin_email': adminEmail});
      final sekolahResp = await dio.post(
        'http://192.168.1.17/aplikasi-checkin/pages/admin/check_sekolah_status.php',
        data: sekolahFormData,
        options: Options(
          contentType: 'multipart/form-data',
          responseType: ResponseType.plain,
        ),
      );
      if (sekolahResp.statusCode == 200) {
        final sekolahData = json.decode(sekolahResp.data);
        print("🔍 Sekolah Status Response: $sekolahData");
        hasSekolahData = sekolahData['has_data'] ?? false;
        print("🔍 hasSekolahData: $hasSekolahData");
      }
      final guruFormData = FormData.fromMap({
        'admin_email': adminEmail,
        'type': 'guru',
      });
      final guruResp = await dio.post(
        'http://192.168.1.17/aplikasi-checkin/pages/admin/check_guru_siswa_status.php',
        data: guruFormData,
        options: Options(
          contentType: 'multipart/form-data',
          responseType: ResponseType.plain,
        ),
      );
      if (guruResp.statusCode == 200) {
        final guruData = json.decode(guruResp.data);
        print("🔍 Guru Status Response: $guruData");
        hasGuruData = guruData['data']?['excel_exists'] ?? false;
        print("🔍 hasGuruData: $hasGuruData");
      }
      final siswaFormData = FormData.fromMap({
        'admin_email': adminEmail,
        'type': 'siswa',
      });
      final siswaResp = await dio.post(
        'http://192.168.1.17/aplikasi-checkin/pages/admin/check_guru_siswa_status.php',
        data: siswaFormData,
        options: Options(
          contentType: 'multipart/form-data',
          responseType: ResponseType.plain,
        ),
      );
      if (siswaResp.statusCode == 200) {
        final siswaData = json.decode(siswaResp.data);
        print("🔍 Siswa Status Response: $siswaData");
        hasSiswaData = siswaData['data']?['excel_exists'] ?? false;
        print("🔍 hasSiswaData: $hasSiswaData");
      }
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('has_sekolah_data', hasSekolahData);
      await prefs.setBool('has_guru_data', hasGuruData);
      await prefs.setBool('has_siswa_data', hasSiswaData);
      print("✅ _checkIndividualData completed:");
      print("   Sekolah: $hasSekolahData");
      print("   Guru: $hasGuruData");
      print("   Siswa: $hasSiswaData");
      setState(() {});
    } catch (e) {
      print('Error in individual data check: $e');
    }
  }

  Future<int> _androidVersion() async {
    final deviceInfo = DeviceInfoPlugin();
    final androidInfo = await deviceInfo.androidInfo;
    return androidInfo.version.sdkInt;
  }

  Future<bool> _showImportModeDialog(VoidCallback onProceed) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Row(
                children: [
                  Icon(Icons.upload_file, color: Colors.blue),
                  SizedBox(width: 8),
                  Text('Pilih Mode Import'),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Pilih mode import data:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 16),

                  RadioListTile<String>(
                    title: const Text('Ganti Semua Data'),
                    subtitle: const Text(
                      'Hapus data lama dan ganti dengan data baru (mode default)',
                      style: TextStyle(fontSize: 12),
                    ),
                    value: 'replace_all',
                    groupValue: importMode,
                    onChanged: (String? value) {
                      setState(() {
                        importMode = value!;
                      });
                    },
                  ),

                  RadioListTile<String>(
                    title: const Text('Tambah Data Baru'),
                    subtitle: const Text(
                      'Tambahkan data baru tanpa menghapus data yang sudah ada',
                      style: TextStyle(fontSize: 12),
                    ),
                    value: 'add_new',
                    groupValue: importMode,
                    onChanged: (String? value) {
                      setState(() {
                        importMode = value!;
                      });
                    },
                  ),

                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info, color: Colors.blue, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            importMode == 'replace_all'
                                ? 'Data lama akan dihapus dan diganti dengan data baru'
                                : 'Data baru akan ditambahkan, data lama tetap ada',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.blue[700],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Batal'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Lanjutkan'),
                ),
              ],
            );
          },
        );
      },
    );

    if (result == true) {
      onProceed();
    }

    return result ?? false;
  }

  Future<void> pickFile(String type) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'xls'],
    );
    if (result != null && result.files.single.path != null) {
      final file = File(result.files.single.path!);
      setState(() {
        if (type == 'sekolah') sekolahFile = file;
        if (type == 'guru') guruFile = file;
        if (type == 'siswa') siswaFile = file;
      });
    }
  }

  Future<void> uploadAllFiles() async {
    if (adminEmail == null) {
      showError("Email admin tidak ditemukan");
      return;
    }
    final fileMap = {
      'sekolah': sekolahFile,
      'guru': guruFile,
      'siswa': siswaFile,
    };
    bool hasFiles = fileMap.values.any((file) => file != null);
    if (!hasFiles) {
      Fluttertoast.showToast(
        msg: "Pilih minimal satu file untuk diproses",
        toastLength: Toast.LENGTH_SHORT,
      );
      return;
    }

    uploadProgress.clear();
    uploadStatus.clear();
    uploadMessages.clear();

    for (var entry in fileMap.entries) {
      if (entry.value != null) {
        uploadProgress[entry.key] = 0.0;
        uploadStatus[entry.key] = 'loading';
        uploadMessages[entry.key] = 'Mempersiapkan upload...';
      }
    }
    setState(() {});

    bool isFirstTimeUpload = !hasSekolahData && !hasGuruData && !hasSiswaData;

    if (isFirstTimeUpload) {
      await _processAllFiles(fileMap);
    } else {
      final shouldProceed = await _showImportModeDialog(
        () => _processAllFiles(fileMap),
      );
      if (!shouldProceed) {
        // User cancelled, clear upload status
        setState(() {
          uploadProgress.clear();
          uploadStatus.clear();
          uploadMessages.clear();
        });
        print("⚠️ User cancelled import dialog");
        return;
      }
    }
  }

  Future<void> _processAllFiles(Map<String, File?> fileMap) async {
    setLoading('uploadAll', true);

    for (var entry in fileMap.entries) {
      if (entry.value != null) {
        uploadStatus[entry.key] = 'loading';
        uploadMessages[entry.key] = 'Memulai upload...';
        setState(() {});
      }
    }

    bool isFirstTimeUpload = !hasSekolahData && !hasGuruData && !hasSiswaData;

    if (isFirstTimeUpload) {
      await _processFirstTimeUpload(fileMap);
    } else {
      await _processUpdateFiles(fileMap);
    }

    setLoading('uploadAll', false);
  }

  Future<void> _processFirstTimeUpload(Map<String, File?> fileMap) async {
    final dio = Dio();
    print("🆕 Menggunakan import_data.php untuk upload pertama kali");

    try {
      final formData = FormData.fromMap({'admin_email': adminEmail});

      for (var entry in fileMap.entries) {
        final type = entry.key;
        final file = entry.value;
        if (file != null) {
          formData.files.add(
            MapEntry(
              type,
              await MultipartFile.fromFile(
                file.path,
                filename: file.path.split('/').last,
              ),
            ),
          );
          print("📎 Menambahkan file $type: ${file.path.split('/').last}");
        }
      }

      final resp = await dio.post(
        'http://192.168.1.17/aplikasi-checkin/pages/admin/import_data.php',
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
          responseType: ResponseType.plain,
        ),
      );

      print("📥 Import Response Status: ${resp.statusCode}");
      print("📥 Import Response Data: ${resp.data}");

      if (resp.statusCode == 200 && resp.data != null) {
        try {
          final json = jsonDecode(resp.data.toString());

          if (json['status'] == 'success') {
            for (var entry in fileMap.entries) {
              final type = entry.key;
              final file = entry.value;
              if (file != null) {
                if (type == 'sekolah') hasSekolahData = true;
                if (type == 'guru') hasGuruData = true;
                if (type == 'siswa') hasSiswaData = true;
              }
            }

            showSuccess("✅ Semua data berhasil diimpor!");

            final prefs = await SharedPreferences.getInstance();
            await prefs.setBool('has_sekolah_data', hasSekolahData);
            await prefs.setBool('has_guru_data', hasGuruData);
            await prefs.setBool('has_siswa_data', hasSiswaData);
          } else {
            showError("❌ Import gagal: ${json['message']}");
          }

          if (json.containsKey('log')) {
            print("📝 Log Backend Import:");
            for (var line in json['log']) {
              print("  • $line");
            }
          }
        } catch (e) {
          print("🛑 JSON Decode Error: $e");
          showError("❌ Format respon tidak valid: $e");
        }
      } else {
        throw Exception('HTTP Error ${resp.statusCode}');
      }
    } catch (e) {
      print("❌ Import Error: $e");
      showError("❌ Import gagal: $e");
    }

    setState(() {
      sekolahFile = null;
      sekolahFileName = null;
      guruFile = null;
      guruFileName = null;
      siswaFile = null;
      siswaFileName = null;
    });

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          uploadProgress.clear();
          uploadStatus.clear();
          uploadMessages.clear();
        });
      }
    });

    await checkExistingData();
  }

  Future<void> _processUpdateFiles(Map<String, File?> fileMap) async {
    final dio = Dio();
    print("🔄 Menggunakan endpoint update untuk data yang sudah ada");

    for (var entry in fileMap.entries) {
      final type = entry.key;
      final file = entry.value;
      if (file == null) continue;

      String endpoint;
      FormData formData;

      if (type == 'sekolah') {
        endpoint =
            'http://192.168.1.17/aplikasi-checkin/pages/admin/update_data_sekolah.php';
        formData = FormData.fromMap({
          'admin_email': adminEmail,
          'import_mode': importMode,
          'file': await MultipartFile.fromFile(
            file.path,
            filename: file.path.split('/').last,
          ),
        });
      } else {
        endpoint =
            'http://192.168.1.17/aplikasi-checkin/pages/admin/update_data_guru_siswa.php';
        formData = FormData.fromMap({
          'admin_email': adminEmail,
          'type': type,
          'import_mode': importMode,
          'file': await MultipartFile.fromFile(
            file.path,
            filename: file.path.split('/').last,
          ),
        });
      }

      try {
        final resp = await dio.post(
          endpoint,
          data: formData,
          options: Options(
            contentType: 'multipart/form-data',
            responseType: ResponseType.plain,
          ),
        );
        print("Update Status Code [$type]: ${resp.statusCode}");
        print("Update Response Raw Data [$type]: ${resp.data}");

        if (resp.data == null || resp.data.toString().trim().isEmpty) {
          showError("[$type] Tidak ada respons dari server.");
          continue;
        }

        late Map<String, dynamic> json;
        try {
          json = jsonDecode(resp.data.toString());
        } catch (e) {
          showError("[$type] Format respon tidak valid.");
          print("🛑 JSON Decode Error [$type]: $e");
          print("🛑 Response content: ${resp.data}");
          continue;
        }

        if (json['status'] == 'success') {
          String successMsg = "✅ $type berhasil diperbarui!";
          if (type != 'sekolah' && json.containsKey('log')) {
            final logs = json['log'] as List;
            for (String logLine in logs) {
              if (logLine.contains('Summary $type')) {
                final summaryLine = logLine.replaceFirst(
                  '📊 Summary $type - ',
                  '',
                );
                successMsg += "\n📊 $summaryLine";
                break;
              }
            }
          }
          showSuccess(successMsg);

          if (type == 'sekolah') {
            hasSekolahData = true;
          } else if (type == 'guru') {
            hasGuruData = true;
          } else if (type == 'siswa') {
            hasSiswaData = true;
          }
        } else {
          showError("❌ $type gagal: ${json['message']}");
        }

        if (json.containsKey('log')) {
          print("📝 Log Backend [$type]:");
          for (var line in json['log']) {
            print("  • $line");
          }
        }
      } catch (e) {
        showError("❌ $type gagal: $e");
        print("❌ Process Error [$type]: $e");
      }
    }

    setState(() {
      sekolahFile = null;
      sekolahFileName = null;
      guruFile = null;
      guruFileName = null;
      siswaFile = null;
      siswaFileName = null;
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_sekolah_data', hasSekolahData);
    await prefs.setBool('has_guru_data', hasGuruData);
    await prefs.setBool('has_siswa_data', hasSiswaData);

    // Clear upload status after completion
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          uploadProgress.clear();
          uploadStatus.clear();
          uploadMessages.clear();
        });
      }
    });

    await checkExistingData();
  }

  Future<void> uploadIndividual(String type) async {
    if (adminEmail == null) {
      showError("Email admin tidak ditemukan");
      return;
    }
    File? selectedFile;
    if (type == 'sekolah') selectedFile = sekolahFile;
    if (type == 'guru') selectedFile = guruFile;
    if (type == 'siswa') selectedFile = siswaFile;
    if (selectedFile == null) {
      Fluttertoast.showToast(
        msg: "Pilih file $type terlebih dahulu",
        toastLength: Toast.LENGTH_SHORT,
      );
      return;
    }

    // Check if data already exists
    bool hasExisting = false;
    if (type == 'sekolah') hasExisting = hasSekolahData;
    if (type == 'guru') hasExisting = hasGuruData;
    if (type == 'siswa') hasExisting = hasSiswaData;

    if (hasExisting) {
      // If data exists, show import mode dialog for update
      final shouldProceed = await _showImportModeDialog(
        () => _processDataUpdate(type, selectedFile!),
      );
      if (!shouldProceed) {
        setState(() {
          uploadProgress.remove(type);
          uploadStatus.remove(type);
          uploadMessages.remove(type);
        });
        print("⚠️ User cancelled import dialog for $type");
        return;
      }
    } else {
      // If no data exists, direct upload
      await _processIndividualUpload(type, selectedFile);
    }
  }

  Future<void> _processIndividualUpload(String type, File selectedFile) async {
    setLoading('upload_$type', true);
    uploadStatus[type] = 'loading';
    uploadMessages[type] = 'Mengunggah data $type...';
    uploadProgress[type] = 0.0;
    setState(() {});

    final dio = Dio();
    print("🆕 Menggunakan upload individual untuk $type");

    try {
      uploadProgress[type] = 0.3;
      uploadMessages[type] = 'Mengirim data ke server...';
      setState(() {});

      String endpoint;
      FormData formData;

      if (type == 'sekolah') {
        endpoint =
            'http://192.168.1.17/aplikasi-checkin/pages/admin/import_data.php';
        formData = FormData.fromMap({
          'admin_email': adminEmail,
          type: await MultipartFile.fromFile(
            selectedFile.path,
            filename: selectedFile.path.split('/').last,
          ),
        });
      } else {
        endpoint =
            'http://192.168.1.17/aplikasi-checkin/pages/admin/import_data.php';
        formData = FormData.fromMap({
          'admin_email': adminEmail,
          type: await MultipartFile.fromFile(
            selectedFile.path,
            filename: selectedFile.path.split('/').last,
          ),
        });
      }

      final resp = await dio.post(
        endpoint,
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
          responseType: ResponseType.plain,
        ),
      );

      uploadProgress[type] = 1.0;
      uploadMessages[type] = 'Memproses data...';
      setState(() {});

      print("Upload Status Code [$type]: ${resp.statusCode}");
      print("Upload Response Raw Data [$type]: ${resp.data}");

      if (resp.data == null || resp.data.toString().trim().isEmpty) {
        uploadStatus[type] = 'error';
        uploadMessages[type] = "Tidak ada respons dari server";
        showError("[$type] Tidak ada respons dari server.");
        return;
      }

      late Map<String, dynamic> json;
      try {
        json = jsonDecode(resp.data.toString());
      } catch (e) {
        uploadStatus[type] = 'error';
        uploadMessages[type] = "Format respon tidak valid";
        showError("[$type] Format respon tidak valid.");
        print("🛑 Upload JSON Decode Error [$type]: $e");
        return;
      }

      if (json['status'] == 'success') {
        uploadStatus[type] = 'success';
        uploadMessages[type] = "Berhasil diunggah";

        showSuccess("Upload data $type berhasil!");

        setState(() {
          if (type == 'sekolah') {
            sekolahFile = null;
            sekolahFileName = null;
            hasSekolahData = true;
          }
          if (type == 'guru') {
            guruFile = null;
            guruFileName = null;
            hasGuruData = true;
          }
          if (type == 'siswa') {
            siswaFile = null;
            siswaFileName = null;
            hasSiswaData = true;
          }
        });

        final prefs = await SharedPreferences.getInstance();
        if (type == 'sekolah') {
          await prefs.setBool('has_sekolah_data', true);
        } else if (type == 'guru') {
          await prefs.setBool('has_guru_data', true);
        } else if (type == 'siswa') {
          await prefs.setBool('has_siswa_data', true);
        }
      } else {
        uploadStatus[type] = 'error';
        uploadMessages[type] = json['message'] ?? 'Upload gagal';
        showError("Upload $type gagal: ${json['message']}");
      }

      if (json.containsKey('log')) {
        print("📝 Upload Log Backend [$type]:");
        for (var line in json['log']) {
          print("  • $line");
        }
      }
    } catch (e) {
      uploadStatus[type] = 'error';
      uploadMessages[type] = "Error: $e";
      showError("Upload $type gagal: $e");
      print("❌ Upload Error [$type]: $e");
    }

    setLoading('upload_$type', false);

    // Clear upload status for this type after completion
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          uploadProgress.remove(type);
          uploadStatus.remove(type);
          uploadMessages.remove(type);
        });
      }
    });

    setState(() {});
    await checkExistingData();
  }

  Future<void> _processDataUpdate(String type, File selectedFile) async {
    setLoading('update_$type', true);
    uploadStatus[type] = 'loading';
    uploadMessages[type] = 'Memperbarui data $type...';
    uploadProgress[type] = 0.0;
    setState(() {});

    final dio = Dio();
    print("🔄 Menggunakan endpoint update untuk data $type");

    String endpoint;
    FormData formData;

    if (type == 'sekolah') {
      endpoint =
          'http://192.168.1.17/aplikasi-checkin/pages/admin/update_data_sekolah.php';
      formData = FormData.fromMap({
        'admin_email': adminEmail,
        'import_mode': importMode,
        'file': await MultipartFile.fromFile(
          selectedFile.path,
          filename: selectedFile.path.split('/').last,
        ),
      });
    } else {
      endpoint =
          'http://192.168.1.17/aplikasi-checkin/pages/admin/update_data_guru_siswa.php';
      formData = FormData.fromMap({
        'admin_email': adminEmail,
        'type': type,
        'import_mode': importMode,
        'file': await MultipartFile.fromFile(
          selectedFile.path,
          filename: selectedFile.path.split('/').last,
        ),
      });
    }

    try {
      uploadProgress[type] = 0.5;
      uploadMessages[type] = 'Mengirim data ke server...';
      setState(() {});

      final resp = await dio.post(
        endpoint,
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
          responseType: ResponseType.plain,
        ),
      );

      uploadProgress[type] = 1.0;
      uploadMessages[type] = 'Memproses data...';
      setState(() {});

      print("Update Status Code [$type]: ${resp.statusCode}");
      print("Update Response Raw Data [$type]: ${resp.data}");

      if (resp.data == null || resp.data.toString().trim().isEmpty) {
        uploadStatus[type] = 'error';
        uploadMessages[type] = "Tidak ada respons dari server";
        showError("[$type] Tidak ada respons dari server.");
        return;
      }

      late Map<String, dynamic> json;
      try {
        json = jsonDecode(resp.data.toString());
      } catch (e) {
        uploadStatus[type] = 'error';
        uploadMessages[type] = "Format respon tidak valid";
        showError("[$type] Format respon tidak valid.");
        print("🛑 Update JSON Decode Error [$type]: $e");
        return;
      }

      if (json['status'] == 'success') {
        uploadStatus[type] = 'success';
        uploadMessages[type] = "Berhasil diperbarui";

        String successMsg = "Update data $type berhasil!";
        if (json.containsKey('log')) {
          final logs = json['log'] as List;
          for (String logLine in logs) {
            if (logLine.contains('Summary $type')) {
              final summaryLine = logLine.replaceFirst(
                '📊 Summary $type - ',
                '',
              );
              successMsg += "\n📊 $summaryLine";
              break;
            }
          }
        }
        showSuccess(successMsg);

        setState(() {
          if (type == 'sekolah') {
            sekolahFile = null;
            sekolahFileName = null;
            hasSekolahData = true;
          }
          if (type == 'guru') {
            guruFile = null;
            guruFileName = null;
            hasGuruData = true;
          }
          if (type == 'siswa') {
            siswaFile = null;
            siswaFileName = null;
            hasSiswaData = true;
          }
        });

        final prefs = await SharedPreferences.getInstance();
        if (type == 'sekolah') {
          await prefs.setBool('has_sekolah_data', true);
        } else if (type == 'guru') {
          await prefs.setBool('has_guru_data', true);
        } else if (type == 'siswa') {
          await prefs.setBool('has_siswa_data', true);
        }
      } else {
        uploadStatus[type] = 'error';
        uploadMessages[type] = json['message'] ?? 'Update gagal';
        showError("Update $type gagal: ${json['message']}");
      }

      if (json.containsKey('log')) {
        print("📝 Update Log Backend [$type]:");
        for (var line in json['log']) {
          print("  • $line");
        }
      }
    } catch (e) {
      uploadStatus[type] = 'error';
      uploadMessages[type] = "Error: $e";
      showError("Update $type gagal: $e");
      print("❌ Update Error [$type]: $e");
    }

    setLoading('update_$type', false);

    // Clear upload status for this type after completion
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          uploadProgress.remove(type);
          uploadStatus.remove(type);
          uploadMessages.remove(type);
        });
      }
    });

    setState(() {});
    await checkExistingData();
  }

  Future<void> download(String type) async {
    setState(() {
      if (type == 'sekolah') isDownloadingSekolah = true;
      if (type == 'guru') isDownloadingGuru = true;
      if (type == 'siswa') isDownloadingSiswa = true;
    });

    try {
      if (Platform.isAndroid && (await _androidVersion() <= 29)) {
        final status = await Permission.storage.request();
        if (!status.isGranted) throw Exception("Izin penyimpanan ditolak");
      }

      final dio = Dio();
      final url =
          'http://192.168.1.17/aplikasi-checkin/pages/admin/download_file_excel.php?file=$type';
      final tempDir = await getTemporaryDirectory();
      final tempPath = '${tempDir.path}/$type.xlsx';
      print("🔄 Mencoba download file: $type");
      print("📍 URL: $url");
      print("💾 Temp path: $tempPath");

      final checkResponse = await dio.get(
        url,
        options: Options(
          responseType: ResponseType.stream,
          receiveTimeout: const Duration(seconds: 30),
          sendTimeout: const Duration(seconds: 30),
          validateStatus: (status) {
            return status != null && status >= 200 && status < 400;
          },
        ),
      );
      print("✅ Response status: ${checkResponse.statusCode}");
      print("📋 Response headers: ${checkResponse.headers}");
      await checkResponse.data.stream.drain();

      final response = await dio.get(
        url,
        options: Options(
          responseType: ResponseType.bytes,
          receiveTimeout: const Duration(seconds: 60),
          sendTimeout: const Duration(seconds: 30),
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final file = File(tempPath);
        await file.writeAsBytes(response.data);
        print("✅ File berhasil ditulis ke: $tempPath");
        print("📊 Ukuran file: ${await file.length()} bytes");

        if (await file.length() == 0) {
          throw Exception("File yang didownload kosong");
        }

        final params = SaveFileDialogParams(
          sourceFilePath: tempPath,
          fileName: '$type.xlsx',
        );
        final savedPath = await FlutterFileDialog.saveFile(params: params);

        if (savedPath != null) {
          Fluttertoast.showToast(
            msg: '✅ Berhasil mengunduh: $type.xlsx',
            toastLength: Toast.LENGTH_LONG,
          );
          print("✅ File disimpan ke: $savedPath");
        } else {
          Fluttertoast.showToast(msg: '❌ Download dibatalkan pengguna');
        }
      } else {
        throw Exception("Response tidak valid: ${response.statusCode}");
      }
    } on DioException catch (e) {
      String errorMsg = 'Gagal mengunduh $type: ';
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
          errorMsg += 'Koneksi timeout';
          break;
        case DioExceptionType.sendTimeout:
          errorMsg += 'Timeout saat mengirim request';
          break;
        case DioExceptionType.receiveTimeout:
          errorMsg += 'Timeout saat menerima data';
          break;
        case DioExceptionType.badResponse:
          errorMsg += 'Bad response (${e.response?.statusCode})';
          if (e.response?.data != null) {
            try {
              final errorData = e.response!.data;
              if (errorData is String) {
                final jsonError = json.decode(errorData);
                if (jsonError['message'] != null) {
                  errorMsg += ': ${jsonError['message']}';
                }
              }
            } catch (_) {
              errorMsg += ': ${e.response!.data}';
            }
          }
          break;
        case DioExceptionType.connectionError:
          errorMsg += 'Tidak dapat terhubung ke server';
          break;
        case DioExceptionType.badCertificate:
          errorMsg += 'Masalah sertifikat SSL';
          break;
        case DioExceptionType.cancel:
          errorMsg += 'Request dibatalkan';
          break;
        case DioExceptionType.unknown:
          errorMsg += 'Error tidak dikenal: ${e.message}';
          break;
      }
      print("❌ DioException: $errorMsg");
      print("❌ Error details: ${e.toString()}");
      Fluttertoast.showToast(msg: errorMsg, toastLength: Toast.LENGTH_LONG);
    } catch (e) {
      final errorMsg = 'Gagal mengunduh $type: $e';
      print("❌ General Error: $errorMsg");
      Fluttertoast.showToast(msg: errorMsg, toastLength: Toast.LENGTH_LONG);
    } finally {
      setState(() {
        if (type == 'sekolah') isDownloadingSekolah = false;
        if (type == 'guru') isDownloadingGuru = false;
        if (type == 'siswa') isDownloadingSiswa = false;
      });
    }
  }

  Widget buildFileTile({
    required String label,
    required File? file,
    required String? lastUploadedName,
    required VoidCallback onPick,
    required VoidCallback onDownload,
    required Color color,
    required IconData icon,
    required bool hasExistingData,
    VoidCallback? onUpdate,
  }) {
    String type = '';
    if (label.contains('Sekolah')) type = 'sekolah';
    if (label.contains('Guru')) type = 'guru';
    if (label.contains('Siswa')) type = 'siswa';

    bool isDownloading = false;
    if (label.contains('Sekolah')) {
      isDownloading = isDownloadingSekolah;
    } else if (label.contains('Guru')) {
      isDownloading = isDownloadingGuru;
    } else if (label.contains('Siswa')) {
      isDownloading = isDownloadingSiswa;
    }

    bool isUpdating = isLoading('update_$type');
    String? currentStatus = uploadStatus[type];
    String? currentMessage = uploadMessages[type];

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          ListTile(
            leading: Icon(icon, size: 36, color: color),
            title: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  file?.path.split('/').last ??
                      lastUploadedName ??
                      'Pilih File',
                  style: const TextStyle(fontSize: 13),
                ),
                if (hasExistingData)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.green.withOpacity(0.3)),
                    ),
                    child: const Text(
                      'Data sudah ada',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.green,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                if (currentStatus != null && currentMessage != null)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color:
                          currentStatus == 'loading'
                              ? Colors.blue.withOpacity(0.1)
                              : currentStatus == 'success'
                              ? Colors.green.withOpacity(0.1)
                              : Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      children: [
                        if (currentStatus == 'loading')
                          const SizedBox(
                            width: 12,
                            height: 12,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        if (currentStatus == 'loading')
                          const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            currentMessage,
                            style: TextStyle(
                              fontSize: 10,
                              color:
                                  currentStatus == 'loading'
                                      ? Colors.blue[700]
                                      : currentStatus == 'success'
                                      ? Colors.green[700]
                                      : Colors.red[700],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.drive_file_move_outline),
                  onPressed:
                      (isDownloading ||
                              isUpdating ||
                              (currentStatus == 'loading'))
                          ? null
                          : onPick,
                  tooltip: "Pilih File",
                  color:
                      (isDownloading ||
                              isUpdating ||
                              (currentStatus == 'loading'))
                          ? Colors.grey
                          : Colors.green,
                ),
                IconButton(
                  icon:
                      (isDownloading || (currentStatus == 'loading'))
                          ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                          : const Icon(Icons.download),
                  onPressed:
                      (isDownloading ||
                              isUpdating ||
                              (currentStatus == 'loading') ||
                              !hasExistingData)
                          ? null
                          : onDownload,
                  tooltip:
                      hasExistingData
                          ? "Unduh Data Excel"
                          : "Belum ada data untuk diunduh",
                  color:
                      (isDownloading ||
                              isUpdating ||
                              (currentStatus == 'loading') ||
                              !hasExistingData)
                          ? Colors.grey
                          : Colors.blue,
                ),
                if (file != null)
                  IconButton(
                    icon:
                        (isUpdating || (currentStatus == 'loading'))
                            ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                            : Icon(
                              hasExistingData
                                  ? Icons.update
                                  : Icons.cloud_upload,
                            ),
                    onPressed:
                        (isDownloading ||
                                isUpdating ||
                                (currentStatus == 'loading'))
                            ? null
                            : () => uploadIndividual(type),
                    tooltip: hasExistingData ? "Update Data" : "Upload Data",
                    color:
                        (isDownloading ||
                                isUpdating ||
                                (currentStatus == 'loading'))
                            ? Colors.grey
                            : (hasExistingData ? Colors.orange : Colors.indigo),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 25),
              Image.asset('asset/images/logo.png', width: 120, height: 30),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Icon(
                  Icons.cloud_upload_outlined,
                  size: 80,
                  color: Colors.green,
                ),
                const SizedBox(height: 16),
                const Text(
                  "Kelola Data Excel",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'TitilliumWeb',
                  ),
                ),
                const SizedBox(height: 20),
                buildFileTile(
                  label: 'File Data Sekolah',
                  file: sekolahFile,
                  lastUploadedName: sekolahFileName,
                  onPick: () => pickFile('sekolah'),
                  onDownload: () => download('sekolah'),
                  icon: Icons.school,
                  color: Colors.teal,
                  hasExistingData: hasSekolahData,
                  onUpdate: () => uploadIndividual('sekolah'),
                ),
                buildFileTile(
                  label: 'File Data Guru',
                  file: guruFile,
                  lastUploadedName: guruFileName,
                  onPick: () => pickFile('guru'),
                  onDownload: () => download('guru'),
                  icon: Icons.person,
                  color: Colors.indigo,
                  hasExistingData: hasGuruData,
                  onUpdate: () => uploadIndividual('guru'),
                ),
                buildFileTile(
                  label: 'File Data Siswa',
                  file: siswaFile,
                  lastUploadedName: siswaFileName,
                  onPick: () => pickFile('siswa'),
                  onDownload: () => download('siswa'),
                  icon: Icons.group,
                  color: Colors.deepPurple,
                  hasExistingData: hasSiswaData,
                  onUpdate: () => uploadIndividual('siswa'),
                ),

                if (uploadStatus.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Status Upload',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (uploadStatus.isNotEmpty)
                                TextButton(
                                  onPressed: () {
                                    uploadProgress.clear();
                                    uploadStatus.clear();
                                    uploadMessages.clear();
                                    setState(() {});
                                  },
                                  child: const Text('Bersihkan Status'),
                                ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          ...uploadStatus.entries.map((entry) {
                            final type = entry.key;
                            final status = entry.value;
                            final progress = uploadProgress[type] ?? 0.0;
                            final message = uploadMessages[type] ?? '';

                            return Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color:
                                    status == 'loading'
                                        ? Colors.blue.withOpacity(0.1)
                                        : status == 'success'
                                        ? Colors.green.withOpacity(0.1)
                                        : Colors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        type.toUpperCase(),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const Spacer(),
                                      if (status == 'loading')
                                        const SizedBox(
                                          width: 16,
                                          height: 16,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        ),
                                    ],
                                  ),
                                  if (status == 'loading')
                                    LinearProgressIndicator(
                                      value: progress,
                                      backgroundColor: Colors.grey[300],
                                      valueColor:
                                          const AlwaysStoppedAnimation<Color>(
                                            Colors.blue,
                                          ),
                                    ),
                                  if (message.isNotEmpty)
                                    Text(
                                      message,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                ],
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
