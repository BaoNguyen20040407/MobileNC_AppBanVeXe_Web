import 'package:flutter/material.dart';
import 'package:giao_dien_1/config/default.dart';
import 'package:giao_dien_1/widget/appbar_admin.dart';
import 'package:giao_dien_1/widget/exit_button.dart';
import 'package:giao_dien_1/widget/input_field.dart';
import 'package:giao_dien_1/widget/save_button.dart';
import 'package:giao_dien_1/view/admin/support_admin/reply_support_success.dart';
import 'package:giao_dien_1/config/config.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ReplySupportScreen extends StatefulWidget {
  final Map<String, dynamic> supportItem;

  const ReplySupportScreen({super.key, required this.supportItem});

  @override
  State<ReplySupportScreen> createState() => _ReplySupportScreenState();
}

class _ReplySupportScreenState extends State<ReplySupportScreen> {
  late TextEditingController _replyController;
  List<String> _staffList = [];
  String? _selectedStaffId;

  @override
  void initState() {
    super.initState();
    _replyController = TextEditingController(text: widget.supportItem['CauTraLoi'] ?? '');
    _loadStaffList();
  }

  Future<void> _loadStaffList() async {
    final url = Uri.parse('$baseURL/nhanvien');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _staffList = data.map((e) => e['MaNV'].toString()).toList();
          _selectedStaffId = widget.supportItem['MaNV'] ?? (_staffList.isNotEmpty ? _staffList.first : null);
        });
      } else {
        print('❌ Lỗi khi tải danh sách nhân viên: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Exception: $e');
    }
  }

  Future<void> _handleSave() async {
    final updatedReply = _replyController.text.trim();
    final maHT = widget.supportItem['MaHT'];

    if (updatedReply.isEmpty || _selectedStaffId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập phản hồi và chọn mã nhân viên')),
      );
      return;
    }

    final url = Uri.parse('$baseURL/hotro/$maHT/phanhoi');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'CauTraLoi': updatedReply,
        'MaNV': _selectedStaffId,
      }),
    );

    final json = jsonDecode(response.body);
    if (json['success'] == true) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const SupportAnswerSuccess()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(json['message'] ?? 'Phản hồi thất bại')),
      );
    }
  }

  Widget _buildReadOnlyInput(String label, String? value, IconData icon) {
    return CustomInputField(
      controller: TextEditingController(text: value ?? ''),
      labelText: label,
      prefixIcon: icon,
      keyboardType: TextInputType.text,
      readOnly: true,
      showToggleVisibility: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.supportItem;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const CustomAppBarAdmin(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'PHẢN HỒI HỖ TRỢ',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.mainOrange,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
              const SizedBox(height: 32),

              _buildReadOnlyInput('Mã hỗ trợ', data['MaHT'], Icons.confirmation_number),
              const SizedBox(height: 16),

              _buildReadOnlyInput('Tiêu đề', data['TieuDe'], Icons.title),
              const SizedBox(height: 16),

              _buildReadOnlyInput('Câu hỏi', data['CauHoi'], Icons.question_answer),
              const SizedBox(height: 16),

              _buildReadOnlyInput('Mã khách hàng', data['MaKH'], Icons.person),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _selectedStaffId,
                items: _staffList.map((id) {
                  return DropdownMenuItem(
                    value: id,
                    child: Text(
                      id,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 15,
                        color: AppColors.black,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedStaffId = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Chọn mã nhân viên',
                  labelStyle: const TextStyle(
                    fontFamily: 'Inter',
                    color: AppColors.black,
                  ),
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(left: 16.0, right: 16.0),
                    child: Icon(Icons.badge),
                  ),
                  prefixIconConstraints: const BoxConstraints(
                    minWidth: 48,
                    minHeight: 48,
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.mainOrange),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.mainOrange, width: 2.0),
                  ),
                  errorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.red),
                  ),
                  focusedErrorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.red, width: 2.0),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 16.0,
                  ),
                ),
                dropdownColor: AppColors.white,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  color: AppColors.black,
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 16),

              CustomInputField(
                controller: _replyController,
                labelText: "Phản hồi",
                prefixIcon: Icons.reply,
                keyboardType: TextInputType.multiline,
                showToggleVisibility: false,
              ),
              const SizedBox(height: 32),

              Row(
                children: [
                  Expanded(
                    child: SaveButton(onPressed: _handleSave),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(child: ExitButton()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
