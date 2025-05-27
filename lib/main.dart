import 'package:flutter/material.dart';
import 'package:giao_dien_1/splash_screen.dart';
import 'package:giao_dien_1/login_screen.dart';
import 'package:giao_dien_1/confirm_email_screen.dart'; 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //Gia Bảo
      title: 'Nhà Xe Nam Hải',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: SplashScreen(),
    );
  }
}
