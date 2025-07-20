import 'package:flutter/material.dart';
import 'package:giao_dien_1/config/default.dart';
import 'package:giao_dien_1/widget/exit_button.dart';
import 'package:giao_dien_1/widget/appbar_admin.dart';
import 'package:giao_dien_1/widget/input_field.dart';
import 'package:giao_dien_1/widget/dropdown_field.dart';
import 'package:giao_dien_1/widget/create_button.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:giao_dien_1/config/config.dart';
import 'package:giao_dien_1/view/admin/vehicle_admin/add_vehicle_success.dart';

class AddVehicleScreen extends StatefulWidget {
  const AddVehicleScreen({super.key});

  @override
  State<AddVehicleScreen> createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends State<AddVehicleScreen> {
  final TextEditingController _plateController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _seatController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  String? selectedMaBX;            
  List<String> maBXList = [];        

  @override
  void initState() {
    super.initState();
    fetchMaBXList();
  }

  Future<void> fetchMaBXList() async {
    final response = await http.get(Uri.parse('$baseURL/benxe'));
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      setState(() {
        maBXList = data.map((e) => e['MaBX'].toString()).toList();
      });
    } else {
      print('Lỗi khi lấy danh sách bến xe');
    }
  }

  void addVehicle() async {
    final response = await http.post(
      Uri.parse('$baseURL/xe'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'BienSoXe': _plateController.text,
        'LoaiXe': _typeController.text,
        'SoChoNgoi': int.tryParse(_seatController.text) ?? 0,
        'HangSanXuat': _brandController.text,
        'NamSanXuat': int.tryParse(_yearController.text) ?? 0,
        'MaBX': selectedMaBX,
      }),
    );

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Thêm xe thành công!')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AddVehicleSuccess()),
      );
    } else {
      print('Lỗi thêm xe: ${response.body}');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Thêm xe thất bại')),
      );
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
                  'THÊM XE MỚI',
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
                controller: _plateController,
                labelText: "Biển số xe",
                prefixIcon: Icons.directions_car,
                keyboardType: TextInputType.text,
                showToggleVisibility: false,
              ),
              const SizedBox(height: 16),

              CustomInputField(
                controller: _typeController,
                labelText: "Loại xe",
                prefixIcon: Icons.category,
                keyboardType: TextInputType.text,
                showToggleVisibility: false,
              ),
              const SizedBox(height: 16),

              CustomInputField(
                controller: _seatController,
                labelText: "Số chỗ ngồi",
                prefixIcon: Icons.event_seat,
                keyboardType: TextInputType.number,
                showToggleVisibility: false,
              ),
              const SizedBox(height: 16),

              CustomInputField(
                controller: _brandController,
                labelText: "Hãng sản xuất",
                prefixIcon: Icons.precision_manufacturing,
                keyboardType: TextInputType.text,
                showToggleVisibility: false,
              ),
              const SizedBox(height: 16),

              CustomInputField(
                controller: _yearController,
                labelText: "Năm sản xuất",
                prefixIcon: Icons.calendar_today,
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
                  Expanded(child: CreateButton(onPressed: addVehicle)),
                  const SizedBox(width: 16),
                  const Expanded(child: ExitButton()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
