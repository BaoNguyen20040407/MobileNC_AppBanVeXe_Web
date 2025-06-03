import 'package:flutter/material.dart';
import 'package:giao_dien_1/screen/register.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 125.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Image.asset(
                  'assets/image/logovexekhach_1.png',
                  width: 205,
                  height: 152,
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
                    SizedBox(width: 16),
                    Image.asset(
                      'assets/image/icons8_bus_100_2.png',
                      width: 100,
                      height: 100,
                    ),
                    SizedBox(width: 16),
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "CHÀO MỪNG BẠN ĐẾN VỚI APP NHÀ XE NAM HẢI",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFF5722),
                        fontFamily: 'Inter',
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
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
                      style: TextStyle(fontSize: 14, fontFamily: 'Inter'),
                    ),
                    TextSpan(
                      text: 'Tiếp tục ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: 'để hoàn tất thông tin và kích hoạt tài khoản',
                      style: TextStyle(fontSize: 14, fontFamily: 'Inter'),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),

              SizedBox(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const Register()),
                  );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF5722),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 4,
                    minimumSize: const Size(double.infinity, 54),
                  ),
                  child: const Text(
                    "Tiếp tục",
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.white,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
