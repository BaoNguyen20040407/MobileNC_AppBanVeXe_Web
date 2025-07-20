import 'package:flutter/material.dart';
import 'package:giao_dien_1/view/admin/vehicle_admin/vehicle_list.dart';
import 'package:giao_dien_1/widget/success.dart';

class EditVehicleSuccess extends StatelessWidget {
  const EditVehicleSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return SuccessScreen(
      message: 'Sửa thông tin xe thành công',
      nextScreen: const VehicleList(),
      routeName: '/vehicle_list',
    );
  }
}