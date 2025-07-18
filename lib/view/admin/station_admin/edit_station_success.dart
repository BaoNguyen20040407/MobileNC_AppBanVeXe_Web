import 'package:flutter/material.dart';
import 'package:giao_dien_1/view/admin/station_admin/station_list.dart';
import 'package:giao_dien_1/widget/success.dart';

class EditStationSuccess extends StatelessWidget {
  const EditStationSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return SuccessScreen(
      message: 'Sửa thông tin bến xe thành công',
      nextScreen: const StationList(),
      routeName: '/station_list',
    );
  }
}