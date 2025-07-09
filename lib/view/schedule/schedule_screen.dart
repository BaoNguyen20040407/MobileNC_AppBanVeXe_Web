import 'package:flutter/material.dart';
import 'package:giao_dien_1/config/default.dart';
import 'package:giao_dien_1/widget/appbar.dart';
import 'package:giao_dien_1/widget/footer.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:giao_dien_1/model/trip.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:giao_dien_1/view/ticket_booking/ticket_booking.dart';

// ... các import giữ nguyên

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

      if (start.isEmpty && end.isEmpty) {
        filteredTrips = [];
        return;
      }

      filteredTrips = allTrips.where((trip) {
        return trip.diemDi.toLowerCase().contains(start) ||
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

            _buildSearchBox(),
            const SizedBox(height: 30),

            // ✅ Điều kiện hiển thị nội dung
            if (!hasSearched)
              _buildPlaceholder()
            else if (filteredTrips.isEmpty)
              _buildNoResultMessage()
            else
              _buildResultList(),
            const SizedBox(height: 32),
          ],
        ),
      ),
      bottomNavigationBar: FooterNavigation(),
    );
  }

  Widget _buildSearchBox() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Cột chứa 2 ô nhập liệu
              Expanded(
                child: Column(
                  children: [
                    TextField(
                      controller: startController,
                      decoration: _inputDecoration('Nhập điểm đi'),
                      cursorColor: AppColors.mainOrange,
                      style: const TextStyle(fontSize: 16, color: AppColors.black87),
                    ),
                    TextField(
                      controller: endController,
                      decoration: _inputDecoration('Nhập điểm đến'),
                      cursorColor: AppColors.mainOrange,
                      style: const TextStyle(fontSize: 16, color: AppColors.black87),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 16), // Khoảng cách giữa TextField và nút

              // Nút đổi vị trí
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: 35, 
                  height: 55,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.mainOrange,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.mainOrange.withOpacity(0.15), // 👈 bóng nhẹ
                          blurRadius: 3,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.swap_vert, color: Colors.white, size: 20),
                      onPressed: () {
                        final temp = startController.text;
                        startController.text = endController.text;
                        endController.text = temp;
                      },
                      tooltip: 'Đổi điểm đi / điểm đến',
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(), 
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Center(
            child: ElevatedButton(
              onPressed: _searchRoutes,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.mainOrange,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
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
    );
  }

  InputDecoration _inputDecoration(String hintText) {
    return InputDecoration(
      prefixIcon: Icon(Icons.location_on, color: AppColors.mainOrange),
      hintText: hintText,
      filled: true,
      fillColor: Colors.white,
      hintStyle: const TextStyle(
        color: AppColors.grey600,
        fontWeight: FontWeight.w500,
        fontFamily: 'Inter',
        fontSize: 14,
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      border: const UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.grey400),
      ),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.grey400),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.mainOrange, width: 2),
      ),
      hoverColor: AppColors.white,
    );
  }

  // ✅ Khi chưa tìm: hiển thị hình & dòng đỏ
  Widget _buildPlaceholder() {
    return Column(
      children: [
        Image.asset(
          'assets/image/bus_trip_illustration.png',
          height: 150,
        ),
        const SizedBox(height: 10),
        const Text(
          'XE TRUNG CHUYỂN',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.red,
              fontSize: 20,
              fontFamily: 'Inter'),
        ),
        const Text(
          'ĐÓN TRẢ TẬN NƠI',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.red,
              fontSize: 20,
              fontFamily: 'Inter'),
        ),
      ],
    );
  }

  // ✅ Khi không có kết quả: chỉ hiện dòng chữ
  Widget _buildNoResultMessage() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Text(
        'Không tìm thấy lịch trình phù hợp.',
        style: TextStyle(
          fontSize: 16,
          color: Colors.black87,
          fontFamily: 'Inter',
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildResultList() {
    return Column(
      children: [
        Text(
          'Có ${filteredTrips.length} kết quả được tìm thấy',
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: AppColors.black87,
          ),
        ),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: filteredTrips.length,
          itemBuilder: (context, index) {
            final route = filteredTrips[index];
            return _buildTripCard(route);
          },
        ),
      ],
    );
  }

  Widget _buildTripCard(Trip route) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
              child: Image.asset(
                route.image,
                width: 110,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ✅ Toàn bộ dòng "Tuyến xe" màu cam, chữ đậm
                    Text(
                      'Tuyến xe: ${route.diemDi} - ${route.diemDen}',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        color: AppColors.mainOrange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _tripInfoRow('Loại xe:', route.loaiGhe),
                    const SizedBox(height: 8),
                    _tripInfoRow('Thời gian hành trình:', '${route.gioBatDau} - ${route.gioKetThuc}'),
                    const Spacer(),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () async {
                          final prefs = await SharedPreferences.getInstance();

                          await prefs.setString('diemDi', route.diemDi);
                          await prefs.setString('diemDen', route.diemDen);
                          await prefs.setInt('seatPrice', route.giaVe);


                          // Mặc định ngày đi là hôm nay:
                          final now = DateTime.now();
                          final formattedToday = '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}';
                          await prefs.setString('ngayDi', formattedToday);

                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => TicketBookingPage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.softOrange,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Tìm tuyến xe',
                          style: TextStyle(
                            color: AppColors.mainOrange,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tripInfoRow(String label, String value,
      {bool boldValue = false, Color? color}) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(fontFamily: 'Inter', fontSize: 14, color: Colors.black),
        children: [
          TextSpan(
            text: '$label ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: value,
            style: TextStyle(
              fontWeight: boldValue ? FontWeight.bold : FontWeight.normal,
              color: color ?? Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}