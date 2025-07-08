import 'package:flutter/material.dart';
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

class SupportPage extends StatelessWidget {
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.mainOrange, width: 5),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.mainOrange,
                        offset: Offset(2, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          'HỖ TRỢ',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: AppColors.black,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                      TextField(
                        cursorColor: AppColors.mainOrange,
                        decoration: InputDecoration(
                          hintText: 'Nhập tiêu đề...',
                          hintStyle: TextStyle(
                            color: AppColors.greyLight,
                            fontFamily: 'Inter',
                          ),
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
                        ),
                      ),
                      SizedBox(height: 16),
                      TextField(
                        maxLines: 4,
                        cursorColor: AppColors.mainOrange,
                        decoration: InputDecoration(
                          hintText: 'Nhập nội dung câu hỏi...',
                          hintStyle: TextStyle(
                            color:  AppColors.greyLight,
                            fontFamily: 'Inter',
                          ),
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
                        ),
                      ),
                      SizedBox(height: 16),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoadingPage(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.mainOrange,
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
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
                ),
              ],
            ),

            SizedBox(height: 32),
            _buildSection('CÂU HỎI PHỔ BIẾN', [
              'Làm sao để đổi vé?',
              'Tôi quên mật khẩu?',
              'Nhà xe có hỗ trợ đổi lịch?',
              'Có thể hoàn tiền vé không?',
              'Tôi không nhận được vé điện tử?',
            ], context),

            SizedBox(height: 32),
            _buildSection('CÂU HỎI CỦA TÔI', [
              'Mang được mấy ký hành lý?',
              'Đổi vé thế nào?',
              'Làm sao để đổi hoặc huỷ vé đã đặt?',
            ], context),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
  String title,
  List<String> questions,
  BuildContext context,
) {
  return Container(
    margin: EdgeInsets.only(bottom: 24), // khoảng cách với phần dưới
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tiêu đề bên trong khung
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17,
              fontFamily: 'Inter',
            ),
          ),
        ),

        // Danh sách câu hỏi
        ...questions
            .asMap()
            .entries
            .map((entry) =>
                _buildQuestionTile(context, entry.value, isNew: entry.key == 0))
            .toList(),
      ],
    ),
  );
}

  Widget _buildQuestionTile(BuildContext context, String question, {bool isNew = false}) {
  return Column(
    children: [
      InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SupportAnswerPage(question: question),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              // Icon ?
              Container(
                margin: EdgeInsets.only(right: 12),
                child: Icon(Icons.help_outline, color: Colors.black),
              ),

              // Nội dung câu hỏi + badge nếu có
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        question.replaceAll(' 🆕', ''), // Xử lý nếu chuỗi có emoji cũ
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                        ),
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
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // Mũi tên
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
