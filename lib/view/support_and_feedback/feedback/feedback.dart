import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:giao_dien_1/widget/appbar_profile.dart';
import 'package:giao_dien_1/config/default.dart';
import 'package:giao_dien_1/view/support_and_feedback/feedback/feedback_answer.dart';
import 'package:giao_dien_1/view/support_and_feedback/feedback/feedback_loading.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  List<String> _myFeedbacks = [];

  @override
  void initState() {
    super.initState();
    _loadSavedFeedbacks();
  }

  Future<void> _loadSavedFeedbacks() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _myFeedbacks = prefs.getStringList('my_feedbacks') ?? [];
    });
  }

  Future<void> _addNewFeedback(String title) async {
    final prefs = await SharedPreferences.getInstance();
    _myFeedbacks.insert(0, title);
    await prefs.setStringList('my_feedbacks', _myFeedbacks);
    setState(() {
      _titleController.clear();
      _contentController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softOrangeBackground,
      appBar: AppBarProfile(title: 'GÓP Ý'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFeedbackForm(),
            const SizedBox(height: 32),
            _buildFeedbackList(),
          ],
        ),
      ),
    );
  }

  Widget _buildFeedbackForm() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.mainOrange, width: 5),
        boxShadow: [
          BoxShadow(
            color: AppColors.mainOrange,
            offset: Offset(0, 0),
            blurRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'GÓP Ý',
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
            decoration: _buildInputDecoration('Nhập nội dung góp ý...'),
          ),
          const SizedBox(height: 16),
          Center(
            child: ElevatedButton(
              onPressed: () async {
                String title = _titleController.text.trim();
                if (title.isNotEmpty) {
                  await _addNewFeedback(title);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => LoadingPage()));
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

  Widget _buildFeedbackList() {
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
              'GÓP Ý CỦA TÔI',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
                fontFamily: 'Inter',
              ),
            ),
          ),
          ..._myFeedbacks.map((feedback) {
            return Column(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FeedbackAnswerPage(question: feedback),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    child: Row(
                      children: [
                        const Icon(Icons.feedback_outlined, color: Colors.black),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            feedback,
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
