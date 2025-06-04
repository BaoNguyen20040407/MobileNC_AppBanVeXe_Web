import 'package:flutter/material.dart';
import 'homepage.dart';
import 'news.dart';

class News extends StatefulWidget {
  const News({super.key});

  @override
  State<News> createState() => _NewsState();
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

class _NewsState extends State<News> {
  int _selectedIndex = 3;

  final List<NewsItem> _newsList = [
  NewsItem(
    title: "NHÀ XE NAM HẢI TƯNG BỪNG KHAI TRƯƠNG VĂN PHÒNG MỚI",
    time: "14:00 15/04/2025",
    imageUrl: "image/news_01.png",
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
              Row(
                children: [
                  Text(
                    'TIN TỨC NỔI BẬT',
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

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: AssetImage(_newsList[0].imageUrl),
                        fit: BoxFit.cover,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          offset: Offset(0, 4), // dịch xuống
                          blurRadius: 4, // độ mờ
                          spreadRadius: 1, // độ lan rộng
                        ), 
                      ], 
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: Text(
                      _newsList[0].title,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Inter',
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: Text(
                      _newsList[0].time,
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Inter'
                      ),
                    ),
                  )
                ],
              ),

              const SizedBox(height: 8),
              
            ],
          ),
        ),
      ),

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color(0xFFD9D9D9),
              offset: Offset(0, -5),
              blurRadius: 4,
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 18),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _bottomNavItem("Trang chủ", Icons.home, 0, () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
            }),
            _bottomNavItem("Lịch trình", Icons.event_note, 1, () {
              // Ví dụ: Navigator.push(context, MaterialPageRoute(builder: (context) => LichTrinhPage()));
            }),
            _bottomNavItem("Tra cứu vé", Icons.confirmation_number, 2, () {
              // Ví dụ: Navigator.push(context, MaterialPageRoute(builder: (context) => TraCuuVePage()));
            }),
            _bottomNavItem("Tin tức", Icons.article, 3, () {
              // Đang ở trang News rồi, bạn có thể bỏ trống hoặc refresh tùy ý
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
          Icon(icon, size: 32, color: isSelected ? const Color(0xFFFF5722) : const Color(0xFFD9D9D9)),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontFamily: 'Inter')),
        ],
      ),
    );
  }
}