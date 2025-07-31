import 'package:flutter/material.dart';
import 'package:giao_dien_1/config/default.dart';
import 'package:giao_dien_1/widget/appbar_admin.dart';
import 'package:giao_dien_1/widget/exit_button.dart';
import 'package:giao_dien_1/widget/input_field.dart';
import 'package:giao_dien_1/view/admin/account/account_user/add_account_user_success.dart';
import 'package:giao_dien_1/widget/create_button.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:giao_dien_1/config/config.dart';
import 'package:giao_dien_1/widget/dropdown_field.dart';

class AddCustomerAccountScreen extends StatefulWidget {
  const AddCustomerAccountScreen({super.key});

  @override
  State<AddCustomerAccountScreen> createState() =>
      _AddCustomerAccountScreenState();
}

class _AddCustomerAccountScreenState extends State<AddCustomerAccountScreen> {
  final TextEditingController _idController = TextEditingController(); // MaTK
  final TextEditingController _usernameController = TextEditingController(); // TenDangNhapKH
  final TextEditingController _passwordController = TextEditingController(); // Password
  final TextEditingController _customerIdController = TextEditingController(); // MaKH

  void _handleSubmit() async {
    final maTK = _idController.text.trim();
    final tenDangNhapKH = _usernameController.text.trim();
    final password = _passwordController.text;
    final maKH = selectedMaKH?.trim() ?? '';
    if (maKH.isEmpty) {
      _showErrorDialog('Vui lòng chọn mã khách hàng');
      return;
    }

    final url = Uri.parse('$baseURL/add-taikhoankh');

    print('Đang gửi dữ liệu đến backend...');
    print({
      'MaTK': maTK,
      'TenDangNhapKH': tenDangNhapKH,
      'Password': password,
      'MaKH': maKH,
    });
    

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'MaTK': maTK,
          'TenDangNhapKH': tenDangNhapKH,
          'Password': password,
          'MaKH': maKH,
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
              builder: (context) => const AddAccountUserSuccess(),
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

  List<String> maKHList = [];
  String? selectedMaKH;

  Future<void> fetchMaKHList() async {
  try {
    final response = await http.get(Uri.parse('$baseURL/khachhang'));

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);

      final List<dynamic> data =
          body is List ? body : body['data']; // ✅ kiểm tra kiểu

      setState(() {
        maKHList = data.map<String>((item) => item['MaKH'].toString()).toList();
      });
    } else {
      _showErrorDialog('Không thể tải danh sách khách hàng');
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
    fetchMaKHList();
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
                  'THÊM TÀI KHOẢN KHÁCH HÀNG',
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
                value: selectedMaKH,
                items: maKHList,
                labelText: "Mã khách hàng",
                prefixIcon: Icons.perm_identity,
                onChanged: (newValue) {
                  setState(() {
                    selectedMaKH = newValue;
                  });
                },
              ),
              const SizedBox(height: 32),

              Row(
                children: [
                  Expanded(
                    child: CreateButton(onPressed: _handleSubmit),
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
