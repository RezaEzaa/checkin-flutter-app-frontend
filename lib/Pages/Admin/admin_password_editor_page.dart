import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:checkin/Pages/settings_page.dart';
import 'package:checkin/Pages/Admin/admin_forgot_password_page.dart';
import 'package:checkin/utils/loading_indicator_utils.dart';

class PasswordAdminEditorPage extends StatefulWidget {
  final String email;
  const PasswordAdminEditorPage({super.key, required this.email});
  @override
  State<PasswordAdminEditorPage> createState() =>
      _PasswordAdminEditorPageState();
}

class _PasswordAdminEditorPageState extends State<PasswordAdminEditorPage>
    with LoadingStateMixin {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isOldPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  Future<void> _savePassword() async {
    final oldPassword = _oldPasswordController.text.trim();
    final newPassword = _newPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (oldPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      showError('Semua field harus diisi.');
      return;
    }

    if (newPassword != confirmPassword) {
      showError('Kata Sandi baru dan konfirmasi tidak sama.');
      return;
    }

    if (newPassword.length < 6) {
      showError('Kata Sandi baru harus minimal 6 karakter.');
      return;
    }

    await executeWithLoading('Memperbarui password...', () async {
      final response = await http.post(
        Uri.parse(
          'http://192.168.1.17/aplikasi-checkin/pages/admin/update_password_admin.php',
        ),
        body: {
          'email': widget.email,
          'old_password': oldPassword,
          'new_password': newPassword,
        },
      );

      if (response.statusCode == 200) {
        try {
          final result = json.decode(response.body);
          if (result['status'] == 'success') {
            showSuccess('Password berhasil diperbarui.');
            Navigator.pop(context);
          } else {
            showError(result['message'] ?? 'Gagal memperbarui password.');
          }
        } catch (e) {
          // Server mengembalikan HTML atau response yang tidak valid
          print('Response body: ${response.body}');
          showError(
            'Server mengembalikan response yang tidak valid. Periksa koneksi atau hubungi administrator.',
          );
        }
      } else {
        showError('Terjadi kesalahan pada server: ${response.statusCode}');
      }
    });
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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SvgPicture.asset('asset/svg/login.svg', height: 140),
                const SizedBox(height: 20),
                const Text(
                  'Ganti Kata Sandi',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'TitilliumWeb',
                  ),
                ),
                const SizedBox(height: 20),
                _buildPasswordField(
                  controller: _oldPasswordController,
                  label: 'Kata Sandi Lama',
                  isObscure: !_isOldPasswordVisible,
                  toggleVisibility: () {
                    setState(() {
                      _isOldPasswordVisible = !_isOldPasswordVisible;
                    });
                  },
                  icon: Icons.lock_reset_outlined,
                ),
                _buildPasswordField(
                  controller: _newPasswordController,
                  label: 'Kata Sandi Baru (Min. 6 Karakter)',
                  isObscure: !_isNewPasswordVisible,
                  toggleVisibility: () {
                    setState(() {
                      _isNewPasswordVisible = !_isNewPasswordVisible;
                    });
                  },
                  icon: Icons.lock_outline,
                ),
                _buildPasswordField(
                  controller: _confirmPasswordController,
                  label: 'Konfirmasi Kata Sandi Baru (Min. 6 Karakter)',
                  isObscure: !_isConfirmPasswordVisible,
                  toggleVisibility: () {
                    setState(() {
                      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                    });
                  },
                  icon: Icons.lock_person_outlined,
                ),
                const SizedBox(height: 5),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ForgotPasswordAdminPage(),
                      ),
                    );
                  },
                  style: ButtonStyle(
                    overlayColor: WidgetStateProperty.all(Colors.transparent),
                    splashFactory: NoSplash.splashFactory,
                  ),
                  child: const Text(
                    'Lupa Kata Sandi?',
                    style: TextStyle(color: Colors.blue, fontSize: 12),
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: LoadingButton(
                    onPressed: _savePassword,
                    isLoading: isLoading('Memperbarui password...'),
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    icon: const Icon(Icons.save, color: Colors.white),
                    child: const Text(
                      'Simpan Kata Sandi',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool isObscure,
    required VoidCallback toggleVisibility,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        obscureText: isObscure,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          suffixIcon: IconButton(
            icon: Icon(isObscure ? Icons.visibility : Icons.visibility_off),
            onPressed: toggleVisibility,
          ),
        ),
      ),
    );
  }
}
