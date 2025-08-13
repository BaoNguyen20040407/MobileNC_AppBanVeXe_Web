import 'package:flutter/material.dart';
import 'package:giao_dien_1/config/default.dart';

class QAChatCard extends StatelessWidget {
  final String sectionTitle;
  final String question;
  final String answer;
  final IconData questionIcon;
  final IconData answerIcon;
  final String actionText;
  final VoidCallback onAction;

  const QAChatCard({
    super.key,
    required this.sectionTitle,
    required this.question,
    required this.answer,
    required this.questionIcon,
    required this.answerIcon,
    required this.actionText,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
      child: Column(
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
                Center(
                  child: Text(
                    sectionTitle,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.greenDark,
                      fontSize: 18,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Câu hỏi
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
                          question,
                          style: const TextStyle(fontSize: 14, fontFamily: 'Inter'),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: AppColors.greenDark,
                      child: Icon(questionIcon, color: Colors.white, size: 16),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Câu trả lời
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: AppColors.mainOrange,
                      child: Icon(answerIcon, color: Colors.white, size: 16),
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
                          answer,
                          style: const TextStyle(fontSize: 14, fontFamily: 'Inter'),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                Center(
                    child: ElevatedButton(
                      onPressed: onAction,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.mainOrange,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min, // Để vừa nội dung
                        children: [
                          const Icon(
                            Icons.question_answer,
                            color: Colors.white,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            actionText,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}