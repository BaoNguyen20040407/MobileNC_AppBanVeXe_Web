import 'package:flutter/material.dart';
import 'package:giao_dien_1/config/config.dart';
import 'package:giao_dien_1/config/default.dart';
import 'package:giao_dien_1/view/admin/stop_admin/stop_list.dart';
import 'package:giao_dien_1/widget/exit_button.dart';
import 'package:giao_dien_1/widget/appbar_admin.dart';
import 'package:giao_dien_1/widget/input_field.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:giao_dien_1/widget/edit_action_button.dart';
import 'package:giao_dien_1/view/admin/stop_admin/stop_list.dart';
import 'package:giao_dien_1/view/admin/stop_admin/edit_stop_success.dart';

class EditStop extends StatefulWidget {
  final Map<String, dynamic> stop;
  const EditStop({super.key, required this.stop});

  @override
  State<EditStop> createState() => _EditStopState();
}

class _EditStopState extends State<EditStop> {
  late TextEditingController _thuTuController;
  late TextEditingController _diemDungController;
  late TextEditingController _thoiGianDenController;
  late TextEditingController _thoiGianDiController;

  List<String> maCXList = [];
  String? selectedMaCX;

  @override
  void initState() {
    super.initState();
    selectedMaCX = widget.stop['MaCX'] ?? '';
    _thuTuController = TextEditingController(text: widget.stop['ThuTu'].toString());
    _diemDungController = TextEditingController(text: widget.stop['DiemDung'] ?? '');
    _thoiGianDenController = TextEditingController(text: widget.stop['ThoiGianDen'] ?? '');
    _thoiGianDiController = TextEditingController(text: widget.stop['ThoiGianDi'] ?? '');

    fetchMaChuyenXe();
  }

  Future<void> fetchMaChuyenXe() async {
    final url = Uri.parse('$baseURL/chuyenxe');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        maCXList = data.map((item) => item['MaCX'].toString()).toList();
      });
    } else {
      print('Lỗi khi tải danh sách chuyến xe: ${response.body}');
    }
  }

  Future<void> updateTransfer() async {
    final maCX = selectedMaCX;
    final thuTu = _thuTuController.text;
    final url = Uri.parse('$baseURL/trungchuyen/$maCX/$thuTu');

    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'DiemDung': _diemDungController.text,
        'ThoiGianDen': _thoiGianDenController.text,
        'ThoiGianDi': _thoiGianDiController.text,
      }),
    );

    if (response.statusCode == 200) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const EditStopSuccess()),
      );
    } else {
      print('Lỗi cập nhật: ${response.body}');
    }
  }

  Future<void> deleteTransfer() async {
    final maCX = selectedMaCX;
    final thuTu = _thuTuController.text;
    final url = Uri.parse('$baseURL/trungchuyen/$maCX/$thuTu');

    final response = await http.delete(url);

    if (response.statusCode == 200) {
      print('Xóa thành công');
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
                'THÔNG TIN TRUNG CHUYỂN',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.mainOrange,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 32),

              DropdownButtonFormField<String>(
                value: selectedMaCX,
                decoration: InputDecoration(
                  labelText: 'Mã chuyến xe',
                  prefixIcon: const Icon(Icons.directions_bus),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                items: maCXList.map((maCX) {
                  return DropdownMenuItem<String>(
                    value: maCX,
                    child: Text(maCX),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedMaCX = value;
                  });
                },
              ),
              const SizedBox(height: 16),

              CustomInputField(controller: _thuTuController, labelText: "Thứ tự", prefixIcon: Icons.format_list_numbered, keyboardType: TextInputType.number, showToggleVisibility: false),
              const SizedBox(height: 16),
              CustomInputField(controller: _diemDungController, labelText: "Điểm dừng", prefixIcon: Icons.location_on, showToggleVisibility: false),
              const SizedBox(height: 16),
              CustomInputField(controller: _thoiGianDenController, labelText: "Thời gian đến", prefixIcon: Icons.access_time, showToggleVisibility: false),
              const SizedBox(height: 16),
              CustomInputField(controller: _thoiGianDiController, labelText: "Thời gian đi", prefixIcon: Icons.schedule, showToggleVisibility: false),
              const SizedBox(height: 32),

              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 42,
                      child: EditActionButton(onPressed: updateTransfer),
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
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              title: const Text('Bạn có chắc không?'),
                              content: const Text('Dữ liệu này có thể bị xóa'),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Hủy')),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text('Xóa'),
                                ),
                              ],
                            ),
                          );
                          if (confirm == true) {
                            await deleteTransfer();
                            await showDialog<void>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Xóa thành công!'),
                                content: const Text('Dữ liệu đã được xóa khỏi hệ thống.'),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () => Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (_) => const StopList()),
                                    ),
                                    child: const Text('Đóng'),
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
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.delete, color: Colors.white, size: 18),
                            SizedBox(width: 6),
                            Text('Xóa', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14, fontFamily: 'Inter')),
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