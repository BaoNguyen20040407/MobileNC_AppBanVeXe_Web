import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:giao_dien_1/widget/appbar.dart';
import 'package:giao_dien_1/widget/footer.dart';

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

  @override
  void initState() {
    super.initState();
    seatMap['A4'] = SeatState.sold;
    seatMap['A17'] = SeatState.sold;
    loadPreferences();
  }

  void loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      seatPrice = prefs.getInt('seatPrice') ?? 120000;
      pickupPoint = prefs.getString('pickupPoint') ?? pickupPoint;
      dropoffPoint = prefs.getString('dropoffPoint') ?? dropoffPoint;
      pickupTime = prefs.getString('pickupTime') ?? pickupTime;
      startTime = prefs.getString('startTime') ?? startTime;
    });
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
          Text(seatId, style: TextStyle(fontSize: 10)),
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
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    'Chọn ghế',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 8),
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
                          Text('Đã bán'),
                        ],
                      ),
                      Row(
                        children: [
                          Image.asset(
                            '/image/chair_default.png',
                            width: 20,
                          ),
                          SizedBox(width: 4),
                          Text('Còn trống'),
                        ],
                      ),
                      Row(
                        children: [
                          Image.asset(
                            '/image/chair_choosing.png',
                            width: 20,
                          ),
                          SizedBox(width: 4),
                          Text('Đang chọn'),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            infoCard(
              title: 'Thông tin khách hàng',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Họ tên: Nguyễn Gia Bảo"),
                  Text("Số điện thoại: 0765178079"),
                  Text("Email: baonguyenhuflit@gmail.com"),
                  SizedBox(height: 8),
                  Text(
                    "ĐIỀU KHOẢN & LƯU Ý",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "(*) Quý khách vui lòng có mặt tại bến xuất phát...",
                    style: TextStyle(fontSize: 12),
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: agreedToTerms,
                        onChanged: (val) {
                          setState(() {
                            agreedToTerms = val!;
                          });
                        },
                      ),
                      Expanded(
                        child: Text(
                          "Chấp nhận điều khoản đặt vé & chính sách bảo mật thông tin",
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            infoCard(
              title: 'Thông tin đón trả',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ĐIỂM ĐÓN:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '$pickupPoint',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF006400),
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(color: Colors.black),
                      children: [
                        TextSpan(text: '\nQuý khách vui lòng có mặt tại '),
                        TextSpan(
                          text: pickupPoint,
                          style: TextStyle(color: Colors.orange),
                        ),
                        TextSpan(text: ' trước '),
                        TextSpan(
                          text: pickupTime,
                          style: TextStyle(color: Colors.orange),
                        ),
                        TextSpan(
                          text:
                              ' để được trung chuyển hoặc kiểm tra thông tin trước khi lên xe.',
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'ĐIỂM TRẢ:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '$dropoffPoint',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF006400),
                    ),
                  ),
                ],
              ),
            ),
            infoCard(
              title: 'Thông tin lượt đi',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Tuyến xe: $pickupPoint - $dropoffPoint'),
                  Text('Giờ xuất bến: $startTime'),
                  Text('Số lượng ghế: ${selectedSeats.length} ghế'),
                  Text('Số ghế: ${selectedSeats.join(', ')}'),
                  Text('Điểm trả khách: $dropoffPoint'),
                  Text('Tổng tiền lượt đi: ${totalPrice} VND'),
                ],
              ),
            ),
            infoCard(
              title: 'Chi tiết giá',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Giá vé lượt đi: ${seatPrice} VND'),
                  Text('Phí thanh toán: 0 VND'),
                  Text(
                    'Tổng tiền: ${totalPrice} VND',
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
            ),
            infoCard(
              title: 'Thanh toán',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '(*) Quý khách chỉ có thể thanh toán khi chọn ít nhất 1 chỗ ngồi và đã nhấn nút Chấp nhận điều khoản đặt vé',
                    style: TextStyle(fontSize: 12),
                  ),
                  SizedBox(height: 8),
                  Center(
                    child: Text(
                      '${totalPrice} VND',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 40,
                    child: OutlinedButton(onPressed: () {}, child: Text('Hủy')),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: SizedBox(
                    height: 40,
                    child: ElevatedButton(
                      onPressed:
                          selectedSeats.isNotEmpty && agreedToTerms
                              ? () {}
                              : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        disabledBackgroundColor: Colors.grey,
                      ),
                      child: Text('Thanh toán'),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: FooterNavigation(),
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
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}
