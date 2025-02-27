import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tapatupa/user/detail-perjanjian.dart';
import 'package:tapatupa/user/detail-sewa.dart';
import 'RetributionListPage.dart'; // Import your RetributionListPage here
import 'profile.dart'; // Import the ProfilePage here
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class tagihanss extends StatefulWidget {
  @override
  _TagihanState createState() => _TagihanState();
}

class _TagihanState extends State<tagihanss> {
  int _currentIndex = 2;

  final List<Widget> _pages = [
    HomePage(),
    HomePage(),
    tagihanss(),
    RetributionListPage(),
    profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        body: _pages[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.help), label: 'Permohonan'),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_balance_wallet), label: 'Tagihan'),
            BottomNavigationBarItem(
                icon: Icon(Icons.history), label: 'Pembayaran'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
          currentIndex: _currentIndex,
          selectedItemColor: Colors.red,
          unselectedItemColor: Colors.grey,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic>? _permohonanData;

  @override
  void initState() {
    super.initState();
    _loadIdPersonal();
  }

  // Load idPersonal from SharedPreferences
  Future<void> _loadIdPersonal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? idPersonal =
        prefs.getInt('idPersonal'); // Assuming you stored it as int

    if (idPersonal != null) {
      // Convert idPersonal to String before passing to _fetchPermohonanData
      _fetchPermohonanData(idPersonal.toString());
    } else {
      print('No idPersonal found in SharedPreferences');
    }
  }

  // Fetch permohonan data based on idPersonal
  Future<void> _fetchPermohonanData(String idPersonal) async {
    try {
      final response = await http.get(Uri.parse(
          'http://tapatupa.manoume.com/api/tagihan-mobile/$idPersonal'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (mounted) {
          // Check if the widget is still in the widget tree
          setState(() {
            _permohonanData = data['tagihanSewa'];
          });
        }
      } else {
        print('Failed to fetch permohonan data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching permohonan data: $e');
    }
  }

  // Future<void> _fetchPermohonanData() async {
  //   try {
  //     final response = await http.get(Uri.parse('http://tapatupa.manoume.com/api/tagihan-mobile/1'));
  //     if (response.statusCode == 200) {
  //       final data = json.decode(response.body);
  //       setState(() {
  //         _permohonanData = data['tagihanSewa'];
  //       });
  //     } else {
  //       print('Failed to fetch permohonan data: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     print('Error fetching permohonan data: $e');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
// Format nilai menjadi Rupiah
    String formatRupiah(num? value) {
      if (value == null) return 'Loading...';
      final formatter =
          NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0);
      return formatter.format(value);
    }

    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
              // Bagian atas dengan gambar
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    child: Container(
                      height:
                          screenHeight / 4 + MediaQuery.of(context).padding.top,
                      width: double.infinity,
                      child: ColorFiltered(
                        colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.8), // Menambahkan opacity
                          BlendMode.darken,
                        ),
                        child: Image.asset(
                          'assets/bg_layar.png', // Ganti dengan path gambar Anda
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).padding.top + 19),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/miranda.JPG',
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Text(
                              'Tagihan Sewa',
                              style: TextStyle(
                                  fontSize: 28,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Transform.translate(
                      offset: Offset(0, -90),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          children: [
                            SizedBox(height: 30),
                            SizedBox(height: 10),
                            GestureDetector(
                              onTap: () {
                                if (_permohonanData != null &&
                                    _permohonanData!.isNotEmpty) {
                                  final int id = _permohonanData![0][
                                      'idPerjanjianSewa']; // Pastikan key 'id' sesuai dengan API
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          detailPerjanjianSewa(id: id),
                                    ),
                                  );
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.green[50],
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.8),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${_permohonanData?[0]['nomorSuratPerjanjian'] ?? 'Loading...'}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Divider(
                                      color: Colors.black,
                                      thickness: 1,
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Column(
                                          children: [
                                            Container(
                                              width: 70,
                                              height: 100,
                                              decoration: BoxDecoration(
                                                color: Colors.blue
                                                    .withOpacity(0.2),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Icon(
                                                Icons.credit_card,
                                                size: 32,
                                                color: Colors.blue,
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(width: 20),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Objek Retribusi: \n${_permohonanData?[0]['kodeObjekRetribusi'] ?? 'Loading...'} - ${_permohonanData?[0]['objekRetribusi'] ?? 'Loading...'}',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              Text(
                                                'Pembayaran: \n${formatRupiah(_permohonanData?[0]['jumlahPembayaran'] as num?)}',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              Text(
                                                'Status: \n${_permohonanData?[0]['namaStatus'] ?? 'Loading...'}',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
