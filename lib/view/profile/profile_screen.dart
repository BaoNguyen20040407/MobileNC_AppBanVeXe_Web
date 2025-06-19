import 'package:flutter/material.dart';
import 'package:giao_dien_1/config/default.dart';
import 'package:giao_dien_1/view/auth/login_screen.dart';
import 'package:giao_dien_1/view/auth/confirm_email_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
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
                const SizedBox(height: 16),
                const CircleAvatar(
                  radius: 32,
                  backgroundImage: AssetImage('assets/image/personicon.png'),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Bao Nguyen',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Image(
                      image: AssetImage('assets/image/vietnam_flag.png'),
                      width: 25,
                      height: 17,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(width: 8),
                    Text(
                      '0765178079',
                      style: TextStyle(
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
                    // TODO: Navigation
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
                    // TODO: Open support screen
                  },
                ),
                _buildMenuItem(
                  Icons.logout,
                  "Đăng xuất",
                  iconColor: Colors.red,
                  trailing: null,
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (_) => LoginScreen(),
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