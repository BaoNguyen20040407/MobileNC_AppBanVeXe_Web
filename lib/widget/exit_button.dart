import 'package:flutter/material.dart';
import 'package:giao_dien_1/config/default.dart';

class ExitButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const ExitButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      child: ElevatedButton.icon(
        onPressed: onPressed ?? () => Navigator.pop(context),
        icon: const Icon(Icons.exit_to_app, color: AppColors.mainOrange),
        label: const Text(
          'Thoát',
          style: TextStyle(
            color: AppColors.mainOrange,
            fontWeight: FontWeight.bold,
            fontSize: 14,
            fontFamily: 'Inter',
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
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
      ),
    );
  }
}
