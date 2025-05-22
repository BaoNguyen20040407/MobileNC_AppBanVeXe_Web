import 'package:flutter/material.dart';
import 'login_screen.dart';

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
      backgroundColor: const Color(0xFFF9DAD5),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/namhailogo.png", height: 150),
            const SizedBox(height: 20),
            const Text(
              "NHÀ XE NAM HẢI",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green),
            ),
            const SizedBox(height: 8),
            const Text(
              "Vì những chuyến xe an toàn cho bạn",
              style: TextStyle(color: Colors.red, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
