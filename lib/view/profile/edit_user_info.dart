import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:giao_dien_1/config/default.dart';
import 'package:giao_dien_1/view/profile/edit_success.dart';

class EditUserInfo extends StatefulWidget {
  const EditUserInfo({super.key});

  @override
  State<EditUserInfo> createState() => _EditUserInfoState();
}

class _EditUserInfoState extends State<EditUserInfo> {
  final _formKey = GlobalKey<FormState>();
  late SharedPreferences prefs;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _introController = TextEditingController();

  String? _gender;
  String? _job;

  final List<String> _genderOptions = ['Nam', 'Nữ', 'Khác'];
  final List<String> _jobOptions = ['Sinh viên', 'Giáo viên', 'Khác'];

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      _usernameController.text = prefs.getString('username') ?? '';
      _phoneController.text = prefs.getString('phone') ?? '';
      _fullNameController.text = prefs.getString('full_name') ?? '';
      _dobController.text = prefs.getString('dob') ?? '';
      _addressController.text = prefs.getString('address') ?? '';
      _emailController.text = prefs.getString('email') ?? '';
      _introController.text = prefs.getString('intro') ?? '';
      _gender = _genderOptions.contains(prefs.getString('gender')) ? prefs.getString('gender') : null;
      _job = _jobOptions.contains(prefs.getString('job')) ? prefs.getString('job') : null;
    });
  }

  Future<void> _saveUserInfo() async {
    await prefs.setString('username', _usernameController.text);
    await prefs.setString('phone', _phoneController.text);
    await prefs.setString('full_name', _fullNameController.text);
    await prefs.setString('dob', _dobController.text);
    await prefs.setString('address', _addressController.text);
    await prefs.setString('email', _emailController.text);
    await prefs.setString('gender', _gender ?? '');
    await prefs.setString('job', _job ?? '');
    await prefs.setString('intro', _introController.text);

    if (context.mounted) {
      Navigator.push(context, 
      MaterialPageRoute(builder: (context) => const EditSuccessScreen()),
      ).then((_) {
        Navigator.pop(context); // Quay lại trang xem thông tin
      });    
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E0),
      appBar: AppBar(
        title: const Text("SỬA THÔNG TIN TÀI KHOẢN"),
        backgroundColor: AppColors.mainOrange,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField("UserName", _usernameController),
              _buildTextField("Số điện thoại", _phoneController),
              const SizedBox(height: 16),
              _buildTextField("Họ tên", _fullNameController),
              _buildTextField("Ngày sinh", _dobController),
              _buildTextField("Địa chỉ thường trú", _addressController),
              _buildTextField("Email", _emailController),
              const SizedBox(height: 16),
              _buildDropdown("Giới tính", _genderOptions, _gender, (val) {
                setState(() {
                  _gender = val;
                });
              }),
              _buildDropdown("Nghề nghiệp", _jobOptions, _job, (val) {
                setState(() {
                  _job = val;
                });
              }),
              _buildTextField("Giới thiệu về bản thân", _introController, maxLines: 3),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.mainOrange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _saveUserInfo();
                  }
                },
                child: const Text(
                  'Lưu thông tin tài khoản',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        validator: (value) => value == null || value.isEmpty ? 'Không được để trống' : null,
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> items, String? value, Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        value: items.contains(value) ? value : null,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        onChanged: onChanged,
        validator: (value) => value == null || value.isEmpty ? 'Vui lòng chọn $label' : null,
      ),
    );
  }
}
