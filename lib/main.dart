import 'package:flutter/material.dart';
import 'package:vpn_app/Screen/LoginPage.dart';

import 'Screen/LogoPage.dart';
import 'Utils/Theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VPN App',
      debugShowCheckedModeBanner: false,
      theme: themeData,
      home: const LogoPage(),
    );
  }
}
