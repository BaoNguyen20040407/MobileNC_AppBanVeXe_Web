import 'package:flutter/material.dart';
import 'package:giao_dien_1/screen/news.dart';
import 'homepage.dart';

class NewsDetail01 extends StatefulWidget {
  const NewsDetail01({super.key});

  @override
  State<NewsDetail01> createState() => _NewsDetail01State();
}

class NewsItem {
  final String title;
  final String time;
  final String imageUrl;

  NewsItem({
    required this.title,
    required this.time,
    required this.imageUrl,
  });
}

class _NewsDetail01State extends State<NewsDetail01> {
  int _selectedIndex = 3; 

  final List<NewsItem> _newsList = [

  NewsItem(
    title: "NHÀ XE NAM HẢI TƯNG BỪNG KHAI TRƯƠNG TUYẾN MỚI TRONG THÁNG - BẾN XE BUÔN HỒ - BẾN XE MIỀN TÂY (TP.HCM)",
    time: "09:20 15/04/2025",
    imageUrl: "image/news_02.png",
  ),

  NewsItem(
    title: "CHỈ 100.000 ĐỒNG DI CHUYỂN THUẬN LỢI TỪ BẾN XE MIỀN TÂY - BẾN XE THÁP MƯỜI CÙNG NHÀ XE NAM HẢI",
    time: "08:55 15/04/2025",
    imageUrl: "image/news_03.png",
  ),

  NewsItem(
    title: "NHÀ XE NAM HẢI THÔNG BÁO THAY ĐỔI ĐẦU SỐ TỔNG ĐÀI CHI NHÁNH CÀ MAU",
    time: "08:45 15/04/2025",
    imageUrl: "image/news_04.png",
  ),

  NewsItem(
    title: "THÔNG BÁO ĐIỀU CHỈNH LỘ TRÌNH KẾT NỐI TUYẾN XE BUÝT ĐIỆN TẠI GA BẾN THÀNH - TPHCM TỪ 16/04/2025",
    time: "08:40 15/04/2025",
    imageUrl: "image/news_06.png",
  ),
];

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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'NHÀ XE NAM HẢI TƯNG BỪNG KHAI TRƯƠNG VĂN PHÒNG MỚI',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Ngày đăng: 14:00 15/04/2025',
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
                    'image/news_01.png',
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
                  backgroundColor: const Color(0xFFFF5722),
                  padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 18),
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
              Row(
                children: [
                  Text(
                    'DÒNG CHẢY TIN TỨC',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Color(0xFF006400),
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Divider(
                      color: Color(0xFF006400),
                      thickness: 5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: AssetImage(_newsList[0].imageUrl),
                              fit: BoxFit.cover,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                offset: Offset(0, 4),
                                blurRadius: 4,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _newsList[0].title,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Inter',
                          ),
                          textAlign: TextAlign.justify,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _newsList[0].time,
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'Inter',
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(width: 32),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: AssetImage(_newsList[1].imageUrl),
                              fit: BoxFit.cover,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                offset: Offset(0, 4),
                                blurRadius: 4,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _newsList[1].title,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Inter',
                          ),
                          textAlign: TextAlign.justify,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _newsList[1].time,
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 32),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: AssetImage(_newsList[2].imageUrl),
                              fit: BoxFit.cover,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                offset: Offset(0, 4),
                                blurRadius: 4,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _newsList[2].title,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Inter',
                          ),
                          textAlign: TextAlign.justify,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _newsList[2].time,
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'Inter',
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(width: 32),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: AssetImage(_newsList[3].imageUrl),
                              fit: BoxFit.cover,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                offset: Offset(0, 4),
                                blurRadius: 4,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _newsList[3].title,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Inter',
                          ),
                          textAlign: TextAlign.justify,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _newsList[3].time,
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),

      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color(0xFFD9D9D9),
              offset: Offset(0, -5),
              blurRadius: 4,
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _bottomNavItem("Trang chủ", Icons.home, 0, () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
            }),
            _bottomNavItem("Lịch trình", Icons.event_note, 1, () {
              // TODO: Điều hướng đến trang Lịch trình
            }),
            _bottomNavItem("Tra cứu vé", Icons.confirmation_number, 2, () {
              // TODO: Điều hướng đến trang Tra cứu vé
            }),
            _bottomNavItem("Tin tức", Icons.article, 3, () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => News()));
            }),
          ],
        ),
      ),
    );
  }

  Widget _bottomNavItem(String title, IconData icon, int index, VoidCallback onTap) {
    final isSelected = _selectedIndex == index;

    return TextButton(
      onPressed: () {
        setState(() {
          _selectedIndex = index;
        });
        onTap();
      },
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.all(Colors.transparent),
        foregroundColor: MaterialStateProperty.all(Colors.black),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 32,
            color: isSelected ? const Color(0xFFFF5722) : const Color(0xFFD9D9D9),
          ),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontFamily: 'Inter')),
        ],
      ),
    );
  }
}
