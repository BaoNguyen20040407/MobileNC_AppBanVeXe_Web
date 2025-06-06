import 'package:flutter/material.dart';
import 'package:giao_dien_1/screen/news_detail_01.dart';
import 'homepage.dart';

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
    imageUrl: "assets/image/news_01.png",
  ),

  NewsItem(
    title: "NHÀ XE NAM HẢI TƯNG BỪNG KHAI TRƯƠNG TUYẾN MỚI TRONG THÁNG - BẾN XE BUÔN HỒ - BẾN XE MIỀN TÂY (TP.HCM)",
    time: "09:20 15/04/2025",
    imageUrl: "assets/image/news_02.png",
  ),

  NewsItem(
    title: "CHỈ 100.000 ĐỒNG DI CHUYỂN THUẬN LỢI TỪ BẾN XE MIỀN TÂY - BẾN XE THÁP MƯỜI CÙNG NHÀ XE NAM HẢI",
    time: "08:55 15/04/2025",
    imageUrl: "assets/image/news_03.png",
  ),

  NewsItem(
    title: "NHÀ XE NAM HẢI THÔNG BÁO THAY ĐỔI ĐẦU SỐ TỔNG ĐÀI CHI NHÁNH CÀ MAU",
    time: "08:45 15/04/2025",
    imageUrl: "assets/image/news_04.png",
  ),

  NewsItem(
    title: "THÔNG BÁO ĐIỀU CHỈNH LỘ TRÌNH KẾT NỐI TUYẾN XE BUÝT ĐIỆN TẠI GA BẾN THÀNH - TPHCM TỪ 16/04/2025",
    time: "08:40 15/04/2025",
    imageUrl: "assets/image/news_06.png",
  ),

  NewsItem(
    title: "NHÀ XE NAM HẢI CHÍNH THỨC KHAI TRƯƠNG VĂN PHÒNG MỚI MANG TÊN MỎ CÀY NAM - BẾN TRE TỪ 15/04/2025",
    time: "08:20 15/04/2025",
    imageUrl: "assets/image/news_07.png",
  ),

  NewsItem(
    title: "THÔNG BÁO THAY ĐỔI LỘ TRÌNH HOẠT ĐỘNG TUYẾN XE BUÝT SỐ 165 ĐẠI HỌC NÔNG LÂM - KHU CÔNG NGHỆ CAO",
    time: "08:10 15/04/2025",
    imageUrl: "assets/image/news_08.jpg",
  ),

  NewsItem(
    title: "TƯNG BỪNG KHAI TRƯƠNG TUYẾN XE BUÝT LIÊN TỈNH LIỀN KỀ HUẾ - QUẢNG TRỊ VÀ CHẠY CHÍNH THỨC TỪ NGÀY 15/04/2025",
    time: "08:00 15/04/2025",
    imageUrl: "assets/image/news_05.png",
  ),

  NewsItem(
    title: "THỨ TƯ VUI VẺ - THANH TOÁN VÉ XE CỦA NHÀ XE NAM HẢI BẰNG MOMO - GIẢM ĐẾN 50.000Đ CÙNG BẠN VUI VẺ",
    time: "08:50 15/04/2025",
    imageUrl: "assets/image/news_09.png",
  ),

  NewsItem(
    title: "KHUYẾN MÃI LÊN ĐẾN 50.000Đ KHI MUA VÉ NAM HẢI - FUTA BUS LINES & THANH TOÁN BẰNG VNPAY-QR",
    time: "08:40 15/04/2025",
    imageUrl: "assets/image/news_10.jpg",
  ),

  NewsItem(
    title: "COMBO 39K SIÊU TIẾT KIỆM, BỔ SUNG NĂNG LƯỢNG CHO CHUYẾN ĐI DÀI CÙNG BẠN VUI VẺ VỚI NHÀ XE",
    time: "08:30 15/04/2025",
    imageUrl: "assets/image/news_11.png",
  ),

  NewsItem(
    title: "NHẬP MÃ NAMHAI100 - GIẢM 15% TỐI ĐA 100K CHO KHÁCH HÀNG MỚI",
    time: "08:20 15/04/2025",
    imageUrl: "assets/image/news_12.jpg",
  ),

  NewsItem(
    title: "NHÀ XE NAM HẢI VINH DỰ NHẬN HAI GIẢI THƯỞNG DANH GIÁ TẠI CHƯƠNG TRÌNH THƯƠNG HIỆU MẠNH QUỐC GIA 2025",
    time: "08:20 15/04/2025",
    imageUrl: "assets/image/news_13.png",
  ),

  NewsItem(
    title: "NHÀ XE NAM HẢI VINH DỰ NHẬN GIẢI THƯỞNG NHÀ XE AN TOÀN, VĂN MINH NHẤT NĂM 2024 CỦA BỘ GIAO THÔNG VẬN TẢI",
    time: "08:10 15/04/2025",
    imageUrl: "assets/image/news_14.jpg",
  ),

  NewsItem(
    title: "NAM HẢI VINH DỰ NHẬN GIẢI THƯỞNG “THƯƠNG HIỆU QUỐC GIA HỘI NHẬP CHÂU Á - THÁI BÌNH DƯƠNG”",
    time: "08:09 15/04/2025",
    imageUrl: "assets/image/news_15.jpg",
  ),

  NewsItem(
    title: "NHÀ XE NAM HẢI  VINH DỰ LỌT TOP 10 THƯƠNG HIỆU MẠNH QUỐC GIA",
    time: "08:08 15/04/2025",
    imageUrl: "assets/image/news_16.jpg",
  ),

  NewsItem(
    title: "TRẠM DỪNG PHÚC LỘC - TRẠM DỪNG 5 SAO BỞI KHÔNG GIAN HIỆN ĐẠI, ẤM CÚNG; CON NGƯỜI THÂN THIỆN",
    time: "08:30 15/04/2025",
    imageUrl: "assets/image/news_17.png",
  ),

  NewsItem(
    title: "ƯU ĐÃI ĐẶC BIỆT 'ĐẶT MÓN NGON 39K - CHỈ CÓ FUTA' - TRẢI NGHIỆM BỮA ĂN TRỌN VỊ, TIẾT KIỆM, AN TOÀN",
    time: "08:30 15/04/2025",
    imageUrl: "assets/image/news_19.png",
  ),

  NewsItem(
    title: "TRẠM DỪNG CHÂN TRÊN CAO TỐC - MÔ HÌNH CẦN NHÂN RỘNG - GIÚP KHÁCH HÀNG THOẢI MÁI HƠN",
    time: "08:30 15/04/2025",
    imageUrl: "assets/image/news_17.png",
  ),

  NewsItem(
    title: "ĐA DẠNG MÓN NGON - ĐỦ ĐẦY DINH DƯỠNG - COMBO CHỈ 39K GIÚP BẠN VUI KHỎE",
    time: "08:30 15/04/2025",
    imageUrl: "assets/image/news_18.png",
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
          //Tin tức nổi bật
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
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NewsDetail01(),
                        ),
                      );
                    },
                    child: Container(
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

              const SizedBox(height: 16),
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
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

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
                              image: AssetImage(_newsList[3].imageUrl),
                              fit: BoxFit.cover
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
                            fontFamily: 'Inter'
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
                        )
                      ],
                    )
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
                              image: AssetImage(_newsList[4].imageUrl),
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
                          _newsList[4].title,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Inter',
                          ),
                          textAlign: TextAlign.justify,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _newsList[4].time,
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'Inter',
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 64),

              //NAMHAI Bus Lines
              Row(
                children: [
                  Text(
                    'NAMHAI Bus Lines',
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
                              image: AssetImage(_newsList[5].imageUrl),
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
                          _newsList[5].title,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Inter',
                          ),
                          textAlign: TextAlign.justify,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _newsList[5].time,
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
                              image: AssetImage(_newsList[6].imageUrl),
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
                          _newsList[6].title,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Inter',
                          ),
                          textAlign: TextAlign.justify,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _newsList[6].time,
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
                              image: AssetImage(_newsList[7].imageUrl),
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
                          _newsList[7].title,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Inter',
                          ),
                          textAlign: TextAlign.justify,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _newsList[7].time,
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
              
              Align(
                alignment: Alignment.center,
                child: TextButton(
                  onPressed: () {

                  }, 
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(Colors.transparent), // Vô hiệu hiệu ứng chạm/rê chuột
                    splashFactory: NoSplash.splashFactory, // Không splash khi tap
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Xem tiếp  ',
                        style: TextStyle(
                          color: Color(0xFF006400),
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Inter',
                          fontSize: 14,
                        ),
                      ),
                      Icon(Icons.arrow_forward, size: 16, color: Color(0xFF006400)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 64),

              //NAMHAI City Bus
              Row(
                children: [
                  Text(
                    'NAMHAI City Bus',
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
                              image: AssetImage(_newsList[7].imageUrl),
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
                          _newsList[7].title,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Inter',
                          ),
                          textAlign: TextAlign.justify,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _newsList[7].time,
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
              
              Align(
                alignment: Alignment.center,
                child: TextButton(
                  onPressed: () {

                  }, 
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(Colors.transparent), // Vô hiệu hiệu ứng chạm/rê chuột
                    splashFactory: NoSplash.splashFactory, // Không splash khi tap
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Xem tiếp  ',
                        style: TextStyle(
                          color: Color(0xFF006400),
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Inter',
                          fontSize: 14,
                        ),
                      ),
                      Icon(Icons.arrow_forward, size: 16, color: Color(0xFF006400)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 64),

              //Khuyến mãi
              Row(
                children: [
                  Text(
                    'KHUYẾN MÃI',
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
                              image: AssetImage(_newsList[8].imageUrl),
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
                          _newsList[8].title,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Inter',
                          ),
                          textAlign: TextAlign.justify,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _newsList[8].time,
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
                              image: AssetImage(_newsList[9].imageUrl),
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
                          _newsList[9].title,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Inter',
                          ),
                          textAlign: TextAlign.justify,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _newsList[9].time,
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
                              image: AssetImage(_newsList[10].imageUrl),
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
                          _newsList[10].title,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Inter',
                          ),
                          textAlign: TextAlign.justify,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _newsList[10].time,
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
                              image: AssetImage(_newsList[11].imageUrl),
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
                          _newsList[11].title,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Inter',
                          ),
                          textAlign: TextAlign.justify,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _newsList[11].time,
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
              
              Align(
                alignment: Alignment.center,
                child: TextButton(
                  onPressed: () {

                  }, 
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(Colors.transparent), // Vô hiệu hiệu ứng chạm/rê chuột
                    splashFactory: NoSplash.splashFactory, // Không splash khi tap
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Xem tiếp  ',
                        style: TextStyle(
                          color: Color(0xFF006400),
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Inter',
                          fontSize: 14,
                        ),
                      ),
                      Icon(Icons.arrow_forward, size: 16, color: Color(0xFF006400)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 64),

              //Giải thưởng
              Row(
                children: [
                  Text(
                    'GIẢI THƯỞNG',
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
                              image: AssetImage(_newsList[12].imageUrl),
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
                          _newsList[12].title,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Inter',
                          ),
                          textAlign: TextAlign.justify,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _newsList[12].time,
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
                              image: AssetImage(_newsList[13].imageUrl),
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
                          _newsList[13].title,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Inter',
                          ),
                          textAlign: TextAlign.justify,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _newsList[13].time,
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
                              image: AssetImage(_newsList[14].imageUrl),
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
                          _newsList[14].title,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Inter',
                          ),
                          textAlign: TextAlign.justify,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _newsList[14].time,
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
                              image: AssetImage(_newsList[15].imageUrl),
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
                          _newsList[15].title,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Inter',
                          ),
                          textAlign: TextAlign.justify,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _newsList[15].time,
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
              
              Align(
                alignment: Alignment.center,
                child: TextButton(
                  onPressed: () {

                  }, 
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(Colors.transparent), // Vô hiệu hiệu ứng chạm/rê chuột
                    splashFactory: NoSplash.splashFactory, // Không splash khi tap
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Xem tiếp  ',
                        style: TextStyle(
                          color: Color(0xFF006400),
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Inter',
                          fontSize: 14,
                        ),
                      ),
                      Icon(Icons.arrow_forward, size: 16, color: Color(0xFF006400)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 64),

              //Trạm dừng
              Row(
                children: [
                  Text(
                    'TRẠM DỪNG',
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
                              image: AssetImage(_newsList[16].imageUrl),
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
                          _newsList[16].title,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Inter',
                          ),
                          textAlign: TextAlign.justify,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _newsList[16].time,
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
                              image: AssetImage(_newsList[17].imageUrl),
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
                          _newsList[17].title,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Inter',
                          ),
                          textAlign: TextAlign.justify,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _newsList[17].time,
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
                              image: AssetImage(_newsList[18].imageUrl),
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
                          _newsList[18].title,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Inter',
                          ),
                          textAlign: TextAlign.justify,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _newsList[18].time,
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
                              image: AssetImage(_newsList[19].imageUrl),
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
                          _newsList[19].title,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Inter',
                          ),
                          textAlign: TextAlign.justify,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _newsList[19].time,
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
              
              Align(
                alignment: Alignment.center,
                child: TextButton(
                  onPressed: () {

                  }, 
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(Colors.transparent), // Vô hiệu hiệu ứng chạm/rê chuột
                    splashFactory: NoSplash.splashFactory, // Không splash khi tap
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Xem tiếp  ',
                        style: TextStyle(
                          color: Color(0xFF006400),
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Inter',
                          fontSize: 14,
                        ),
                      ),
                      Icon(Icons.arrow_forward, size: 16, color: Color(0xFF006400)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
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
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 4),
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
          const SizedBox(height: 4),
          Text(title, style: const TextStyle(fontFamily: 'Inter')),
        ],
      ),
    );
  }
}