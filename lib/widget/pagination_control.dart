import 'package:flutter/material.dart';
import 'package:giao_dien_1/config/default.dart';

class PaginationControls extends StatelessWidget {
  final int currentPage;
  final VoidCallback onFirstPressed;
  final VoidCallback onLastPressed;

  const PaginationControls({
    super.key,
    required this.currentPage,
    required this.onFirstPressed,
    required this.onLastPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: onFirstPressed,
          child: const Text(
            "Đầu",
            style: TextStyle(
              fontFamily: 'Inter',
              color: AppColors.black,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: AppColors.mainOrange,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            '$currentPage',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'Inter',
            ),
          ),
        ),
        TextButton(
          onPressed: onLastPressed,
          child: const Text(
            "Cuối",
            style: TextStyle(
              fontFamily: 'Inter',
              color: AppColors.black,
            ),
          ),
        ),
      ],
    );
  }
}
