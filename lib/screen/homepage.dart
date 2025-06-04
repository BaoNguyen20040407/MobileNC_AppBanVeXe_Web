import 'package:flutter/material.dart';
import 'about_us.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Color green = Color(0xFF006400);
  int _selectedIndex = 0;

  Widget _bottomNavItem(String title, IconData icon, int index, VoidCallback onTap) {
    final isSelected = _selectedIndex == index;

    return TextButton(
      onPressed: () {
        setState(() {
          _selectedIndex = index;
        });
        onTap(); // gọi hành động điều hướng
      },
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.all(Colors.transparent),
        foregroundColor: MaterialStateProperty.all(Colors.black),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 32, color: isSelected ? Color(0xFFFF5722) : Color(0xFFD9D9D9)),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontFamily: 'Inter')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Container(
          padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
          color: const Color(0xffFDE5DE),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset("assets/image/namhailogo.png", height: 32, width: 60),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text("NHÀ XE NAM HẢI",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff006400),
                          fontFamily: 'Inter'),
                    ),
                    SizedBox(height: 2),
                    Text("Vì những chuyến xe an toàn cho bạn",
                      style: TextStyle(
                          fontSize: 14,
                          color: Color(0xffFF0000),
                          fontFamily: 'Inter'),
                    ),
                  ],
                ),
              ),
              Image.asset("assets/image/personicon.png", height: 32, width: 32),
            ],
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
          child: Column(
            children: [
              RouteSearchCard(),
              SizedBox(height: 16),
              PromotionSection(),
              SizedBox(height: 16),
              PopularRoutesSection(),
              SizedBox(height: 16),
              TrustInfoSection(),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AboutUs()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFF5722),
                    padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 5,
                    shadowColor: Color(0xFFFF5722).withOpacity(0.6),
                  ),
                  child: const Text(
                    "Về chúng tôi",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
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
            }),
            _bottomNavItem("Lịch trình", Icons.event_note, 1, () {
              //Navigator.push(context, MaterialPageRoute(builder: (context) => LichTrinhPage()));
            }),
            _bottomNavItem("Tra cứu vé", Icons.confirmation_number, 2, () {
              //Navigator.push(context, MaterialPageRoute(builder: (context) => TraCuuVePage()));
            }),
            _bottomNavItem("Tin tức", Icons.article, 3, () {
              //Navigator.push(context, MaterialPageRoute(builder: (context) => TinTucPage()));
            }),
          ],
        ),
      ),
    );
  }
}


class RouteSearchCard extends StatefulWidget {
  @override
  _RouteSearchCardState createState() => _RouteSearchCardState();
}

class _RouteSearchCardState extends State<RouteSearchCard> {
  bool _isOneWay = true; // default selected

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xffFF5722), width: 8),
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.place,
                  color: Color(0xFFFF5722),
                ),
                hintText: 'Nhập điểm đi',
                hintStyle: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Inter',
                  fontSize: 14,
                ),
                filled: true,
                fillColor: Colors.white,
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFFF5722), width: 2),
                ),
                hoverColor: Colors.transparent, 
                focusColor: Colors.transparent,
                contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              ),
              mouseCursor: SystemMouseCursors.text,
              cursorColor: Color(0xFFFF5722),
              style: TextStyle(
                color: Colors.black87,
                fontSize: 16,
              ),
            ),

            TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.place,
                  color: Color(0xFFFF5722),
                ),
                hintText: 'Nhập điểm đến',
                hintStyle: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Inter',
                  fontSize: 14,
                ),
                filled: true,
                fillColor: Colors.white,
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFFF5722), width: 2),
                ),
                hoverColor: Colors.transparent, 
                focusColor: Colors.transparent, 
                contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              ),
              mouseCursor: SystemMouseCursors.text, 
              cursorColor: Color(0xFFFF5722),
              style: TextStyle(
                color: Colors.black87,
                fontSize: 16,
              ),
            ),

            TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.calendar_today,
                  color: Color(0xFFFF5722),
                ),
                hintText: 'dd/mm/yyyy',
                hintStyle: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Inter',
                  fontSize: 14,
                ),
                filled: true,
                fillColor: Colors.white,
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFFF5722), width: 2),
                ),
                hoverColor: Colors.transparent, 
                focusColor: Colors.transparent, 
                contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              ),
              mouseCursor: SystemMouseCursors.text,
              cursorColor: Color(0xFFFF5722),
              style: TextStyle(
                color: Colors.black87,
                fontSize: 16,
              ),
            ),

            TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.confirmation_num,
                  color: Color(0xFFFF5722),
                ),
                hintText: 'Số vé',
                hintStyle: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Inter',
                  fontSize: 14,
                ),
                filled: true,
                fillColor: Colors.white,
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFFF5722), width: 2),
                ),
                hoverColor: Colors.transparent,
                focusColor: Colors.transparent, 
                contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              ),
              mouseCursor: SystemMouseCursors.text, 
              cursorColor: Color(0xFFFF5722),
              style: TextStyle(
                color: Colors.black87,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      const SizedBox(width: 4),
                      Radio<bool>(
                        value: true,
                        groupValue: _isOneWay,
                        activeColor: Color(0xFFFF5722),
                        onChanged: (bool? value) {
                          setState(() {
                            _isOneWay = value!;
                          });
                        },
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Một chiều', 
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 32),
                  Row(
                    children: [
                      Radio<bool>(
                        value: false,
                        groupValue: _isOneWay,
                        activeColor: Color(0xFFFF5722),
                        onChanged: (bool? value) {
                          setState(() {
                            _isOneWay = value!;
                          });
                        },
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Khứ hồi', 
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () {
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFF5722),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  shadowColor: Color(0xFFFF5722)
                ),
                child: const Text(
                  "Tìm chuyến xe",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ),
            SizedBox(height: 8),
            ],
          ),
        ),
      );
  }
}

class PromotionSection extends StatefulWidget {
  @override
  _PromotionSectionState createState() => _PromotionSectionState();
}

class _PromotionSectionState extends State<PromotionSection> {
  int _currentPage = 0;
  late PageController _pageController;

  final List<List<String>> placeholderImages = [
  ['image/promote_01.png', 'image/promote_02.png'],
  ['image/promote_03.png', 'image/promote_04.png'],
  ['image/promote_05.png', 'image/promote_06.png'],
];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = placeholderImages.map((page) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: page.map((imagePath) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Container(
              height: 140,
              margin: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    offset: Offset(0, 4), // dịch xuống
                    blurRadius: 4, // độ mờ
                    spreadRadius: 1, // độ lan rộng
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
          );
        }).toList(),
      );
    }).toList();

    return Column(
      children: [
        SizedBox(height: 32),
        Text(
          'KHUYẾN MÃI NỔI BẬT',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF006400),
            fontFamily: 'Inter'
          ),
        ),
        SizedBox(height: 16),
        Container(
          height: 352,
          child: PageView(
            controller: _pageController,
            onPageChanged: (int index) {
              setState(() {
                _currentPage = index;
              });
            },
            children: pages,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(placeholderImages.length, (index) {
            return GestureDetector(
              onTap: () {
                _pageController.animateToPage(
                  index,
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 8),
                child: Icon(
                  _currentPage == index ? Icons.circle : Icons.circle_outlined,
                  size: 14, 
                  color: _currentPage == index ? Color(0xffFF5722) : Colors.grey,
                ),
              ),
            );
          }),
        ),

      ],
    );
  }
}

class PopularRoutesSection extends StatelessWidget {
  final List<Map<String, String>> routes = [
    {
      'from': 'Thành phố Hồ Chí Minh',
      'to': 'Đà Lạt',
      'distance': '305km',
      'duration': '8h00ph',
      'date': '04/10/2024',
      'price': '290.000 VNĐ',
    },
    {
      'from': 'Thành phố Hồ Chí Minh',
      'to': 'Cần Thơ',
      'distance': '166km',
      'duration': '3h12ph',
      'date': '04/10/2024',
      'price': '165.000 VNĐ',
    },
    {
      'from': 'Hà Nội',
      'to': 'Hải Phòng',
      'distance': '120km',
      'duration': '2h00ph',
      'date': '04/10/2024',
      'price': '90.000 VNĐ',
    },
    {
      'from': 'Hà Nội',
      'to': 'Thanh Hóa',
      'distance': '150km',
      'duration': '3h30ph',
      'date': '04/10/2024',
      'price': '165.000 VNĐ',
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Nhóm các route theo 'from'
    final groupedRoutes = <String, List<Map<String, String>>>{};
    for (var route in routes) {
      final from = route['from']!;
      groupedRoutes.putIfAbsent(from, () => []).add(route);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 32),
        Center(
          child: Text(
            'TUYẾN PHỔ BIẾN',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF006400),
              fontFamily: 'Inter',
            ),
          ),
        ),
        SizedBox(height: 4),
        Center(
          child: Text(
            'Được khách hàng tin tưởng và lựa chọn',
            style: TextStyle(fontSize: 14, fontFamily: 'Inter'),
          ),
        ),
        SizedBox(height: 16),
        // Các khối tuyến phổ biến
        ...groupedRoutes.entries.map((entry) {
          final from = entry.key;
          final destinations = entry.value;

          // Xác định ảnh tương ứng với điểm đi
          String imagePath = 'assets/default.jpg';
          if (from.contains('Hồ Chí Minh')) imagePath = 'image/hochiminh.png';
          if (from.contains('Hà Nội')) imagePath = 'image/hanoi.png';

          return Container(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,  // Căn top cho cả Row
              children: [
                // Bên trái: ảnh + text
                Container(
                  width: 125,
                  height: 135,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                    ),
                    image: DecorationImage(
                      image: AssetImage(imagePath),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(8),
                    alignment: Alignment.topLeft,  // căn trên trái cho Column
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        bottomLeft: Radius.circular(12),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,  // tránh giãn cao hơn
                      children: [
                        Text(
                          'Tuyến xe từ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontFamily: 'Inter',
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          from,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Expanded(
  child: Padding(
    padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
    child: ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(), // nếu bạn muốn tránh scroll riêng bên trong
      itemCount: destinations.length,
      separatorBuilder: (context, index) {
        return Divider(
          color: Colors.grey.shade300,
          thickness: 1,
          height: 1,
          indent: 0,
          endIndent: 0,
        );
      },
      itemBuilder: (context, index) {
        final route = destinations[index];
        return Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,  
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    route['to']!,
                    style: TextStyle(
                      color: Color(0xFF006400),
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Inter',
                      fontSize: 14, 
                    ),
                  ),
                  Text(
                    route['price']!,
                    style: TextStyle(
                      color: Color(0xffFF5722),
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Inter',
                      fontSize: 14, 
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                '${route['distance']} - ${route['duration']} - ${route['date']}',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
        );
      },
    ),
  ),
),

              ],
            ),
          );
        }).toList(),
      ],
    );
  }
}


class TrustInfoSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center( // Đưa toàn bộ Column ra giữa trang
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 32),
          Text(
            'NHÀ XE NAM HẢI',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF006400),
              fontFamily: 'Inter',
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            'NHỮNG CHUYẾN ĐI AN TOÀN',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF006400),
              fontFamily: 'Inter',
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Text(
            'Được khách hàng tin tưởng và lựa chọn',
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'Inter',
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center, // Căn giữa theo chiều dọc
              children: [
                Image.asset('image/safe_01.png', width: 50, height: 50),
                const SizedBox(width: 12),
                Flexible(
                  child: Text(
                    'Hơn 20 triệu lượt khách/ năm',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset('image/safe_02.png', width: 50, height: 50),
                const SizedBox(width: 12),
                Flexible(
                  child: Text(
                    'Hơn 350 phòng vé/ bưu cục trên toàn quốc',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset('image/safe_03.png', width: 50, height: 50),
                const SizedBox(width: 12),
                Flexible(
                  child: Text(
                    'Hơn 1500 chuyến xe được phục vụ mỗi năm',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 32),
        ],
      ),
    );
  }
}