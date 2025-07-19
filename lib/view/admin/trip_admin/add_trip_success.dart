import 'package:flutter/material.dart';
import 'package:giao_dien_1/view/admin/trip_admin/trip_list.dart';
import 'package:giao_dien_1/widget/success.dart';

class AddTripSuccess extends StatelessWidget {
  const AddTripSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return const SuccessScreen(
      message: 'Thêm chuyến xe thành công',
      nextScreen: TripList(),
      routeName: '/station_list',
    );
  }
}