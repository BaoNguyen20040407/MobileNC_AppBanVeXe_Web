import 'package:flutter/material.dart';
import 'package:giao_dien_1/config/default.dart';
import 'package:giao_dien_1/model/notification_model.dart';
import 'package:giao_dien_1/widget/appbar_profile.dart';

class NotificationDetailScreen extends StatelessWidget {
  final AppNotification notification;

  const NotificationDetailScreen({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    final trip = notification.trip;

    return Scaffold(
      backgroundColor: AppColors.softOrangeBackground,
      appBar: AppBarProfile(title: 'CHI TIẾT THÔNG BÁO'),
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
                  Row(
                    children: [
                      const Icon(Icons.campaign, color: AppColors.black),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${notification.title}',
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
                  const Text(
                    "VÉ XE ĐƯỢC ĐẶT THÀNH CÔNG",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Inter',
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (trip != null) ...[
                    const Text(
                      "Thông tin chuyến đi:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 4),
                    _buildBulletText("Tuyến: ${trip.from} → ${trip.to}"),
                    _buildBulletText("Xe: ${trip.seat}"),
                    _buildBulletText("Mã vé: ${trip.code}"),
                    _buildBulletText("Thời gian đi: ${trip.departure}"),
                    _buildBulletText("Thời gian có mặt: ${trip.arrival}"),
                    const SizedBox(height: 8),
                    const Text(
                      "Chúc quý khách có chuyến đi vui vẻ, an toàn.",
                      style: TextStyle(fontFamily: 'Inter', fontSize: 14),
                    ),
                  ] else
                    const Text(
                      "Thông báo này không chứa thông tin chuyến đi.",
                      style: TextStyle(fontFamily: 'Inter', fontSize: 14),
                    ),
                ],
              ),
            ),
          ),

          // Spacer để đẩy hình ảnh xuống cuối
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
