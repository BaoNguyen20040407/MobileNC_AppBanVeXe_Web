import 'package:flutter/material.dart';
import 'package:giao_dien_1/config/default.dart';
import 'package:giao_dien_1/widget/appbar.dart';
import 'package:giao_dien_1/widget/footer.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:giao_dien_1/model/trip.dart';



class ScheduleScreen extends StatefulWidget {
  ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();

  
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  List<Trip> allTrips = [];

@override
void initState() {
  super.initState();
  _loadTrips();
}

Future<void> _loadTrips() async {
  final String response = await rootBundle.loadString('assets/data/trips.json');
  final List<dynamic> data = json.decode(response);
  setState(() {
    allTrips = data.map((json) => Trip.fromJson(json)).toList();
    filteredTrips = allTrips;
  });
}

  List<Trip> filteredTrips = [];
  final TextEditingController startController = TextEditingController();
  final TextEditingController endController = TextEditingController();
  bool hasSearched = false;

 void _searchRoutes() {
  String start = startController.text.toLowerCase().trim();
  String end = endController.text.toLowerCase().trim();

  setState(() {
    hasSearched = true;
    filteredTrips = allTrips.where((trip) {
      return trip.diemDi.toLowerCase().contains(start) &&
             trip.diemDen.toLowerCase().contains(end);
    }).toList();
  });
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
      else if (filteredTrips.isEmpty)
        _buildPlaceholder(message: 'Không tìm thấy chuyến xe phù hợp.')
      else
        Column(
          children: [
            Text(
              'Có ${filteredTrips.length} kết quả được tìm thấy',
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
              itemCount: filteredTrips.length,
              itemBuilder: (context, index) {
                final route = filteredTrips[index];
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
                              '${route.diemDi} - ${route.diemDen}',
                              style: TextStyle(
                                color: AppColors.mainOrange,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text('Loại xe: ${route.loaiGhe}'),
                            Text('Giá vé: ${route.giaVe}vnđ'),
                            Text('Thời gian hành trình: ${route.gioBatDau} - ${route.gioKetThuc}'),
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