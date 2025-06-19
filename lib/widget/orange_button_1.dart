import 'package:flutter/material.dart';

class OrangeButton1 extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const OrangeButton1({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFF5722),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 4,
          minimumSize: const Size(double.infinity, 48),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 17,
            color: Colors.white,
            fontFamily: 'Inter',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
