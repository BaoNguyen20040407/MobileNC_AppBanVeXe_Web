import 'package:flutter/material.dart';
import 'package:giao_dien_1/screen/news.dart';
import 'homepage.dart';

class NewsDetail02 extends StatefulWidget {
  const NewsDetail02({super.key});

  @override
  State<NewsDetail02> createState() => _NewsDetail02State();
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

class _NewsDetail02State extends State<NewsDetail02> {
  int _selectedIndex = 3; 

  final List<NewsItem> _newsList = [

  NewsItem(
    title: "THỨ TƯ VUI VẺ - THANH TOÁN VÉ XE CỦA NHÀ XE NAM HẢI BẰNG MOMO - GIẢM ĐẾN 50.000Đ CÙNG BẠN VUI VẺ",
    time: "09:20 15/04/2025",
    imageUrl: "assets/image/news_09.png",
  ),

  NewsItem(
    title: "KHUYẾN MÃI LÊN ĐẾN 50.000Đ KHI MUA VÉ NAM HẢI - FUTA BUS LINES & THANH TOÁN BẰNG VNPAY-QR",
    time: "08:55 15/04/2025",
    imageUrl: "assets/image/news_10.jpg",
  ),

  NewsItem(
    title: "COMBO 39K SIÊU TIẾT KIỆM, BỔ SUNG NĂNG LƯỢNG CHO CHUYẾN ĐI DÀI CÙNG BẠN VUI VẺ VỚI NHÀ XE",
    time: "08:45 15/04/2025",
    imageUrl: "assets/image/news_11.png",
  ),

  NewsItem(
    title: "NHẬP MÃ KHUYẾN MÃI NAMHAI100 - GIẢM 15% TỐI ĐA 100K CHO KHÁCH HÀNG MỚI",
    time: "08:40 15/04/2025",
    imageUrl: "assets/image/news_12.jpg",
  ),
];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Container(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
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
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff006400),
                        fontFamily: 'Inter',
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      "Vì những chuyến xe an toàn cho bạn",
                      style: TextStyle(
                        fontSize: 12,
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
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
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
          const SizedBox(height: 4),
          Text(title, style: const TextStyle(fontFamily: 'Inter')),
        ],
      ),
    );
  }
}
