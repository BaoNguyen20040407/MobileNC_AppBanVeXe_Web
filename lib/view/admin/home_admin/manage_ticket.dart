import 'package:flutter/material.dart';
import 'package:giao_dien_1/config/default.dart';
import 'package:giao_dien_1/view/admin/home_admin/homeadmin.dart';
import 'package:giao_dien_1/view/admin/ticket_admin/qr_scan.dart';
import 'package:giao_dien_1/view/admin/ticket_admin/ticket_list.dart';
import 'package:giao_dien_1/widget/admin_option_card.dart';
import 'package:giao_dien_1/widget/exit_button.dart';
import 'package:giao_dien_1/widget/appbar_admin.dart';

class ManageTicketScreen extends StatelessWidget {
  final List<Map<String, dynamic>> items = [
    {
      'title': 'Quản lý vé', 
      'icon': Icons.confirmation_number,
      'route': TicketListScreen(),
    },
    {
      'title': 'Quét vé', 
      'icon': Icons.qr_code_scanner,
      'route': QRScanFromImageScreen(),
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
              'QUẢN LÝ VÉ',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.mainOrange,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 32),

            /// ✅ Grid không dùng Expanded
            GridView.builder(
              shrinkWrap: true, // Giúp GridView chiếm chiều cao đúng
              physics: const NeverScrollableScrollPhysics(), // Không cuộn
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
                          builder: (_) => item['route'],
                          settings: RouteSettings(name: '/${item['title'].toString().toLowerCase()}'),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${item['title']} đang được phát triển')),
                      );
                    }
                  },
                );
              },
            ),

            const SizedBox(height: 32), // Khoảng cách rõ ràng trước nút

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