import 'package:flutter/material.dart';
import 'package:giao_dien_1/config/config.dart';
import 'package:giao_dien_1/view/main/homepage.dart';
import 'package:giao_dien_1/view/auth/phone_number_input.dart';
import 'confirm_email_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:giao_dien_1/widget/input_field.dart';
import 'package:giao_dien_1/view/admin/home_admin/homeadmin.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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

                    setState(() {
                      _usernameError = null;
                      _passwordError = null;
                    });

                    try {
                      final url = Uri.parse('$baseURL/login');
                      print('📡 Sending POST request to $url');
                      print(
                        'Login request: username=${_usernameController.text}, password=${_passwordController.text}',
                      );

                      final response = await http.post(
                        url,
                        headers: {'Content-Type': 'application/json'},
                        body: jsonEncode({
                          'username': _usernameController.text,
                          'password': _passwordController.text,
                        }),
                      );

                      print('📥 Response status: ${response.statusCode}');
                      print('📥 Response body: ${response.body}');
                      print('Login response: ${response.body}');

                      if (response.statusCode == 200) {
                        final data = jsonDecode(response.body);
                        print('✅ Login successful. Data: $data');

                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setString(
                          'username',
                          data['data']['username'],
                        );
                        await prefs.setString(
                          'makh',
                          data['data']['Ma'],
                        );
                        // Navigate based on role
                        if (data['role'] == 'admin') {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => HomeAdmin()),
                          );
                        } else {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => HomePage()),
                          );
                        }
                      } else {
                        print('❌ Login failed. Status: ${response.statusCode}');

                        try {
                          final responseData = jsonDecode(response.body);
                          print(
                            '❌ Error message from server: ${responseData['message']}',
                          );

                          setState(() {
                            _usernameError = ' ';
                            _passwordError =
                                responseData['error'] ??
                                'Đăng nhập không thành công';
                          });
                        } catch (jsonError) {
                          print('🛑 Failed to decode error JSON: $jsonError');
                          setState(() {
                            _passwordError =
                                'Phản hồi không hợp lệ từ máy chủ.';
                          });
                        }
                      }
                    } catch (e) {
                      print('🛑 Exception caught: $e');
                      setState(() {
                        _passwordError = 'Lỗi kết nối đến máy chủ';
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
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.white,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ConfirmEmailScreen(),
                    ),
                  );
                },
                style: ButtonStyle(
                  overlayColor: WidgetStateProperty.resolveWith<Color?>((
                    Set<WidgetState> states,
                  ) {
                    if (states.contains(WidgetState.hovered)) {
                      return Colors.transparent;
                    }
                    return null;
                  }),
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
                    const Text(
                      "Không có tài khoản? ",
                      style: TextStyle(fontFamily: 'Inter', fontSize: 14),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Phone_Number_Input(),
                          ),
                        );
                      },
                      style: ButtonStyle(
                        overlayColor: WidgetStateProperty.all(
                          Colors.transparent,
                        ), // Loại bỏ màu khi nhấn/hover
                        splashFactory:
                            NoSplash.splashFactory, // Loại bỏ hiệu ứng splash
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
