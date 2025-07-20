import 'package:flutter/material.dart';
import 'package:giao_dien_1/config/config.dart';
import 'package:giao_dien_1/config/default.dart';
import 'package:giao_dien_1/widget/appbar_admin.dart';
import 'package:giao_dien_1/widget/input_field.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:giao_dien_1/widget/edit_action_button.dart';
import 'package:giao_dien_1/view/admin/assignment_admin/assignment_list.dart';
import 'package:giao_dien_1/view/admin/assignment_admin/edit_assignment_success.dart';
import 'package:giao_dien_1/widget/confirm_delete_button.dart';

class EditAssignment extends StatefulWidget {
  final Map<String, dynamic> assignment;
  const EditAssignment({super.key, required this.assignment});

  @override
  State<EditAssignment> createState() => _EditAssignmentState();
}

class _EditAssignmentState extends State<EditAssignment> {
  late TextEditingController _viTriController;
  late TextEditingController _ngayPhanCongController;

  List<String> maCXList = [];
  List<String> maNVList = [];
  String? selectedMaCX;
  String? selectedMaNV;

  @override
  void initState() {
    super.initState();
    selectedMaCX = widget.assignment['MaCX'];
    selectedMaNV = widget.assignment['MaNV'];
    _viTriController = TextEditingController(text: widget.assignment['ViTri'] ?? '');
    _ngayPhanCongController = TextEditingController(text: widget.assignment['NgayPhanCong'] ?? '');

    fetchData();
  }

  Future<void> fetchData() async {
    await fetchMaCXList();
    await fetchMaNVList();
  }

  Future<void> fetchMaCXList() async {
    final response = await http.get(Uri.parse('$baseURL/chuyenxe'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        maCXList = List<String>.from(data.map((e) => e['MaCX'].toString()));
      });
    }
  }

  Future<void> fetchMaNVList() async {
    final response = await http.get(Uri.parse('$baseURL/nhanvien'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        maNVList = List<String>.from(data.map((e) => e['MaNV'].toString()));
      });
    }
  }

  Future<void> updateAssignment() async {
    final url = Uri.parse('$baseURL/phancong/$selectedMaCX/$selectedMaNV');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'ViTri': _viTriController.text,
        'NgayPhanCong': _ngayPhanCongController.text,
      }),
    );

    if (response.statusCode == 200) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const EditAssignmentSuccess()));
    } else {
      print('Lỗi cập nhật: ${response.body}');
    }
  }

  Future<void> deleteAssignment() async {
    final url = Uri.parse('$baseURL/phancong/$selectedMaCX/$selectedMaNV');
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
                'THÔNG TIN PHÂN CÔNG',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.mainOrange,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 32),
              DropdownButtonFormField<String>(
                value: selectedMaCX,
                decoration: InputDecoration(
                  labelText: 'Mã chuyến xe',
                  prefixIcon: const Icon(Icons.directions_bus),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                items: maCXList.map((cx) => DropdownMenuItem(value: cx, child: Text(cx))).toList(),
                onChanged: (value) => setState(() => selectedMaCX = value),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedMaNV,
                decoration: InputDecoration(
                  labelText: 'Mã nhân viên',
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                items: maNVList.map((nv) => DropdownMenuItem(value: nv, child: Text(nv))).toList(),
                onChanged: (value) => setState(() => selectedMaNV = value),
              ),
              const SizedBox(height: 16),
              CustomInputField(
                controller: _viTriController,
                labelText: 'Vị trí',
                prefixIcon: Icons.work,
                showToggleVisibility: false,
              ),
              const SizedBox(height: 16),
              CustomInputField(
                controller: _ngayPhanCongController,
                labelText: 'Ngày phân công',
                prefixIcon: Icons.calendar_today,
                showToggleVisibility: false,
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 42,
                      child: EditActionButton(onPressed: updateAssignment),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ConfirmDeleteButton(
                      onConfirmDelete: deleteAssignment,
                      successTitle: 'Xóa thành công!',
                      successMessage: 'Dữ liệu đã được xóa khỏi hệ thống.',
                      onSuccessClose: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const AssignmentList()),
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