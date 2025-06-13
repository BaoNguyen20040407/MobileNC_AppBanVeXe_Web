import 'package:flutter/material.dart';
import 'package:giao_dien_1/view/news/news.dart';
import '../main/homepage.dart';
import 'package:giao_dien_1/config/default.dart';
import 'package:giao_dien_1/widget/appbar.dart';
import 'package:giao_dien_1/widget/footer.dart';

class AboutUsPage3 extends StatelessWidget {
  const AboutUsPage3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,

      //AppBar
      appBar: CustomAppBar(),

      //Body
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                "CƠ SỞ VẬT CHẤT",
                style: TextStyle(
                  color: AppColors.mainOrange,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Inter',
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text.rich(
              TextSpan(
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: 16,
                  height: 2.0,
                  fontFamily: 'Inter',
                ),
                children: [
                  TextSpan(
                      text:
                          "Tuân thủ phương châm “Vì những chuyến xe an toàn cho bạn”. Công ty quản lý xe khách Nam Hải hiện đang khai thác hơn 250 phòng vé, với đội ngũ nhân viên lên 9.000 người. "
                          "Chúng tôi hiện đang sở hữu 4.500 đầu xe các loại, trong đó có hơn 1.500 xe giường nằm, vận hành hơn 125 tuyến liên tỉnh với 5.500 chuyến được khai thác mỗi ngày. "),
                  TextSpan(
                      text:
                          "Thương hiệu Nam Hải đã trở thành thương hiệu được lựa chọn của hàng triệu lượt khách mỗi năm.",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              height: 345, 
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  'assets/image/about_us_4.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 32),
            const Center(
              child: Text(
                "TRẠM DỪNG CHÂN",
                style: TextStyle(
                  color: AppColors.mainOrange,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Inter',
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Nắm bắt được nhu cầu nghỉ ngơi sau những chuyến đi dài qua nhiều thành phố. "
              "Công ty có một số trạm dừng chân tọa lạc tại các tỉnh thành như: Thủ đô Hà Nội, TP. Đà Nẵng, TP. Nha Trang, Bình Thuận, TP. Hồ Chí Minh, Bình Dương, TP. Cần Thơ, Bạc Liêu, Cà Mau.",
              style: TextStyle(fontSize: 16, height: 2, fontFamily: 'Inter'),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 8),
            const Text(
              "Các trạm dừng chân Nam Hải Vui Tươi với chỗ nghỉ đầy đủ tiện nghi (giường, chiếu, phòng máy lạnh...), phục vụ những món ăn đặc sản theo vùng miền.",
              style: TextStyle(fontSize: 16, height: 2, fontFamily: 'Inter'),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              height: 345, 
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  'assets/image/about_us_5.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 32),
            const Center(
              child: Text(
                "APPLICATION",
                style: TextStyle(
                  color: AppColors.mainOrange,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Inter',
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text.rich(
              TextSpan(
                style: TextStyle(
                    color: AppColors.black, fontSize: 16, height: 2, fontFamily: 'Inter'),
                children: [
                  TextSpan(
                      text:
                          "Cùng với việc mở rộng mạng lưới phát triển, Công ty hiện tại đang ứng dụng những công nghệ tiên tiến mới nhất vào hoạt động kinh doanh. "
                          "Khách hàng chỉ cần một chiếc điện thoại và với vài thao tác đơn giản là đã có thể đặt được vé xe như mong muốn, "
                          "cũng như tận hưởng những chương trình khuyến mãi của các đối tượng trong từng thời điểm. Hãy trải nghiệm "),
                  TextSpan(
                      text: "Nam Hải App ",
                      style:
                          TextStyle(color: AppColors.black, fontWeight: FontWeight.bold)),
                  TextSpan(
                      text:
                          "ngay để tận hưởng những tiện nghi công nghệ thông tin mới nhất – chúng tôi luôn hân hạnh phục vụ bạn."),
                ],
              ),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              height: 345, 
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  'assets/image/about_us_6.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 32),
            Center(
              child: ElevatedButton(
                onPressed: () {
                    Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => HomePage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.mainOrange,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 5,
                  shadowColor: AppColors.mainOrange,
                ),
                child: const Text(
                  "Trở về trang chủ",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
      
      //Footer
      bottomNavigationBar: FooterNavigation(),
    );
  }
}