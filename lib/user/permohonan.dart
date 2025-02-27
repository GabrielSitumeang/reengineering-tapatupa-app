import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tapatupa/user/buat-permohonan-baru.dart';
import 'package:tapatupa/user/buat-permohonan.dart';
import 'package:tapatupa/user/home.dart';
import 'package:tapatupa/user/tagihan.dart';
import 'RetributionListPage.dart'; // Import your RetributionListPage here
import 'profile.dart'; // Import the ProfilePage here
import 'bayar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class permohonan extends StatefulWidget {
  @override
  _PermohonanState createState() => _PermohonanState();
}

class _PermohonanState extends State<permohonan> {
  int _currentIndex = 1; // Set the initial index to 1

  final List<Widget> _pages = [
    HomePage(),
    HomePage(),
    tagihans(),
    RetributionListPage(),
    profile(),
  ];

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.red.withOpacity(0.7),
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        body: _pages[_currentIndex], // Change the displayed page
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<dynamic>? _permohonanData;
  String? idPersonal;

  @override
  void initState() {
    super.initState();
    _loadIdPersonal(); // Load idPersonal first
    _tabController = TabController(length: 2, vsync: this);
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
          'http://tapatupa.manoume.com/api/permohonan-mobile/$idPersonal'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _permohonanData = data['permohonanSewa'];
          print(_permohonanData);
        });
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

    return DefaultTabController(
      length: 2,
      child: Stack(
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
                            Colors.black
                                .withOpacity(0.5), // Menambahkan opacity
                            BlendMode.darken,
                          ),
                          child: Image.asset(
                            'assets/gorgabatak.jpg',
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
                                    color: Color.fromARGB(255, 188, 8, 8),
                                  ),
                                  child: const Icon(
                                    Icons.home_work,
                                    size: 40,
                                    color: Colors.white,
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
                                    'Permohonan',
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
                SizedBox(height: 20),

                // Tab Bar
                TabBar(
                  labelColor: Colors.black,
                  indicatorColor: Colors.red,
                  labelStyle: GoogleFonts.montserrat(),
                  tabs: [
                    Tab(
                      text: 'Riwayat Permohonan',
                    ),
                    Tab(text: 'Buat Permohonan'),
                  ],
                ),

                SizedBox(height: 10),

                // Tab Bar View
                Stack(
                  children: [
                    SingleChildScrollView(
                      child: Container(
                        height: screenHeight - 100,
                        child: TabBarView(
                          children: [
                            // Tab Baru
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Column(
                                children: [
                                  // Align(
                                  //   alignment: Alignment.topLeft,
                                  //   child: SizedBox(
                                  //     width: 180,
                                  //     height: 35,
                                  //     child: FloatingActionButton.extended(
                                  //       onPressed: () {
                                  //         Navigator.push(
                                  //           context,
                                  //           MaterialPageRoute(
                                  //             builder: (context) =>
                                  //                 FormulirPermohonan(),
                                  //           ),
                                  //         );
                                  //       },
                                  //       label: Row(
                                  //         mainAxisSize: MainAxisSize.min,
                                  //         children: [
                                  //           SizedBox(width: 5),
                                  //           Text(
                                  //             'Buat Permohonan',
                                  //             style: GoogleFonts.montserrat(
                                  //               color: Colors.white,
                                  //               fontSize: 15,
                                  //               fontWeight: FontWeight.w500,
                                  //             ),
                                  //           ),
                                  //           SizedBox(width: 8),
                                  //           Icon(
                                  //             Icons.add_circle,
                                  //             color: Colors.white,
                                  //             size: 20,
                                  //           ),
                                  //         ],
                                  //       ),
                                  //       backgroundColor: const Color.fromARGB(
                                  //           255, 196, 14, 1),
                                  //       shape: RoundedRectangleBorder(
                                  //         borderRadius:
                                  //             BorderRadius.circular(10),
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                  SizedBox(height: 20),
                                  Container(
                                    padding: EdgeInsets.all(20),
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
                                    child: _permohonanData != null &&
                                            _permohonanData!.isNotEmpty
                                        ? Column(
                                            children:
                                                _permohonanData!.map((data) {
                                              return Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(height: 10),
                                                  Row(
                                                    children: [
                                                      Column(
                                                        children: [
                                                          Container(
                                                            width: 50,
                                                            height: 50,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Colors.blue
                                                                  .withOpacity(
                                                                      0.1),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8),
                                                            ),
                                                            child: Icon(
                                                              Icons
                                                                  .insert_drive_file,
                                                              size: 32,
                                                              color:
                                                                  Colors.blue,
                                                            ),
                                                          ),
                                                          SizedBox(height: 8),
                                                        ],
                                                      ),
                                                      SizedBox(width: 10),
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              'No. Permohonan - ${data['nomorSuratPermohonan'] ?? 'Loading...'}',
                                                              style: GoogleFonts
                                                                  .montserrat(
                                                                fontSize: 13,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            Text(
                                                              '${data['jenisPermohonan'] ?? 'Loading...'}',
                                                              style: GoogleFonts
                                                                  .montserrat(
                                                                fontSize: 13,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                            SizedBox(height: 5),
                                                            Text(
                                                              '${data['tanggalDiajukan'] ?? 'Loading...'}',
                                                              style: GoogleFonts
                                                                  .montserrat(
                                                                fontSize: 14,
                                                                color:
                                                                    Colors.grey,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(width: 5),
                                                      Column(
                                                        children: [
                                                          Container(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        12,
                                                                    vertical:
                                                                        4),
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  Colors.green,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15),
                                                            ),
                                                            child: Text(
                                                              data['namaStatus'] ??
                                                                  'Loading...',
                                                              style: GoogleFonts
                                                                  .montserrat(
                                                                      color: Colors
                                                                          .white),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  Divider(
                                                      color: Colors.grey[300],
                                                      thickness: 1),
                                                  SizedBox(height: 5),
                                                ],
                                              );
                                            }).toList(),
                                          )
                                        : Center(
                                            child: Text('Data tidak tersedia')),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                                child: Center(child: FormulirPermohonanBaru())),
                          ],
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
