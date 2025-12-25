import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:path_provider/path_provider.dart';
import 'package:checkin/Pages/settings_page.dart';
import 'package:checkin/utils/loading_indicator_utils.dart';

class DownloadTemplatePage extends StatefulWidget {
  const DownloadTemplatePage({super.key});

  @override
  State<DownloadTemplatePage> createState() => _DownloadTemplatePageState();
}

class _DownloadTemplatePageState extends State<DownloadTemplatePage>
    with LoadingStateMixin {
  Future<int> _androidVersion() async {
    final deviceInfo = DeviceInfoPlugin();
    final androidInfo = await deviceInfo.androidInfo;
    return androidInfo.version.sdkInt;
  }

  Future<bool> _downloadFileInternal(String fileName) async {
    if (Platform.isAndroid && (await _androidVersion() <= 29)) {
      final status = await Permission.storage.request();
      if (!status.isGranted) {
        throw Exception("Izin penyimpanan ditolak");
      }
    }

    final dio = Dio();
    final url =
        "http://192.168.1.17/aplikasi-checkin/pages/admin/download_templates.php?file=$fileName";
    final directory = await getTemporaryDirectory();
    final tempPath = "${directory.path}/$fileName";

    await dio.download(
      url,
      tempPath,
      onReceiveProgress: (received, total) {
        if (total != -1) {
          final progress = (received / total * 100).toStringAsFixed(1);
          debugPrint('Download progress: $progress%');
        }
      },
    );

    final params = SaveFileDialogParams(
      sourceFilePath: tempPath,
      fileName: fileName,
    );
    final savedPath = await FlutterFileDialog.saveFile(params: params);

    if (savedPath != null) {
      showSuccess('File berhasil disimpan: $fileName');
      return true;
    } else {
      showInfo('Download dibatalkan oleh pengguna');
      return false;
    }
  }

  Future<void> downloadFile(String fileName) async {
    await executeWithLoading('Mengunduh $fileName...', () async {
      await _downloadFileInternal(fileName);
    });
  }

  Future<void> downloadAllTemplates() async {
    await executeWithLoading('Mengunduh semua template...', () async {
      List<String> files = [
        'Data_Sekolah.xlsx',
        'Data_Guru.xlsx',
        'Data_Siswa.xlsx',
      ];
      int successCount = 0;

      for (String fileName in files) {
        bool success = await _downloadFileInternal(fileName);
        if (success) {
          successCount++;
        } else {
          // User cancelled, stop the process
          if (successCount > 0) {
            showInfo(
              'Download dihentikan. $successCount dari ${files.length} file berhasil diunduh.',
            );
          }
          return;
        }
      }

      showSuccess('Semua template berhasil diunduh! ($successCount file)');
    });
  }

  Widget _buildDownloadButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: LoadingButton(
        onPressed: onPressed,
        child: Container(
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
            color: color ?? Colors.blue,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.cloud_download_outlined,
                  size: 80,
                  color: Colors.green,
                ),
                const SizedBox(height: 16),
                const Text(
                  "Unduh Template Data Excel",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'TitilliumWeb',
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                const Text(
                  "Gunakan file template ini untuk menginput data sekolah, guru, dan siswa",
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                _buildDownloadButton(
                  label: "Unduh Template Data Sekolah",
                  icon: Icons.school,
                  onPressed: () => downloadFile('Data_Sekolah.xlsx'),
                  color: Colors.teal,
                ),
                _buildDownloadButton(
                  label: "Unduh Template Data Guru",
                  icon: Icons.person,
                  onPressed: () => downloadFile('Data_Guru.xlsx'),
                  color: Colors.indigo,
                ),
                _buildDownloadButton(
                  label: "Unduh Template Data Siswa",
                  icon: Icons.group,
                  onPressed: () => downloadFile('Data_Siswa.xlsx'),
                  color: Colors.deepPurple,
                ),
                const Divider(height: 40),
                _buildDownloadButton(
                  label: "Unduh Semua Template",
                  icon: Icons.download_for_offline_rounded,
                  onPressed: () => downloadAllTemplates(),
                  color: Colors.orange,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
