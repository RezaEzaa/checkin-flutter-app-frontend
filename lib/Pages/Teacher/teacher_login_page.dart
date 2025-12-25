import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:checkin/Pages/settings_page.dart';
import 'package:checkin/Pages/welcome_page.dart';
import 'package:checkin/utils/loading_indicator_utils.dart';

class TeacherLoginPage extends StatefulWidget {
  const TeacherLoginPage({super.key});
  @override
  _TeacherLoginPageState createState() => _TeacherLoginPageState();
}

class _TeacherLoginPageState extends State<TeacherLoginPage>
    with LoadingStateMixin {
  final TextEditingController emailController = TextEditingController();
  bool rememberMe = false;

  @override
  void initState() {
    super.initState();
    _loadSavedEmail();
  }

  Future<void> _loadSavedEmail() async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('saved_guru_email') ?? '';
    final savedRememberMe = prefs.getBool('guru_remember_me') ?? false;

    setState(() {
      emailController.text = savedEmail;
      rememberMe = savedRememberMe;
    });
  }

  Future<void> _saveEmail() async {
    final prefs = await SharedPreferences.getInstance();
    if (rememberMe) {
      await prefs.setString('saved_guru_email', emailController.text.trim());
      await prefs.setBool('guru_remember_me', true);
    } else {
      await prefs.remove('saved_guru_email');
      await prefs.setBool('guru_remember_me', false);
    }
  }

  Future<void> loginGuru() async {
    final email = emailController.text.trim();
    if (email.isEmpty) {
      _showErrorDialog("Silakan isi alamat email.");
      return;
    }

    await executeWithLoading('login', () async {
      try {
        final response = await http.post(
          Uri.parse(
            'http://192.168.1.17/aplikasi-checkin/pages/guru/login_guru.php',
          ),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({"email": email}),
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
          await _saveEmail();

          showSuccess('Login berhasil!');
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('guru_email', email);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder:
                  (context) => WelcomePage(
                    userType: 'Guru',
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 20),
              SvgPicture.asset('asset/svg/login.svg', height: 150),
              const SizedBox(height: 24),
              const Text(
                'Masukkan Email Yang Terdaftar',
                style: TextStyle(
                  fontFamily: 'TitilliumWeb',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                textCapitalization: TextCapitalization.none,
                decoration: InputDecoration(
                  labelText: 'Alamat E-Mail Guru',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: const Icon(Icons.email),
                ),
              ),
              const SizedBox(height: 16),
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
                    'Ingat email saya',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              LoadingButton(
                isLoading: isLoading('login'),
                loadingText: 'Memverifikasi...',
                onPressed: loginGuru,
                icon: const Icon(Icons.login),
                minimumSize: const Size(250, 48),
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text('Masuk'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
