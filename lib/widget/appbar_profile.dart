import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppBarProfile extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBack;

  const AppBarProfile({
    super.key,
    required this.title,
    this.onBack,
  });

  Future<Uint8List?> _loadAvatar() async {
    final prefs = await SharedPreferences.getInstance();
    final base64 = prefs.getString('image_base64');
    if (base64 != null && base64.isNotEmpty) {
      return base64Decode(base64);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height,
      padding: const EdgeInsets.only(top: 16, left: 24, right: 24),
      decoration: const BoxDecoration(
        color: Color(0xFFF5A562),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Nút quay lại
          GestureDetector(
            onTap: onBack ?? () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back_ios, color: Colors.white),
          ),

          // Tiêu đề
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.bold,
              fontFamily: 'Inter',
            ),
          ),

          // Avatar
          FutureBuilder<Uint8List?>(
            future: _loadAvatar(),
            builder: (context, snapshot) {
              final imageProvider = (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData &&
                      snapshot.data != null)
                  ? MemoryImage(snapshot.data!)
                  : const AssetImage('assets/image/personicon.png') as ImageProvider;

              return GestureDetector(
                onTap: () {
                  Future.delayed(const Duration(milliseconds: 50), () {
                    if (context.mounted) {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/profile',
                        (route) => false,
                      );
                    }
                  });
                },
                child: CircleAvatar(
                  radius: 16,
                  backgroundImage: imageProvider,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}
