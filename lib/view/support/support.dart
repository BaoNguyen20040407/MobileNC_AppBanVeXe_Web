import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:giao_dien_1/view/support/support_answer_page.dart';
import 'package:giao_dien_1/view/support/support_loading.dart';
import 'package:giao_dien_1/widget/appbar_profile.dart';
import 'package:giao_dien_1/config/default.dart';

void main() {
  runApp(SupportPageApp());
}

class SupportPageApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: SupportPage(), debugShowCheckedModeBanner: false);
  }
}

class SupportPage extends StatefulWidget {
  @override
  State<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  List<String> _myQuestions = [];
  Set<String> _readQuestions = {};

  final List<String> _commonQuestions = [
    'Làm sao để đổi vé?',
    'Tôi quên mật khẩu?',
    'Nhà xe có hỗ trợ đổi lịch?',
    'Có thể hoàn tiền vé không?',
    'Tôi không nhận được vé điện tử?',
  ];

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _myQuestions = prefs.getStringList('my_questions') ?? [];
      _readQuestions = (prefs.getStringList('read_questions') ?? []).toSet();
    });
  }

  Future<void> _markAsRead(String question) async {
    final prefs = await SharedPreferences.getInstance();
    _readQuestions.add(question);
    await prefs.setStringList('read_questions', _readQuestions.toList());
    setState(() {});
  }

  Future<void> _addNewQuestion(String question) async {
    final prefs = await SharedPreferences.getInstance();
    _myQuestions.insert(0, question);
    await prefs.setStringList('my_questions', _myQuestions);
    setState(() {
      _titleController.clear();
      _contentController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softOrangeBackground,
      appBar: AppBarProfile(title: 'HỖ TRỢ'),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(24, 32, 24, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSupportForm(),
            SizedBox(height: 32),
            _buildSection('CÂU HỎI PHỔ BIẾN', _commonQuestions, context, checkNew: true),
            SizedBox(height: 16),
            _buildSection('CÂU HỎI CỦA TÔI', _myQuestions, context),
          ],
        ),
      ),
    );
  }

  Widget _buildSupportForm() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.mainOrange, width: 5),
        boxShadow: [
          BoxShadow(
            color: AppColors.mainOrange,
            offset: Offset(0, 0),
            blurRadius: 0
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'HỖ TRỢ',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: AppColors.black,
              fontFamily: 'Inter',
            ),
          ),
          SizedBox(height: 12),
          TextField(
            controller: _titleController,
            cursorColor: AppColors.mainOrange,
            decoration: _buildInputDecoration('Nhập tiêu đề...'),
          ),
          SizedBox(height: 16),
          TextField(
            controller: _contentController,
            maxLines: 4,
            cursorColor: AppColors.mainOrange,
            decoration: _buildInputDecoration('Nhập nội dung câu hỏi...'),
          ),
          SizedBox(height: 16),
          Center(
            child: ElevatedButton(
              onPressed: () async {
                String title = _titleController.text.trim();
                if (title.isNotEmpty) {
                  await _addNewQuestion(title);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => LoadingPage()));
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.mainOrange,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                shadowColor: AppColors.mainOrange,
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
      hintStyle: TextStyle(color: AppColors.greyLight, fontFamily: 'Inter', fontSize: 14),
      filled: true,
      fillColor: Colors.white,
      hoverColor: Colors.transparent,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: AppColors.greyLight),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: AppColors.greyLight),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: AppColors.greyLight),
      ),
    );
  }

  Widget _buildSection(String title, List<String> questions, BuildContext context, {bool checkNew = false}) {
    return Container(
      margin: EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, fontFamily: 'Inter'),
            ),
          ),
          ...questions.map((q) {
            final isNew = checkNew && !_readQuestions.contains(q);
            return _buildQuestionTile(context, q, isNew: isNew);
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildQuestionTile(BuildContext context, String question, {bool isNew = false}) {
    return Column(
      children: [
        InkWell(
          onTap: () async {
            await _markAsRead(question);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => SupportAnswerPage(question: question)),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Icon(Icons.help_outline, color: Colors.black),
                SizedBox(width: 12),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          question,
                          style: TextStyle(fontFamily: 'Inter', fontSize: 14),
                        ),
                      ),
                      if (isNew)
                        Container(
                          margin: EdgeInsets.only(left: 8),
                          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.mainOrange,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'NEW',
                            style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios, size: 14),
              ],
            ),
          ),
        ),
        Divider(height: 1, thickness: 0.5, color: Colors.black12),
      ],
    );
  }
}