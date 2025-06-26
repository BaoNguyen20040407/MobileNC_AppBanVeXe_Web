import 'package:flutter/material.dart';
import 'package:giao_dien_1/config/default.dart';

class EditSuccessScreen extends StatelessWidget {
  const EditSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E0),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: Colors.orange, size: 80),
            const SizedBox(height: 20),
            const Text(
              'Thông tin đã được chỉnh sửa thành công',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // hoặc điều hướng về trang chính
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.mainOrange,
              ),
              child: const Text('Xem thông tin'),
            ),
          ],
        ),
      ),
    );
  }
}
