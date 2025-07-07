import 'package:flutter/material.dart';
import 'package:giao_dien_1/config/default.dart';
import 'package:giao_dien_1/widget/appbar.dart';

class ManageTripScreen extends StatelessWidget {
  final List<Map<String, dynamic>> items = [
    {'title': 'Chuyến xe', 'icon': Icons.directions_bus_filled},
    {'title': 'Nhân sự', 'icon': Icons.person_pin},
    {'title': 'Trạm dừng', 'icon': Icons.stop_circle},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          children: [
            SizedBox(height: 8),
            Text(
              'QUẢN LÝ CHUYẾN XE',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.mainOrange,
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1, // để ô vuông
                children: items.map((item) {
                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.mainOrange),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(item['icon'], size: 48, color: Colors.black),
                          SizedBox(height: 8),
                          Text(
                            item['title'],
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 12),
            SizedBox(
              width: 140,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.exit_to_app, color: AppColors.mainOrange),
                label: Text(
                  'Thoát',
                  style: TextStyle(color: AppColors.mainOrange),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: BorderSide(color: AppColors.mainOrange),
                  elevation: 3,
                  shadowColor: Colors.orange.shade100,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
