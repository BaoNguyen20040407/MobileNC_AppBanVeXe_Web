import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:giao_dien_1/model/notification_admin_model.dart';
import 'package:giao_dien_1/config/default.dart';
import 'package:giao_dien_1/widget/appbar_profile_admin.dart';
import 'package:giao_dien_1/view/admin/profile_admin/notification/notification_admin_details.dart';

class NotificationAdminScreen extends StatefulWidget {
  const NotificationAdminScreen({super.key});

  @override
  State<NotificationAdminScreen> createState() => _NotificationAdminScreenState();
}

class _NotificationAdminScreenState extends State<NotificationAdminScreen> {
  List<TripAdminInfo> notifications = [];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    final String jsonString =
        await rootBundle.loadString('assets/data/notifications_admin.json');
    final List data = json.decode(jsonString);
    setState(() {
      notifications = data.map((e) => TripAdminInfo.fromJson(e)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softOrangeBackground,
      appBar: AppBarAdminProfile(title: 'THÔNG BÁO'),
      body: Container(
        color: const Color(0xFFFFF3E0),
        child: notifications.isEmpty
            ? const Center(child: Text('Không có thông báo nào'))
            : ListView.builder(
                padding: const EdgeInsets.all(24),
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final n = notifications[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 32),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.campaign, color: AppColors.black),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                n.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                  color: AppColors.greenDark,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Người gửi: ${n.sender}',
                          style: const TextStyle(fontSize: 14, fontFamily: 'Inter'),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Thời gian: ${n.time}',
                          style: const TextStyle(fontSize: 14, fontFamily: 'Inter'),
                        ),
                        const SizedBox(height: 8),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    NotificationAdminDetails(notification: n),
                              ),
                            );
                          },
                          child: const Text(
                            'Xem chi tiết thông báo',
                            style: TextStyle(
                              color: AppColors.mainOrange,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
