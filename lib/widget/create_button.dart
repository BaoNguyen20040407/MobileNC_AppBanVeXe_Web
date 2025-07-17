import 'package:flutter/material.dart';
import 'package:giao_dien_1/config/default.dart';

class CreateButton extends StatelessWidget {
  final VoidCallback onPressed;

  const CreateButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.add, color: Colors.white),
      label: const Text(
        'Tạo mới',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 14,
          fontFamily: 'Inter',
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.mainOrange,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        side: const BorderSide(color: AppColors.mainOrange, width: 1.2),
        elevation: 3,
        shadowColor: AppColors.mainOrange.withOpacity(0.2),
      ).copyWith(
        overlayColor: MaterialStateProperty.all(Colors.transparent),
        surfaceTintColor: MaterialStateProperty.all(Colors.transparent),
      ),
    );
  }
}