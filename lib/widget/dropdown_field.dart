import 'package:flutter/material.dart';
import 'package:giao_dien_1/config/default.dart';

class CustomDropdownField extends StatelessWidget {
  final String? value;
  final List<String> items;
  final String labelText;
  final IconData prefixIcon;
  final void Function(String?) onChanged;

  const CustomDropdownField({
    super.key,
    required this.value,
    required this.items,
    required this.labelText,
    required this.prefixIcon,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(fontFamily: 'Inter', color: Colors.black),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Icon(prefixIcon),
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.fromLTRB(20, 16, 16, 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: AppColors.mainOrange),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: AppColors.mainOrange),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: AppColors.mainOrange),
        ),
      ),
      icon: const Icon(Icons.arrow_drop_down),
      items: items.map((item) => DropdownMenuItem<String>(
        value: item,
        child: Text(item, style: const TextStyle(fontFamily: 'Inter')),
      )).toList(),
      onChanged: onChanged,
    );
  }
}