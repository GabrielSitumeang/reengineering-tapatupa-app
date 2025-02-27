import 'package:flutter/material.dart';
import 'dart:convert'; // Untuk konversi JSON
import 'package:http/http.dart' as http; // Tambahkan paket HTTP
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart'; // Import halaman home
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'dart:async';

class login extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<login> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  Timer? _sessionTimer;

  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  void _showSnackbar(String title, String message, ContentType contentType) {
    var snackBar = SnackBar(
      margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height - 200),
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: title,
        message: message,
        contentType: contentType,
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> _checkSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isLoggedIn = prefs.getBool('isLoggedIn');

    if (isLoggedIn == true) {
      // Jika sesi masih aktif, arahkan ke halaman home
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => home()),
      );
    }
  }

  Future<void> _startSession(Map<String, dynamic> userData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Simpan data pengguna ke SharedPreferences
    await prefs.setString('namaLengkap', userData['namaLengkap'] ?? '');
    await prefs.setString('fotoUser', userData['fotoUser'] ?? '');
    await prefs.setInt('id', userData['id'] ?? 0);
    await prefs.setInt('roleId', userData['roleId'] ?? 0);
    await prefs.setString('roleName', userData['roleName'] ?? '');
    await prefs.setInt('idPersonal', userData['idPersonal'] ?? 0);
    await prefs.setBool('isLoggedIn', true);

    // Atur timer untuk sesi (30 detik)
    _sessionTimer = Timer(Duration(seconds: 30), () async {
      await _endSession();
    });
  }

  Future<void> _endSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (mounted) {
      _showSnackbar("Sesi Berakhir", "Sesi Anda telah habis.", ContentType.warning);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => login()),
      );
    }
  }

  Future<void> _login() async {
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      _showSnackbar("Gagal", "Email Atau Password Harus Diisi", ContentType.failure);
      return;
    }

    const String url = 'http://tapatupa.manoume.com/api/login';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['status'] == 200) {
          // Ambil data pengguna dari list userData
          final List<dynamic> userDataList = responseData['userData'];
          if (userDataList.isNotEmpty) {
            final Map<String, dynamic> userData = userDataList[0];

            // Tampilkan pesan sukses
            _showSnackbar("Benar", "Anda berhasil login", ContentType.success);

            // Mulai sesi dengan data pengguna
            await _startSession(userData);

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => home()),
            );
          } else {
            _showSnackbar("Gagal", "Data pengguna tidak ditemukan", ContentType.failure);
          }
        } else {
          _showSnackbar("Gagal", "${responseData['message']}", ContentType.failure);
        }
      } else {
        _showSnackbar("Error", "Terjadi kesalahan server", ContentType.failure);
      }
    } catch (e) {
      _showSnackbar("Error", "Tidak dapat terhubung ke server", ContentType.failure);
    }
  }



  @override
  void dispose() {
    _sessionTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(35.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/img.png',
                  width: 200,
                  height: 200,
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.red, Colors.redAccent],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: TextButton(
                      onPressed: _login,
                      child: Text(
                        'Login',
                        style: TextStyle(color: Colors.white),
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
}
