import 'package:flutter/material.dart';
import 'package:giao_dien_1/view/admin/stop_admin/stop_list.dart';
import 'package:giao_dien_1/widget/success.dart';

class EditStopSuccess extends StatelessWidget {
  const EditStopSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return SuccessScreen(
      message: 'Sửa thông tin trạm thành công',
      nextScreen: const StopList(),
      routeName: '/station_list',
    );
  }
}