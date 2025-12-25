import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:checkin/utils/loading_indicator_utils.dart';

class AdminDataViewPage extends StatefulWidget {
  const AdminDataViewPage({Key? key}) : super(key: key);

  @override
  _AdminDataViewPageState createState() => _AdminDataViewPageState();
}

class _AdminDataViewPageState extends State<AdminDataViewPage>
    with TickerProviderStateMixin, LoadingStateMixin {
  TabController? _tabController;

  List<Map<String, dynamic>> teacherList = [];
  List<Map<String, dynamic>> studentList = [];

  bool isLoadingTeachers = true;
  bool isLoadingStudents = true;

  Set<String> expandedTahunAjaranGuru = {};
  Set<String> expandedProdiGuru = {};
  Set<String> expandedTahunAjaranSiswa = {};
  Set<String> expandedProdiSiswa = {};
  Set<String> expandedKelasSiswa = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    fetchTeachers();
    fetchStudents();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  Future<void> fetchTeachers() async {
    setState(() => isLoadingTeachers = true);
    try {
      print('🔄 Fetching teachers from API...');
      final response = await http.get(
        Uri.parse(
          'http://192.168.1.17/aplikasi-checkin/pages/admin/get_teachers.php?',
        ),
      );

      print('📥 Teachers API Response Status: ${response.statusCode}');
      print('📥 Teachers API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('📊 Parsed Teachers Data: $data');

        setState(() {
          if (data['status'] == 'success' && data['data'] != null) {
            teacherList = List<Map<String, dynamic>>.from(data['data']);
            print('✅ Teachers loaded: ${teacherList.length} items');
          } else {
            teacherList = [];
            print(
              '❌ Teachers API returned: ${data['status']} - ${data['message'] ?? 'No message'}',
            );
          }
          isLoadingTeachers = false;
        });
      } else {
        setState(() {
          teacherList = [];
          isLoadingTeachers = false;
        });
        print('❌ Teachers API HTTP Error: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        teacherList = [];
        isLoadingTeachers = false;
      });
      print('❌ Teachers API Exception: $e');
      showError('Error loading teachers: $e');
    }
  }

  Future<void> fetchStudents() async {
    setState(() => isLoadingStudents = true);
    try {
      print('🔄 Fetching students from API...');
      final response = await http.get(
        Uri.parse(
          'http://192.168.1.17/aplikasi-checkin/pages/admin/get_students.php',
        ),
      );

      print('📥 Students API Response Status: ${response.statusCode}');
      print('📥 Students API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('📊 Parsed Students Data: $data');

        setState(() {
          if (data['status'] == 'success' && data['data'] != null) {
            studentList = List<Map<String, dynamic>>.from(data['data']);
            print('✅ Students loaded: ${studentList.length} items');
          } else {
            studentList = [];
            print(
              '❌ Students API returned: ${data['status']} - ${data['message'] ?? 'No message'}',
            );
          }
          isLoadingStudents = false;
        });
      } else {
        setState(() {
          studentList = [];
          isLoadingStudents = false;
        });
        print('❌ Students API HTTP Error: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        studentList = [];
        isLoadingStudents = false;
      });
      print('❌ Students API Exception: $e');
      showError('Error loading students: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    print('🏗️ Building UI - isLoading: $isLoading');
    print('🏗️ Teachers count: ${teacherList.length}');
    print('🏗️ Students count: ${studentList.length}');

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Column(
          children: [
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.dashboard,
                    size: 24,
                    color: Colors.cyan,
                  ),
                ),
                const SizedBox(width: 5),
                const Text(
                  "Data Management",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              "Kelola Data Guru & Siswa",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            ),
          ],
        ),
        centerTitle: true,
        toolbarHeight: 80,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color:
                      Theme.of(context).brightness == Brightness.dark
                          ? Colors.white.withOpacity(0.1)
                          : Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: TabBar(
              controller: _tabController,
              labelColor:
                  Theme.of(context).brightness == Brightness.dark
                      ? Colors.blue.shade300
                      : Colors.blue.shade700,
              unselectedLabelColor:
                  Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey.shade400
                      : Colors.grey.shade600,
              indicatorColor:
                  Theme.of(context).brightness == Brightness.dark
                      ? Colors.blue.shade300
                      : Colors.blue.shade700,
              indicatorWeight: 3,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                color:
                    Theme.of(context).brightness == Brightness.dark
                        ? Colors.blue.shade900.withOpacity(0.3)
                        : Colors.blue.shade50,
              ),
              labelStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              tabs: [
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color:
                              Theme.of(context).brightness == Brightness.dark
                                  ? Colors.blue.shade800.withOpacity(0.3)
                                  : Colors.blue.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.person_outline,
                          size: 20,
                          color:
                              Theme.of(context).brightness == Brightness.dark
                                  ? Colors.blue.shade300
                                  : Colors.blue.shade700,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text('Guru'),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color:
                              Theme.of(context).brightness == Brightness.dark
                                  ? Colors.orange.shade800.withOpacity(0.3)
                                  : Colors.orange.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.school_outlined,
                          size: 20,
                          color:
                              Theme.of(context).brightness == Brightness.dark
                                  ? Colors.orange.shade300
                                  : Colors.orange.shade700,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text('Siswa'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body:
          isLoadingTeachers && isLoadingStudents
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                onRefresh: () async {
                  await Future.wait([fetchTeachers(), fetchStudents()]);
                },
                child: TabBarView(
                  controller: _tabController,
                  children: [_buildTeacherListView(), _buildStudentListView()],
                ),
              ),
    );
  }

  Widget _buildTeacherListView() {
    print(
      '🎯 Building Teacher ListView - teacherList.length: ${teacherList.length}',
    );

    final Map<String, List<Map<String, dynamic>>> groupedByProdi = {};

    for (var guru in teacherList) {
      final prodi = guru['prodi'] ?? 'Unknown';
      groupedByProdi.putIfAbsent(prodi, () => []).add(guru);
    }

    print('🎯 Grouped teachers data: $groupedByProdi');

    if (groupedByProdi.isEmpty) {
      print('❌ No teachers data to display');
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.group_off, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              "Belum ada data guru",
              style: TextStyle(color: Colors.grey, fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              "Data guru akan muncul setelah diimpor oleh admin",
              style: TextStyle(color: Colors.grey, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    List<String> sortedProdiKeys = groupedByProdi.keys.toList()..sort();

    return ListView(
      padding: const EdgeInsets.all(8),
      children:
          sortedProdiKeys.map((prodi) {
            final guruList = groupedByProdi[prodi]!;
            final isExpandedProdi = expandedProdiGuru.contains(prodi);

            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 5,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        if (isExpandedProdi) {
                          expandedProdiGuru.remove(prodi);
                        } else {
                          expandedProdiGuru.add(prodi);
                        }
                      });
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: ListTile(
                      leading: const Icon(Icons.school),
                      title: Text(
                        prodi,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text('${guruList.length} guru'),
                      trailing: Icon(
                        isExpandedProdi ? Icons.expand_less : Icons.expand_more,
                      ),
                    ),
                  ),
                  if (isExpandedProdi)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 8,
                      ),
                      child: Column(
                        children:
                            (guruList..sort(
                                  (a, b) => (a['nama_lengkap'] ?? '').compareTo(
                                    b['nama_lengkap'] ?? '',
                                  ),
                                ))
                                .map((guru) {
                                  final photoUrl =
                                      guru['foto'] ??
                                      'http://192.168.1.17/aplikasi-checkin/uploads/guru/default.png';
                                  return Card(
                                    elevation: 1,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 4,
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder:
                                              (_) => Dialog(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                ),
                                                child: SingleChildScrollView(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                          16.0,
                                                        ),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        const SizedBox(
                                                          height: 16,
                                                        ),
                                                        Stack(
                                                          alignment:
                                                              Alignment
                                                                  .bottomRight,
                                                          children: [
                                                            Hero(
                                                              tag:
                                                                  'guru-${guru['id']}',
                                                              child: CircleAvatar(
                                                                backgroundImage:
                                                                    NetworkImage(
                                                                      photoUrl,
                                                                    ),
                                                                radius: 60,
                                                                onBackgroundImageError:
                                                                    (_, __) {},
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 16,
                                                        ),
                                                        Text(
                                                          guru['nama_lengkap'] ??
                                                              'Tidak Ada Nama',
                                                          style:
                                                              const TextStyle(
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                        const SizedBox(
                                                          height: 20,
                                                        ),
                                                        _buildDetailItem(
                                                          icon: Icons.email,
                                                          title: 'Email',
                                                          value:
                                                              guru['email'] ??
                                                              '-',
                                                        ),
                                                        const Divider(),
                                                        _buildDetailItem(
                                                          icon: Icons.school,
                                                          title: 'Prodi',
                                                          value: prodi,
                                                        ),
                                                        const Divider(),
                                                        _buildDetailItem(
                                                          icon:
                                                              guru['jenis_kelamin'] ==
                                                                      'L'
                                                                  ? Icons.male
                                                                  : Icons
                                                                      .female,
                                                          title:
                                                              'Jenis Kelamin',
                                                          value:
                                                              guru['jenis_kelamin'] ==
                                                                      'L'
                                                                  ? 'Laki-laki'
                                                                  : 'Perempuan',
                                                        ),
                                                        const SizedBox(
                                                          height: 16,
                                                        ),
                                                        const SizedBox(
                                                          height: 12,
                                                        ),
                                                        SizedBox(
                                                          width:
                                                              double.infinity,
                                                          child: ElevatedButton.icon(
                                                            icon: const Icon(
                                                              Icons.edit,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            label: const Text(
                                                              'Edit Data Guru',
                                                              style: TextStyle(
                                                                color:
                                                                    Colors
                                                                        .white,
                                                              ),
                                                            ),
                                                            style: ElevatedButton.styleFrom(
                                                              backgroundColor:
                                                                  Colors.orange,
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      8,
                                                                    ),
                                                              ),
                                                            ),
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                context,
                                                              );
                                                              _showTeacherEditDialog(
                                                                guru,
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                        );
                                      },
                                      borderRadius: BorderRadius.circular(10),
                                      child: ListTile(
                                        leading: Hero(
                                          tag: 'guru-${guru['id']}',
                                          child: CircleAvatar(
                                            backgroundImage: NetworkImage(
                                              photoUrl,
                                            ),
                                            radius: 25,
                                            onBackgroundImageError: (_, __) {},
                                          ),
                                        ),
                                        title: Text(
                                          guru['nama_lengkap'] ??
                                              'Tidak Ada Nama',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        subtitle: Text(
                                          guru['email'] ?? '-',
                                          style: const TextStyle(fontSize: 13),
                                        ),
                                        trailing: Icon(
                                          guru['jenis_kelamin'] == 'L'
                                              ? Icons.male
                                              : Icons.female,
                                          color:
                                              guru['jenis_kelamin'] == 'L'
                                                  ? Colors.blue
                                                  : Colors.pink,
                                        ),
                                      ),
                                    ),
                                  );
                                })
                                .toList(),
                      ),
                    ),
                ],
              ),
            );
          }).toList(),
    );
  }

  Widget _buildStudentListView() {
    print(
      '🎯 Building Student ListView - studentList.length: ${studentList.length}',
    );

    final Map<String, Map<String, Map<String, List<Map<String, dynamic>>>>>
    groupedByTahunAjaranProdiKelas = {};

    for (var siswa in studentList) {
      final tahunAjaran = siswa['tahun_ajaran'] ?? 'Unknown';
      final prodi = siswa['prodi'] ?? 'Unknown';
      final kelas = siswa['kelas'] ?? 'Unknown';

      groupedByTahunAjaranProdiKelas.putIfAbsent(tahunAjaran, () => {});
      groupedByTahunAjaranProdiKelas[tahunAjaran]!.putIfAbsent(prodi, () => {});
      groupedByTahunAjaranProdiKelas[tahunAjaran]![prodi]!
          .putIfAbsent(kelas, () => [])
          .add(siswa);
    }

    print('🎯 Grouped students data: $groupedByTahunAjaranProdiKelas');

    if (groupedByTahunAjaranProdiKelas.isEmpty) {
      print('❌ No students data to display');
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.people_outline, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              "Belum ada data siswa",
              style: TextStyle(color: Colors.grey, fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              "Data siswa akan muncul setelah diimpor oleh admin",
              style: TextStyle(color: Colors.grey, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    List<String> sortedTahunAjaranKeys =
        groupedByTahunAjaranProdiKelas.keys.toList()
          ..sort((a, b) => b.compareTo(a));

    return ListView(
      padding: const EdgeInsets.all(8),
      children:
          sortedTahunAjaranKeys.map((tahunAjaran) {
            final prodiKelasMap = groupedByTahunAjaranProdiKelas[tahunAjaran]!;
            final isExpandedTahunAjaran = expandedTahunAjaranSiswa.contains(
              tahunAjaran,
            );

            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 5,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        if (isExpandedTahunAjaran) {
                          expandedTahunAjaranSiswa.remove(tahunAjaran);
                        } else {
                          expandedTahunAjaranSiswa.add(tahunAjaran);
                        }
                      });
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: ListTile(
                      leading: const Icon(Icons.calendar_today),
                      title: Text(
                        'Tahun Ajaran: $tahunAjaran',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        '${_countTotalStudents(prodiKelasMap)} siswa',
                      ),
                      trailing: Icon(
                        isExpandedTahunAjaran
                            ? Icons.expand_less
                            : Icons.expand_more,
                      ),
                    ),
                  ),
                  if (isExpandedTahunAjaran)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 8,
                      ),
                      child: Column(
                        children: _buildProdiCardsAdmin(
                          prodiKelasMap,
                          tahunAjaran,
                        ),
                      ),
                    ),
                ],
              ),
            );
          }).toList(),
    );
  }

  int _countTotalStudents(
    Map<String, Map<String, List<Map<String, dynamic>>>> prodiKelasMap,
  ) {
    int total = 0;
    for (var kelasMap in prodiKelasMap.values) {
      for (var siswaList in kelasMap.values) {
        total += siswaList.length;
      }
    }
    return total;
  }

  List<Widget> _buildProdiCardsAdmin(
    Map<String, Map<String, List<Map<String, dynamic>>>> prodiKelasMap,
    String tahunAjaran,
  ) {
    List<String> sortedProdiKeys = prodiKelasMap.keys.toList()..sort();

    return sortedProdiKeys.map((prodi) {
      final kelasMap = prodiKelasMap[prodi]!;
      final prodiKey = '${tahunAjaran}_$prodi';
      final isExpandedProdi = expandedProdiSiswa.contains(prodiKey);

      return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 6),
        child: Column(
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  if (isExpandedProdi) {
                    expandedProdiSiswa.remove(prodiKey);
                  } else {
                    expandedProdiSiswa.add(prodiKey);
                  }
                });
              },
              borderRadius: BorderRadius.circular(16),
              child: ListTile(
                leading: const Icon(Icons.school),
                title: Text(
                  '$prodi',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: Icon(
                  isExpandedProdi ? Icons.expand_less : Icons.expand_more,
                ),
              ),
            ),
            if (isExpandedProdi)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                child: Column(
                  children: _buildKelasCardsAdmin(kelasMap, tahunAjaran, prodi),
                ),
              ),
          ],
        ),
      );
    }).toList();
  }

  List<Widget> _buildKelasCardsAdmin(
    Map<String, List<Map<String, dynamic>>> kelasMap,
    String tahunAjaran,
    String prodi,
  ) {
    return (kelasMap.entries.toList()..sort((a, b) => a.key.compareTo(b.key))).map((
      kelasEntry,
    ) {
      final kelas = kelasEntry.key;
      final siswaList = kelasEntry.value;
      final kelasKey = '${tahunAjaran}_${prodi}_$kelas';
      final isExpandedKelas = expandedKelasSiswa.contains(kelasKey);

      return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 3,
        margin: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  if (isExpandedKelas) {
                    expandedKelasSiswa.remove(kelasKey);
                  } else {
                    expandedKelasSiswa.add(kelasKey);
                  }
                });
              },
              borderRadius: BorderRadius.circular(12),
              child: ListTile(
                leading: const Icon(Icons.class_),
                title: Text(
                  'Kelas: $kelas',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                trailing: Icon(
                  isExpandedKelas ? Icons.expand_less : Icons.expand_more,
                ),
              ),
            ),
            if (isExpandedKelas)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                child: Column(
                  children:
                      (siswaList..sort((a, b) {
                            final noAbsenA =
                                int.tryParse(
                                  a['no_absen']?.toString() ?? '0',
                                ) ??
                                0;
                            final noAbsenB =
                                int.tryParse(
                                  b['no_absen']?.toString() ?? '0',
                                ) ??
                                0;
                            return noAbsenA.compareTo(noAbsenB);
                          }))
                          .map((siswa) {
                            final photoUrl =
                                siswa['foto'] ??
                                'http://192.168.1.17/aplikasi-checkin/uploads/siswa/default.png';
                            return Card(
                              elevation: 1,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              child: InkWell(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder:
                                        (_) => Dialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                          ),
                                          child: SingleChildScrollView(
                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                16.0,
                                              ),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  const SizedBox(height: 16),
                                                  Stack(
                                                    alignment:
                                                        Alignment.bottomRight,
                                                    children: [
                                                      Hero(
                                                        tag:
                                                            'siswa-${siswa['id']}',
                                                        child: CircleAvatar(
                                                          backgroundImage:
                                                              NetworkImage(
                                                                photoUrl,
                                                              ),
                                                          radius: 60,
                                                          onBackgroundImageError:
                                                              (_, __) {},
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 16),
                                                  Text(
                                                    siswa['nama_lengkap'] ??
                                                        'Tidak Ada Nama',
                                                    style: const TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  const SizedBox(height: 20),
                                                  _buildDetailItem(
                                                    icon: Icons.email,
                                                    title: 'Email',
                                                    value:
                                                        siswa['email'] ?? '-',
                                                  ),
                                                  const Divider(),
                                                  _buildDetailItem(
                                                    icon:
                                                        Icons
                                                            .format_list_numbered,
                                                    title: 'No Absen',
                                                    value:
                                                        siswa['no_absen']
                                                            ?.toString() ??
                                                        '-',
                                                  ),
                                                  const Divider(),
                                                  _buildDetailItem(
                                                    icon: Icons.class_,
                                                    title: 'Kelas',
                                                    value: kelas,
                                                  ),
                                                  const Divider(),
                                                  _buildDetailItem(
                                                    icon: Icons.school,
                                                    title: 'Prodi',
                                                    value: prodi,
                                                  ),
                                                  const Divider(),
                                                  _buildDetailItem(
                                                    icon: Icons.calendar_today,
                                                    title: 'Tahun Ajaran',
                                                    value: tahunAjaran,
                                                  ),
                                                  const Divider(),
                                                  _buildDetailItem(
                                                    icon:
                                                        siswa['jenis_kelamin'] ==
                                                                'L'
                                                            ? Icons.male
                                                            : Icons.female,
                                                    title: 'Jenis Kelamin',
                                                    value:
                                                        siswa['jenis_kelamin'] ==
                                                                'L'
                                                            ? 'Laki-laki'
                                                            : 'Perempuan',
                                                  ),
                                                  const SizedBox(height: 16),
                                                  const SizedBox(height: 12),
                                                  SizedBox(
                                                    width: double.infinity,
                                                    child: ElevatedButton.icon(
                                                      icon: const Icon(
                                                        Icons.edit,
                                                        color: Colors.white,
                                                      ),
                                                      label: const Text(
                                                        'Edit Data Siswa',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                      style: ElevatedButton.styleFrom(
                                                        backgroundColor:
                                                            Colors.orange,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                8,
                                                              ),
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                        _showStudentEditDialog(
                                                          siswa,
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                  );
                                },
                                borderRadius: BorderRadius.circular(10),
                                child: ListTile(
                                  leading: Hero(
                                    tag: 'siswa-${siswa['id']}',
                                    child: CircleAvatar(
                                      backgroundImage: NetworkImage(photoUrl),
                                      radius: 25,
                                      onBackgroundImageError: (_, __) {},
                                    ),
                                  ),
                                  title: Text(
                                    siswa['nama_lengkap'] ?? 'Tidak Ada Nama',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  subtitle: Text(
                                    'No. Absen: ${siswa['no_absen'] ?? '-'}',
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                  trailing: Icon(
                                    siswa['jenis_kelamin'] == 'L'
                                        ? Icons.male
                                        : Icons.female,
                                    color:
                                        siswa['jenis_kelamin'] == 'L'
                                            ? Colors.blue
                                            : Colors.pink,
                                  ),
                                ),
                              ),
                            );
                          })
                          .toList(),
                ),
              ),
          ],
        ),
      );
    }).toList();
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showTeacherEditDialog(Map<String, dynamic> teacher) {
    final nameController = TextEditingController(text: teacher['nama_lengkap']);
    final emailController = TextEditingController(text: teacher['email']);
    final prodiController = TextEditingController(text: teacher['prodi']);
    String selectedGender = teacher['jenis_kelamin'] ?? 'L';

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text('Edit Data Guru'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    textCapitalization: TextCapitalization.words,
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(
                      labelText: 'Nama Lengkap',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: emailController,
                    textCapitalization: TextCapitalization.none,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: prodiController,
                    textCapitalization: TextCapitalization.characters,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      labelText: 'Prodi',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectedGender,
                    decoration: const InputDecoration(
                      labelText: 'Jenis Kelamin',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'L', child: Text('Laki-laki')),
                      DropdownMenuItem(value: 'P', child: Text('Perempuan')),
                    ],
                    onChanged: (value) {
                      selectedGender = value!;
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Batal'),
              ),
              LoadingButton(
                onPressed: () async {
                  if (nameController.text.trim().isEmpty) {
                    showError('Nama lengkap tidak boleh kosong');
                    return;
                  }
                  if (emailController.text.trim().isEmpty) {
                    showError('Email tidak boleh kosong');
                    return;
                  }
                  if (!RegExp(
                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                  ).hasMatch(emailController.text.trim())) {
                    showError('Format email tidak valid');
                    return;
                  }
                  if (prodiController.text.trim().isEmpty) {
                    showError('Prodi tidak boleh kosong');
                    return;
                  }

                  await executeWithLoading('Memperbarui data guru...', () async {
                    // Hanya kirim field yang berubah
                    Map<String, String> updateData = {
                      'type': 'guru',
                      'id': teacher['id'].toString(),
                    };

                    // Cek field yang berubah dan hanya kirim yang berubah
                    if (nameController.text.trim() != teacher['nama_lengkap']) {
                      updateData['nama_lengkap'] = nameController.text.trim();
                    }
                    if (emailController.text.trim() != teacher['email']) {
                      updateData['email'] = emailController.text.trim();
                    }
                    if (prodiController.text.trim() != teacher['prodi']) {
                      updateData['prodi'] = prodiController.text.trim();
                    }
                    if (selectedGender != teacher['jenis_kelamin']) {
                      updateData['jenis_kelamin'] = selectedGender;
                    }

                    final response = await http.post(
                      Uri.parse(
                        'http://192.168.1.17/aplikasi-checkin/pages/admin/edit_data.php',
                      ),
                      body: updateData,
                    );

                    if (response.statusCode == 200) {
                      try {
                        final data = json.decode(response.body);
                        if (data['status'] == 'success') {
                          showSuccess('Data guru berhasil diupdate');
                          await fetchTeachers();
                          if (mounted) Navigator.of(context).pop();
                        } else {
                          showError(
                            data['message'] ?? 'Gagal mengupdate data guru',
                          );
                        }
                      } catch (e) {
                        // Server mengembalikan HTML atau response yang tidak valid
                        print('Edit Teacher Response body: ${response.body}');
                        showError(
                          'Server mengembalikan response yang tidak valid. Periksa koneksi atau hubungi administrator.',
                        );
                      }
                    } else {
                      showError(
                        'Terjadi kesalahan pada server: ${response.statusCode}',
                      );
                    }
                  });
                },
                child: const Text('Simpan'),
              ),
            ],
          ),
    );
  }

  void _showStudentEditDialog(Map<String, dynamic> student) {
    final nameController = TextEditingController(text: student['nama_lengkap']);
    final emailController = TextEditingController(text: student['email']);
    final prodiController = TextEditingController(text: student['prodi']);
    final kelasController = TextEditingController(text: student['kelas']);
    final noAbsenController = TextEditingController(
      text: student['no_absen']?.toString(),
    );
    String selectedGender = student['jenis_kelamin'] ?? 'L';

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text('Edit Data Siswa'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    textCapitalization: TextCapitalization.words,
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(
                      labelText: 'Nama Lengkap',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: emailController,
                    textCapitalization: TextCapitalization.none,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: prodiController,
                    textCapitalization: TextCapitalization.characters,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      labelText: 'Prodi',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: kelasController,
                    textCapitalization: TextCapitalization.characters,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      labelText: 'Kelas',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: noAbsenController,
                    decoration: const InputDecoration(
                      labelText: 'No Absen',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectedGender,
                    decoration: const InputDecoration(
                      labelText: 'Jenis Kelamin',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'L', child: Text('Laki-laki')),
                      DropdownMenuItem(value: 'P', child: Text('Perempuan')),
                    ],
                    onChanged: (value) {
                      selectedGender = value!;
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Batal'),
              ),
              LoadingButton(
                onPressed: () async {
                  if (nameController.text.trim().isEmpty) {
                    showError('Nama lengkap tidak boleh kosong');
                    return;
                  }
                  if (emailController.text.trim().isEmpty) {
                    showError('Email tidak boleh kosong');
                    return;
                  }
                  if (!RegExp(
                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                  ).hasMatch(emailController.text.trim())) {
                    showError('Format email tidak valid');
                    return;
                  }

                  await executeWithLoading('Memperbarui data siswa...', () async {
                    // Hanya kirim field yang berubah
                    Map<String, String> updateData = {
                      'type': 'siswa',
                      'id': student['id'].toString(),
                      'tahun_ajaran':
                          student['tahun_ajaran']
                              .toString(), // Selalu kirim tahun_ajaran untuk konsistensi
                    };

                    // Cek field yang berubah dan hanya kirim yang berubah
                    if (nameController.text.trim() != student['nama_lengkap']) {
                      updateData['nama_lengkap'] = nameController.text.trim();
                    }
                    if (emailController.text.trim() != student['email']) {
                      updateData['email'] = emailController.text.trim();
                    }
                    if (prodiController.text.trim() != student['prodi']) {
                      updateData['prodi'] = prodiController.text.trim();
                    }
                    if (kelasController.text.trim() != student['kelas']) {
                      updateData['kelas'] = kelasController.text.trim();
                    }
                    if (noAbsenController.text.trim() !=
                        student['no_absen']?.toString()) {
                      updateData['no_absen'] = noAbsenController.text.trim();
                    }
                    if (selectedGender != student['jenis_kelamin']) {
                      updateData['jenis_kelamin'] = selectedGender;
                    }

                    final response = await http.post(
                      Uri.parse(
                        'http://192.168.1.17/aplikasi-checkin/pages/admin/edit_data.php',
                      ),
                      body: updateData,
                    );

                    if (response.statusCode == 200) {
                      try {
                        final data = json.decode(response.body);
                        if (data['status'] == 'success') {
                          showSuccess('Data siswa berhasil diupdate');
                          await fetchStudents();
                          if (mounted) Navigator.of(context).pop();
                        } else {
                          showError(
                            data['message'] ?? 'Gagal mengupdate data siswa',
                          );
                        }
                      } catch (e) {
                        // Server mengembalikan HTML atau response yang tidak valid
                        print('Edit Student Response body: ${response.body}');
                        showError(
                          'Server mengembalikan response yang tidak valid. Periksa koneksi atau hubungi administrator.',
                        );
                      }
                    } else {
                      showError(
                        'Terjadi kesalahan pada server: ${response.statusCode}',
                      );
                    }
                  });
                },
                child: const Text('Simpan'),
              ),
            ],
          ),
    );
  }
}
