import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:giao_dien_1/widget/appbar_profile.dart';

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
      backgroundColor: Color(0xFFFDF1E6),
      appBar: AppBarProfile(title: 'HỖ TRỢ'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: answer == null
            ? Center(
                child: CircularProgressIndicator(color: Color(0xFFFF5722)),
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: Text(
                            'GIẢI ĐÁP THẮC MẮC',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green[800],
                            ),
                          ),
                        ),
                        SizedBox(height: 12),
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 12,
                              child: Icon(Icons.person),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(widget.question),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 12,
                              child: Icon(Icons.support_agent),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Color(0xFFFFF3E0),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(answer ?? ''),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Center(
                          child: ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFFF5722),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'Thêm câu hỏi',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24),
                  Center(
                    child: Image.asset(
                      'image/bitexco.png',
                      height: 550,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
