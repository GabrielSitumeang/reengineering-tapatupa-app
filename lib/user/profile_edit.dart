import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class profile_edit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(45),
                  bottomRight: Radius.circular(45),
                ),
                child: Container(
                  height:
                      screenHeight / 12 + MediaQuery.of(context).padding.top,
                  width: double.infinity,
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.5), // Menambahkan opacity
                      BlendMode.darken,
                    ),
                    child: Image.asset(
                      'assets/bg_layar.png', // Ganti dengan path gambar Anda
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Edit Data Diri',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20),
              // Menghapus box decoration untuk Mei Pane dan ID
              Row(
                children: [
                  Icon(Icons.person, color: Colors.black38),
                  SizedBox(width: 16),
                  Text(
                    'Miranda',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.credit_card, color: Colors.black38),
                  SizedBox(width: 16),
                  Text(
                    '1212394053374739',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.phone, color: Colors.black38),
                  SizedBox(width: 16),
                  Text(
                    '081377060672',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text(
                'No. Telepon',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black38,
                ),
              ),
              Text(
                'Cth : 082167663638',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              SizedBox(height: 10),
              ProfileInputField(
                hintText: '081377060672',
              ),
              SizedBox(height: 20),
              Text(
                'Alamat',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black38,
                ),
              ),
              Text(
                'Cth : Toko Mei, Pasar I Kecamatan Sipoholon, Kabupaten Tapanuli Utara, Sumatera Utara',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              SizedBox(height: 10),
              ProfileInputField(
                hintText:
                    'Gedung Fairgrounds Lt 5-10, JL SCBD No 126, Jakarta Selatan',
                maxLines: 3,
              ),
              SizedBox(height: 40),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.redAccent, // Warna background button
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                  onPressed: () {
                    // Aksi saat tombol "Simpan" ditekan
                  },
                  child: Text('Simpan',
                      style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.help),
            label: 'Bantuan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.payment),
            label: 'Bayar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: 4, // Indeks halaman saat ini (Profile)
        selectedItemColor: Colors.red,
      ),
    );
  }
}

class ProfileInputField extends StatelessWidget {
  final String hintText;
  final int maxLines;

  ProfileInputField({required this.hintText, this.maxLines = 1});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3), // Posisi shadow
          ),
        ],
      ),
      child: TextField(
        maxLines: maxLines,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}
