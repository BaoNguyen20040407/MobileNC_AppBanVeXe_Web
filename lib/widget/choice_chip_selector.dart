import 'package:flutter/material.dart';
import 'package:giao_dien_1/config/default.dart'; 

class ChoiceChipSelector extends StatelessWidget {
  final String label;
  final String value;
  final String selectedValue;
  final ValueChanged<String> onSelected;

  const ChoiceChipSelector({
    super.key,
    required this.label,
    required this.value,
    required this.selectedValue,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSelected = selectedValue == value;

    return ChoiceChip(
      label: Text(label, style: const TextStyle(fontFamily: 'Inter')),
      selected: isSelected,
      onSelected: (_) => onSelected(value),
      selectedColor: AppColors.mainOrange,
      backgroundColor: Colors.white,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.black87,
        fontWeight: FontWeight.bold,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: AppColors.mainOrange),
      ),
    );
  }
}
