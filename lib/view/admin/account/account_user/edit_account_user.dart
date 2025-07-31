import 'package:flutter/material.dart';
import 'package:giao_dien_1/config/config.dart';
import 'package:giao_dien_1/config/default.dart';
import 'package:giao_dien_1/view/admin/account/account_user/account_user_list.dart';
import 'package:giao_dien_1/widget/appbar_admin.dart';
import 'package:giao_dien_1/widget/input_field.dart';
import 'package:giao_dien_1/view/admin/account/account_user/edit_account_user_success.dart';
import 'package:giao_dien_1/widget/edit_action_button.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:giao_dien_1/widget/confirm_delete_button.dart';

class EditCustomerAccountScreen extends StatefulWidget {
  final Map<String, dynamic> accountData;

  const EditCustomerAccountScreen({super.key, required this.accountData});

  @override
  State<EditCustomerAccountScreen> createState() => _EditCustomerAccountScreenState();
}

class _EditCustomerAccountScreenState extends State<EditCustomerAccountScreen> {
  late TextEditingController _maTKController;
late TextEditingController _tenDangNhapController;
// replace usage of _emailController with _tenDangNhapController

  late TextEditingController _passwordController;
  late TextEditingController _maKHController;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _maTKController = TextEditingController(text: widget.accountData['MaTK'].toString());
    _tenDangNhapController = TextEditingController(text: widget.accountData['TenDangNhapKH']);
    _passwordController = TextEditingController(text: widget.accountData['Password']);
    _maKHController = TextEditingController(text: widget.accountData['MaKH']);
  }

  @override
  void dispose() {
    _maTKController.dispose();
    _tenDangNhapController.dispose();
    _passwordController.dispose();
    _maKHController.dispose();
    super.dispose();
  }

void _submitForm() async {
  if (_formKey.currentState!.validate()) {
    final maTK = _maTKController.text.trim();
    final url = Uri.parse('$baseURL/taikhoankh/$maTK');

    final body = {
      'TenDangNhapKH': _tenDangNhapController.text.trim(),
      'Password': _passwordController.text.trim(),
      'MaKH': _maKHController.text.trim(),
    };

    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        // Success
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const EditAccountUserSuccess()),
        );
      } else {
        final error = jsonDecode(response.body)['error'] ?? 'Lỗi không xác định';
        _showErrorDialog('Cập nhật thất bại', error);
      }
    } catch (e) {
      _showErrorDialog('Lỗi kết nối', e.toString());
    }
  }
}
void _showErrorDialog(String title, String message) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Đóng'),
        ),
      ],
    ),
  );
}

Future<void> deleteCustomerAccount() async {
  final maTK = _maTKController.text.trim();

  if (maTK.isEmpty) {
    _showErrorDialog('Lỗi dữ liệu', '❌ Mã tài khoản không được để trống.');
    return;
  }

  final url = Uri.parse('$baseURL/taikhoankh/$maTK');

  try {
    final response = await http.delete(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['message'] == 'Xóa tài khoản thành công') {
        print('✅ Đã xóa tài khoản $maTK');
        // Gọi fetch lại dữ liệu nếu cần
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
                  'TÀI KHOẢN KHÁCH HÀNG',
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
                  controller: _tenDangNhapController,
                  labelText: "Ten Dang Nhap",
                  prefixIcon: Icons.email,
                  keyboardType: TextInputType.text,
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
                CustomInputField(
                  controller: _maKHController,
                  labelText: "Mã khách hàng",
                  prefixIcon: Icons.person,
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
                        onConfirmDelete: deleteCustomerAccount,
                        successTitle: 'Xóa thành công!',
                        successMessage: 'Tài khoản khách hàng đã được xóa khỏi hệ thống.',
                        onSuccessClose: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => const AccountUserList()),
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