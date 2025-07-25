import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:giao_dien_1/config/default.dart';
import 'package:giao_dien_1/config/config.dart';
import 'package:giao_dien_1/view/admin/profile_admin/profile/profile_admin.dart';

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
  String? _imageUrl;
  Uint8List? _avatarBytes;

  @override
  void initState() {
    super.initState();
    _loadAvatar();
  }

  Future<void> _loadAvatar() async {
    final prefs = await SharedPreferences.getInstance();
    final base64 = prefs.getString('image_base64');
    final url = prefs.getString('avatarUrl'); // nên dùng key giống user

    setState(() {
      if (base64 != null && base64.isNotEmpty) {
        _avatarBytes = base64Decode(base64);
        _imageUrl = null;
      } else if (url != null && url.isNotEmpty) {
        _imageUrl = url.startsWith("http") ? url : '$baseURL$url';
      }
    });
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
                _loadAvatar(); // Refresh lại sau khi quay về
              },
              child: ClipOval(child: _buildAvatar()),
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

    if (_avatarBytes != null) {
      return Image.memory(
        _avatarBytes!,
        height: size,
        width: size,
        fit: BoxFit.cover,
      );
    }

    if (_imageUrl != null && _imageUrl!.isNotEmpty) {
      return Image.network(
        _imageUrl!,
        height: size,
        width: size,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => placeholder,
      );
    }

    return placeholder;
  }
}
