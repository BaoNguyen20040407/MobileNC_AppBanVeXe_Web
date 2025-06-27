import 'package:flutter/material.dart';
import 'package:giao_dien_1/widget/appbar_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:giao_dien_1/config/default.dart';

class SupportAndFeedback extends StatefulWidget {
  const SupportAndFeedback({super.key});

  @override
  State<SupportAndFeedback> createState() => _HotrogopyState();
}

class _HotrogopyState extends State<SupportAndFeedback> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E0),
      appBar: const AppBarProfile(title: 'HỖ TRỢ/GÓP Ý '),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Khung hỗ trợ / góp ý
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.support_agent),
                      title: const Text('Hỗ trợ'),
                      onTap: () {
                        // TODO: Chuyển sang trang Hỗ trợ
                      },
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.chat_bubble_outline),
                      title: const Text('Góp ý'),
                      onTap: () {
                        // TODO: Chuyển sang trang Góp ý
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Thông tin liên hệ
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Thông tin liên hệ',
                      style: TextStyle(
                        color: AppColors.red,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Inter'
                      ),
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'CÔNG TY CỔ PHẦN\nXE KHÁCH NAM HẢI',
                        textAlign: TextAlign.center, // canh giữa 2 dòng trong text
                        style: TextStyle(
                          color: AppColors.greenDark,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Địa chỉ: ',
                            style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Inter'),
                          ),
                          TextSpan(
                            text:
                                '458 Trường Chinh, Phường 13, Quận Tân Bình, TP. Hồ Chí Minh',
                                style: TextStyle(fontFamily: 'Inter'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Email: ',
                            style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Inter'),
                          ),
                          TextSpan(text: 'xekhachnamhai@gmail.com', style: TextStyle(fontFamily: 'Inter')),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Điện thoại: ',
                            style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Inter'),
                          ),
                          TextSpan(text: '02843512123', style: TextStyle(fontFamily: 'Inter')),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Fax: ',
                            style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Inter'),
                          ),
                          TextSpan(text: '02843512124', style: TextStyle(fontFamily: 'Inter')),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Text(
                          'KẾT NỐI VỚI CHÚNG TÔI',
                          style: TextStyle(
                            color: AppColors.greenDark,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Inter',
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Image.network(
                          "https://img.icons8.com/?size=100&id=118497&format=png&color=000000", // Facebook
                          width: 32,
                          height: 32,
                        ),
                        const SizedBox(width: 12),
                        Image.network(
                          "https://img.icons8.com/?size=100&id=Xy10Jcu1L2Su&format=png&color=000000", // Instagram
                          width: 32,
                          height: 32,
                        ),
                        const SizedBox(width: 12),
                        Image.network(
                          "https://img.icons8.com/?size=100&id=0m71tmRjlxEe&format=png&color=000000", // Zalo
                          width: 32,
                          height: 32,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
