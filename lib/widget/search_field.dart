import 'package:flutter/material.dart';
import 'package:giao_dien_1/config/default.dart';

class CustomSearchField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onClear;
  final Function(String)? onChanged;
  final String hintText;

  const CustomSearchField({
    Key? key,
    required this.controller,
    required this.onClear,
    this.onChanged,
    this.hintText = 'Nhập từ khóa...',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(fontFamily: 'Inter'),
        suffixIcon: IconButton(
          icon: const Icon(Icons.clear),
          onPressed: onClear,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.mainOrange, width: 1.5),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.mainOrange, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      onChanged: onChanged,
    );
  }
}