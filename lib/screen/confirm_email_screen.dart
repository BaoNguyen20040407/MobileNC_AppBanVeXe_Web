import 'package:flutter/material.dart';
import 'reset_password_screen.dart';

class ConfirmEmailScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();

  ConfirmEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: true, elevation: 0),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Xác nhận Email", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.email_outlined),
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
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
                  Navigator.push(context, MaterialPageRoute(builder: (_) => ResetPasswordScreen()));
                },
                child: const Text("Tiếp tục"),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Bằng việc xác nhận Email đang dùng, bạn có thể thay đổi mật khẩu mà mình mong muốn",
              style: TextStyle(fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
