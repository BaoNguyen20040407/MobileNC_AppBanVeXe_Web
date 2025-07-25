import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:giao_dien_1/widget/appbar_profile.dart';
import 'package:giao_dien_1/config/default.dart';
import 'package:giao_dien_1/config/config.dart';

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
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
        child: isLoading
            ? Center(child: CircularProgressIndicator(color: AppColors.mainOrange))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Center(
                          child: Text(
                            'PHẢN HỒI GÓP Ý',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.greenDark,
                              fontSize: 18,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Góp ý người dùng
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Flexible(
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                margin: const EdgeInsets.only(left: 48),
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 2,
                                      offset: const Offset(1, 2),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  question ?? '...',
                                  style: const TextStyle(fontSize: 14, fontFamily: 'Inter'),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const CircleAvatar(
                              radius: 16,
                              backgroundColor: AppColors.greenDark,
                              child: Icon(Icons.feedback, color: Colors.white, size: 16),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Phản hồi từ hệ thống
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const CircleAvatar(
                              radius: 16,
                              backgroundColor: AppColors.mainOrange,
                              child: Icon(Icons.feedback, color: Colors.white, size: 16),
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                margin: const EdgeInsets.only(right: 48),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFF3E0),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 2,
                                      offset: const Offset(1, 2),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  answer ?? '',
                                  style: const TextStyle(fontSize: 14, fontFamily: 'Inter'),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 32),

                        Center(
                          child: ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.mainOrange,
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            child: const Text(
                              'Thêm góp ý',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
      ),
    );
  }
}
