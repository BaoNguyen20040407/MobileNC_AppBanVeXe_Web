import 'package:flutter/material.dart';
import 'package:giao_dien_1/config/config.dart';
import 'package:giao_dien_1/config/default.dart';
import 'package:giao_dien_1/widget/appbar_admin.dart';
import 'package:giao_dien_1/widget/input_field.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:giao_dien_1/view/admin/station_admin/edit_station_success.dart';
import 'package:giao_dien_1/view/admin/station_admin/station_list.dart';
import 'package:giao_dien_1/widget/edit_action_button.dart';
import 'package:giao_dien_1/widget/confirm_delete_button.dart';

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

  final url = Uri.parse('$baseURL/benxe/$maBX');

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

  final url = Uri.parse('$baseURL/benxe/$maBX');

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
      body: SafeArea(
        child: SingleChildScrollView(
padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
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

            const SizedBox(height: 32),

            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 42,
                    child: EditActionButton(onPressed: updateStation),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ConfirmDeleteButton(
                    onConfirmDelete: deleteStation,
                    successTitle: 'Xóa thành công!',
                    successMessage: 'Dữ liệu đã được xóa khỏi hệ thống.',
                    onSuccessClose: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const StationList()),
                      );
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      ),
    );  
  }
}