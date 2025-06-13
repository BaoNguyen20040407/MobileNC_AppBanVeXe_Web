import 'package:flutter/material.dart';
import 'package:giao_dien_1/view/news/news.dart';
import '../main/homepage.dart';
import 'package:giao_dien_1/widget/appbar.dart';
import 'package:giao_dien_1/widget/footer.dart';
import 'package:giao_dien_1/config/default.dart';
import 'package:giao_dien_1/model/news.dart';
import 'package:giao_dien_1/data/news_data.dart';
import 'package:giao_dien_1/widget/news_item.dart';
import 'package:giao_dien_1/widget/see_more_button.dart';
import 'package:giao_dien_1/widget/news_card.dart';
import 'package:giao_dien_1/widget/news_header.dart';
import 'package:giao_dien_1/widget/section_title.dart';

class NewsDetail02 extends StatefulWidget {
  const NewsDetail02({super.key});

  @override
  State<NewsDetail02> createState() => _NewsDetail02State();
}

class _NewsDetail02State extends State<NewsDetail02> {
  int _selectedIndex = 3; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(),
      
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'VIETTRAVEL TUNG KHUYẾN MÃI TẾT 2025: TẾT ĐI CHƠI XA - NHÀ TA THÊM GẦN',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Ngày đăng: 12:30 25/01/2025',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Thực hiện: Gia Bảo, Đăng Khoa',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 32),
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      offset: Offset(0, 4),
                      blurRadius: 4,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    'assets/image/promote_05.png',
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              Text.rich(
                TextSpan(
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.75,
                    fontFamily: 'Inter',
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: 'Ưu đãi hấp dẫn dành riêng cho mùa Tết:\n',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: '- Giảm đến 5 triệu đồng cho tour Tết trong và ngoài nước\n',
                    ),
                    TextSpan(
                      text: '- Mua tour - Trúng vàng thật mỗi tuần\n',
                    ),
                    TextSpan(
                      text: '- Ưu đãi "Mua nhóm - Giá sốc" dành cho đoàn gia đình từ 4 người trở lên\n',
                    ),
                    TextSpan(
                      text: '- Nhiều phần quà xuân may mắn từ Vietravel khi đăng ký sớm\n',
                    ),
                    WidgetSpan(
                      child: Icon(Icons.public, color: Color(0xFF006400), size: 18),
                      alignment: PlaceholderAlignment.middle,
                    ),
                    TextSpan(
                      text:
                          ' Hành trình rực rỡ - Gắn kết yêu thương\n',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text:
                          'Từ Nhật Bản, Hàn Quốc, Đài Loan, đến châu Âu hay tour miền Trung - Tây Bắc, mỗi chuyến đi Tết là dịp để cả nhà cùng nhau trải nghiệm, thêm gắn bó và lưu giữ những khoảnh khắc ý nghĩa đầu năm.\n',
                    ),
                    WidgetSpan(
                      child: Icon(Icons.card_giftcard, color: Color(0xFF006400), size: 18),
                      alignment: PlaceholderAlignment.middle,
                    ),
                    TextSpan(
                      text: ' Đăng ký ngay hôm nay để:\n',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: '- Lựa chọn tour đẹp, chỗ tốt\n',
                    ),
                    TextSpan(
                      text: '- Nhận trọn ưu đãi & quà tặng giới hạn\n',
                    ),
                    WidgetSpan(
                      child: Icon(Icons.phone, color: Color(0xFF006400), size: 18),
                      alignment: PlaceholderAlignment.middle,
                    ),
                    TextSpan(
                      text: ' Hotline tư vấn: ',
                    ),
                    TextSpan(
                      text: '1900 1839\n',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    WidgetSpan(
                      child: Icon(Icons.language, color: Color(0xFF006400), size: 18),
                      alignment: PlaceholderAlignment.middle,
                    ),
                    TextSpan(
                      text: ' Website: ',
                    ),
                    TextSpan(
                      text: 'www.vietravel.com',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 32),

              Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF5722),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), 
                  ),
                  elevation: 5, 
                  shadowColor: Color(0xFFFF5722),
                ),
                child: const Text(
                  "Trở về trang trước",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    fontFamily: 'Inter'
                  ),
                ),
              ),
            ),
            const SizedBox(height: 64),

            //Dòng chảy tin tức
              SectionTitle(title: 'DÒNG CHẢY TIN TỨC'),
              const SizedBox(height: 32),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: NewsItem(
                      imageUrl: newsList[8].imageUrl,
                      title: newsList[8].title,
                      time: newsList[8].time,
                    ),
                  ),
                  const SizedBox(width: 32),
                  Expanded(
                    child: NewsItem(
                      imageUrl: newsList[9].imageUrl,
                      title: newsList[9].title,
                      time: newsList[9].time,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: NewsItem(
                      imageUrl: newsList[10].imageUrl,
                      title: newsList[10].title,
                      time: newsList[10].time,
                    ),
                  ),
                  const SizedBox(width: 32),
                  Expanded(
                    child: NewsItem(
                      imageUrl: newsList[11].imageUrl,
                      title: newsList[11].title,
                      time: newsList[11].time,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),

      bottomNavigationBar: FooterNavigation(),
    );
  }
}