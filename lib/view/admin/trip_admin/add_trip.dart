import 'package:flutter/material.dart';
import 'package:giao_dien_1/config/default.dart';
import 'package:giao_dien_1/widget/exit_button.dart';
import 'package:giao_dien_1/widget/appbar_admin.dart';
import 'package:giao_dien_1/widget/input_field.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:giao_dien_1/view/admin/trip_admin/add_trip_success.dart';
import 'package:giao_dien_1/config/config.dart';
import 'package:giao_dien_1/widget/create_button.dart';
import 'package:giao_dien_1/widget/dropdown_field.dart';

class AddTrip extends StatefulWidget {
  const AddTrip({super.key});

  @override
  State<AddTrip> createState() => _AddTripState();
}

class _AddTripState extends State<AddTrip> {
  final TextEditingController _maCXController = TextEditingController();
  final TextEditingController _thoiGianDiController = TextEditingController();
  final TextEditingController _thoiGianVeController = TextEditingController();
  final TextEditingController _diemDiController = TextEditingController();
  final TextEditingController _diemDenController = TextEditingController();
  final TextEditingController _loaiHinhController = TextEditingController();
  final TextEditingController _giaVeController = TextEditingController();
  final TextEditingController _soChoController = TextEditingController();

  List<String> bienSoList = [];
  String? selectedBienSo;

  @override
  void initState() {
    super.initState();
    fetchBienSoXe();
  }

  Future<void> fetchBienSoXe() async {
    final response = await http.get(Uri.parse('$baseURL/xe'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        bienSoList = List<String>.from(data.map((e) => e['BienSoXe']));
        if (bienSoList.isNotEmpty) selectedBienSo = bienSoList.first;
      });
    } else {
      print('Lỗi khi lấy danh sách xe');
    }
  }

  void addTrip() async {
    final response = await http.post(
      Uri.parse('$baseURL/add-chuyenxe'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'MaCX': _maCXController.text,
        'BienSoXe': selectedBienSo,
        'ThoiGianDi': _thoiGianDiController.text,
        'ThoiGianVe': _thoiGianVeController.text,
        'DiemDi': _diemDiController.text,
        'DiemDen': _diemDenController.text,
        'LoaiHinhChuyenDi': _loaiHinhController.text,
        'GiaVe': double.tryParse(_giaVeController.text) ?? 0,
        'SoChoNgoi': int.tryParse(_soChoController.text) ?? 0,
      }),
    );

    if (response.statusCode == 200) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AddTripSuccess()),
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
                  'THÊM CHUYẾN XE',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.mainOrange,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
              const SizedBox(height: 32),
              CustomInputField(
                controller: _maCXController,
                labelText: "Mã chuyến xe",
                prefixIcon: Icons.directions_bus,
                keyboardType: TextInputType.text,
                showToggleVisibility: false,
              ),
              const SizedBox(height: 16),
              CustomDropdownField(
                value: selectedBienSo,
                items: bienSoList,
                labelText: 'Biển số xe',
                prefixIcon: Icons.directions_bus,
                onChanged: (val) => setState(() => selectedBienSo = val),
              ),
              const SizedBox(height: 16),
              CustomInputField(
                controller: _thoiGianDiController,
                labelText: "Thời gian đi (YYYY-MM-DD HH:MM:SS)",
                prefixIcon: Icons.schedule,
                keyboardType: TextInputType.datetime,
                showToggleVisibility: false,
              ),
              const SizedBox(height: 16),
              CustomInputField(
                controller: _thoiGianVeController,
                labelText: "Thời gian về (YYYY-MM-DD HH:MM:SS)",
                prefixIcon: Icons.schedule,
                keyboardType: TextInputType.datetime,
                showToggleVisibility: false,
              ),
              const SizedBox(height: 16),
              CustomInputField(
                controller: _diemDiController,
                labelText: "Điểm đi",
                prefixIcon: Icons.location_on,
                keyboardType: TextInputType.text,
                showToggleVisibility: false,
              ),
              const SizedBox(height: 16),
              CustomInputField(
                controller: _diemDenController,
                labelText: "Điểm đến",
                prefixIcon: Icons.location_on,
                keyboardType: TextInputType.text,
                showToggleVisibility: false,
              ),
              const SizedBox(height: 16),
              CustomInputField(
                controller: _loaiHinhController,
                labelText: "Loại hình chuyến đi",
                prefixIcon: Icons.directions,
                keyboardType: TextInputType.text,
                showToggleVisibility: false,
              ),
              const SizedBox(height: 16),
              CustomInputField(
                controller: _giaVeController,
                labelText: "Giá vé",
                prefixIcon: Icons.attach_money,
                keyboardType: TextInputType.number,
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
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: CreateButton(onPressed: addTrip),
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
