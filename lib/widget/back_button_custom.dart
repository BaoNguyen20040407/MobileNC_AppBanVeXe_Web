import 'package:flutter/material.dart';
import 'package:giao_dien_1/config/default.dart';

class BackButtonCustom extends StatelessWidget {
  final VoidCallback onPressed;

  const BackButtonCustom({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.all(Colors.transparent),
        splashFactory: NoSplash.splashFactory,
      ),
      child: Row(
        children: const [
          Icon(Icons.arrow_back, size: 16, color: AppColors.greenDark),
          SizedBox(width: 4),
          Text(
            'Trở về',
            style: TextStyle(
              color: AppColors.greenDark,
              fontWeight: FontWeight.bold,
              fontFamily: 'Inter',
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}