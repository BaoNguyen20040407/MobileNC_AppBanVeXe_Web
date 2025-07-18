import 'package:flutter/material.dart';
import 'package:giao_dien_1/config/default.dart';
import 'package:giao_dien_1/widget/appbar_admin.dart';
import 'package:giao_dien_1/widget/exit_button.dart';
import 'package:giao_dien_1/widget/input_field.dart';
import 'package:intl/intl.dart';
import 'package:giao_dien_1/view/admin/employee_admin/add_employee_success.dart';
import 'package:giao_dien_1/widget/create_button.dart';

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

  void _selectDate(TextEditingController controller) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        controller.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void _handleSubmit() {
    print('Mã NV: ${_idController.text}');
    print('Họ tên: ${_nameController.text}');
    print('Ngày sinh: ${_dobController.text}');
    print('Địa chỉ: ${_addressController.text}');
    print('Email: ${_emailController.text}');
    print('SĐT: ${_phoneController.text}');
    print('URL ảnh: ${_imageUrlController.text}');
    print('Ngày vào làm: ${_joinDateController.text}');
    print('Chức vụ: ${_positionController.text}');
    print('Phòng ban: ${_departmentController.text}');
    // TODO: Gọi API thêm nhân viên

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddEmployeeSuccess()),
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

              CustomInputField(
                controller: _idController,
                labelText: "Mã nhân viên",
                prefixIcon: Icons.perm_identity,
                keyboardType: TextInputType.text,
                showToggleVisibility: false,
              ),
              const SizedBox(height: 16),

              CustomInputField(
                controller: _nameController,
                labelText: "Họ và tên",
                prefixIcon: Icons.person,
                keyboardType: TextInputType.name,
                showToggleVisibility: false,
              ),
              const SizedBox(height: 16),

              CustomInputField(
                controller: _dobController,
                labelText: "Ngày sinh",
                prefixIcon: Icons.cake,
                keyboardType: TextInputType.datetime,
                showToggleVisibility: false,
                readOnly: true,
                onTap: () => _selectDate(_dobController),
              ),
              const SizedBox(height: 16),

              CustomInputField(
                controller: _addressController,
                labelText: "Địa chỉ",
                prefixIcon: Icons.location_on,
                keyboardType: TextInputType.text,
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
                controller: _phoneController,
                labelText: "Số điện thoại",
                prefixIcon: Icons.phone,
                keyboardType: TextInputType.phone,
                showToggleVisibility: false,
              ),
              const SizedBox(height: 16),

              CustomInputField(
                controller: _imageUrlController,
                labelText: "URL hình ảnh",
                prefixIcon: Icons.image,
                keyboardType: TextInputType.url,
                showToggleVisibility: false,
              ),
              const SizedBox(height: 16),

              CustomInputField(
                controller: _joinDateController,
                labelText: "Ngày vào làm",
                prefixIcon: Icons.calendar_today,
                keyboardType: TextInputType.datetime,
                showToggleVisibility: false,
                readOnly: true,
                onTap: () => _selectDate(_joinDateController),
              ),
              const SizedBox(height: 16),

              CustomInputField(
                controller: _positionController,
                labelText: "Chức vụ",
                prefixIcon: Icons.work,
                keyboardType: TextInputType.text,
                showToggleVisibility: false,
              ),
              const SizedBox(height: 16),

              CustomInputField(
                controller: _departmentController,
                labelText: "Phòng ban",
                prefixIcon: Icons.apartment,
                keyboardType: TextInputType.text,
                showToggleVisibility: false,
              ),
              const SizedBox(height: 32),

              Row(
                children: [
                  Expanded(
                    child: CreateButton(onPressed: _handleSubmit),
                  ),
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