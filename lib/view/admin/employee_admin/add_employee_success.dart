import 'package:flutter/material.dart';
import 'package:giao_dien_1/view/admin/employee_admin/employee_list.dart';
import 'package:giao_dien_1/widget/success.dart';

class AddEmployeeSuccess extends StatelessWidget {
  const AddEmployeeSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return const SuccessScreen(
      message: 'Thêm nhân viên thành công',
      nextScreen: EmployeeListScreen(),
      routeName: '/nhân viên',
    );
  }
}
