import 'package:flutter/material.dart';
import 'package:giao_dien_1/widget/appbar_profile.dart';

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
      backgroundColor: Color(0xFFFDF1E6),
      appBar: AppBarProfile(title: 'HỖ TRỢ'),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Color(0xFFFF7043), width: 5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orange.shade100,
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
                          'Hỗ Trợ',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF000000),
                          ),
                        ),
                      ),
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Nhập tiêu đề...',
                          filled: true,
                          fillColor: Color(0xFFF6F6F6),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                      TextField(
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText: 'Nhập nội dung câu hỏi...',
                          filled: true,
                          fillColor: Color(0xFFF6F6F6),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      SizedBox(height: 40),
                    ],
                  ),
                ),
                Positioned(
                  bottom: -16,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFFF5722),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        elevation: 4,
                        shadowColor: Colors.orangeAccent,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        print('Button pressed');
                      },
                      child: Text('Gửi', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 40),
            _buildSection('CÂU HỎI PHỔ BIẾN', [
              'Làm sao để đổi vé? 🆕',
              'Tôi quên mật khẩu?',
              'Nhà xe có hỗ trợ đổi lịch?',
              'Có thể hoàn tiền vé không?',
              'Tôi không nhận được vé điện tử?',
            ]),
            SizedBox(height: 16),
            _buildSection('CÂU HỎI CỦA TÔI', [
              'Mang được mấy ký hành lý? 💬',
              'Đổi vé thế nào?',
              'Làm sao để đổi hoặc huỷ vé đã đặt?',
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<String> questions) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: questions.map((q) => _buildQuestionTile(q)).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionTile(String question) {
    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              // TODO: Navigate to detailed Q&A page
              print('Tapped on: \$question');
            },
            splashColor: Colors.black26,
            highlightColor: Colors.black12,
            child: ListTile(
              title: Text(question),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
              dense: true,
              visualDensity: VisualDensity.compact,
            ),
          ),
        ),
        Divider(height: 1, thickness: 0.5, color: Colors.black12),
      ],
    );
  }
}
