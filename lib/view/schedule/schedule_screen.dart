import 'package:flutter/material.dart';
import 'package:giao_dien_1/config/default.dart';
import 'package:giao_dien_1/config/config.dart';
import 'package:giao_dien_1/widget/appbar.dart';
import 'package:giao_dien_1/widget/footer.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:giao_dien_1/model/trip.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:giao_dien_1/view/ticket_booking/ticket_booking.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';


class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  List<Map<String, dynamic>> allTrips = [];
  List<Map<String, dynamic>> filteredTrips = [];

  final TextEditingController startController = TextEditingController();
  final TextEditingController endController = TextEditingController();
  bool hasSearched = false;

  @override
  void initState() {
    super.initState();
    fetchTrips();
  }

  Future<void> fetchTrips() async {
    try {
      final response = await http.get(Uri.parse('$baseURL/chuyenxe'));

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        final List<Map<String, dynamic>> parsedList =
            List<Map<String, dynamic>>.from(jsonList.map((e) => Map<String, dynamic>.from(e)));

        setState(() {
          allTrips = parsedList;
        });
      } else {
        print('❌ Lỗi khi lấy dữ liệu: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Lỗi kết nối: $e');
    }
  }

  void _searchRoutes() {
    String start = startController.text.toLowerCase().trim();
    String end = endController.text.toLowerCase().trim();

    setState(() {
      hasSearched = true;

      if (start.isEmpty && end.isEmpty) {
        filteredTrips = [];
        return;
      }
      if (start.isEmpty) {
      filteredTrips = allTrips.where((trip) {
        return trip['DiemDen'].toString().toLowerCase().contains(end);
      }).toList();
      }
      if (end.isEmpty) {
      filteredTrips = allTrips.where((trip) {
        return trip['DiemDi'].toString().toLowerCase().contains(start);
      }).toList();
      }
      filteredTrips = allTrips.where((trip) {
        return trip['DiemDi'].toString().toLowerCase().contains(start) &&
               trip['DiemDen'].toString().toLowerCase().contains(end);
      }).toList();
      
    });
  }

String formatDate(String dateTimeString) {
  try {
    final dt = DateTime.parse(dateTimeString);
    return DateFormat('dd/MM/yyyy').format(dt);
  } catch (e) {
    return dateTimeString; // fallback nếu lỗi
  }
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
              style: TextStyle(fontSize: 14, color: AppColors.black, fontFamily: 'Inter'),
            ),
            const SizedBox(height: 20),
            _buildSearchBox(),
            const SizedBox(height: 30),
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
              const SizedBox(width: 16),
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
                          color: AppColors.mainOrange.withOpacity(0.15),
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
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
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
      border: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.grey400)),
      enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.grey400)),
      focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.mainOrange, width: 2)),
      hoverColor: AppColors.white,
    );
  }

  Widget _buildPlaceholder() {
    return Column(
      children: [
        Image.asset('assets/image/bus_trip_illustration.png', height: 150),
        const SizedBox(height: 10),
        const Text('XE TRUNG CHUYỂN', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 20, fontFamily: 'Inter')),
        const Text('ĐÓN TRẢ TẬN NƠI', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 20, fontFamily: 'Inter')),
      ],
    );
  }

  Widget _buildNoResultMessage() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Text(
        'Không tìm thấy lịch trình phù hợp.',
        style: TextStyle(fontSize: 16, color: Colors.black87, fontFamily: 'Inter'),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildResultList() {
    return Column(
      children: [
        Text(
          'Có ${filteredTrips.length} kết quả được tìm thấy',
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: AppColors.black87),
        ),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: filteredTrips.length,
          itemBuilder: (context, index) {
            final trip = filteredTrips[index];
            return _buildTripCard(trip);
          },
        ),
      ],
    );
  }

  Widget _buildTripCard(Map<String, dynamic> trip) {
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
            Image.asset('assets/image/bus_trip_illustration.png', width: 110, fit: BoxFit.cover),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tuyến xe: ${trip['DiemDi']} - ${trip['DiemDen']}',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        color: AppColors.mainOrange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _tripInfoRow('Loại xe:', trip['LoaiHinhChuyenDi']),
                    const SizedBox(height: 8),
                    _tripInfoRow('Thời gian hành trình:', '${formatDate(trip['ThoiGianDi'])} - ${formatDate(trip['ThoiGianVe'])}',),
                    const Spacer(),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () async {
                          final prefs = await SharedPreferences.getInstance();

                          await prefs.setString('diemDi', trip['DiemDi']);
                          await prefs.setString('diemDen', trip['DiemDen']);
                          await prefs.setInt('seatPrice', double.parse(trip['GiaVe'].toString()).toInt());
                          DateTime thoiGianDi = DateTime.parse(trip['ThoiGianDi']);
                          String formattedStartTime = '${thoiGianDi.hour.toString().padLeft(2, '0')}:${thoiGianDi.minute.toString().padLeft(2, '0')}';

                          await prefs.setString('startTime', formattedStartTime);

                          final now = DateTime.now();
                          final formattedToday = '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}';
                          await prefs.setString('ngayDi', formattedToday);
                          await prefs.setString('maCX', trip['MaCX']);
                          await prefs.setString('loaiVe', trip['LoaiHinhChuyenDi']);

                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => TicketBookingPage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.softOrange,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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

  Widget _tripInfoRow(String label, dynamic value,
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
            text: value.toString(),
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