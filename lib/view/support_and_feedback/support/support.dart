import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:giao_dien_1/view/support_and_feedback/support/support_answer_page.dart';
import 'package:giao_dien_1/view/support_and_feedback/support/support_success.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:giao_dien_1/widget/appbar_profile.dart';
import 'package:giao_dien_1/config/default.dart';
import 'package:giao_dien_1/config/config.dart';
import 'package:giao_dien_1/widget/feedback_and_support.dart';
import 'package:giao_dien_1/widget/feedback_and_support_list.dart';

class SupportPage extends StatefulWidget {
  const SupportPage({super.key});

  @override
  State<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  List<Map<String, dynamic>> _mySupports = [];
  String? _maKH;

  @override
  void initState() {
    super.initState();
    _getMaKHAndLoadSupports();
  }

  Future<void> _getMaKHAndLoadSupports() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');
    if (username == null) return;

    try {
      final response = await http.get(Uri.parse('$baseURL/api/full-user/$username'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _maKH = data['data']['MaKH'];
        if (_maKH != null) {
          await _loadMySupports(_maKH!);
        }
      }
    } catch (e) {
      print('Lỗi lấy MaKH: $e');
    }
  }

  Future<void> _loadMySupports(String maKH) async {
    try {
      final response = await http.get(Uri.parse('$baseURL/hotro/khachhang/$maKH'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _mySupports = List<Map<String, dynamic>>.from(data['data']);
        });
      }
    } catch (e) {
      print('Lỗi khi tải hỗ trợ: $e');
    }
  }

  Future<void> _addNewSupport(String title, String content) async {
    if (_maKH == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không tìm thấy mã khách hàng')),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('$baseURL/hotro'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'TieuDe': title,
          'CauHoi': content,
          'MaKH': _maKH,
        }),
      );

      final result = jsonDecode(response.body);
      if (result['success']) {
        await _loadMySupports(_maKH!);
        setState(() {
          _titleController.clear();
          _contentController.clear();
        });
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => SuccessPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gửi thất bại: ${result['message']}')),
        );
      }
    } catch (e) {
      print('Lỗi gửi hỗ trợ: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Có lỗi xảy ra')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softOrangeBackground,
      appBar: AppBarProfile(title: 'HỖ TRỢ'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FeedbackAndSupportWidget(
              titleController: _titleController,
              contentController: _contentController,
              formTitle: 'HỖ TRỢ',
              titleHint: 'Nhập tiêu đề...',
              contentHint: 'Nhập nội dung câu hỏi...',
              onSubmit: () async {
                final title = _titleController.text.trim();
                final content = _contentController.text.trim();
                if (title.isNotEmpty && content.isNotEmpty) {
                  await _addNewSupport(title, content);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Vui lòng điền đủ tiêu đề và nội dung')),
                  );
                }
              },
            ),
            const SizedBox(height: 32),
            FeedbackAndSupportList(
              title: 'CÂU HỎI CỦA TÔI',
              emptyMessage: 'Bạn chưa có yêu cầu nào.',
              items: _mySupports,
              icon: Icons.help_outline,
              onItemTap: (support) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SupportAnswerPage(maHT: support['MaHT']),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}