import 'package:flutter/material.dart';
import 'package:giao_dien_1/config/default.dart';
import 'package:giao_dien_1/model/trip.dart';

class TripRouteLabel extends StatelessWidget {
  final Trip trip;

  const TripRouteLabel({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '${trip.diemDi.toUpperCase()} - ${trip.diemDen.toUpperCase()}',
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.mainOrange,
          fontFamily: 'Inter',
        ),
      ),
    );
  }
}
