import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:giao_dien_1/config/default.dart';
import 'package:giao_dien_1/widget/appbar_admin.dart';
import 'package:giao_dien_1/widget/exit_button.dart';
import 'package:giao_dien_1/widget/input_field.dart';
import 'package:giao_dien_1/view/admin/account/account_admin/add_account_admin_success.dart';
import 'package:giao_dien_1/widget/create_button.dart';

class AddEmployeeAccountScreen extends StatefulWidget {
  const AddEmployeeAccountScreen({super.key});

  @override
  State<AddEmployeeAccountScreen> createState() => _AddEmployeeAccountScreenState();
}

class _AddEmployeeAccountScreenState extends State<AddEmployeeAccountScreen> {
  final TextEditingController _idController = TextEditingController(); // MaTK
  final TextEditingController _usernameController = TextEditingController(); // TenDangNhapNV
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _employeeIdController = TextEditingController(); // MaNV

  bool _isLoading = false;

  Future<void> _handleSubmit() async {
    final url = Uri.parse('http://10.0.2.2:3000/taikhoannv');

    final data = {
      "MaTK": _idController.text.trim(),
      "TenDangNhapNV": _usernameController.text.trim(),
      "Password": _passwordController.text.trim(),
      "MaNV": _employeeIdController.text.trim(),
    };

    if (data.values.any((value) => value.isEmpty)) {
      _showDialog("Vui lòng điền đầy đủ thông tin.");
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['success'] == true) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AddAccountAdminSuccess()),
        );
      } else {
        _showDialog(responseData['message'] ?? "Tạo tài khoản thất bại.");
      }
    } catch (e) {
      _showDialog("Lỗi kết nối đến máy chủ.");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Thông báo"),
        content: Text(message),
        actions: [
          TextButton(
            child: const Text("Đóng"),
            onPressed: () => Navigator.of(context).pop(),
          )
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
                  'THÊM TÀI KHOẢN NHÂN VIÊN',
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
                labelText: "Mã tài khoản",
                prefixIcon: Icons.vpn_key,
                keyboardType: TextInputType.text,
                showToggleVisibility: false,
              ),
              const SizedBox(height: 16),

              CustomInputField(
                controller: _usernameController,
                labelText: "Tên đăng nhập",
                prefixIcon: Icons.person,
                keyboardType: TextInputType.text,
                showToggleVisibility: false,
              ),
              const SizedBox(height: 16),

              CustomInputField(
                controller: _passwordController,
                labelText: "Mật khẩu",
                prefixIcon: Icons.lock,
                keyboardType: TextInputType.visiblePassword,
                showToggleVisibility: true,
              ),
              const SizedBox(height: 16),

              CustomInputField(
                controller: _employeeIdController,
                labelText: "Mã nhân viên",
                prefixIcon: Icons.badge,
                keyboardType: TextInputType.text,
                showToggleVisibility: false,
              ),
              const SizedBox(height: 32),

              Row(
                children: [
                  Expanded(
                    child: _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : CreateButton(onPressed: _handleSubmit),
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
