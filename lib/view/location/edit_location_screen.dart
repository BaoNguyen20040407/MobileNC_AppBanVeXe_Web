import 'package:flutter/material.dart';
import 'package:giao_dien_1/config/default.dart';
import 'package:giao_dien_1/widget/appbar_profile.dart';
import 'package:giao_dien_1/widget/location_form.dart';
import 'package:giao_dien_1/model/saved_location.dart';

class EditLocationScreen extends StatelessWidget {
  final SavedLocation location;

  const EditLocationScreen({
    super.key,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softOrangeBackground,

      appBar: const AppBarProfile(
        title: 'SỬA ĐỊA ĐIỂM'
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
          child: Column(
            children: [
              LocationForm(
                isEdit: true,
                initialType: location.type,
                initialAddress: location.address,

                onSave: (type, address) {
                  final updatedLocation = SavedLocation(
                    type: type, 
                    name: type,
                    address: address,
                    latitude: location.latitude,
                    longitude: location.longitude
                  );

                  Navigator.pop(
                    context,
                    updatedLocation,
                  );
                },
              ),

              const SizedBox(height: 32),

              Center(
                child: Image.asset(
                  'assets/image/snapedit_1746841417483.png',
                  height: 300,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          )
        ),
      ),
        
    );
  }
}