import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:giao_dien_1/widget/appbar_profile.dart';
import 'package:giao_dien_1/config/default.dart';

class LocationPickerScreen extends StatefulWidget {
  const LocationPickerScreen({Key? key}) : super(key: key);

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  GoogleMapController? _mapController;
  LatLng? _currentLatLng;
  String _currentAddress = "Đang xác định địa chỉ...";
  String _selectedType = "Nhà";

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

    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(latLng, 16),
    );

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
          _currentAddress = "Không tìm thấy địa chỉ.";
        });
        return;
      }

      final place = placemarks.first;

      final parts = [
        place.name,
        place.street,
        place.subAdministrativeArea,
        place.locality,
        place.administrativeArea,
      ];

      final address = parts
          .where((part) => part != null && part!.isNotEmpty)
          .join(", ");

      setState(() {
        _currentAddress = address;
      });
    } catch (e) {
      setState(() {
        _currentAddress = "Lỗi lấy địa chỉ.";
      });
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _saveLocation() {
    print("Địa chỉ: $_currentAddress");
    print("Loại: $_selectedType");

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Đã lưu $_selectedType"),
      ),
    );
  }

  Widget _buildTypeButton(String type, IconData icon) {
    final isSelected = _selectedType == type;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedType = type;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.orange : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.orange),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : Colors.orange,
              ),
              const SizedBox(width: 8),
              Text(
                type,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softOrangeBackground,
      appBar: const AppBarProfile(title: 'ĐỊA CHỈ CỦA BẠN'),
      body: _currentLatLng == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
              child: Column(
                children: [

                  /// MAP
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
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
                          });

                          _getAddressFromLatLng(position);

                          _mapController?.animateCamera(
                            CameraUpdate.newLatLng(position),
                          );
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// Ô địa chỉ
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.orange),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.location_on,
                            color: Colors.orange),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _currentAddress,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
    );
  }
}
