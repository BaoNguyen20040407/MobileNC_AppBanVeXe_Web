import 'package:flutter/material.dart';
import 'package:giao_dien_1/config/config.dart';
import 'package:giao_dien_1/config/default.dart';
import 'package:giao_dien_1/widget/exit_button.dart';
import 'package:giao_dien_1/widget/appbar_admin.dart';
import 'package:giao_dien_1/widget/input_field.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:giao_dien_1/view/admin/station_admin/edit_station_success.dart';

class EditStation extends StatefulWidget {
  final Map<String, dynamic> station;
  const EditStation({super.key, required this.station});

  @override
  State<EditStation> createState() => _EditStationState();
}

class _EditStationState extends State<EditStation> {
  late TextEditingController _stationController;
  late TextEditingController _stationnameController;
  late TextEditingController _addressController;
  late TextEditingController _provinceController;

  @override
  void initState() {
    super.initState();
    // Khởi tạo controller với dữ liệu hiện tại
    _stationController = TextEditingController(text: widget.station['MaBX'] ?? '');
    _stationnameController = TextEditingController(text: widget.station['TenBX'] ?? '');
    _addressController = TextEditingController(text: widget.station['DiaChi'] ?? '');
    _provinceController = TextEditingController(text: widget.station['TinhThanh'] ?? '');
  }

  @override
  void dispose() {
    _stationController.dispose();
    _stationnameController.dispose();
    _addressController.dispose();
    _provinceController.dispose();
    super.dispose();
  }

  Future<void> updateStation() async {
  final maBX = _stationController.text;
  final tenBX = _stationnameController.text;
  final diaChi = _addressController.text;
  final tinhThanh = _provinceController.text;

  final url = Uri.parse('$baseURL/benxe/$maBX');

  final response = await http.put(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'TenBX': tenBX,
      'DiaChi': diaChi,
      'TinhThanh': tinhThanh,
    }),
  );

  if (response.statusCode == 200) {
    // ✅ Cập nhật thành công → chuyển trang
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => EditStationSuccess()),
    );
  } else {
    print('Lỗi: ${response.body}');
  }
}

Future<void> deleteStation() async {
  final maBX = _stationController.text;

  if (maBX.isEmpty) {
    print('Vui lòng nhập mã bến xe để xóa');
    return;
  }

  final url = Uri.parse('$baseURL/benxe/$maBX');

  final response = await http.delete(url);

  if (response.statusCode == 200) {
    print('Xóa thành công');
    // Có thể reset form hoặc thông báo UI
  } else {
    print('Lỗi xóa: ${response.body}');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBarAdmin(),
      body: SafeArea(
        child: SingleChildScrollView(
padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
        child: Column(
          children: [
            const Text(
              'THÔNG TIN BẾN XE',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.mainOrange,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 32),

            CustomInputField(
              controller: _stationController,
              labelText: "Mã bến xe",
              prefixIcon: Icons.tag,
              keyboardType: TextInputType.text,
              showToggleVisibility: false,
            ),

            const SizedBox(height: 16),

            CustomInputField(
              controller: _stationnameController,
              labelText: "Tên bến xe",
              prefixIcon: Icons.bus_alert,
              keyboardType: TextInputType.text,
              showToggleVisibility: false,
            ),

            const SizedBox(height: 16),

            CustomInputField(
              controller: _addressController,
              labelText: "Địa chỉ",
              prefixIcon: Icons.gps_fixed,
              keyboardType: TextInputType.text,
              showToggleVisibility: false,
            ),

            const SizedBox(height: 16),

            CustomInputField(
              controller: _provinceController,
              labelText: "Tỉnh/thành",
              prefixIcon: Icons.map_sharp,
              keyboardType: TextInputType.text,
              showToggleVisibility: false,
            ),

            const SizedBox(height: 32),

            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 42,
                    child: ElevatedButton(
                      onPressed: updateStation,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.greenDark,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        side: const BorderSide(color: AppColors.greenDark, width: 1.2),
                        elevation: 3,
                        shadowColor: AppColors.greenDark.withOpacity(0.2),
                      ).copyWith(
                        overlayColor: MaterialStateProperty.all(Colors.transparent),
                        surfaceTintColor: MaterialStateProperty.all(Colors.transparent),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.edit, color: Colors.white, size: 18),
                          SizedBox(width: 6),
                          Text(
                            'Sửa',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: SizedBox(
                    height: 42,
                    child: ElevatedButton(
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            backgroundColor: AppColors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            titlePadding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
                            contentPadding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
                            actionsPadding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                            title: const Text(
                              'Bạn có chắc không?',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                fontFamily: 'Inter',
                              ),
                            ),
                            content: const Text(
                              'Dữ liệu này có thể bị xóa',
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'Inter',
                                color: Colors.black87,
                              ),
                            ),
                            actionsAlignment: MainAxisAlignment.end,
                            actions: [
                              OutlinedButton(
                                style: ButtonStyle(
                                  side: MaterialStateProperty.all(
                                    const BorderSide(color: Colors.black),
                                  ),
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                  padding: MaterialStateProperty.all(
                                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                  ),
                                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                                  backgroundColor: MaterialStateProperty.all(Colors.white),
                                  foregroundColor: MaterialStateProperty.all(Colors.black),
                                ),
                                onPressed: () => Navigator.of(context).pop(false),
                                child: const Text(
                                  'Hủy',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                  elevation: 0,
                                ),
                                onPressed: () => Navigator.of(context).pop(true),
                                child: const Text(
                                  'Xóa',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Inter',
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );

                        if (confirm == true) {
                          await deleteStation();
                          await showDialog<void>(
                            context: context,
                            builder: (context) => AlertDialog(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              titlePadding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
                              contentPadding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
                              actionsPadding: const EdgeInsets.fromLTRB(24, 24, 16, 16),
                              title: const Text(
                                'Xóa thành công!',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Inter',
                                  color: Colors.black,
                                ),
                              ),
                              content: const Text(
                                'Dữ liệu đã được xóa khỏi hệ thống.',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Inter',
                                  color: Colors.black87,
                                ),
                              ),
                              actionsAlignment: MainAxisAlignment.end,
                              actions: [
                                ElevatedButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.mainOrange,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                    elevation: 0,
                                  ),
                                  child: const Text(
                                    'Đóng',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Inter',
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.red,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                        side: const BorderSide(color: AppColors.mainOrange, width: 1.2),
                        elevation: 3,
                        shadowColor: AppColors.mainOrange.withOpacity(0.2),
                      ).copyWith(
                        overlayColor: MaterialStateProperty.all(Colors.transparent),
                        surfaceTintColor: MaterialStateProperty.all(Colors.transparent),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.delete, color: Colors.white, size: 18),
                          SizedBox(width: 6),
                          Text(
                            'Xóa',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      ),
    );  
  }
}