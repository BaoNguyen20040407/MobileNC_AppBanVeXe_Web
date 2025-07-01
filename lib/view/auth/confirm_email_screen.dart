import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'reset_password_screen.dart';
import 'package:giao_dien_1/config/default.dart';

class ConfirmEmailScreen extends StatefulWidget {
  const ConfirmEmailScreen({super.key});

  @override
  State<ConfirmEmailScreen> createState() => _ConfirmEmailScreenState();
}

class _ConfirmEmailScreenState extends State<ConfirmEmailScreen> {
  final TextEditingController emailController = TextEditingController();
  String? _emailError;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future<String?> _getRegisteredEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('email');
  }

  void _handleConfirm() async {
    final inputEmail = emailController.text.trim();
    final registeredEmail = await _getRegisteredEmail();

    setState(() {
      _emailError = null;
    });

    if (inputEmail.isEmpty) {
      setState(() {
        _emailError = "Vui lòng nhập Email.";
      });
    } else if (registeredEmail == null) {
      setState(() {
        _emailError = "Không tìm thấy thông tin đăng ký.";
      });
    } else if (inputEmail != registeredEmail) {
      setState(() {
        _emailError = "Email không trùng khớp với tài khoản đã đăng ký.";
      });
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ResetPasswordScreen()),
      );
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
                errorText: _emailError,
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