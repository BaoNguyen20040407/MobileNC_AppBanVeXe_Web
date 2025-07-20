import 'package:flutter/material.dart';
import 'package:giao_dien_1/config/default.dart';
import 'package:giao_dien_1/widget/exit_button.dart';
import 'package:giao_dien_1/widget/appbar_admin.dart';
import 'package:giao_dien_1/widget/input_field.dart';
import 'package:giao_dien_1/widget/create_button.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:giao_dien_1/config/config.dart';
import 'package:giao_dien_1/view/admin/assignment_admin/add_assignment_success.dart';
import 'package:giao_dien_1/widget/dropdown_field.dart';

class AddAssignment extends StatefulWidget {
  const AddAssignment({super.key});

  @override
  State<AddAssignment> createState() => _AddAssignmentState();
}

class _AddAssignmentState extends State<AddAssignment> {
  final TextEditingController _viTriController = TextEditingController();
  final TextEditingController _ngayPhanCongController = TextEditingController();

  List<String> maCXList = [];
  List<String> maNVList = [];

  String? selectedMaCX;
  String? selectedMaNV;

  @override
  void initState() {
    super.initState();
    fetchMaCX();
    fetchMaNV();
  }

  Future<void> fetchMaCX() async {
    final response = await http.get(Uri.parse('$baseURL/chuyenxe'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        maCXList = data.map((item) => item['MaCX'].toString()).toList();
      });
    }
  }

  Future<void> fetchMaNV() async {
    final response = await http.get(Uri.parse('$baseURL/nhanvien'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        maNVList = data.map((item) => item['MaNV'].toString()).toList();
      });
    }
  }

  void addAssignment() async {
    final response = await http.post(
      Uri.parse('$baseURL/add-phancong'), // ➤ bạn cần tạo route này trong Node.js
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'MaCX': selectedMaCX,
        'MaNV': selectedMaNV,
        'ViTri': _viTriController.text,
        'NgayPhanCong': _ngayPhanCongController.text,
      }),
    );

    if (response.statusCode == 200) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AddAssignmentSuccess()),
      );
    } else {
      print('Lỗi thêm phân công: ${response.body}');
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
                  'THÊM PHÂN CÔNG',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.mainOrange,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
              const SizedBox(height: 32),

              CustomDropdownField(
                value: selectedMaCX,
                items: maCXList,
                labelText: "Mã chuyến xe",
                prefixIcon: Icons.directions_bus,
                onChanged: (newValue) {
                  setState(() {
                    selectedMaCX = newValue;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Dropdown MaNV
              CustomDropdownField(
                value: selectedMaNV,
                items: maNVList,
                labelText: "Mã nhân viên",
                prefixIcon: Icons.person,
                onChanged: (newValue) {
                  setState(() {
                    selectedMaNV = newValue;
                  });
                },
              ),
              const SizedBox(height: 16),

              CustomInputField(
                controller: _viTriController,
                labelText: "Vị trí",
                prefixIcon: Icons.work,
                keyboardType: TextInputType.text,
                showToggleVisibility: false,
              ),
              const SizedBox(height: 16),

              CustomInputField(
                controller: _ngayPhanCongController,
                labelText: "Ngày phân công",
                prefixIcon: Icons.calendar_today,
                keyboardType: TextInputType.datetime,
                showToggleVisibility: false,
              ),
              const SizedBox(height: 32),

              Row(
                children: [
                  Expanded(child: CreateButton(onPressed: addAssignment)),
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