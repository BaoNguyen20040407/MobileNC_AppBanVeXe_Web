import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:giao_dien_1/widget/appbar_profile.dart';
import 'package:giao_dien_1/config/default.dart';
import 'package:giao_dien_1/config/config.dart';

class SupportAnswerPage extends StatefulWidget {
  final String maHT;

  const SupportAnswerPage({super.key, required this.maHT});

  @override
  _SupportAnswerPageState createState() => _SupportAnswerPageState();
}

class _SupportAnswerPageState extends State<SupportAnswerPage> {
  Map<String, dynamic>? supportData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSupportAnswer();
  }

  Future<void> _loadSupportAnswer() async {
    final url = Uri.parse('$baseURL/hotro/detail/${widget.maHT}');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json['success'] == true) {
          setState(() {
            supportData = json['data'];
            isLoading = false;
          });
        } else {
          throw Exception(json['message']);
        }
      } else {
        throw Exception("Lỗi server: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Lỗi khi tải dữ liệu hỗ trợ: $e");
      setState(() {
        supportData = {
          'CauHoi': '',
          'CauTraLoi': 'Xin lỗi, không thể tải được câu trả lời cho yêu cầu này.',
          'TieuDe': '',
        };
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softOrangeBackground,
      appBar: const AppBarProfile(title: 'HỖ TRỢ'),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.mainOrange))
          : supportData == null
              ? const Center(child: Text('Không tìm thấy dữ liệu hỗ trợ.'))
              : Padding(
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
                            const Center(
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

                            // Câu hỏi người dùng
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
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 2,
                                          offset: Offset(1, 2),
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      supportData!['CauHoi'] ?? '',
                                      style: const TextStyle(fontSize: 14, fontFamily: 'Inter'),
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

                            // Trả lời từ nhân viên
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
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 2,
                                          offset: Offset(1, 2),
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      supportData!['CauTraLoi'] ?? 'Chưa có câu trả lời.',
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
                                  'Thêm hỗ trợ',
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
                    ],
                  ),
                ),
    );
  }
}