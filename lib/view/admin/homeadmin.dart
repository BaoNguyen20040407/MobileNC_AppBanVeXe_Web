import 'package:flutter/material.dart';
import 'package:giao_dien_1/widget/appbar.dart';

class HomeAdmin extends StatelessWidget {
  Widget buildTile(BuildContext context, String title, IconData icon, String route) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Container(
        padding: EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 255, 255, 255),
          border: Border.all(color: Colors.orange),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.black),
            SizedBox(height: 4),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = [
      {'title': 'Quản lý Người', 'icon': Icons.person, 'route': '/manage_people'},
      {'title': 'Quản lý Bến xe', 'icon': Icons.directions_bus, 'route': '/manage_station'},
      {'title': 'Quản lý Chuyến xe', 'icon': Icons.directions, 'route': '/manage_trip'},
      {'title': 'Quản lý Vé', 'icon': Icons.confirmation_number, 'route': '/'},
      {'title': 'Trả lời Hỗ trợ', 'icon': Icons.support_agent, 'route': '/'},
      {'title': 'Trả lời Góp ý', 'icon': Icons.chat, 'route': '/'},
    ];

    return Scaffold(
      appBar: CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: GridView.builder( 
          itemCount: items.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 1, // Vuông đều
          ),
          itemBuilder: (context, index) {
            return buildTile(
              context,
              items[index]['title'] as String,
              items[index]['icon'] as IconData,
              items[index]['route'] as String,
            );
          },
        ),
      ),
    );
  }
}
