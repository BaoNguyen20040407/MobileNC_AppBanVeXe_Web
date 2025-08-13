import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:giao_dien_1/widget/appbar_profile.dart';
import 'package:giao_dien_1/config/default.dart';
import 'package:giao_dien_1/config/config.dart';
import 'package:giao_dien_1/widget/qa_chat.dart';

class FeedbackAnswerPage extends StatefulWidget {
  final String maGY;

  const FeedbackAnswerPage({required this.maGY, super.key});

  @override
  _FeedbackAnswerPageState createState() => _FeedbackAnswerPageState();
}

class _FeedbackAnswerPageState extends State<FeedbackAnswerPage> {
  String? question;
  String? answer;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAnswer();
  }

  Future<void> _loadAnswer() async {
    try {
      final response = await http.get(Uri.parse('$baseURL/gopy/detail/${widget.maGY}'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final result = data['data'];
        setState(() {
          question = result['NoiDungGopY'] ?? 'Góp ý';
          answer = result['PhanHoi']?.toString().trim().isNotEmpty == true
              ? result['PhanHoi']
              : 'Chưa có phản hồi.';
          isLoading = false;
        });
      } else {
        setState(() {
          question = 'Góp ý không tồn tại';
          answer = 'Không tìm thấy góp ý.';
          isLoading = false;
        });
      }
    } catch (e) {
      print('Lỗi khi tải phản hồi: $e');
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
      appBar: AppBarProfile(title: 'GÓP Ý'),
      body: isLoading
        ? Center(child: CircularProgressIndicator(color: AppColors.mainOrange))
        : QAChatCard(
            sectionTitle: 'PHẢN HỒI GÓP Ý',
            question: question ?? '...',
            answer: answer ?? '',
            questionIcon: Icons.feedback,
            answerIcon: Icons.feedback,
            actionText: 'Thêm câu hỏi',
            onAction: () => Navigator.pop(context),
      ),
    );
  }
}