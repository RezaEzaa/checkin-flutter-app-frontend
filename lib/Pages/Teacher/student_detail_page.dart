import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:checkin/Pages/Teacher/student_list_by_class_page.dart';

class StudentDetailPage extends StatefulWidget {
  const StudentDetailPage({super.key});
  @override
  State<StudentDetailPage> createState() => _StudentDetailPageState();
}

class _StudentDetailPageState extends State<StudentDetailPage> {
  Map<String, List<dynamic>> prodiKelasMap = {};
  Set<String> expandedProdi = {};
  String? guruEmail;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    loadGuruEmailAndData();
  }

  Future<void> loadGuruEmailAndData() async {
    final prefs = await SharedPreferences.getInstance();
    guruEmail = prefs.getString('guru_email');
    debugPrint('🔍 Loaded guru_email from prefs: $guruEmail');

    if (guruEmail != null && guruEmail!.isNotEmpty) {
      await fetchKelasProdi();
    } else {
      debugPrint('❌ No guru_email found in SharedPreferences');
      _showErrorDialog('Email guru tidak ditemukan. Silakan login ulang.');
    }
  }

  Future<void> fetchKelasProdi() async {
    setState(() => isLoading = true);
    try {
      final response = await http.post(
        Uri.parse(
          'http://192.168.1.17/aplikasi-checkin/pages/guru/get_classes_detail.php',
        ),
        body: {'guru_email': guruEmail!},
      );

      debugPrint('📥 Response status: ${response.statusCode}');
      debugPrint('📥 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        debugPrint('📊 Parsed data: $data');

        if (data['status'] == true) {
          // Check if data field exists and is a List
          if (data.containsKey('data') && data['data'] is List) {
            final List kelasProdiList = data['data'];
            final Map<String, List<dynamic>> map = {};

            for (var item in kelasProdiList) {
              if (item is Map<String, dynamic>) {
                final String prodi = (item['prodi'] ?? '').toString();

                // Handle kelas_list - it might be a List of objects or strings
                List<dynamic> kelasList = [];
                if (item['kelas_list'] != null) {
                  if (item['kelas_list'] is List) {
                    for (var kelasItem in item['kelas_list']) {
                      if (kelasItem is Map<String, dynamic>) {
                        // If it's an object with kelas and tahun_ajaran
                        kelasList.add({
                          'kelas': kelasItem['kelas']?.toString() ?? '',
                          'tahun_ajaran':
                              kelasItem['tahun_ajaran']?.toString() ?? '',
                        });
                      } else {
                        // If it's just a string
                        kelasList.add({
                          'kelas': kelasItem.toString(),
                          'tahun_ajaran': '',
                        });
                      }
                    }
                  } else {
                    // If it's a single item
                    kelasList.add({
                      'kelas': item['kelas_list'].toString(),
                      'tahun_ajaran': '',
                    });
                  }
                }

                map[prodi] = kelasList;
                debugPrint('📊 Added prodi: $prodi with classes: $kelasList');
              }
            }

            setState(() {
              prodiKelasMap = map;
            });
          } else {
            debugPrint(
              '❌ Data field is missing or not a List: ${data['data']}',
            );
            _showErrorDialog('Format data tidak valid dari server');
          }
        } else {
          final message = data['message']?.toString() ?? 'Gagal memuat data';
          debugPrint('❌ Server returned status false: $message');
          _showErrorDialog(message);
        }
      } else {
        _showErrorDialog(
          'Gagal koneksi ke server (Status ${response.statusCode})',
        );
      }
    } catch (e) {
      debugPrint('❌ Error in fetchKelasProdi: $e');
      debugPrint('❌ Error type: ${e.runtimeType}');
      _showErrorDialog(
        "Terjadi kesalahan saat mengambil data: ${e.toString()}",
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _navigateToStudentList(String kelas, String prodi, String tahunAjaran) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => StudentListByClassPage(
              kelas: kelas,
              prodi: prodi,
              tahunAjaran: tahunAjaran,
            ),
      ),
    );
  }

  void _toggleExpandProdi(String prodi) {
    setState(() {
      if (expandedProdi.contains(prodi)) {
        expandedProdi.remove(prodi);
      } else {
        expandedProdi.add(prodi);
      }
    });
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Terjadi Kesalahan'),
            content: Text(message),
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
    return Scaffold(
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.people_alt_rounded,
                    color: Colors.green,
                    size: 40,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Data Siswa',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  prodiKelasMap.isEmpty
                      ? const Expanded(
                        child: Center(
                          child: Text(
                            'Belum ada data kelas dan prodi',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      )
                      : Expanded(
                        child: RefreshIndicator(
                          onRefresh: fetchKelasProdi,
                          child: ListView.builder(
                            itemCount: prodiKelasMap.length,
                            padding: const EdgeInsets.only(top: 10),
                            itemBuilder: (context, index) {
                              final entry = prodiKelasMap.entries.elementAt(
                                index,
                              );
                              final String prodi = entry.key;
                              final List<dynamic> kelasList = entry.value;
                              return Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 4,
                                margin: const EdgeInsets.symmetric(vertical: 6),
                                child: Column(
                                  children: [
                                    InkWell(
                                      onTap: () => _toggleExpandProdi(prodi),
                                      borderRadius: BorderRadius.circular(16),
                                      child: ListTile(
                                        leading: Icon(
                                          prodi.isNotEmpty
                                              ? Icons.school
                                              : Icons.group,
                                          color: Colors.green,
                                        ),
                                        title: Text(
                                          prodi.isNotEmpty ? prodi : 'Umum',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        trailing: Icon(
                                          expandedProdi.contains(prodi)
                                              ? Icons.expand_less
                                              : Icons.expand_more,
                                        ),
                                      ),
                                    ),
                                    if (expandedProdi.contains(prodi))
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 5,
                                          vertical: 5,
                                        ),
                                        child: Column(
                                          children:
                                              kelasList.map((kelasData) {
                                                // Safely extract data from kelasData
                                                String kelas = '';
                                                String tahunAjaran = '';

                                                if (kelasData
                                                    is Map<String, dynamic>) {
                                                  kelas =
                                                      kelasData['kelas']
                                                          ?.toString() ??
                                                      '';
                                                  tahunAjaran =
                                                      kelasData['tahun_ajaran']
                                                          ?.toString() ??
                                                      '';
                                                } else {
                                                  kelas = kelasData.toString();
                                                }

                                                final displayText =
                                                    tahunAjaran.isNotEmpty
                                                        ? 'Kelas $kelas $tahunAjaran'
                                                        : 'Kelas $kelas';

                                                return Card(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          12,
                                                        ),
                                                  ),
                                                  elevation: 2,
                                                  margin:
                                                      const EdgeInsets.symmetric(
                                                        vertical: 4,
                                                      ),
                                                  child: InkWell(
                                                    onTap:
                                                        () =>
                                                            _navigateToStudentList(
                                                              kelas,
                                                              prodi,
                                                              tahunAjaran,
                                                            ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          12,
                                                        ),
                                                    child: ListTile(
                                                      leading: const Icon(
                                                        Icons.class_rounded,
                                                        color: Colors.teal,
                                                      ),
                                                      title: Text(
                                                        displayText,
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                      trailing: const Icon(
                                                        Icons.arrow_forward_ios,
                                                        size: 16,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }).toList(),
                                        ),
                                      ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                ],
              ),
    );
  }
}
