import 'package:flutter/material.dart';
import 'confirm_email_screen.dart';


class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: ListView(
            children: [
              const SizedBox(height: 40),
              Image.asset("assets/namhailogo.png", height: 120),
              const SizedBox(height: 10),
              const Center(
                child: Text(
                  "NHÀ XE NAM HẢI",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green),
                ),
              ),
              const Center(
                child: Text(
                  "Vì những chuyến xe an toàn cho bạn",
                  style: TextStyle(color: Colors.red, fontSize: 14),
                ),
              ),
              const SizedBox(height: 30),
              const Center(               
                child: Text(
                  "ĐĂNG NHẬP",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                
              ),
              const SizedBox(height: 30),
              TextField(
                decoration: InputDecoration(
                  labelText: "UserName",
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password",
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: Icon(Icons.visibility_off),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ConfirmEmailScreen()),
                      );
                      },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFF5722),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 4,
                  ),
                  child: const Text(
                    "Đăng Nhập",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {},
                child: const Text("Quên mật khẩu?", style: TextStyle(color: Colors.red)),
              ),
              const SizedBox(height: 10),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Không có tài khoản? "),
                    GestureDetector(
                      onTap: () {},
                      child: const Text(
                        "Đăng ký",
                        style: TextStyle(color: Color(0xFFFF5722), fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
