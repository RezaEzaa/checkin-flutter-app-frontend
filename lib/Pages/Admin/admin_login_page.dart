import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:checkin/Pages/settings_page.dart';
import 'package:checkin/Pages/welcome_page.dart';
import 'package:checkin/Pages/Admin/admin_forgot_password_page.dart';
import 'package:checkin/utils/loading_indicator_utils.dart';

class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({super.key});
  @override
  _AdminLoginPageState createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage>
    with LoadingStateMixin {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = false;
  bool rememberMe = false;

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  Future<void> _loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('saved_admin_email') ?? '';
    final savedPassword = prefs.getString('saved_admin_password') ?? '';
    final savedRememberMe = prefs.getBool('admin_remember_me') ?? false;

    setState(() {
      emailController.text = savedEmail;
      passwordController.text = savedPassword;
      rememberMe = savedRememberMe;
    });
  }

  Future<void> _saveCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    if (rememberMe) {
      await prefs.setString('saved_admin_email', emailController.text.trim());
      await prefs.setString(
        'saved_admin_password',
        passwordController.text.trim(),
      );
      await prefs.setBool('admin_remember_me', true);
    } else {
      await prefs.remove('saved_admin_email');
      await prefs.remove('saved_admin_password');
      await prefs.setBool('admin_remember_me', false);
    }
  }

  Future<void> loginAdmin() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    if (email.isEmpty && password.isEmpty) {
      _showErrorDialog("Silakan isi email dan kata sandi.");
      return;
    } else if (email.isEmpty) {
      _showErrorDialog("Silakan isi alamat email.");
      return;
    } else if (password.isEmpty) {
      _showErrorDialog("Silakan isi kata sandi.");
      return;
    }

    await executeWithLoading('login', () async {
      try {
        final response = await http.post(
          Uri.parse(
            'http://192.168.1.17/aplikasi-checkin/pages/admin/login_admin.php',
          ),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({"email": email, "kata_sandi": password}),
        );

        dynamic responseData;
        try {
          responseData = jsonDecode(response.body);
        } catch (e) {
          _showErrorDialog(
            "Gagal mengurai respon dari server:\n${response.body}",
          );
          return;
        }

        if (response.statusCode == 200 &&
            responseData['message'] == 'Login berhasil') {
          await _saveCredentials();

          showSuccess('Login berhasil!');
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('admin_email', email);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder:
                  (context) => WelcomePage(
                    userType: 'Admin',
                    namaLengkap: responseData['data']['nama_lengkap'],
                    jenisKelamin: responseData['data']['jenis_kelamin'],
                    userEmail: email,
                  ),
            ),
          );
        } else {
          _showErrorDialog(responseData['message']);
        }
      } catch (e) {
        _showErrorDialog('Terjadi kesalahan: $e');
      }
    });
  }

  void _showErrorDialog(String message) {
    DialogUtils.showErrorDialog(
      context,
      title: 'Login Gagal',
      message: message,
    );
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
        child: Column(
          children: <Widget>[
            SvgPicture.asset('asset/svg/login.svg', height: 140),
            const SizedBox(height: 24),
            const Text(
              'Silakan Masuk',
              style: TextStyle(
                fontFamily: 'TitilliumWeb',
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 28),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              textCapitalization: TextCapitalization.none,
              decoration: InputDecoration(
                labelText: 'Alamat E-Mail Admin',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: const Icon(Icons.email),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              obscureText: !isPasswordVisible,
              decoration: InputDecoration(
                labelText: 'Kata Sandi',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(
                    isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() => isPasswordVisible = !isPasswordVisible);
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Checkbox(
                  value: rememberMe,
                  onChanged: (bool? value) {
                    setState(() {
                      rememberMe = value ?? false;
                    });
                  },
                  activeColor: Colors.green,
                  checkColor: Colors.white,
                ),
                const Text(
                  'Ingat email dan kata sandi saya',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
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
            const SizedBox(height: 16),
            LoadingButton(
              isLoading: isLoading('login'),
              loadingText: 'Memverifikasi...',
              onPressed: loginAdmin,
              icon: const Icon(Icons.login),
              minimumSize: const Size(250, 48),
              backgroundColor: Colors.indigo,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text('Masuk', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
