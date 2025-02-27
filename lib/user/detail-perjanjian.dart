import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';

class detailPerjanjian extends StatefulWidget {
  final int id; // Variabel untuk menerima ID

  detailPerjanjian({required this.id}); // Konstruktor untuk menerima ID

  @override
  _DetailPerjanjianState createState() => _DetailPerjanjianState();
}

class _DetailPerjanjianState extends State<detailPerjanjian> {
  Map<String, dynamic>? _detailPerjanjianSewa;

  @override
  void initState() {
    super.initState();
    _fetchDetailPerjanjianData();
  }

  Future<void> _fetchDetailPerjanjianData() async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://tapatupa.manoume.com/api/perjanjian-mobile/detail/${widget.id}'),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _detailPerjanjianSewa = data['perjanjianSewa'];
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

    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              ClipRRect(
                child: Container(
                  height:
                      screenHeight / 19 + MediaQuery.of(context).padding.top,
                  width: double.infinity,
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.5),
                      BlendMode.darken,
                    ),
                    child: Image.asset(
                      'assets/gorgabatak.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: screenHeight / 30,
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    '      Daftar Objek Retribusi \n di Kabupaten Tapanuli Utara',
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Center(
            child: Column(
              children: [
                Transform.translate(
                  offset: Offset(0, -15),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: [
                        SizedBox(height: 30),
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Nomor Surat Perjanjian : ',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          '${_detailPerjanjianSewa?['nomorSuratPerjanjian'] ?? 'Loading...'}',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                          softWrap:
                                              true, // Jika ingin teks terpotong dengan ...
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                              Column(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Tanggal Disahkan :',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          '${_detailPerjanjianSewa?['tanggalDisahkan'] ?? 'Loading...'} ',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                          softWrap:
                                              true, // Jika ingin teks terpotong dengan ...
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Nama Wajib Retribusi: \n${_detailPerjanjianSewa?['namaWajibRetribusi'] ?? 'Loading...'}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Alamat Wajib Retribusi: \n${_detailPerjanjianSewa?['alamatWajibRetribusi'] ?? 'Loading...'}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Kode Objek Retribusi: \n${_detailPerjanjianSewa?['kodeObjekRetribusi'] ?? 'Loading...'}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Objek Retribusi: \n${_detailPerjanjianSewa?['objekRetribusi'] ?? 'Loading...'}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Jenis Jangka Waktu: \n${_detailPerjanjianSewa?['jenisJangkaWaktu'] ?? 'Loading...'}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Nama Satuan: \n${_detailPerjanjianSewa?['namaSatuan'] ?? 'Loading...'}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Panjang Tanah: \n${_detailPerjanjianSewa?['panjangTanah'] ?? 'Loading...'}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Lebar Tanah: \n${_detailPerjanjianSewa?['lebarTanah'] ?? 'Loading...'}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Luas Tanah: \n${_detailPerjanjianSewa?['luasTanah'] ?? 'Loading...'}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Panjang Bangunan: \n${_detailPerjanjianSewa?['panjangBangunan'] ?? 'Loading...'}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Lebar Bangunan: \n${_detailPerjanjianSewa?['lebarBangunan'] ?? 'Loading...'}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Luas Bangunan: \n${_detailPerjanjianSewa?['luasBangunan'] ?? 'Loading...'}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'No Bangunan: \n${_detailPerjanjianSewa?['noBangunan'] ?? 'Loading...'}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Jumlah Lantai \n${_detailPerjanjianSewa?['jumlahLantai'] ?? 'Loading...'}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Kapasitas: \n${_detailPerjanjianSewa?['kapasitas'] ?? 'Loading...'}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Alamat Objek Retribusi: \n${_detailPerjanjianSewa?['alamatObjekRetribusi'] ?? 'Loading...'}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Lokasi Objek Retribusi: \n${_detailPerjanjianSewa?['lokasiObjekRetribusi'] ?? 'Loading...'}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Jenis Objek Retribusi: \n${_detailPerjanjianSewa?['jenisObjekRetribusi'] ?? 'Loading...'}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
