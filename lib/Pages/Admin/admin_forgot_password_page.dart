import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:checkin/utils/loading_indicator_utils.dart';

class ForgotPasswordAdminPage extends StatefulWidget {
  const ForgotPasswordAdminPage({super.key});
  @override
  State<ForgotPasswordAdminPage> createState() =>
      _ForgotPasswordAdminPageState();
}

class _ForgotPasswordAdminPageState extends State<ForgotPasswordAdminPage>
    with LoadingStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  Future<void> _resetPassword() async {
    final email = _emailController.text.trim();
    final newPassword = _newPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (email.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
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
          'email': email,
          'new_password': newPassword,
          'confirm_password': confirmPassword,
          'forgot_password': 'true',
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
      appBar: AppBar(title: const Text('Reset Password Admin')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SvgPicture.asset('asset/svg/login.svg', height: 140),
                const SizedBox(height: 20),
                const Text(
                  'Reset Kata Sandi',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'TitilliumWeb',
                  ),
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  _emailController,
                  'Alamat E-Mail Yang Terdaftar',
                  false,
                  null,
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                ),
                _buildTextField(
                  _newPasswordController,
                  'Kata Sandi Baru (Min. 6 Karakter)',
                  !_isNewPasswordVisible,
                  () {
                    setState(() {
                      _isNewPasswordVisible = !_isNewPasswordVisible;
                    });
                  },
                  icon: Icons.lock_outline,
                ),
                _buildTextField(
                  _confirmPasswordController,
                  'Konfirmasi Kata Sandi Baru (Min. 6 Karakter)',
                  !_isConfirmPasswordVisible,
                  () {
                    setState(() {
                      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                    });
                  },
                  icon: Icons.lock_person_outlined,
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: LoadingButton(
                    onPressed: _resetPassword,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.indigo,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.refresh, color: Colors.white),
                            SizedBox(width: 8),
                            Text(
                              'Reset Password',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
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

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    bool obscure,
    VoidCallback? toggleVisibility, {
    TextInputType? keyboardType,
    IconData? icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        keyboardType: keyboardType,
        textCapitalization: TextCapitalization.none,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: icon != null ? Icon(icon) : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          suffixIcon:
              toggleVisibility != null
                  ? IconButton(
                    icon: Icon(
                      obscure ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: toggleVisibility,
                  )
                  : null,
        ),
      ),
    );
  }
}
