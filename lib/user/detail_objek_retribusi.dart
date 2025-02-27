import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tapatupa/user/RetributionListPage.dart';

class FormScreen extends StatefulWidget {
  final String idObjekRetribusi;

  FormScreen({required this.idObjekRetribusi});

  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  Map<String, dynamic> data = {};

  @override
  void initState() {
    super.initState();
    loadRetributionData(widget.idObjekRetribusi);
  }

  Future<void> loadRetributionData(String id) async {
    final response = await http.get(
      Uri.parse(
          'http://tapatupa.manoume.com/api/objek-retribusi-mobile/detail/$id'),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      setState(() {
        data = responseData['objekRetribusi'] ?? {};

        // Hapus kunci yang tidak ingin ditampilkan
        data.remove('idObjekRetribusi');
        data.remove('idLokasiObjekRetribusi');
        data.remove('idJenisObjekRetribusi');
        data.remove('prov_id');
        data.remove('city_id');
        data.remove('dis_id');
        data.remove('subdis_id');
      });
    } else {
      throw Exception('Failed to load retribution data');
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
          Expanded(
            // 🔥 Ini mencegah overflow
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                        8), // Memberikan radius agar lebih estetis
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: data.keys.map((key) {
                      return _buildTextData(
                          key, data[key] != null ? data[key].toString() : '-');
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextData(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 3, // 🔥 Atur flex agar label tidak terlalu lebar
            child: Text(
              label,
              style: GoogleFonts.montserrat(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54),
            ),
          ),
          SizedBox(width: 10), // 🔥 Tambah jarak agar lebih rapi
          Expanded(
            flex: 5, // 🔥 Pastikan value memiliki ruang lebih besar
            child: Text(
              textAlign: TextAlign.right,
              value,
              style:
                  GoogleFonts.montserrat(fontSize: 15.0, color: Colors.black87),
              softWrap: true, // 🔥 Memastikan teks turun ke bawah jika panjang
            ),
          ),
        ],
      ),
    );
  }
}
