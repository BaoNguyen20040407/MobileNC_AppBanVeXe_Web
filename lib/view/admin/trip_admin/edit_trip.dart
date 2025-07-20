import 'package:flutter/material.dart';
import 'package:giao_dien_1/config/config.dart';
import 'package:giao_dien_1/config/default.dart';
import 'package:giao_dien_1/widget/appbar_admin.dart';
import 'package:giao_dien_1/widget/input_field.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:giao_dien_1/view/admin/trip_admin/edit_trip_success.dart';
import 'package:giao_dien_1/view/admin/trip_admin/trip_list.dart';
import 'package:giao_dien_1/widget/edit_action_button.dart';
import 'package:giao_dien_1/widget/confirm_delete_button.dart';

class EditTrip extends StatefulWidget {
  final Map<String, dynamic> trip;
  const EditTrip({super.key, required this.trip});

  @override
  State<EditTrip> createState() => _EditTripState();
}

class _EditTripState extends State<EditTrip> {
  late TextEditingController _maCXController;
  late TextEditingController _thoiGianDiController;
  late TextEditingController _thoiGianVeController;
  late TextEditingController _diemDiController;
  late TextEditingController _diemDenController;
  late TextEditingController _loaiHinhController;
  late TextEditingController _giaVeController;
  late TextEditingController _soChoController;

  List<String> bienSoList = [];
  String? selectedBienSo;

  @override
  void initState() {
    super.initState();
    _maCXController = TextEditingController(text: widget.trip['MaCX'] ?? '');
    selectedBienSo = widget.trip['BienSoXe'] ?? '';
    _thoiGianDiController = TextEditingController(text: widget.trip['ThoiGianDi'] ?? '');
    _thoiGianVeController = TextEditingController(text: widget.trip['ThoiGianVe'] ?? '');
    _diemDiController = TextEditingController(text: widget.trip['DiemDi'] ?? '');
    _diemDenController = TextEditingController(text: widget.trip['DiemDen'] ?? '');
    _loaiHinhController = TextEditingController(text: widget.trip['LoaiHinhChuyenDi'] ?? '');
    _giaVeController = TextEditingController(text: widget.trip['GiaVe']?.toString() ?? '');
    _soChoController = TextEditingController(text: widget.trip['SoChoNgoi']?.toString() ?? '');

    fetchBienSoXe();
  }

  Future<void> fetchBienSoXe() async {
    final url = Uri.parse('$baseURL/xe');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        bienSoList = data.map((item) => item['BienSoXe'].toString()).toList();
      });
    } else {
      print('Lỗi khi tải danh sách xe: ${response.body}');
    }
  }

  @override
  void dispose() {
    _maCXController.dispose();
    _thoiGianDiController.dispose();
    _thoiGianVeController.dispose();
    _diemDiController.dispose();
    _diemDenController.dispose();
    _loaiHinhController.dispose();
    _giaVeController.dispose();
    _soChoController.dispose();
    super.dispose();
  }

  Future<void> updateTrip() async {
    final maCX = _maCXController.text;
    final url = Uri.parse('$baseURL/chuyenxe/$maCX');

    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'BienSoXe': selectedBienSo,
        'ThoiGianDi': _thoiGianDiController.text,
        'ThoiGianVe': _thoiGianVeController.text,
        'DiemDi': _diemDiController.text,
        'DiemDen': _diemDenController.text,
        'LoaiHinhChuyenDi': _loaiHinhController.text,
        'GiaVe': double.tryParse(_giaVeController.text) ?? 0.0,
        'SoChoNgoi': int.tryParse(_soChoController.text) ?? 0,
      }),
    );

    if (response.statusCode == 200) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const EditTripSuccess()),
      );
    } else {
      print('Lỗi cập nhật: ${response.body}');
    }
  }

  Future<void> deleteTrip() async {
    final maCX = _maCXController.text;
    final url = Uri.parse('$baseURL/chuyenxe/$maCX');

    final response = await http.delete(url);

    if (response.statusCode == 200) {
      print('Xóa thành công');
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
                'THÔNG TIN CHUYẾN XE',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.mainOrange,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 32),

              CustomInputField(controller: _maCXController, labelText: "Mã chuyến xe", prefixIcon: Icons.tag, showToggleVisibility: false),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: selectedBienSo,
                decoration: InputDecoration(
                  labelText: 'Biển số xe',
                  prefixIcon: const Icon(Icons.directions_bus),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                items: bienSoList.map((bienSo) {
                  return DropdownMenuItem<String>(
                    value: bienSo,
                    child: Text(bienSo),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedBienSo = value;
                  });
                },
              ),
              const SizedBox(height: 16),

              CustomInputField(controller: _thoiGianDiController, labelText: "Thời gian đi", prefixIcon: Icons.schedule, showToggleVisibility: false),
              const SizedBox(height: 16),
              CustomInputField(controller: _thoiGianVeController, labelText: "Thời gian về", prefixIcon: Icons.access_time_filled, showToggleVisibility: false),
              const SizedBox(height: 16),
              CustomInputField(controller: _diemDiController, labelText: "Điểm đi", prefixIcon: Icons.location_on, showToggleVisibility: false),
              const SizedBox(height: 16),
              CustomInputField(controller: _diemDenController, labelText: "Điểm đến", prefixIcon: Icons.flag, showToggleVisibility: false),
              const SizedBox(height: 16),
              CustomInputField(controller: _loaiHinhController, labelText: "Loại hình chuyến đi", prefixIcon: Icons.category, showToggleVisibility: false),
              const SizedBox(height: 16),
              CustomInputField(controller: _giaVeController, labelText: "Giá vé", prefixIcon: Icons.monetization_on, keyboardType: TextInputType.number, showToggleVisibility: false),
              const SizedBox(height: 16),
              CustomInputField(controller: _soChoController, labelText: "Số chỗ ngồi", prefixIcon: Icons.event_seat, keyboardType: TextInputType.number, showToggleVisibility: false),
              const SizedBox(height: 32),

              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 42,
                      child: EditActionButton(onPressed: updateTrip),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ConfirmDeleteButton(
                      onConfirmDelete: deleteTrip,
                      successTitle: 'Xóa thành công!',
                      successMessage: 'Dữ liệu đã được xóa khỏi hệ thống.',
                      onSuccessClose: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const TripList()),
                        );
                      },
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