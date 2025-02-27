import 'package:flutter/material.dart';
import 'package:tapatupa/user/spashscreen.dart';
import 'package:tapatupa/user/RetributionListPage.dart';
import 'package:tapatupa/user/detail_objek_retribusi.dart';
import 'package:tapatupa/user/tagihan.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
