import 'package:flutter/material.dart';
import 'package:giao_dien_1/view/admin/station_admin/station_list.dart';
import 'package:giao_dien_1/widget/success.dart';

class AddStationSuccess extends StatelessWidget {
  const AddStationSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return const SuccessScreen(
      message: 'Thêm bến xe thành công',
      nextScreen: StationList(),
      routeName: '/station_list',
    );
  }
}