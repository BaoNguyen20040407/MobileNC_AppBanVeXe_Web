import 'package:flutter/material.dart';
import 'package:giao_dien_1/view/admin/account/account_admin/account_admin_list.dart';
import 'package:giao_dien_1/widget/success.dart';

class AddAccountAdminSuccess extends StatelessWidget {
  const AddAccountAdminSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return SuccessScreen(
      message: 'Thêm tài khoản nhân viên\nthành công',
      nextScreen: AccountStaffList(),
      routeName: '/tài khoản nhân viên',
    );
  }
}