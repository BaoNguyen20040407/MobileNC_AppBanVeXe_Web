import 'package:flutter/material.dart';
import 'package:giao_dien_1/model/saved_location.dart';
import 'package:giao_dien_1/config/default.dart';

class SavedLocationItem extends StatelessWidget {
  final SavedLocation location;
  final VoidCallback? onDelete;
  final VoidCallback? onTap; 

  const SavedLocationItem({
    Key? key,
    required this.location,
    this.onDelete,
    this.onTap,
  }) : super(key: key);

  IconData _getLocationIcon() {
    switch (location.type.toLowerCase()) {
      case 'nhà':
        return Icons.home; 

      case 'công ty':
        return Icons.business;

      case 'trường':
        return Icons.school; 

      case 'cửa hàng':
        return Icons.store;

      default:
        return Icons.location_on;   
    }
  }

  @override
  Widget build (BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.mainOrange
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Icon loại địa điểm
            Icon(
              _getLocationIcon(),
              color: AppColors.mainOrange,
              size: 24,
            ),

            const SizedBox(width: 8),

            //Tên + địa chỉ
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Tên
                  Text(
                    location.type,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),

                  //Địa chỉ
                  Text(
                    location.address ?? 'Chưa có địa chỉ',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      color: AppColors.black,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            //Xóa
            IconButton(
              onPressed: onDelete,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(
                minWidth: 32,
                minHeight: 32,
              ),
              icon: const Icon(
                Icons.close,
                color: AppColors.black,
                size: 20,
              ),
            ),
          ],
        )
      )
    );
  }
}