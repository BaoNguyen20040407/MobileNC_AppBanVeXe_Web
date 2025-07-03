import 'package:flutter/material.dart';
import 'package:giao_dien_1/view/ticket_lookup/ticket_details.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:giao_dien_1/config/default.dart';
import 'package:giao_dien_1/widget/appbar.dart';
import 'package:giao_dien_1/widget/footer.dart';
import 'package:giao_dien_1/model/ticket.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class TicketLookupScreen extends StatefulWidget {
  const TicketLookupScreen({super.key});

  @override
  State<TicketLookupScreen> createState() => _TicketLookupScreenState();
}

class _TicketLookupScreenState extends State<TicketLookupScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _ticketCodeController = TextEditingController();

  Ticket? _foundTicket;
  bool _isSearched = false;

  String formatCurrency(int value) {
  return NumberFormat("#,###", "vi_VN").format(value);
}

  @override
  void initState() {
    super.initState();
    _loadPhone();
    _phoneController.addListener(_savePhone);
  }

  Future<void> _loadPhone() async {
    final prefs = await SharedPreferences.getInstance();
    final phone = prefs.getString('phone') ?? '';
    setState(() {
      _phoneController.text = phone;
    });
  }

  Future<void> _savePhone() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('phone', _phoneController.text.trim());
  }

  Future<void> _findTicket() async {
  final prefs = await SharedPreferences.getInstance();
  final phone = _phoneController.text.trim();
  final seatCode = _ticketCodeController.text.trim();
  final key = 'ticket_${phone}_$seatCode';

  final ticketJson = prefs.getString(key);
  setState(() {
    _isSearched = true;
    if (ticketJson != null) {
      _foundTicket = Ticket.fromJson(jsonDecode(ticketJson));
    } else {
      _foundTicket = null;
    }
  });
}

  @override
  void dispose() {
    _phoneController.removeListener(_savePhone);
    _phoneController.dispose();
    _ticketCodeController.dispose();
    super.dispose();
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
              'TRA CỨU THÔNG TIN ĐẶT VÉ',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.mainOrange,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Tìm thông tin đặt vé của mình',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.black,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 20),
            Container(
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
                  // Ô nhập số điện thoại
                  TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.phone, color: AppColors.mainOrange),
                      filled: true,
                      fillColor: Colors.white,
                      hoverColor: Colors.transparent,
                      focusColor: Colors.transparent,
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

                  // Ô nhập mã vé
                  TextField(
                    controller: _ticketCodeController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.confirmation_number, color: AppColors.mainOrange),
                      hintText: 'Nhập mã vé',
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

                  // Nút tìm vé (chưa xử lý)
                  Center(
                    child: ElevatedButton(
                      onPressed: _findTicket,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.mainOrange,
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        shadowColor: AppColors.mainOrange,
                      ),
                      child: const Text(
                        'Tìm vé',
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

            const SizedBox(height: 32),
            if (_foundTicket != null)
              _buildTicketCard(_foundTicket!)
            else if (_isSearched)
              const Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text(
                  'Không tìm thấy thông tin phù hợp',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.black,
                    fontFamily: 'Inter',
                  ),
                ),
              )
            else ...[
              Image.asset(
                'assets/image/lookup_illustration.png',
                height: 150,
              ),
              const SizedBox(height: 10),
              const Text(
                'NHÀ XE NAM HẢI',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.red,
                  fontSize: 20,
                  fontFamily: 'Inter',
                ),
              ),
              const Text(
                'NHỮNG CHUYẾN ĐI AN TOÀN',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.red,
                  fontSize: 20,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ],
        ),
      ),
      bottomNavigationBar: FooterNavigation(),
    );
  }

  Widget _buildTicketCard(Ticket ticket) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: AppColors.mainOrange, width: 5),
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.3),
          spreadRadius: 1,
          blurRadius: 6,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Hàng đầu: Số ghế + QR
        Row(
          children: [
            Column(
              children: [
                Image.asset(
                  'assets/image/qrcode.png',
                  width: 60,
                  height: 60,
                ),
                const SizedBox(height: 4),
                const Text(
                  'Số ghế',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.greenDark,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  ticket.seatCode,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _infoRow('Tuyến xe', ticket.route),
                  const SizedBox(height: 4,),
                  _infoRow('Thời gian', '${ticket.time} ${ticket.date}'),
                  const SizedBox(height: 4,),
                  _infoRow('Điểm lên xe', 'BX Nam Hải - ${ticket.pickupPoint}'),
                  const SizedBox(height: 4,),
                  _infoRow('Giá vé', '${formatCurrency(ticket.totalPrice)} VND'),
                  const SizedBox(height: 16,),
                ],
              ),
            ),
          ],
        ),

        // Nút "Xem chi tiết vé"
        Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TicketDetails(),
                  settings: const RouteSettings(name: '/ticket_details'),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.mainOrange,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Xem chi tiết vé',
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


Widget _infoRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 140, // cố định độ rộng của label
          child: Text(
            '$label:',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              fontFamily: 'Inter',
              color: Colors.black87,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontFamily: 'Inter',
              color: Colors.black,
            ),
          ),
        ),
      ],
    ),
  );
}
}
