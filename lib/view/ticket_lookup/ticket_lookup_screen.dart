import 'package:flutter/material.dart';
import 'package:giao_dien_1/config/default.dart';
import 'package:giao_dien_1/widget/appbar.dart';
import 'package:giao_dien_1/widget/footer.dart';

class TicketLookupScreen extends StatelessWidget {
  const TicketLookupScreen({super.key});

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
              'TRA CỨU THÔNG TIN ĐẶT VÉ',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.mainOrange,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Tìm thông tin đặt vé của mình',
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
                      prefixIcon: Icon(Icons.phone, color: AppColors.mainOrange),
                      hintText: '0765178079',
                      border: InputBorder.none,
                    ),
                  ),
                  const Divider(),
                  TextField(
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.confirmation_number,
                          color: AppColors.mainOrange),
                      hintText: 'Nhập mã vé',
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
                    child: const Text('Tìm vé',
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Image.asset(
              'assets/image/lookup_illustration.png',
              height: 150,
            ),
            const SizedBox(height: 10),
            const Text(
              'NHÀ XE NAM HẢI',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                  fontSize: 16),
            ),
            const Text(
              'NHỮNG CHUYẾN ĐI AN TOÀN',
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
