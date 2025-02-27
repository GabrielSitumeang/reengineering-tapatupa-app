import 'package:flutter/material.dart';
import 'home.dart';
import 'profile.dart';
import 'RetributionListPage.dart';

class tunai extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('Pembayaran Tunai', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white, size: 30,),
          onPressed: () {
            Navigator.pop(context); // Aksi untuk kembali ke layar sebelumnya
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          Text(
            'Silahkan Scan Barcode anda untuk melakukan pembayaran tunai',
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),

          // Stack untuk menempatkan barcode dan tombol download di atasnya
          Stack(
            children: [
              // Container dengan BoxDecoration untuk menampilkan QR Code
              Container(
                padding: EdgeInsets.all(35),
                decoration: BoxDecoration(
                  color: Colors.white, // Warna background box
                  borderRadius: BorderRadius.circular(12), // Sudut melengkung
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5), // Warna shadow
                      spreadRadius: 5, // Penyebaran shadow
                      blurRadius: 7, // Jarak blur
                      offset: Offset(0, 3), // Posisi shadow (x, y)
                    ),
                  ],
                ),
                child: Image.asset(
                  'assets/qrcode.png', // Gambar barcode diambil dari folder assets
                  height: 280, // Ukuran gambar
                  width: 280,
                ),
              ),

              // Tombol download di pojok kanan atas barcode
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.red.withOpacity(0.5), // Warna bayangan merah
                        spreadRadius: 2,
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.download,
                        color: Colors.black,
                        size: 16,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Download',
                        style: TextStyle(color: Colors.black, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.help),
            label: 'Permohonan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Tagihan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Pembayaran',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: 2, // Set this to the current index
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          // You can implement navigation logic here
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => home()),
            );
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RetributionListPage()),
            );
          } else if (index == 4) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => profile()),
            );
          }
        },
      ),
    );
  }
}
