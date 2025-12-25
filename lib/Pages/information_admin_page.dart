import 'package:flutter/material.dart';
class InformationAdminPage extends StatelessWidget {
  const InformationAdminPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panduan Dashboard Admin'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade600, Colors.blue.shade400],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                children: [
                  Icon(
                    Icons.admin_panel_settings,
                    size: 50,
                    color: Colors.white,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Dashboard Administrator',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'TitilliumWeb',
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Panduan Lengkap Fitur & Fungsi Admin',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                      fontFamily: 'TitilliumWeb',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const AdminFeatureCard(
              icon: Icons.cloud_upload,
              title: 'Import Data Excel',
              description:
                  'Upload data sekolah, guru, dan siswa melalui file Excel',
              features: [
                '• Import data sekolah dari template Excel',
                '• Import data guru lengkap dengan informasi pribadi',
                '• Import data siswa beserta kelas dan jurusan',
                '• Validasi otomatis format data sebelum upload',
                '• Progress tracking saat proses upload berlangsung',
                '• Backup data lama sebelum import baru',
              ],
              color: Colors.green,
            ),
            const SizedBox(height: 16),
            const AdminFeatureCard(
              icon: Icons.photo_library,
              title: 'Upload Foto Wajah',
              description: 'Kelola foto profil untuk sistem face recognition',
              features: [
                '• Upload foto guru dalam format ZIP',
                '• Upload foto siswa dalam format ZIP',
                '• Automatic face detection dan validasi kualitas foto',
                '• Resize dan optimasi foto secara otomatis',
                '• Backup foto lama sebelum update',
                '• Progress bar untuk tracking upload foto',
              ],
              color: Colors.blue,
            ),
            const SizedBox(height: 16),
            const AdminFeatureCard(
              icon: Icons.visibility,
              title: 'Lihat & Kelola Data',
              description: 'Monitor dan edit semua data pengguna terdaftar',
              features: [
                '• Tab view terpisah untuk data guru dan siswa',
                '• Filter berdasarkan program studi dan kelas',
                '• Expand/collapse view untuk navigasi mudah',
                '• Edit informasi pengguna secara real-time',
              ],
              color: Colors.orange,
            ),
            const SizedBox(height: 16),
            const AdminFeatureCard(
              icon: Icons.file_download,
              title: 'Download Template & Export',
              description: 'Unduh template dan export data sistem',
              features: [
                '• Download template Excel untuk data sekolah',
                '• Download template Excel untuk data guru',
                '• Download template Excel untuk data siswa',
                '• Export seluruh database ke format Excel',
                '• Automatic file naming dengan timestamp',
                '• Save file ke storage dengan permission handling',
              ],
              color: Colors.purple,
            ),
            const SizedBox(height: 16),
            const AdminFeatureCard(
              icon: Icons.person,
              title: 'Profil Administrator',
              description: 'Kelola akun dan profil admin sistem',
              features: [
                '• Edit informasi profil admin (nama, email)',
                '• Update foto profil admin',
                '• Ubah password dengan validasi keamanan',
                '• Logout dengan konfirmasi',
                '• Session management otomatis',
                '• Activity log untuk tracking aktivitas admin',
              ],
              color: Colors.teal,
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.amber.withOpacity(0.3)),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.lightbulb, color: Colors.amber, size: 24),
                      SizedBox(width: 8),
                      Text(
                        'Tips untuk Admin',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'TitilliumWeb',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Text(
                    '💡 Panduan Penggunaan Dashboard Admin\n\n'
                    '1. Import Data Awal:\n'
                    '   • Mulai dengan download template Excel\n'
                    '   • Isi data sekolah, guru, dan siswa sesuai format\n'
                    '   • Upload file Excel melalui menu Import Data\n\n'
                    '2. Upload Foto Pengguna:\n'
                    '   • Siapkan foto guru dan siswa dalam folder ZIP\n'
                    '   • Pastikan nama file foto sesuai dengan email/ID\n'
                    '   • Upload melalui menu Upload Foto\n\n'
                    '3. Monitoring & Maintenance:\n'
                    '   • Cek data pengguna melalui menu Lihat Data\n'
                    '   • Edit informasi jika diperlukan\n'
                    '   • Backup data secara berkala\n\n'
                    '4. Keamanan:\n'
                    '   • Ganti password admin secara berkala\n'
                    '   • Logout setelah selesai menggunakan\n'
                    '   • Monitor aktivitas melalui log sistem',
                    style: TextStyle(fontSize: 14, fontFamily: 'TitilliumWeb'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class AdminFeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final List<String> features;
  final Color color;
  const AdminFeatureCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.features,
    required this.color,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'TitilliumWeb',
                      ),
                    ),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        fontFamily: 'TitilliumWeb',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...features.map(
            (feature) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                feature,
                style: const TextStyle(
                  fontSize: 14,
                  fontFamily: 'TitilliumWeb',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
