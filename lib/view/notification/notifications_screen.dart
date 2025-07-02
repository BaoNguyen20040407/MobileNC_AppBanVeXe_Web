import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:giao_dien_1/model/notification_model.dart';
import 'package:giao_dien_1/view/notification/notification_detail_screen.dart';
import 'package:giao_dien_1/widget/appbar_profile.dart';
import 'package:giao_dien_1/config/default.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<AppNotification> notifications = [];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    final String jsonString = await rootBundle.loadString('assets/data/notifications.json');
    final List data = json.decode(jsonString);
    setState(() {
      notifications = data.map((e) => AppNotification.fromJson(e)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softOrangeBackground,
      appBar: AppBarProfile(title: 'THÔNG BÁO'),
      body: Container(
        color: const Color(0xFFFFF3E0), // Nền cam nhạt
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
                            const Icon(Icons.campaign, color: AppColors.black,),
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
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Thời gian: ${n.time}',
                          style: const TextStyle(fontSize: 14, fontFamily: 'Inter'),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => NotificationDetailScreen(notification: n),
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
