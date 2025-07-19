import 'package:flutter/material.dart';
import 'package:giao_dien_1/view/admin/stop_admin/stop_list.dart';
import 'package:giao_dien_1/widget/success.dart';

class AddStopSuccess extends StatelessWidget {
  const AddStopSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return const SuccessScreen(
      message: 'Thêm trạm thành công',
      nextScreen: StopList(),
      routeName: '/station_list',
    );
  }
}