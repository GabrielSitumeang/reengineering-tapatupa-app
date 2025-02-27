import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tapatupa/user/pembayaran.dart';

class detailPerjanjianSewa extends StatefulWidget {
  final int id; // Variabel untuk menerima ID

  detailPerjanjianSewa({required this.id}); // Konstruktor untuk menerima ID

  @override
  _DetailPerjanjianSewaState createState() => _DetailPerjanjianSewaState();
}

class _DetailPerjanjianSewaState extends State<detailPerjanjianSewa> {
  Map<String, dynamic>? _detailPerjanjianSewa;
  List<dynamic>? _tagihanDetail;
  List<bool> _isChecked = [];

  @override
  void initState() {
    super.initState();
    _fetchDetailPerjanjianData();
  }

  Future<void> _fetchDetailPerjanjianData() async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://tapatupa.manoume.com/api/tagihan-mobile/detail/${widget.id}'),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _detailPerjanjianSewa = data['headTagihanDetail'];
          _tagihanDetail = data['tagihanDetail'];
          _isChecked =
              List.generate(_tagihanDetail?.length ?? 0, (index) => false);
        });
      } else {
        print('Failed to fetch permohonan data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching permohonan data: $e');
    }
  }

  Future<void> _postTagihan() async {
    try {
      final selectedIds = <int>[];
      for (int i = 0; i < _isChecked.length; i++) {
        final detail = _tagihanDetail?[i];
        if (detail == null) {
          print('Error: _tagihanDetail at index $i is null');
          continue;
        }
        final idTagihan = detail['idTagihanSewa'];
        print('Index $i: idTagihan = $idTagihan, Checked = ${_isChecked[i]}');

        if (_isChecked[i] && idTagihan != null) {
          selectedIds.add(idTagihan);
        }
      }

      print('Selected IDs: $selectedIds'); // Debugging selected IDs

      if (selectedIds.isEmpty) {
        print('No selected IDs, showing checkbox dialog');
        _showCheckboxDialog();
        return;
      }
      print('widget.id: ${widget.id}');
      print('selectedIds: $selectedIds');

      final idPerjanjian = _detailPerjanjianSewa?['idPerjanjianSewa'];
      if (idPerjanjian == null) {
        print('Error: idPerjanjian is null');
        return;
      }

      print('idPerjanjian: $idPerjanjian'); // Debugging idPerjanjian

      SharedPreferences prefs = await SharedPreferences.getInstance();

// Retrieve the value as an int and convert it to String
      int? id = prefs.getInt(
          'id'); // Assuming 'id' is stored as an integer in SharedPreferences
      String dibuatOleh =
          id?.toString() ?? '2'; // Convert to String, use default '2' if null

      print(
          'DibuatOleh value from SharedPreferences: $dibuatOleh'); // Debugging

      final uri =
          Uri.parse('http://tapatupa.manoume.com/api/tagihan-mobile/checkout')
                  .replace(queryParameters: {
                'idPerjanjian': idPerjanjian.toString(),
                'DibuatOleh': dibuatOleh, // Ubah sesuai kebutuhan
                'Status': '13', // Ubah sesuai kebutuhan
              }).toString() +
              selectedIds.map((id) => '&idTagihan[]=$id').join();

      print('Final URL: $uri'); // Debugging final URL yang dikirim

      final response = await http.post(Uri.parse(uri));

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        if (response.statusCode == 200) {
          final responseBody = response.body; // Dapatkan respons body
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PembayaranPage(responseBody: responseBody),
            ),
          );
        } else {
          _showErrorDialog(response.body);
        }
      } else {
        _showErrorDialog(response.body);
      }
    } catch (e) {
      print('Error posting data: $e');
      _showErrorDialog('Terjadi kesalahan saat mengirim data.');
    }
  }

  String formatRupiah(num? value) {
    if (value == null) return 'Loading...';
    final formatter =
        NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0);
    return formatter.format(value);
  }

  num calculateTotalSelected() {
    if (_tagihanDetail == null) return 0;
    num total = 0;
    for (int i = 0; i < _tagihanDetail!.length; i++) {
      if (_isChecked[i]) {
        total += _tagihanDetail![i]['jumlahTagihan'] as num;
      }
    }
    return total;
  }

  void _showCheckboxDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Peringatan'),
          content: Text(
              'Anda harus mencentang checkbox pembayaran terlebih dahulu.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Gagal'),
        content: Text('Pembayaran gagal: $errorMessage'),
        actions: [
          TextButton(
            child: Text('OK'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      // backgroundColor: Colors.white, // Pastikan background tetap putih
      body: Stack(
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
                    Positioned(
                      top: screenHeight /
                          30, // Menyesuaikan posisi ke tengah lebih baik
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Text(
                          'Detail Sewa',
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

                Center(
                  child: Column(
                    children: [
                      Transform.translate(
                        offset: Offset(0, -15),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2.0),
                          child: Column(
                            children: [
                              SizedBox(height: 30),
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(0),
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
                                  children: [
                                    SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Column(
                                          children: [
                                            Text(
                                              'Nomor Perjanjian Sewa ',
                                              style: GoogleFonts.montserrat(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Text(
                                              '        ${_detailPerjanjianSewa?['nomorSuratPerjanjian'] ?? 'Loading...'}',
                                              style: GoogleFonts.montserrat(
                                                  fontSize: 13,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Divider(
                                        color: Colors.grey[300], thickness: 1),
                                    SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Column(
                                          children: [
                                            Text(
                                              'Tanggal Disahkan        ',
                                              style: GoogleFonts.montserrat(
                                                fontSize: 14,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Text(
                                              '           ${_detailPerjanjianSewa?['tanggalDisahkan'] ?? 'Loading...'}',
                                              style: GoogleFonts.montserrat(
                                                  fontSize: 13,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Divider(
                                        color: Colors.grey[300], thickness: 1),
                                    SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Column(
                                          children: [
                                            Text(
                                              'Jangka Waktu               ',
                                              style: GoogleFonts.montserrat(
                                                fontSize: 14,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Text(
                                              '          ${_detailPerjanjianSewa?['durasiSewa'] ?? 'Loading...'}',
                                              style: GoogleFonts.montserrat(
                                                  fontSize: 13,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Divider(
                                        color: Colors.grey[300], thickness: 1),
                                    SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Column(
                                          children: [
                                            Text(
                                              'Pembayaran',
                                              style: GoogleFonts.montserrat(
                                                fontSize: 14,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Text(
                                              '                               ${formatRupiah(_detailPerjanjianSewa?['jumlahPembayaran'] as num?)}',
                                              style: GoogleFonts.montserrat(
                                                  fontSize: 13,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Divider(
                                        color: Colors.grey[300], thickness: 1),
                                    SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Column(
                                          children: [
                                            Text(
                                              'Nama Wajib Retribusi',
                                              style: GoogleFonts.montserrat(
                                                fontSize: 14,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Text(
                                              '            ${_detailPerjanjianSewa?['namaWajibRetribusi'] ?? 'Loading...'}',
                                              style: GoogleFonts.montserrat(
                                                  fontSize: 13,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Divider(
                                        color: Colors.grey[300], thickness: 1),
                                    SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Column(
                                          children: [
                                            Text(
                                              'Objek Retribusi',
                                              style: GoogleFonts.montserrat(
                                                fontSize: 14,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Text(
                                              '                         ${_detailPerjanjianSewa?['kodeObjekRetribusi'] ?? 'Loading...'} - ${_detailPerjanjianSewa?['objekRetribusi'] ?? 'Loading...'}',
                                              style: GoogleFonts.montserrat(
                                                  fontSize: 13,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                  ],
                                ),
                              ),
                              SizedBox(height: 25),
                              Text(
                                "Tagihan",
                                style: GoogleFonts.montserrat(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              // List Tagihan dengan Checkbox
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: _tagihanDetail?.length ?? 1,
                                itemBuilder: (context, index) {
                                  final tagihan = _tagihanDetail![index];
                                  return Card(
                                    margin: EdgeInsets.symmetric(vertical: 3),
                                    color: const Color.fromARGB(
                                        255, 254, 253, 253),
                                    child: ListTile(
                                      leading: Checkbox(
                                        value: _isChecked[index],
                                        onChanged: (bool? value) {
                                          setState(() {
                                            _isChecked[index] = value ?? false;
                                          });
                                        },
                                      ),
                                      title: Text(
                                        'Pembayaran Ke-${index + 1}',
                                        style: GoogleFonts.montserrat(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'No. Tagihan ${tagihan['nomorTagihan']}',
                                            style: GoogleFonts.montserrat(
                                              fontSize: 13,
                                            ),
                                          ),
                                          Text(
                                            'Jatuh Tempo    : ${tagihan['tanggalJatuhTempo']}',
                                            style: GoogleFonts.montserrat(
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      ),
                                      trailing: Text(
                                        formatRupiah(tagihan['jumlahTagihan']),
                                        style: GoogleFonts.montserrat(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                            color: Colors.red),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          color: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          child: Column(
                            children: [
                              // Total Pembayaran di atas
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'Total : ${formatRupiah(calculateTotalSelected())}',
                                    style: GoogleFonts.montserrat(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                  height:
                                      10), // Memberikan jarak antara Total dan tombol Bayar
                              // Tombol Bayar di bawah
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      // Logika pembayaran

                                      if (_isChecked.contains(true)) {
                                        print(
                                            'Membayar total: ${calculateTotalSelected()}');
                                        _postTagihan();
                                      } else {
                                        // Jika tidak ada checkbox yang dicentang, tampilkan pop-up
                                        _showCheckboxDialog();
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: Text('Bayar',
                                        style: GoogleFonts.montserrat(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.help), label: 'Permohonan'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet), label: 'Tagihan'),
          BottomNavigationBarItem(
              icon: Icon(Icons.history), label: 'Pembayaran'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: 2, // Tetapkan index sesuai kebutuhan
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          // Navigasikan ke halaman lain jika diperlukan
        },
      ),
    );
  }
}
