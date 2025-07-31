import 'package:flutter/material.dart';
import 'package:giao_dien_1/view/auth/login_screen.dart';
import 'package:giao_dien_1/widget/orange_button_1.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:giao_dien_1/widget/input_field.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:giao_dien_1/view/auth/phone_number_input.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:giao_dien_1/config/config.dart';
import 'package:giao_dien_1/config/default.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  _RegisterState createState() => _RegisterState();
}

Future<bool> registerCustomer(Map<String, String> customerData) async {
  final url = Uri.parse('$baseURL/insert-khachhang');

  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(customerData),
  );

  final body = jsonDecode(response.body);
  return body['success'] ?? false;
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();

  DateTime? _selectedDate;
  bool _obscurePassword = true;

  final TextEditingController _nameController = TextEditingController();
  String? _nameError;

  final TextEditingController _dobController = TextEditingController();
  String? _dobError;

  final TextEditingController _addressController = TextEditingController();
  String? _addressError;

  final TextEditingController _emailController = TextEditingController();
  String? _emailError;

  final TextEditingController _usernameController = TextEditingController();
  String? _usernameError;

  final TextEditingController _passwordController = TextEditingController();
  final bool _obscurePassword1 = true;
  String? _passwordError;

  final TextEditingController _confirmPasswordController =
      TextEditingController();
  String? _confirmPasswordError;

  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  String? _imageUrlError;

  String _phone = '';

  Future<void> _loadPhoneNumber() async {
    final prefs = await SharedPreferences.getInstance();
    final savedPhone = prefs.getString('phone');

    if (mounted) {
      setState(() {
        _phone = savedPhone ?? '';
      });
    }
  }

  @override
  void dispose() {
    _dobController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadPhoneNumber();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        _imageUrlError = null;
      });
    }
  }

Future<void> _submitData() async {
  var uri = Uri.parse('$baseURL/insert-khachhang');
  var request = http.MultipartRequest('POST', uri);

  request.fields['HoVaTen'] = _nameController.text.trim();
  request.fields['NgaySinh'] = _dobController.text.trim();
  request.fields['DiaChi'] = _addressController.text.trim();
  request.fields['Email'] = _emailController.text.trim();
  request.fields['SDT'] = _phone;
  request.fields['Password'] = _passwordController.text;
  request.fields['TenDangNhapKH'] = _usernameController.text.trim(); 

  if (_selectedImage != null) {
    var imageFile = File(_selectedImage!.path);
    var stream = http.ByteStream(imageFile.openRead());
    var length = await imageFile.length();
    var multipartFile = http.MultipartFile(
      'profileImage',
      stream,
      length,
      filename: path.basename(imageFile.path),
    );
    request.files.add(multipartFile);
  }

  print("🟡 Gửi request insert khách hàng");
  var response = await request.send();
  final res = await http.Response.fromStream(response);
  print('Raw Response Body: ${res.body}');
  final responseData = jsonDecode(res.body);

  print('Server Response (KHACHHANG): $responseData');

  if (responseData['success'] == true && responseData['MaKH'] != null) {
    print("🟢 Gửi request insert tài khoản");
    // Now create TAIKHOANKH
    final maKH = responseData['MaKH'];
    final accountRes = await http.post(
      Uri.parse('$baseURL/insert-taikhoankh'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'TenDangNhapKH': _usernameController.text.trim(),
        'Password': _passwordController.text.trim(),
        'MaKH': maKH,
      }),
    );
    final avatarUrl = responseData['avatarUrl'];
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('avatarUrl', avatarUrl);
    print('🔵 Đã lưu avatarUrl vào SharedPreferences: $avatarUrl'); 
      try {
    final accResponseBody = jsonDecode(accountRes.body);
    print('✅ TAIKHOANKH Insert Response: $accResponseBody');
  } catch (e, stackTrace) {
    print('❌ Lỗi khi decode JSON từ accountRes.body: $e');
    print('🔍 StackTrace: $stackTrace');
  }
  } else {
    print('Failed to register KHACHHANG');
  }
}


  void handleContinue() async {
    final isNameValid =
        _nameError == null && _nameController.text.trim().isNotEmpty;
    final isEmailValid =
        _emailError == null && _emailController.text.isNotEmpty;
    final isAddressValid =
        _addressError == null && _addressController.text.isNotEmpty;
    final isUsernameValid =
        _usernameError == null && _usernameController.text.isNotEmpty;
    final isPasswordValid =
        _passwordError == null && _passwordController.text.isNotEmpty;
    final isConfirmPasswordValid =
        _confirmPasswordError == null &&
        _confirmPasswordController.text.isNotEmpty;
    final isDobFilled = _dobController.text.isNotEmpty;
    final isImageSelected = _selectedImage != null;

    if (isNameValid &&
        isEmailValid &&
        isAddressValid &&
        isUsernameValid &&
        isPasswordValid &&
        isConfirmPasswordValid &&
        isDobFilled &&
        isImageSelected) {
      await _submitData();

      if (!context.mounted) return; // <--- THIS FIXES THE ISSUE
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    } else {
      setState(() {
        if (_nameController.text.isEmpty) _nameError ??= 'Vui lòng nhập họ tên';
        if (_emailController.text.isEmpty)
          _emailError ??= 'Vui lòng nhập email';
        if (_addressController.text.isEmpty)
          _addressError ??= 'Vui lòng nhập nơi ở';
        if (_usernameController.text.isEmpty)
          _usernameError ??= 'Vui lòng nhập username';
        if (_passwordController.text.isEmpty)
          _passwordError ??= 'Vui lòng nhập mật khẩu';
        if (_confirmPasswordController.text.isEmpty) {
          _confirmPasswordError ??= 'Vui lòng nhập lại mật khẩu';
        } else if (_confirmPasswordController.text !=
            _passwordController.text) {
          _confirmPasswordError = 'Mật khẩu không khớp';
        }
        if (_selectedImage == null) _imageUrlError ??= 'Vui lòng chọn hình ảnh';
        if (_dobController.text.isEmpty)
          _dobError ??= 'Vui lòng chọn ngày sinh';
      });
    }
  }

  String formatDate(DateTime date) {
    String day = date.day.toString().padLeft(2, '0');
    String month = date.month.toString().padLeft(2, '0');
    String year = date.year.toString();
    return '$day/$month/$year';
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime(2000, 1, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      helpText: 'Chọn ngày sinh',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFFF5722),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: Color(0xFFFF5722)),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dobController.text = formatDate(picked);
        _dobError = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 10.0,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    'ĐĂNG KÝ TÀI KHOẢN',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFF5722),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Vui lòng điền đầy đủ thông tin bên dưới',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Align(
                    alignment: Alignment.center,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center, // Giữa theo chiều ngang
                      children: [
                        const Text(
                          "Ảnh đại diện",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Khung chọn ảnh
                        GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.mainOrange),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: _selectedImage != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.file(
                                      _selectedImage!,
                                      fit: BoxFit.cover,
                                      width: 120,
                                      height: 120,
                                    ),
                                  )
                                : const Icon(
                                    Icons.add_a_photo,
                                    size: 40,
                                  ),
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Ghi chú bên dưới khung ảnh
                        Text(
                          _selectedImage != null
                              ? 'Đã chọn hình ảnh'
                              : 'Chọn một hình ảnh từ thiết bị',
                          style: const TextStyle(fontSize: 14),
                          textAlign: TextAlign.center,
                        ),

                        // Hiển thị lỗi nếu có
                        if (_imageUrlError != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                              _imageUrlError!,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),

                        const SizedBox(height: 16),
                      ],
                    ),
                  ),

                  CustomInputField(
                    controller: _nameController,
                    labelText: "Họ tên",
                    prefixIcon: Icons.person,
                    errorText: _nameError,
                    keyboardType: TextInputType.text,
                    onChanged: (value) {
                      _nameError =
                          value.trim().isEmpty ? 'Vui lòng nhập họ tên' : null;
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _dobController,
                    readOnly: true,
                    onTap: () => _selectDate(context),
                    decoration: InputDecoration(
                      labelText: "Ngày sinh",
                      labelStyle: const TextStyle(fontFamily: 'Inter'),
                      hintText: "dd/mm/yyyy",
                      errorText: _dobError,
                      prefixIcon: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Icon(Icons.calendar_today),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFFF5722)),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFFFF5722),
                          width: 2.0,
                        ),
                      ),
                      errorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFFF5722)),
                      ),
                      focusedErrorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFFFF5722),
                          width: 2.0,
                        ),
                      ),
                      hintStyle: TextStyle(color: Colors.grey.withOpacity(0.5)),
                      floatingLabelStyle: const TextStyle(color: Colors.black),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 16.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  CustomInputField(
                    controller: _addressController,
                    labelText: "Nơi ở",
                    hintText: "Số nhà, tên đường, phường, tỉnh/ thành",
                    prefixIcon: Icons.location_on,
                    errorText: _addressError,
                    onChanged: (value) {
                      _addressError =
                          value.trim().isEmpty ? 'Vui lòng nhập nơi ở' : null;
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomInputField(
                    controller: _emailController,
                    labelText: "Email",
                    prefixIcon: Icons.email,
                    errorText: _emailError,
                    keyboardType: TextInputType.emailAddress,
                    hintText: "example@gmail.com",
                    onChanged: (value) {
                      final emailPattern = RegExp(
                        r'^[a-zA-Z0-9._%+-]+@gmail\.com$',
                      );
                      _emailError =
                          value.isEmpty || emailPattern.hasMatch(value)
                              ? null
                              : 'Email phải có định dạng hợp lệ và kết thúc bằng @gmail.com';
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomInputField(
                    controller: _usernameController,
                    labelText: "Tên đăng nhập",
                    prefixIcon: Icons.person,
                    errorText: _usernameError,
                    keyboardType: TextInputType.text,
                    onChanged: (value) {
                      final usernamePattern = RegExp(r'^[a-zA-Z0-9]{8,}$');
                      _usernameError =
                          usernamePattern.hasMatch(value)
                              ? null
                              : 'Username phải ít nhất 8 ký tự, không chứa ký tự đặc biệt';
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomInputField(
                    controller: _passwordController,
                    labelText: "Mật khẩu",
                    prefixIcon: Icons.lock,
                    obscureText: _obscurePassword,
                    showToggleVisibility: true,
                    onToggleObscureText: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                    keyboardType: TextInputType.visiblePassword,
                    errorText: _passwordError,
                    onChanged: (value) {
                      _passwordError =
                          value.length >= 8
                              ? null
                              : 'Mật khẩu phải có ít nhất 8 ký tự';
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomInputField(
                    controller: _confirmPasswordController,
                    labelText: "Nhập lại mật khẩu",
                    prefixIcon: Icons.lock,
                    obscureText: _obscurePassword,
                    showToggleVisibility: true,
                    onToggleObscureText: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                    keyboardType: TextInputType.visiblePassword,
                    errorText: _confirmPasswordError,
                    onChanged: (value) {
                      _confirmPasswordError =
                          value != _passwordController.text
                              ? 'Mật khẩu không khớp'
                              : null;
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: 16),

                  // IMAGE PICKER REPLACEMENT END
                  const SizedBox(height: 32),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text.rich(
                            TextSpan(
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontFamily: 'Inter',
                                letterSpacing: 0.5,
                                height: 1.5,
                              ),
                              children: const [
                                TextSpan(text: "Nhấn nút "),
                                TextSpan(
                                  text: "Đăng ký tài khoản",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Inter',
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      " bên dưới, bạn đã hoàn thành quy trình kích hoạt tài khoản mới. Tài khoản này có thể được sử dụng trên cả web xe khách của chúng tôi.",
                                ),
                              ],
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  OrangeButton1(
                    text: 'Đăng ký tài khoản',
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        handleContinue();
                      }
                    },
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
