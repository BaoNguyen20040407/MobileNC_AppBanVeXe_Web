import 'package:flutter/material.dart';
import 'package:giao_dien_1/view/admin/account/account_admin/account_admin_list.dart';
import 'package:giao_dien_1/widget/success.dart'; 

class EditAccountAdminSuccess extends StatelessWidget {
  const EditAccountAdminSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return SuccessScreen(
      message: 'Sửa thông tin tài khoản nhân viên\nthành công',
      nextScreen: const AccountStaffList(),
      routeName: '/account_staff_list',
    );
  }
}
