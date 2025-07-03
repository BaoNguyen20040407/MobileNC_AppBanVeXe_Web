import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:giao_dien_1/config/default.dart';
import 'package:giao_dien_1/widget/appbar.dart';
import 'package:giao_dien_1/widget/footer.dart';
import 'package:giao_dien_1/view/main/homepage.dart';

class TicketDetails extends StatefulWidget {
  const TicketDetails({super.key});

  @override
  State<TicketDetails> createState() => _TicketDetailsState();
}

class _TicketDetailsState extends State<TicketDetails> {
  String _name = '';
  String _phone = '';
  String _email = '';
  String _pickupPoint = '';
  String _dropoffPoint = '';
  String _ngayDi = '';
  String _startTime = '';
  int _totalPrice = 0;
  List<String> _selectedSeats = [];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = prefs.getString('full_name') ?? '';
      _phone = prefs.getString('phone') ?? '';
      _email = prefs.getString('email') ?? '';
      _pickupPoint = prefs.getString('pickupPoint') ?? '';
      _dropoffPoint = prefs.getString('dropoffPoint') ?? '';
      _ngayDi = prefs.getString('ngayDi') ?? '';
      _startTime = prefs.getString('startTime') ?? '';
      _totalPrice = prefs.getInt('totalPrice') ?? 0;
      _selectedSeats = prefs.getStringList('selectedSeats') ?? [];
    });
  }

  String formatCurrency(int amount) {
    final formatter = NumberFormat("#,###", "vi_VN");
    return '${formatter.format(amount)} VND';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            margin: const EdgeInsets.fromLTRB(24, 32, 24, 32),
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: AppColors.mainOrange, width: 5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'THÔNG TIN VÉ XE',
                  style: TextStyle(
                    fontSize: 20, 
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Nhà Xe Nam Hải đã gửi thông tin vé xe qua\ngmail của người dùng',
                  textAlign: TextAlign.center, 
                  style: TextStyle(
                    fontFamily: 'Inter', 
                    fontSize: 14,),
                ),
                const SizedBox(height: 8),
                Text(
                  'Vé ${_selectedSeats.isNotEmpty ? _selectedSeats.first : ''}',
                  style: const TextStyle(
                    color: AppColors.greenDark, 
                    fontWeight: FontWeight.bold, 
                    fontFamily: 'Inter'
                  ),
                ),
                const SizedBox(height: 8),
                Image.asset(
                  'assets/image/qrcode.png',
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Quý khách vui lòng trình mã QR trên hoặc\nchụp màn hình này để trình trạm soát vé',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14, 
                    fontFamily: 'Inter'
                  ),
                ),
                const SizedBox(height: 16),

                // Thông tin cá nhân
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'THÔNG TIN CÁ NHÂN',
                    style: TextStyle(
                      color: AppColors.greenDark,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Inter',
                      fontSize: 17,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                infoRow('Họ tên:', _name),
                infoRow('Số điện thoại:', _phone),
                infoRow('Email:', _email),
                const SizedBox(height: 16),

                // Thông tin chuyến xe
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'THÔNG TIN CHUYẾN XE',
                    style: TextStyle(
                      color: AppColors.greenDark,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Inter',
                      fontSize: 17,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                infoRow('Tuyến xe:', '$_pickupPoint - $_dropoffPoint'),
                infoRow('Thời gian:', '$_startTime $_ngayDi'),
                infoRow('Số ghế:', _selectedSeats.join(', ')),
                infoRow('Điểm lên xe:', 'BX Nam Hải - TP. HCM'),
                infoRow('Giá vé:', formatCurrency(_totalPrice)),
                const SizedBox(height: 16),

                // Thông tin chuyển khoản
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'THÔNG TIN CHUYỂN KHOẢN',
                    style: TextStyle(
                      color: AppColors.greenDark,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Inter',
                      fontSize: 17,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                infoRow('Giá vé:', formatCurrency(_totalPrice)),
                infoRow('PTTT:', 'Momo'),
                const SizedBox(height: 4),
                Row(
                  children: const [
                    SizedBox(
                      width: 120,
                      child: Text(
                        'Trạng thái:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Thanh toán thành công',
                          style: TextStyle(
                            color: AppColors.greenDark,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => HomePage(),
                        settings: const RouteSettings(name: '/home'),
                      ),
                    );

                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.mainOrange,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: const Text(
                    'Về trang chủ',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const FooterNavigation(),
    );
  }

  // Widget helper để hiển thị một dòng thông tin
  static Widget infoRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      children: [
        Expanded(
          flex: 1,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'Inter',
              ),
            ),
          ),
        ),
        const SizedBox(width: 16), // khoảng cách giữa tiêu đề và nội dung
        Expanded(
          flex: 2,
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontFamily: 'Inter',
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
}