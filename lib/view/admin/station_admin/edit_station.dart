import 'package:flutter/material.dart';
import 'package:giao_dien_1/config/default.dart';
import 'package:giao_dien_1/widget/exit_button.dart';
import 'package:giao_dien_1/widget/appbar_admin.dart';
import 'package:giao_dien_1/widget/input_field.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:giao_dien_1/view/admin/station_admin/edit_station_success.dart';

class EditStation extends StatefulWidget {
  final Map<String, dynamic> station;
  const EditStation({super.key, required this.station});

  @override
  State<EditStation> createState() => _EditStationState();
}

class _EditStationState extends State<EditStation> {
  late TextEditingController _stationController;
  late TextEditingController _stationnameController;
  late TextEditingController _addressController;
  late TextEditingController _provinceController;

  @override
  void initState() {
    super.initState();
    // Khởi tạo controller với dữ liệu hiện tại
    _stationController = TextEditingController(text: widget.station['MaBX'] ?? '');
    _stationnameController = TextEditingController(text: widget.station['TenBX'] ?? '');
    _addressController = TextEditingController(text: widget.station['DiaChi'] ?? '');
    _provinceController = TextEditingController(text: widget.station['TinhThanh'] ?? '');
  }

  @override
  void dispose() {
    _stationController.dispose();
    _stationnameController.dispose();
    _addressController.dispose();
    _provinceController.dispose();
    super.dispose();
  }

  Future<void> updateStation() async {
  final maBX = _stationController.text;
  final tenBX = _stationnameController.text;
  final diaChi = _addressController.text;
  final tinhThanh = _provinceController.text;

  final url = Uri.parse('http://localhost:3000/benxe/$maBX');

  final response = await http.put(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'TenBX': tenBX,
      'DiaChi': diaChi,
      'TinhThanh': tinhThanh,
    }),
  );

  if (response.statusCode == 200) {
    // ✅ Cập nhật thành công → chuyển trang
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => EditStationSuccess()),
    );
  } else {
    print('Lỗi: ${response.body}');
  }
}

Future<void> deleteStation() async {
  final maBX = _stationController.text;

  if (maBX.isEmpty) {
    print('Vui lòng nhập mã bến xe để xóa');
    return;
  }

  final url = Uri.parse('http://localhost:3000/benxe/$maBX');

  final response = await http.delete(url);

  if (response.statusCode == 200) {
    print('Xóa thành công');
    // Có thể reset form hoặc thông báo UI
  } else {
    print('Lỗi xóa: ${response.body}');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBarAdmin(),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
        child: Column(
          children: [
            const Text(
              'THÔNG TIN BẾN XE',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.mainOrange,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 32),

            CustomInputField(
              controller: _stationController,
              labelText: "Mã bến xe",
              prefixIcon: Icons.tag,
              keyboardType: TextInputType.text,
              showToggleVisibility: false,
            ),

            const SizedBox(height: 16),

            CustomInputField(
              controller: _stationnameController,
              labelText: "Tên bến xe",
              prefixIcon: Icons.bus_alert,
              keyboardType: TextInputType.text,
              showToggleVisibility: false,
            ),

            const SizedBox(height: 16),

            CustomInputField(
              controller: _addressController,
              labelText: "Địa chỉ",
              prefixIcon: Icons.gps_fixed,
              keyboardType: TextInputType.text,
              showToggleVisibility: false,
            ),

            const SizedBox(height: 16),

            CustomInputField(
              controller: _provinceController,
              labelText: "Tỉnh/thành",
              prefixIcon: Icons.map_sharp,
              keyboardType: TextInputType.text,
              showToggleVisibility: false,
            ),

            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 140,
                  child: ElevatedButton(
                    onPressed: updateStation,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.greenDark,
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      side: const BorderSide(color: AppColors.mainOrange, width: 1.2),
                      elevation: 3,
                      shadowColor: AppColors.mainOrange.withOpacity(0.2),
                    ).copyWith(
                      overlayColor: MaterialStateProperty.all(Colors.transparent),
                      surfaceTintColor: MaterialStateProperty.all(Colors.transparent),
                    ),
                    child: const Text(
                      'Sửa',
                      style: TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 140,
                  child: ElevatedButton(
                  onPressed: () async {
  final confirm = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Xác nhận'),
      content: const Text('Bạn có chắc không?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false), // Không xóa
          child: const Text('Hủy'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true), // Xóa
          child: const Text('Xóa'),
        ),
      ],
    ),
  );

  if (confirm == true) {
    // Người dùng xác nhận xóa
    await deleteStation();
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Thông báo'),
        content: const Text('Dữ liệu đã xóa'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
},
                  style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.red,  // màu đỏ cho nút xóa
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                  side: const BorderSide(color: AppColors.mainOrange, width: 1.2),
                  elevation: 3,
                  shadowColor: AppColors.mainOrange.withOpacity(0.2),
                  ).copyWith(
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                  surfaceTintColor: MaterialStateProperty.all(Colors.transparent),
                  ),
                  child: const Text(
                    'Xóa',
                  style: TextStyle(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  fontFamily: 'Inter',
                ),
                ),
                ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}