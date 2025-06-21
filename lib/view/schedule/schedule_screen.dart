import 'package:flutter/material.dart';
import 'package:giao_dien_1/config/default.dart';
import 'package:giao_dien_1/widget/appbar.dart';
import 'package:giao_dien_1/widget/footer.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              'LỊCH TRÌNH CÁC CHUYẾN ĐI',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.mainOrange,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Cùng bạn đi trên mọi nẻo đường',
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.mainOrange,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  )
                ],
              ),
              child: Column(
                children: [
                  TextField(
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.location_pin, color: AppColors.mainOrange),
                      hintText: 'Nhập điểm đi',
                      border: InputBorder.none,
                    ),
                  ),
                  const Divider(),
                  TextField(
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.location_pin,
                          color: AppColors.mainOrange),
                      hintText: 'Nhập điểm đến',
                      border: InputBorder.none,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.mainOrange,
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 80),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 4,
                    ),
                    child: const Text('Tìm chuyến xe',
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Image.asset(
              'assets/image/bus_trip_illustration.png',
              height: 150,
            ),
            const SizedBox(height: 10),
            const Text(
              'XE TRUNG CHUYỂN',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                  fontSize: 16),
            ),
            const Text(
              'ĐÓN TRẢ TẬN NƠI',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                  fontSize: 16),
            ),
          ],
        ),
      ),
      bottomNavigationBar: FooterNavigation(),
    );
  }
}
