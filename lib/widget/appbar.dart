import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:giao_dien_1/config/default.dart';
import 'package:giao_dien_1/view/profile/profile_screen.dart';
import 'dart:convert';
import 'dart:typed_data';

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
  String? _imageUrl;
  Uint8List? _avatarBytes;

  @override
  void initState() {
    super.initState();
    _loadImageUrl();
  }

  Future<void> _loadImageUrl() async {
  final prefs = await SharedPreferences.getInstance();
  final url = prefs.getString('image_url');
  final base64 = prefs.getString('image_base64');

  setState(() {
    _imageUrl = url;
    if (base64 != null && base64.isNotEmpty) {
      _avatarBytes = base64Decode(base64);
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
              onTap: widget.onProfileTap ??
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ProfileScreen(),
                        settings: const RouteSettings(name: '/profile'),
                      ),
                    );
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

  if (_avatarBytes != null) {
    return Image.memory(
      _avatarBytes!,
      height: 40,
      width: 40,
      fit: BoxFit.cover,
    );
  }

  if (_imageUrl != null &&
      _imageUrl!.isNotEmpty &&
      (_imageUrl!.startsWith("http") || _imageUrl!.startsWith("https"))) {
    return Image.network(
      _imageUrl!,
      height: 40,
      width: 40,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => placeholder,
    );
  }

  return placeholder;
}
}
