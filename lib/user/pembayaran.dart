import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:tapatupa/user/upload-bukti-bayar.dart'; // Untuk format tanggal dan waktu

class PembayaranPage extends StatefulWidget {
  final String responseBody;

  PembayaranPage({required this.responseBody}) {
    print(responseBody);
  }

  @override
  _PembayaranPageState createState() => _PembayaranPageState();
}

class _PembayaranPageState extends State<PembayaranPage> {
  late DateTime _waktuSekarang;
  late DateTime _waktuJatuhTempo;
  late String _formattedWaktuJatuhTempo;
  late String _formattedTotalBayar;
  late String _kodeBilling;
  late Timer _timer;
  late int _totalBayar;
  late String _formattedSisaWaktu;

  late String _nomorTagihan;
  late DateTime _tanggalJatuhTempo;
  late String _formattedTanggalJatuhTempo;
  late int _jumlahTagihan;

  @override
  void initState() {
    super.initState();

    // Parsing JSON dari responseBody
    Map<String, dynamic> data = jsonDecode(widget.responseBody);
    var headPembayaran = data['headPembayaran'];
    _totalBayar = headPembayaran['totalBayar'];
    _kodeBilling = headPembayaran['kodeBilling'];

    // Format totalBayar ke format yang lebih mudah dibaca
    _formattedTotalBayar =
        'Rp${_totalBayar.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (match) => '${match[1]},')}';

    // Mengambil data dari detailPembayaran
    var detailPembayaran = data['detailPembayaran'][0];
    _nomorTagihan = detailPembayaran['nomorTagihan'];
    _jumlahTagihan = detailPembayaran['jumlahTagihan'];
    _tanggalJatuhTempo = DateTime.parse(detailPembayaran['tanggalJatuhTempo']);
    _formattedTanggalJatuhTempo =
        DateFormat('dd MMM yyyy').format(_tanggalJatuhTempo);

    // Menghitung waktu jatuh tempo (7 hari dari sekarang)
    _waktuSekarang = DateTime.now();
    _waktuJatuhTempo = _waktuSekarang.add(Duration(days: 7));
    _formattedWaktuJatuhTempo =
        DateFormat('dd MMM yyyy, HH:mm').format(_waktuJatuhTempo);

    // Inisialisasi awal _formattedSisaWaktu
    Duration initialRemainingTime = _waktuJatuhTempo.difference(_waktuSekarang);
    _formattedSisaWaktu = initialRemainingTime.isNegative
        ? 'Waktu telah habis'
        : _formatDuration(initialRemainingTime);

    // Mulai timer untuk menghitung waktu yang berjalan
    _startCountdown();
  }

  void _startCountdown() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        Duration remainingTime = _waktuJatuhTempo.difference(DateTime.now());

        if (remainingTime.isNegative) {
          _formattedSisaWaktu = 'Waktu telah habis';
        } else {
          _formattedSisaWaktu = _formatDuration(remainingTime);
        }
      });
    });
  }

  String _formatDuration(Duration duration) {
    String days = duration.inDays.toString().padLeft(2, '0');
    String hours = (duration.inHours % 24).toString().padLeft(2, '0');
    String minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    String seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$days hari $hours jam $minutes menit $seconds detik';
  }

  @override
  void dispose() {
    _timer.cancel(); // Stop the timer when the page is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Navigasi kembali ke halaman sebelumnya
          },
        ),
        title: Text('Pembayaran',
            style: GoogleFonts.montserrat(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 179, 13, 1),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              Container(
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
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Pembayaran',
                          style: GoogleFonts.montserrat(fontSize: 15),
                        ),
                        Text(
                          _formattedTotalBayar,
                          style: GoogleFonts.montserrat(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Divider(height: 32, thickness: 0.5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Bayar Dalam',
                          style: GoogleFonts.montserrat(fontSize: 15),
                        ),
                        Text(
                          _formattedSisaWaktu,
                          style: GoogleFonts.montserrat(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 7),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          'Jatuh tempo $_formattedWaktuJatuhTempo',
                          style: GoogleFonts.montserrat(
                              fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ),

              SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(
                      8), // Tambahkan border radius agar lebih menarik
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
                  children: [
                    Row(
                      children: [
                        Image.asset('assets/img.png', width: 40, height: 40),
                        const SizedBox(width: 8),
                        Text(
                          'TAPATUPA',
                          style: GoogleFonts.montserrat(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No. Billing',
                      style: GoogleFonts.montserrat(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '1256.2.23.1.$_kodeBilling',
                          style: GoogleFonts.montserrat(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 250, 75, 40),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Clipboard.setData(
                                ClipboardData(text: _kodeBilling));

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Kode Billing disalin ke clipboard!',
                                ),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                          child: Text(
                            'Salin',
                            style: GoogleFonts.montserrat(
                                fontSize: 16,
                                color: const Color.fromARGB(255, 0, 83, 151)),
                          ),
                        ),
                      ],
                    ),
                    Divider(height: 32, thickness: 0.5),
                    Text(
                      'Silakan menunggu proses verifikasi yang akan dilakukan oleh petugas untuk memastikan proses pembayaran telah selesai.',
                      style: GoogleFonts.montserrat(
                          fontSize: 12, color: Colors.green),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Penting: Pastikan kamu mentransfer ke kode Billing di atas.',
                      style: GoogleFonts.montserrat(
                          fontSize: 12, color: Colors.black),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 10),

              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(
                      8), // Border radius agar lebih estetis
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
                  children: [
                    Text(
                      'Petunjuk Transfer Kode Billing',
                      style: GoogleFonts.montserrat(
                          fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Text('1. Pilih *Transfer* > *Virtual Account Billing*.',
                        style: GoogleFonts.montserrat(
                          fontSize: 13,
                        )),
                    const SizedBox(height: 8),
                    Text(
                      '2. Pilih *Rekening Debit* > Masukkan nomor Virtual Account **$_kodeBilling** pada menu *Input Baru*.',
                      style: GoogleFonts.montserrat(
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '3. Tagihan yang harus dibayar akan muncul pada layar konfirmasi.',
                      style: GoogleFonts.montserrat(
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '4. Periksa informasi yang tertera di layar. Pastikan nama penerima adalah **TAPATUPA**. Jika sudah sesuai, masukkan password transaksi dan pilih *Lanjut*.',
                      style: GoogleFonts.montserrat(
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Catatan: Pastikan melakukan transfer ke nomor Billing yang tertera di atas. Kamu dapat menggunakan bank apapun, seperti **BCA, Mandiri, BNI**, atau lainnya. Pastikan transfer dilakukan ke nomor Billing yang sesuai.',
                      style: GoogleFonts.montserrat(
                          fontSize: 13,
                          color: Colors.green,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: 10,
              ),

              // Menampilkan Detail Pembayaran
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(
                      8), // Border radius agar lebih estetis
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
                  // Perbaikan: Bungkus dengan Column agar bisa memiliki banyak child
                  children: [
                    Text(
                      'Detail Pembayaran',
                      style: GoogleFonts.montserrat(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'No. Tagihan',
                          style: GoogleFonts.montserrat(fontSize: 14),
                        ),
                        Text(
                          _nomorTagihan,
                          style: GoogleFonts.montserrat(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Jumlah Tagihan',
                          style: GoogleFonts.montserrat(fontSize: 14),
                        ),
                        Text(
                          'Rp${_jumlahTagihan.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (match) => '${match[1]},')}',
                          style: GoogleFonts.montserrat(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Jatuh Tempo',
                          style: GoogleFonts.montserrat(fontSize: 14),
                        ),
                        Text(
                          _formattedTanggalJatuhTempo,
                          style: GoogleFonts.montserrat(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UploadBuktiPage(
                            responseBodys: widget.responseBody)),
                  );
                },
                child: Text(
                  'Upload Bukti Bayar',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  minimumSize: Size(double.infinity, 50),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
