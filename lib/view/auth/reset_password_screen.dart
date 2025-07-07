import 'package:flutter/material.dart';
import 'package:giao_dien_1/config/default.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;

  // Lưu mật khẩu mới vào SharedPreferences
  Future<void> _saveNewPassword(String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('password', password);
  }

  // Xử lý xác thực và lưu mật khẩu
  void _handleSavePassword() async {
    final newPassword = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (newPassword.length < 8) {
      _showError('Mật khẩu phải có ít nhất 8 ký tự.');
      return;
    }

    if (newPassword != confirmPassword) {
      _showError('Mật khẩu nhập lại không khớp.');
      return;
    }

    await _saveNewPassword(newPassword);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đổi mật khẩu thành công', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold),), backgroundColor: AppColors.greenDark),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message, style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold)), backgroundColor: AppColors.red),
    );
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
              controller: passwordController,
              cursorColor: AppColors.mainOrange,
              decoration: InputDecoration(
                labelText: 'Mật khẩu mới',
                prefixIcon: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Icon(Icons.lock),
                ),
                suffixIcon: IconButton(
                  icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
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
              controller: confirmPasswordController,
              cursorColor: AppColors.mainOrange,
              decoration: InputDecoration(
                labelText: 'Nhập lại mật khẩu mới',
                prefixIcon: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Icon(Icons.lock),
                ),
                suffixIcon: IconButton(
                  icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
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
            const SizedBox(height: 32),

            // Nút lưu
            ElevatedButton(
              onPressed: _handleSavePassword,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF5722),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                elevation: 4,
                minimumSize: const Size(double.infinity, 48),
              ),
              child: const Text(
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
    );
  }
}