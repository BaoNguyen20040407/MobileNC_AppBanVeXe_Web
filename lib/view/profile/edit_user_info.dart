import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:giao_dien_1/config/default.dart';
import 'package:giao_dien_1/view/profile/edit_success.dart';
import 'package:giao_dien_1/widget/appbar_profile.dart';

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
  String _avatarUrl = '';

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
      _avatarUrl = prefs.getString('avatar_url') ?? '';
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
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const EditSuccessScreen()),
      ).then((_) {
        Navigator.pop(context);
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.tryParse(_dobController.text) ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.mainOrange,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: AppColors.mainOrange),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _dobController.text =
            "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFFFFF3E0),
      appBar: const AppBarProfile(title: 'SỬA THÔNG TIN TÀI KHOẢN'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 16),
              Stack(
                children: [
                  CircleAvatar(
                    radius: 48,
                    backgroundImage: _avatarUrl.isNotEmpty
                        ? NetworkImage(_avatarUrl)
                        : const AssetImage('assets/image/personicon.png') as ImageProvider,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(color: AppColors.grey400, blurRadius: 4),
                          ],
                        ),
                        padding: const EdgeInsets.all(6),
                        child: const Icon(Icons.camera_alt, size: 20, color: AppColors.black),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              _buildSection(
                title: 'THÔNG TIN CHÍNH',
                children: [
                  _buildTextField("UserName", _usernameController, prefixIcon: Icons.person),
                  const SizedBox(height: 16),
                  _buildTextField("Số điện thoại", _phoneController, prefixIcon: Icons.phone),
                ],
              ),
              _buildSection(
                title: 'THÔNG TIN CƠ BẢN',
                children: [
                  _buildTextField("Họ tên", _fullNameController, prefixIcon: Icons.badge),
                  const SizedBox(height: 16),
                  _buildTextField("Ngày sinh", _dobController,
                      prefixIcon: Icons.calendar_today,
                      readOnly: true,
                      onTap: () => _selectDate(context)),
                  const SizedBox(height: 16),
                  _buildTextField("Địa chỉ thường trú", _addressController, prefixIcon: Icons.home),
                  const SizedBox(height: 16),
                  _buildTextField("Email", _emailController, prefixIcon: Icons.email),
                ],
              ),
              _buildSection(
                title: 'THÔNG TIN THÊM',
                children: [
                  _buildOptionalDropdown(
                    label: "Giới tính",
                    items: _genderOptions,
                    value: _gender,
                    prefixIcon: Icons.wc,
                    onChanged: (val) {
                      setState(() => _gender = val);
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildOptionalDropdown(
                    label: "Nghề nghiệp",
                    items: _jobOptions,
                    value: _job,
                    prefixIcon: Icons.work,
                    onChanged: (val) {
                      setState(() => _job = val);
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildOptionalTextField("Giới thiệu về bản thân", _introController,
                      prefixIcon: Icons.info, maxLines: 3),
                ],
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.mainOrange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
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
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Inter'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.greenDark,
              fontWeight: FontWeight.bold,
              fontSize: 17,
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
    IconData? prefixIcon,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        readOnly: readOnly,
        onTap: onTap,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          hoverColor: Colors.transparent,
          fillColor: Colors.white,
          floatingLabelStyle: const TextStyle(color: AppColors.black),
          prefixIcon: prefixIcon != null
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Icon(prefixIcon),
                )
              : null,
          prefixIconConstraints: const BoxConstraints(minWidth: 48, minHeight: 48),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.mainOrange),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.mainOrange, width: 2.0),
          ),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.mainOrange),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.mainOrange, width: 2.0),
          ),
        ),
        validator: (value) => value == null || value.isEmpty ? 'Không được để trống' : null,
      ),
    );
  }

  Widget _buildOptionalTextField(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
    IconData? prefixIcon,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        readOnly: readOnly,
        onTap: onTap,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          hoverColor: Colors.transparent,
          fillColor: Colors.white,
          floatingLabelStyle: const TextStyle(color: AppColors.black),
          prefixIcon: prefixIcon != null
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Icon(prefixIcon),
                )
              : null,
          prefixIconConstraints: const BoxConstraints(minWidth: 48, minHeight: 48),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.mainOrange),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.mainOrange, width: 2.0),
          ),
        ),
      ),
    );
  }

  Widget _buildOptionalDropdown({
    required String label,
    required List<String> items,
    required String? value,
    required void Function(String?) onChanged,
    IconData? prefixIcon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        value: value,
        isExpanded: true,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          hoverColor: Colors.transparent,
          labelStyle: const TextStyle(color: AppColors.black),
          prefixIcon: prefixIcon != null
              ? Icon(prefixIcon, color: AppColors.black)
              : null,
          prefixIconConstraints: const BoxConstraints(minWidth: 48),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: AppColors.mainOrange),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: AppColors.mainOrange),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: AppColors.mainOrange, width: 2),
          ),
        ),
        icon: const Icon(Icons.arrow_drop_down, color: AppColors.mainOrange),
        dropdownColor: Colors.white,
        style: const TextStyle(color: Colors.black, fontSize: 16),
        items: items
            .map((item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                ))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}