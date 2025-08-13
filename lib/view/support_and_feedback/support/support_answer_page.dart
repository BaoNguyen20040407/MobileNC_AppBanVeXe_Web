import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:giao_dien_1/widget/appbar_profile.dart';
import 'package:giao_dien_1/config/default.dart';
import 'package:giao_dien_1/config/config.dart';
import 'package:giao_dien_1/widget/qa_chat.dart';

class SupportAnswerPage extends StatefulWidget {
  final String maHT;

  const SupportAnswerPage({super.key, required this.maHT});

  @override
  _SupportAnswerPageState createState() => _SupportAnswerPageState();
}

class _SupportAnswerPageState extends State<SupportAnswerPage> {
  String? question;
  String? answer;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSupportAnswer();
  }

  Future<void> _loadSupportAnswer() async {
    try {
      final response = await http.get(Uri.parse('$baseURL/hotro/detail/${widget.maHT}'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final result = data['data'];
        setState(() {
          question = result['CauHoi'] ?? 'Yêu cầu hỗ trợ';
          answer = result['CauTraLoi']?.toString().trim().isNotEmpty == true
              ? result['CauTraLoi']
              : 'Chưa có phản hồi.';
          isLoading = false;
        });
      } else {
        setState(() {
          question = 'Yêu cầu không tồn tại';
          answer = 'Không tìm thấy yêu cầu hỗ trợ.';
          isLoading = false;
        });
      }
    } catch (e) {
      print('Lỗi khi tải phản hồi hỗ trợ: $e');
      setState(() {
        question = 'Lỗi';
        answer = 'Lỗi kết nối máy chủ.';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softOrangeBackground,
      appBar: const AppBarProfile(title: 'HỖ TRỢ'),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: AppColors.mainOrange))
          : QAChatCard(
              sectionTitle: 'PHẢN HỒI HỖ TRỢ',
              question: question ?? '...',
              answer: answer ?? '',
              questionIcon: Icons.support_agent,
              answerIcon: Icons.support_agent,
              actionText: 'Thêm câu hỏi',
              onAction: () => Navigator.pop(context),
            ),
    );
  }
}