import 'package:flutter/material.dart';

class LocationForm extends StatefulWidget {
  final bool isEdit;
  final String? initialType;
  final String? initialAddress;
  final VoidCallback? onSave;

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
                color: Colors.green,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'Loại địa điểm',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          TextField(
            controller: typeController,
            decoration: InputDecoration(
              hintText: 'Nhập loại địa điểm. VD: Nhà, Công ty...',
              prefixIcon: const Icon(Icons.location_on),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Colors.orange,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Colors.orange,
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          const Text(
            'Địa chỉ',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          TextField(
            controller: addressController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Nhập địa chỉ',
              prefixIcon: const Icon(Icons.location_on),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Colors.orange,
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          Center(
            child: SizedBox(
              width: 156,
              height: 42,
              child: ElevatedButton(
                onPressed: widget.onSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                  ),
                ),
                child: Text(
                  widget.isEdit ? 'CẬP NHẬT' : 'LƯU',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
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