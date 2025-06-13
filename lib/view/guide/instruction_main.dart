import 'package:flutter/material.dart';
import 'package:giao_dien_1/view/news/news.dart';

class HuongDanApp extends StatefulWidget {
  @override
  _HuongDanAppState createState() => _HuongDanAppState();
}

class _HuongDanAppState extends State<HuongDanApp> {
  PageController _pageController = PageController();
  int _currentIndex = 0;
  int _selectedIndex = 0;

  void _onDotTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget _bottomNavItem(
    String title,
    IconData icon,
    int index,
    VoidCallback onTap,
  ) {
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
            color: isSelected ? Color(0xFFFF5722) : Color(0xFFD9D9D9),
          ),
          const SizedBox(height: 4),
          Text(title, style: const TextStyle(fontFamily: 'Inter')),
        ],
      ),
    );
  }

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
              Image.asset("assets/image/namhailogo.png", height: 32, width: 60),
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
              Image.asset("assets/image/personicon.png", height: 32, width: 32),
            ],
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 390), // typical phone width
            child: Column(
              children: [
                SizedBox(height: 24),
                Text(
                  'HƯỚNG DẪN MUA VÉ XE',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrange,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Nơi bạn được hướng dẫn\nđể có thể mua vé xe một cách dễ dàng hơn',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to App tutorial
                  },
                  child: Text('Xem hướng dẫn mua vé trên App'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  ),
                ),
                SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to Web tutorial
                  },
                  child: Text('Xem hướng dẫn mua vé trên Web'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  ),
                ),
                SizedBox(height: 24),
                Container(
                  width: 200,
                  height: 200,
                  child: Image.asset('assets/image/instruction_phone.png'), // Replace with Image.asset later
                ),
                SizedBox(height: 16),
                Text(
                  'NHÀ XE NAM HẢI\nNHỮNG CHUYẾN ĐI AN TOÀN',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 24),
              ],
            ),
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
            _bottomNavItem("Trang chủ", Icons.home, 0, () {}),
            _bottomNavItem("Lịch trình", Icons.event_note, 1, () {
              //Navigator.push(context, MaterialPageRoute(builder: (context) => LichTrinhPage()));
            }),
            _bottomNavItem("Tra cứu vé", Icons.confirmation_number, 2, () {
              //Navigator.push(context, MaterialPageRoute(builder: (context) => TraCuuVePage()));
            }),
            _bottomNavItem("Tin tức", Icons.article, 3, () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => News()),
              );
            }),
          ],
        ),
      ),
    );
  }
}