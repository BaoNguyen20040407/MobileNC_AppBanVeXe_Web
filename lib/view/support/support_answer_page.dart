import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:giao_dien_1/widget/appbar_profile.dart';
import 'package:giao_dien_1/config/default.dart';

class SupportAnswerPage extends StatefulWidget {
  final String question;

  const SupportAnswerPage({required this.question});

  @override
  _SupportAnswerPageState createState() => _SupportAnswerPageState();
}

class _SupportAnswerPageState extends State<SupportAnswerPage> {
  String? answer;

  @override
  void initState() {
    super.initState();
    _loadAnswer();
  }

  Future<void> _loadAnswer() async {
    final jsonString = await rootBundle.loadString('lib/data/qna.json');
    final List<dynamic> data = json.decode(jsonString);
    final match = data.firstWhere(
      (item) => item['question'] == widget.question,
      orElse: () => null,
    );

    if (match != null && mounted) {
      setState(() {
        answer = match['answer'];
      });
    }
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.softOrangeBackground,
    appBar: AppBarProfile(title: 'HỖ TRỢ'),
    body: Padding(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
      child: answer == null
          ? Center(
              child: CircularProgressIndicator(color: AppColors.mainOrange),
            )
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
                          'GIẢI ĐÁP THẮC MẮC',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.greenDark,
                            fontSize: 18,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Tin nhắn người dùng (phải)
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
                            child: Icon(Icons.support_agent, color: Colors.white, size: 16),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Tin nhắn hệ thống (trái)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CircleAvatar(
                            radius: 16,
                            backgroundColor: AppColors.mainOrange,
                            child: Icon(Icons.support_agent, color: Colors.white, size: 16),
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

                      // Nút quay lại
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
                            'Thêm câu hỏi',
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

                // Ảnh trang trí
                Center(
                  child: Image.asset(
                    'image/bitexco.png',
                    height: 200,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
    ),
  );
}
}
