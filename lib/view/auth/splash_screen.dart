import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'package:giao_dien_1/view/payment/payment.dart';
import 'package:giao_dien_1/view/admin/trip_admin/trip_list.dart';
import 'package:giao_dien_1/view/admin/assignment_admin/assignment_list.dart';


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
        MaterialPageRoute(builder: (context) => AssignmentList()),
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
            Image.asset("assets/image/logovexekhach_1.png", height: 600),
          ],
        ),
      ),
    );
  }
}
