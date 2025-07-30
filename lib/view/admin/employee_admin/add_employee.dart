import 'package:flutter/material.dart';
import 'package:giao_dien_1/config/default.dart';
import 'package:giao_dien_1/view/admin/employee_admin/add_employee_success.dart';
import 'package:giao_dien_1/widget/appbar_admin.dart';
import 'package:giao_dien_1/widget/exit_button.dart';
import 'package:giao_dien_1/widget/input_field.dart';
import 'package:giao_dien_1/view/admin/account/account_admin/add_account_admin_success.dart';
import 'package:giao_dien_1/widget/create_button.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddEmployeeScreen extends StatefulWidget {
  const AddEmployeeScreen({super.key});

  @override
  State<AddEmployeeScreen> createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen> {
  // Controllers for employee info
  final TextEditingController _idController = TextEditingController(); // MaNV
  final TextEditingController _nameController = TextEditingController(); // HoVaTen
  final TextEditingController _dobController = TextEditingController(); // NgaySinh
  final TextEditingController _addressController = TextEditingController(); // DiaChi
  final TextEditingController _emailController = TextEditingController(); // Email
  final TextEditingController _phoneController = TextEditingController(); // SDT
  final TextEditingController _imageUrlController = TextEditingController(); // URLHinhAnh
  final TextEditingController _joinDateController = TextEditingController(); // NgayVaoLam
  final TextEditingController _positionController = TextEditingController(); // ChucVu
  final TextEditingController _departmentController = TextEditingController(); // PhongBan

  // Date picker for DOB or Join Date
  Future<void> _selectDate(TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(1990),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        controller.text = picked.toIso8601String().split('T').first;
      });
    }
  }

  void _handleSubmit() async {
    final Map<String, dynamic> employeeData = {
      "MaNV": _idController.text.trim(),
      "HoVaTen": _nameController.text.trim(),
      "NgaySinh": _dobController.text.trim(),
      "DiaChi": _addressController.text.trim(),
      "Email": _emailController.text.trim(),
      "SDT": _phoneController.text.trim(),
      "URLHinhAnh": _imageUrlController.text.trim(),
      "NgayVaoLam": _joinDateController.text.trim(),
      "ChucVu": _positionController.text.trim(),
      "PhongBan": _departmentController.text.trim(),
    };

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/nhanvien'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(employeeData),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddEmployeeSuccess(),
            ),
          );
        } else {
          _showErrorDialog("Lỗi từ server: ${data['message']}");
        }
      } else {
        _showErrorDialog("Thêm nhân viên thất bại (mã lỗi ${response.statusCode})");
      }
    } catch (e) {
      _showErrorDialog("Lỗi kết nối: $e");
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Lỗi'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarAdmin(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            CustomInputField(
              controller: _idController,
              labelText: 'Mã nhân viên',
              prefixIcon: Icons.badge,
            ),
            const SizedBox(height: 16),

            CustomInputField(
              controller: _nameController,
              labelText: 'Họ và tên',
              prefixIcon: Icons.person,
            ),
            const SizedBox(height: 16),

            GestureDetector(
              onTap: () => _selectDate(_dobController),
              child: AbsorbPointer(
                child: CustomInputField(
                  controller: _dobController,
                  labelText: 'Ngày sinh',
                  prefixIcon: Icons.cake,
                ),
              ),
            ),
            const SizedBox(height: 16),

            CustomInputField(
              controller: _addressController,
              labelText: 'Địa chỉ',
              prefixIcon: Icons.home,
            ),
            const SizedBox(height: 16),

            CustomInputField(
              controller: _emailController,
              labelText: 'Email',
              prefixIcon: Icons.email,
            ),
            const SizedBox(height: 16),

            CustomInputField(
              controller: _phoneController,
              labelText: 'Số điện thoại',
              prefixIcon: Icons.phone,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),

            CustomInputField(
              controller: _imageUrlController,
              labelText: 'URL hình ảnh',
              prefixIcon: Icons.image,
            ),
            const SizedBox(height: 16),

            GestureDetector(
              onTap: () => _selectDate(_joinDateController),
              child: AbsorbPointer(
                child: CustomInputField(
                  controller: _joinDateController,
                  labelText: 'Ngày vào làm',
                  prefixIcon: Icons.calendar_today,
                ),
              ),
            ),
            const SizedBox(height: 16),

            CustomInputField(
              controller: _positionController,
              labelText: 'Chức vụ',
              prefixIcon: Icons.work,
            ),
            const SizedBox(height: 16),

            CustomInputField(
              controller: _departmentController,
              labelText: 'Phòng ban',
              prefixIcon: Icons.account_tree,
            ),
            const SizedBox(height: 32),

            Row(
              children: [
                Expanded(child: CreateButton(onPressed: _handleSubmit)),
                const SizedBox(width: 16),
                const Expanded(child: ExitButton()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
