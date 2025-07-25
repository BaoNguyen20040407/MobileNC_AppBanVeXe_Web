import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:giao_dien_1/config/default.dart';
import 'package:giao_dien_1/config/config.dart';
import 'package:giao_dien_1/view/admin/profile_admin/profile/profile_admin.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CustomAppBarAdmin extends StatefulWidget implements PreferredSizeWidget {
  final double height;
  final bool showProfileIcon;
  final VoidCallback? onProfileTap;

  const CustomAppBarAdmin({
    Key? key,
    this.height = 80,
    this.showProfileIcon = true,
    this.onProfileTap,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  State<CustomAppBarAdmin> createState() => _CustomAppBarAdminState();
}

class _CustomAppBarAdminState extends State<CustomAppBarAdmin> {
  String? _avatarUrl;

  @override
  void initState() {
    super.initState();
    _loadAvatarFromApi();
  }

  Future<void> _loadAvatarFromApi() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');
    if (username == null) return;

    final response = await http.get(Uri.parse('$baseURL/api/admin-info/$username'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success']) {
        final imagePath = data['data']['URLHinhAnh'];
        if (imagePath != null && imagePath.isNotEmpty) {
          setState(() {
            _avatarUrl = '$baseURL$imagePath';
          });
        }
      }
    } else {
      print('❌ Lỗi lấy avatar admin: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      color: AppColors.softOrange,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            "assets/image/namhailogo.png",
            height: 60,
            width: 60,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  "NHÀ XE NAM HẢI",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.greenDark,
                    fontFamily: 'Inter',
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  "Vì những chuyến xe an toàn cho bạn",
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.red,
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
          ),
          if (widget.showProfileIcon)
            GestureDetector(
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AdminProfileScreen(),
                    settings: const RouteSettings(name: '/profile_admin'),
                  ),
                );
                _loadAvatarFromApi(); // Reload sau khi sửa
              },
              child: ClipOval(
                child: _buildAvatar(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    const double size = 40;
    final placeholder = Image.asset(
      "assets/image/personicon.png",
      height: size,
      width: size,
      fit: BoxFit.cover,
    );

    if (_avatarUrl != null && _avatarUrl!.isNotEmpty) {
      return Image.network(
        _avatarUrl!,
        height: size,
        width: size,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => placeholder,
      );
    }

    return placeholder;
  }
}