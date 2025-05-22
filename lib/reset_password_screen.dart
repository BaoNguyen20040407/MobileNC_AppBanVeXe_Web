import 'package:flutter/material.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: true, elevation: 0),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Thay đổi mật khẩu", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              obscureText: _obscurePassword,
              controller: passwordController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.lock_outline),
                labelText: 'Mật khẩu mới',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                  onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              obscureText: _obscurePassword,
              controller: confirmPasswordController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.lock_outline),
                labelText: 'Nhập lại mật khẩu mới',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                  onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "Mật khẩu mới có ít nhất 8 ký tự (bao gồm 1 ký tự viết hoa, 1 ký tự đặc biệt).",
              style: TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFF5722),
                ),
                onPressed: () {
                  // TODO: xử lý lưu mật khẩu mới
                  Navigator.pop(context);
                },
                child: const Text("Lưu mật khẩu"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
