import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:giao_dien_1/view/support_and_feedback/support/support_answer_page.dart';
import 'package:giao_dien_1/view/support_and_feedback/support/support_success.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:giao_dien_1/widget/appbar_profile.dart';
import 'package:giao_dien_1/config/default.dart';
import 'package:giao_dien_1/config/config.dart';

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
            _buildSupportForm(),
            const SizedBox(height: 32),
            _buildSupportList(),
          ],
        ),
      ),
    );
  }

  Widget _buildSupportForm() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.mainOrange, width: 5),
        boxShadow: [
          BoxShadow(
            color: AppColors.mainOrange,
            offset: const Offset(0, 0),
            blurRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'HỖ TRỢ',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: AppColors.black,
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _titleController,
            cursorColor: AppColors.mainOrange,
            decoration: _buildInputDecoration('Nhập tiêu đề...'),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _contentController,
            maxLines: 4,
            cursorColor: AppColors.mainOrange,
            decoration: _buildInputDecoration('Nhập nội dung câu hỏi...'),
          ),
          const SizedBox(height: 16),
          Center(
            child: ElevatedButton(
              onPressed: () async {
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
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.mainOrange,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
              ),
              child: const Text(
                'Gửi',
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

  InputDecoration _buildInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: AppColors.greyLight,
        fontFamily: 'Inter',
        fontSize: 14,
      ),
      filled: true,
      fillColor: Colors.white,
      hoverColor: Colors.transparent,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.greyLight),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.greyLight),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.greyLight),
      ),
    );
  }

  Widget _buildSupportList() {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              'CÂU HỎI CỦA TÔI',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
                fontFamily: 'Inter',
              ),
            ),
          ),
          if (_mySupports.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text('Bạn chưa có yêu cầu nào.', style: TextStyle(fontFamily: 'Inter')),
            ),
          ..._mySupports.map((support) {
            return Column(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SupportAnswerPage(maHT: support['MaHT']),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    child: Row(
                      children: [
                        const Icon(Icons.help_outline, color: Colors.black),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            support['TieuDe'] ?? '',
                            style: const TextStyle(fontSize: 14, fontFamily: 'Inter'),
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios, size: 14),
                      ],
                    ),
                  ),
                ),
                const Divider(height: 1, thickness: 0.5, color: Colors.black12),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }
}