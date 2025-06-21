import 'package:flutter/material.dart';
import 'package:giao_dien_1/config/default.dart';
import 'package:giao_dien_1/widget/appbar.dart';
import 'package:giao_dien_1/widget/footer.dart';

class BusRoute {
  final String route;
  final String type;
  final int distance;
  final String duration;
  final String image;

  BusRoute({
    required this.route,
    required this.type,
    required this.distance,
    required this.duration,
    required this.image,
  });
}

class ScheduleScreen extends StatefulWidget {
  ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  final List<BusRoute> allRoutes = [
    BusRoute(
      route: 'Hà Nội - TP. Hồ Chí Minh',
      type: 'Giường',
      distance: 639,
      duration: '11 giờ 30 phút',
      image: 'assets/image/bus1.jpg',
    ),
    BusRoute(
      route: 'Hà Nội - TP. Hồ Chí Minh',
      type: 'Ghế ngồi',
      distance: 639,
      duration: '12 giờ 00 phút',
      image: 'assets/image/bus2.jpg',
    ),
    BusRoute(
      route: 'Hà Nội - TP. Hồ Chí Minh',
      type: 'Giường',
      distance: 639,
      duration: '11 giờ 30 phút',
      image: 'assets/image/bus1.jpg',
    ),
    BusRoute(
      route: 'Hà Nội - TP. Hồ Chí Minh',
      type: 'Ghế ngồi',
      distance: 630,
      duration: '12 giờ 35 phút',
      image: 'assets/image/bus2.jpg',
    ),
  ];

  List<BusRoute> filteredRoutes = [];
  final TextEditingController startController = TextEditingController();
  final TextEditingController endController = TextEditingController();
  bool hasSearched = false;

  void _searchRoutes() {
    String start = startController.text.toLowerCase().trim();
    String end = endController.text.toLowerCase().trim();

    setState(() {
      hasSearched = true;
      filteredRoutes = allRoutes.where((route) {
        final routeLower = route.route.toLowerCase();
        return routeLower.contains(start) && routeLower.contains(end);
      }).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    filteredRoutes = allRoutes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
  child: Column(
    children: [
      const SizedBox(height: 32),
      const Text(
        'LỊCH TRÌNH CÁC CHUYẾN ĐI',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.mainOrange,
          fontFamily: 'Inter',
        ),
      ),
      const SizedBox(height: 8),
      const Text(
        'Cùng bạn đi trên mọi nẻo đường',
        style: TextStyle(
          fontSize: 14,
          color: AppColors.black,
          fontFamily: 'Inter',
        ),
      ),
      const SizedBox(height: 20),
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.mainOrange,
            width: 8,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: startController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.location_on, color: AppColors.mainOrange),
                hintText: 'Nhập điểm đi',
                filled: true,
                fillColor: Colors.white,
                hoverColor: Colors.transparent,
                focusColor: Colors.transparent,
                hintStyle: TextStyle(
                  color: AppColors.grey600,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Inter',
                  fontSize: 14,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.grey400),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.grey400),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.mainOrange, width: 2),
                ),
              ),
              cursorColor: AppColors.mainOrange,
              style: TextStyle(fontSize: 16, color: AppColors.black87),
            ),
            TextField(
              controller: endController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.location_on, color: AppColors.mainOrange),
                hintText: 'Nhập điểm đến',
                filled: true,
                fillColor: Colors.white,
                hoverColor: Colors.transparent,
                focusColor: Colors.transparent,
                hintStyle: TextStyle(
                  color: AppColors.grey600,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Inter',
                  fontSize: 14,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.grey400),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.grey400),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.mainOrange, width: 2),
                ),
              ),
              cursorColor: AppColors.mainOrange,
              style: TextStyle(fontSize: 16, color: AppColors.black87),
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: _searchRoutes,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.mainOrange,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 4,
                  shadowColor: AppColors.mainOrange,
                ),
                child: const Text(
                  'Tìm chuyến xe',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 30),

      // Kết quả tìm kiếm
      if (!hasSearched)
        _buildPlaceholder()
      else if (filteredRoutes.isEmpty)
        _buildPlaceholder(message: 'Không tìm thấy chuyến xe phù hợp.')
      else
        Column(
          children: [
            Text(
              'Có ${filteredRoutes.length} kết quả được tìm thấy',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: AppColors.black87,
              ),
            ),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: filteredRoutes.length,
              itemBuilder: (context, index) {
                final route = filteredRoutes[index];
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          route.image,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Tuyến xe:', style: TextStyle(color: AppColors.mainOrange)),
                            Text(
                              route.route,
                              style: TextStyle(
                                color: AppColors.mainOrange,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text('Loại xe: ${route.type}'),
                            Text('Quãng đường: ${route.distance}km'),
                            Text('Thời gian hành trình: ${route.duration}'),
                            const SizedBox(height: 6),
                            Align(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.softOrange,
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                                child: const Text(
                                  'Tìm tuyến xe',
                                  style: TextStyle(color: AppColors.mainOrange),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ],
        ),
          ],
        ),
      ),
      bottomNavigationBar: FooterNavigation(),
    );
  }

  Widget _buildPlaceholder({String? message}) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Image.asset(
          'assets/image/bus_trip_illustration.png',
          height: 150,
        ),
        const SizedBox(height: 10),
        const Text(
          'XE TRUNG CHUYỂN',
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.red, fontSize: 16),
        ),
        const Text(
          'ĐÓN TRẢ TẬN NƠI',
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.red, fontSize: 16),
        ),
        if (message != null) ...[
          const SizedBox(height: 8),
          Text(
            message,
            style: TextStyle(color: Colors.grey),
          ),
        ]
      ],
    );
  }
}