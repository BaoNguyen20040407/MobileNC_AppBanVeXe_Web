import 'package:flutter/material.dart';
import 'package:giao_dien_1/view/admin/employee_admin/employee_list.dart';
import 'package:giao_dien_1/widget/success.dart';

class EditEmployeeSuccess extends StatelessWidget {
  const EditEmployeeSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return SuccessScreen(
      message: 'Sửa thông tin nhân viên thành công',
      nextScreen: const EmployeeListScreen(),
      routeName: '/employee_list',
    );
  }
}