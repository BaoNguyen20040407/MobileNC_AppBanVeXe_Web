import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:giao_dien_1/config/config.dart';
import 'package:giao_dien_1/config/default.dart';
import 'package:giao_dien_1/widget/appbar_admin.dart';
import 'package:giao_dien_1/widget/input_field.dart';
import 'package:giao_dien_1/widget/edit_action_button.dart';
import 'package:giao_dien_1/view/admin/ticket_admin/ticket_list.dart';

class EditTicket extends StatefulWidget {
  final Map<String, dynamic> ticket;
  const EditTicket({super.key, required this.ticket});

  @override
  State<EditTicket> createState() => _EditTicketState();
}

class _EditTicketState extends State<EditTicket> {
  late TextEditingController _maVeController;
  late TextEditingController _loaiVeController;
  late TextEditingController _viTriGheController;
  late TextEditingController _giaVeController;
  late TextEditingController _trangThaiController;
  late TextEditingController _hinhThucThanhToanController;
  late TextEditingController _maCXController;
  late TextEditingController _maKHController;

  @override
  void initState() {
    super.initState();
    _maVeController = TextEditingController(text: widget.ticket['MaVe'] ?? '');
    _loaiVeController = TextEditingController(text: widget.ticket['LoaiVe'] ?? '');
    _viTriGheController = TextEditingController(text: widget.ticket['ViTriGheNgoi'] ?? '');
    _giaVeController = TextEditingController(text: widget.ticket['GiaVe']?.toString() ?? '');
    _trangThaiController = TextEditingController(text: widget.ticket['TrangThai'] ?? '');
    _hinhThucThanhToanController = TextEditingController(text: widget.ticket['HinhThucThanhToan'] ?? '');
    _maCXController = TextEditingController(text: widget.ticket['MaCX'] ?? '');
    _maKHController = TextEditingController(text: widget.ticket['MaKH'] ?? '');
  }

  @override
  void dispose() {
    _maVeController.dispose();
    _loaiVeController.dispose();
    _viTriGheController.dispose();
    _giaVeController.dispose();
    _trangThaiController.dispose();
    _hinhThucThanhToanController.dispose();
    _maCXController.dispose();
    _maKHController.dispose();
    super.dispose();
  }

  Future<void> updateTicket() async {
    final maVe = _maVeController.text;

    final response = await http.put(
      Uri.parse('$baseURL/ve/$maVe'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'LoaiVe': _loaiVeController.text,
        'ViTriGheNgoi': _viTriGheController.text,
        'GiaVe': double.tryParse(_giaVeController.text) ?? 0,
        'TrangThai': _trangThaiController.text,
        'HinhThucThanhToan': _hinhThucThanhToanController.text,
        'MaCX': _maCXController.text,
        'MaKH': _maKHController.text,
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Cập nhật vé thành công")),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const TicketListScreen()),
      );
    } else {
      print('Lỗi cập nhật: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBarAdmin(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text(
              'CHỈNH SỬA VÉ',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.mainOrange,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 32),

            CustomInputField(
              controller: _maVeController,
              labelText: "Mã vé",
              prefixIcon: Icons.confirmation_number,
              keyboardType: TextInputType.text,
              showToggleVisibility: false,
              readOnly: true, // không sửa Mã vé
            ),
            const SizedBox(height: 16),

            CustomInputField(
              controller: _loaiVeController,
              labelText: "Loại vé",
              prefixIcon: Icons.category,
              keyboardType: TextInputType.text,
              showToggleVisibility: false,
            ),
            const SizedBox(height: 16),

            CustomInputField(
              controller: _viTriGheController,
              labelText: "Vị trí ghế",
              prefixIcon: Icons.event_seat,
              keyboardType: TextInputType.text,
              showToggleVisibility: false,
            ),
            const SizedBox(height: 16),

            CustomInputField(
              controller: _giaVeController,
              labelText: "Giá vé",
              prefixIcon: Icons.attach_money,
              keyboardType: TextInputType.number,
              showToggleVisibility: false,
            ),
            const SizedBox(height: 16),

            CustomInputField(
              controller: _trangThaiController,
              labelText: "Trạng thái",
              prefixIcon: Icons.info_outline,
              keyboardType: TextInputType.text,
              showToggleVisibility: false,
            ),
            const SizedBox(height: 16),

            CustomInputField(
              controller: _hinhThucThanhToanController,
              labelText: "Hình thức thanh toán",
              prefixIcon: Icons.payment,
              keyboardType: TextInputType.text,
              showToggleVisibility: false,
            ),
            const SizedBox(height: 16),

            CustomInputField(
              controller: _maCXController,
              labelText: "Mã chuyến xe",
              prefixIcon: Icons.directions_bus,
              keyboardType: TextInputType.text,
              showToggleVisibility: false,
            ),
            const SizedBox(height: 16),

            CustomInputField(
              controller: _maKHController,
              labelText: "Mã khách hàng",
              prefixIcon: Icons.person,
              keyboardType: TextInputType.text,
              showToggleVisibility: false,
            ),

            const SizedBox(height: 32),

            SizedBox(
              height: 42,
              width: double.infinity,
              child: EditActionButton(onPressed: updateTicket),
            ),
          ],
        ),
      ),
    );
  }
}
