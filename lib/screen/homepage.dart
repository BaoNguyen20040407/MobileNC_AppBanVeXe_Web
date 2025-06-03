import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final Color green = Color(0xFF008000);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.directions_bus),
            SizedBox(width: 8),
            Text('NHÀ XE NAM HẢI', style: TextStyle(color: green)),
          ],
        ),
        actions: [Icon(Icons.account_circle), SizedBox(width: 16)],
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      body: SingleChildScrollView(
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
              onPressed: () {},
              child: Text('Về chúng tôi'),
              style: ElevatedButton.styleFrom(backgroundColor: Color(0xffFF5722)),
            ),
            SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Color(0xffFF5722),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Trang chủ'),
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule),
            label: 'Lịch trình',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Tra cứu vé',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.article), label: 'Tin tức'),
        ],
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
        border: Border.all(color: Color(0xffFF5722), width: 5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.place),
                  hintText: 'Nhập điểm đi',
                ),
              ),
              TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.place),
                  hintText: 'Nhập điểm đến',
                ),
              ),
              TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.calendar_today),
                  hintText: 'dd/mm/yyyy',
                ),
              ),
              TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.airline_seat_recline_normal),
                  hintText: 'Số vé',
                ),
              ),
              Center(
  child: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Row(
        children: [
          Radio<bool>(
            value: true,
            groupValue: _isOneWay,
            onChanged: (bool? value) {
              setState(() {
                _isOneWay = value!;
              });
            },
          ),
          Text('Một chiều'),
        ],
      ),
      SizedBox(width: 20),
      Row(
        children: [
          Radio<bool>(
            value: false,
            groupValue: _isOneWay,
            onChanged: (bool? value) {
              setState(() {
                _isOneWay = value!;
              });
            },
          ),
          Text('Khứ hồi'),
        ],
      ),
    ],
  ),
),

              ElevatedButton(
                onPressed: () {
                  // handle form submission if needed
                },
                child: Text('Tìm chuyến xe'),
                style: ElevatedButton.styleFrom(backgroundColor: Color(0xffFF5722)),
              ),
            ],
          ),
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
