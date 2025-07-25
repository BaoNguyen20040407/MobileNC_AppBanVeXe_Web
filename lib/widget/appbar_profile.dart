import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:giao_dien_1/view/profile/profile_screen.dart';
import 'package:giao_dien_1/config/config.dart'; // chứa baseURL
import 'package:http/http.dart' as http;

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

    try {
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
        print('⚠️ Lỗi khi gọi API avatar: ${response.body}');
      }
    } catch (e) {
      print('❌ Exception khi gọi API avatar: $e');
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadAvatarFromApi(); // Reload khi quay lại trang này
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
              _loadAvatarFromApi(); // Refresh sau khi quay lại
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

    if (_avatarUrl != null &&
        _avatarUrl!.isNotEmpty &&
        (_avatarUrl!.startsWith("http") || _avatarUrl!.startsWith("https"))) {
      return Image.network(
        _avatarUrl!,
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
