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


class NewsDetail01 extends StatefulWidget {
  const NewsDetail01({super.key});

  @override
  State<NewsDetail01> createState() => _NewsDetail01State();
}

class _NewsDetail01State extends State<NewsDetail01> {
  int _selectedIndex = 3; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(),
      
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const NewsHeader(
                title: 'NHÀ XE NAM HẢI TƯNG BỪNG KHAI TRƯƠNG VĂN PHÒNG MỚI TẠI GÒ DẦU – TÂY NINH',
                date: '14:00 15/04/2025',
                authors: 'Gia Bảo, Đăng Khoa',
                imagePath: 'assets/image/news_01.png',
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
                      text:
                          'Nhằm mở rộng mạng lưới vận chuyển và đáp ứng nhu cầu đi lại tăng cao của Quý Khách khu vực Tây Ninh, Nhà Xe Nam Hải chính thức khai trương Văn phòng Gò Dầu kể từ ngày 03/04/2025.\n',
                    ),
                    TextSpan(
                      text: 'Tại Văn phòng Gò Dầu:\n',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text:
                          '- Phục vụ bán vé các tuyến Bến xe Tân Biên, Bến xe Tây Ninh, Bến xe Hòa Thành - Bến xe An Sương và ngược lại\n',
                    ),
                    TextSpan(
                      text:
                          '- Tận hưởng hành trình êm ái, tiện nghi với dòng xe đời mới, hiện đại giúp Quý Khách an tâm di chuyển trên mọi nẻo đường.\n',
                    ),
                    TextSpan(
                      text:
                          '- Đội ngũ chuyên nghiệp, hỗ trợ giải đáp mọi thắc mắc về lịch trình, giá vé, dịch vụ cho Quý Khách.\n',
                    ),
                    TextSpan(
                      text:
                          '- Trung chuyển MIỄN PHÍ trong bán kính 8-10km tại Huyện Gò Dầu và các khu vực lân cận giúp Quý Khách tối ưu chi phí di chuyển.\n',
                    ),
                    TextSpan(
                      text: '- Nhận vận chuyển hàng hóa đi toàn quốc với giá cực ưu đãi.\n',
                    ),
                    TextSpan(
                      text:
                          'Địa chỉ văn phòng: QL22, Khu phố Thanh Bình B, Thị trấn Gò Dầu, Huyện Gò Dầu, Tây Ninh.\n',
                    ),
                    TextSpan(
                      text:
                          'Thời gian hoạt động: 24/24, phục vụ cả Chủ Nhật & Ngày Lễ.\n',
                    ),
                    TextSpan(
                      text:
                          'Với mục tiêu không ngừng nâng cao chất lượng dịch vụ, Nhà Xe Nam Hải tin rằng Văn phòng Gò Dầu sẽ trở thành điểm đến thân quen của bà con Tây Ninh, đáp ứng nhu cầu di chuyển an toàn và tiện lợi.\n',
                    ),
                    TextSpan(
                      text:
                          'Đặt vé ngay trên ứng dụng Nhà Xe Nam Hải hoặc truy cập namhai.vn để cập nhật thông tin và thuận tiện cho việc đặt vé nhé!\n',
                    ),
                    WidgetSpan(
                      child: Icon(Icons.favorite, color: Color(0xFF006400), size: 18),
                      alignment: PlaceholderAlignment.middle,
                    ),
                    TextSpan(
                      text: ' Nhà Xe Nam Hải hân hạnh được phục vụ Quý Khách!\n',
                    ),
                    WidgetSpan(
                      child: Icon(Icons.info, color: Color(0xFF006400), size: 18),
                      alignment: PlaceholderAlignment.middle,
                    ),
                    TextSpan(
                      text: ' Thông tin chi tiết xin vui lòng liên hệ:\n',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    WidgetSpan(
                      child: Icon(Icons.phone, color: Color(0xFF006400), size: 18),
                      alignment: PlaceholderAlignment.middle,
                    ),
                    TextSpan(
                      text: ' Tổng đài hỗ trợ đặt vé tại Tây Ninh: ',
                    ),
                    TextSpan(
                      text: '1900 6913\n',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    WidgetSpan(
                      child: Icon(Icons.support_agent, color: Color(0xFF006400), size: 18),
                      alignment: PlaceholderAlignment.middle,
                    ),
                    TextSpan(
                      text: ' Trung Tâm Tổng Đài & CSKH: ',
                    ),
                    TextSpan(
                      text: '1900 6067',
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
                  backgroundColor: AppColors.mainOrange,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), 
                  ),
                  elevation: 5, 
                  shadowColor: AppColors.mainOrange,
                ),
                child: const Text(
                  "Trở về trang trước",
                  style: TextStyle(
                    color: AppColors.white,
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
                      imageUrl: newsList[1].imageUrl,
                      title: newsList[1].title,
                      time: newsList[1].time,
                    ),
                  ),
                  const SizedBox(width: 32),
                  Expanded(
                    child: NewsItem(
                      imageUrl: newsList[2].imageUrl,
                      title: newsList[2].title,
                      time: newsList[2].time,
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
                      imageUrl: newsList[3].imageUrl,
                      title: newsList[3].title,
                      time: newsList[3].time,
                    ),
                  ),
                  const SizedBox(width: 32),
                  Expanded(
                    child: NewsItem(
                      imageUrl: newsList[5].imageUrl,
                      title: newsList[5].title,
                      time: newsList[5].time,
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