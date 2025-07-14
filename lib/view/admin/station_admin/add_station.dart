import 'package:flutter/material.dart';
import 'package:giao_dien_1/config/default.dart';
import 'package:giao_dien_1/widget/exit_button.dart';
import 'package:giao_dien_1/widget/appbar_admin.dart';
import 'package:giao_dien_1/widget/input_field.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:giao_dien_1/view/admin/station_admin/add_station_success.dart';
import 'package:giao_dien_1/config/config.dart';

class AddStation extends StatefulWidget {
  const AddStation({super.key});

  @override
  State<AddStation> createState() => _AddStationState();
}

class _AddStationState extends State<AddStation> {
final TextEditingController _stationController = TextEditingController();
final TextEditingController _stationnameController = TextEditingController();
final TextEditingController _addressController = TextEditingController();
final TextEditingController _provinceController = TextEditingController();

void addStation() async {
  final response = await http.post(
    Uri.parse('$baseURL/add-bx'), // đổi thành IP nếu chạy thiết bị thật
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'MaBX': _stationController.text,
      'TenBX': _stationnameController.text,
      'DiaChi': _addressController.text,
      'TinhThanh': _provinceController.text,
    }),
  );

  if (response.statusCode == 200) {
    // ✅ Cập nhật thành công → chuyển trang
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => AddStationSuccess()),
    );
  } else {
    print('Lỗi: ${response.body}');
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'QUẢN LÝ BẾN XE',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.mainOrange,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Các input
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

              // Nút
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 42,
                      child: ElevatedButton(
                        onPressed: addStation,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.mainOrange,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                          elevation: 3,
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add, color: Colors.white, size: 18),
                            SizedBox(width: 6),
                            Text('Tạo mới', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14, fontFamily: 'Inter')),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(child: ExitButton()),
                ],
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),

    );
  }
}