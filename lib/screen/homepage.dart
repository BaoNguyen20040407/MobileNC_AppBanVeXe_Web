import 'package:flutter/material.dart';
import 'about_us.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Color green = Color(0xFF008000);

  
  Widget _bottomNavItem(String title, IconData icon, VoidCallback onTap) {
    return TextButton(
      onPressed: onTap,
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.all(Colors.transparent),
        foregroundColor: MaterialStateProperty.all(Colors.black),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 32, color: Color(0xFFD9D9D9)),
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
                        fontFamily: 'Inter'
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      "Vì những chuyến xe an toàn cho bạn",
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xffFF0000),
                        fontFamily: 'Inter'
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
        child: Container(
          color: Colors.white,
          child: Padding(
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
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => AboutUs()));
              },
              child: Text('Về chúng tôi'),
              style: ElevatedButton.styleFrom(backgroundColor: Color(0xffFF5722)),
            ),
            SizedBox(height: 24),
            
          ],
        ),
      ), 
      )
      ),
        
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color(0xFFD9D9D9), // Màu bóng xám
              offset: Offset(0, -5), // Đẩy bóng lên trên
              blurRadius: 4, // Độ mờ của bóng
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 18),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _bottomNavItem("Trang chủ", Icons.home, () => print('Bấm Trang chủ')),
            _bottomNavItem("Lịch trình", Icons.event_note, () => print('Bấm Lịch trình')),
            _bottomNavItem("Tra cứu vé", Icons.confirmation_number, () => print('Bấm Tra cứu vé')),
            _bottomNavItem("Tin tức", Icons.article, () => print('Bấm Tin tức')),
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
                hoverColor: Colors.transparent, // Vô hiệu hóa màu hover
                focusColor: Colors.transparent, // Vô hiệu hóa màu focus (nếu cần)
                contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              ),
              mouseCursor: SystemMouseCursors.text, // Giữ con trỏ chữ nhưng không thay hover
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
                hoverColor: Colors.transparent, // Vô hiệu hóa màu hover
                focusColor: Colors.transparent, // Vô hiệu hóa màu focus (nếu cần)
                contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              ),
              mouseCursor: SystemMouseCursors.text, // Giữ con trỏ chữ nhưng không thay hover
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
                hoverColor: Colors.transparent, // Vô hiệu hóa màu hover
                focusColor: Colors.transparent, // Vô hiệu hóa màu focus (nếu cần)
                contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              ),
              mouseCursor: SystemMouseCursors.text, // Giữ con trỏ chữ nhưng không thay hover
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
                hoverColor: Colors.transparent, // Vô hiệu hóa màu hover
                focusColor: Colors.transparent, // Vô hiệu hóa màu focus (nếu cần)
                contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              ),
              mouseCursor: SystemMouseCursors.text, // Giữ con trỏ chữ nhưng không thay hover
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
    ['Image 1', 'Image 2'],
    ['Image 3', 'Image 4'],
    ['Image 5', 'Image 6'],
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
    List<Widget> pages =
        placeholderImages.map((page) {
          return Column(
            children:
                page.map((text) {
                  return Container(
                    height: 140,
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(child: Text(text)),
                  );
                }).toList(),
          );
        }).toList();

    return Column(
      children: [
        Text(
          'KHUYẾN MÃI NỔI BẬT',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        SizedBox(height: 8),
        Container(
          height: 320,
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
                margin: EdgeInsets.symmetric(horizontal: 4),
                child: Icon(
                  _currentPage == index ? Icons.circle : Icons.circle_outlined,
                  size: 10,
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
    return Column(
      children: [
        Text(
          'TUYẾN PHỔ BIẾN',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        Text('Được khách hàng tin tưởng và lựa chọn'),
        SizedBox(height: 8),
        ...routes.map(
          (route) => Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text('Tuyến xe từ ${route['from']}'),
              subtitle: Text(
                '${route['to']} - ${route['distance']} - ${route['duration']} - ${route['date']}',
              ),
              trailing: Text(
                route['price'] ?? '',
                style: TextStyle(color: Color(0xffFF5722)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class TrustInfoSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'NHÀ XE NAM HẢI',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        Text(
          'NHỮNG CHUYẾN ĐI AN TOÀN',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        Text('Được khách hàng tin tưởng và lựa chọn'),
        SizedBox(height: 12),
        ListTile(
          leading: Icon(Icons.people, color: Color(0xffFF5722)),
          title: Text('Hơn 20 triệu lượt khách/năm'),
        ),
        ListTile(
          leading: Icon(Icons.local_post_office, color: Color(0xffFF5722)),
          title: Text('Hơn 350 phòng vé/ bưu cục trên toàn quốc'),
        ),
        ListTile(
          leading: Icon(Icons.directions_bus, color: Color(0xffFF5722)),
          title: Text('Hơn 1500 chuyến xe được phục vụ trong 1 năm'),
        ),
      ],
    );
  }
}