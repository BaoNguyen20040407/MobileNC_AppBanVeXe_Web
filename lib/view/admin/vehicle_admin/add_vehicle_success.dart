import 'package:flutter/material.dart';
import 'package:giao_dien_1/view/admin/vehicle_admin/vehicle_list.dart';
import 'package:giao_dien_1/widget/success.dart';

class AddVehicleSuccess extends StatelessWidget {
  const AddVehicleSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return const SuccessScreen(
      message: 'Thêm xe thành công',
      nextScreen: VehicleList(),
      routeName: '/vehicle_list',
    );
  }
}