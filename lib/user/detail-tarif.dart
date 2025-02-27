import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tapatupa/user/RetributionListPage.dart';
import 'package:tapatupa/user/tarif-objek.dart';

class DetailTarif extends StatefulWidget {
  final String idObjekRetribusi;

  DetailTarif({required this.idObjekRetribusi});

  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<DetailTarif> {
  Map<String, dynamic> data = {};

  @override
  void initState() {
    super.initState();
    loadRetributionData(widget.idObjekRetribusi);
  }

  Future<void> loadRetributionData(String id) async {
    final response = await http.get(
      Uri.parse(
          'http://tapatupa.manoume.com/api/objek-retribusi-mobile/detail-tarif/$id'),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final filteredData =
          Map<String, dynamic>.from(responseData['tarifObjekRetribusi']);

      // Remove the specified keys
      final keysToRemove = [
        'idTarifObjekRetribusi',
        'idObjekRetribusi',
        'idLokasiObjekRetribusi',
        'idJenisObjekRetribusi',
        'subdis_id',
        'fileName',
        'idJenisJangkawaktu'
      ];
      keysToRemove.forEach(filteredData.remove);

      setState(() {
        data = filteredData;
      });
    } else {
      throw Exception('Failed to load retribution data');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
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
                    Positioned(
                      top: screenHeight /
                          30, // Menyesuaikan posisi ke tengah lebih baik
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Text(
                          'Detail Tarif Objek Retribusi',
                          style: GoogleFonts.montserrat(
                            fontSize: 21,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: data.keys.map((key) {
                      return _buildTextData(key, data[key]?.toString() ?? '-');
                    }).toList(),
                  ),
                ),
              ],
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
            flex: 3,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14.0,
                color: Colors.black54,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 15.0,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
