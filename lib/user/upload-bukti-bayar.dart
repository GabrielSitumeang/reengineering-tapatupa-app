import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:tapatupa/user/tagihan-baru.dart';

class UploadBuktiPage extends StatefulWidget {
  final String responseBodys;

  UploadBuktiPage({required this.responseBodys}) {
    print(responseBodys);
  }

  @override
  _UploadBuktiPageState createState() => _UploadBuktiPageState();
}

class _UploadBuktiPageState extends State<UploadBuktiPage> {
  final TextEditingController _namaBankController = TextEditingController();
  final TextEditingController _namaPemilikController = TextEditingController();
  final TextEditingController _jumlahDanaController = TextEditingController();
  final TextEditingController _keteranganController = TextEditingController();
  File? _image;

  int? idPembayaranSewa;
  List<int> idTagihanList = []; // Menyimpan idTagihan[] yang di-generate

  @override
  void initState() {
    super.initState();
    _processResponse();
    print(_processResponse);
  }

  // Fungsi untuk memproses responseBodys
  void _processResponse() {
    try {
      // Decode JSON
      final Map<String, dynamic> data = json.decode(widget.responseBodys);

      // Ambil idPembayaranSewa (pastikan tidak null)
      idPembayaranSewa = data['headPembayaran']['idPembayaranSewa'] as int?;
      if (idPembayaranSewa == null) {
        print('idPembayaranSewa tidak ditemukan');
        return;
      }

      // Validasi detailPembayaran (pastikan bukan null dan ada isinya)
      final List<dynamic>? detailPembayaran = data['detailPembayaran'] as List<dynamic>?;
      if (detailPembayaran == null || detailPembayaran.isEmpty) {
        print('detailPembayaran tidak ditemukan atau kosong');
        return;
      }

      // Ambil idTagihan dari setiap detailPembayaran (handle null values)
      setState(() {
        idTagihanList = detailPembayaran
            .map<int>((item) => item['idTagihanSewa'] is int ? item['idTagihanSewa'] as int : 0)
            .where((idTagihan) => idTagihan > 0) // Filter hanya nilai yang valid (bukan 0)
            .toList();
      });

      print('idPembayaranSewa: $idPembayaranSewa');
      print('idTagihanList: $idTagihanList');
    } catch (e) {
      print('Error memproses responseBodys: $e');
    }
  }




  // Fungsi untuk memilih gambar
  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker _picker = ImagePicker();
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);

      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
        print('Gambar dipilih: ${_image!.path}');
      } else {
        print('Tidak ada gambar yang dipilih');
      }
    } catch (e) {
      print('Error mengambil gambar: $e');
    }
  }

  Future<void> _uploadData() async {
    if (_image == null) {
      print('Gambar belum dipilih');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Harap pilih gambar terlebih dahulu')),
      );
      return;
    }

    if (idPembayaranSewa == null || idTagihanList.isEmpty) {
      print('Data belum lengkap: idPembayaranSewa atau idTagihan[] tidak tersedia');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Data pembayaran tidak lengkap')),
      );
      return;
    }

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://tapatupa.manoume.com/api/pembayaran-mobile/upload-bukti'),
      );

      // Tambahkan field form-data
      request.fields['idPembayaranSewa'] = idPembayaranSewa.toString();
      request.fields['namaBank'] = _namaBankController.text;
      request.fields['namaPemilikRek'] = _namaPemilikController.text;
      request.fields['jumlahDana'] = _jumlahDanaController.text;
      request.fields['keterangan'] = _keteranganController.text;

      // Kirim idTagihan[] sebagai JSON string jika API memerlukan format JSON
      request.fields['idTagihan'] = idTagihanList.isNotEmpty ? idTagihanList.first.toString() : '';

      // Tambahkan file gambar
      if (_image != null && await _image!.exists()) {
        request.files.add(await http.MultipartFile.fromPath('fileBukti', _image!.path));
      } else {
        print('File gambar tidak valid');
        return;
      }

      print('Data yang dikirim:');
      print('idPembayaranSewa: ${idPembayaranSewa.toString()}');
      print('namaBank: ${_namaBankController.text}');
      print('namaPemilikRek: ${_namaPemilikController.text}');
      print('jumlahDana: ${_jumlahDanaController.text}');
      print('keterangan: ${_keteranganController.text}');
      print('idTagihan[]: ${idTagihanList.map((e) => e.toString()).toList()}');
      print('File path: ${_image?.path}');

      // Kirim request
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        print('Bukti bayar berhasil dikirim: $responseBody');
        // Tampilkan dialog konfirmasi
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Sukses'),
              content: Text('Bukti bayar berhasil dikirim'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Tutup dialog
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => tagihan_baru()),
                    );
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        print('Gagal mengirim bukti bayar: ${response.statusCode}');
        print('Response Error Body: $responseBody');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengirim bukti bayar')),
        );
      }
    } catch (e) {
      print('Error saat upload: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan saat upload')),
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Bukti Bayar'),
        backgroundColor: Colors.black38,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField('Nama Bank Asal', _namaBankController),
            _buildTextField('Nama Pemilik Rekening', _namaPemilikController),
            _buildTextField('Jumlah Dana', _jumlahDanaController, TextInputType.number),
            _buildTextField('Keterangan', _keteranganController, TextInputType.text),
            SizedBox(height: 16),

            _buildImagePickerSection(),

            if (_image != null) Image.file(_image!, height: 200),

            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _uploadData,
              child: Text('Kirim'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrangeAccent,
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      [TextInputType keyboardType = TextInputType.text, int maxLines = 1]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  Widget _buildImagePickerSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Upload Bukti Bayar', style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () => _pickImage(ImageSource.gallery),
              child: Text('Pilih dari Gallery'),
            ),
            ElevatedButton(
              onPressed: () => _pickImage(ImageSource.camera),
              child: Text('Ambil dengan Kamera'),
            ),
          ],
        ),
      ],
    );
  }
}
