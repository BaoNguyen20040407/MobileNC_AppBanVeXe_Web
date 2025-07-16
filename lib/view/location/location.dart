import 'package:flutter/material.dart';
import 'package:giao_dien_1/config/default.dart';
import 'package:giao_dien_1/widget/appbar_profile.dart';
import 'package:giao_dien_1/view/location/location_picker_screen.dart';

class LocationScreen extends StatelessWidget {
  const LocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softOrangeBackground,
      appBar: const AppBarProfile(title: 'ĐỊA CHỈ CỦA BẠN'),
      body: Column(
        children: [
          const SizedBox(height: 32),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _LocationItem(
                        icon: Icons.location_on,
                        label: 'Địa chỉ của bạn',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LocationPickerScreen(),
                              settings: const RouteSettings(name: '/location_picker'),
                            ),
                          );
                        },
                      ),
                      const Divider(height: 1),
                      _LocationItem(
                        icon: Icons.location_city,
                        label: 'Bến xe gần nhất',
                        onTap: () {
                          // TODO: Điều hướng đến màn bản đồ bến xe
                        },
                      ),
                      const Divider(height: 1),
                      _LocationItem(
                        icon: Icons.directions_bus,
                        label: 'Chuyến xe gần nhất',
                        onTap: () {
                          // TODO: Xử lý chuyến gần nhất
                        },
                      ),
                      const Divider(height: 1),
                      _LocationItem(
                        icon: Icons.train,
                        label: 'Kết nối METRO',
                        onTap: () {
                          // TODO: Xử lý kết nối Metro
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Center(
                  child: Image.asset(
                    'assets/image/bridge.png', // ảnh tượng trưng theo Figma
                    height: 300,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LocationItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _LocationItem({
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        leading: Icon(icon, color: Colors.black, size: 20),
        title: Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontFamily: 'Inter',
          ),
        ),
      ),
    );
  }
}
