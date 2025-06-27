import 'package:flutter/material.dart';
import 'package:giao_dien_1/config/default.dart';
import 'package:giao_dien_1/view/auth/login_screen.dart';
import 'package:giao_dien_1/view/auth/confirm_email_screen.dart';
import 'package:giao_dien_1/view/support_and_feedback/support_and_feedback.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:giao_dien_1/view/profile/user_info.dart';
import 'package:giao_dien_1/view/ticket_history/ticket_history.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _url = '';
  String _userName = '';
  String _phone = '';
  Uint8List? _avatarBytes;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final pref = await SharedPreferences.getInstance();

    final url = pref.getString('image_url') ?? '';
    final base64 = pref.getString('image_base64');
    final username = pref.getString('username') ?? 'Người dùng';
    final phone = pref.getString('phone') ?? 'Chưa có số';

    setState(() {
      _url = url;
      _userName = username;
      _phone = phone;
      _avatarBytes = (base64 != null && base64.isNotEmpty)
          ? base64Decode(base64)
          : null;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E0),
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFFF5A562),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(0)),
            ),
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_ios, color: AppColors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const UserInfo(),
                        settings: const RouteSettings(name: '/info'),
                      ),
                    );
                  },
                  child: CircleAvatar(
                    radius: 32,
                      backgroundImage: _avatarBytes != null
                        ? MemoryImage(_avatarBytes!)
                        : const AssetImage('assets/image/personicon.png') as ImageProvider,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _userName,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Image(
                      image: AssetImage('assets/image/vietnam_flag.png'),
                      width: 25,
                      height: 17,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _phone,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
              children: [
                _buildMenuItem(
                  Icons.receipt_long,
                  "Lịch sử đặt vé",
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const UserInfo(),
                        settings: const RouteSettings(name: '/info'),
                      ),
                    ).then((_) {
                      _loadUserData(); // Load lại avatar và thông tin
                    });
                  },
                ),
                _buildMenuItem(
                  Icons.location_on_outlined,
                  "Địa chỉ của bạn",
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // TODO: Navigation
                  },
                ),
                _buildMenuItem(
                  Icons.lock_outline,
                  "Đổi mật khẩu",
                  trailing: null,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ConfirmEmailScreen(),
                        settings: const RouteSettings(name: '/change-password'),
                      ),
                    );
                  },
                ),
                _buildMenuItem(
                  Icons.notifications_none,
                  "Thông báo",
                  trailing: null,
                  onTap: () {
                    // TODO: Show notifications
                  },
                ),
                _buildMenuItem(
                  Icons.help_outline,
                  "Hỗ trợ/ góp ý",
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SupportAndFeedback(),
                        settings: const RouteSettings(name: '/support_and_feedback'),
                      ),
                    );
                  },
                ),
                _buildMenuItem(
                  Icons.logout,
                  "Đăng xuất",
                  iconColor: Colors.red,
                  trailing: null,
                  onTap: () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.clear();

                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const LoginScreen(),
                        settings: const RouteSettings(name: '/login'),
                      ),
                      (route) => false,
                    );
                  },
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Tạo 1 item menu chung
  Widget _buildMenuItem(
    IconData icon,
    String title, {
    Widget? trailing,
    Color? iconColor,
    VoidCallback? onTap,
  }) {
    return Card(
      elevation: 0.5,
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: iconColor ?? AppColors.black, size: 28),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }
}