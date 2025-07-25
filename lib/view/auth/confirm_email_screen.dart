import 'package:flutter/material.dart';
import 'package:giao_dien_1/config/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'reset_password_screen.dart';
import 'package:giao_dien_1/config/default.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ConfirmEmailScreen extends StatefulWidget {
  const ConfirmEmailScreen({super.key});

  @override
  State<ConfirmEmailScreen> createState() => _ConfirmEmailScreenState();
}

class _ConfirmEmailScreenState extends State<ConfirmEmailScreen> {
  final TextEditingController emailController = TextEditingController();
  String? _errorMessage;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  void _handleConfirm() async {
  final inputEmail = emailController.text.trim();

  if (inputEmail.isEmpty || !inputEmail.contains('@')) {
    setState(() {
      _errorMessage = 'Vui lòng nhập email hợp lệ';
    });
    return;
  }

  try {
    final response = await http.post(
      Uri.parse('$baseURL/api/check-email'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': inputEmail}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data['success'] == true) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('email', inputEmail);
      await prefs.setString('maKH', data['maKH']);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResetPasswordScreen(email: inputEmail),
        ),
      );
    } else {
      setState(() {
        _errorMessage = 'Email không tồn tại trong hệ thống';
      });
    }
  } catch (e) {
    setState(() {
      _errorMessage = 'Đã xảy ra lỗi khi kiểm tra email';
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 64),
            const Text(
              "Xác nhận Email",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 32),

            // Email TextField with errorText
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              cursorColor: AppColors.mainOrange,
              decoration: InputDecoration(
                labelText: "Email",
                hintText: "example@gmail.com",
                errorText: _errorMessage,
                errorStyle: const TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                  fontFamily: 'Inter',
                ),
                prefixIcon: const Padding(
                  padding: EdgeInsets.only(left: 16.0, right: 16.0),
                  child: Icon(Icons.email),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFFF5722)),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFFF5722), width: 2.0),
                ),
                errorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFFF5722)),
                ),
                focusedErrorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFFF5722), width: 2.0),
                ),
                hintStyle: TextStyle(
                  color: Colors.grey.withOpacity(0.5),
                ),
                floatingLabelStyle: const TextStyle(
                  color: Colors.black,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 16.0,
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Nút Tiếp tục
            ElevatedButton(
              onPressed: _handleConfirm,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF5722),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 4,
                minimumSize: const Size(double.infinity, 48),
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

            const SizedBox(height: 32),

            // Dòng mô tả
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
                  TextSpan(text: 'Bằng việc xác nhận Email đang dùng, bạn có thể '),
                  TextSpan(
                    text: 'thay đổi mật khẩu',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: ' mà mình mong muốn.'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}