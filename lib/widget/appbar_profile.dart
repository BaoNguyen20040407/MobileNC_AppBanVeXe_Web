import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:giao_dien_1/view/profile/profile_screen.dart';
import 'package:giao_dien_1/config/config.dart'; // chứa baseURL

class AppBarProfile extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBack;

  const AppBarProfile({super.key, required this.title, this.onBack});

  @override
  State<AppBarProfile> createState() => _AppBarProfileState();

  @override
  Size get preferredSize => const Size.fromHeight(80);
}

class _AppBarProfileState extends State<AppBarProfile> {
  String? _imageUrl;
  Uint8List? _avatarBytes;

  @override
  void initState() {
    super.initState();
    _loadAvatar();
  }

  Future<void> _loadAvatar() async {
    final prefs = await SharedPreferences.getInstance();
    final url = prefs.getString('avatarUrl'); // e.g. /uploads/abc.jpg
    final base64 = prefs.getString('image_base64');

    setState(() {
      if (url != null && url.isNotEmpty) {
        _imageUrl = '$baseURL$url';
      }
      if (base64 != null && base64.isNotEmpty) {
        _avatarBytes = base64Decode(base64);
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadAvatar(); // Reload mỗi lần build lại
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.preferredSize.height,
      padding: const EdgeInsets.only(top: 16, left: 24, right: 24),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(0)),
        image: DecorationImage(
          image: AssetImage('assets/image/profile_appbar.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Nút quay lại
          GestureDetector(
            onTap: widget.onBack ?? () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back_ios, color: Colors.white),
          ),

          // Tiêu đề
          Text(
            widget.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.bold,
              fontFamily: 'Inter',
            ),
          ),

          // Avatar
          GestureDetector(
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
              _loadAvatar(); // Cập nhật lại sau khi quay về
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
    const placeholder = AssetImage('assets/image/personicon.png');

    if (_avatarBytes != null) {
      return Image.memory(
        _avatarBytes!,
        height: 32,
        width: 32,
        fit: BoxFit.cover,
      );
    }

    if (_imageUrl != null &&
        _imageUrl!.isNotEmpty &&
        (_imageUrl!.startsWith("http") || _imageUrl!.startsWith("https"))) {
      return Image.network(
        _imageUrl!,
        height: 32,
        width: 32,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Image(
          image: placeholder,
          height: 32,
          width: 32,
          fit: BoxFit.cover,
        ),
      );
    }

    return Image(
      image: placeholder,
      height: 32,
      width: 32,
      fit: BoxFit.cover,
    );
  }
}
