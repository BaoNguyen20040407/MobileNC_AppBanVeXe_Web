import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import 'package:giao_dien_1/widget/appbar_profile.dart';
import 'package:giao_dien_1/config/default.dart';
import 'package:giao_dien_1/view/location/add_location_screen.dart';
import 'package:giao_dien_1/model/saved_location.dart';
import 'package:giao_dien_1/view/location/saved_locations_screen.dart';
import 'package:giao_dien_1/config/default.dart';

class LocationPickerScreen extends StatefulWidget {
  const LocationPickerScreen({Key? key}) : super(key: key);

  @override
  State<LocationPickerScreen> createState() =>
      _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  GoogleMapController? _mapController;

  LatLng? _currentLatLng;

  String _currentAddress = 'Đang xác định địa chỉ...';
  String _selectedType = 'Nhà';

  // ============================================================
  // DANH SÁCH ĐỊA ĐIỂM ĐÃ LƯU
  // ============================================================

  final List<SavedLocation> _savedLocations = [];

  // true = hiện danh sách
  // false = chỉ hiện tiêu đề
  bool _showSavedLocations = true;

  // Chỉ hiển thị tối đa 3 địa điểm ở màn hình chính
  static const int _previewLimit = 3;

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  // ============================================================
  // LẤY VỊ TRÍ HIỆN TẠI
  // ============================================================

  Future<void> _determinePosition() async {
    final serviceEnabled =
        await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }

    LocationPermission permission =
        await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      if (!mounted) return;

      setState(() {
        _currentAddress = 'Không có quyền truy cập vị trí.';
      });

      return;
    }

    try {
      final position = await Geolocator.getCurrentPosition();

      final latLng = LatLng(
        position.latitude,
        position.longitude,
      );

      if (!mounted) return;

      setState(() {
        _currentLatLng = latLng;
      });

      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(
          latLng,
          16,
        ),
      );

      _getAddressFromLatLng(latLng);
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _currentAddress = 'Không thể lấy vị trí hiện tại.';
      });
    }
  }

  // ============================================================
  // LẤY ĐỊA CHỈ TỪ TỌA ĐỘ
  // ============================================================

  Future<void> _getAddressFromLatLng(
    LatLng latLng,
  ) async {
    try {
      final placemarks = await placemarkFromCoordinates(
        latLng.latitude,
        latLng.longitude,
      );

      if (placemarks.isEmpty) {
        if (!mounted) return;

        setState(() {
          _currentAddress = 'Không tìm thấy địa chỉ.';
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
          .where(
            (part) =>
                part != null &&
                part!.trim().isNotEmpty,
          )
          .join(', ');

      if (!mounted) return;

      setState(() {
        _currentAddress = address.isEmpty
            ? 'Không tìm thấy địa chỉ.'
            : address;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _currentAddress = 'Lỗi lấy địa chỉ.';
      });
    }
  }

  // ============================================================
  // GOOGLE MAP
  // ============================================================

  void _onMapCreated(
    GoogleMapController controller,
  ) {
    _mapController = controller;
  }

  // ============================================================
  // TẠO MARKER HIỆN TẠI
  // ============================================================

  Set<Marker> _buildMarkers() {
    if (_currentLatLng == null) {
      return {};
    }

    return {
      Marker(
        markerId: const MarkerId(
          'selected_location',
        ),
        position: _currentLatLng!,
        infoWindow: InfoWindow(
          title: _selectedType,
          snippet: _currentAddress,
        ),
      ),
    };
  }

  // ============================================================
  // XỬ LÝ KHI CHẠM BẢN ĐỒ
  // ============================================================

  Future<void> _onMapTap(
    LatLng position,
  ) async {
    setState(() {
      _currentLatLng = position;
    });

    await _getAddressFromLatLng(position);

    _mapController?.animateCamera(
      CameraUpdate.newLatLng(position),
    );
  }

  // ============================================================
  // MỞ MÀN HÌNH THÊM ĐỊA ĐIỂM
  // ============================================================

  Future<void> _openAddLocationScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            const AddLocationScreen(),
      ),
    );

    if (!mounted) return;

    if (result is SavedLocation) {
      setState(() {
        _savedLocations.add(result);

        _selectedType = result.type;

        if (result.address != null &&
            result.address!.trim().isNotEmpty) {
          _currentAddress = result.address!;
        }

        if (result.latitude != null &&
            result.longitude != null) {
          _currentLatLng = LatLng(
            result.latitude!,
            result.longitude!,
          );
        }

        // Tự mở danh sách sau khi thêm
        _showSavedLocations = true;
      });

      // Di chuyển bản đồ tới địa điểm vừa lưu
      if (result.latitude != null &&
          result.longitude != null) {
        final latLng = LatLng(
          result.latitude!,
          result.longitude!,
        );

        _mapController?.animateCamera(
          CameraUpdate.newLatLngZoom(
            latLng,
            16,
          ),
        );
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Đã lưu địa điểm "${result.type}"',
            style: const TextStyle(
              fontFamily: 'Inter',
            ),
          ),
        ),
      );
    }
  }

  // ============================================================
  // CHỌN ĐỊA ĐIỂM ĐÃ LƯU
  // ============================================================

  void _selectSavedLocation(
    SavedLocation location,
  ) {
    setState(() {
      _selectedType = location.type;

      if (location.address != null &&
          location.address!.trim().isNotEmpty) {
        _currentAddress = location.address!;
      }

      if (location.latitude != null &&
          location.longitude != null) {
        _currentLatLng = LatLng(
          location.latitude!,
          location.longitude!,
        );
      }
    });

    if (location.latitude != null &&
        location.longitude != null) {
      final latLng = LatLng(
        location.latitude!,
        location.longitude!,
      );

      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(
          latLng,
          16,
        ),
      );
    }
  }

  // ============================================================
  // MỞ DANH SÁCH ĐẦY ĐỦ
  // ============================================================

  Future<void> _openSavedLocationsScreen() async {
    final result = await Navigator.push<List<SavedLocation>>(
      context,
      MaterialPageRoute(
        builder: (_) => SavedLocationsScreen(
          locations: _savedLocations,
        ),
      ),
    );

    if (!mounted || result == null) return;

    setState(() {
      _savedLocations
        ..clear()
        ..addAll(result);
    });
  }

  // ============================================================
  // KHUNG CÁC ĐỊA ĐIỂM ĐÃ LƯU
  // ============================================================

  Widget _buildSavedLocations() {
    // Chưa có địa điểm thì không hiển thị
    if (_savedLocations.isEmpty) {
      return const SizedBox.shrink();
    }

    // Chỉ hiển thị tối đa 3 địa điểm ở màn hình chính
    final previewLocations =
        _savedLocations.take(_previewLimit).toList();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,

        // BO GÓC GIỐNG Ô ĐỊA CHỈ
        borderRadius: BorderRadius.circular(12),

        // GIỮ VIỀN CAM BÊN NGOÀI
        border: Border.all(
          color: AppColors.mainOrange,
        ),
      ),
      child: Column(
        children: [
          // ==================================================
          // HEADER
          // ==================================================

          Padding(
            padding: const EdgeInsets.fromLTRB(
              12,
              4,
              4,
              4,
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.location_on,
                  color: AppColors.mainOrange,
                  size: 21,
                ),

                const SizedBox(width: 8),

                const Expanded(
                  child: Text(
                    'CÁC ĐỊA ĐIỂM ĐÃ LƯU',
                    style: TextStyle(
                      color: AppColors.greenDark,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),

                // ==================================================
                // NÚT ẨN / HIỆN
                // ==================================================

                Tooltip(
                  message: _showSavedLocations
                      ? 'Ẩn danh sách'
                      : 'Hiện danh sách',
                  textStyle: const TextStyle(
                    fontFamily: 'Inter',
                    color: AppColors.white,
                    fontSize: 14,
                  ),
                  child: IconButton(
                    visualDensity: VisualDensity.compact,
                    onPressed: () {
                      setState(() {
                        _showSavedLocations = !_showSavedLocations;
                      });
                    },
                    icon: Icon(
                      _showSavedLocations
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: AppColors.mainOrange,
                    ),
                  ),
                ),

                // ==================================================
                // NÚT 3 CHẤM
                // ==================================================

                Tooltip(
                  message: 'Xem tất cả',
                  textStyle: const TextStyle(
                    fontFamily: 'Inter',
                    color: AppColors.white,
                    fontSize: 14,
                  ),
                  child: IconButton(
                    visualDensity: VisualDensity.compact,
                    onPressed: _openSavedLocationsScreen,
                    icon: const Icon(
                      Icons.more_vert,
                      color: AppColors.mainOrange,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ==================================================
          // DANH SÁCH
          // ==================================================

          if (_showSavedLocations)
            ...previewLocations.map(
              (location) {
                return InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () {
                    _selectSavedLocation(location);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 12,
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: AppColors.mainOrange,
                          size: 22,
                        ),

                        const SizedBox(width: 8),

                        Expanded(
                          child: Text(
                            location.type,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 15,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),

                        const Icon(
                          Icons.chevron_right,
                          color: AppColors.grey600,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  // ============================================================
  // Ô ĐỊA CHỈ
  // ============================================================

  Widget _buildAddressBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.mainOrange,
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.location_on,
            color: AppColors.mainOrange,
          ),

          const SizedBox(width: 8),

          Expanded(
            child: Text(
              _currentAddress,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: 'Inter',
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // NÚT THÊM ĐỊA ĐIỂM
  // ============================================================

  Widget _buildAddLocationButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton.icon(
        onPressed: _openAddLocationScreen,
        icon: const Icon(
          Icons.add_location_alt,
          color: AppColors.white,
        ),
        label: const Text(
          'Thêm địa điểm',
          style: TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
            fontFamily: 'Inter',
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.mainOrange,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          AppColors.softOrangeBackground,

      appBar: AppBarProfile(
        title: 'ĐỊA ĐIỂM ĐÃ LƯU',
        onBack: () {
          Navigator.pop(context, _savedLocations);
        },
      ),

      body: _currentLatLng == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.fromLTRB(
                24,
                24,
                24,
                16,
              ),
              child: Column(
                children: [
                  // ==================================================
                  // BẢN ĐỒ
                  // ==================================================

                  Expanded(
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(16),
                      child: GoogleMap(
                        onMapCreated:
                            _onMapCreated,

                        initialCameraPosition:
                            CameraPosition(
                          target:
                              _currentLatLng!,
                          zoom: 16,
                        ),

                        myLocationEnabled: true,

                        myLocationButtonEnabled:
                            true,

                        markers:
                            _buildMarkers(),

                        onTap: _onMapTap,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ==================================================
                  // Ô ĐỊA CHỈ
                  // ==================================================

                  _buildAddressBox(),

                  const SizedBox(height: 12),

                  // ==================================================
                  // CÁC ĐỊA ĐIỂM ĐÃ LƯU
                  // ==================================================

                  _buildSavedLocations(),

                  if (_savedLocations.isNotEmpty)
                    const SizedBox(height: 12),

                  // ==================================================
                  // THÊM ĐỊA ĐIỂM
                  // ==================================================

                  _buildAddLocationButton(),
                ],
              ),
            ),
    );
  }
}