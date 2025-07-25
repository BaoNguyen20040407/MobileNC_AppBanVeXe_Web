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
import 'package:giao_dien_1/view/notification/notifications_screen.dart';
import 'package:giao_dien_1/view/location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:giao_dien_1/config/config.dart';
import 'package:http/http.dart' as http;

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
  final prefs = await SharedPreferences.getInstance();
  final username = prefs.getString('username');
  if (username == null) return;

  final url = Uri.parse('$baseURL/user-info/$username');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    if (data['success']) {
      final user = data['data'];
      final imageUrl = user['URLHinhAnh'];
      setState(() {
        _userName = username;
        _phone = user['SDT'] ?? 'Chưa có số';
        _url = (imageUrl != null && imageUrl.isNotEmpty)
            ? '$baseURL$imageUrl'
            : '';
      });
    }
  } else {
    print('❌ Lỗi khi gọi API user-info: ${response.body}');
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softOrangeBackground,
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: AppColors.profileHeaderOrange,
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
                      backgroundImage: _url.isNotEmpty
                        ? NetworkImage(_url)
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
                        builder: (_) => TicketHistoryPage(),
                        settings: const RouteSettings(name: '/ticket_history'),
                      ),
                    );
                  },
                ),
                _buildMenuItem(
                  Icons.location_on_outlined,
                  "Địa chỉ của bạn",
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const LocationScreen(), 
                        settings: const RouteSettings(name: '/location'),
                      ),
                    );

                    if (result != null && result is LatLng) {
                      print('Địa chỉ đã chọn: ${result.latitude}, ${result.longitude}');
                      // TODO: xử lý lưu hoặc hiển thị địa chỉ
                    }
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => NotificationsScreen(),
                        settings: const RouteSettings(name: '/notification'),
                      ),
                    );
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