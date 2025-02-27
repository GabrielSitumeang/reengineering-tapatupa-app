import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tapatupa/user/detail-tarif.dart';

class TarifObjekListPage extends StatefulWidget {
  @override
  _TarifObjekListPageState createState() => _TarifObjekListPageState();
}

class _TarifObjekListPageState extends State<TarifObjekListPage> {
  List<Map<String, dynamic>> _originalData = [];
  List<Map<String, dynamic>> _filteredData = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchRetributionData();
    _searchController.addListener(_filterData);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> fetchRetributionData() async {
    final response = await http.get(Uri.parse(
        'http://tapatupa.manoume.com/api/objek-retribusi-mobile/tarif'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _originalData = List<Map<String, dynamic>>.from(data['tarifRetribusi']);
        _filteredData = _originalData;
      });
    } else {
      throw Exception('Failed to load retribution data');
    }
  }

  void _filterData() {
    setState(() {
      _filteredData = _originalData
          .where((item) => item['objekRetribusi']
              .toString()
              .toLowerCase()
              .contains(_searchController.text.toLowerCase()))
          .toList();
    });
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
                    '  Daftar Tarif Objek Retribusi \n di Kabupaten Tapanuli Utara',
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
          Padding(
            padding: EdgeInsets.all(10),
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 228, 224, 224),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear, color: Colors.grey),
                          onPressed: () => _searchController.clear(),
                        )
                      : null,
                  hintText: "Search",
                  border: InputBorder.none,
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
          ),
          Expanded(
            child: _filteredData.isEmpty
                ? Center(child: Text('Data tidak ditemukan'))
                : ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    itemCount: _filteredData.length,
                    itemBuilder: (context, index) {
                      final data = _filteredData[index];
                      return _buildRetributionItem(context, data);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildRetributionItem(
      BuildContext context, Map<String, dynamic> data) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  '${data['kodeObjekRetribusi'] ?? '-'} ${data['objekRetribusi'] ?? '-'}',
                  style:
                      GoogleFonts.montserrat(fontSize: 14, color: Colors.black),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                'Rp ${data['nominalTarif']}',
                style: GoogleFonts.montserrat(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrangeAccent),
              ),
            ],
          ),
          SizedBox(height: 5),
          Align(
            alignment: Alignment.topRight,
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailTarif(
                        idObjekRetribusi:
                            data['idTarifObjekRetribusi'].toString()),
                  ),
                );
              },
              child: Text(
                'Lihat Detail',
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.blue,
                ),
              ),
            ),
          ),
          Divider(color: Colors.grey.shade300),
        ],
      ),
    );
  }
}
