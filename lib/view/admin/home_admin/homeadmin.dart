import 'package:flutter/material.dart';
import 'package:giao_dien_1/view/admin/feedback_admin/feedback_list.dart';
import 'package:giao_dien_1/view/admin/support_admin/support_list.dart';
import 'package:giao_dien_1/widget/appbar.dart';
import 'package:giao_dien_1/config/default.dart';
import 'package:giao_dien_1/view/admin/home_admin/manage_people.dart';
import 'package:giao_dien_1/view/admin/home_admin/manage_station.dart';
import 'package:giao_dien_1/view/admin/home_admin/manage_trip.dart';
import 'package:giao_dien_1/widget/admin_option_card.dart';
import 'package:giao_dien_1/widget/appbar_admin.dart';

class HomeAdmin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final items = [
      {'title': 'Quản lý Người', 'icon': Icons.person, 'route': '/manage_people'},
      {'title': 'Quản lý Bến xe', 'icon': Icons.directions_bus, 'route': '/manage_station'},
      {'title': 'Quản lý Chuyến xe', 'icon': Icons.directions, 'route': '/manage_trip'},
      {'title': 'Quản lý Vé', 'icon': Icons.confirmation_number, 'route': '/'},
      {'title': 'Trả lời Hỗ trợ', 'icon': Icons.support_agent, 'route': '/support'},
      {'title': 'Trả lời Góp ý', 'icon': Icons.chat, 'route': '/feedback'},
    ];

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBarAdmin(),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
        child: GridView.builder(
          itemCount: items.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 32,
            mainAxisSpacing: 32,
            childAspectRatio: 1,
          ),
          itemBuilder: (context, index) {
            final item = items[index];

          return AdminOptionCard(
            icon: item['icon'] as IconData,
            title: item['title'] as String,
              onTap: () {
                // Điều hướng đúng màn hình
                switch (item['route']) {
                  case '/manage_people':
                    Navigator.push(context, MaterialPageRoute(builder: (_) => ManagePeopleScreen()));
                    break;
                  case '/manage_station':
                    Navigator.push(context, MaterialPageRoute(builder: (_) => ManageStationScreen()));
                    break;
                  case '/manage_trip':
                    Navigator.push(context, MaterialPageRoute(builder: (_) => ManageTripScreen()));
                    break;
                  case '/support':
                    Navigator.push(context, MaterialPageRoute(builder: (_) => SupportListScreen()));
                    break;
                  case '/feedback':
                    Navigator.push(context, MaterialPageRoute(builder: (_) => FeedbackListScreen()));
                    break;
                  default:
                    // Hiện thông báo placeholder
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Chức năng đang được phát triển')),
                    );
                }
              },
            );
          },
        ),
      ),
    );
  }
}