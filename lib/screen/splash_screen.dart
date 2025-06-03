import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'guide_s1.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDE5DE),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/image/namhailogo.png", height: 200),
            const SizedBox(height: 16),
            const Text(
              "NHÀ XE NAM HẢI",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF006400), fontFamily: 'Inter'),
            ),
            const SizedBox(height: 4),
            const Text(
              "Vì những chuyến xe an toàn cho bạn",
              style: TextStyle(color: Color(0xFFFF0000), fontSize: 20, fontFamily: 'Inter'),
            ),
          ],
        ),
      ),
    );
  }
}
