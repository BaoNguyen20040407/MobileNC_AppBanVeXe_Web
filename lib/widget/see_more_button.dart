import 'package:flutter/material.dart';
import 'package:giao_dien_1/config/default.dart';

class SeeMoreButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SeeMoreButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: TextButton(
        onPressed: onPressed,
        style: ButtonStyle(
          overlayColor: MaterialStateProperty.all(Colors.transparent),
          splashFactory: NoSplash.splashFactory,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text(
              'Xem tiếp  ',
              style: TextStyle(
                color: AppColors.greenDark,
                fontWeight: FontWeight.bold,
                fontFamily: 'Inter',
                fontSize: 14,
              ),
            ),
            Icon(Icons.arrow_forward, size: 16, color: AppColors.greenDark),
          ],
        ),
      ),
    );
  }
}
