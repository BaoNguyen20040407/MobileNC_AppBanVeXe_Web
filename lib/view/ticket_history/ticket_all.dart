import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:giao_dien_1/model/ticket.dart';
import 'package:giao_dien_1/config/default.dart';
import 'package:giao_dien_1/widget/appbar_profile.dart';
import 'package:giao_dien_1/config/config.dart';
import 'package:http/http.dart' as http;
import 'package:giao_dien_1/widget/ticket_list.dart';

class TicketAllPage extends StatefulWidget {
  const TicketAllPage({super.key});

  @override
  State<TicketAllPage> createState() => _TicketAllPageState();
}

class _TicketAllPageState extends State<TicketAllPage> {
  List<Ticket> allTickets = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAllTickets();
  }

  Future<void> _fetchAllTickets() async {
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

    final uri = Uri.parse('$baseURL/api/ve?filter=all&username=$username');

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      print('📦 Tất cả vé: $data');

      setState(() {
        allTickets = data.map((e) => Ticket.fromJson(e)).toList().reversed.toList();
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
    print('❌ Lỗi khi tải tất cả vé: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã xảy ra lỗi khi tải dữ liệu.')),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softOrangeBackground,
      appBar: const AppBarProfile(title: 'TẤT CẢ VÉ'),
      body: TicketListView(
        isLoading: isLoading,
        tickets: allTickets,
        emptyMessage: 'Không có vé nào\nHãy đặt vé nhé!',
      )
    );
  }
}