import 'package:flutter/material.dart';
import 'package:giao_dien_1/config/default.dart';
import 'package:giao_dien_1/view/admin/home_admin/homeadmin.dart';
import 'package:giao_dien_1/widget/appbar_admin.dart';
import 'package:giao_dien_1/widget/admin_option_card.dart';
import 'package:giao_dien_1/widget/exit_button.dart';
import 'package:giao_dien_1/view/admin/trip_admin/trip_list.dart';
import 'package:giao_dien_1/view/admin/assignment_admin/assignment_list.dart';
import 'package:giao_dien_1/view/admin/stop_admin/stop_list.dart';

class ManageTripScreen extends StatelessWidget {
  ManageTripScreen({super.key});

  final List<Map<String, dynamic>> items = [
    {
      'title': 'Chuyến xe',
      'icon': Icons.directions_bus_filled,
      'route': TripList(),
    },
    {
      'title': 'Nhân sự',
      'icon': Icons.person_pin,
      'route': AssignmentList(),
    },
    {
      'title': 'Trạm dừng',
      'icon': Icons.stop_circle,
      'route': StopList(),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBarAdmin(),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
        child: Column(
          children: [
            const Text(
              'QUẢN LÝ CHUYẾN XE',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.mainOrange,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 32),

            /// ✅ GridView cho các tùy chọn
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                    if (item['route'] != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => item['route'] as Widget,
                          settings: RouteSettings(
                            name: '/${item['title'].toString().toLowerCase()}',
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${item['title']} đang được phát triển'),
                        ),
                      );
                    }
                  },
                );
              },
            ),

            const SizedBox(height: 32),

            /// ✅ Nút thoát về HomeAdmin
            ExitButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => HomeAdmin()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
