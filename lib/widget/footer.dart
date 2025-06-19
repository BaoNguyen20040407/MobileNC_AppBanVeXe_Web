import 'package:flutter/material.dart';
import 'package:giao_dien_1/view/main/homepage.dart';
import 'package:giao_dien_1/view/news/news.dart';
import 'package:giao_dien_1/config/default.dart';

class FooterNavigation extends StatelessWidget {
  const FooterNavigation({super.key});

  int _getCurrentIndex(BuildContext context) {
    final current = ModalRoute.of(context)?.settings.name;

    if (current == '/news') return 3;
    if (current == '/home') return 0;

    // Default
    return -1;
  }

  void _navigateTo(int index, BuildContext context) {
    Widget nextPage;
    String routeName;

    switch (index) {
      case 0:
        nextPage = HomePage();
        routeName = '/home';
        break;
      case 3:
        nextPage = const News();
        routeName = '/news';
        break;
      default:
        return;
    }

    // Không push nếu đã ở trang đó
    if (ModalRoute.of(context)?.settings.name == routeName) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => nextPage,
        settings: RouteSettings(name: routeName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _getCurrentIndex(context);

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0xFFD9D9D9),
            offset: Offset(0, -5),
            blurRadius: 4,
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _bottomNavItem(context, "Trang chủ", Icons.home, 0, selectedIndex),
          _bottomNavItem(context, "Lịch trình", Icons.event_note, 1, selectedIndex),
          _bottomNavItem(context, "Tra cứu vé", Icons.confirmation_number, 2, selectedIndex),
          _bottomNavItem(context, "Tin tức", Icons.article, 3, selectedIndex),
        ],
      ),
    );
  }

  Widget _bottomNavItem(
    BuildContext context,
    String title,
    IconData icon,
    int index,
    int selectedIndex,
  ) {
    final isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () => _navigateTo(index, context),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 32,
            color: isSelected ? AppColors.mainOrange : AppColors.greyLight,
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Inter',
              color: AppColors.black,
            ),
          ),
        ],
      ),
    );
  }
}
