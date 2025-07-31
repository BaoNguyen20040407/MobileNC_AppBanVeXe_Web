import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:giao_dien_1/config/config.dart';
import 'package:giao_dien_1/config/default.dart';
import 'package:giao_dien_1/widget/appbar_admin.dart';
import 'package:giao_dien_1/widget/input_field.dart';
import 'package:giao_dien_1/view/admin/account/account_admin/edit_account_admin_success.dart';
import 'package:giao_dien_1/view/admin/account/account_admin/account_admin_list.dart';
import 'package:giao_dien_1/widget/edit_action_button.dart';
import 'package:http/http.dart' as http;
import 'package:giao_dien_1/widget/confirm_delete_button.dart';

class EditAccountAdminScreen extends StatefulWidget {
  final Map<String, dynamic> accountData;

  const EditAccountAdminScreen({super.key, required this.accountData});

  @override
  State<EditAccountAdminScreen> createState() => _EditAccountAdminScreenState();
}

class _EditAccountAdminScreenState extends State<EditAccountAdminScreen> {
  late TextEditingController _maTKController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _maNVController; // MaNV
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _maTKController = TextEditingController(
      text: widget.accountData['MaTK'].toString(),
    );
    _emailController = TextEditingController(
      text: widget.accountData['TenDangNhapNV'],
    );
    _passwordController = TextEditingController(
      text: widget.accountData['Password'],
    );
    _maNVController = TextEditingController(text: widget.accountData['MaNV']);
  }

  @override
  void dispose() {
    _maTKController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _maNVController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
  if (_formKey.currentState!.validate()) {
    final updatedData = {
      'TenDangNhapNV': _emailController.text.trim(),
      'Password': _passwordController.text.trim(),
      'MaNV': _maNVController.text.trim(),
    };

    final maTK = _maTKController.text.trim();

    try {
      final url = Uri.parse('$baseURL/taikhoannv/$maTK');
      final response = await http.put(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(updatedData),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['success'] == true) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const EditAccountAdminSuccess()),
        );
      } else {
        _showErrorDialog(
          'Cập nhật thất bại',
          responseData['message'] ?? 'Lỗi cập nhật tài khoản.',
        );
      }
    } catch (e) {
      _showErrorDialog(
        'Lỗi kết nối',
        'Không thể kết nối đến máy chủ. Chi tiết: $e',
      );
    }
  }
}

void _showErrorDialog(String title, String message) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
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


  Future<void> deleteEmployeeAccount() async {
  final maTK = _maTKController.text.trim();

  if (maTK.isEmpty) {
    _showErrorDialog('Lỗi dữ liệu', '❌ Mã tài khoản không được để trống.');
    return;
  }

  final url = Uri.parse('$baseURL/taikhoannv/$maTK');

  try {
    final response = await http.delete(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['message'] == 'Xóa tài khoản thành công') {
        print('✅ Đã xóa tài khoản nhân viên $maTK');
        // Có thể gọi lại fetch danh sách hoặc quay về màn hình chính nếu cần
      } else {
        _showErrorDialog('Lỗi xóa tài khoản', '⚠️ ${data['error'] ?? "Không rõ lỗi."}');
      }
    } else {
      _showErrorDialog('Lỗi xóa tài khoản', '❌ Xóa thất bại (mã: ${response.statusCode})');
    }
  } catch (e) {
    _showErrorDialog('Lỗi kết nối', '❌ Không thể kết nối tới máy chủ: $e');
    rethrow;
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBarAdmin(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Text(
                  'TÀI KHOẢN NHÂN VIÊN',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.mainOrange,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 24),

                // MaTK (readonly)
                CustomInputField(
                  controller: _maTKController,
                  labelText: "Mã tài khoản",
                  prefixIcon: Icons.key,
                  readOnly: true,
                ),
                const SizedBox(height: 16),

                // Email
                CustomInputField(
                  controller: _emailController,
                  labelText: "Email",
                  prefixIcon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),

                // Password
                CustomInputField(
                  controller: _passwordController,
                  labelText: "Mật khẩu",
                  prefixIcon: Icons.lock,
                  obscureText: true,
                ),
                const SizedBox(height: 16),

                // MaKH
                // MaNV input (instead of MaKH)
                CustomInputField(
                  controller: _maNVController,
                  labelText: "Mã nhân viên",
                  prefixIcon: Icons.badge,
                ),

                const SizedBox(height: 32),

                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 42,
                        child: EditActionButton(onPressed: _submitForm),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ConfirmDeleteButton(
                        onConfirmDelete: deleteEmployeeAccount,
                        successTitle: 'Xóa thành công!',
                        successMessage: 'Tài khoản khách hàng đã được xóa khỏi hệ thống.',
                        onSuccessClose: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => const AccountStaffList()),
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
