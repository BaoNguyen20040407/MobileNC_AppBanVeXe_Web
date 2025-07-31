import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:giao_dien_1/config/config.dart';
import 'package:giao_dien_1/config/default.dart';
import 'package:giao_dien_1/widget/appbar_admin.dart';
import 'package:giao_dien_1/widget/exit_button.dart';
import 'package:giao_dien_1/widget/input_field.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:giao_dien_1/view/admin/customer_admin/add_customer_success.dart';
import 'package:giao_dien_1/widget/create_button.dart';
import 'package:http/http.dart' as http;
import 'package:giao_dien_1/widget/image_picker_field.dart';

class AddCustomerScreen extends StatefulWidget {
  const AddCustomerScreen({super.key});

  @override
  State<AddCustomerScreen> createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends State<AddCustomerScreen> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  File? _selectedImage;
  String? _imageUrlError;

  void _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _dobController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
        _imageUrlError = null;
      });
    }
  }

  void _handleSubmit() async {
  if (_selectedImage == null) {
    setState(() => _imageUrlError = 'Vui lòng chọn ảnh đại diện.');
    print('⚠️ Chưa chọn ảnh đại diện.');
    return;
  }

  final bytes = await _selectedImage!.readAsBytes();
  final base64Image = base64Encode(bytes);

  final customerData = {
    'MaKH': _idController.text.trim(),
    'HoVaTen': _nameController.text.trim(),
    'NgaySinh': _dobController.text.trim(),
    'DiaChi': _addressController.text.trim(),
    'Email': _emailController.text.trim(),
    'SDT': _phoneController.text.trim(),
    'URLHinhAnh': base64Image,
  };

  print('📤 Dữ liệu chuẩn bị gửi lên:');
  print(jsonEncode(customerData));

  final url = Uri.parse('$baseURL/add-khachhang');
  print('🌐 Gửi POST đến URL: $url');

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(customerData),
    );

    print('📥 Status code: ${response.statusCode}');
    print('📥 Response body: ${response.body}');

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['success'] == true) {
        print('✅ Thêm khách hàng thành công.');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddCustomerSuccess()),
        );
      } else {
        print('❌ Server trả về lỗi logic: ${jsonResponse['message']}');
        _showErrorDialog(jsonResponse['message']);
      }
    } else {
      print('❌ Server trả về lỗi mã: ${response.statusCode}');
      _showErrorDialog('Thêm khách hàng thất bại (mã: ${response.statusCode})');
    }
  } catch (e) {
    print("❌ Exception: $e");
    _showErrorDialog("Lỗi khi kết nối đến server: $e");
  }
}


  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Lỗi"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
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
                  'THÊM KHÁCH HÀNG',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
              const SizedBox(height: 32),

              ImagePickerField(
                selectedImage: _selectedImage,
                onPick: _pickImage,
                errorText: _imageUrlError,
              ),
              const SizedBox(height: 32,),
              CustomInputField(
                controller: _idController,
                labelText: "Mã khách hàng",
                prefixIcon: Icons.perm_identity,
                keyboardType: TextInputType.text,
                showToggleVisibility: false,
              ),
              const SizedBox(height: 16),

              CustomInputField(
                controller: _nameController,
                labelText: "Họ và tên",
                prefixIcon: Icons.person,
                keyboardType: TextInputType.name,
                showToggleVisibility: false,
              ),
              const SizedBox(height: 16),

              CustomInputField(
                controller: _dobController,
                labelText: "Ngày sinh",
                prefixIcon: Icons.cake,
                keyboardType: TextInputType.datetime,
                showToggleVisibility: false,
                readOnly: true,
                onTap: _selectDate,
              ),
              const SizedBox(height: 16),

              CustomInputField(
                controller: _addressController,
                labelText: "Địa chỉ",
                prefixIcon: Icons.location_on,
                keyboardType: TextInputType.text,
                showToggleVisibility: false,
              ),
              const SizedBox(height: 16),

              CustomInputField(
                controller: _emailController,
                labelText: "Email",
                prefixIcon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                showToggleVisibility: false,
              ),
              const SizedBox(height: 16),

              CustomInputField(
                controller: _phoneController,
                labelText: "Số điện thoại",
                prefixIcon: Icons.phone,
                keyboardType: TextInputType.phone,
                showToggleVisibility: false,
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(child: CreateButton(onPressed: _handleSubmit)),
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
