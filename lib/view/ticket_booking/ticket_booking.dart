import 'package:flutter/material.dart';
import 'package:giao_dien_1/config/default.dart';
import 'package:giao_dien_1/view/payment/payment.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:giao_dien_1/widget/appbar.dart';
import 'package:giao_dien_1/widget/footer.dart';
import 'package:intl/intl.dart';
import 'package:giao_dien_1/view/main/homepage.dart';

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
  String startTime = "06:00 16/04/2025";
  String diemDi = '';
  String diemDen = '';
  String ngayDi = '';
  String fullname = '';
  String phoneNumber = '';
  String email = '';

  DateTime? parsedStartTime;
  String suggestArriveTime = '';


  @override
  void initState() {
    super.initState();
    seatMap['A4'] = SeatState.sold;
    seatMap['A17'] = SeatState.sold;
    loadPreferences();
  }

  String formatCurrency(int amount) {
  final formatter = NumberFormat("#,###", "vi_VN");
  return '${formatter.format(amount)} VND';
  }


  void loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      seatPrice = prefs.getInt('seatPrice') ?? 120000;
      pickupPoint = prefs.getString('pickupPoint') ?? pickupPoint;
      dropoffPoint = prefs.getString('dropoffPoint') ?? dropoffPoint;
      pickupTime = prefs.getString('pickupTime') ?? pickupTime;
      startTime = prefs.getString('startTime') ?? startTime;
      diemDi = prefs.getString('diemDi') ?? '';
      diemDen = prefs.getString('diemDen') ?? '';
      ngayDi = prefs.getString('ngayDi') ?? '';
      fullname = prefs.getString('full_name') ?? '';
      phoneNumber = prefs.getString('phone') ?? '';
      email = prefs.getString('email') ?? '';

      try {
      // Format chuẩn: "06:00 16/04/2025" → "2025-04-16 06:00:00"
      final isoTime = _convertToIsoFormat('$startTime $ngayDi');
      parsedStartTime = DateTime.parse(isoTime);

      final suggestTime = parsedStartTime!.subtract(const Duration(hours: 1, minutes: 30));
      suggestArriveTime = '${_formatTime(suggestTime)} ${_formatDate(suggestTime)}';
    } catch (e) {
      debugPrint('Lỗi định dạng thời gian: $e');
      suggestArriveTime = pickupTime;
    }
    });
  }

  String _convertToIsoFormat(String original) {
    // Chuyển "06:00 16/04/2025" => "2025-04-16 06:00:00"
    final parts = original.split(' ');
    final time = parts[0];
    final date = parts[1].split('/');
    return '${date[2]}-${date[1]}-${date[0]} $time:00';
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
        assetPath = 'image/chair_choosing.png';
        break;
      case SeatState.sold:
        assetPath = 'image/chair_sold.png';
        break;
      case SeatState.available:
      default:
        assetPath = 'image/chair_default.png';
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
          Image.asset(assetPath, width: 28),
          Text(seatId, style: TextStyle(fontSize: 10, fontFamily: 'Inter', color: AppColors.black)),
        ],
      ),
    );
  }

  Widget buildSeatGrid(List<String> seats) {
    return GridView.builder(
      padding: EdgeInsets.zero,
      itemCount: seats.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 0.05,
        crossAxisSpacing: 0.05,
        childAspectRatio: 1.5,
      ),
      itemBuilder: (context, index) {
        return buildSeat(seats[index]);
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
                          Image.asset('/image/chair_sold.png', width: 20),
                          SizedBox(width: 4),
                          Text('Đã bán', style: TextStyle(fontFamily: 'Inter', fontSize: 14),),
                        ],
                      ),
                      Row(
                        children: [
                          Image.asset(
                            '/image/chair_default.png',
                            width: 20,
                          ),
                          SizedBox(width: 4),
                          Text('Còn trống', style: TextStyle(fontFamily: 'Inter', fontSize: 14),),
                        ],
                      ),
                      Row(
                        children: [
                          Image.asset(
                            '/image/chair_choosing.png',
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
                    "(*): Quý khách vui lòng có mặt tại bến lúc $suggestArriveTime",
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
                      _buildInfoRow('Tuyến xe:', '$pickupPoint - $dropoffPoint'),
                      SizedBox(height: 8),
                      _buildInfoRow('Giờ xuất bến:', '$startTime $ngayDi'),
                      SizedBox(height: 8),
                      _buildInfoRow('Số lượng ghế:', '${selectedSeats.length} ghế'),
                      SizedBox(height: 8),
                      _buildInfoRow('Số ghế:', selectedSeats.join(', '), isSeat: true),
                      SizedBox(height: 8),
                      _buildInfoRow('Điểm trả khách:', dropoffPoint),
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
                      '${totalPrice} VND',
                      style: TextStyle(
                        color: AppColors.mainOrange,
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
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
                    height: 32,
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
                    height: 32,
                    child: ElevatedButton.icon(
                      onPressed: selectedSeats.isNotEmpty && agreedToTerms ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => Payment(),
                            settings: const RouteSettings(name: '/payment'),
                          ),
                        );
                      } : null,
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