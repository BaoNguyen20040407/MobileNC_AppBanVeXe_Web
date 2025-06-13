import 'package:flutter/material.dart';
import 'package:giao_dien_1/config/default.dart';

class NewsHeader extends StatelessWidget {
  final String title;
  final String date;
  final String authors;
  final String imagePath;

  const NewsHeader({
    super.key,
    required this.title,
    required this.date,
    required this.authors,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Tiêu đề bài viết
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 19,
            fontWeight: FontWeight.bold,
            color: AppColors.black,
          ),
        ),
        const SizedBox(height: 8),

        /// Ngày đăng
        Text(
          'Ngày đăng: $date',
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            color: AppColors.black,
          ),
        ),
        const SizedBox(height: 4),

        /// Tác giả / người thực hiện
        Text(
          'Thực hiện: $authors',
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            color: AppColors.black,
          ),
        ),
        const SizedBox(height: 16),

        /// Hình ảnh đầu bài viết
        Container(
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withOpacity(0.15),
                offset: const Offset(0, 4),
                blurRadius: 4,
                spreadRadius: 1,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              imagePath,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
          ),
        ),

      ],
    );
  }
}