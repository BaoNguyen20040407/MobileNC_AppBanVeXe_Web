import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:giao_dien_1/widget/appbar_profile.dart';
import 'package:giao_dien_1/config/default.dart';

class FeedbackAnswerPage extends StatefulWidget {
  final String question;

  const FeedbackAnswerPage({required this.question});

  @override
  _FeedbackAnswerPageState createState() => _FeedbackAnswerPageState();
}

class _FeedbackAnswerPageState extends State<FeedbackAnswerPage> {
  String? answer;

  @override
  void initState() {
    super.initState();
    _loadAnswer();
  }

  Future<void> _loadAnswer() async {
    final jsonString = await rootBundle.loadString('assets/data/feedback.json');
    final List<dynamic> data = json.decode(jsonString);

    final cleanedQuestion = widget.question.trim().replaceAll(' 🆕', '').replaceAll(' 💬', '');

    final match = data.firstWhere(
      (item) {
        final q = item['question']?.toString().trim().replaceAll(' 🆕', '').replaceAll(' 💬', '');
        return q == cleanedQuestion;
      },
      orElse: () => {},
    );

    if (mounted && match.isNotEmpty) {
      setState(() {
        answer = match['answer'];
      });
    } else {
      print('Không tìm thấy câu trả lời cho: $cleanedQuestion');
      setState(() {
        answer = 'Xin lỗi, chúng tôi chưa có phản hồi cho góp ý này.';
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
        child: answer == null
            ? Center(child: CircularProgressIndicator(color: AppColors.mainOrange))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
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
                                      offset: Offset(1, 2),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  widget.question,
                                  style: TextStyle(fontSize: 14, fontFamily: 'Inter'),
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
                                      offset: Offset(1, 2),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  answer ?? '',
                                  style: TextStyle(fontSize: 14, fontFamily: 'Inter'),
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
