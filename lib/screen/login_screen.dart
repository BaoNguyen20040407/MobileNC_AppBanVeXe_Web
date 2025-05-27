import 'package:flutter/material.dart';
import 'confirm_email_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
          child: ListView(
            children: [
              const SizedBox(height: 32),
              Image.asset("assets/image/namhailogo.png", height: 120),
              const SizedBox(height: 16),

              const Center(
                child: Text(
                  "NHÀ XE NAM HẢI",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF006400),
                    fontFamily: 'Inter',
                  ),
                ),
              ),
              const SizedBox(height: 4),

              const Center(
                child: Text(
                  "Vì những chuyến xe an toàn cho bạn",
                  style: TextStyle(
                    color: Color(0xFFFF0000),
                    fontSize: 14,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
              const SizedBox(height: 32),

              const Center(
                child: Text(
                  "ĐĂNG NHẬP",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFF5722),
                    fontFamily: 'Inter',
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // UserName TextField
              TextField(
                decoration: InputDecoration(
                  labelText: "UserName",
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                    child: Icon(Icons.person),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFFF5722)),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFFF5722), width: 2.0),
                  ),
                    hintStyle: TextStyle(
                    color: Colors.grey.withOpacity(0.5),
                  ),
                  floatingLabelStyle: const TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Password TextField có nút ẩn/hiện mật khẩu
              TextField(
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: "Password",
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                    child: Icon(Icons.lock),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFFF5722)),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFFF5722), width: 2.0),
                  ),
                  hintStyle: TextStyle(
                    color: Colors.grey.withOpacity(0.5),
                  ),
                  floatingLabelStyle: const TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),

              const SizedBox(height: 32),

              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: () {

                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF5722),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 4,
                  ),
                  child: const Text(
                    "Đăng Nhập",
                    style: TextStyle(fontSize: 17, color: Colors.white, fontFamily: 'Inter', fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ConfirmEmailScreen()),
                  );
                },
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.hovered)) {
                        return Colors.transparent;
                      }
                      return null;
                    },
                  ),
                ),
                child: const Text(
                  "Quên mật khẩu?",
                  style: TextStyle(
                    color: Color(0xFFFF5722),
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),


              const SizedBox(height: 32),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Không có tài khoản? ", style: TextStyle(fontFamily: 'Inter', fontSize: 14),),
                    TextButton(
                      onPressed: () {
                        // Xử lý sự kiện đăng ký
                      },
                      style: ButtonStyle(
                        overlayColor: MaterialStateProperty.all(Colors.transparent), // Loại bỏ màu khi nhấn/hover
                        splashFactory: NoSplash.splashFactory, // Loại bỏ hiệu ứng splash
                        padding: MaterialStateProperty.all(EdgeInsets.zero),
                        minimumSize: MaterialStateProperty.all(Size(0, 0)),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        alignment: Alignment.centerLeft,
                      ),
                      child: const Text(
                        "Đăng ký",
                        style: TextStyle(
                          color: Color(0xFFFF5722),
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Inter',
                          fontSize: 14,
                        ),
                      ),
                    ),
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