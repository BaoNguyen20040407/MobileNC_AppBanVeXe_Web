import 'dart:io';
import 'package:flutter/material.dart';
import 'package:giao_dien_1/view/admin/homeadmin.dart';
import 'package:giao_dien_1/view/admin/manage_people.dart';
import 'package:giao_dien_1/view/admin/manage_station.dart';
import 'package:giao_dien_1/view/admin/manage_trip.dart';
import 'package:giao_dien_1/view/auth/splash_screen.dart';
import 'package:giao_dien_1/view/profile/profile_screen.dart';
import 'package:giao_dien_1/view/support/support.dart';
import 'package:giao_dien_1/view/admin/homeadmin.dart';
import 'package:giao_dien_1/view/admin/manage_people.dart';
import 'package:giao_dien_1/view/admin/manage_station.dart';
import 'package:giao_dien_1/view/admin/manage_trip.dart';


void main() {
  runApp(/*const*/ MyApp());
}

//Phần màu xanh là để chạy từ đầu splash screen//
/*class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Nhà Xe Nam Hải',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: SplashScreen(),
    );
  }
}*/

//Còn phần không khóa này để chạy test thử trang admin//
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nhà xe Nam Hải - Admin',
      theme: ThemeData(primarySwatch: Colors.orange),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => HomeAdmin(),
        '/manage_people': (context) => ManagePeopleScreen(),
        '/manage_station': (context) => ManageStationScreen(),
        '/manage_trip': (context) => ManageTripScreen(),
      },
    );
  }
}
