import 'package:flutter/material.dart';

class UserProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        backgroundColor: Colors.redAccent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {},
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            color: const Color.fromARGB(255, 161, 8, 20),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  child: Image.asset(
                    'assets/bg_layar.png', // Ganti dengan path gambar Anda
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "GABRIEL IGNATIUS SITUMEANG",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ],
            ),
          ),
          // ListTile(
          //   leading: Image.asset("assets/bripoin.png", width: 30),
          //   title: const Text("330 Poin"),
          //   trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          //   onTap: () {},
          // ),
          // const Divider(),
          // ListTile(
          //   leading: const Icon(Icons.account_circle),
          //   title: const Text("Data Diri & Data Pekerjaan"),
          //   trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          //   onTap: () {},
          // ),
          const Divider(),
          _buildInfoTile("No Rekening", "1239141774174194"),
          _buildInfoTile("No Telepon", "situ***************@gmail.com",
              icon: Icons.edit),
          _buildInfoTile("Alamat",
              "Toko Mei, Pasar I Kecamatan Sipoholon, Kabupaten Tapanuli Utara, Sumatera Utara",
              icon: Icons.edit),
        ],
      ),
    );
  }

  Widget _buildInfoTile(String title, String value, {IconData? icon}) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(value),
      trailing: icon != null ? Icon(icon) : null,
      onTap: () {},
    );
  }
}
