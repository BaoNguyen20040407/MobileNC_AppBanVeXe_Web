import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:giao_dien_1/config/config.dart';
import 'package:giao_dien_1/view/admin/profile_admin/profile/profile_admin.dart';
import 'package:http/http.dart' as http;

class AppBarAdminProfile extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBack;

  const AppBarAdminProfile({super.key, required this.title, this.onBack});

  @override
  State<AppBarAdminProfile> createState() => _AppBarAdminProfileState();

  @override
  Size get preferredSize => const Size.fromHeight(80);
}

class _AppBarAdminProfileState extends State<AppBarAdminProfile> {
  String? _avatarUrl;

  @override
  void initState() {
    super.initState();
    _loadAvatarFromApi();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadAvatarFromApi(); // reload mỗi lần quay lại
  }

  Future<void> _loadAvatarFromApi() async {
  final prefs = await SharedPreferences.getInstance();
  final username = prefs.getString('username');
  print('👤 Username lưu trong prefs: $username');

  if (username == null) return;

  try {
    final response = await http.get(Uri.parse('$baseURL/api/admin-info/$username'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success']) {
        final imagePath = data['data']['URLHinhAnh'];
        if (imagePath != null && imagePath.isNotEmpty) {
          setState(() {
          _avatarUrl = imagePath.startsWith('http')
              ? imagePath
              : '$baseURL/$imagePath'.replaceAll('//', '/').replaceFirst(':/', '://');
          });
        }
      } else {
        print('❗ API trả về false: ${data['message']}');
      }
    } else {
      print('❌ API lỗi HTTP: ${response.statusCode}');
    }
  } catch (e) {
    print('❌ Ngoại lệ: $e');
  }
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
          GestureDetector(
            onTap: widget.onBack ?? () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back_ios, color: Colors.white),
          ),
          Text(
            widget.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.bold,
              fontFamily: 'Inter',
            ),
          ),
          GestureDetector(
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AdminProfileScreen()),
              );
              _loadAvatarFromApi(); // cập nhật lại avatar
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
    const double size = 32;
    const placeholder = AssetImage('assets/image/personicon.png');

    if (_avatarUrl != null && _avatarUrl!.isNotEmpty) {
      return Image.network(
        _avatarUrl!,
        height: size,
        width: size,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Image(image: placeholder, height: size, width: size, fit: BoxFit.cover),
      );
    }

    return Image(image: placeholder, height: size, width: size, fit: BoxFit.cover);
  }
}
