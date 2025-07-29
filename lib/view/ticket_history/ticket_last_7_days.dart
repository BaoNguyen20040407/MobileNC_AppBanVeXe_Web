import 'package:flutter/material.dart';
import 'package:giao_dien_1/view/main/homepage.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:giao_dien_1/model/ticket.dart';
import 'package:giao_dien_1/config/default.dart';
import 'package:giao_dien_1/widget/ticket_info.dart';
import 'package:giao_dien_1/widget/appbar_profile.dart';
import 'package:giao_dien_1/view/ticket_lookup/ticket_details.dart';
import 'package:giao_dien_1/config/config.dart';

class TicketLast7DaysPage extends StatefulWidget {
  const TicketLast7DaysPage({super.key});

  @override
  State<TicketLast7DaysPage> createState() => _TicketLast7DaysPageState();
}

class _TicketLast7DaysPageState extends State<TicketLast7DaysPage> {
  List<Ticket> last7DaysTickets = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchLast7DaysTickets();
  }

  Future<void> _fetchLast7DaysTickets() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');
    print('🔍 DEBUG username: $username');

    if (username == null || username.isEmpty) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không tìm thấy tên đăng nhập.')),
      );
      return;
    }

    final uri = Uri.parse('$baseURL/api/ve?filter=7days&username=$username');

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      print('📦 Vé 7 ngày: $data');

      setState(() {
        last7DaysTickets = data.map((e) => Ticket.fromJson(e)).toList().reversed.toList();
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
      final message = response.statusCode == 401
          ? 'Bạn cần đăng nhập để xem vé.'
          : 'Lỗi server: ${response.statusCode}';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    }
  } catch (e) {
    setState(() => isLoading = false);
    print('❌ Lỗi khi tải vé 7 ngày: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã xảy ra lỗi khi tải dữ liệu.')),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final sevenDaysAgo = now.subtract(const Duration(days: 6));
    final dateRangeLabel = '${DateFormat('dd/MM/yyyy').format(sevenDaysAgo)} - ${DateFormat('dd/MM/yyyy').format(now)}';

    return Scaffold(
      backgroundColor: AppColors.softOrangeBackground,
      appBar: AppBarProfile(title: dateRangeLabel),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
              child: last7DaysTickets.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.airline_seat_recline_normal,
                              size: 60,
                              color: AppColors.mainOrange.withOpacity(0.8)),
                          const SizedBox(height: 16),
                          Text(
                            'Không có vé nào\ntrong 7 ngày qua\nHãy đặt vé nhé!',
                            style: TextStyle(
                              fontSize: 20,
                              color: AppColors.black,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => HomePage(),
                                  settings: const RouteSettings(name: '/home'),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.mainOrange,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 4,
                            ),
                            icon: const Icon(Icons.add_shopping_cart,
                                color: Colors.white),
                            label: const Text(
                              'Đặt vé',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Inter',
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      itemCount: last7DaysTickets.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 32),
                      itemBuilder: (context, index) {
                        final ticket = last7DaysTickets[index];
                        return Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: AppColors.mainOrange, width: 5),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              )
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TicketInfoWidget(ticket: ticket),
                              const SizedBox(height: 8),
                              Align(
                                alignment: Alignment.center,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => TicketDetails(),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.mainOrange,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 10),
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
                      },
                    ),
            ),
    );
  }
}
