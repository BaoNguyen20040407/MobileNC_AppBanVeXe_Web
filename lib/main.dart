import 'package:flutter/material.dart';
import 'package:giao_dien_1/view/auth/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Nhà Xe Nam Hải',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: const SplashScreen(),
    );
  }
}
