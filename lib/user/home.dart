import 'package:carousel_slider/carousel_slider.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tapatupa/user/bayars.dart';
import 'package:tapatupa/user/detail-perjanjian.dart';
import 'package:tapatupa/user/pembayaran-tagihan.dart';
import 'package:tapatupa/user/perjanjian.dart';
import 'package:tapatupa/user/permohonan.dart';
import 'package:tapatupa/user/tagihan-baru.dart';
import 'package:tapatupa/user/tagihan.dart';
import 'package:tapatupa/user/tarif-objek.dart';
import 'RetributionListPage.dart'; // Import your RetributionListPage here
import 'profile.dart'; // Import the ProfilePage here
import 'bayar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

class home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<home> {
  int _currentIndex = 0; // This keeps track of the selected bottom nav item

  String _namaLengkap = '';
  String _fotoUser = '';
  int _roleId = 0;
  int _idPersonal = 0;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _namaLengkap = prefs.getString('namaLengkap') ?? 'Nama tidak ditemukan';
      _fotoUser = prefs.getString('fotoUser') ?? '';
      _roleId = prefs.getInt('roleId') ?? 0;
      _idPersonal = prefs.getInt('idPersonal') ?? 0; // Memuat idPersonal
    });

    // Mencetak semua data ke konsol
    print('Nama Lengkap: $_namaLengkap');
    print('Foto User: $_fotoUser');
    print('Role ID: $_roleId');
    print('ID Personal: $_idPersonal');
  }

  // Pages for BottomNavigationBar items
  final List<Widget> _pages = [
    HomePage(),
    permohonan(),
    tagihan_baru(), // For the 'Bayar' Page
    pembayaran_tagihan(), // For the 'History' Page
    profile(), // The Profile Page
  ];

  final List<Widget> _navigationItem = [
    const Icon(Icons.home),
    const Icon(Icons.view_list),
    const Icon(Icons.account_balance_wallet),
    const Icon(Icons.history),
    const Icon(Icons.person),
  ];

  Color bgcolor = Colors.blueAccent;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.red.withOpacity(0.7),
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        body: _pages[_currentIndex], // Change the displayed page
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.view_list),
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
          currentIndex: _currentIndex,
          selectedItemColor: Colors.red,
          unselectedItemColor: Colors.grey,
          onTap: (index) {
            setState(() {
              _currentIndex = index; // Update the current index when tapped
            });
          },
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    final _homeState = context.findAncestorStateOfType<_HomeState>();
    final namaLengkap = _homeState?._namaLengkap ?? 'User';
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: screenHeight / 8 + MediaQuery.of(context).padding.top,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 196, 90, 90), // Dark Red
                    Color.fromARGB(255, 177, 45, 45), // Firebrick
                    Color.fromARGB(255, 189, 39, 69), // Crimson
                    Color.fromARGB(
                        255, 142, 26, 26), // Dark Red again for a darker touch
                  ],
                  stops: [0.1, 0.4, 0.7, 1.0],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(55),
                  bottomRight: Radius.circular(55),
                )),
            child: Stack(
              children: [
                // Lingkaran dekoratif
                Positioned(
                  top: -20,
                  left: -30,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.2),
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 20,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.2),
                    ),
                  ),
                ),
                Positioned(
                  top: 50,
                  right: -40,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.15),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 40,
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.1),
                    ),
                  ),
                ),
                // Konten header
                Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + -15,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Gambar profil dalam lingkaran
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Container(
                          width: 110,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            image: DecorationImage(
                              image: AssetImage(
                                'assets/logotapatupa.png',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      // Teks sambutan
                      SizedBox(width: 10),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          // child: Text(
                          //   'Hi, $namaLengkap\nSelamat datang di Aplikasi\nObjek Retribusi Tapanuli Utara',
                          //   style: GoogleFonts.montserrat(
                          //     fontSize: 15,
                          //     color: Colors.white,
                          //   ),
                          // ),
                        ),
                      ),
                      // Ikon notifikasi
                      IconButton(
                        onPressed: () {
                          print("Notifikasi ditekan");
                        },
                        icon: Icon(
                          Icons.notifications,
                          color: Colors.white,
                        ),
                      ),

                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: AssetImage(
                              'assets/miranda.JPG',
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(255, 255, 255, 255)
                            .withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  transform: Matrix4.translationValues(
                      1, -(screenHeight / 5 - 130), 0),
                ),
                Transform.translate(
                  offset: Offset(0, -80),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                            width: 370,
                            height: 110,
                            padding: EdgeInsets.all(19),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 255, 255, 255),
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(
                                    0.3,
                                  ),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    _buildIconCard(
                                        Icons.home_work, 'Objk Retribusi',
                                        onTap: () {
                                      _navigateWithTransition(
                                          context, RetributionListPage());
                                    }),
                                  ],
                                ),
                                SizedBox(width: 15),
                                Container(
                                  height:
                                      60, // Sesuaikan tinggi dengan kebutuhan
                                  width: 1, // Lebar garis
                                  color: Colors.grey, // Warna garis
                                ),
                                SizedBox(width: 15),
                                Column(
                                  children: [
                                    _buildIconCard(
                                        Icons.receipt_long, 'Tarif Objek',
                                        onTap: () {
                                      _navigateWithTransition(
                                          context, TarifObjekListPage());
                                    }),
                                  ],
                                ),
                                SizedBox(width: 15),
                                Container(
                                  height: 60,
                                  width: 1,
                                  color: Colors.grey,
                                ),
                                SizedBox(width: 25),
                                Column(
                                  children: [
                                    _buildIconCard(
                                        Icons.handshake_outlined, 'Perjanjian',
                                        onTap: () {
                                      _navigateWithTransition(
                                          context, perjanjian());
                                    }),
                                  ],
                                ),
                              ],
                            )),
                        SizedBox(height: 30),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Informasi Tagihan',
                            style: GoogleFonts.montserrat(
                              fontSize: 17,
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color.fromARGB(255, 255, 255, 255), // Dark Red
                                Color.fromARGB(255, 255, 255, 255), // Firebrick
                                Color.fromARGB(255, 255, 238, 238), // Crimson
                                Color.fromARGB(232, 255, 211,
                                    211), // Dark Red again for a darker touch
                              ],
                              stops: [0.1, 0.4, 0.7, 1.0],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(55),
                              topRight: Radius.circular(55),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color.fromARGB(255, 255, 255, 255),
                                spreadRadius: 12,
                                blurRadius: 15,
                                offset: Offset(10, 13),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Tagihan anda belum lunas',
                                style: GoogleFonts.montserrat(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red),
                              ),
                              SizedBox(height: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text('Tagihan bulan',
                                          style: GoogleFonts.montserrat(
                                              fontSize: 15)),
                                      Text('    :',
                                          style: GoogleFonts.montserrat(
                                              fontSize: 15)),
                                      Text(' Januari',
                                          style: GoogleFonts.montserrat(
                                              fontSize: 15)),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text('Objek ',
                                          style: GoogleFonts.montserrat(
                                              fontSize: 15)),
                                      Text('                  :',
                                          style: GoogleFonts.montserrat(
                                              fontSize: 15)),
                                      Text(' Ruko',
                                          style: GoogleFonts.montserrat(
                                              fontSize: 15)),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text('Alamat                 :',
                                          style: GoogleFonts.montserrat(
                                              fontSize: 15)),
                                      Text(' Jl. Merdeka No. 10',
                                          style: GoogleFonts.montserrat(
                                              fontSize: 15)),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text('Kecamatan         :',
                                          style: GoogleFonts.montserrat(
                                              fontSize: 15)),
                                      Text(' Siantar',
                                          style: GoogleFonts.montserrat(
                                              fontSize: 15)),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text('Kabupaten          :',
                                          style: GoogleFonts.montserrat(
                                              fontSize: 15)),
                                      Text(' Tapanuli Utara',
                                          style: GoogleFonts.montserrat(
                                              fontSize: 15)),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Text.rich(
                                TextSpan(
                                  text: 'Jumlah Tagihan : ',
                                  style: GoogleFonts.montserrat(fontSize: 15),
                                  children: [
                                    TextSpan(
                                      text: 'Rp 1.500.000',
                                      style: GoogleFonts.montserrat(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 5),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Lakukan Pembayaran',
                                      style: GoogleFonts.montserrat(
                                        fontSize: 15,
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Icon(Icons.arrow_right, color: Colors.blue),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 30),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Tapatupa Banyak Bisanya, Udah Coba?',
                            style: GoogleFonts.montserrat(
                              fontSize: 17,
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        CarouselMenu(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconCard(IconData icon, String title, {Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: Colors.red),
          SizedBox(height: 10),
          Text(
            title,
            style: GoogleFonts.montserrat(
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  void _navigateWithTransition(BuildContext context, Widget page) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.ease;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }
}

class CarouselMenu extends StatelessWidget {
  const CarouselMenu({super.key});

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> items = [
      {
        "image":
            "https://via.placeholder.com/600x300", // Ganti dengan URL gambar asli
        "title": "Diskon 50%\nNikmati Bayar atau\nTop Up Listrik PLN",
        "button": "Cek Sekarang"
      },
      {
        "image": "https://via.placeholder.com/600x300",
        "title": "Yuk, Beli Tiket Mudik\ndan Liburan Asik\nBertabur Promo!",
        "button": "Cek Sekarang"
      }
    ];

    return CarouselSlider(
      options: CarouselOptions(
        height: 200.0,
        autoPlay: true,
        enlargeCenterPage: true,
        viewportFraction: 0.6,
        aspectRatio: 16 / 9,
      ),
      items: items.map((item) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: NetworkImage(item["image"]!),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                        colors: [
                          const Color.fromARGB(225, 194, 2, 2).withOpacity(0.7),
                          const Color.fromARGB(0, 255, 236, 236)
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item["title"]!,
                          style: const TextStyle(
                              color: Color.fromARGB(255, 32, 31, 31),
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white),
                          child: Text(item["button"]!,
                              style: const TextStyle(color: Colors.black)),
                        )
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        );
      }).toList(),
    );
  }
}

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Page'),
      ),
      body: Center(
        child: Text('This is the profile page'),
      ),
    );
  }
}
