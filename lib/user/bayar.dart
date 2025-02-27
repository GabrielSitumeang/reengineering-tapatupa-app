import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'RetributionListPage.dart'; // Import your RetributionListPage here
import 'profile.dart'; // Import the ProfilePage here
import 'home.dart'; // Import the HomePage here
import 'tunai.dart';

class bayars extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Mendapatkan tinggi layar menggunakan MediaQuery
    double screenHeight = MediaQuery.of(context).size.height;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.red.withOpacity(0.7),
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        body: Column(
          children: [
            // Container merah yang mengambil 25% tinggi layar dan menampilkan tulisan
            Container(
              color: Colors.red,
              height: screenHeight * 0.25, // 25% dari tinggi layar
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Mari Membayar Retribusi Sampah',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10), // Jarak antara teks pertama dan kedua
                  Text(
                    'Jangan lupa untuk membayar retribusi sampah Anda.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              // Sisa tampilan akan berada di bawah container merah
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pilih Metode Pembayaran',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Silahkan pilih terlebih dahulu metode pembayaran yang akan Anda lakukan dalam pembayaran retribusi Anda.',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 20),
                    PaymentOptionCard(
                      title: 'Pembayaran Tunai',
                      description:
                      'Pastikan anda sedang bersama Petugas Pemungut Retribusi Sampah',
                      icon: Icons.attach_money,
                      color: Colors.greenAccent,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => tunai()),
                        );
                      },
                    ),
                    SizedBox(height: 10),
                    PaymentOptionCard(
                      title: 'Pembayaran Non Tunai',
                      description:
                      'Pastikan rekening anda memiliki saldo agar pembayaran berhasil',
                      icon: Icons.credit_card,
                      color: Colors.lightBlueAccent,
                      onTap: () {
                        // Tambahkan aksi untuk Pembayaran Non Tunai
                      },
                    ),
                  ],
                ),
              ),
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
      ),
    );
  }
}

class PaymentOptionCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onTap; // Menambahkan onTap sebagai parameter

  PaymentOptionCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.onTap, // Inisialisasi onTap
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Menangani klik dengan onTap
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, size: 40, color: color),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    description,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
