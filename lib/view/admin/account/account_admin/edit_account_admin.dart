import 'package:flutter/material.dart';
import 'package:giao_dien_1/config/default.dart';
import 'package:giao_dien_1/widget/appbar_admin.dart';
import 'package:giao_dien_1/widget/input_field.dart';
import 'package:giao_dien_1/view/admin/account/account_admin/edit_account_admin_success.dart';
import 'package:giao_dien_1/view/admin/account/account_admin/account_admin_list.dart';
import 'package:giao_dien_1/widget/edit_action_button.dart';

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
  late TextEditingController _maKHController;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _maTKController = TextEditingController(text: widget.accountData['MaTK'].toString());
    _emailController = TextEditingController(text: widget.accountData['Email']);
    _passwordController = TextEditingController(text: widget.accountData['Password']);
    _maKHController = TextEditingController(text: widget.accountData['MaKH']);
  }

  @override
  void dispose() {
    _maTKController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _maKHController.dispose();
    super.dispose();
  }

  void _submitForm() {
  if (_formKey.currentState!.validate()) {
    final updatedData = {
      'MaTK': _maTKController.text.trim(),
      'Email': _emailController.text.trim(),
      'Password': _passwordController.text.trim(),
      'MaKH': _maKHController.text.trim(),
    };

    // Gửi API cập nhật ở đây nếu cần...

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditAccountAdminSuccess(),
      ),
    );
  }
}


  void _confirmDelete() async {
  final confirm = await showDialog<bool>(
    context: context,
    builder: (_) => AlertDialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      titlePadding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
      contentPadding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
      actionsPadding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
      title: const Text(
        'Bạn có chắc không?',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          fontFamily: 'Inter',
        ),
      ),
      content: Text(
        'Tài khoản "${_maTKController.text}" sẽ bị xóa khỏi hệ thống.',
        style: const TextStyle(
          fontSize: 14,
          fontFamily: 'Inter',
          color: Colors.black87,
        ),
      ),
      actionsAlignment: MainAxisAlignment.end,
      actions: [
        OutlinedButton(
          style: ButtonStyle(
            side: MaterialStateProperty.all(const BorderSide(color: Colors.black)),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            padding: MaterialStateProperty.all(
              const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            backgroundColor: MaterialStateProperty.all(Colors.white),
            foregroundColor: MaterialStateProperty.all(Colors.black),
          ),
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text(
            'Hủy',
            style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Inter'),
          ),
        ),
        const SizedBox(width: 12),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            elevation: 0,
          ),
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text(
            'Xóa',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'Inter',
              color: Colors.white,
            ),
          ),
        ),
      ],
    ),
  );

  if (confirm == true) {
    await showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        titlePadding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
        contentPadding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
        actionsPadding: const EdgeInsets.fromLTRB(24, 24, 16, 16),
        title: const Text(
          'Xóa thành công!',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'Inter',
            color: Colors.black,
          ),
        ),
        content: const Text(
          'Tài khoản đã được xóa khỏi hệ thống.',
          style: TextStyle(fontSize: 14, fontFamily: 'Inter', color: Colors.black87),
        ),
        actionsAlignment: MainAxisAlignment.end,
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(); // Đóng AlertDialog
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => AccountStaffList()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              elevation: 0,
            ),
            child: const Text(
              'Đóng',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'Inter',
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
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
                      child: SizedBox(
                        height: 42,
                        child: ElevatedButton(
                          onPressed: _confirmDelete,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.red,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            side: const BorderSide(color: AppColors.red, width: 1.2),
                            elevation: 3,
                            shadowColor: AppColors.red.withOpacity(0.2),
                          ).copyWith(
                            overlayColor: MaterialStateProperty.all(Colors.transparent),
                            surfaceTintColor: MaterialStateProperty.all(Colors.transparent),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.delete, color: Colors.white, size: 18),
                              SizedBox(width: 6),
                              Text(
                                'Xóa',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ],
                          ),
                        ),
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