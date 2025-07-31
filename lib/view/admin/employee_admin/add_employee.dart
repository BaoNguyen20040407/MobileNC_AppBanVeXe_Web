import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:giao_dien_1/config/config.dart';
import 'package:giao_dien_1/config/default.dart';
import 'package:giao_dien_1/view/admin/employee_admin/add_employee_success.dart';
import 'package:giao_dien_1/widget/appbar_admin.dart';
import 'package:giao_dien_1/widget/exit_button.dart';
import 'package:giao_dien_1/widget/input_field.dart';
import 'package:giao_dien_1/widget/create_button.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:giao_dien_1/widget/image_picker_field.dart';

class AddEmployeeScreen extends StatefulWidget {
  const AddEmployeeScreen({super.key});

  @override
  State<AddEmployeeScreen> createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _joinDateController = TextEditingController();
  final TextEditingController _positionController = TextEditingController();
  final TextEditingController _departmentController = TextEditingController();

  File? _selectedImage;
  String? _imageError;

  Future<void> _pickImage() async {
  final picked = await ImagePicker().pickImage(source: ImageSource.gallery);

  if (picked != null) {
    setState(() {
      _selectedImage = File(picked.path);
      _imageError = null;
    });
  }
}


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
    if (_selectedImage == null) {
      setState(() => _imageError = 'Vui lòng chọn ảnh đại diện.');
      return;
    }

    final bytes = await _selectedImage!.readAsBytes();
    final base64Image = base64Encode(bytes);


    final employeeData = {
      "MaNV": _idController.text.trim(),
      "HoVaTen": _nameController.text.trim(),
      "NgaySinh": _dobController.text.trim(),
      "DiaChi": _addressController.text.trim(),
      "Email": _emailController.text.trim(),
      "SDT": _phoneController.text.trim(),
      "URLHinhAnh": base64Image,
      "NgayVaoLam": _joinDateController.text.trim(),
      "ChucVu": _positionController.text.trim(),
      "PhongBan": _departmentController.text.trim(),
      
    };

    try {
      final response = await http.post(
        Uri.parse('$baseURL/nhanvien'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(employeeData),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddEmployeeSuccess()),
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
      builder: (_) => AlertDialog(
        title: const Text("Lỗi"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
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
                  'THÊM NHÂN VIÊN',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
              const SizedBox(height: 32),

              ImagePickerField(
                selectedImage: _selectedImage,
                onPick: _pickImage,
                errorText: _imageError,
              ),
              const SizedBox(height: 16,),
              
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

              CustomInputField(
                controller: _dobController,
                labelText: 'Ngày sinh',
                prefixIcon: Icons.cake,
                readOnly: true,
                onTap: () => _selectDate(_dobController),
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
                controller: _joinDateController,
                labelText: 'Ngày vào làm',
                prefixIcon: Icons.calendar_today,
                readOnly: true,
                onTap: () => _selectDate(_joinDateController),
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
      ),
    );
  }
}