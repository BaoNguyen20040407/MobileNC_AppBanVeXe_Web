import 'package:flutter/material.dart';
import 'package:giao_dien_1/widget/appbar_profile.dart';
import 'package:giao_dien_1/config/default.dart';

class SuccessPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softOrangeBackground,
      appBar: AppBarProfile(title: 'HỖ TRỢ'),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle,
                size: 80, color: Color(0xFFFF5722)),
            SizedBox(height: 32),
            Text(
              'Đặt câu hỏi thành công',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Inter',
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Text(
                'Quý khách nhấn nút Thêm câu hỏi dưới đây để có thể thêm các câu hỏi nếu cần hỗ trợ',
                textAlign: TextAlign.center, 
                style: TextStyle(
                  fontFamily: 'Inter', 
                  fontSize: 14,
                ),
              ),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.mainOrange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Thêm câu hỏi', 
                style: TextStyle(
                  color: Colors.white, 
                  fontFamily: 'Inter', 
                  fontSize: 14,
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
