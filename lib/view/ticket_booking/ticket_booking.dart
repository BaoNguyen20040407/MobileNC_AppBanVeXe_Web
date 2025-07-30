import 'package:flutter/material.dart';
import 'package:giao_dien_1/config/default.dart';
import 'package:giao_dien_1/view/payment/payment.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:giao_dien_1/widget/appbar.dart';
import 'package:giao_dien_1/widget/footer.dart';
import 'package:intl/intl.dart';
import 'package:giao_dien_1/view/main/homepage.dart';
import 'package:http/http.dart' as http;
import 'package:giao_dien_1/config/config.dart';
import 'package:giao_dien_1/model/trip.dart';

void main() => runApp(MaterialApp(home: TicketBookingPage()));

class TicketBookingPage extends StatefulWidget {
  @override
  _TicketBookingPageState createState() => _TicketBookingPageState();
}

enum SeatState { available, sold, selected }

class _TicketBookingPageState extends State<TicketBookingPage> {
  Map<String, SeatState> seatMap = {
    for (var i = 1; i <= 36; i++)
      (i <= 18 ? 'A$i' : 'B${i - 18}'): SeatState.available,
  };

  List<String> selectedSeats = [];
  bool agreedToTerms = false;
  int seatPrice = 120000;
  int totalPrice = 0;
  String pickupPoint = "Bến Xe Nam Hải - TP. Hồ Chí Minh";
  String dropoffPoint = "Bến Xe Nam Hải - Hà Nội";
  String pickupTime = "05:00 16/04/2025";
  String startTime = "";
  String diemDi = '';
  String diemDen = '';
  String ngayDi = '';
  String fullname = '';
  String phoneNumber = '';
  String email = '';

  DateTime? parsedStartTime;
  String suggestArriveTime = '';
  Trip? selectedTrip;


  @override
  void initState() {
    super.initState();
    seatMap['A4'] = SeatState.sold;
    seatMap['A17'] = SeatState.sold;
    fetchCustomerInfo();
    loadDataFromPrefsAndServer(); // chỉ cần 1 hàm này
  }

  String formatCurrency(int amount) {
  final formatter = NumberFormat("#,###", "vi_VN");
  return '${formatter.format(amount)} VND';
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

Future<void> loadDataFromPrefsAndServer() async {
  final prefs = await SharedPreferences.getInstance();
  final maCX = prefs.getString('maCX');

  if (maCX == null || maCX.isEmpty) {
    debugPrint('⚠️ Không tìm thấy maCX trong SharedPreferences');
    return;
  }

  try {
    final url = '$baseURL/chuyenxe/$maCX';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);

      if (json['success'] == true) {
        final data = json['data'];

        setState(() {
          selectedTrip = Trip.fromJson(data);
          diemDi = selectedTrip?.diemDi ?? '';
          diemDen = selectedTrip?.diemDen ?? '';

          try {
            final raw = selectedTrip!.gioBatDau;
            debugPrint('🔍 Thời gian gốc từ server: $raw');

            final dt = DateTime.parse(raw).toLocal(); // ✅ sửa tại đây

            startTime = DateFormat('HH:mm').format(dt);
            ngayDi = DateFormat('dd/MM/yyyy').format(dt);
            suggestArriveTime = DateFormat('HH:mm').format(dt.subtract(Duration(minutes: 30)));
          } catch (e) {
            debugPrint('❌ Lỗi phân tích thời gian: ${selectedTrip?.gioBatDau} - $e');
            startTime = '';
            ngayDi = '';
            suggestArriveTime = 'trước 30 phút';
          }

          debugPrint('✅ Chuyến xe đã load: ${selectedTrip!.diemDi} - ${selectedTrip!.diemDen} lúc ${selectedTrip!.gioBatDau}');
        });
      } else {
        debugPrint('❌ API trả về success = false');
      }
    } else {
      debugPrint('❌ Lỗi lấy thông tin chuyến xe: ${response.statusCode}');
    }
  } catch (e) {
    debugPrint('❌ Lỗi khi load chuyến xe: $e');
  }
}

Future<void> handleBookingAndNavigate(BuildContext context) async {
  updateTotalPrice(); // ← THÊM DÒNG NÀY

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => const Center(child: CircularProgressIndicator()),
  );

  try {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('pickupPoint', pickupPoint);
    await prefs.setString('dropoffPoint', dropoffPoint);
    await prefs.setString('startTime', startTime); 
    await prefs.setString('ngayDi', ngayDi);
    await prefs.setStringList('selectedSeats', selectedSeats);
    await prefs.setInt('seatPrice', seatPrice);
    await prefs.setInt('totalPrice', totalPrice); // ⬅ đúng giá trị đã cập nhật
    await prefs.setString('route', '$diemDi - $diemDen'); 

    await Future.delayed(const Duration(milliseconds: 200)); // tránh gắt khung hình

    Navigator.pop(context); // đóng loading
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const Payment()),
    );
  } catch (e) {
    Navigator.pop(context); // đóng loading nếu lỗi
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Đã xảy ra lỗi khi đặt vé: $e")),
    );
  }
}


  String _convertToIsoFormat(String original) {
  try {
    final parts = original.trim().split(' ');
    if (parts.length != 2) throw FormatException('Thiếu thời gian hoặc ngày');

    final time = parts[0].trim();
    final dateParts = parts[1].split('/');
    if (dateParts.length != 3) throw FormatException('Ngày sai định dạng');

    final day = dateParts[0].padLeft(2, '0');
    final month = dateParts[1].padLeft(2, '0');
    final year = dateParts[2];

    return '$year-$month-$day $time:00';
  } catch (e) {
    debugPrint('Lỗi chuyển đổi định dạng thời gian: $e');
    throw e;
  }
}

  String _formatTime(DateTime dt) {
    return dt.hour.toString().padLeft(2, '0') + ':' + dt.minute.toString().padLeft(2, '0');
  }

  String _formatDate(DateTime dt) {
    return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
  }

  void updateTotalPrice() {
    setState(() {
      totalPrice = selectedSeats.length * seatPrice;
    });
  }

  Widget buildSeat(String seatId) {
    SeatState state = seatMap[seatId]!;
    String assetPath;
    switch (state) {
      case SeatState.selected:
        assetPath = 'assets/image/chair_choosing.png';
        break;
      case SeatState.sold:
        assetPath = 'assets/image/chair_sold.png';
        break;
      case SeatState.available:
      default:
        assetPath = 'assets/image/chair_default.png';
        break;
    }

    return GestureDetector(
      onTap:
          state == SeatState.sold
              ? null
              : () {
                setState(() {
                  if (state == SeatState.selected) {
                    seatMap[seatId] = SeatState.available;
                    selectedSeats.remove(seatId);
                  } else {
                    if (selectedSeats.length >= 5) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text('Tối Đa 5 Ghế')));
                      return;
                    }
                    seatMap[seatId] = SeatState.selected;
                    selectedSeats.add(seatId);
                  }
                  updateTotalPrice();
                });
              },
      child: Column(
        children: [
          Image.asset(assetPath, width: 19),
          Text(seatId, style: TextStyle(fontSize: 10, fontFamily: 'Inter', color: AppColors.black)),
        ],
      ),
    );
  }

  Widget buildSeatGrid(List<String> seats) {
  return LayoutBuilder(
    builder: (context, constraints) {
      // Tính chiều cao cần thiết cho grid (số hàng)
      final rowCount = (seats.length / 3).ceil();
      final estimatedHeight = rowCount * 60.0 + (rowCount - 1) * 16.0; // mỗi item ~60px + spacing

      return SizedBox(
        height: estimatedHeight,
        child: GridView.builder(
          padding: EdgeInsets.zero,
          itemCount: seats.length,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 16,
            crossAxisSpacing: 0,
            childAspectRatio: 1.5,
          ),
          itemBuilder: (context, index) {
            return buildSeat(seats[index]);
          },
        ),
      );
    },
  );
}


  @override
  Widget build(BuildContext context) {
    List<String> leftSeats = [for (var i = 1; i <= 18; i++) 'A$i'];
    List<String> rightSeats = [for (var i = 1; i <= 18; i++) 'B$i'];

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(24, 32, 24, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              children: [
                Text(
                  '${diemDi.toUpperCase()} - ${diemDen.toUpperCase()}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.mainOrange,
                    fontFamily: 'Inter',
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  ngayDi,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.mainOrange,
                    fontFamily: 'Inter',
                  ),
                ),
                SizedBox(height: 16),
              ],
            ),
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Chọn ghế',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),

                  SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 300,
                          child: buildSeatGrid(leftSeats),
                        ),
                      ),
                      Container(
                        width: 2,
                        height: 300,
                        margin: EdgeInsets.symmetric(horizontal: 8),
                        color: Colors.black,
                      ),
                      Expanded(
                        child: SizedBox(
                          height: 300,
                          child: buildSeatGrid(rightSeats),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            'assets/image/chair_sold.png',
                            width: 20,
                            cacheHeight: 40,
                            cacheWidth: 40,
                          ),
                          SizedBox(width: 4),
                          Text('Đã bán', style: TextStyle(fontFamily: 'Inter', fontSize: 14),),
                        ],
                      ),
                      Row(
                        children: [
                          Image.asset(
                            'assets/image/chair_default.png',
                            width: 20,
                          ),
                          SizedBox(width: 4),
                          Text('Còn trống', style: TextStyle(fontFamily: 'Inter', fontSize: 14),),
                        ],
                      ),
                      Row(
                        children: [
                          Image.asset(
                            'assets/image/chair_choosing.png',
                            width: 20,
                          ),
                          SizedBox(width: 4),
                          Text('Đang chọn', style: TextStyle(fontFamily: 'Inter', fontSize: 14),),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
            SizedBox(height: 32),
            infoCard(
              title: 'Thông tin khách hàng',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: TextStyle(fontFamily: 'Inter', fontSize: 14, color: AppColors.black),
                      children: [
                        TextSpan(text: 'Họ tên: ', style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(text: fullname, style: TextStyle(fontWeight: FontWeight.normal, color: AppColors.black)),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(fontFamily: 'Inter', fontSize: 14, color: AppColors.black),
                      children: [
                        TextSpan(text: 'Số điện thoại: ', style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(text: phoneNumber, style: TextStyle(fontWeight: FontWeight.normal, color: AppColors.black)),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(fontFamily: 'Inter', fontSize: 14, color: AppColors.black),
                      children: [
                        TextSpan(text: 'Email: ', style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(text: email, style: TextStyle(fontWeight: FontWeight.normal, color: AppColors.black)),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "ĐIỀU KHOẢN & LƯU Ý",
                    style: TextStyle(
                      color: AppColors.mainOrange,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Inter',
                      fontSize: 14, 
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "(*): Quý khách vui lòng có mặt tại bến lúc $suggestArriveTime $ngayDi",
                    style: TextStyle(fontSize: 14, fontFamily: 'Inter'),
                  ),
                  SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Transform.translate(
                        offset: Offset(-4, 0), // đẩy sang trái 4px
                        child: Transform.scale(
                          scale: 0.8, // thu nhỏ checkbox
                          child: Checkbox(
                            value: agreedToTerms,
                            activeColor: AppColors.mainOrange,
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                            onChanged: (val) {
                              setState(() {
                                agreedToTerms = val!;
                              });
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            "Chấp nhận quy định đặt vé & chính sách bảo mật thông tin",
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14,
                              height: 1.4, // tăng độ cao dòng cho đẹp
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16,),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32,),
            infoCard(
              title: 'Thông tin lượt đi',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow('Tuyến xe:', '$diemDi - $diemDen'),
                      SizedBox(height: 8),
                      _buildInfoRow('Giờ xuất bến:', '$startTime $ngayDi'),
                      SizedBox(height: 8),
                      _buildInfoRow('Số lượng ghế:', '${selectedSeats.length} ghế'),
                      SizedBox(height: 8),
                      _buildInfoRow('Số ghế:', selectedSeats.join(', '), isSeat: true),
                      SizedBox(height: 8),
                      _buildInfoRow('Điểm trả khách:', diemDen),
                      SizedBox(height: 8),
                      _buildInfoRow('Tổng tiền lượt đi:', '${formatCurrency(totalPrice)}', isTotal: true),
                      SizedBox(height: 8),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox (height: 32,),
            infoCard(
              title: 'Chi tiết giá',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow('Giá vé lượt đi:', formatCurrency(totalPrice)),
                  SizedBox(height: 8),
                  _buildInfoRow('Phí thanh toán:', '0 VND'),
                  SizedBox(height: 8),
                  _buildInfoRow('Tổng tiền:', formatCurrency(totalPrice), isTotal: true),
                  SizedBox(height: 8),
                ],
              ),
            ),
            const SizedBox(height: 32,),
            infoCard(
              title: 'Thanh toán',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '(*) Quý khách chỉ có thể thanh toán khi chọn ít nhất 1 chỗ ngồi và đã nhấn nút Chấp nhận điều khoản đặt vé',
                    style: TextStyle(
                      fontSize: 14, 
                      fontFamily: 'Inter', 
                      color: AppColors.black
                      ),
                  ),
                  SizedBox(height: 8),
                  Center(
                    child: Text(
                      '${formatCurrency(totalPrice)}',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.deepOrange,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 40,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => HomePage()),
                          (route) => false,
                        );
                      },
                      icon: Icon(
                        Icons.block,
                        size: 18,
                        color: selectedSeats.isNotEmpty && agreedToTerms
                            ? Colors.black
                            : AppColors.greyLight,
                      ),
                      label: Text(
                        'Hủy',
                        style: TextStyle(
                          fontSize: 17,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.bold,
                          color: selectedSeats.isNotEmpty && agreedToTerms
                              ? Colors.black
                              : AppColors.greyLight,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        overlayColor: Colors.transparent,
                        side: BorderSide(
                          color: selectedSeats.isNotEmpty && agreedToTerms
                              ? Colors.black
                              : AppColors.greyLight,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: SizedBox(
                    height: 40,
                    child: ElevatedButton.icon(
                      onPressed: selectedSeats.isNotEmpty && agreedToTerms
                        ? () => handleBookingAndNavigate(context)
                        : null,

                      icon: Icon(Icons.credit_card, size: 18, color: AppColors.white,),
                      label: Text(
                        'Thanh toán',
                        style: TextStyle(
                          fontSize: 17,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.mainOrange,
                        disabledBackgroundColor: AppColors.greyLight,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 4,
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      bottomNavigationBar: FooterNavigation(),
    );
  }

  Widget _buildInfoRow(String title, String value, {bool isSeat = false, bool isTotal = false}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        title,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      Flexible(
        child: Text(
          value,
          textAlign: TextAlign.right,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: isSeat || isTotal ? FontWeight.bold : FontWeight.normal,
            color: isSeat
                ? AppColors.greenDark
                : isTotal
                    ? AppColors.mainOrange
                    : AppColors.black,
          ),
        ),
      ),
    ],
  );
}

  Widget buildLegend(Color color, String label) {
    return Row(
      children: [
        Icon(Icons.event_seat, color: color),
        SizedBox(width: 4),
        Text(label),
      ],
    );
  }

  Widget infoCard({required String title, required Widget child}) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, fontFamily: 'Inter'),
          ),
          SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}