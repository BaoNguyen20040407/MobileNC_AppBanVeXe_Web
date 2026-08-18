import 'package:flutter/material.dart';
import 'package:giao_dien_1/widget/input_field.dart';
import 'package:giao_dien_1/config/default.dart';

class LocationForm extends StatefulWidget {
  final bool isEdit;
  final String? initialType;
  final String? initialAddress;

  final void Function(String type, String address)? onSave;

  const LocationForm({
    super.key,
    this.isEdit = false,
    this.initialType,
    this.initialAddress,
    this.onSave,
  });

  @override
  State<LocationForm> createState() => _LocationFormState();
}

class _LocationFormState extends State<LocationForm> {
  late TextEditingController typeController;
  late TextEditingController addressController;

  @override
  void initState() {
    super.initState();

    typeController = TextEditingController(
      text: widget.initialType ?? '',
    );

    addressController = TextEditingController(
      text: widget.initialAddress ?? '',
    );
  }

  @override
  void dispose() {
    typeController.dispose();
    addressController.dispose();
    super.dispose();
  }

  void _handleSave() {
    final type = typeController.text.trim();
    final address = addressController.text.trim();

    if (type.isEmpty || address.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Vui lòng nhập đầy đủ loại địa điểm và địa chỉ',
            style: TextStyle(fontFamily: 'Inter'),
          ),
        ),
      );
      return;
    }

    widget.onSave?.call(type, address);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              widget.isEdit ? 'SỬA ĐỊA ĐIỂM' : 'THÊM ĐỊA ĐIỂM',
              style: const TextStyle(
                color: AppColors.greenDark,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Inter',
              ),
            ),
          ),

          const SizedBox(height: 20),

          // LOẠI ĐỊA ĐIỂM
          CustomInputField(
            controller: typeController,
            labelText: 'Loại địa điểm',
            prefixIcon: Icons.location_on,
            keyboardType: TextInputType.text,
            showToggleVisibility: false,
          ),

          const SizedBox(height: 24),

          // ĐỊA CHỈ
          CustomInputField(
            controller: addressController,
            labelText: 'Địa chỉ',
            prefixIcon: Icons.location_on,
            keyboardType: TextInputType.streetAddress,
            showToggleVisibility: false,
          ),

          const SizedBox(height: 24),

          Center(
            child: SizedBox(
              width: 156,
              height: 42,
              child: ElevatedButton(
                onPressed: _handleSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.mainOrange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                  ),
                ),
                child: Text(
                  widget.isEdit ? 'CẬP NHẬT' : 'LƯU',
                  style: const TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}