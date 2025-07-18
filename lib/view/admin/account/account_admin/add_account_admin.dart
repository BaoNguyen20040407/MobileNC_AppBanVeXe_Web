import 'package:flutter/material.dart';
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
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _employeeIdController = TextEditingController();

  void _handleSubmit() {
    print('Mã tài khoản: ${_idController.text}');
    print('Email: ${_emailController.text}');
    print('Password: ${_passwordController.text}');
    print('Mã nhân viên: ${_employeeIdController.text}');
    // TODO: Gọi API thêm tài khoản nhân viên

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddAccountAdminSuccess()),
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
                keyboardType: TextInputType.number,
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
                prefixIcon: Icons.perm_identity,
                keyboardType: TextInputType.text,
                showToggleVisibility: false,
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
