import 'package:flutter/material.dart';
import 'package:giao_dien_1/screen/about_us_page3.dart';
import 'homepage.dart';
import 'news.dart';

class AboutUsPage2 extends StatelessWidget {
  const AboutUsPage2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                "TẦM NHÌN VÀ SỨ MỆNH",
                style: TextStyle(
                  color: Color(0xffFF5722),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Inter',
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Center(
              child: Text(
                "Vì 1 Việt Nam vững mạnh kinh tế - xã hội",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Inter',
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text.rich(
              TextSpan(
                style: const TextStyle(
                    color: Colors.black, fontSize: 14, height: 2.0, fontFamily: 'Inter'),
                children: [
                  const TextSpan(
                    text:
                        "Trở thành công ty uy tín hàng đầu Việt Nam với cam kết:\n",
                  ),
                  const TextSpan(
                      text: "  • Tạo môi trường làm việc năng động, thân thiện.\n"),
                  const TextSpan(
                      text: "  • Lòng tin của khách hàng là chất lượng của công ty.\n"),
                  const TextSpan(
                      text: "  • Trở thành công ty vận tải hàng đầu đất nước.\n"),
                  const TextSpan(
                      text: "Nam Hải ",
                      style: TextStyle(
                          color: Color(0xffFF5722), fontWeight: FontWeight.bold)),
                  const TextSpan(
                      text:
                          "luôn phát triển để tạo nên một Việt Nam vững mạnh về kinh tế - xã hội."),
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
                  'image/about_us_1.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(height: 32),
            const Center(
              child: Text(
                "GIÁ TRỊ CỐT LÕI",
                style: TextStyle(
                  color: Color(0xffFF5722),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Inter',
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Center(
              child: Text(
                "Giá trị cốt lõi - Nam Hải",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Inter',
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text.rich(
              TextSpan(
                style: TextStyle(
                    color: Colors.black, fontSize: 14, height: 2, fontFamily: 'Inter'),
                children: [
                  TextSpan(
                      text: "NAM:",
                      style: TextStyle(
                          color: Color(0xffFF5722), fontWeight: FontWeight.bold)),
                  TextSpan(
                      text:
                          " Tượng trưng cho sự ấm áp, bao dung, hướng tới tương lai.\n"),
                  TextSpan(
                      text: "HẢI:",
                      style: TextStyle(
                          color: Color(0xffFF5722), fontWeight: FontWeight.bold)),
                  TextSpan(
                      text:
                          " Tượng trưng cho sự bao la, rộng lớn và sâu sắc, nối kết các đại lục.\n"),
                  TextSpan(
                      text: "NAM HẢI:",
                      style: TextStyle(
                          color: Color(0xffFF5722), fontWeight: FontWeight.bold)),
                  TextSpan(
                      text:
                          " Những chuyến xe nối kết mọi nơi bằng sự ấm áp, bao dung.\n"),
                ],
              ),
              textAlign: TextAlign.justify,
            ),
            Container(
              width: double.infinity,
              height: 345, 
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  'image/about_us_2.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(height: 32),
            const Center(
              child: Text(
                "TRIẾT LÝ",
                style: TextStyle(
                  color: Color(0xffFF5722),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Inter',
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Center(
              child: Text(
                "Hành trình an toàn",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Inter',
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Nhà xe Nam Hải cam kết mang đến hành trình an toàn, chất lượng và đáng tin cậy cho mỗi hành khách. "
              "Chúng tôi đặt sự hài lòng của khách hàng lên hàng đầu, lấy uy tín và tận tâm làm kim chỉ nam trong mọi hoạt động."
              " Với tinh thần phục vụ chuyên nghiệp và sự đồng hành bền bỉ, Nam Hải không chỉ là phương tiện di chuyển mà còn là người bạn đồng hành tin cậy trên mỗi chặng đường,"
              " mang đến cho khách hàng những trải nghiệm tốt nhất, chất lượng nhất, sự an toàn chỉnh chu trong từng khâu phục vụ khách hàng, góp phần nâng cao nền kinh tế nước nhà.",
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                height: 2,
                fontFamily: 'Inter',
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
                  'image/about_us_3.png',
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
                    MaterialPageRoute(
                        builder: (context) => const AboutUsPage3()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFF5722),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 64, vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 5,
                  shadowColor: Color(0xFFFF5722),
                ),
                child: const Text(
                  "Xem tiếp",
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