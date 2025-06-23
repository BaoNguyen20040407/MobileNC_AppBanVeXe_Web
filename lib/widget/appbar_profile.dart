import 'package:flutter/material.dart';

class AppBarProfile extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? avatarUrl;
  final VoidCallback? onBack;

  const AppBarProfile({
    super.key,
    required this.title,
    this.avatarUrl,
    this.onBack,
  });

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

          // Avatar → tự điều hướng về Profile
          GestureDetector(
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
              backgroundImage: avatarUrl != null && avatarUrl!.isNotEmpty
                  ? NetworkImage(avatarUrl!)
                  : const AssetImage('assets/image/personicon.png') as ImageProvider,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}
