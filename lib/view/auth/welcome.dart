import 'package:flutter/material.dart';
import 'package:giao_dien_1/view/auth/register.dart';
import 'package:giao_dien_1/widget/orange_button_1.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 70.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Image.asset(
                    'assets/image/logovexekhach_1.png',
                    width: 250,
                    height: 250,
                  ),
                ),
                SizedBox(height: 16),

                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/image/icons8_bus_100_2.png',
                        width: 100,
                        height: 100,
                      ),
                      SizedBox(width: 8),
                      Image.asset(
                        'assets/image/icons8_bus_100_2.png',
                        width: 100,
                        height: 100,
                      ),
                      SizedBox(width: 8),
                      Image.asset(
                        'assets/image/icons8_bus_100_2.png',
                        width: 100,
                        height: 100,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),

                Center(
                  child: Text(
                    "CHÀO MỪNG BẠN ĐẾN VỚI APP\nNHÀ XE NAM HẢI",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFF5722),
                      fontFamily: 'Inter',
                      letterSpacing: 0.5,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 16),

                RichText(
                  textAlign: TextAlign.justify,
                  text: const TextSpan(
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontFamily: 'Inter',
                      height: 1.5,
                      letterSpacing: 0.5,
                    ),
                    children: [
                      TextSpan(
                        text: 'Hãy nhấn nút ',
                      ),
                      TextSpan(
                        text: 'Tiếp tục ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: 'để hoàn tất thông tin và kích hoạt tài khoản',
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),

                OrangeButton1(
                  text: 'Tiếp tục',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Register()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
