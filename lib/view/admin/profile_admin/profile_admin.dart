import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:giao_dien_1/view/admin/profile_admin/location_admin/location_admin.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:giao_dien_1/config/default.dart';
import 'package:giao_dien_1/view/notification/notifications_screen.dart';
import 'package:giao_dien_1/view/auth/login_screen.dart';

class AdminProfileScreen extends StatefulWidget {
  const AdminProfileScreen({super.key});

  @override
  State<AdminProfileScreen> createState() => _AdminProfileScreenState();
}

class _AdminProfileScreenState extends State<AdminProfileScreen> {
  Uint8List? _avatarBytes;
  String _userName = 'Admin';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final base64 = prefs.getString('image_base64');
    final username = prefs.getString('username') ?? 'Admin';

    setState(() {
      _userName = username;
      _avatarBytes = (base64 != null && base64.isNotEmpty)
          ? base64Decode(base64)
          : null;
    });
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
                      'Số điện thoại',
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
          const SizedBox(height: 32),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
              children: [
                _buildMenuItem(
                  Icons.location_on_outlined,
                  "Địa chỉ của bạn",
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => LocationAdminScreen(),
                        settings: const RouteSettings(name: '/admin/locations'),
                      ),
                    );
                  },
                ),
                _buildMenuItem(
                  Icons.notifications_none,
                  "Thông báo",
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => NotificationsScreen(),
                        settings: const RouteSettings(name: '/admin/notifications'),
                      ),
                    );
                  },
                ),
                _buildMenuItem(
                  Icons.logout,
                  "Đăng xuất",
                  iconColor: Colors.red,
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