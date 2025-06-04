import 'package:flutter/material.dart';
import 'package:giao_dien_1/screen/about_us_page2.dart';
import 'package:giao_dien_1/screen/news.dart';
import 'homepage.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // ✅ AppBar tuỳ chỉnh theo thiết kế
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Container(
          padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
          color: const Color(0xffFDE5DE),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                "assets/image/namhailogo.png",
                height: 32,
                width: 60,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "NHÀ XE NAM HẢI",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff006400),
                        fontFamily: 'Inter',
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      "Vì những chuyến xe an toàn cho bạn",
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xffFF0000),
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              ),
              Image.asset(
                "assets/image/personicon.png",
                height: 32,
                width: 32,
              ),
            ],
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  "NHÀ XE NAM HẢI",
                  style: TextStyle(
                      color: Color(0xFFFF5722),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Inter'),
                ),
              ),
              const SizedBox(height: 8),
              const Center(
                child: Text(
                  "Vì những chuyến xe an toàn cho bạn",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Inter'),
                ),
              ),
              const SizedBox(height: 16),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text:
                          "Công ty quản lý xe khách Nam Hải (Nhà xe Nam Hải) được thành lập vào ngày 09/09/2004. ",
                      style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Inter', fontSize: 14),
                    ),
                    TextSpan(
                      text:
                          "Với hoạt động kinh doanh chính trong lĩnh vực vận tải hành khách và kinh doanh dịch vụ. "
                          "Nam Hải dần trở thành cái tên quen thuộc trên những nẻo đường của người Việt.",
                      style: TextStyle(fontFamily: 'Inter', fontSize: 14)
                    ),
                  ],
                ),
                textAlign: TextAlign.justify,
                style: TextStyle(color: Colors.black, height: 2.0),
              ),
              const SizedBox(height: 16),
              const Text(
                "Trải qua 20 năm hình thành với mục tiêu khách hàng là trọng tâm,"
                " chúng tôi tự hào là một trong những doanh nghiệp có chất lượng vận tải tốt nhất tại Việt Nam,"
                " góp phần không nhỏ trong việc phát triển kinh tế đất nước lên một tầm cao mới. Luôn cải tiến dịch vụ để mang đến những trải nghiệm tốt nhất cho khách hàng,"
                " Công ty có nhiều giải thưởng danh giá như “Thương hiệu số 1 Việt Nam”, "
                "“Top 10 dịch vụ hoàn hảo vì quyền lợi người tiêu dùng năm 2024”, "
                "“Top 5 thương hiệu - sản phẩm uy tín cho các doanh nghiệp tại Việt Nam năm 2024”…",
                style: TextStyle(color: Colors.black, fontSize: 14, height: 2.0, fontFamily: 'Inter'),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 32),
              const Center(
                child: Text(
                  "LOGO NHẬN DIỆN",
                  style: TextStyle(
                      color: Color(0xffFF5722),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Inter'),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Column(
                  children: const [
                    Image(
                      image: AssetImage("assets/image/logovexekhach_1.png"),
                      width: 250,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AboutUsPage2()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF5722),
                  padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // bo tròn mềm mại
                  ),
                  elevation: 5, // đổ bóng nhẹ
                  shadowColor: Color(0xFFFF5722),
                ),
                child: const Text(
                  "Xem tiếp",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    fontFamily: 'Inter'
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),

            ],
          ),
        ),
      ),

      //Footer
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white, // nền trắng hoặc màu bạn muốn
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15), // màu bóng, bạn chỉnh opacity cho nhẹ/dày
              offset: const Offset(0, -3), // bóng nằm phía trên (hướng lên trên)
              blurRadius: 6,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _bottomNavItem(
              context,
              "Trang chủ",
              Icons.home,
              HomePage(),
            ),
            _bottomNavItem(
              context,
              "Lịch trình",
              Icons.event_note,
              HomePage(),
            ),
            _bottomNavItem(
              context,
              "Tra cứu vé",
              Icons.confirmation_number,
              HomePage(),
            ),
            _bottomNavItem(
              context,
              "Tin tức",
              Icons.article,
              News(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bottomNavItem(
    BuildContext context,
    String title,
    IconData icon,
    Widget destinationScreen,
    ) 
  {
  return TextButton(
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => destinationScreen),
      );
    },
    style: ButtonStyle(
      overlayColor: MaterialStateProperty.all(Colors.transparent),
      foregroundColor: MaterialStateProperty.all(Colors.black),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 32, color: const Color(0xFFD9D9D9)),
        const SizedBox(height: 8),
        Text(title, style: const TextStyle(fontFamily: 'Inter')),
        ],
      ),
    );
  }
}