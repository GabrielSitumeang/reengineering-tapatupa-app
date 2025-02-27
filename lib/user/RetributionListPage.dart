import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'detail_objek_retribusi.dart';

class RetributionListPage extends StatefulWidget {
  @override
  _RetributionListPageState createState() => _RetributionListPageState();
}

class _RetributionListPageState extends State<RetributionListPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _retributionData = [];
  List<Map<String, dynamic>> _filteredData = [];
  String? _selectedKecamatan;
  int _currentPage = 1;
  final int _itemsPerPage = 10;
  bool _isLoading = false;
  bool _hasMoreData = true;

  // Hanya menampilkan filter untuk kecamatan tertentu
  final List<String> _fixedKecamatanList = [
    "Adian Koting",
    "Garoga",
    "Muara",
    "Pagaran",
    "Pahae Julu",
    "Pahae Jae",
    "Parmaksian",
    "Purbatua",
    "Siatas Barita",
    "Siborong-borong",
    "Sipahutar",
    "Simangumban",
    "Tarutung",
  ];

  @override
  void initState() {
    super.initState();
    _fetchRetributionData();
  }

  Future<void> _fetchRetributionData() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      final response = await http.get(Uri.parse(
          'http://tapatupa.manoume.com/api/objek-retribusi-mobile?page=$_currentPage&limit=$_itemsPerPage'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final newData = List<Map<String, dynamic>>.from(data['objekRetribusi']);

        setState(() {
          _retributionData = newData;
          _filteredData = newData; // Awalnya tampilkan semua data
          _hasMoreData = newData.length == _itemsPerPage;
        });
      } else {
        throw Exception('Failed to load retribution data');
      }
    } catch (error) {
      print('Error fetching data: $error');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _applyFilter(String kecamatan) {
    setState(() {
      _selectedKecamatan = kecamatan;
      _filteredData = _retributionData
          .where((data) => data['kecamatan'] == kecamatan)
          .toList();
    });
  }

  void _resetFilter() {
    setState(() {
      _selectedKecamatan = null;
      _filteredData = _retributionData;
    });
  }

  void _showFilterDialog() {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Pilih Kecamatan",
                    style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              Divider(),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _fixedKecamatanList.map((kecamatan) {
                  return GestureDetector(
                    onTap: () {
                      _applyFilter(kecamatan);
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey.shade300),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 3,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Text(
                        kecamatan,
                        style: GoogleFonts.montserrat(fontSize: 14),
                      ),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 16),
              Divider(),
              Center(
                child: TextButton(
                  onPressed: () {
                    _resetFilter();
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Reset Filter",
                    style: GoogleFonts.montserrat(
                        color: Colors.red, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _nextPage() {
    if (_hasMoreData) {
      setState(() {
        _currentPage++;
      });
      _fetchRetributionData();
    }
  }

  void _previousPage() {
    if (_currentPage > 1) {
      setState(() {
        _currentPage--;
      });
      _fetchRetributionData();
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
          Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    width: 160,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 228, 224,
                          224), // Background biru di sekitar search bar
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4), // Spasi dalam
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search,
                            color: Colors.grey), // Ikon search
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: Icon(Icons.clear, color: Colors.grey),
                                onPressed: () => _searchController.clear(),
                              )
                            : null, // Jika kosong, tidak tampil
                        hintText: "Search",
                        border: InputBorder.none, // Hapus border default
                        filled: true,
                        fillColor: Colors.white, // Warna dalam search bar
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 10), // Padding teks
                      ),
                      onChanged: (value) {
                        setState(
                            () {}); // Untuk memperbarui tampilan ikon clear
                      },
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.filter_list, color: Colors.white),
                    onPressed: _showFilterDialog,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _filteredData.isEmpty
                    ? Center(child: Text('No data available'))
                    : ListView.builder(
                        itemCount: _filteredData.length,
                        itemBuilder: (context, index) {
                          final data = _filteredData[index];
                          return ListTile(
                            title: Text(
                              '${data['kodeObjekRetribusi'] ?? '-'} - ${data['objekRetribusi'] ?? '-'}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle:
                                Text('Kecamatan ${data['kecamatan'] ?? '-'}'),
                            trailing:
                                Icon(Icons.arrow_right, color: Colors.black),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FormScreen(
                                      idObjekRetribusi:
                                          data['idObjekRetribusi'].toString()),
                                ),
                              );
                            },
                          );
                        },
                      ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: _currentPage > 1 ? _previousPage : null,
                  child: Text(''),
                ),
                Text('Halaman $_currentPage'),
                TextButton(
                  onPressed: _hasMoreData ? _nextPage : null,
                  child: Text(''),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
