import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:giao_dien_1/config/default.dart';
import 'package:giao_dien_1/view/profile/profile_screen.dart';
import 'package:giao_dien_1/config/config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final double height;
  final bool showProfileIcon;
  final VoidCallback? onProfileTap;

  const CustomAppBar({
    Key? key,
    this.height = 80,
    this.showProfileIcon = true,
    this.onProfileTap,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
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

    final url = Uri.parse('$baseURL/user-info/$username');
    final response = await http.get(url);

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
      print('❌ Lỗi lấy ảnh avatar: ${response.body}');
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
                    builder: (_) => const ProfileScreen(),
                    settings: const RouteSettings(name: '/profile'),
                  ),
                );
                _loadAvatarFromApi(); // reload lại ảnh nếu có thay đổi
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
    final placeholder = Image.asset(
      "assets/image/personicon.png",
      height: 40,
      width: 40,
      fit: BoxFit.cover,
    );

    if (_avatarUrl != null &&
        _avatarUrl!.isNotEmpty &&
        (_avatarUrl!.startsWith("http") || _avatarUrl!.startsWith("https"))) {
      return Image.network(
        _avatarUrl!,
        height: 40,
        width: 40,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => placeholder,
      );
    }

    return placeholder;
  }
}