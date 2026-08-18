import 'package:flutter/material.dart';
import 'package:giao_dien_1/config/default.dart';
import 'package:giao_dien_1/widget/appbar_profile.dart';
import 'package:giao_dien_1/widget/location_form.dart';
import 'package:giao_dien_1/model/saved_location.dart';

class AddLocationScreen extends StatelessWidget {
  const AddLocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softOrangeBackground,

      appBar: const AppBarProfile(
        title: 'THÊM ĐỊA ĐIỂM',
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
          child: Column(
            children: [
              // KHUNG THÊM ĐỊA ĐIỂM
              LocationForm(
                onSave: (type, address) {
                  final location = SavedLocation(
                    type: type,
                    name: type,
                    address: address,
                  );

                  Navigator.pop(context, location);
                },
              ),

              const SizedBox(height: 32),

              // HÌNH BÊN DƯỚI
              Center(
                child: Image.asset(
                  'assets/image/snapedit_1746841417483.png',
                  height: 300,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}