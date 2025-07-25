import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:giao_dien_1/config/config.dart';
import 'package:giao_dien_1/config/default.dart';
import 'package:giao_dien_1/view/auth/login_screen.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email; 

  const ResetPasswordScreen({super.key, required this.email});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  String? _errorText;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _handleSavePassword() async {
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (password.isEmpty || confirmPassword.isEmpty) {
      setState(() => _errorText = "Vui lòng nhập đầy đủ thông tin.");
      return;
    }

    if (password != confirmPassword) {
      setState(() => _errorText = "Mật khẩu không khớp.");
      return;
    }

    if (widget.email.isEmpty) {
      setState(() => _errorText = "Không tìm thấy email đã đăng ký.");
      return;
    }


    setState(() {
      _isLoading = true;
      _errorText = null;
    });

    try {
      final response = await http.put(
        Uri.parse('$baseURL/api/reset-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': widget.email,
          'newPassword': password,
        }),
      );

      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        }
      } else {
        setState(() {
          _errorText = data['message'] ?? 'Đổi mật khẩu thất bại.';
        });
      }
    } catch (e) {
      setState(() {
        _errorText = 'Lỗi kết nối đến máy chủ.';
      });
    } finally {
      setState(() => _isLoading = false);
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 64),
              const Text(
                "Thay đổi mật khẩu",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 32),

              // Mật khẩu mới
              TextField(
                obscureText: _obscurePassword,
                controller: _passwordController,
                cursorColor: AppColors.mainOrange,
                decoration: InputDecoration(
                  labelText: 'Mật khẩu mới',
                  prefixIcon: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Icon(Icons.lock),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFFF5722)),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFFF5722), width: 2.0),
                  ),
                  hintStyle: TextStyle(color: Colors.grey.withOpacity(0.5)),
                  floatingLabelStyle: const TextStyle(color: Colors.black),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                ),
              ),

              const SizedBox(height: 16),

              // Nhập lại mật khẩu mới
              TextField(
                obscureText: _obscurePassword,
                controller: _confirmPasswordController,
                cursorColor: AppColors.mainOrange,
                decoration: InputDecoration(
                  labelText: 'Nhập lại mật khẩu mới',
                  prefixIcon: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Icon(Icons.lock),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFFF5722)),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFFF5722), width: 2.0),
                  ),
                  hintStyle: TextStyle(color: Colors.grey.withOpacity(0.5)),
                  floatingLabelStyle: const TextStyle(color: Colors.black),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                ),
              ),

              const SizedBox(height: 16),

              const Text(
                "Mật khẩu mới có ít nhất 8 ký tự (bao gồm 1 ký tự viết hoa, 1 ký tự đặc biệt).",
                style: TextStyle(fontSize: 14, fontFamily: 'Inter', letterSpacing: 0.5),
              ),

              if (_errorText != null) ...[
                const SizedBox(height: 16),
                Text(
                  _errorText!,
                  style: const TextStyle(color: Colors.red, fontSize: 13),
                ),
              ],

              const SizedBox(height: 32),

              ElevatedButton(
                onPressed: _isLoading ? null : _handleSavePassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF5722),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  elevation: 4,
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Lưu mật khẩu",
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.white,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.bold,
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