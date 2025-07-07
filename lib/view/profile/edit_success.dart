import 'package:flutter/material.dart';
import 'package:giao_dien_1/config/default.dart';
import 'package:giao_dien_1/widget/appbar_profile.dart';

class EditSuccessScreen extends StatelessWidget {
  const EditSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softOrangeBackground,
      appBar: AppBarProfile(title: 'SỬA THÔNG TIN TAI KHOẢN'),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: AppColors.mainOrange, size: 80),
            const SizedBox(height: 20),
            const Text(
              'Thông tin đã được chỉnh sửa\nthành công',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, fontFamily: 'Inter'),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.mainOrange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              onPressed: () {
                Navigator.pop(context); // hoặc điều hướng về trang chính
              },
              child: const Text('Xem thông tin', 
              style: TextStyle(
                fontFamily: 'Inter', 
                fontWeight: FontWeight.bold, 
                fontSize: 14),),
            ),
          ],
        ),
      ),
    );
  }
}
