import 'package:flutter/material.dart';
import 'package:giao_dien_1/config/default.dart';
import 'package:giao_dien_1/widget/exit_button.dart';
import 'package:giao_dien_1/widget/appbar_admin.dart';
import 'package:giao_dien_1/widget/input_field.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:giao_dien_1/config/config.dart';
import 'package:giao_dien_1/widget/create_button.dart';
import 'package:giao_dien_1/view/admin/stop_admin/add_stop_success.dart';

class AddStop extends StatefulWidget {
  const AddStop({super.key});

  @override
  State<AddStop> createState() => _AddStopState();
}

class _AddStopState extends State<AddStop> {
  final TextEditingController _maCXController = TextEditingController();
  final TextEditingController _thuTuController = TextEditingController();
  final TextEditingController _diemDungController = TextEditingController();
  final TextEditingController _thoiGianDenController = TextEditingController();
  final TextEditingController _thoiGianDiController = TextEditingController();

  List<String> maCXList = [];
  String? selectedMaCX;

  @override
  void initState() {
    super.initState();
    fetchMaCX();
  }

  Future<void> fetchMaCX() async {
    final response = await http.get(Uri.parse('$baseURL/chuyenxe'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        maCXList = data.map((item) => item['MaCX'].toString()).toList();
      });
    } else {
      print('Lỗi khi lấy danh sách MaCX');
    }
}
  
  void addTransfer() async {
    final response = await http.post(
      Uri.parse('$baseURL/add-trungchuyen'), // API backend thêm TRUNGCHUYEN
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'MaCX': selectedMaCX,
        'ThuTu': int.tryParse(_thuTuController.text) ?? 0,
        'DiemDung': _diemDungController.text,
        'ThoiGianDen': _thoiGianDenController.text,
        'ThoiGianDi': _thoiGianDiController.text,
      }),
    );

    if (response.statusCode == 200) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AddStopSuccess()),
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
                  'THÊM TRẠM',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.mainOrange,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
              const SizedBox(height: 32),

              InputDecorator(
  decoration: InputDecoration(
    labelText: "Mã chuyến xe",
    prefixIcon: const Icon(Icons.directions_bus),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color:AppColors.mainOrange)),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  ),
  child: DropdownButtonHideUnderline(
    child: DropdownButton<String>(
      isExpanded: true,
      value: selectedMaCX,
      hint: const Text('Chọn mã chuyến xe'),
      items: maCXList.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (newValue) {
        setState(() {
          selectedMaCX = newValue;
        });
      },
    ),
  ),
),
              const SizedBox(height: 16),

              CustomInputField(
                controller: _thuTuController,
                labelText: "Thứ tự",
                prefixIcon: Icons.format_list_numbered,
                keyboardType: TextInputType.number,
                showToggleVisibility: false,
              ),
              const SizedBox(height: 16),

              CustomInputField(
                controller: _diemDungController,
                labelText: "Điểm dừng",
                prefixIcon: Icons.location_on,
                keyboardType: TextInputType.text,
                showToggleVisibility: false,
              ),
              const SizedBox(height: 16),

              CustomInputField(
                controller: _thoiGianDenController,
                labelText: "Thời gian đến (YYYY-MM-DD HH:mm:ss)",
                prefixIcon: Icons.access_time,
                keyboardType: TextInputType.datetime,
                showToggleVisibility: false,
              ),
              const SizedBox(height: 16),

              CustomInputField(
                controller: _thoiGianDiController,
                labelText: "Thời gian đi (YYYY-MM-DD HH:mm:ss)",
                prefixIcon: Icons.access_time_outlined,
                keyboardType: TextInputType.datetime,
                showToggleVisibility: false,
              ),

              const SizedBox(height: 32),

              Row(
                children: [
                  Expanded(
                    child: CreateButton(onPressed: addTransfer),
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