import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:checkin/Pages/settings_page.dart';
import 'package:fluttertoast/fluttertoast.dart';

class StudentListByClassPage extends StatefulWidget {
  final String kelas;
  final String prodi;
  final String tahunAjaran;
  const StudentListByClassPage({
    super.key,
    required this.kelas,
    required this.prodi,
    required this.tahunAjaran,
  });
  @override
  State<StudentListByClassPage> createState() => _StudentListByClassPageState();
}

class _StudentListByClassPageState extends State<StudentListByClassPage> {
  List<Map<String, dynamic>> students = [];
  bool isLoading = true;
  String? guruEmail;
  @override
  void initState() {
    super.initState();
    loadGuruEmailAndFetchStudents();
  }

  Future<void> loadGuruEmailAndFetchStudents() async {
    final prefs = await SharedPreferences.getInstance();
    guruEmail = prefs.getString('guru_email');
    debugPrint('🔍 Loaded guru_email from prefs: $guruEmail');

    if (guruEmail != null && guruEmail!.isNotEmpty) {
      await fetchStudents();
    } else {
      debugPrint('❌ No guru_email found in SharedPreferences');
      _showErrorDialog("Guru email tidak ditemukan. Silakan login ulang.");
      setState(() => isLoading = false);
    }
  }

  Future<void> fetchStudents() async {
    setState(() => isLoading = true);
    try {
      // Extract actual kelas and tahun_ajaran from the complex object
      String actualKelas = widget.kelas;
      String actualTahunAjaran = widget.tahunAjaran;

      // Check if kelas is a JSON-like string and extract the actual values
      if (widget.kelas.contains('{') && widget.kelas.contains('kelas:')) {
        debugPrint('🔧 Parsing complex kelas object: ${widget.kelas}');
        try {
          // Try to extract kelas value from string like "{kelas: X, tahun_ajaran: 2025/2026}"
          final kelasMatch = RegExp(
            r'kelas:\s*([^,}]+)',
          ).firstMatch(widget.kelas);
          final tahunMatch = RegExp(
            r'tahun_ajaran:\s*([^}]+)',
          ).firstMatch(widget.kelas);

          if (kelasMatch != null) {
            actualKelas = kelasMatch.group(1)?.trim() ?? widget.kelas;
            debugPrint('🔧 Extracted kelas: $actualKelas');
          }

          if (tahunMatch != null && widget.tahunAjaran.isEmpty) {
            actualTahunAjaran =
                tahunMatch.group(1)?.trim() ?? widget.tahunAjaran;
            debugPrint('🔧 Extracted tahun_ajaran: $actualTahunAjaran');
          }
        } catch (e) {
          debugPrint('⚠️ Failed to parse complex kelas object: $e');
          // Use original values if parsing fails
        }
      }

      final uri = Uri.parse(
        'http://192.168.1.17/aplikasi-checkin/pages/guru/get_students_by_class.php?kelas=${Uri.encodeComponent(actualKelas)}&prodi=${Uri.encodeComponent(widget.prodi)}&tahun_ajaran=${Uri.encodeComponent(actualTahunAjaran)}&guru_email=${Uri.encodeComponent(guruEmail!)}',
      );

      debugPrint('🔍 Fetching students with parameters:');
      debugPrint('   Original Kelas: ${widget.kelas}');
      debugPrint('   Actual Kelas: $actualKelas');
      debugPrint('   Prodi: ${widget.prodi}');
      debugPrint('   Original Tahun Ajaran: ${widget.tahunAjaran}');
      debugPrint('   Actual Tahun Ajaran: $actualTahunAjaran');
      debugPrint('   Guru Email: $guruEmail');
      debugPrint('📍 Request URL: $uri');

      final response = await http.get(uri);
      debugPrint('📥 Response status: ${response.statusCode}');
      debugPrint('📥 Response body: ${response.body}');

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        final data = json.decode(response.body);
        debugPrint('📊 Parsed data: $data');

        if (data['status'] == true) {
          if (data.containsKey('data') && data['data'] is List) {
            final studentList = List<Map<String, dynamic>>.from(data['data']);
            debugPrint('✅ Found ${studentList.length} students');

            // Debug each student data
            for (int i = 0; i < studentList.length && i < 3; i++) {
              debugPrint('📋 Student $i: ${studentList[i]}');
            }

            setState(() {
              students = studentList;
            });

            if (studentList.isNotEmpty) {
              _showSuccessToast(
                "Data siswa berhasil dimuat (${studentList.length} siswa).",
              );
            } else {
              debugPrint('⚠️ Student list is empty');
              _showErrorDialog("Tidak ada siswa ditemukan untuk kelas ini.");
            }
          } else {
            debugPrint(
              '❌ Data field is missing or not a List: ${data['data']}',
            );
            _showErrorDialog("Format data tidak valid dari server.");
          }
        } else {
          final message =
              data['message']?.toString() ?? "Gagal memuat data siswa.";
          debugPrint('❌ Server returned status false: $message');
          _showErrorDialog(message);
        }
      } else {
        debugPrint(
          '❌ Invalid response: Status ${response.statusCode}, Body: ${response.body}',
        );
        _showErrorDialog("Gagal koneksi. Status ${response.statusCode}.");
      }
    } catch (e) {
      debugPrint('❌ Error in fetchStudents: $e');
      debugPrint('❌ Error type: ${e.runtimeType}');
      _showErrorDialog("Kesalahan: ${e.toString()}");
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _showSuccessToast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.grey[700],
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  void _showErrorDialog(String msg) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Terjadi Kesalahan'),
            content: Text(msg),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Extract actual kelas for display
    String displayKelas = widget.kelas;
    if (widget.kelas.contains('{') && widget.kelas.contains('kelas:')) {
      final kelasMatch = RegExp(r'kelas:\s*([^,}]+)').firstMatch(widget.kelas);
      if (kelasMatch != null) {
        displayKelas = kelasMatch.group(1)?.trim() ?? widget.kelas;
      }
    }

    final title =
        widget.prodi.isNotEmpty
            ? '$displayKelas (${widget.prodi})'
            : displayKelas;

    debugPrint(
      '🎨 Building UI - isLoading: $isLoading, students count: ${students.length}',
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Image.asset('asset/images/logo.png', width: 120, height: 30),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsPage()),
                ),
          ),
        ],
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : students.isEmpty
              ? const Center(child: Text("Belum ada siswa di kelas ini"))
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Icon(
                      Icons.class_rounded,
                      color: Colors.green,
                      size: 40,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Daftar Siswa',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "$title • ${students.length} siswa",
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: fetchStudents,
                        child: ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: students.length,
                          itemBuilder: (context, index) {
                            final student = students[index];
                            final isLaki = student['jenis_kelamin'] == 'L';
                            final iconJK = isLaki ? Icons.male : Icons.female;
                            final colorJK = isLaki ? Colors.blue : Colors.pink;
                            final fotoUrl =
                                student['foto'] ??
                                'http://192.168.1.17/aplikasi-checkin/uploads/siswa/default.png';
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                vertical: 5,
                                horizontal: 0,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 2,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8.0,
                                ),
                                child: ListTile(
                                  leading: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 15,
                                        alignment: Alignment.center,
                                        child: Text(
                                          '${student['no_absen'] ?? '-'}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      CircleAvatar(
                                        radius: 25,
                                        backgroundImage: NetworkImage(fotoUrl),
                                        onBackgroundImageError: (_, __) {},
                                      ),
                                    ],
                                  ),
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          student['nama_lengkap'] ??
                                              'Nama Siswa',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Icon(iconJK, color: colorJK, size: 16),
                                    ],
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 4),
                                      Text(
                                        student['email'] ?? 'Tidak ada email',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}
