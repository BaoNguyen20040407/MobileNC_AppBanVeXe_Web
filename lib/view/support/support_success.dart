import 'package:flutter/material.dart';
import 'package:giao_dien_1/widget/appbar_profile.dart';

class SuccessPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFDF1E6),
      appBar: AppBarProfile(title: 'HỖ TRỢ'),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle,
                size: 80, color: Color(0xFFFF5722)),
            SizedBox(height: 24),
            Text(
              'Đặt câu hỏi thành công',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Text(
                'Quý khách nhấn nút Thêm câu hỏi dưới đây để có thể thêm các câu hỏi nếu cần hỗ trợ',
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFF5722),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Thêm câu hỏi',style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
