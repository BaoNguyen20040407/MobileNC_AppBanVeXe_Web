import 'package:flutter/material.dart';
import 'package:giao_dien_1/config/default.dart';
import 'package:giao_dien_1/widget/appbar_profile.dart';
import 'package:giao_dien_1/model/saved_location.dart';
import 'package:giao_dien_1/widget/saved_location_item.dart';

class SavedLocationsScreen extends StatelessWidget {
  final List<SavedLocation> locations;

  const SavedLocationsScreen({
    Key? key,
    required this.locations,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softOrangeBackground,

      appBar: const AppBarProfile(
        title: 'ĐỊA ĐIỂM ĐÃ LƯU',
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            24,
            32,
            24,
            32,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==================================================
              // DANH SÁCH ĐỊA ĐIỂM
              // ==================================================

              if (locations.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 24,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.orange,
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'Chưa có địa điểm nào được lưu.',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        color: Colors.grey,
                      ),
                    ),
                  ),
                )
              else
                ...locations.map(
                  (location) {
                    return Padding(
                      padding: const EdgeInsets.only(
                        bottom: 12,
                      ),
                      child: SavedLocationItem(
                        location: location,
                        onDelete: () {
                          // TODO: Xóa địa điểm
                        },
                        onTap: () {
                          // TODO: Chọn địa điểm
                        },
                      ),
                    );
                  },
                ),

              const SizedBox(height: 16),

              // ==================================================
              // HÌNH BÊN DƯỚI
              // ==================================================

              Center(
                child: Image.asset(
                  'assets/image/snapedit_1746841417483.png',
                  height: 300,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}