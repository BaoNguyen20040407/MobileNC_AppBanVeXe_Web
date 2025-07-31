import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:giao_dien_1/config/config.dart';
import 'package:http/http.dart' as http;
import 'package:giao_dien_1/config/default.dart';
import 'package:giao_dien_1/widget/appbar_admin.dart';
import 'package:giao_dien_1/widget/exit_button.dart';
import 'package:giao_dien_1/widget/input_field.dart';
import 'package:giao_dien_1/view/admin/account/account_admin/add_account_admin_success.dart';
import 'package:giao_dien_1/widget/create_button.dart';
import 'package:giao_dien_1/widget/dropdown_field.dart';

class AddEmployeeAccountScreen extends StatefulWidget {
  const AddEmployeeAccountScreen({super.key});

  @override
  State<AddEmployeeAccountScreen> createState() => _AddEmployeeAccountScreenState();
}

class _AddEmployeeAccountScreenState extends State<AddEmployeeAccountScreen> {
  final TextEditingController _idController = TextEditingController(); // MaTK
  final TextEditingController _usernameController = TextEditingController(); // TenDangNhapNV
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _employeeIdController = TextEditingController(); // MaNV

  bool _isLoading = false;

    void _handleSubmit() async {
    final maTK = _idController.text.trim();
    final tenDangNhapNV = _usernameController.text.trim();
    final password = _passwordController.text;
    final maNV = selectedMaNV?.trim() ?? '';
    if (maNV.isEmpty) {
      _showErrorDialog('Vui lòng chọn mã nhân viên');
      return;
    }

    final url = Uri.parse('$baseURL/taikhoannv');

    print('Đang gửi dữ liệu đến backend...');
    print({
      'MaTK': maTK,
      'TenDangNhapNV': tenDangNhapNV,
      'Password': password,
      'MaNV': maNV,
    });
    

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'MaTK': maTK,
          'TenDangNhapNV': tenDangNhapNV,
          'Password': password,
          'MaNV': maNV,
        }),
      );

      print('Trạng thái phản hồi: ${response.statusCode}');
      print('Nội dung phản hồi: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddAccountAdminSuccess(),
            ),
          );
        } else {
          _showErrorDialog('Thêm tài khoản thất bại: ${data['message']}');
        }
      } else {
        _showErrorDialog('Lỗi máy chủ: ${response.statusCode}');
      }
    } catch (e) {
      _showErrorDialog('Không thể kết nối đến máy chủ. Chi tiết: $e');
    }
  }

  List<String> maNVList = [];
  String? selectedMaNV;

Future<void> fetchMaNVList() async {
  try {
    final response = await http.get(Uri.parse('$baseURL/nhanvien'));

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);

      final List<dynamic> data =
          body is List ? body : body['data']; // ✅ kiểm tra kiểu

      setState(() {
        maNVList = data.map<String>((item) => item['MaNV'].toString()).toList();
      });
    } else {
      _showErrorDialog('Không thể tải danh sách nhân viên');
    }
  } catch (e) {
    _showErrorDialog('Lỗi kết nối: $e');
  }
}

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Lỗi'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchMaNVList();
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'THÊM TÀI KHOẢN NHÂN VIÊN',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
              const SizedBox(height: 32),

              CustomInputField(
                controller: _idController,
                labelText: "Mã tài khoản",
                prefixIcon: Icons.vpn_key,
                keyboardType: TextInputType.text,
                showToggleVisibility: false,
              ),
              const SizedBox(height: 16),

              CustomInputField(
                controller: _usernameController,
                labelText: "Tên đăng nhập",
                prefixIcon: Icons.person,
                keyboardType: TextInputType.text,
                showToggleVisibility: false,
              ),
              const SizedBox(height: 16),

              CustomInputField(
                controller: _passwordController,
                labelText: "Mật khẩu",
                prefixIcon: Icons.lock,
                keyboardType: TextInputType.visiblePassword,
                showToggleVisibility: true,
              ),
              const SizedBox(height: 16),

              CustomDropdownField(
                value: selectedMaNV,
                items: maNVList,
                labelText: "Mã nhân viên",
                prefixIcon: Icons.perm_identity,
                onChanged: (newValue) {
                  setState(() {
                    selectedMaNV = newValue;
                  });
                },
              ),
              const SizedBox(height: 32),

              Row(
                children: [
                  Expanded(
                    child: _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : CreateButton(onPressed: _handleSubmit),
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
