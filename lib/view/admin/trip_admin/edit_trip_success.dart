import 'package:flutter/material.dart';
import 'package:giao_dien_1/view/admin/trip_admin/trip_list.dart';
import 'package:giao_dien_1/widget/success.dart';

class EditTripSuccess extends StatelessWidget {
  const EditTripSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return SuccessScreen(
      message: 'Sửa thông tin bến xe thành công',
      nextScreen: const TripList(),
      routeName: '/station_list',
    );
  }
}