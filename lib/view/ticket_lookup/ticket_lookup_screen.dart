import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:giao_dien_1/view/ticket_lookup/ticket_details.dart';
import 'package:giao_dien_1/config/default.dart';
import 'package:giao_dien_1/widget/appbar.dart';
import 'package:giao_dien_1/widget/footer.dart';
import 'package:giao_dien_1/model/ticket.dart';
import 'package:giao_dien_1/widget/ticket_info.dart';
import 'package:giao_dien_1/config/config.dart';

class TicketLookupScreen extends StatefulWidget {
  const TicketLookupScreen({super.key});

  @override
  State<TicketLookupScreen> createState() => _TicketLookupScreenState();
}

class _TicketLookupScreenState extends State<TicketLookupScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _ticketCodeController = TextEditingController();

  List<Ticket> _foundTickets = [];
  bool _isSearched = false;
  bool _isLoading = false;

  Future<void> _findTicket() async {
    final phone = _phoneController.text.trim();
    final code = _ticketCodeController.text.trim();

    if (phone.isEmpty || code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập đầy đủ số điện thoại và mã vé.')),
      );
      return;
    }

    setState(() {
      _isSearched = true;
      _isLoading = true;
      _foundTickets = [];
    });

    try {
      final url = Uri.parse('$baseURL/api/tim-ve?phone=$phone&code=$code');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

      setState(() {
        _foundTickets = data.map((e) => Ticket.fromJson(e)).toList().reversed.toList();
      });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Không tìm thấy vé. Mã lỗi: ${response.statusCode}')),
        );
      }
    } catch (e) {
      print('❌ Lỗi khi gọi API: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lỗi kết nối tới máy chủ.')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
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
                  TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.phone, color: AppColors.mainOrange),
                      hintText: 'Nhập số điện thoại', hintStyle: TextStyle(
                        color: AppColors.grey600,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Inter',
                        fontSize: 14,
                      ),
                      filled: true,
                      fillColor: Colors.white,
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
                    controller: _ticketCodeController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.confirmation_number, color: AppColors.mainOrange),
                      hintText: 'Nhập mã vé',
                      filled: true,
                      fillColor: Colors.white,
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
                      onPressed: _isLoading ? null : _findTicket,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.mainOrange,
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        shadowColor: AppColors.mainOrange,
                      ),
                      child: _isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : const Text(
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
            if (_foundTickets.isNotEmpty)
              ..._foundTickets.map((ticket) => _buildTicketCard(ticket)).toList()
            else if (_isSearched && !_isLoading)
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
              Image.asset('assets/image/lookup_illustration.png', height: 150),
              const SizedBox(height: 10),
              const Text('NHÀ XE NAM HẢI',
                  style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.red, fontSize: 20, fontFamily: 'Inter')),
              const Text('NHỮNG CHUYẾN ĐI AN TOÀN',
                  style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.red, fontSize: 20, fontFamily: 'Inter')),
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
          TicketInfoWidget(ticket: ticket),
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
}
