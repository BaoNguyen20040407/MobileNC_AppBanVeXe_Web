import 'package:flutter/material.dart';
import 'package:giao_dien_1/config/default.dart';
import 'package:giao_dien_1/view/profile/profile_screen.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
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
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
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
          if (showProfileIcon)
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => ProfileScreen()));
              },
              child: Image.asset(
                "assets/image/personicon.png",
                height: 32,
                width: 32,
              ),
            ),
        ],
      ),
    );
  }
}
