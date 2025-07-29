import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:giao_dien_1/config/default.dart';
import 'package:giao_dien_1/view/ticket_lookup/ticket_details.dart';
import 'package:giao_dien_1/widget/appbar.dart';
import 'package:giao_dien_1/widget/footer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:giao_dien_1/config/config.dart';

class PaymentSuccess extends StatefulWidget {
  const PaymentSuccess({super.key});

  @override
  State<PaymentSuccess> createState() => _PaymentSuccessState();
}

class _PaymentSuccessState extends State<PaymentSuccess> {
  String _name = '';
  String _phone = '';
  String _email = '';
  String _diemDi = '';
  String _diemDen = '';
  String _ngayDi = '';
  String _startTime = '';
  int _totalPrice = 0;
  List<String> _selectedSeats = [];

  // ✅ Thêm biến maVe
  String _maVe = '';

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _loadAndSendEmail());
  }

  Future<void> _loadAndSendEmail() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _name = prefs.getString('full_name') ?? '';
      _phone = prefs.getString('phone') ?? '';
      _email = prefs.getString('email') ?? '';
      _diemDi = prefs.getString('diemDi') ?? '';
      _diemDen = prefs.getString('diemDen') ?? '';
      _ngayDi = prefs.getString('ngayDi') ?? '';
      _startTime = prefs.getString('startTime') ?? '';
      _totalPrice = prefs.getInt('totalPrice') ?? 0;
      _selectedSeats = prefs.getStringList('selectedSeats') ?? [];

      // ✅ Lấy maVe từ SharedPreferences
      _maVe = prefs.getString('maVe') ?? '';
    });

    await _sendEmailTicket();
  }

  Future<void> _sendEmailTicket() async {
    final url = Uri.parse('$baseURL/send-ticket');
    debugPrint('🔄 Bắt đầu gửi Gmail đến: $_email');

    try {
      final requestBody = {
        'fullName': _name,
        'email': _email,
        'phone': _phone,
        'route': '$_diemDi - $_diemDen',
        'date': _ngayDi,
        'time': _startTime,
        'seats': _selectedSeats.join(', '),
        'totalPrice': _totalPrice,
      };

      debugPrint('📦 Payload gửi đi: ${jsonEncode(requestBody)}');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        debugPrint('✅ Gửi Gmail thành công: ${response.body}');
      } else {
        debugPrint('❌ Gửi Gmail lỗi: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      debugPrint('❌ Lỗi gửi Gmail (exception): $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.mainOrange,
                    width: 6,
                  ),
                ),
                child: const Icon(
                  Icons.check,
                  color: AppColors.mainOrange,
                  size: 60,
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Đặt vé xe thành công',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Quý khách nhấn nút Xem vé xe dưới đây để\nxem thông tin chi tiết',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  if (_maVe.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Không tìm thấy mã vé!')),
                    );
                    return;
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TicketDetails(maVe: _maVe),
                      settings: const RouteSettings(name: '/ticket_details'),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Xem vé xe',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppColors.white,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const FooterNavigation(),
    );
  }
}
