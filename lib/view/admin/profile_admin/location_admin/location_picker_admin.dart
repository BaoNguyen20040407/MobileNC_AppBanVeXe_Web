import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:giao_dien_1/widget/appbar_profile.dart';
import 'package:giao_dien_1/config/default.dart';

class LocationPickerAdminScreen extends StatefulWidget {
  const LocationPickerAdminScreen({Key? key}) : super(key: key);

  @override
  State<LocationPickerAdminScreen> createState() => _LocationPickerAdminScreenState();
}

class _LocationPickerAdminScreenState extends State<LocationPickerAdminScreen> {
  GoogleMapController? _mapController;
  LatLng? _currentLatLng;
  String _currentAddress = 'Đang xác định địa chỉ...';

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) return;

    final position = await Geolocator.getCurrentPosition();
    final latLng = LatLng(position.latitude, position.longitude);

    setState(() {
      _currentLatLng = latLng;
    });

    _mapController?.animateCamera(CameraUpdate.newLatLngZoom(latLng, 16));
    _getAddressFromLatLng(latLng);
  }

  Future<void> _getAddressFromLatLng(LatLng latLng) async {
  try {
    final placemarks = await placemarkFromCoordinates(
      latLng.latitude,
      latLng.longitude,
    );

    if (placemarks.isEmpty) {
      setState(() {
        _currentAddress = 'Không tìm thấy địa chỉ.';
      });
      return;
    }

    final place = placemarks.first;
    final address =
        '${place.name ?? ''}, ${place.street ?? ''}, ${place.locality ?? ''}, ${place.administrativeArea ?? ''}';

    setState(() {
      _currentAddress = address;
    });
  } catch (e) {
  }
}


  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softOrangeBackground,
      appBar: const AppBarProfile(title: 'ĐỊA CHỈ CỦA BẠN'),
      body: _currentLatLng == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
              child: Column(
                children: [
                  /// Bản đồ hiển thị
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: GoogleMap(
                        onMapCreated: _onMapCreated,
                        initialCameraPosition: CameraPosition(
                          target: _currentLatLng!,
                          zoom: 16,
                        ),
                        myLocationEnabled: true,
                        myLocationButtonEnabled: true,
                        markers: {
                          Marker(
                            markerId: const MarkerId('current_location'),
                            position: _currentLatLng!,
                          ),
                        },
                        onTap: (position) {
                          setState(() {
                            _currentLatLng = position;
                            _getAddressFromLatLng(position);
                          });
                          _mapController?.animateCamera(
                            CameraUpdate.newLatLng(position),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
    );
  }
}
