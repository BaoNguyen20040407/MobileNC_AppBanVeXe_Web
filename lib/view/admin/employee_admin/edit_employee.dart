import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:giao_dien_1/config/config.dart';
import 'package:giao_dien_1/config/default.dart';
import 'package:giao_dien_1/view/admin/employee_admin/employee_list.dart';
import 'package:giao_dien_1/widget/input_field.dart';
import 'package:giao_dien_1/widget/appbar_admin.dart';
import 'package:giao_dien_1/view/admin/employee_admin/edit_employee_success.dart';
import 'package:giao_dien_1/widget/edit_action_button.dart';
import 'package:http/http.dart' as http;
import 'package:giao_dien_1/widget/confirm_delete_button.dart';

class EditEmployee extends StatefulWidget {
  final Map<String, dynamic> staffData;

  const EditEmployee({super.key, required this.staffData});

  @override
  State<EditEmployee> createState() => _EditEmployeeState();
}

class _EditEmployeeState extends State<EditEmployee> {
  late TextEditingController _maNVController;
  late TextEditingController _hoTenController;
  late TextEditingController _ngaySinhController;
  late TextEditingController _diaChiController;
  late TextEditingController _emailController;
  late TextEditingController _sdtController;
  late TextEditingController _urlHinhAnhController;
  late TextEditingController _ngayVaoLamController;
  late TextEditingController _chucVuController;
  late TextEditingController _phongBanController;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _maNVController = TextEditingController(text: widget.staffData['MaNV']);
    _hoTenController = TextEditingController(text: widget.staffData['HoVaTen']);
    _ngaySinhController = TextEditingController(text: widget.staffData['NgaySinh']);
    _diaChiController = TextEditingController(text: widget.staffData['DiaChi']);
    _emailController = TextEditingController(text: widget.staffData['Email']);
    _sdtController = TextEditingController(text: widget.staffData['SDT']);
    _urlHinhAnhController = TextEditingController(text: widget.staffData['URLHinhAnh']);
    _ngayVaoLamController = TextEditingController(text: widget.staffData['NgayVaoLam']);
    _chucVuController = TextEditingController(text: widget.staffData['ChucVu']);
    _phongBanController = TextEditingController(text: widget.staffData['PhongBan']);
  }

  @override
  void dispose() {
    _maNVController.dispose();
    _hoTenController.dispose();
    _ngaySinhController.dispose();
    _diaChiController.dispose();
    _emailController.dispose();
    _sdtController.dispose();
    _urlHinhAnhController.dispose();
    _ngayVaoLamController.dispose();
    _chucVuController.dispose();
    _phongBanController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(TextEditingController controller) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.tryParse(controller.text) ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        controller.text = pickedDate.toIso8601String().split('T')[0];
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final updatedData = {
        "HoVaTen": _hoTenController.text.trim(),
        "NgaySinh": _ngaySinhController.text.trim(),
        "DiaChi": _diaChiController.text.trim(),
        "Email": _emailController.text.trim(),
        "SDT": _sdtController.text.trim(),
        "URLHinhAnh": _urlHinhAnhController.text.trim(),
        "NgayVaoLam": _ngayVaoLamController.text.trim(),
        "ChucVu": _chucVuController.text.trim(),
        "PhongBan": _phongBanController.text.trim(),
      };

      try {
        final response = await http.put(
          Uri.parse('$baseURL/nhanvien/${_maNVController.text.trim()}'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(updatedData),
        );

        final result = json.decode(response.body);
        if (response.statusCode == 200 && result['success'] == true) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const EditEmployeeSuccess()),
          );
        } else {
          _showErrorDialog(result['message'] ?? 'Đã xảy ra lỗi khi cập nhật.');
        }
      } catch (e) {
        _showErrorDialog('Lỗi kết nối: $e');
      }
    }
  }

  Future<void> deleteEmployee() async {
  final maNV = _maNVController.text.trim();
  final url = Uri.parse('$baseURL/nhanvien/$maNV');

  try {
    final response = await http.delete(url);
    if (response.statusCode != 200) {
      throw Exception('Xóa thất bại (mã: ${response.statusCode})');
    }
  } catch (e) {
    _showErrorDialog('❌ Lỗi khi xóa nhân viên: $e');
    rethrow; // Ngăn showDialog thành công nếu xảy ra lỗi
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
      backgroundColor: AppColors.white,
      appBar: CustomAppBarAdmin(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Text(
                  'THÔNG TIN NHÂN VIÊN',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.mainOrange,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 32),

                CustomInputField(
                  controller: _maNVController,
                  labelText: "Mã NV",
                  prefixIcon: Icons.perm_identity,
                  readOnly: true,
                  showToggleVisibility: false,
                ),
                const SizedBox(height: 16),

                CustomInputField(
                  controller: _hoTenController,
                  labelText: "Họ và tên",
                  prefixIcon: Icons.person,
                  showToggleVisibility: false,
                ),
                const SizedBox(height: 16),

                CustomInputField(
                  controller: _ngaySinhController,
                  labelText: "Ngày sinh",
                  prefixIcon: Icons.cake,
                  readOnly: true,
                  onTap: () => _selectDate(_ngaySinhController),
                  showToggleVisibility: false,
                ),
                const SizedBox(height: 16),

                CustomInputField(
                  controller: _ngayVaoLamController,
                  labelText: "Ngày vào làm",
                  prefixIcon: Icons.calendar_today,
                  readOnly: true,
                  onTap: () => _selectDate(_ngayVaoLamController),
                  showToggleVisibility: false,
                ),
                const SizedBox(height: 16),

                CustomInputField(
                  controller: _diaChiController,
                  labelText: "Địa chỉ",
                  prefixIcon: Icons.home,
                  showToggleVisibility: false,
                ),
                const SizedBox(height: 16),

                CustomInputField(
                  controller: _emailController,
                  labelText: "Email",
                  prefixIcon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  showToggleVisibility: false,
                ),
                const SizedBox(height: 16),

                CustomInputField(
                  controller: _sdtController,
                  labelText: "SĐT",
                  prefixIcon: Icons.phone,
                  keyboardType: TextInputType.phone,
                  showToggleVisibility: false,
                ),
                const SizedBox(height: 16),

                CustomInputField(
                  controller: _urlHinhAnhController,
                  labelText: "URL hình ảnh",
                  prefixIcon: Icons.image,
                  keyboardType: TextInputType.url,
                  showToggleVisibility: false,
                ),
                const SizedBox(height: 16),

                CustomInputField(
                  controller: _chucVuController,
                  labelText: "Chức vụ",
                  prefixIcon: Icons.work,
                  showToggleVisibility: false,
                ),
                const SizedBox(height: 16),

                CustomInputField(
                  controller: _phongBanController,
                  labelText: "Phòng ban",
                  prefixIcon: Icons.apartment,
                  showToggleVisibility: false,
                ),
                const SizedBox(height: 32),

                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 42,
                        child: EditActionButton(
                          onPressed: _submitForm,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ConfirmDeleteButton(
                        onConfirmDelete: deleteEmployee,
                        successTitle: 'Xóa thành công!',
                        successMessage: 'Khách hàng đã được xóa khỏi hệ thống.',
                        onSuccessClose: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => const EmployeeListScreen()),
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
      ),
    );
  }
}
