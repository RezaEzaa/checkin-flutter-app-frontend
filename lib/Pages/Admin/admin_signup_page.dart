import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:checkin/Pages/Admin/admin_login_page.dart';
import 'package:checkin/Pages/settings_page.dart';
import 'package:checkin/utils/loading_indicator_utils.dart';

class AdminSignupPage extends StatefulWidget {
  const AdminSignupPage({super.key});
  @override
  _AdminSignupPageState createState() => _AdminSignupPageState();
}

class _AdminSignupPageState extends State<AdminSignupPage>
    with LoadingStateMixin {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController namaController = TextEditingController();
  final TextEditingController kataSandiController = TextEditingController();
  final TextEditingController konfirmasiKataSandiController =
      TextEditingController();
  final TextEditingController namaSekolahController = TextEditingController();
  final TextEditingController jabatanController = TextEditingController();
  String? selectedGender;
  File? selectedImage;
  final picker = ImagePicker();
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  Future<void> pickImage() async {
    setLoading('pickImage', true);

    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final file = File(pickedFile.path);
        final fileSize = await file.length();
        const maxSizeInBytes = 1024 * 1024; // 1 MB in bytes

        if (fileSize > maxSizeInBytes) {
          final fileSizeInMB = (fileSize / (1024 * 1024)).toStringAsFixed(2);
          _showErrorDialog(
            'Ukuran File Terlalu Besar',
            'Ukuran foto $fileSizeInMB MB melebihi batas maksimal 1 MB. Silakan pilih foto dengan ukuran lebih kecil.',
          );
        } else {
          setState(() {
            selectedImage = file;
          });
          showSuccess('Foto berhasil dipilih');
        }
      }
    } catch (e) {
      showError('Gagal memilih foto: $e');
    }

    setLoading('pickImage', false);
  }

  void _showErrorDialog(String title, String message) {
    DialogUtils.showErrorDialog(context, title: title, message: message);
  }

  Future<void> registerAdmin() async {
    if (kataSandiController.text.length < 6) {
      _showErrorDialog(
        'Registrasi Gagal',
        'Kata sandi harus minimal 6 karakter',
      );
      return;
    }
    if (kataSandiController.text != konfirmasiKataSandiController.text) {
      _showErrorDialog(
        'Registrasi Gagal',
        'Kata sandi dan konfirmasi tidak cocok',
      );
      return;
    }
    if (selectedGender == null) {
      _showErrorDialog('Registrasi Gagal', 'Pilih jenis kelamin');
      return;
    }
    if (jabatanController.text.trim().isEmpty) {
      _showErrorDialog('Registrasi Gagal', 'Jabatan tidak boleh kosong');
      return;
    }
    if (selectedImage == null) {
      _showErrorDialog('Registrasi Gagal', 'Upload foto terlebih dahulu');
      return;
    }

    await executeWithLoading('register', () async {
      try {
        var request = http.MultipartRequest(
          'POST',
          Uri.parse(
            'http://192.168.1.17/aplikasi-checkin/pages/admin/register_admin.php',
          ),
        );
        request.fields['nama_lengkap'] = namaController.text;
        request.fields['email'] = emailController.text;
        request.fields['jenis_kelamin'] = selectedGender!;
        request.fields['jabatan'] = jabatanController.text;
        request.fields['nama_sekolah'] = namaSekolahController.text;
        request.fields['kata_sandi'] = kataSandiController.text;
        request.fields['konfirmasi_kata_sandi'] =
            konfirmasiKataSandiController.text;
        request.files.add(
          await http.MultipartFile.fromPath('foto', selectedImage!.path),
        );

        var response = await request.send();
        var responseBody = await response.stream.bytesToString();
        var responseData = jsonDecode(responseBody);

        if (response.statusCode == 200 && responseData['status'] == 'success') {
          showSuccess('Registrasi berhasil! Silakan login');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const AdminLoginPage()),
          );
        } else {
          _showErrorDialog(
            'Registrasi Gagal',
            responseData['message'] ?? 'Terjadi kesalahan yang tidak diketahui',
          );
        }
      } catch (e) {
        _showErrorDialog('Terjadi Kesalahan', '$e');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Admin'),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            SvgPicture.asset('asset/svg/login.svg', height: 70),
            const SizedBox(height: 20),
            const Text(
              'Registrasi Admin',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'TitilliumWeb',
              ),
            ),
            const SizedBox(height: 20),
            _buildTextField(
              emailController,
              'Alamat E-Mail',
              Icons.email,
              TextInputType.emailAddress,
              TextCapitalization.none,
            ),
            _buildTextField(
              namaController,
              'Nama Lengkap',
              Icons.person,
              TextInputType.name,
              TextCapitalization.words,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Jenis Kelamin',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.wc),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: selectedGender,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    hint: const Text("Pilih Jenis Kelamin"),
                    items: const [
                      DropdownMenuItem(
                        value: 'L',
                        child: Row(
                          children: [
                            Icon(Icons.male, color: Colors.blue),
                            SizedBox(width: 10),
                            Text('Laki-Laki'),
                          ],
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'P',
                        child: Row(
                          children: [
                            Icon(Icons.female, color: Colors.pink),
                            SizedBox(width: 10),
                            Text('Perempuan'),
                          ],
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedGender = value;
                      });
                    },
                  ),
                ),
              ),
            ),
            _buildTextField(
              jabatanController,
              'Jabatan',
              Icons.badge,
              TextInputType.text,
              TextCapitalization.words,
            ),
            _buildTextField(
              namaSekolahController,
              'Nama Sekolah',
              Icons.school,
              TextInputType.text,
              TextCapitalization.characters,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LoadingButton(
                  isLoading: isLoading('pickImage'),
                  loadingText: 'Memilih...',
                  onPressed: pickImage,
                  icon: const Icon(Icons.photo),
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  child: const Text('Pilih Foto'),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: Text(
                    'Maksimal ukuran file: 1 MB',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
            if (selectedImage != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: CircleAvatar(
                  backgroundImage: FileImage(selectedImage!),
                  radius: 30,
                ),
              ),
            const SizedBox(height: 10),
            _buildPasswordField(
              kataSandiController,
              'Kata Sandi (Min. 6 Karakter)',
              isPasswordVisible,
              () {
                setState(() => isPasswordVisible = !isPasswordVisible);
              },
            ),
            _buildPasswordField(
              konfirmasiKataSandiController,
              'Konfirmasi Kata Sandi (Min. 6 Karakter)',
              isConfirmPasswordVisible,
              () {
                setState(
                  () => isConfirmPasswordVisible = !isConfirmPasswordVisible,
                );
              },
            ),
            const SizedBox(height: 20),
            LoadingButton(
              isLoading: isLoading('register'),
              loadingText: 'Mendaftar...',
              onPressed: registerAdmin,
              icon: const Icon(Icons.app_registration),
              minimumSize: const Size(260, 50),
              backgroundColor: Colors.indigo,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Text('Registrasi'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon,
    TextInputType keyboardType,
    TextCapitalization capitalization,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        textCapitalization: capitalization,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          prefixIcon: Icon(icon),
        ),
      ),
    );
  }

  Widget _buildPasswordField(
    TextEditingController controller,
    String label,
    bool isVisible,
    VoidCallback toggleVisibility,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controller,
        obscureText: !isVisible,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          prefixIcon: const Icon(Icons.lock),
          suffixIcon: IconButton(
            icon: Icon(isVisible ? Icons.visibility_off : Icons.visibility),
            onPressed: toggleVisibility,
          ),
        ),
      ),
    );
  }
}
