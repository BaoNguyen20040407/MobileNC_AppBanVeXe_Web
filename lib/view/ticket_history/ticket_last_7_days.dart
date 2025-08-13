import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:giao_dien_1/model/ticket.dart';
import 'package:giao_dien_1/config/default.dart';
import 'package:giao_dien_1/widget/appbar_profile.dart';
import 'package:giao_dien_1/config/config.dart';
import 'package:giao_dien_1/widget/ticket_list.dart';

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
      body: TicketListView(
        isLoading: isLoading,
        tickets: last7DaysTickets,
        emptyMessage: 'Không có vé nào trong 7 ngày qua\nHãy đặt vé nhé!',
      )
    );
  }
}
