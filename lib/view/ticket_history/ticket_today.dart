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

class TicketTodayPage extends StatefulWidget {
  const TicketTodayPage({super.key});

  @override
  State<TicketTodayPage> createState() => _TicketTodayPageState();
}

class _TicketTodayPageState extends State<TicketTodayPage> {
  List<Ticket> todayTickets = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTodayTickets();
  }

  Future<void> _fetchTodayTickets() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final username = prefs.getString('username'); // ✅ username, không phải MaTK
      print('🔍 DEBUG username: $username');

      if (username == null || username.isEmpty) {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Không tìm thấy tên đăng nhập.')),
        );
        return;
      }

      final uri = Uri.parse('$baseURL/api/ve?filter=today&username=$username');

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        print('📦 Dữ liệu vé: ${response.body}');
        setState(() {
          todayTickets = data.map((e) => Ticket.fromJson(e)).toList().reversed.toList();
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
      print('Lỗi khi tải vé hôm nay: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã xảy ra lỗi khi tải dữ liệu.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final todayFormatted = DateFormat('dd/MM/yyyy').format(DateTime.now());

    return Scaffold(
      backgroundColor: AppColors.softOrangeBackground,
      appBar: AppBarProfile(title: todayFormatted),
      body: TicketListView(
        isLoading: isLoading,
        tickets: todayTickets,
        emptyMessage: 'Không có vé nào trong hôm nay\nHãy đặt vé nhé!',
      )
    );
  }
}