import 'package:flutter/material.dart';
import 'package:giao_dien_1/view/about/about_us_page3.dart';
import '../main/homepage.dart';
import '../news/news.dart';
import 'package:giao_dien_1/widget/appbar.dart';
import 'package:giao_dien_1/widget/footer.dart';
import 'package:giao_dien_1/config/default.dart';

class AboutUsPage2 extends StatelessWidget {
  const AboutUsPage2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,

      //AppBar
      appBar: AppBar(),

      //Body
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                "TẦM NHÌN VÀ SỨ MỆNH",
                style: TextStyle(
                  color: AppColors.mainOrange,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Inter',
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Center(
              child: Text(
                "Vì 1 Việt Nam vươn mình",
                style: TextStyle(
                  color: AppColors.black,
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
                    color: AppColors.black, fontSize: 16, height: 2.0, fontFamily: 'Inter'),
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
                          color: AppColors.mainOrange, fontWeight: FontWeight.bold)),
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
                  'assets/image/about_us_1.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(height: 32),
            const Center(
              child: Text(
                "GIÁ TRỊ CỐT LÕI",
                style: TextStyle(
                  color: AppColors.mainOrange,
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
                  color: AppColors.mainOrange,
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
                    color: AppColors.black, fontSize: 16, height: 2, fontFamily: 'Inter'),
                children: [
                  TextSpan(
                      text: "NAM:",
                      style: TextStyle(
                          color: AppColors.mainOrange, fontWeight: FontWeight.bold)),
                  TextSpan(
                      text:
                          " Tượng trưng cho sự ấm áp, bao dung, hướng tới tương lai.\n"),
                  TextSpan(
                      text: "HẢI:",
                      style: TextStyle(
                          color: AppColors.mainOrange, fontWeight: FontWeight.bold)),
                  TextSpan(
                      text:
                          " Tượng trưng cho sự bao la, rộng lớn và sâu sắc, nối kết các đại lục.\n"),
                  TextSpan(
                      text: "NAM HẢI:",
                      style: TextStyle(
                          color: AppColors.mainOrange, fontWeight: FontWeight.bold)),
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
                  'assets/image/about_us_2.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(height: 32),
            const Center(
              child: Text(
                "TRIẾT LÝ",
                style: TextStyle(
                  color: AppColors.mainOrange,
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
                  color: AppColors.black,
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
                color: AppColors.black,
                fontSize: 16,
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
                  'assets/image/about_us_3.png',
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
                  backgroundColor: AppColors.mainOrange,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 5,
                  shadowColor: AppColors.mainOrange,
                ),
                child: const Text(
                  "Xem tiếp",
                  style: TextStyle(
                    color: AppColors.white,
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