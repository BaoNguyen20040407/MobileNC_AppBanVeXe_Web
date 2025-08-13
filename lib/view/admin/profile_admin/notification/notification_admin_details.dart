import 'package:flutter/material.dart';
import 'package:giao_dien_1/config/default.dart';
import 'package:giao_dien_1/model/notification_admin_model.dart';
import 'package:giao_dien_1/widget/appbar_profile_admin.dart';

class NotificationAdminDetails extends StatelessWidget {
  final TripAdminInfo notification;

  const NotificationAdminDetails({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    final meeting = notification.meeting;

    return Scaffold(
      backgroundColor: AppColors.softOrangeBackground,
      appBar: AppBarAdminProfile(title: 'CHI TIẾT THÔNG BÁO'),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tiêu đề thông báo
                  Row(
                    children: [
                      const Icon(Icons.campaign, color: AppColors.black),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          notification.title,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: AppColors.greenDark,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Loại thông báo
                  const Text(
                    "THÔNG TIN BUỔI HỌP",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Inter',
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Nội dung chi tiết
                  if (meeting != null) ...[
                    _buildBulletText("Phòng ban: ${meeting.department}"),
                    _buildBulletText("Chủ đề: ${meeting.topic}"),
                    _buildBulletText("Mã cuộc họp: ${meeting.code}"),
                    _buildBulletText("Bắt đầu: ${meeting.start}"),
                    _buildBulletText("Kết thúc: ${meeting.end}"),
                    _buildBulletText("Địa điểm: ${meeting.location}"),
                  ] else
                    const Text(
                      "Thông báo này không chứa thông tin buổi họp.",
                      style: TextStyle(fontFamily: 'Inter', fontSize: 14),
                    ),
                ],
              ),
            ),
          ),

          const Spacer(),

          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Image.asset(
              'assets/image/hochiminhcity.png',
              height: 240,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildBulletText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("•  ", style: TextStyle(fontSize: 14)),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                fontFamily: 'Inter',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
