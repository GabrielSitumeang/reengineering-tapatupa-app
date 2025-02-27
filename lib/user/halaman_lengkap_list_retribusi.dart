import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'detail_objek_retribusi.dart';

class HalamanLengkapListRetribusi extends StatelessWidget {
  final TextEditingController _searchController = TextEditingController();
  Future<List<Map<String, dynamic>>> fetchRetributionData() async {
    final response = await http.get(
        Uri.parse('http://tapatupa.manoume.com/api/objek-retribusi-mobile'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data['objekRetribusi']);
    } else {
      throw Exception('Failed to load retribution data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Daftar Objek Retribusi ',
            style: GoogleFonts.montserrat(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            size: 25,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.red.withOpacity(0.9),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Container(
            //   color: Colors.white,
            //   height: 20,
            //   width: 340,
            //   alignment: Alignment.center,
            //   child: Column(
            //     children: [
            //       TextField(
            //         controller: _searchController,
            //         decoration: InputDecoration(
            //           hintText: 'Search...',
            //           // Add a clear button to the search bar
            //           suffixIcon: IconButton(
            //             icon: Icon(Icons.clear),
            //             onPressed: () => _searchController.clear(),
            //           ),
            //           // Add a search icon or button to the search bar
            //           prefixIcon: IconButton(
            //             icon: Icon(Icons.search),
            //             onPressed: () {
            //               // Perform the search here
            //             },
            //           ),
            //           border: OutlineInputBorder(
            //             borderRadius: BorderRadius.circular(20.0),
            //           ),
            //         ),
            //       ),

            //       // Text(
            //       //   'Berikut Daftar Objek Retribusi \n di Kabupaten Tapanuli Utara',
            //       //   style: GoogleFonts.montserrat(
            //       //       fontSize: 18,
            //       //       fontWeight: FontWeight.bold,
            //       //       color: Colors.white),
            //       //   textAlign: TextAlign.center,
            //       // ),
            //     ],
            //   ),
            // ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: Colors.white, // Background putih untuk container utama
              child: Container(
                height: 45,
                decoration: BoxDecoration(
                  color: Colors
                      .grey[200], // Latar belakang abu-abu untuk TextField
                  borderRadius: BorderRadius.circular(20), // Sudut melengkung
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Cari', // Ubah teks placeholder
                    hintStyle: GoogleFonts.montserrat(
                      fontSize: 16,
                      color: Colors.grey[600], // Warna teks placeholder
                    ),
                    border: InputBorder.none, // Hilangkan border default
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.grey[600], // Ikon pencarian
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 12), // Padding teks
                  ),
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    color: Colors.black, // Warna teks input
                  ),
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.all(0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: fetchRetributionData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No data available'));
                  }

                  final retributionData = snapshot.data!;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: retributionData.map((data) {
                        final objekRetribusiText =
                            '${data['kodeObjekRetribusi'] ?? '-'} \n ${data['objekRetribusi'] ?? '-'} ';
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Column(
                                  children: [
                                    Text('')
                                    // Container(
                                    //   width: 50,
                                    //   height: 50,
                                    //   decoration: BoxDecoration(
                                    //     color: Colors.blue.withOpacity(0.1),
                                    //     borderRadius: BorderRadius.circular(8),
                                    //   ),
                                    //   child: Icon(
                                    //     Icons.insert_drive_file,
                                    //     size: 32,
                                    //     color: Colors.blue,
                                    //   ),
                                    // ),
                                    // SizedBox(height: 8),
                                  ],
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${data['kodeObjekRetribusi'] ?? '-'} - ${data['objekRetribusi'] ?? '-'}',
                                        style: GoogleFonts.montserrat(
                                          fontSize: 16,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      // Text(
                                      //   '${data['kodeObjekRetribusi'] ?? '-'} \n ${data['objekRetribusi'] ?? '-'}',
                                      //   style: GoogleFonts.montserrat(
                                      //     fontSize: 15,
                                      //     color: Colors.black,
                                      //     fontWeight: FontWeight.w400,
                                      //   ),
                                      // ),
                                      SizedBox(height: 5),
                                      Text(
                                        '${data['kecamatan'] ?? 'Loading...'}',
                                        style: GoogleFonts.montserrat(
                                          fontSize: 15,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 5),
                                Column(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 4),

                                      child: IconButton(
                                        icon: Icon(Icons.arrow_right,
                                            color: Colors.black),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => FormScreen(
                                                idObjekRetribusi:
                                                    data['id'].toString(),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      // child: Text(
                                      //   data['namaStatus'] ?? 'Loading...',
                                      //   style: TextStyle(
                                      //     fontSize: 14,
                                      //     color: Colors.white,
                                      //     fontWeight: FontWeight.w500,
                                      //   ),
                                      // ),
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
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  TableRow _buildTableRow(BuildContext context, String title, String jenis,
      {int? id, bool isHeader = false}) {
    return TableRow(
      decoration: BoxDecoration(
        color: isHeader ? Colors.white : Colors.red.withOpacity(0.3),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
              color: Colors.black,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                jenis,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
                  color: Colors.black,
                ),
              ),
              if (!isHeader)
                IconButton(
                  icon: Icon(Icons.arrow_right, color: Colors.black),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            FormScreen(idObjekRetribusi: id.toString()),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ],
    );
  }
}
