import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  Uint8List? _avatar;

  @override
  void initState() {
    super.initState();
    _loadAvatar();
  }

  Future<void> _loadAvatar() async {
    final prefs = await SharedPreferences.getInstance();
    final base64 = prefs.getString('image_base64');
    if (base64 != null && base64.isNotEmpty) {
      try {
        setState(() {
          _avatar = base64Decode(base64);
        });
      } catch (_) {
        setState(() {
          _avatar = null;
        });
      }
    } else {
      setState(() {
        _avatar = null;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadAvatar(); // Reload mỗi lần màn hình quay lại
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.preferredSize.height,
      padding: const EdgeInsets.only(top: 16, left: 24, right: 24),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(0)),
        image: DecorationImage(
          image: AssetImage(
            'assets/image/profile_appbar.png',
          ), 
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
              await Navigator.pushNamed(context, '/profile');
              _loadAvatar(); // Tải lại avatar sau khi quay lại
            },
            child: CircleAvatar(
              radius: 16,
              backgroundImage:
                  _avatar != null
                      ? MemoryImage(_avatar!)
                      : const AssetImage('assets/image/personicon.png')
                          as ImageProvider,
            ),
          ),
        ],
      ),
    );
  }
}
