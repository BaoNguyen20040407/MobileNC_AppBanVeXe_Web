import 'package:flutter/material.dart';
import 'package:giao_dien_1/config/default.dart';

class FeedbackAndSupportWidget extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController contentController;
  final VoidCallback onSubmit;
  final String formTitle;
  final String titleHint;
  final String contentHint;

  const FeedbackAndSupportWidget({
    super.key,
    required this.titleController,
    required this.contentController,
    required this.onSubmit,
    required this.formTitle,
    required this.titleHint,
    required this.contentHint,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.mainOrange, width: 5),
        boxShadow: [
          BoxShadow(
            color: AppColors.mainOrange,
            offset: const Offset(0, 0),
            blurRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            formTitle,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: AppColors.black,
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: titleController,
            cursorColor: AppColors.mainOrange,
            decoration: _buildInputDecoration(titleHint),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: contentController,
            maxLines: 4,
            cursorColor: AppColors.mainOrange,
            decoration: _buildInputDecoration(contentHint),
          ),
          const SizedBox(height: 16),
          Center(
            child: ElevatedButton(
              onPressed: onSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.mainOrange,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
              ),
              child: const Text(
                'Gửi',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  fontFamily: 'Inter',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static InputDecoration _buildInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: AppColors.greyLight,
        fontFamily: 'Inter',
        fontSize: 14,
      ),
      filled: true,
      fillColor: Colors.white,
      hoverColor: Colors.transparent,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.greyLight),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.greyLight),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.greyLight),
      ),
    );
  }
}
