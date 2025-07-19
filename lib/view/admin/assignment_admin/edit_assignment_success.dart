import 'package:flutter/material.dart';
import 'package:giao_dien_1/view/admin/assignment_admin/assignment_list.dart';
import 'package:giao_dien_1/widget/success.dart';

class EditAssignmentSuccess extends StatelessWidget {
  const EditAssignmentSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return SuccessScreen(
      message: 'Sửa thông tin phân công thành công',
      nextScreen: const AssignmentList(),
      routeName: '/station_list',
    );
  }
}