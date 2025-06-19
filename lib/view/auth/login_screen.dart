import 'package:flutter/material.dart';
import 'package:giao_dien_1/view/main/homepage.dart';
import 'package:giao_dien_1/view/auth/phone_number_input.dart';
import 'confirm_email_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:giao_dien_1/widget/input_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true; 
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _usernameError;
  String? _passwordError; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: ListView(
            children: [
              Image.asset("assets/image/logovexekhach_1.png", height: 250),
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

              //Tên đăng nhập
              CustomInputField(
                controller: _usernameController,
                labelText: "Tên đăng nhập",
                prefixIcon: Icons.person,
                errorText: _usernameError,
                keyboardType: TextInputType.text,
                showToggleVisibility: false,
              ),
              const SizedBox(height: 16),

              // Password TextField có nút ẩn/hiện mật khẩu
              CustomInputField(
                controller: _passwordController,
                labelText: "Mật khẩu",
                prefixIcon: Icons.lock,
                errorText: _passwordError,
                obscureText: _obscurePassword,
                keyboardType: TextInputType.visiblePassword,
                showToggleVisibility: true,
                onToggleObscureText: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),

              const SizedBox(height: 32),

              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: () async {
                    final userNameInput = _usernameController.text.trim();
                    final passwordInput = _passwordController.text.trim();

                    final pref = await SharedPreferences.getInstance();
                    final saveUsername = pref.getString('username');
                    final savePassword = pref.getString('password');

                    setState(() {
                      _usernameError = null;
                      _passwordError = null;
                    });

                    if (userNameInput == saveUsername && passwordInput == savePassword)
                    {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => HomePage()),
                    );
                    }
                    else {
                      setState(() {
                        if (userNameInput != saveUsername) 
                        {
                          _usernameError = 'Tên đăng nhập không đúng';
                        }
                        if (passwordInput != savePassword)
                        {
                          _passwordError = 'Mật khẩu không đúng';
                        }
                      });
                    }
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
                  overlayColor: WidgetStateProperty.resolveWith<Color?>(
                    (Set<WidgetState> states) {
                      if (states.contains(WidgetState.hovered)) {
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Phone_Number_Input()),
                        );
                      },
                      style: ButtonStyle(
                        overlayColor: WidgetStateProperty.all(Colors.transparent), // Loại bỏ màu khi nhấn/hover
                        splashFactory: NoSplash.splashFactory, // Loại bỏ hiệu ứng splash
                        padding: WidgetStateProperty.all(EdgeInsets.zero),
                        minimumSize: WidgetStateProperty.all(Size(0, 0)),
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