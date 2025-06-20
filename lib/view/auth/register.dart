import 'package:flutter/material.dart';
import 'package:giao_dien_1/view/auth/login_screen.dart';
import 'package:giao_dien_1/widget/orange_button_1.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:giao_dien_1/widget/input_field.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  DateTime? _selectedDate;
  bool _obscurePassword = true; 
  //Kiểm tra họ tên
  final TextEditingController _nameController = TextEditingController();
  String? _nameError; 

  //Kiểm tra ngày sinh
  final TextEditingController _dobController = TextEditingController();
  String? _dobError; 

  //Kiểm tra nơi ở
  final TextEditingController _addressController = TextEditingController();
  String? _addressError; 

  //Kiểm tra email
  final TextEditingController _emailController = TextEditingController();
  String? _emailError;

  //Kiểm tra username
  final TextEditingController _usernameController = TextEditingController();
  String? _usernameError;

  //Kiểm tra password
  final TextEditingController _passwordController = TextEditingController();
  final bool _obscurePassword1 = true;
  String? _passwordError;

  //Kiểm tra định dạng hình ảnh
  final TextEditingController _imageUrlController = TextEditingController();
  String? _imageUrlError;

  //Lưu số điện thoại
  String _phone = '';

  Future<void> _loadPhoneNumber() async {
    final pref = await SharedPreferences.getInstance();
    setState(() {
      _phone = pref.getString('phone_number') ?? '';
    });
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

  Future<void> _saveUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('full_name', _nameController.text.trim());
    await prefs.setString('dob', _dobController.text.trim());
    await prefs.setString('address', _addressController.text.trim());
    await prefs.setString('email', _emailController.text.trim());
    await prefs.setString('username', _usernameController.text.trim());
    await prefs.setString('password', _passwordController.text); 
    await prefs.setString('image_url', _imageUrlController.text.trim());
    await prefs.setString('phone', _phone);
  }

  void handleContinue() async {
  final isNameValid = _nameError == null && _nameController.text.trim().isNotEmpty;
  final isEmailValid = _emailError == null && _emailController.text.isNotEmpty;
  final isAddressVailid = _addressError == null && _addressController.text.isNotEmpty;
  final isUsernameValid = _usernameError == null && _usernameController.text.isNotEmpty;
  final isPasswordValid = _passwordError == null && _passwordController.text.isNotEmpty;
  final isDobFilled = _dobController.text.isNotEmpty;
  final isImageUrlValid = _imageUrlError == null && _imageUrlController.text.isNotEmpty;

  if (isNameValid &&
      isEmailValid &&
      isAddressVailid &&
      isUsernameValid &&
      isPasswordValid &&
      isDobFilled &&
      isImageUrlValid) {
        await _saveUserData();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  } else {
    setState(() {
      if (_nameController.text.isEmpty) _nameError ??= 'Vui lòng nhập họ tên';
      if (_emailController.text.isEmpty) _emailError ??= 'Vui lòng nhập email';
      if (_addressController.text.isEmpty) _addressError ??= 'Vui lòng nhập nơi ở';
      if (_usernameController.text.isEmpty) _usernameError ??= 'Vui lòng nhập username';
      if (_passwordController.text.isEmpty) _passwordError ??= 'Vui lòng nhập mật khẩu';
      if (_imageUrlController.text.isEmpty) _imageUrlError ??= 'Vui lòng nhập URL hình ảnh';
      if (_dobController.text.isEmpty) _dobError ??= 'Vui lòng chọn ngày sinh';
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
          colorScheme: ColorScheme.light(
            primary: Color(0xFFFF5722),
            onPrimary: Colors.white,
            onSurface: Colors.black,
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: Color(0xFFFF5722),
            ),
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
          padding:
              const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
              
              //Đăng ký tài khoản
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

              //Dòng thông báo
              const Text(
                'Vui lòng điền đầy đủ thông tin bên dưới',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 32),

              // Họ tên
              CustomInputField(
                controller: _nameController,
                labelText: "Họ tên",
                prefixIcon: Icons.person,
                errorText: _nameError,
                keyboardType: TextInputType.text,
                onChanged: (value) {
                  if (value.trim().isEmpty) {
                    _nameError = 'Vui lòng nhập họ tên';
                  } else {
                    _nameError = null;
                  }
                  setState(() {}); // Cập nhật lại UI
                },
              ),
              const SizedBox(height: 16),

              // Ngày sinh
              TextField(
                controller: _dobController,
                readOnly: true,
                onTap: () => _selectDate(context),
                decoration: InputDecoration(
                  labelText: "Ngày sinh", labelStyle: TextStyle(fontFamily: 'Inter'),
                  hintText: "dd/mm/yyyy",
                  errorText: _dobError,
                  errorStyle: const TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                    fontFamily: 'Inter',
                  ),
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(left: 16.0, right: 16.0),
                    child: Icon(Icons.calendar_today),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFFF5722)),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFFF5722), width: 2.0),
                  ),
                  errorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFFF5722)),
                  ),
                  focusedErrorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFFF5722), width: 2.0),
                  ),
                  hintStyle: TextStyle(
                    color: Colors.grey.withOpacity(0.5),
                  ),
                  floatingLabelStyle: const TextStyle(
                    color: Colors.black,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 16.0,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Nơi ở
              CustomInputField(
                controller: _addressController,
                labelText: "Nơi ở",
                hintText: "Số nhà, tên đường, phường, tỉnh/ thành",
                prefixIcon: Icons.location_on,
                errorText: _addressError,
                onChanged: (value) {
                  if (value.trim().isEmpty) {
                    _addressError = 'Vui lòng nhập nơi ở';
                  } else {
                    _addressError = null;
                  }
                  setState(() {});
                },
              ),
              const SizedBox(height: 16),

              // Email
              CustomInputField(
                controller: _emailController,
                labelText: "Email",
                prefixIcon: Icons.email,
                errorText: _emailError,
                keyboardType: TextInputType.emailAddress,
                hintText: "example@gmail.com",
                onChanged: (value) {
                  final emailPattern = RegExp(r'^[a-zA-Z0-9._%+-]+@gmail\.com$');
                  if (value.isEmpty || emailPattern.hasMatch(value)) {
                    _emailError = null;
                  } else {
                    _emailError = 'Email phải có định dạng hợp lệ và kết thúc bằng @gmail.com';
                  }
                  setState(() {});
                },
              ),
              const SizedBox(height: 16),

              // UserName
              CustomInputField(
                controller: _usernameController,
                labelText: "Tên đăng nhập",
                prefixIcon: Icons.person,
                errorText: _usernameError,
                keyboardType: TextInputType.text,
                onChanged: (value) {
                  final usernamePattern = RegExp(r'^[a-zA-Z0-9]{8,}$');
                  if (usernamePattern.hasMatch(value)) {
                    _usernameError = null;
                  } else {
                    _usernameError = 'Username phải ít nhất 8 ký tự, không chứa ký tự đặc biệt';
                  }
                  setState(() {});
                },
              ),
              const SizedBox(height: 16),

              // Mật khẩu
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
                  if (value.length >= 8) {
                    _passwordError = null;
                  } else {
                    _passwordError = 'Mật khẩu phải có ít nhất 8 ký tự';
                  }
                  setState(() {});
                },
              ),
              const SizedBox(height: 16),

              //Url Hình ảnh
              CustomInputField(
              controller: _imageUrlController,
              labelText: "URL hình ảnh",
              hintText: "Nhập URL hình ảnh (.jpg, .png, .jpeg, .gif)",
              prefixIcon: Icons.image,
              keyboardType: TextInputType.url,
              errorText: _imageUrlError,
              onChanged: (value) {
                final urlPattern = RegExp(
                  r'^(https?:\/\/.*\.(?:png|jpg|jpeg|gif))$', caseSensitive: false);
                if (value.isEmpty || urlPattern.hasMatch(value)) {
                  _imageUrlError = null;
                } else {
                  _imageUrlError = 'Vui lòng nhập URL ảnh hợp lệ (.jpg, .png, .jpeg, .gif)';
                }
                setState(() {});
              },
            ),
              const SizedBox(height: 32),

              // Hướng dẫn
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontFamily: 'Inter',
                          letterSpacing: 0.5,
                          height: 1.5,
                          ),
                        children: [
                          TextSpan(text: "Nhấn nút "),
                          TextSpan(
                            text: "Đăng ký tài khoản",
                            style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Inter', letterSpacing: 0.5),
                          ),
                        TextSpan(text: " bên dưới, bạn đã hoàn thành quy trình kích hoạt tài khoản mới. Tài khoản này có thể được sử dụng trên cả web xe khách của chúng tôi."),
                        ],
                      ),
                      textAlign: TextAlign.justify, // ✅ Canh đều
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),

              //Nút Đăng ký tài khoản
              OrangeButton1(
                text: 'Đăng ký tài khoản', 
                onPressed: handleContinue
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    ),
    ); 
  }
}