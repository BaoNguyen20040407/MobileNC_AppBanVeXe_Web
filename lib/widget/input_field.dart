import 'package:flutter/material.dart';
import 'package:giao_dien_1/config/default.dart';

class CustomInputField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String? errorText;
  final String? hintText;
  final IconData prefixIcon;
  final bool obscureText;
  final VoidCallback? onToggleObscureText;
  final TextInputType keyboardType;
  final bool showToggleVisibility;
  final Function(String)? onChanged;
  final bool readOnly;
  final VoidCallback? onTap; 

  const CustomInputField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.prefixIcon,
    this.errorText,
    this.hintText,
    this.obscureText = false,
    this.onToggleObscureText,
    this.keyboardType = TextInputType.text,
    this.showToggleVisibility = false,
    this.onChanged,
    this.readOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      onChanged: onChanged,
      cursorColor: AppColors.mainOrange,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        labelStyle: const TextStyle(fontFamily: 'Inter'),
        errorText: errorText,
        errorStyle: const TextStyle(
          color: AppColors.red,
          fontSize: 12,
          fontFamily: 'Inter',
        ),
        errorMaxLines: 2,
        prefixIcon: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Icon(prefixIcon),
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 48, minHeight: 48),
        suffixIcon: showToggleVisibility
            ? IconButton(
                icon: Icon(
                  obscureText ? Icons.visibility_off : Icons.visibility,
                  color: AppColors.black,
                ),
                onPressed: onToggleObscureText,
              )
            : null,
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.mainOrange),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.mainOrange, width: 2.0),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.mainOrange),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.mainOrange, width: 2.0),
        ),
        hintStyle: TextStyle(color: AppColors.greyLight),
        floatingLabelStyle: const TextStyle(color: AppColors.black),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      ),
    );
  }
}
