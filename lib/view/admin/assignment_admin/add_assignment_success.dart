import 'package:flutter/material.dart';
import 'package:giao_dien_1/view/admin/assignment_admin/assignment_list.dart';
import 'package:giao_dien_1/widget/success.dart';

class AddAssignmentSuccess extends StatelessWidget {
  const AddAssignmentSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return const SuccessScreen(
      message: 'Thêm phân công thành công',
      nextScreen: AssignmentList(),
      routeName: '/station_list',
    );
  }
}