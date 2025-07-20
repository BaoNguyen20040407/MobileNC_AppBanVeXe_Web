import 'package:flutter/material.dart';
import 'package:giao_dien_1/config/config.dart';
import 'package:giao_dien_1/config/default.dart';
import 'package:giao_dien_1/widget/appbar_admin.dart';
import 'package:giao_dien_1/widget/input_field.dart';
import 'package:giao_dien_1/view/admin/vehicle_admin/vehicle_list.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:giao_dien_1/widget/edit_action_button.dart';
import 'package:giao_dien_1/view/admin/vehicle_admin/edit_vehicle_success.dart';
import 'package:giao_dien_1/widget/dropdown_field.dart';

class EditVehicle extends StatefulWidget {
  final Map<String, dynamic> vehicle;
  const EditVehicle({super.key, required this.vehicle});

  @override
  State<EditVehicle> createState() => _EditVehicleState();
}

class _EditVehicleState extends State<EditVehicle> {
  late TextEditingController _bienSoController;
  late TextEditingController _loaiXeController;
  late TextEditingController _soChoController;
  late TextEditingController _hangSXController;
  late TextEditingController _namSXController;

  String? selectedMaBX;
  List<String> maBXList = [];

  @override
  void initState() {
    super.initState();
    _bienSoController = TextEditingController(text: widget.vehicle['BienSoXe'] ?? '');
    _loaiXeController = TextEditingController(text: widget.vehicle['LoaiXe'] ?? '');
    _soChoController = TextEditingController(text: widget.vehicle['SoChoNgoi'].toString());
    _hangSXController = TextEditingController(text: widget.vehicle['HangSanXuat'] ?? '');
    _namSXController = TextEditingController(text: widget.vehicle['NamSanXuat'].toString());
    selectedMaBX = widget.vehicle['MaBX'];

    fetchMaBXList();
  }

  Future<void> fetchMaBXList() async {
    try {
      final response = await http.get(Uri.parse('$baseURL/benxe'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          maBXList = data.map((e) => e['MaBX'].toString()).toList();
        });
      } else {
        print('Lỗi lấy mã bến xe: ${response.body}');
      }
    } catch (e) {
      print('Lỗi mạng khi lấy mã bến xe: $e');
    }
  }

  Future<void> updateVehicle() async {
    final url = Uri.parse('$baseURL/xe/${_bienSoController.text}');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'LoaiXe': _loaiXeController.text,
        'SoChoNgoi': int.tryParse(_soChoController.text) ?? 0,
        'HangSanXuat': _hangSXController.text,
        'NamSanXuat': int.tryParse(_namSXController.text) ?? 0,
        'MaBX': selectedMaBX,
      }),
    );

    if (response.statusCode == 200) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const EditVehicleSuccess()),
      );
    } else {
      print('Lỗi cập nhật: ${response.body}');
    }
  }

  Future<void> deleteVehicle() async {
    final url = Uri.parse('$baseURL/xe/${_bienSoController.text}');
    final response = await http.delete(url);

    if (response.statusCode == 200) {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Xóa thành công!',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          content: const Text('Dữ liệu đã được xóa khỏi hệ thống.'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const VehicleList()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.red,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Đóng', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    } else {
      print('Lỗi xoá: ${response.body}');
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
                'THÔNG TIN XE',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.mainOrange,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 32),

              CustomInputField(
                controller: _bienSoController,
                labelText: "Biển số xe",
                prefixIcon: Icons.directions_car,
                keyboardType: TextInputType.text,
                showToggleVisibility: false,
                readOnly: true,
              ),
              const SizedBox(height: 16),

              CustomInputField(
                controller: _loaiXeController,
                labelText: "Loại xe",
                prefixIcon: Icons.category,
                keyboardType: TextInputType.text,
                showToggleVisibility: false,
              ),
              const SizedBox(height: 16),

              CustomInputField(
                controller: _soChoController,
                labelText: "Số chỗ ngồi",
                prefixIcon: Icons.event_seat,
                keyboardType: TextInputType.number,
                showToggleVisibility: false,
              ),
              const SizedBox(height: 16),

              CustomInputField(
                controller: _hangSXController,
                labelText: "Hãng sản xuất",
                prefixIcon: Icons.business,
                keyboardType: TextInputType.text,
                showToggleVisibility: false,
              ),
              const SizedBox(height: 16),

              CustomInputField(
                controller: _namSXController,
                labelText: "Năm sản xuất",
                prefixIcon: Icons.date_range,
                keyboardType: TextInputType.number,
                showToggleVisibility: false,
              ),
              const SizedBox(height: 16),

              CustomDropdownField(
                value: selectedMaBX,
                items: maBXList,
                labelText: 'Mã bến xe',
                prefixIcon: Icons.bus_alert,
                onChanged: (val) => setState(() => selectedMaBX = val),
              ),

              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 42,
                      child: EditActionButton(onPressed: updateVehicle),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: SizedBox(
                      height: 42,
                      child: ElevatedButton(
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              backgroundColor: AppColors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              title: const Text('Bạn có chắc không?',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                              content: const Text('Dữ liệu này có thể bị xóa'),
                              actions: [
                                OutlinedButton(
                                  onPressed: () => Navigator.of(context).pop(false),
                                  child: const Text('Hủy'),
                                ),
                                ElevatedButton(
                                  onPressed: () => Navigator.of(context).pop(true),
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                  child: const Text('Xóa'),
                                ),
                              ],
                            ),
                          );

                          if (confirm == true) {
                            await deleteVehicle();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.red,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                          side: const BorderSide(color: AppColors.mainOrange, width: 1.2),
                          elevation: 3,
                          shadowColor: AppColors.mainOrange.withOpacity(0.2),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.delete, color: Colors.white, size: 18),
                            SizedBox(width: 6),
                            Text(
                              'Xóa',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
