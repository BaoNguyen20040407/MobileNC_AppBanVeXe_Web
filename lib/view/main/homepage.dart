import 'dart:async';
import 'dart:convert'; 
import 'dart:io';              
import 'package:flutter/services.dart'; 
import 'package:flutter/material.dart';
import 'package:giao_dien_1/model/trip.dart';
import 'package:giao_dien_1/view/news/news.dart';
import 'package:giao_dien_1/view/news/news_detail_02.dart';
import 'package:giao_dien_1/widget/trip_filter.dart';
import '../about/about_us.dart';
import 'package:giao_dien_1/config/default.dart';
import 'package:giao_dien_1/widget/appbar.dart';
import 'package:giao_dien_1/widget/footer.dart';
import 'package:giao_dien_1/view/guide/instruction_main.dart';
import 'package:giao_dien_1/widget/tripcard.dart';
import 'package:giao_dien_1/widget/trip_route_label.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //Tìm danh sách chuyến xe theo địa điểm đã nhập
  bool _showSearchResults = false; 
  List <Trip> _filteredTrips = [];
  List<Trip> _visibleTrips = [];
  Map<String, dynamic> _currentFilters = {};
  final Color green = AppColors.greenDark;
  int _selectedIndex = 0;
  DateTime? _selectedDate;              // biến lưu ngày chọn
  final TextEditingController _dobController = TextEditingController();
  final _diemDiController = TextEditingController();
  final _diemDenController = TextEditingController();
  final _soVeController = TextEditingController();

  String formatDate(DateTime date) {
  String day = date.day.toString().padLeft(2, '0');
  String month = date.month.toString().padLeft(2, '0');
  String year = date.year.toString();
  return '$day/$month/$year';
  }

  void _applyFilters(Map<String, dynamic> filters) {
  setState(() {
    _currentFilters = filters;

    _visibleTrips = _filteredTrips.where((trip) {
      // 1. Giờ đi
      final gio = int.tryParse(trip.gioBatDau.split(':').first) ?? 0;
      String range = '';
      if (gio < 6) {
        range = '00:00 - 06:00';
      } else if (gio < 12) {
        range = '06:00 - 12:00';
      } else if (gio < 18) {
        range = '12:00 - 18:00';
      } else {
        range = '18:00 - 24:00';
      }

      bool matchTime = filters['timeRanges'] == null || filters['timeRanges'].isEmpty
        || filters['timeRanges'].contains(range);

      // 2. Loại xe
      bool matchType = filters['types'] == null || filters['types'].isEmpty
        || filters['types'].contains(trip.loaiChuyen);

      // 3. Hàng ghế
      String hang = '';
      final ghe = trip.loaiGhe.toLowerCase();
      if (ghe.contains('đầu')) hang = 'Hàng đầu';
      else if (ghe.contains('giữa') || ghe.contains('trung')) hang = 'Hàng giữa';
      else if (ghe.contains('cuối') || ghe.contains('sau')) hang = 'Hàng cuối';

      bool matchSeat = filters['seats'] == null || filters['seats'].isEmpty
        || filters['seats'].contains(hang);

      // 4. Tầng
      String tang = '';
      if (ghe.contains('trên')) tang = 'Tầng trên';
      else if (ghe.contains('dưới')) tang = 'Tầng dưới';

      bool matchFloor = filters['floors'] == null || filters['floors'].isEmpty
        || filters['floors'].contains(tang);

      return matchTime && matchType && matchSeat && matchFloor;
    }).toList();
  });
}


  Future<void> _selectDate(BuildContext context) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: _selectedDate ?? DateTime(2000, 1, 1),
    firstDate: DateTime(1900),
    lastDate: DateTime(2100),
    helpText: 'Chọn ngày',
     builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: AppColors.mainOrange,
            onPrimary: AppColors.white,
            onSurface: AppColors.black,
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: AppColors.mainOrange,
            ),
          ),
        ),
        child: child!,
      );
    },
  );
  if (picked != null) {
    setState(() {
      _selectedDate = picked;
      _dobController.text = formatDate(picked);  // formatDate theo dd/mm/yyyy
    });
  }
}

 Future<List<Trip>> loadTripsFromJson() async {
    final String response = await rootBundle.loadString('assets/data/trips.json');
    final List<dynamic> data = json.decode(response);
    return data.map((e) => Trip.fromJson(e)).toList();
  } 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),

      body: SingleChildScrollView(
        child: Container(
          color: AppColors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            children: [
              // Luôn luôn hiện bộ lọc
              RouteSearchCard(
                diemDiController: _diemDiController,
                diemDenController: _diemDenController,
                soVeController: _soVeController,
                dobController: _dobController,
                selectDateCallback: _selectDate,
                onSearch: (diemDi, diemDen, ngayDi, soVe) async {
                  final trips = await loadTripsFromJson();

                  final ketQua = trips.where((trip) =>
                    trip.diemDi.trim().toLowerCase() == diemDi.trim().toLowerCase() &&
                    trip.diemDen.trim().toLowerCase() == diemDen.trim().toLowerCase() &&
                    trip.ngayDi.trim() == ngayDi.trim() &&
                    trip.soChoConLai >= soVe
                  ).toList();

                  print('==> Tổng số chuyến phù hợp: ${ketQua.length}');

                  setState(() {
                    _filteredTrips = ketQua;
                    _showSearchResults = true;
                  });

                  _applyFilters(_currentFilters);
                },
              ),
              const SizedBox(height: 16),

              // Khi ĐÃ tìm
              if (_showSearchResults) ...[
                if (_filteredTrips.isNotEmpty) ...[
                  TripFilterWidget(
                    onFilterChanged: _applyFilters,
                    ),
                  SizedBox(height: 16),

                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: TripRouteLabel(trip: _filteredTrips.first),
                  ),
                  SizedBox(height: 16),
                  Column(
                  children: _visibleTrips
                      .asMap()
                      .entries
                      .map((entry) {
                        final index = entry.key;
                        final trip = entry.value;

                        return Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                // TODO: xử lý chọn chuyến
                              },
                              child: TripCard(trip: trip),
                            ),
                            if (index != _filteredTrips.length - 1)
                              const SizedBox(height: 16), // Thêm khoảng cách nếu không phải phần tử cuối
                          ],
                        );
                      })
                      .toList(),
                ),

                ] else ...[
                  const SizedBox(height: 32),
                  const Center(
                    child: Text(
                      'Không tìm thấy chuyến xe phù hợp',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 128),
                ]
              ]

              // Khi CHƯA tìm
              else ...[
                PromotionSection(),
                const SizedBox(height: 16),
                PopularRoutesSection(),
                const SizedBox(height: 16),
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
                      backgroundColor: AppColors.mainOrange,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 5,
                      shadowColor: AppColors.mainOrange.withOpacity(0.6),
                    ),
                    child: const Text(
                      "Về chúng tôi",
                      style: TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ],
          ),
        ),
      ),

      bottomNavigationBar: FooterNavigation(),
    );
  }
}


class RouteSearchCard extends StatefulWidget {
  final TextEditingController diemDiController;
  final TextEditingController diemDenController;
  final TextEditingController soVeController;
  final TextEditingController dobController;
  final Future<void> Function(BuildContext) selectDateCallback;
  final void Function(String diemDi, String diemDen, String ngayDi, int soVe) onSearch;

  RouteSearchCard({
    Key? key,
    required this.diemDiController,
    required this.diemDenController,
    required this.soVeController,
    required this.dobController,
    required this.selectDateCallback,
    required this.onSearch,
  }) : super(key: key);

  @override
  _RouteSearchCardState createState() => _RouteSearchCardState();
}

class _RouteSearchCardState extends State<RouteSearchCard> {
  bool _isOneWay = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.mainOrange, width: 8),
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: Column(
          children: [
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HuongDanApp()),
                  );
                },
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(EdgeInsets.zero),
                  minimumSize: MaterialStateProperty.all(Size(0, 0)),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  alignment: Alignment.centerRight,
                  splashFactory: NoSplash.splashFactory,
                  overlayColor: MaterialStateProperty.all(AppColors.whitetransparent),
                  foregroundColor: MaterialStateProperty.all(AppColors.mainOrange),
                ),
                child: Text(
                  'Hướng dẫn đặt vé',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Inter',
                    color: AppColors.mainOrange,
                  ),
                ),
              ),
            ),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Cột chứa 2 TextField
                Expanded(
                  flex: 8,
                  child: Column(
                    children: [
                      TextField(
                        controller: widget.diemDiController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.place, color: AppColors.mainOrange),
                          hintText: 'Nhập điểm đi',
                          hoverColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hintStyle: TextStyle(
                            color: AppColors.grey600,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Inter',
                            fontSize: 14,
                          ),
                          filled: true,
                          fillColor: AppColors.white,
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColors.grey400, width: 1),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColors.grey400, width: 1),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColors.mainOrange, width: 2),
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                        ),
                        mouseCursor: SystemMouseCursors.text,
                        cursorColor: AppColors.mainOrange,
                        style: TextStyle(
                          color: AppColors.black87,
                          fontSize: 16,
                        ),
                      ),
                      TextField(
                        controller: widget.diemDenController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.place, color: AppColors.mainOrange),
                          hintText: 'Nhập điểm đến',
                          hoverColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hintStyle: TextStyle(
                            color: AppColors.grey600,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Inter',
                            fontSize: 14,
                          ),
                          filled: true,
                          fillColor: AppColors.white,
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColors.grey400, width: 1),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColors.grey400, width: 1),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColors.mainOrange, width: 2),
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                        ),
                        mouseCursor: SystemMouseCursors.text,
                        cursorColor: AppColors.mainOrange,
                        style: TextStyle(
                          color: AppColors.black87,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),

                // Khoảng cách giữa 2 cột
                const SizedBox(width: 16),

                // Cột chứa nút đảo
                Column(
                  children: [
                    const SizedBox(height: 24), 
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.mainOrange,
                        borderRadius: BorderRadius.circular(8), 
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.mainOrange.withOpacity(0.3),
                            blurRadius: 1,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.swap_vert, color: Colors.white),
                        onPressed: () {
                          final temp = widget.diemDiController.text;
                          widget.diemDiController.text = widget.diemDenController.text;
                          widget.diemDenController.text = temp;
                        },
                        tooltip: 'Đổi điểm đi / điểm đến',
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        padding: const EdgeInsets.all(10), 
                        constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                      ),
                    ),
                  ],
                )
              ],
            ),
            TextField(
              controller: widget.dobController,
              readOnly: true,
              onTap: () => widget.selectDateCallback(context),  // mở date picker khi nhấn
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.calendar_today,
                  color: AppColors.mainOrange,
                ),
                hintText: 'dd/mm/yyyy',
                hintStyle: TextStyle(
                  color: AppColors.grey600,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Inter',
                  fontSize: 14,
                ),
                filled: true,
                fillColor: Colors.white,
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.grey400, width: 1),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.grey400, width: 1),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.mainOrange, width: 2), // Màu cam
                ),
                hoverColor: AppColors.whitetransparent,
                focusColor: AppColors.whitetransparent,
                contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              ),
              mouseCursor: SystemMouseCursors.text,
              cursorColor: AppColors.mainOrange,
              style: TextStyle(
                color: AppColors.black87,
                fontSize: 16,
              ),
            ),

            TextField(
              controller: widget.soVeController,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.confirmation_num,
                  color: AppColors.mainOrange,
                ),
                hintText: 'Số vé',
                hintStyle: TextStyle(
                  color: AppColors.grey600,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Inter',
                  fontSize: 14,
                ),
                filled: true,
                fillColor: AppColors.white,
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.grey400, width: 1),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.grey400, width: 1),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.mainOrange, width: 2),
                ),
                hoverColor: AppColors.whitetransparent,
                focusColor: AppColors.whitetransparent, 
                contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              ),
              mouseCursor: SystemMouseCursors.text, 
              cursorColor: AppColors.mainOrange,
              style: TextStyle(
                color: AppColors.black87,
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
                        activeColor: AppColors.mainOrange,
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
                        activeColor: AppColors.mainOrange,
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
                  widget.onSearch(
                    widget.diemDiController.text.trim(),
                    widget.diemDenController.text.trim(),
                    widget.dobController.text.trim(),
                    int.tryParse(widget.soVeController.text.trim()) ?? 1,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.mainOrange,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  shadowColor: AppColors.mainOrange
                ),
                child: const Text(
                  "Tìm chuyến xe",
                  style: TextStyle(
                    color: AppColors.white,
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
  Timer? _autoPageTimer; 

  final List<List<String>> placeholderImages = [
  ['assets/image/promote_01.png', 'assets/image/promote_02.png'],
  ['assets/image/promote_03.png', 'assets/image/promote_04.png'],
  ['assets/image/promote_05.png', 'assets/image/promote_06.png'],
];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
     _autoPageTimer = Timer.periodic(Duration(seconds: 5), (Timer timer) {
      if (_pageController.hasClients) {
        int nextPage = (_currentPage + 1) % placeholderImages.length;
        _pageController.animateToPage(
          nextPage,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _autoPageTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

    @override
    Widget build(BuildContext context) {
      List<Widget> pages = placeholderImages.map((page) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: page.map((imagePath) {
            Widget imageWidget = Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Container(
                height: 140,
                margin: EdgeInsets.symmetric(horizontal: 0),
                decoration: BoxDecoration(
                  color: AppColors.grey300,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withOpacity(0.15),
                      offset: Offset(0, 4),
                      blurRadius: 4,
                      spreadRadius: 1,
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

            // Nếu là promote_05.png thì thêm GestureDetector để điều hướng
            if (imagePath == 'assets/image/promote_05.png') {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NewsDetail02()),
                  );
                },
                child: imageWidget,
              );
            }

            return imageWidget;
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
              color: AppColors.greenDark,
              fontFamily: 'Inter',
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
          const SizedBox(height: 16),
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
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  child: Icon(
                    _currentPage == index ? Icons.circle : Icons.circle_outlined,
                    size: 16,
                    color: _currentPage == index ? AppColors.mainOrange : AppColors.greyLight,
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
              color: AppColors.greenDark,
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
          if (from.contains('Hồ Chí Minh')) imagePath = 'assets/image/hochiminh.png';
          if (from.contains('Hà Nội')) imagePath = 'assets/image/hanoi.png';

          return Container(
            margin: EdgeInsets.symmetric(horizontal: 0, vertical: 16),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.greyShade300),
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,  // Căn top cho cả Row
              children: [
                // Bên trái: ảnh + text
                Container(
                  width: 100,
                  height: 135,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
                    image: DecorationImage(
                      image: AssetImage(imagePath),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(8),
                    alignment: Alignment.topLeft,
                    decoration: BoxDecoration(
                      color: AppColors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
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
                            color: AppColors.white,
                            fontSize: 14,
                            fontFamily: 'Inter',
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          from,
                          style: TextStyle(
                            color: AppColors.white,
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
                          color: AppColors.greyShade300,
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
                                      color: AppColors.greenDark,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Inter',
                                      fontSize: 14, 
                                    ),
                                  ),
                                  Text(
                                    route['price']!,
                                    style: TextStyle(
                                      color: AppColors.mainOrange,
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
                                  color: AppColors.black,
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
    return Center( 
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 32),
          Text(
            'NHÀ XE NAM HẢI',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.greenDark,
              fontFamily: 'Inter',
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            'NHỮNG CHUYẾN ĐI AN TOÀN',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.greenDark,
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
                Image.asset('assets/image/safe_01.png', width: 50, height: 50),
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
                Image.asset('assets/image/safe_02.png', width: 50, height: 50),
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
                Image.asset('assets/image/safe_03.png', width: 50, height: 50),
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