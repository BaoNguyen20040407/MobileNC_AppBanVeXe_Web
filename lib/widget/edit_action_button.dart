import 'package:flutter/material.dart';
import 'package:giao_dien_1/config/default.dart';

class EditActionButton extends StatelessWidget {
  final VoidCallback onPressed;

  const EditActionButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.greenDark,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        side: const BorderSide(color: AppColors.greenDark, width: 1.2),
        elevation: 3,
        shadowColor: AppColors.greenDark.withOpacity(0.2),
      ).copyWith(
        overlayColor: MaterialStateProperty.all(Colors.transparent),
        surfaceTintColor: MaterialStateProperty.all(Colors.transparent),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.edit, color: Colors.white, size: 18),
          SizedBox(width: 6),
          Text(
            'Sửa',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }
}