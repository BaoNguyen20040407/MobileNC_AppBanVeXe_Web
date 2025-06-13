import 'package:flutter/material.dart';
import 'package:giao_dien_1/config/default.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final Color color;
  final double fontSize;
  final double dividerThickness;

  const SectionTitle({
    Key? key,
    required this.title,
    this.color = AppColors.greenDark,
    this.fontSize = 24,
    this.dividerThickness = 5,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title.toUpperCase(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: fontSize,
            color: color,
            fontFamily: 'Inter',
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Divider(
            color: color,
            thickness: dividerThickness,
          ),
        ),
      ],
    );
  }
}