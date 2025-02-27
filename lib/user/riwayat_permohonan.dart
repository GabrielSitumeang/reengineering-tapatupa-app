import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tapatupa/user/buat-permohonan.dart';
import 'package:tapatupa/user/home.dart';
import 'package:tapatupa/user/tagihan.dart';
import 'RetributionListPage.dart'; // Import your RetributionListPage here
import 'profile.dart'; // Import the ProfilePage here
import 'bayar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class RiwayatPermohonan extends StatefulWidget {
  @override
  _RiwayatPermohonanState createState() => _RiwayatPermohonanState();
}

class _RiwayatPermohonanState extends State<RiwayatPermohonan> {
  List<dynamic>? _permohonanData;
  String? idPersonal;

  @override
  void initState() {
    super.initState();
    _loadIdPersonal(); // Load idPersonal first
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

    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
              // Bagian atas dengan gambar
              Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).padding.top + 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          // child: Icon(Icons.arrow_back, color: Colors.white),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 0),
                            child: Text(
                              'Permohonan',
                              style: GoogleFonts.montserrat(
                                fontSize: 25,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.only(
                  left: 10.0,
                  top: 10,
                  bottom: 10,
                ),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: SizedBox(
                    width: 180,
                    height: 35,
                    child: FloatingActionButton.extended(
                      onPressed: () {
                        // Navigasi ke halaman FormulirPermohonan
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FormulirPermohonan()),
                        );
                      },
                      label: Row(
                        mainAxisSize: MainAxisSize
                            .min, // Menghindari penggunaan seluruh lebar tombol
                        children: [
                          SizedBox(width: 5),
                          Text(
                            'Buat Permohonan',
                            style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(width: 8), // Jarak antara teks dan ikon
                          Icon(
                            Icons.add_circle,
                            color: Colors.white,
                            size: 20, // Sesuaikan ukuran ikon jika perlu
                          ),
                        ],
                      ),
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
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
                            SizedBox(height: 30),
                            Container(
                              height: 635,
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
                                      children: _permohonanData!.map((data) {
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
                                                      decoration: BoxDecoration(
                                                        color: Colors.blue
                                                            .withOpacity(0.1),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                      child: Icon(
                                                        Icons.insert_drive_file,
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
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        '${data['jenisPermohonan'] ?? 'Loading...'}',
                                                        style: GoogleFonts
                                                            .montserrat(
                                                          fontSize: 16,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      Text(
                                                        'No. Permohonan - ${data['nomorSuratPermohonan'] ?? 'Loading...'}',
                                                        style: GoogleFonts
                                                            .montserrat(
                                                          fontSize: 15,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                      SizedBox(height: 5),
                                                      Text(
                                                        '${data['tanggalDiajukan'] ?? 'Loading...'}',
                                                        style: GoogleFonts
                                                            .montserrat(
                                                          fontSize: 15,
                                                          color: Colors.grey,
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
                                                            BorderRadius
                                                                .circular(15),
                                                      ),
                                                      child: Text(
                                                        data['namaStatus'] ??
                                                            'Loading...',
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Divider(
                                              color: Colors.grey[300],
                                              thickness: 1,
                                            ),
                                            SizedBox(height: 5),
                                          ],
                                        );
                                      }).toList(),
                                    )
                                  : Center(
                                      child: Text('Data tidak tersedia'),
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
