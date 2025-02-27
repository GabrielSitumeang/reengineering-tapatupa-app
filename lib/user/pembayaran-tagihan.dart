import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tapatupa/user/detail-perjanjian.dart';
import 'package:tapatupa/user/detail-sewa.dart';
import 'RetributionListPage.dart'; // Import your RetributionListPage here
import 'profile.dart'; // Import the ProfilePage here
import 'bayar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class pembayaran_tagihan extends StatefulWidget {
  @override
  _TagihanPembayaranState createState() => _TagihanPembayaranState();
}

class _TagihanPembayaranState extends State<pembayaran_tagihan> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    HomePage(),
    HomePage(),
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
        // bottomNavigationBar: BottomNavigationBar(
        //   type: BottomNavigationBarType.fixed,
        //   items: const [
        //     BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        //     BottomNavigationBarItem(icon: Icon(Icons.help), label: 'Permohonan'),
        //     BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: 'Tagihan'),
        //     BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Pembayaran'),
        //     BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        //   ],
        //   currentIndex: _currentIndex,
        //   selectedItemColor: Colors.red,
        //   unselectedItemColor: Colors.grey,
        //   onTap: (index) {
        //     setState(() {
        //       _currentIndex = index;
        //     });
        //   },
        // ),
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
          'http://tapatupa.manoume.com/api/pembayaran-mobile/$idPersonal'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (mounted) {
          // Check if the widget is still in the widget tree
          setState(() {
            _permohonanData = data['pembayaranSewa'];
            print(_permohonanData);
          });
        }
      } else {
        print('Failed to fetch permohonan data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching permohonan data: $e');
    }
  }

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
                    child: Container(
                      height: screenHeight / 19 +
                          MediaQuery.of(context).padding.top,
                      width: double.infinity,
                      child: ColorFiltered(
                        colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.5), // Menambahkan opacity
                          BlendMode.darken,
                        ),
                        child: Image.asset(
                          'assets/gorgabatak.jpg', // Ganti dengan path gambar Anda
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).padding.top + 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Center(
                              child: Container(
                                width: 90,
                                height: 70,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color.fromARGB(255, 188, 8,
                                      8), // Warna latar belakang ikon
                                ),
                                child: const Icon(
                                  Icons.home_work,
                                  size: 40, // Ukuran ikon
                                  color: Colors.white, // Warna ikon
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 0),
                                child: Text(
                                  'Pembayaran',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 25,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
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
                      offset: Offset(0, -25),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Column(
                          children: [
                            SizedBox(height: 40),
                            GestureDetector(
                              onTap: () {},
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.3),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: ListView.builder(
                                  shrinkWrap:
                                      true, // Menyusut berdasarkan konten
                                  physics:
                                      NeverScrollableScrollPhysics(), // Non-scroll jika shrinkWrap digunakan
                                  itemCount: _permohonanData?.length ?? 0,
                                  itemBuilder: (context, index) {
                                    final data = _permohonanData?[index];
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 16.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
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
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                    child: Icon(
                                                      Icons.credit_card,
                                                      size: 32,
                                                      color: Colors.blue,
                                                    ),
                                                  ),
                                                  SizedBox(height: 8),
                                                ],
                                              ),
                                              SizedBox(width: 10),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      '${data?['noInvoice'] ?? 'Loading...'}',
                                                      style: GoogleFonts
                                                          .montserrat(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    SizedBox(height: 5),
                                                    Text(
                                                      '${data?['npwrd'] ?? 'Loading...'} - \n${data?['namaWajibRetribusi'] ?? 'Loading...'}',
                                                      style: GoogleFonts
                                                          .montserrat(
                                                        fontSize: 14,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    SizedBox(height: 5),
                                                    Text(
                                                      '${data?['kodeObjekRetribusi'] ?? 'Loading...'} - ${data?['objekRetribusi'] ?? 'Loading...'}',
                                                      style: GoogleFonts
                                                          .montserrat(
                                                        fontSize: 14,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    SizedBox(height: 5),
                                                    Text(
                                                      '${formatRupiah(data?['totalBayar'] as num?)}',
                                                      style: GoogleFonts
                                                          .montserrat(
                                                        fontSize: 14,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(width: 5),
                                              Column(
                                                children: [
                                                  Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 12,
                                                            vertical: 4),
                                                    decoration: BoxDecoration(
                                                      color: Colors.green,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                    ),
                                                    child: Text(
                                                      '${data?['namaStatus'] ?? 'Loading...'}',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 5),
                                          Divider(
                                            color: Colors.grey[300],
                                            thickness: 1,
                                          ),
                                          Row(
                                            children: [
                                              Column(
                                                children: [],
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [],
                                                ),
                                              ),
                                            ],
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
