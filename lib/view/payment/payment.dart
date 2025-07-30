import 'package:flutter/material.dart';
import 'package:giao_dien_1/config/default.dart';
import 'package:giao_dien_1/config/config.dart';
import 'package:giao_dien_1/widget/appbar.dart';
import 'package:giao_dien_1/widget/footer.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:giao_dien_1/view/payment/wait_payment.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Payment extends StatefulWidget {
  const Payment({super.key});

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
int remainingSeconds = 15 * 60; // 15 phút
 final List<String> items1 = [
  'assets/image/vietqr.png',
  'assets/image/atm.png',
  'assets/image/vnpay.png',
  
 ];
 final List<String> items2 = [
  
  'assets/image/visa.png',
  'assets/image/viettel.png',
  'assets/image/spay.png',
  
 ];
 final List<String> items3 = [
  'assets/image/momo.png',
  'assets/image/zalopay.png',
 ];

  String _name = '';
  String _phone = '';
  String _email = '';
  String _pickupPoint = '';
  String _dropoffPoint = '';
  String _ngayDi = '';
  String _startTime = '';
  int _totalPrice = 0;
  String _diemDi = '';
  String _diemDen = '';
  String fullname = '';
  String phoneNumber = '';
  String email = '';
  Timer? _countdownTimer;

  String formatCurrency(int amount) {
  final formatter = NumberFormat("#,###", "vi_VN");
  return '${formatter.format(amount)} VNĐ';
  }

  Future<void> fetchCustomerInfo() async {
  final prefs = await SharedPreferences.getInstance();
  final customerId = prefs.getString('makh'); // ✅ phải lấy 'makh' chứ không phải 'username'

  if (customerId == null || customerId.isEmpty) {
    debugPrint('❌ Không tìm thấy MaKH trong SharedPreferences');
    return;
  }

  try {
    final url = '$baseURL/khachhang/$customerId';
    debugPrint('🔍 Đang gọi API: $url');

    final response = await http.get(Uri.parse(url));
    debugPrint("📥 Kết quả API: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        final khachHang = data['data'];
        debugPrint("✅ Dữ liệu khách hàng: $khachHang");

        setState(() {
          fullname = khachHang['HoVaTen'] ?? '';
          phoneNumber = khachHang['SDT'] ?? '';
          email = khachHang['Email'] ?? '';
        });

        // ✅ Lưu vào SharedPreferences để PaymentSuccess lấy ra
        await prefs.setString('full_name', fullname);
        await prefs.setString('phone', phoneNumber);
        await prefs.setString('email', email);
      } else {
        debugPrint("⚠️ API trả về success = false");
      }
    } else {
      debugPrint("❌ API lỗi: statusCode = ${response.statusCode}");
    }
  } catch (e) {
    debugPrint("❌ Lỗi khi lấy thông tin khách hàng: $e");
  }
}

Future<void> loadTripInfo() async {
  final prefs = await SharedPreferences.getInstance();
  final maCX = prefs.getString('maCX');

  if (maCX == null || maCX.isEmpty) {
    debugPrint('⚠️ Không có mã chuyến xe trong SharedPreferences');
    return;
  }

  try {
    final response = await http.get(Uri.parse('$baseURL/chuyenxe/$maCX'));
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      if (json['success'] == true) {
        final trip = json['data'];

        setState(() {
          _diemDi = trip['DiemDi'] ?? '';
          _diemDen = trip['DiemDen'] ?? '';

          final gioDiRaw = trip['ThoiGianDi'] ?? '';
          try {
            final dt = DateTime.parse(gioDiRaw); // Dạng ISO 8601
            _ngayDi = DateFormat('dd/MM/yyyy').format(dt);
            _startTime = DateFormat('HH:mm').format(dt);
          } catch (e) {
            debugPrint('❌ Lỗi phân tích thời gian: $e');
            _ngayDi = '';
            _startTime = '';
          }
        });

        debugPrint('✅ Đã load chuyến xe: $_diemDi - $_diemDen lúc $_ngayDi $_startTime');
      } else {
        debugPrint('❌ API chuyến xe trả về success = false');
      }
    } else {
      debugPrint('❌ Lỗi API chuyến xe: ${response.statusCode}');
    }
  } catch (e) {
    debugPrint('❌ Lỗi khi load chuyến xe: $e');
  }
}

Future<void> loadTotalPrice() async {
  final prefs = await SharedPreferences.getInstance();
  final total = prefs.getInt('totalPrice') ?? 0;

  setState(() {
    _totalPrice = total;
  });

  debugPrint('✅ Tổng tiền từ SharedPreferences: $_totalPrice');
}

Future<void> _handleConfirmPayment() async {
  final prefs = await SharedPreferences.getInstance();

  String maCX = prefs.getString('maCX') ?? '';
  String loaiVe = prefs.getString('loaiVe') ?? '';
  int giaVe = prefs.getInt('seatPrice') ?? 0;
  String maKH = prefs.getString('makh') ?? '';
  List<String> selectedSeats = prefs.getStringList('selectedSeats') ?? [];

  // Lấy ghế đầu tiên
  String viTriGhe = selectedSeats.isNotEmpty ? selectedSeats[0] : '';

  if (maCX.isEmpty || loaiVe.isEmpty || viTriGhe.isEmpty || maKH.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Dữ liệu không hợp lệ. Vui lòng kiểm tra lại.")),
    );
    return;
  }

  final response = await http.post(
    Uri.parse('$baseURL/ve'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'LoaiVe': loaiVe,
      'ViTriGheNgoi': viTriGhe,
      'GiaVe': giaVe,
      'TrangThai': 'Đã thanh toán',
      'HinhThucThanhToan': 'Momo',
      'MaCX': maCX,
      'MaKH': maKH,
    }),
  );

 if (response.statusCode == 200) {
  final data = jsonDecode(response.body);

  // Kiểm tra xem backend trả về mã vé thực sự chưa
  if (data['maVe'] != null && data['maVe'] is String) {
  final maVe = data['maVe'];
  await prefs.setString('maVe', maVe);
  debugPrint('✅ Lưu mã vé: $maVe');

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => WaitPayment(),
      settings: const RouteSettings(name: '/wait_payment'),
    ),
  );
} else {
  debugPrint('❌ Không lấy được MaVe từ response: ${data}');
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text("Không lấy được mã vé. Vui lòng thử lại.")),
  );
}
} else {
  print('Lỗi khi đặt vé: ${response.body}');
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text("Đặt vé thất bại. Vui lòng thử lại.")),
  );
}
}

  @override
  void initState() {
    super.initState();
    startCountdown();
    fetchCustomerInfo();
    loadTripInfo();
    loadTotalPrice();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }


  void startCountdown() {
  _countdownTimer = Timer.periodic(Duration(seconds: 2), (timer) {
    if (remainingSeconds == 0) {
      timer.cancel();
    } else {
      setState(() {
        remainingSeconds--;
      });
    }
  });
}

  String get timerDisplay {
    final minutes = (remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (remainingSeconds % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
          child: Column(
            children: [
              Text(
                '$_diemDi - $_diemDen',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.mainOrange,
                  fontSize: 20,
                  fontFamily: 'Inter',
                ),
              ),
              SizedBox(height: 4),
              Text(
                '$_ngayDi',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.mainOrange,
                  fontSize: 20,
                  fontFamily: 'Inter',
                ),
              ),
              SizedBox(height: 32),
              Text(
                'Tổng thanh toán',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Inter',
                ),
              ),
              Text(
                formatCurrency(_totalPrice),
                style: TextStyle(
                  fontSize: 24,
                  color: AppColors.mainOrange,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Inter',
                ),
              ),
              SizedBox(height: 32),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(16),
                  color: AppColors.greyLight,
                ),
                child: Column(
                  children: [
                    Text(
                      'Thời gian giữ chỗ còn lại $timerDisplay',
                      style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Inter'),
                    ),
                    SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        'assets/image/qrcode.png', // Ảnh QR giả
                        width: 280,
                        height: 280,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Nhận tiền từ mọi Ngân hàng và Ví điện tử',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.black,
                        fontFamily: 'Inter',
                      ),
                    ),
                    SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Hướng dẫn thanh toán bằng Momo',
                        style: TextStyle(
                          color: AppColors.greenDark,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        instructionRow("1", "Mở ứng dụng Momo trên app điện thoại"),
                        instructionRow("2", "Dùng biểu tượng để quét mã QR"),
                        instructionRow("3", "Quét mã ở trang này và thanh toán"),
                      ],
                    ),
             
                  ],
                ),
              ),
              SizedBox(height: 32),

              SizedBox(
                child: ElevatedButton(
                  onPressed: _handleConfirmPayment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.mainOrange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: Text(
                    'Xác nhận thanh toán',
                    style: TextStyle(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      fontFamily: 'Inter', 
                    ),
                  ),
                ),
              ),
              SizedBox(height: 32),

              //Ngân Hàng
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Chọn ngân hàng thanh toán',
                        style: TextStyle(
                          fontWeight: FontWeight.bold, 
                          fontSize: 17,
                          fontFamily: 'Inter',
                        ),
                      ),
                      SizedBox(height: 16),

                      // Hàng 1: 3 ảnh
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset('assets/image/vietqr.png', width: 100, height: 50),
                          Image.asset('assets/image/atm.png', width: 100, height: 50),
                          Image.asset('assets/image/vnpay.png', width: 100, height: 50),
                        ],
                      ),
                      SizedBox(height: 16),

                      // Hàng 2: 3 ảnh
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset('assets/image/visa.png', width: 100, height: 50),
                          Image.asset('assets/image/viettel.png', width: 100, height: 50),
                          Image.asset('assets/image/spay.png', width: 100, height: 50),
                        ],
                      ),
                      SizedBox(height: 16),

                      // Hàng 3: 2 ảnh + 1 khoảng trống
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset('assets/image/momo.png', width: 100, height: 50),
                          Image.asset('assets/image/zalopay.png', width: 100, height: 50),
                          SizedBox(width: 100),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 32),
              //Thông tin user
              Container(
                padding: EdgeInsets.all(12),
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Thông tin khách hàng',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        fontFamily: 'Inter',
                      ),
                    ),
                    SizedBox(height: 8),

                    buildInfoRow('Họ tên', fullname, isBold: true),
                    SizedBox(height: 8),
                    buildInfoRow('Số điện thoại', phoneNumber),
                    SizedBox(height: 8),
                    buildInfoRow('Email', email),
                    SizedBox(height: 8),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: FooterNavigation(),
    );
  }

  Widget buildInfoRow(String label, String value, {bool isBold = false}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        label,
        style: TextStyle(
          fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
          fontFamily: 'Inter',
        ),
      ),
      Flexible(
        child: Text(
          value,
          textAlign: TextAlign.right,
          style: TextStyle(
            fontFamily: 'Inter',
            color: AppColors.black,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ],
  );
}


  Widget instructionRow(String number, String text) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: AppColors.white.withOpacity(0.1),
            border: Border.all(color: AppColors.white, width: 1.5),
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Text(
            number,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.black,
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 15,
              fontFamily: 'Inter',
              height: 1.4,
            ),
          ),
        ),
      ],
    ),
  );
}
}
